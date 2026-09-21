package lesson

import (
	"errors"
	exercise "meet-attendance-clean/domain2/excercise"
	"uuid"
)

type Audience string

const (
	AudienceTeacher Audience = "teacher"
	AudienceStudent Audience = "student"
)

var (
	ErrErcerciseEmpty = errors.New("exercises is empty")
)

type TeacherExample struct {
	ExampleNum                 int
	Problem                    string
	TeacherSolution            string
	StudentFriendlyExplanation string
	CommonMistake              string
}

type Section struct {
	SectionTitle      string
	TransitionIntro   string
	DetailedContent   string
	KeyTakeaway       string
	StudentClozeNotes []string
	TeacherExamples   []TeacherExample
}
type LessonSource interface {
	isLessonSource()
}
type Lesson struct {
	id        uuid.UUID
	title     string
	overview  string
	sections  []Section
	exercises []exercise.Exercise
	material  StudyMaterial
}

func (l *Lesson) ID() uuid.UUID {
	return l.id
}
func (l *Lesson) Material() StudyMaterial {
	return l.material
}
func (l *Lesson) Title() string {
	return l.title
}
func (l *Lesson) Overview() string {
	return l.overview
}
func (l *Lesson) Sections() []Section {
	copied := make([]Section, len(l.sections))
	for i := range l.sections {
		copied[i] = Section{
			SectionTitle:      l.sections[i].SectionTitle,
			TransitionIntro:   l.sections[i].TransitionIntro,
			DetailedContent:   l.sections[i].DetailedContent,
			KeyTakeaway:       l.sections[i].KeyTakeaway,
			StudentClozeNotes: append([]string(nil), l.sections[i].StudentClozeNotes...),
			TeacherExamples:   append([]TeacherExample(nil), l.sections[i].TeacherExamples...),
		}
	}
	return copied
}
func (l *Lesson) Exercises() []exercise.Exercise {
	var exs []exercise.Exercise
	for _, ex := range l.exercises {
		exs = append(exs, ex)
	}
	return exs
}
func cloneSections(sections []Section) []Section {
	copied := make([]Section, len(sections))
	for i := range sections {
		copied[i] = Section{
			SectionTitle:      sections[i].SectionTitle,
			TransitionIntro:   sections[i].TransitionIntro,
			DetailedContent:   sections[i].DetailedContent,
			KeyTakeaway:       sections[i].KeyTakeaway,
			StudentClozeNotes: append([]string(nil), sections[i].StudentClozeNotes...),
			TeacherExamples:   append([]TeacherExample(nil), sections[i].TeacherExamples...),
		}
	}
	return copied
}
func NewLesson(title string, overview string, sections []Section, exercises []exercise.Exercise, material StudyMaterial) (*Lesson, error) {
	if len(title) == 0 {
		title = "Không có tiêu đề"
	}

	if len(exercises) == 0 {
		return nil, ErrErcerciseEmpty
	}
	if material == nil {
		return nil, errors.New("material không được để trống")
	}

	return &Lesson{
		id:        uuid.New(),
		title:     title,
		overview:  overview,
		sections:  cloneSections(sections),
		exercises: append([]exercise.Exercise(nil), exercises...),
		material:  material,
	}, nil
}

type LessonSourceYouTube struct {
	url string
}
type LessonSourcePDF struct {
	path  string
	pages []int
}
type LessonSourceMistake struct {
	mistakeID uuid.UUID
}
