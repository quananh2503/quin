package assignment

import (
	"errors"
	// exercise "meet-attendance-clean/domain2/excercise"
	shareKernel "meet-attendance-clean/domain2/kernel"
	"uuid"
)

type MCQAnswer struct {
	itemID         uuid.UUID
	selectedOption string
	workingText    string
	workingData    [][]byte
}

func (a MCQAnswer) ItemID() uuid.UUID { return a.itemID }
func (a MCQAnswer) IsAnswer()         {}

func (a MCQAnswer) IsValid(ex shareKernel.MultipleChoiceExercise) (bool, string) {
	if a.selectedOption == "" {
		return false, "Chưa chọn đáp án trắc nghiệm"
	}
	for _, option := range ex.Options() {
		if option.Label() == a.selectedOption {
			return true, ""
		}
	}
	return false, "Đáp án không hợp lệ"
}
func (a MCQAnswer) SelectedOption() string {
	return a.selectedOption
}
func (a MCQAnswer) WorkingText() string {
	return a.workingText
}
func (a MCQAnswer) WorkingData() [][]byte {
	return cloneBytes2D(a.workingData)
}

type MCQEvalReq struct {
	itemID         uuid.UUID
	selectedOption string
	text           string
	data           [][]byte
}

func (e MCQEvalReq) ItemID() uuid.UUID { return e.itemID }

type MCQEvalRes struct {
	itemID           uuid.UUID
	comment          string
	detectedMistakes []DetectedMistake
}

func NewMCQEvalRes(itemID uuid.UUID, comment string, detectedMistakes []DetectedMistake) MCQEvalRes {
	return MCQEvalRes{
		itemID:           itemID,
		comment:          comment,
		detectedMistakes: append([]DetectedMistake(nil), detectedMistakes...),
	}
}
func (e MCQEvalRes) Comment() string {
	return e.comment
}

func (e MCQEvalRes) ItemID() uuid.UUID { return e.itemID }
func (e MCQEvalRes) DetectedMistakes() []DetectedMistake {
	return append([]DetectedMistake(nil), e.detectedMistakes...)
}

type MCQAssignmentItem struct {
	id         uuid.UUID
	exercise   shareKernel.MultipleChoiceExercise
	answer     *MCQAnswer
	evaluation *ItemEvaluation
}

func (e *MCQAssignmentItem) OutputResult() string {
	if e.answer == nil {
		return "Chưa chọn đáp án"
	}
	valid, reason := e.answer.IsValid(e.exercise)
	if !valid {
		return reason
	}

	if e.evaluation == nil {
		return "Chưa chấm"
	}

	switch e.evaluation.outcome {
	case EvaluationCorrect:
		return "Đúng"
	case EvaluationIncorrect:
		return "Sai"
	default:
		return "Chưa chấm"
	}
}
func (e *MCQAssignmentItem) ApplyEvalResult(res MCQEvalRes) []DetectedMistake {
	if e.answer == nil {
		return nil
	}
	isValid, _ := e.answer.IsValid(e.exercise)
	if !isValid {
		return nil
	}
	var mistakes []DetectedMistake
	if res.DetectedMistakes() != nil {
		for _, m := range res.DetectedMistakes() {
			newMistake := NewDetectedMistake(m.topic, m.reason, e.id)
			mistakes = append(mistakes, newMistake)
		}
	}
	if e.answer.selectedOption != e.exercise.Answer() {

		e.evaluation = &ItemEvaluation{
			outcome: EvaluationIncorrect,
			comment: res.comment,
		}
		return mistakes
	}
	e.evaluation = &ItemEvaluation{
		outcome: EvaluationCorrect,
		comment: res.comment,
	}
	return mistakes
}

func (e *MCQAssignmentItem) GenerateEvalRequest() MCQEvalReq {
	var selected string
	var workText string
	var workData [][]byte

	if e.answer != nil {
		selected = e.answer.selectedOption
		workText = e.answer.workingText
		workData = cloneBytes2D(e.answer.workingData)
	}
	isValid, reason := e.IsValid()
	if !isValid {
		e.evaluation = &ItemEvaluation{
			outcome: EvaluationIncorrect,
			comment: reason,
		}
		return MCQEvalReq{}
	}
	return MCQEvalReq{
		itemID:         e.id,
		selectedOption: selected,
		text:           workText,
		data:           workData,
	}
}
func (e *MCQAssignmentItem) AddAnswer(anwser MCQAnswer) {
	e.answer = &anwser
}
func (e *MCQAssignmentItem) Exercise() shareKernel.MultipleChoiceExercise {
	return e.exercise
}
func (e *MCQAssignmentItem) ID() uuid.UUID { return e.id }
func (e *MCQAssignmentItem) Comment() string {
	if e.evaluation == nil {
		return ""
	}
	return e.evaluation.comment
}
func (e *MCQAssignmentItem) IsCorrect() bool {
	return e.evaluation != nil && e.evaluation.outcome == EvaluationCorrect
}
func (e *MCQAssignmentItem) IsValid() (bool, string) {
	if e.answer == nil {
		return false, "Chưa chọn đáp án"
	}
	return e.answer.IsValid(e.exercise)
}
func (e *MCQAssignmentItem) IsEvaluated() bool {
	return e.evaluation != nil
}
func (e *MCQAssignmentItem) Answer() *MCQAnswer {
	if e.answer == nil {
		return nil
	}
	return &MCQAnswer{
		itemID:         e.answer.itemID,
		selectedOption: e.answer.selectedOption,
		workingText:    e.answer.workingText,
		workingData:    cloneBytes2D(e.answer.workingData),
	}
}
func (e *MCQAssignmentItem) Evaluation() *ItemEvaluation {
	if e.evaluation == nil {
		return nil
	}
	return &ItemEvaluation{
		outcome: e.evaluation.outcome,
		comment: e.evaluation.comment,
	}
}
func NewMCQAnswer(itemID uuid.UUID, selectedOption string, text string, data [][]byte) (MCQAnswer, error) {
	if itemID == uuid.Nil() {
		return MCQAnswer{}, errors.New("itemID không hợp lệ")
	}
	// Chú ý: Trả về Value (hoặc Pointer trỏ tới Value), nhưng bản thân nó là bất biến
	return MCQAnswer{
		itemID:         itemID,
		selectedOption: selectedOption,
		workingText:    text,
		workingData:    cloneBytes2D(data),
	}, nil
}

var _ TypedAssignmentItem[shareKernel.MultipleChoiceExercise, MCQAnswer, MCQEvalReq, MCQEvalRes] = &MCQAssignmentItem{}
