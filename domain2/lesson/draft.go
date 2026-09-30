package lesson

import (
	"errors"
	shareKernel "meet-attendance-clean/domain2/kernel"
	"time"
	"uuid"
)

type LessonDraftStatus string

const (
	LessonDraftCompleted  LessonDraftStatus = "completed"
	LessonDraftFailed     LessonDraftStatus = "failed"
	LessonDraftProcessing LessonDraftStatus = "processing"
)

type LessonDraft struct {
	id          uuid.UUID
	title       shareKernel.Content
	model       string
	prompt      string
	status      LessonDraftStatus
	lesson      *Lesson
	createdAt   time.Time
	updatedAt   *time.Time
	errorString *string
	meterial    StudyMaterial
}

func NewLessonDraft(title string, model string, prompt string, status LessonDraftStatus, material StudyMaterial) *LessonDraft {
	return &LessonDraft{
		id:        uuid.New(),
		title:     shareKernel.NewContent(shareKernel.InlinePart{Type: shareKernel.InlineText, Value: title}),
		model:     model,
		prompt:    prompt,
		status:    status,
		meterial:  material,
		createdAt: time.Now().UTC(),
	}
}
func ReconstituteLessonDraft(id uuid.UUID, title shareKernel.Content, model, prompt string, status LessonDraftStatus, material StudyMaterial, createdAt time.Time, updatedAt *time.Time, errorString *string, content *Lesson) (*LessonDraft, error) {
	if id == uuid.Nil() || createdAt.IsZero() || material == nil {
		return nil, errors.New("dữ liệu lesson draft lưu trữ không hợp lệ")
	}
	if status != LessonDraftProcessing && status != LessonDraftCompleted && status != LessonDraftFailed {
		return nil, errors.New("trạng thái lesson draft lưu trữ không hợp lệ")
	}
	d := &LessonDraft{id: id, title: title, model: model, prompt: prompt, status: status, meterial: material, createdAt: createdAt}
	if updatedAt != nil {
		v := *updatedAt
		d.updatedAt = &v
	}
	if errorString != nil {
		v := *errorString
		d.errorString = &v
	}
	d.lesson = content
	return d, nil
}

func (d *LessonDraft) ApplyLesson(lesson Lesson) {
	d.title = lesson.title
	d.status = LessonDraftCompleted
	now := time.Now().UTC()
	d.updatedAt = &now
	d.lesson = &lesson
}

// ReplaceLesson thay toàn bộ nội dung bài học bằng phiên bản giáo viên vừa sửa.
// Lesson đã được tạo/kiểm tra bởi factory ở boundary trước khi đi vào Domain.
// Draft vẫn giữ nguyên ID, model, prompt và thời điểm tạo ban đầu.
func (d *LessonDraft) ReplaceLesson(lesson Lesson) {
	d.title = lesson.title
	d.status = LessonDraftCompleted
	now := time.Now().UTC()
	d.updatedAt = &now
	d.lesson = &lesson
}
func (d *LessonDraft) ApplyError(err error) {
	d.status = LessonDraftFailed
	now := time.Now().UTC()
	d.updatedAt = &now
	errStr := err.Error()
	d.errorString = &errStr
}
func (d *LessonDraft) ErrorString() *string {
	return d.errorString
}
func (d *LessonDraft) ID() uuid.UUID {
	return d.id
}
func (d *LessonDraft) Title() shareKernel.Content {
	return d.title
}
func (d *LessonDraft) Model() string {
	return d.model
}
func (d *LessonDraft) Prompt() string {
	return d.prompt
}
func (d *LessonDraft) Status() LessonDraftStatus {
	return d.status
}
func (d *LessonDraft) Lesson() *Lesson {
	return d.lesson
}
func (d *LessonDraft) CreatedAt() time.Time {
	return d.createdAt
}
func (d *LessonDraft) UpdatedAt() *time.Time {
	return d.updatedAt
}
func (d *LessonDraft) Material() StudyMaterial {
	return d.meterial
}
