package application2

import (
	"context"
	"errors"
	"fmt"

	"meet-attendance-clean/domain2/lesson"
	"uuid"
)

// LessonDraftEditorRepo là port dành riêng cho luồng giáo viên chỉnh sửa.
// Infrastructure reconstitute LessonDraft từ dữ liệu cũ và persist lại toàn bộ
// aggregate sau khi nội dung mới đã ghi đè.
type LessonDraftEditorRepo interface {
	GetByID(ctx context.Context, id uuid.UUID) (*lesson.LessonDraft, error)
	Save(ctx context.Context, draft *lesson.LessonDraft) error
}

// UpdateLessonDraftCommand nhận Lesson mới hoàn chỉnh do boundary dựng từ form UI.
// Không nhận field rời để application không phải hiểu chi tiết editor.
type UpdateLessonDraftCommand struct {
	DraftID uuid.UUID
	Lesson  *lesson.Lesson
}

type UpdateLessonDraftUsecase struct {
	repo LessonDraftEditorRepo
}

func NewUpdateLessonDraftUsecase(repo LessonDraftEditorRepo) *UpdateLessonDraftUsecase {
	return &UpdateLessonDraftUsecase{repo: repo}
}

func (u *UpdateLessonDraftUsecase) Update(ctx context.Context, cmd UpdateLessonDraftCommand) error {
	if cmd.DraftID == uuid.Nil() {
		return errors.New("draft ID không được định nghĩa")
	}
	if cmd.Lesson == nil {
		return errors.New("lesson mới không được để trống")
	}

	draft, err := u.repo.GetByID(ctx, cmd.DraftID)
	if err != nil {
		return fmt.Errorf("không tìm thấy lesson draft: %w", err)
	}
	if draft == nil {
		return errors.New("lesson draft không tồn tại")
	}

	draft.ReplaceLesson(*cmd.Lesson)
	if err := u.repo.Save(ctx, draft); err != nil {
		return fmt.Errorf("không thể lưu lesson draft đã chỉnh sửa: %w", err)
	}
	return nil
}
