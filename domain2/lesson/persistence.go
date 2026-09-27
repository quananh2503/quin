package lesson

import (
	"errors"
	"time"
	"uuid"

	exercise "meet-attendance-clean/domain2/excercise"
)

func ReconstituteLesson(id uuid.UUID, title, overview string, sections []Section, exercises []exercise.Exercise, material StudyMaterial) (*Lesson, error) {
	if id == uuid.Nil() || material == nil || len(exercises) == 0 {
		return nil, errors.New("dữ liệu lesson lưu trữ không hợp lệ")
	}
	return &Lesson{id: id, title: title, overview: overview, sections: cloneSections(sections), exercises: append([]exercise.Exercise(nil), exercises...), material: material}, nil
}

func ReconstituteLessonDraft(id uuid.UUID, title, model, prompt string, status LessonDraftStatus, material StudyMaterial, createdAt time.Time, updatedAt *time.Time, errorString *string, content *Lesson) (*LessonDraft, error) {
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
	if content != nil {
		v := *content
		v.sections = cloneSections(content.sections)
		v.exercises = append([]exercise.Exercise(nil), content.exercises...)
		d.lesson = &v
	}
	return d, nil
}

func (m MistakeMaterial) Topic() string  { return m.topic }
func (m MistakeMaterial) Reason() string { return m.reason }
func (m MistakeMaterial) Context() []MistakeItem {
	return append([]MistakeItem(nil), m.mistakeContext...)
}
