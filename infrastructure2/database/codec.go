package database

import (
	"encoding/json"
	"errors"
	"fmt"
	"uuid"

	"meet-attendance-clean/domain2/assignment"
	exercise "meet-attendance-clean/domain2/excercise"
	"meet-attendance-clean/domain2/lesson"
)

type materialRecord struct {
	Type      lesson.MaterialType  `json:"type"`
	URL       string               `json:"url,omitempty"`
	Path      string               `json:"path,omitempty"`
	Pages     []int                `json:"pages,omitempty"`
	StudentID uuid.UUID            `json:"student_id,omitempty"`
	MistakeID uuid.UUID            `json:"mistake_id,omitempty"`
	Topic     string               `json:"topic,omitempty"`
	Reason    string               `json:"reason,omitempty"`
	Context   []lesson.MistakeItem `json:"context,omitempty"`
}

func encodeMaterial(material lesson.StudyMaterial) (materialRecord, error) {
	switch m := material.(type) {
	case lesson.YouTubeMaterial:
		return materialRecord{Type: lesson.MaterialYouTube, URL: m.SourceURL()}, nil
	case lesson.PDFMaterial:
		return materialRecord{Type: lesson.MaterialPDF, Path: m.FilePath(), Pages: m.Pages()}, nil
	case lesson.MistakeMaterial:
		return materialRecord{Type: lesson.MaterialMistake, StudentID: m.StudentID(), MistakeID: m.MistakeID(), Topic: m.Topic(), Reason: m.Reason(), Context: m.Context()}, nil
	default:
		return materialRecord{}, fmt.Errorf("material không hỗ trợ: %T", material)
	}
}

func decodeMaterial(m materialRecord) (lesson.StudyMaterial, error) {
	switch m.Type {
	case lesson.MaterialYouTube:
		return lesson.NewYouTubeMaterial(m.URL)
	case lesson.MaterialPDF:
		return lesson.NewSlicedPDFMaterial(m.Path, m.Pages)
	case lesson.MaterialMistake:
		if m.StudentID == uuid.Nil() || m.MistakeID == uuid.Nil() {
			return nil, errors.New("mistake material lưu trữ thiếu ID")
		}
		return lesson.NewMistakeMaterial(m.StudentID, m.MistakeID, m.Topic, m.Reason, m.Context), nil
	default:
		return nil, fmt.Errorf("material type lưu trữ không hỗ trợ: %q", m.Type)
	}
}

type optionRecord struct {
	Label   string `json:"label"`
	Content string `json:"content"`
}
type partRecord struct {
	Label    string `json:"label"`
	Question string `json:"question"`
	Solution string `json:"solution"`
	Rubric   string `json:"rubric"`
}
type diagramRecord struct {
	Type    exercise.DiagramType `json:"type"`
	Content string               `json:"content"`
}
type exerciseRecord struct {
	Type       exercise.ExerciseType `json:"type"`
	Topic      string                `json:"topic"`
	Difficulty string                `json:"difficulty"`
	Prompt     string                `json:"prompt"`
	Options    []optionRecord        `json:"options,omitempty"`
	Answer     string                `json:"answer,omitempty"`
	Solution   string                `json:"solution,omitempty"`
	Parts      []partRecord          `json:"parts,omitempty"`
	Diagram    diagramRecord         `json:"diagram"`
}

func encodeExercise(ex exercise.Exercise) (exerciseRecord, error) {
	r := exerciseRecord{Type: ex.Type(), Topic: ex.Topic(), Difficulty: ex.Difficulty(), Prompt: ex.Prompt(), Diagram: diagramRecord{Type: ex.Diagram().Type(), Content: ex.Diagram().Content()}}
	switch v := ex.(type) {
	case exercise.MultipleChoiceExercise:
		r.Answer, r.Solution = v.Answer(), v.Solution()
		for _, opt := range v.Options() {
			r.Options = append(r.Options, optionRecord{Label: opt.Label(), Content: opt.Content()})
		}
	case exercise.EssayExercise:
		for _, part := range v.Parts() {
			r.Parts = append(r.Parts, partRecord{Label: part.Label(), Question: part.Question(), Solution: part.Solution(), Rubric: part.Rubric()})
		}
	default:
		return exerciseRecord{}, fmt.Errorf("exercise không hỗ trợ: %T", ex)
	}
	return r, nil
}

func decodeExercise(r exerciseRecord) (exercise.Exercise, error) {
	diagram := exercise.NewDiagram(r.Diagram.Type, r.Diagram.Content)
	switch r.Type {
	case exercise.ExerciseTypeMultipleChoice:
		options := make([]exercise.MCOption, 0, len(r.Options))
		for _, opt := range r.Options {
			options = append(options, exercise.NewMCOption(opt.Label, opt.Content))
		}

		return exercise.NewMultipleChoiceExercise(r.Topic, r.Difficulty, r.Prompt, options, r.Answer, r.Solution, diagram)
	case exercise.ExerciseTypeEssay:
		parts := make([]exercise.EssayPart, 0, len(r.Parts))
		for _, part := range r.Parts {
			parts = append(parts, exercise.NewEssayPart(part.Label, part.Question, part.Solution, part.Rubric))
		}
		return exercise.NewEssayExercise(r.Topic, r.Difficulty, r.Prompt, parts, diagram)
	default:
		return nil, fmt.Errorf("exercise type lưu trữ không hỗ trợ: %q", r.Type)
	}
}

type lessonRecord struct {
	ID        uuid.UUID        `json:"id"`
	Title     string           `json:"title"`
	Overview  string           `json:"overview"`
	Sections  []lesson.Section `json:"sections"`
	Exercises []exerciseRecord `json:"exercises"`
	Material  materialRecord   `json:"material"`
}

func encodeLesson(value *lesson.Lesson) ([]byte, error) {
	if value == nil {
		return nil, errors.New("lesson không được nil")
	}
	material, err := encodeMaterial(value.Material())
	if err != nil {
		return nil, err
	}
	r := lessonRecord{ID: value.ID(), Title: value.Title(), Overview: value.Overview(), Sections: value.Sections(), Material: material}
	for _, ex := range value.Exercises() {
		encoded, err := encodeExercise(ex)
		if err != nil {
			return nil, err
		}
		r.Exercises = append(r.Exercises, encoded)
	}
	return json.Marshal(r)
}

func decodeLesson(raw []byte) (*lesson.Lesson, error) {
	var r lessonRecord
	if err := json.Unmarshal(raw, &r); err != nil {
		return nil, err
	}
	material, err := decodeMaterial(r.Material)
	if err != nil {
		return nil, err
	}
	exercises := make([]exercise.Exercise, 0, len(r.Exercises))
	for _, saved := range r.Exercises {
		ex, err := decodeExercise(saved)
		if err != nil {
			return nil, err
		}
		exercises = append(exercises, ex)
	}
	return lesson.ReconstituteLesson(r.ID, r.Title, r.Overview, r.Sections, exercises, material)
}

type answerRecord struct {
	Kind           exercise.ExerciseType `json:"kind"`
	SelectedOption string                `json:"selected_option,omitempty"`
	Text           string                `json:"text,omitempty"`
	Data           [][]byte              `json:"data,omitempty"`
	TargetParts    []string              `json:"target_parts,omitempty"`
}
type itemRecord struct {
	ID         uuid.UUID                   `json:"id"`
	Exercise   exerciseRecord              `json:"exercise"`
	Answer     *answerRecord               `json:"answer,omitempty"`
	Evaluation *assignment.EvaluationState `json:"evaluation,omitempty"`
	SubItems   []assignment.EssayPartState `json:"sub_items,omitempty"`
}

func encodeItems(items []assignment.AssignmentItem) ([]byte, error) {
	result := make([]itemRecord, 0, len(items))
	for _, item := range items {
		state := item.State()
		ex, err := encodeExercise(state.Exercise)
		if err != nil {
			return nil, err
		}
		r := itemRecord{ID: state.ID, Exercise: ex, Evaluation: state.Evaluation, SubItems: state.SubItems}
		switch a := state.Answer.(type) {
		case nil:
		case assignment.MCQAnswer:
			r.Answer = &answerRecord{Kind: exercise.ExerciseTypeMultipleChoice, SelectedOption: a.SelectedOption(), Text: a.WorkingText(), Data: a.WorkingData()}
		case assignment.EssayAnswer:
			r.Answer = &answerRecord{Kind: exercise.ExerciseTypeEssay, Text: a.Text(), Data: a.Data(), TargetParts: a.TargetParts()}
		default:
			return nil, fmt.Errorf("answer không hỗ trợ: %T", state.Answer)
		}
		result = append(result, r)
	}
	return json.Marshal(result)
}

func decodeItems(raw []byte) ([]assignment.AssignmentItem, error) {
	var records []itemRecord
	if err := json.Unmarshal(raw, &records); err != nil {
		return nil, err
	}
	items := make([]assignment.AssignmentItem, 0, len(records))
	for _, r := range records {
		ex, err := decodeExercise(r.Exercise)
		if err != nil {
			return nil, err
		}
		state := assignment.ItemState{ID: r.ID, Exercise: ex, Evaluation: r.Evaluation, SubItems: r.SubItems}
		if r.Answer != nil {
			switch r.Answer.Kind {
			case exercise.ExerciseTypeMultipleChoice:
				state.Answer, err = assignment.NewMCQAnswer(r.ID, r.Answer.SelectedOption, r.Answer.Text, r.Answer.Data)
			case exercise.ExerciseTypeEssay:
				state.Answer, err = assignment.NewEssayAnswer(r.ID, r.Answer.Text, r.Answer.Data, r.Answer.TargetParts)
			default:
				err = errors.New("answer type lưu trữ không hợp lệ")
			}
			if err != nil {
				return nil, err
			}
		}
		item, err := assignment.ReconstituteItem(state)
		if err != nil {
			return nil, err
		}
		items = append(items, item)
	}
	return items, nil
}
