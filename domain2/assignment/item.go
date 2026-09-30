package assignment

import (
	"errors"
	"fmt"

	// exercise "meet-attendance-clean/domain2/excercise"

	// exercise "meet-attendance-clean/domain2/excercise"
	// exercise "meet-attendance-clean/domain2/excercise"
	shareKernel "meet-attendance-clean/domain2/kernel"
	"uuid"
)

type EvaluationOutcome string

const (
	EvaluationCorrect          EvaluationOutcome = "correct"
	EvaluationPartiallyCorrect EvaluationOutcome = "partially_correct"
	EvaluationIncorrect        EvaluationOutcome = "incorrect"
)

type ItemEvaluation struct {
	outcome EvaluationOutcome
	comment string
}

func NewItemEvaluation(outcome EvaluationOutcome, comment string) ItemEvaluation {
	return ItemEvaluation{
		outcome: outcome,
		comment: comment,
	}
}

func ReconstituteEvaluation(outcome EvaluationOutcome, comment string) *ItemEvaluation {
	return &ItemEvaluation{outcome: outcome, comment: comment}
}
func (e ItemEvaluation) Outcome() EvaluationOutcome {
	return e.outcome
}
func (e ItemEvaluation) Comment() string {
	return e.comment
}

type Answer interface {
	ItemID() uuid.UUID
	IsAnswer()
}
type EvaluationRequest interface {
	ItemID() uuid.UUID
}

type EvaluationResult interface {
	ItemID() uuid.UUID
	DetectedMistakes() []DetectedMistake
}
type AssignmentItem interface {
	ID() uuid.UUID
	OutputResult() string
	Comment() string
	Exercise() shareKernel.Exercise
	AddAnswer(raw Answer) error
	GenerateEvalRequest() EvaluationRequest
	ApplyEvalResult(res EvaluationResult) ([]DetectedMistake, error)
	IsCorrect() bool
	IsValid() (bool, string)
	IsEvaluated() bool
	Inner() any
	// State() ItemState
}

type TypedAssignmentItem[E shareKernel.Exercise, A Answer, Req EvaluationRequest, Res EvaluationResult] interface {
	ID() uuid.UUID
	OutputResult() string
	Comment() string
	Exercise() E
	AddAnswer(raw A)
	GenerateEvalRequest() Req
	ApplyEvalResult(res Res) []DetectedMistake
	IsValid() (bool, string)
	IsCorrect() bool
	IsEvaluated() bool
	// State() ItemState
}
type wrapperAssignmentItem[E shareKernel.Exercise, A Answer, Req EvaluationRequest, Res EvaluationResult, T TypedAssignmentItem[E, A, Req, Res]] struct {
	inner T
}

func newWrapItem[E shareKernel.Exercise, A Answer, Req EvaluationRequest, Res EvaluationResult, T TypedAssignmentItem[E, A, Req, Res]](item T) *wrapperAssignmentItem[E, A, Req, Res, T] {
	return &wrapperAssignmentItem[E, A, Req, Res, T]{
		inner: item,
	}
}
func (w *wrapperAssignmentItem[E, A, Req, Res, T]) ID() uuid.UUID { return w.inner.ID() }
func (w *wrapperAssignmentItem[E, A, Req, Res, T]) OutputResult() string {
	return w.inner.OutputResult()
}
func (w *wrapperAssignmentItem[E, A, Req, Res, T]) Comment() string { return w.inner.Comment() }
func (w *wrapperAssignmentItem[E, A, Req, Res, T]) Exercise() shareKernel.Exercise {
	return w.inner.Exercise()
}
func (w *wrapperAssignmentItem[E, A, Req, Res, T]) AddAnswer(raw Answer) error {
	typed, ok := raw.(A)
	if !ok {
		return fmt.Errorf("item %s yêu cầu đáp án kiểu %T, nhận được %T", w.inner.ID(), *new(A), raw)
	}
	if typed.ItemID() != w.inner.ID() {
		return fmt.Errorf("đáp án thuộc về item khác: %s", typed.ItemID())
	}
	w.inner.AddAnswer(typed)
	return nil
}
func (w *wrapperAssignmentItem[E, A, Req, Res, T]) GenerateEvalRequest() EvaluationRequest {
	return w.inner.GenerateEvalRequest()
}
func (w *wrapperAssignmentItem[E, A, Req, Res, T]) ApplyEvalResult(res EvaluationResult) ([]DetectedMistake, error) {
	typed, ok := res.(Res)
	if !ok {
		return nil, fmt.Errorf("item %s yêu cầu đáp án kiểu %T, nhận được %T", w.inner.ID(), *new(Res), res)
	}
	if typed.ItemID() != w.inner.ID() {
		return nil, fmt.Errorf("đáp án thuộc về item khác: %s", typed.ItemID())
	}
	return w.inner.ApplyEvalResult(typed), nil
}
func (w *wrapperAssignmentItem[E, A, Req, Res, T]) IsCorrect() bool {
	return w.inner.IsCorrect()
}
func (w *wrapperAssignmentItem[E, A, Req, Res, T]) IsValid() (bool, string) {
	return w.inner.IsValid()
}
func (w *wrapperAssignmentItem[E, A, Req, Res, T]) IsEvaluated() bool {
	return w.inner.IsEvaluated()
}
func (w *wrapperAssignmentItem[E, A, Req, Res, T]) Inner() any {
	return w.inner
}

// func (w *wrapperAssignmentItem[E, A, Req, Res, T]) State() ItemState {
// 	return w.inner.State()
// }

// Tạo một file factory.go hoặc để chung trong assignment.go
func NewAssignmentItem(ex shareKernel.Exercise) (AssignmentItem, error) {
	if ex == nil {
		return nil, errors.New("không thể tạo item từ exercise nil")
	}

	switch typedEx := ex.(type) {
	case shareKernel.EssayExercise:
		// Phải trả về pointer &EssayAssigmentItem
		var subItems []SubItem
		for _, sub := range typedEx.Parts() {
			subItems = append(subItems, SubItem{
				label:      sub.Label(),
				isSelected: false,
				isCorrect:  false,
				comment:    "",
			})
		}
		rawItem := &EssayAssigmentItem{
			id:       uuid.New(),
			exercise: typedEx,
			subItems: subItems,
			// Khởi tạo subItems dựa vào đề bài
		}
		return newWrapItem(rawItem), nil

	case shareKernel.MultipleChoiceExercise:
		// Phải trả về pointer &MCQAssignmentItem
		rawItem := &MCQAssignmentItem{
			id:       uuid.New(),
			exercise: typedEx,
		}
		return newWrapItem(rawItem), nil

	default:
		return nil, fmt.Errorf("loại bài tập không hỗ trợ: %T", ex)
	}
}

// ReconstituteMCQItem restores the persisted state without allocating a new ID.
func ReconstituteMCQItem(id uuid.UUID, ex shareKernel.MultipleChoiceExercise, answer *MCQAnswer, evaluation *ItemEvaluation) AssignmentItem {
	return newWrapItem(&MCQAssignmentItem{id: id, exercise: ex, answer: answer, evaluation: evaluation})
}

var _ AssignmentItem = &wrapperAssignmentItem[shareKernel.Exercise, Answer, EvaluationRequest, EvaluationResult, TypedAssignmentItem[shareKernel.Exercise, Answer, EvaluationRequest, EvaluationResult]]{}

type DetectedMistake struct {
	topic            string
	reason           string
	assignmentItemID uuid.UUID
}

func NewDetectedMistake(topic, reason string, assignmentItemID uuid.UUID) DetectedMistake {
	return DetectedMistake{
		topic:            topic,
		reason:           reason,
		assignmentItemID: assignmentItemID,
	}
}
func (d DetectedMistake) Topic() string {
	return d.topic
}
func (d DetectedMistake) Reason() string {
	return d.reason
}
func (d DetectedMistake) AssignmentItemID() uuid.UUID {
	return d.assignmentItemID
}
