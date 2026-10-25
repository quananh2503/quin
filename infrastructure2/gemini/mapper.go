package gemini

import (
	"errors"
	"fmt"
	"strings"

	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
)

// PipelineLessonMapper định nghĩa hợp đồng chuyển đổi kết quả đầu ra của AI Pipeline
// (LessonPlan và các WorkerResult) thành Lesson Domain Entity hoàn chỉnh theo mô hình sư phạm module.
type PipelineLessonMapper interface {
	ToDomainLesson(plan *LessonPlan, workers []WorkerResult, materials []lesson.StudyMaterial) (*lesson.Lesson, error)
}

// DefaultPipelineLessonMapper là hiện thực mặc định của PipelineLessonMapper.
type DefaultPipelineLessonMapper struct{}

// NewDefaultPipelineLessonMapper khởi tạo mapper.
func NewDefaultPipelineLessonMapper() *DefaultPipelineLessonMapper {
	return &DefaultPipelineLessonMapper{}
}

// ToDomainLesson chuyển đổi các kết quả phân tích và biên soạn từ AI Pipeline thành Lesson Entity.
// Invariants:
// - plan không được nil, plan.LessonTitle không được để trống.
// - len(workers) phải > 0 (phải có ít nhất 1 dạng toán).
// - len(materials) phải > 0 (phải có ít nhất 1 tài liệu nguồn).
// - Mỗi WorkerResult phải được chuyển hóa thành 1 Topic hoàn chỉnh trong Section:
//   * TheoryPoints, CalloutTip, ClozeFormula -> các Blocks lý thuyết/mẹo/công thức.
//   * Examples -> các ExampleBlock (có đề bài và lời giải).
//   * Drills và ShortAnswers -> các EssayExercise tương ứng gắn vào Topic đó.
func (m *DefaultPipelineLessonMapper) ToDomainLesson(
	plan *LessonPlan,
	workers []WorkerResult,
	materials []lesson.StudyMaterial,
) (*lesson.Lesson, error) {
	if plan == nil {
		return nil, errors.New("lesson plan không được nil")
	}
	if strings.TrimSpace(plan.LessonTitle) == "" {
		return nil, errors.New("tiêu đề bài học (lesson title) không được để trống")
	}
	if len(workers) == 0 {
		return nil, errors.New("danh sách workers không được để trống")
	}
	if len(materials) == 0 {
		return nil, errors.New("danh sách tài liệu học tập (materials) không được để trống")
	}

	topics := make([]lesson.Topic, 0, len(workers))
	for _, w := range workers {
		var blocks []lesson.Block

		if len(w.TheoryPoints) > 0 {
			theoryText := strings.TrimSpace(strings.Join(w.TheoryPoints, "\n"))
			if theoryText != "" {
				blocks = append(blocks, lesson.NewParagraphBlock(textToContent(theoryText)))
			}
		}

		if strings.TrimSpace(w.CalloutTip) != "" {
			blocks = append(blocks, lesson.NewCalloutBlock(
				lesson.CalloutTip,
				textToContent("Mẹo giải nhanh"),
				textToContent(w.CalloutTip),
			))
		}

		if strings.TrimSpace(w.ClozeFormula) != "" {
			blocks = append(blocks, lesson.NewFormulaBlock(w.ClozeFormula))
		}

		for _, ex := range w.Examples {
			blocks = append(blocks, lesson.NewExampleBlock(
				textToContent(ex.Title),
				textToContent(ex.Problem),
				textToContent(ex.Solution),
				textToContent(""),
			))
		}

		var exercises []sharekernel.Exercise

		for _, s := range w.ShortAnswers {
			rubric := textToContent(s.FinalNumber)
			if rubric.IsEmpty() {
				rubric = textToContent(s.Solution)
			}
			if rubric.IsEmpty() {
				rubric = textToContent("-")
			}
			part := sharekernel.NewEssayPart(
				"a",
				textToContent(s.Prompt),
				textToContent(s.Solution),
				rubric,
			)
			diag := sharekernel.NewDiagram(sharekernel.DiagramNone, "")
			ex, err := sharekernel.NewEssayExercise(w.Title, "Thông hiểu", textToContent(s.Prompt), []sharekernel.EssayPart{part}, diag)
			if err != nil {
				return nil, fmt.Errorf("tạo bài tập trả lời ngắn thất bại: %w", err)
			}
			exercises = append(exercises, ex)
		}

		for _, d := range w.Drills {
			rubric := textToContent(d.Solution)
			if rubric.IsEmpty() {
				rubric = textToContent("-")
			}
			part := sharekernel.NewEssayPart(
				"a",
				textToContent(d.Prompt),
				textToContent(d.Solution),
				rubric,
			)
			diag := sharekernel.NewDiagram(sharekernel.DiagramNone, "")
			ex, err := sharekernel.NewEssayExercise(w.Title, "Vận dụng", textToContent(d.Prompt), []sharekernel.EssayPart{part}, diag)
			if err != nil {
				return nil, fmt.Errorf("tạo bài tập tự luyện thất bại: %w", err)
			}
			exercises = append(exercises, ex)
		}

		top, err := lesson.NewTopic(textToContent(w.Title), blocks, exercises)
		if err != nil {
			return nil, fmt.Errorf("tạo topic '%s' thất bại: %w", w.Title, err)
		}
		topics = append(topics, top)
	}

	section, err := lesson.NewSection(textToContent("Nội Dung Bài Giảng"), topics)
	if err != nil {
		return nil, fmt.Errorf("tạo section thất bại: %w", err)
	}

	lsn, err := lesson.NewLesson(
		textToContent(plan.LessonTitle),
		textToContent(plan.Overview),
		[]lesson.Section{section},
		materials,
	)
	if err != nil {
		return nil, fmt.Errorf("tạo lesson thất bại: %w", err)
	}

	return lsn, nil
}

// Helper tiện ích chuyển chuỗi văn bản thành sharekernel.Content
func textToContent(text string) sharekernel.Content {
	text = strings.TrimSpace(text)
	if text == "" {
		return sharekernel.NewContent()
	}
	return sharekernel.NewContent(sharekernel.InlinePart{
		Type:  sharekernel.InlineText,
		Value: text,
	})
}
