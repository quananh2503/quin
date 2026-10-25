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
	ErrSectionEmpty   = errors.New("danh sách section không được để trống")
	ErrMaterialsEmpty = errors.New("materials không được để trống")
	// Giữ ErrExerciseEmpty để tương thích ngược nếu có module cũ tham chiếu
	ErrExerciseEmpty  = errors.New("danh sách bài tập không được để trống")
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
// BÀI HỌC (LESSON ENTITY - AGGREGATE ROOT)
// ============================================================

// Lesson là Aggregate Root quản lý toàn bộ nội dung của bài học.
// Bài học được cấu trúc theo mô hình sư phạm module gồm nhiều Section (mỗi Section chia thành các Topic/Dạng toán).
// Các bài tập (exercises) không nằm tách rời ở root nữa mà được gắn trực tiếp vào từng Topic tương ứng.
type Lesson struct {
	id        uuid.UUID
	title     shareKernel.Content
	overview  shareKernel.Content
	sections  []Section
	materials []StudyMaterial
}

func (l *Lesson) ID() uuid.UUID                 { return l.id }
func (l *Lesson) Title() shareKernel.Content    { return l.title }
func (l *Lesson) Overview() shareKernel.Content { return l.overview }
func (l *Lesson) Materials() []StudyMaterial    { return l.materials }
func (l *Lesson) Sections() []Section           { return cloneSections(l.sections) }

// Exercises tổng hợp toàn bộ bài tập từ tất cả các Topics trong các Sections.
// Đảm bảo tính tương thích ngược 100% với Assignment và Grading.
// Trả về bản sao lát cắt (slice copy) an toàn.
func (l *Lesson) Exercises() []shareKernel.Exercise {
	if l == nil || len(l.sections) == 0 {
		return nil
	}
	var exercises []shareKernel.Exercise
	for _, sec := range l.sections {
		for _, top := range sec.topics {
			exercises = append(exercises, top.exercises...)
		}
	}
	return exercises
}

func cloneSections(sections []Section) []Section {
	if len(sections) == 0 {
		return nil
	}
	copied := make([]Section, len(sections))
	copy(copied, sections)
	return copied
}

// NewLesson khởi tạo một bài học mới theo mô hình sư phạm module.
// Invariants:
// - Nếu title rỗng: tự động fallback về "Không có tiêu đề".
// - Bắt buộc len(sections) > 0, nếu không trả về ErrSectionEmpty.
// - Bắt buộc len(materials) > 0, nếu không trả về ErrMaterialsEmpty.
// - sections và materials được sao chép bảo vệ (defensive copy).
func NewLesson(
	title shareKernel.Content,
	overview shareKernel.Content,
	sections []Section,
	materials []StudyMaterial,
) (*Lesson, error) {
	if title.IsEmpty() {
		title = shareKernel.NewContent(shareKernel.InlinePart{Type: shareKernel.InlineText, Value: "Không có tiêu đề"})
	}
	if len(sections) == 0 {
		return nil, ErrSectionEmpty
	}
	if len(materials) == 0 {
		return nil, ErrMaterialsEmpty
	}
	copiedMaterials := make([]StudyMaterial, len(materials))
	copy(copiedMaterials, materials)
	return &Lesson{
		id:        uuid.New(),
		title:     copyContent(title),
		overview:  copyContent(overview),
		sections:  cloneSections(sections),
		materials: copiedMaterials,
	}, nil
}

// ReconstituteLesson tái tạo Lesson Entity từ dữ liệu lưu trữ (Repository).
// Invariants:
// - id không được là uuid.Nil().
// - len(sections) > 0 và len(materials) > 0.
func ReconstituteLesson(
	id uuid.UUID,
	title, overview shareKernel.Content,
	sections []Section,
	materials []StudyMaterial,
) (*Lesson, error) {
	if id == uuid.Nil() {
		return nil, errors.New("id không được là uuid.Nil")
	}
	if len(sections) == 0 {
		return nil, ErrSectionEmpty
	}
	if len(materials) == 0 {
		return nil, ErrMaterialsEmpty
	}
	if title.IsEmpty() {
		title = shareKernel.NewContent(shareKernel.InlinePart{Type: shareKernel.InlineText, Value: "Không có tiêu đề"})
	}
	copiedMaterials := make([]StudyMaterial, len(materials))
	copy(copiedMaterials, materials)
	return &Lesson{
		id:        id,
		title:     copyContent(title),
		overview:  copyContent(overview),
		sections:  cloneSections(sections),
		materials: copiedMaterials,
	}, nil
}
