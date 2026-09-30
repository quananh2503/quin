package lesson

import (
	"errors"
	shareKernel "meet-attendance-clean/domain2/kernel"

	"uuid"
)

type Audience string

const (
	AudienceTeacher Audience = "teacher"
	AudienceStudent Audience = "student"
)

var (
	ErrExerciseEmpty = errors.New("danh sách bài tập không được để trống")
)

// ============================================================
// NGUỒN TẠO BÀI HỌC (LESSON SOURCE)
// ============================================================

type LessonSource interface {
	isLessonSource()
}

type LessonSourceYouTube struct {
	url string
}

func (LessonSourceYouTube) isLessonSource() {}

type LessonSourcePDF struct {
	path  string
	pages []int
}

func (LessonSourcePDF) isLessonSource() {}

type LessonSourceMistake struct {
	mistakeID uuid.UUID
}

func (LessonSourceMistake) isLessonSource() {}

// ============================================================
// BÀI HỌC (LESSON ENTITY)
// ============================================================

type Lesson struct {
	id        uuid.UUID
	title     shareKernel.Content
	overview  shareKernel.Content
	sections  []Section              // Nằm ngay trong package lesson
	exercises []shareKernel.Exercise // Import từ package exercise
	material  StudyMaterial
}

func (l *Lesson) ID() uuid.UUID                 { return l.id }
func (l *Lesson) Title() shareKernel.Content    { return l.title }
func (l *Lesson) Overview() shareKernel.Content { return l.overview }
func (l *Lesson) Material() StudyMaterial       { return l.material }
func (l *Lesson) Sections() []Section           { return cloneSections(l.sections) }
func (l *Lesson) Exercises() []shareKernel.Exercise {
	return append([]shareKernel.Exercise(nil), l.exercises...)
}

func cloneSections(sections []Section) []Section {
	copied := make([]Section, len(sections))
	copy(copied, sections)
	return copied
}

func NewLesson(
	title shareKernel.Content,
	overview shareKernel.Content,
	sections []Section,
	exercises []shareKernel.Exercise,
	material StudyMaterial,
) (*Lesson, error) {

	if title.IsEmpty() {
		title = shareKernel.NewContent(shareKernel.InlinePart{Type: shareKernel.InlineText, Value: "Không có tiêu đề"})
	}

	if len(exercises) == 0 {
		return nil, ErrExerciseEmpty
	}

	if material == nil {
		return nil, errors.New("material không được để trống")
	}

	return &Lesson{
		id:        uuid.New(),
		title:     title,
		overview:  overview,
		sections:  cloneSections(sections),
		exercises: append([]shareKernel.Exercise(nil), exercises...),
		material:  material,
	}, nil
}

func ReconstituteLesson(id uuid.UUID, title, overview shareKernel.Content, sections []Section, exercises []shareKernel.Exercise, material StudyMaterial) (*Lesson, error) {
	if id == uuid.Nil() || material == nil || len(exercises) == 0 {
		return nil, errors.New("dữ liệu lesson lưu trữ không hợp lệ")
	}
	return &Lesson{id: id, title: title, overview: overview, sections: cloneSections(sections), exercises: append([]shareKernel.Exercise(nil), exercises...), material: material}, nil
}
