package exercise

import (
	"errors"
	"fmt"
	"strings"
)

type ExerciseType string

const (
	ExerciseTypeMultipleChoice ExerciseType = "multiple-choice"
	ExerciseTypeEssay          ExerciseType = "essay"
)

type Exercise interface {
	Topic() string
	Difficulty() string
	Prompt() string
	Type() ExerciseType
	Diagram() Diagram
}
type exerciseBase struct {
	// id         uuid.UUID
	topic      string
	difficulty string
	prompt     string
	diagram    Diagram
}

// func (e exerciseBase) ID() uuid.UUID      { return e.id }
func (e exerciseBase) Topic() string      { return e.topic }
func (e exerciseBase) Difficulty() string { return e.difficulty }
func (e exerciseBase) Prompt() string     { return e.prompt }
func (e exerciseBase) Diagram() Diagram   { return e.diagram }

type MultipleChoiceExercise struct {
	exerciseBase
	options  []MCOption
	answer   string
	solution string
}

func (m MultipleChoiceExercise) Type() ExerciseType { return ExerciseTypeMultipleChoice }

type MCOption struct {
	label   string
	content string
}

func NewMCOption(label string, content string) MCOption {
	return MCOption{
		label:   label,
		content: content,
	}
}
func (m MCOption) Label() string {
	return m.label
}
func (m MCOption) Content() string {
	return m.content
}

func (m MultipleChoiceExercise) Options() []MCOption {
	copied := make([]MCOption, len(m.options))
	copy(copied, m.options)
	return copied
}
func (m MultipleChoiceExercise) Answer() string   { return m.answer }
func (m MultipleChoiceExercise) Solution() string { return m.solution }

type EssayExercise struct {
	exerciseBase
	parts []EssayPart
}

func (e EssayExercise) Type() ExerciseType { return ExerciseTypeEssay }

func (e EssayExercise) Parts() []EssayPart {
	copied := make([]EssayPart, len(e.parts))
	copy(copied, e.parts)
	return copied
}

type EssayPart struct {
	label    string
	question string
	solution string
	rubric   string
}

func NewEssayPart(label, question, solution, rubric string) EssayPart {
	return EssayPart{label: label, question: question, solution: solution, rubric: rubric}
}

func (p EssayPart) Label() string {
	return p.label
}
func (p EssayPart) Solution() string {
	return p.solution
}
func (p EssayPart) Rubric() string {
	return p.rubric
}
func (p EssayPart) Question() string {
	return p.question
}

func NewMultipleChoiceExercise(
	topic string,
	difficulty string,
	prompt string,
	options []MCOption,
	answer string,
	solution string,
	diagram Diagram,
) (MultipleChoiceExercise, error) {

	topic = strings.TrimSpace(topic)
	if topic == "" {
		return MultipleChoiceExercise{}, errors.New("topic không được để trống")
	}

	prompt = strings.TrimSpace(prompt)
	if prompt == "" {
		return MultipleChoiceExercise{}, errors.New("đề bài (prompt) không được để trống")
	}

	if len(options) < 2 {
		return MultipleChoiceExercise{}, errors.New("câu hỏi trắc nghiệm phải có ít nhất 2 lựa chọn")
	}

	// 3. Chuẩn hóa đáp án (Xóa khoảng trắng thừa và chuyển thành chữ HOA)
	cleanAnswer := strings.TrimSpace(strings.ToUpper(answer))
	if cleanAnswer == "" {
		return MultipleChoiceExercise{}, errors.New("đáp án (answer) không được để trống")
	}

	// 4. Invariant: Kiểm tra chữ cái đáp án có nằm trong phạm vi của Options không
	// Ví dụ: Có 4 options thì đáp án chỉ được phép là 'A', 'B', 'C', hoặc 'D'
	firstChar := cleanAnswer[0]
	if firstChar < 'A' || firstChar > 'Z' {
		return MultipleChoiceExercise{}, fmt.Errorf("đáp án phải bắt đầu bằng chữ cái (A-Z), nhận được: %s", cleanAnswer)
	}

	// Tính chỉ số index từ ký tự: 'A' -> 0, 'B' -> 1, 'C' -> 2...
	optionIndex := int(firstChar - 'A')

	// 🛡️ CHẶN LOGIC CHUẨN XÁC: Index âm hoặc vượt quá số lượng options
	if optionIndex < 0 || optionIndex >= len(options) {
		maxAllowedLetter := string(rune('A' + len(options) - 1))
		return MultipleChoiceExercise{}, fmt.Errorf("đáp án '%s' không hợp lệ: câu hỏi có %d lựa chọn (chỉ chấp nhận từ A đến %s)", cleanAnswer, len(options), maxAllowedLetter)
	}

	// 5. Khởi tạo Entity an toàn 100%
	return MultipleChoiceExercise{
		// id:         uuid.New(),
		topic:      topic,
		difficulty: strings.TrimSpace(difficulty),
		prompt:     prompt,
		options:    append([]MCOption(nil), options...), // Copy slice để tránh bị thay đổi từ bên ngoài
		answer:     cleanAnswer,
		diagram:    diagram,
		solution:   strings.TrimSpace(solution),
	}, nil
}

func NewEssayExercise(
	topic string,
	difficulty string,
	prompt string,
	parts []EssayPart,
	diagram Diagram,
) (EssayExercise, error) {

	topic = strings.TrimSpace(topic)
	if topic == "" {
		return EssayExercise{}, errors.New("topic không được để trống")
	}

	prompt = strings.TrimSpace(prompt)
	if prompt == "" {
		return EssayExercise{}, errors.New("đề bài (prompt) không được để trống")
	}

	if len(parts) == 0 {
		return EssayExercise{}, errors.New("các phần đề cập (parts) không được để trống")
	}
	newParts := append([]EssayPart(nil), parts...)
	for i := 0; i < len(parts); i++ {
		part := &newParts[i]
		part.label = strings.TrimSpace(part.label)
		if part.label == "" {
			return EssayExercise{}, errors.New("phần đề cập (parts) cần có tên")
		}

		part.question = strings.TrimSpace(part.question)
		if part.question == "" {
			return EssayExercise{}, errors.New("phần đề cập (parts) cần có câu hỏi")
		}

		part.solution = strings.TrimSpace(part.solution)
		if part.solution == "" {
			return EssayExercise{}, errors.New("phần đề cập (parts) cần có câu trả lời")
		}

		part.rubric = strings.TrimSpace(part.rubric)
		if part.rubric == "" {
			return EssayExercise{}, errors.New("phần đề cập (parts) cần có đáp án")
		}
	}

	return EssayExercise{
		// id:         uuid.New(),
		topic:      topic,
		difficulty: strings.TrimSpace(difficulty),
		prompt:     prompt,
		parts:      newParts, // Copy slice để tránh bị thay đổi từ bên ngoài
		diagram:    diagram,
	}, nil
}
