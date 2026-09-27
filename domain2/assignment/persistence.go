package assignment

import (
	"errors"
	"fmt"
	"time"
	"uuid"

	exercise "meet-attendance-clean/domain2/excercise"
)

// ItemState is an immutable copy of the mutable item state for storage and queries.
type ItemState struct {
	ID         uuid.UUID
	Exercise   exercise.Exercise
	Answer     Answer
	Evaluation *EvaluationState
	SubItems   []EssayPartState
}

type EvaluationState struct {
	Outcome EvaluationOutcome
	Comment string
}

type EssayPartState struct {
	Label    string
	Selected bool
	Correct  bool
	Comment  string
}

func (e *MCQAssignmentItem) State() ItemState {
	state := ItemState{ID: e.id, Exercise: e.exercise}
	if e.answer != nil {
		v := *e.answer
		v.workingData = cloneBytes2D(v.workingData)
		state.Answer = v
	}
	if e.evaluation != nil {
		state.Evaluation = &EvaluationState{Outcome: e.evaluation.outcome, Comment: e.evaluation.comment}
	}
	return state
}

func (e *EssayAssigmentItem) State() ItemState {
	state := ItemState{ID: e.id, Exercise: e.exercise, SubItems: make([]EssayPartState, len(e.subItems))}
	if e.answer != nil {
		v := *e.answer
		v.data = cloneBytes2D(v.data)
		v.targetParts = append([]string(nil), v.targetParts...)
		state.Answer = v
	}
	for i, sub := range e.subItems {
		state.SubItems[i] = EssayPartState{Label: sub.label, Selected: sub.isSelected, Correct: sub.isCorrect, Comment: sub.comment}
	}
	if e.evaluation != nil {
		state.Evaluation = &EvaluationState{Outcome: e.evaluation.outcome, Comment: e.evaluation.comment}
	}
	return state
}

func ReconstituteItem(state ItemState) (AssignmentItem, error) {
	if state.ID == uuid.Nil() || state.Exercise == nil {
		return nil, errors.New("item lưu trữ thiếu ID hoặc exercise")
	}
	var evaluation *ItemEvaluation
	if state.Evaluation != nil {
		switch state.Evaluation.Outcome {
		case EvaluationCorrect, EvaluationPartiallyCorrect, EvaluationIncorrect:
		default:
			return nil, errors.New("outcome item lưu trữ không hợp lệ")
		}
		evaluation = &ItemEvaluation{outcome: state.Evaluation.Outcome, comment: state.Evaluation.Comment}
	}
	switch ex := state.Exercise.(type) {
	case exercise.MultipleChoiceExercise:
		item := &MCQAssignmentItem{id: state.ID, exercise: ex, evaluation: evaluation}
		if state.Answer != nil {
			answer, ok := state.Answer.(MCQAnswer)
			if !ok || answer.ItemID() != state.ID {
				return nil, errors.New("MCQ answer lưu trữ không khớp item")
			}
			item.AddAnswer(answer)
		}
		return newWrapItem(item), nil
	case exercise.EssayExercise:
		parts := ex.Parts()
		if len(state.SubItems) != len(parts) {
			return nil, errors.New("số phần essay lưu trữ không khớp exercise")
		}
		item := &EssayAssigmentItem{id: state.ID, exercise: ex, evaluation: evaluation, subItems: make([]subItem, len(parts))}
		if state.Answer != nil {
			answer, ok := state.Answer.(EssayAnswer)
			if !ok || answer.ItemID() != state.ID {
				return nil, errors.New("essay answer lưu trữ không khớp item")
			}
			item.AddAnswer(answer)
		}
		for i, part := range parts {
			saved := state.SubItems[i]
			if saved.Label != part.Label() {
				return nil, fmt.Errorf("essay part %d lưu trữ không khớp exercise", i)
			}
			item.subItems[i] = subItem{label: saved.Label, isSelected: saved.Selected, isCorrect: saved.Correct, comment: saved.Comment}
		}
		return newWrapItem(item), nil
	default:
		return nil, fmt.Errorf("exercise lưu trữ không hỗ trợ: %T", state.Exercise)
	}
}

func ReconstituteAssignment(id, studentID uuid.UUID, title string, purpose AssignmentPurpose, status AssignmentStatus, assignedAt time.Time, items []AssignmentItem) (*Assignment, error) {
	if id == uuid.Nil() || studentID == uuid.Nil() || title == "" || purpose == nil || assignedAt.IsZero() || len(items) == 0 {
		return nil, errors.New("assignment lưu trữ không hợp lệ")
	}
	if status != AssignmentStatusPending && status != AssignmentStatusGraded && status != AssignmentStatusCompleted {
		return nil, errors.New("trạng thái assignment lưu trữ không hợp lệ")
	}
	return &Assignment{id: id, studentID: studentID, title: title, purpose: purpose, status: status, assignedAt: assignedAt, items: append([]AssignmentItem(nil), items...)}, nil
}

func NewRemediationPurpose(mistakeID uuid.UUID) (AssignmentPurposeRemediation, error) {
	if mistakeID == uuid.Nil() {
		return AssignmentPurposeRemediation{}, errors.New("mistake ID không hợp lệ")
	}
	return AssignmentPurposeRemediation{mistakeID: mistakeID}, nil
}
