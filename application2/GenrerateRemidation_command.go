package application2

import (
	"context"
	"errors"
	"fmt"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/domain2/mistake"
	"time"
	"uuid"
)

type GraphMistakeRepo interface {
	Save(ctx context.Context, graph *mistake.MistakeGraph) error
	GetByStudentID(ctx context.Context, studentID uuid.UUID) (*mistake.MistakeGraph, error)
}
type GenerateRemediationLessonCommand struct {
	Title     string
	Model     string
	Prompt    string
	StudentID uuid.UUID
	MistakeID uuid.UUID
}

type GenerateRemediationLessonUsecase struct {
	repo             LessonDraftRepo
	generator        LessonGenerator
	mistakeGraphRepo GraphMistakeRepo
}

func NewGenerateRemediationLessonUsecase(repo LessonDraftRepo, gen LessonGenerator, mistakeRepo GraphMistakeRepo) *GenerateRemediationLessonUsecase {
	return &GenerateRemediationLessonUsecase{repo: repo, generator: gen, mistakeGraphRepo: mistakeRepo}
}

func (u *GenerateRemediationLessonUsecase) Create(ctx context.Context, cmd GenerateRemediationLessonCommand) (uuid.UUID, error) {
	if cmd.MistakeID == uuid.Nil() {
		return uuid.Nil(), errors.New("mistake ID không được để trống")
	}
	if cmd.StudentID == uuid.Nil() {
		return uuid.Nil(), errors.New("student ID không được để trống")
	}

	graph, err := u.mistakeGraphRepo.GetByStudentID(ctx, cmd.StudentID)
	if err != nil {
		return uuid.Nil(), fmt.Errorf("không thể lấy đồ thị lỗi: %w", err)
	}
	mistakeContext, err := graph.GetAncestryPath(cmd.MistakeID)
	if err != nil {
		return uuid.Nil(), fmt.Errorf("không thể lấy ngữ cảnh lỗi: %w", err)
	}
	if len(mistakeContext) == 0 {
		return uuid.Nil(), errors.New("không tìm thấy ngữ cảnh lỗi")
	}
	coreMistake := mistakeContext[len(mistakeContext)-1]
	items := []lesson.MistakeItem{}
	for _, m := range mistakeContext {
		items = append(items, lesson.MistakeItem{
			Topic:  m.Topic(),
			Reason: m.Reason(),
		})
	}
	material := lesson.NewMistakeMaterial(cmd.StudentID, cmd.MistakeID, coreMistake.Topic(), coreMistake.Reason(), items)
	if cmd.Title == "" {
		cmd.Title = "Bài giảng khắc phục lỗi: " + coreMistake.Topic()
	}

	draft := lesson.NewLessonDraft(cmd.Title, cmd.Model, cmd.Prompt, lesson.LessonDraftProcessing, material)

	if err := u.repo.Save(ctx, draft); err != nil {
		return uuid.Nil(), fmt.Errorf("không thể lưu Lesson Draft: %w", err)
	}

	go u.processGenerationInBackground(draft, cmd.Title, cmd.Model, cmd.Prompt, material)

	return draft.ID(), nil
}

func (u *GenerateRemediationLessonUsecase) processGenerationInBackground(draft *lesson.LessonDraft, title string, model string, prompt string, material lesson.StudyMaterial) {

	bgCtx, cancel := context.WithTimeout(context.Background(), 10*time.Minute)
	defer cancel()

	var err error
	defer func() {
		if err != nil {
			draft.ApplyError(err)
			errCtx, cancel := context.WithTimeout(context.Background(), 101*time.Second)
			defer cancel()
			_ = u.repo.Save(errCtx, draft)
		}
	}()

	generatedLesson, err := u.generator.Generate(bgCtx, title, material, model, prompt)
	if err != nil {
		err = fmt.Errorf("AI Grader lỗi khi tạo bài giảng: %w", err)
		return
	}

	draft.ApplyLesson(*generatedLesson)
	err = u.repo.Save(bgCtx, draft)
}
