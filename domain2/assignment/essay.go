package assignment

import (
	"errors"
	"fmt"
	exercise "meet-attendance-clean/domain2/excercise"
	"strings"
	"uuid"
)

type EssayAnswer struct {
	itemID      uuid.UUID
	text        string
	data        [][]byte
	targetParts []string
}

func (a EssayAnswer) IsValid(ex exercise.EssayExercise) (bool, string) {
	return true, ""
}
func (a EssayAnswer) ItemID() uuid.UUID { return a.itemID }
func (a EssayAnswer) IsAnswer()         {}
func (a EssayAnswer) TargetParts() []string {
	return append([]string(nil), a.targetParts...)
}
func (a EssayAnswer) Text() string {
	return a.text
}
func (a EssayAnswer) Data() [][]byte {
	return cloneBytes2D(a.data)
}

// var _ Answer[exercise.EssayExercise] = &EssayAnswer{}

type SubEssayReq struct {
	label string
}
type EssayEvalReq struct {
	itemID   uuid.UUID
	subItems []SubEssayReq
	text     string
	data     [][]byte
}

func (e EssayEvalReq) ItemID() uuid.UUID { return e.itemID }

type SubEssayRes struct {
	label     string
	isCorrect bool
	comment   string
}
type EssayEvalRes struct {
	itemID           uuid.UUID
	subItems         []SubEssayRes
	detectedMistakes []DetectedMistake
}

func NewSubEssayRes(label string, isCorrect bool, comment string) SubEssayRes {
	return SubEssayRes{
		label:     label,
		isCorrect: isCorrect,
		comment:   comment,
	}
}
func NewEssayEvalRes(itemID uuid.UUID, subItems []SubEssayRes, detectedMistakes []DetectedMistake) EssayEvalRes {
	return EssayEvalRes{
		itemID:           itemID,
		subItems:         append([]SubEssayRes(nil), subItems...),
		detectedMistakes: append([]DetectedMistake(nil), detectedMistakes...),
	}
}

func (e EssayEvalRes) ItemID() uuid.UUID { return e.itemID }
func (e EssayEvalRes) DetectedMistakes() []DetectedMistake {
	var copied []DetectedMistake
	copied = append(copied, e.detectedMistakes...)
	return copied
}
func (e EssayEvalRes) Comment() string {
	totalComment := ""
	for _, sub := range e.subItems {
		totalComment += "\n" + sub.comment
	}
	return totalComment
}

type subItem struct {
	label      string
	isSelected bool
	isCorrect  bool
	comment    string
}
type EssayAssigmentItem struct {
	id         uuid.UUID
	exercise   exercise.EssayExercise
	answer     *EssayAnswer
	subItems   []subItem
	evaluation *ItemEvaluation
}

func newEssayAssignmentItem(ex exercise.EssayExercise) EssayAssigmentItem {
	var subItems []subItem
	for _, sub := range ex.Parts() {
		subItems = append(subItems, subItem{
			label:      sub.Label(),
			isSelected: false,
			isCorrect:  false,
			comment:    "",
		})
	}
	return EssayAssigmentItem{
		id:       uuid.New(),
		exercise: ex,
		subItems: subItems,
	}
}
func (e *EssayAssigmentItem) Exercise() exercise.EssayExercise {
	return e.exercise
}
func (e *EssayAssigmentItem) ID() uuid.UUID { return e.id }

func (e *EssayAssigmentItem) ListSelectedSubItem() []string {
	var selected []string
	for _, sub := range e.subItems {
		if sub.isSelected {
			selected = append(selected, sub.label)
		}
	}
	return selected
}
func (e *EssayAssigmentItem) IsCorrect() bool {
	return e.evaluation != nil && e.evaluation.outcome == EvaluationCorrect
}
func (e *EssayAssigmentItem) OutputResult() string {
	if e.answer == nil {
		return "Chưa làm bài tự luận"
	}
	if e.evaluation == nil {
		return "Chưa chấm điểm"
	}

	isValid, rs := e.answer.IsValid(e.exercise)
	if !isValid {
		return rs
	}
	correct := 0
	selected := 0
	for _, sub := range e.subItems {
		if sub.isCorrect {
			correct++
		}
		if sub.isSelected {
			selected++
		}
	}
	return fmt.Sprintf("Đúng: %d/%d ý", correct, selected)
}
func (e *EssayAssigmentItem) ApplyEvalResult(res EssayEvalRes) []DetectedMistake {

	// e.isEvaluated = true
	var mistakes []DetectedMistake
	for _, sub := range res.DetectedMistakes() {
		mistakes = append(mistakes, NewDetectedMistake(sub.topic, sub.reason, e.id))
	}
	for i := 0; i < len(e.subItems); i++ {
		sub := &e.subItems[i]
		if sub.isSelected {
			for _, subGrade := range res.subItems {
				if subGrade.label == sub.label {
					sub.comment = subGrade.comment
					sub.isCorrect = subGrade.isCorrect

				}
			}
		}
	}
	correctCount := 0
	totalCount := 0

	for _, sub := range e.subItems {
		if !sub.isSelected {
			continue
		}

		totalCount++

		if sub.isCorrect {
			correctCount++
		}
	}

	switch {
	case totalCount == 0:
	case correctCount == totalCount:
		e.evaluation = &ItemEvaluation{
			outcome: EvaluationCorrect,
		}

	case correctCount == 0:
		e.evaluation = &ItemEvaluation{
			outcome: EvaluationIncorrect,
		}

	default:
		e.evaluation = &ItemEvaluation{
			outcome: EvaluationPartiallyCorrect,
		}
	}
	return mistakes
}
func (e *EssayAssigmentItem) GenerateEvalRequest() EssayEvalReq {
	var subItems []SubEssayReq
	for i := 0; i < len(e.subItems); i++ {
		sub := &e.subItems[i]

		if sub.isSelected {
			subItems = append(subItems, SubEssayReq{
				label: sub.label,
			})
		}
	}
	var studentText string
	var studentData [][]byte
	if e.answer != nil {
		studentText = e.answer.text
		studentData = e.answer.data
	}
	return EssayEvalReq{
		itemID:   e.id,
		subItems: subItems,
		text:     studentText,
		data:     studentData,
	}
}
func (e *EssayAssigmentItem) AddAnswer(anwser EssayAnswer) {
	mapLabel := make(map[string]bool)
	for _, label := range anwser.TargetParts() {
		mapLabel[strings.ToLower(label)] = true
	}
	for i := 0; i < len(e.subItems); i++ {
		cleanLabel := strings.ToLower(strings.TrimSpace(e.subItems[i].label))
		e.subItems[i].isSelected = mapLabel[cleanLabel]
	}
	e.answer = &anwser
}
func (e *EssayAssigmentItem) Comment() string {
	var finalComment string
	for _, sub := range e.subItems {
		if sub.isSelected {
			finalComment += sub.comment + "\n"
		}
	}
	return finalComment
}
func (e *EssayAssigmentItem) IsValid() (bool, string) {
	// if e.answer == nil {
	// 	return false, "Chưa làm bài tự luận"
	// }
	// isValid, rs := e.answer.IsValid(e.exercise)
	// if !isValid {
	// 	return false, rs
	// }
	return true, ""
}
func (e *EssayAssigmentItem) IsEvaluated() bool {
	return e.evaluation != nil
}

var _ TypedAssignmentItem[exercise.EssayExercise, EssayAnswer, EssayEvalReq, EssayEvalRes] = &EssayAssigmentItem{}

func NewEssayAnswer(itemID uuid.UUID, text string, data [][]byte, targetParts []string) (EssayAnswer, error) {
	// if text == "" && len(data) == 0 {
	// 	return nil, errors.New("bài làm tự luận không được để trống")
	// }
	parts := append([]string(nil), targetParts...)
	for i := 0; i < len(targetParts); i++ {
		parts[i] = strings.TrimSpace(parts[i])
		if parts[i] == "" {
			return EssayAnswer{}, errors.New("phần đề cập (parts) cần có tên")
		}
	}
	return EssayAnswer{
		itemID:      itemID,
		text:        text,
		data:        cloneBytes2D(data),
		targetParts: parts,
	}, nil
}
