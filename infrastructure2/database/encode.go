package database

import (
	"encoding/json"
	"errors"
	"fmt"
	"meet-attendance-clean/domain2/assignment"
	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/domain2/mistake"
	"time"
	"uuid"
)

type inlinePartRecord struct {
	Type  sharekernel.InlinePartType `json:"type"`  // "text" hoặc "math"
	Value string                     `json:"value"` // Nội dung chữ hoặc công thức Typst
}
type contentRecord struct {
	InlineParts []inlinePartRecord `json:"inline_parts"`
}

func encodeContent(c sharekernel.Content) contentRecord {
	if len(c.Parts()) == 0 {
		return contentRecord{InlineParts: nil}
	}
	parts := c.Parts()
	encodedParts := make([]inlinePartRecord, len(parts))
	for i, p := range parts {
		encodedParts[i] = inlinePartRecord{
			Type:  p.Type,
			Value: p.Value,
		}
	}
	return contentRecord{InlineParts: encodedParts}
}

type clozePartRecord struct {
	Type  string `json:"type"` // "text" | "math" | "blank"
	Value string `json:"value"`
}

type clozeItemRecord struct {
	Parts []clozePartRecord `json:"parts"`
}

type blockRecord struct {
	Type string `json:"type"` // "paragraph" | "list" | "formula" | "example" | "image" | "cloze" | "callout"

	// 1. Cho ParagraphBlock
	Body *contentRecord `json:"body,omitempty"`

	// 2. Cho ListBlock
	IsOrdered *bool           `json:"is_ordered,omitempty"`
	Items     []contentRecord `json:"items,omitempty"`

	// 3. Cho FormulaBlock
	Math string `json:"math,omitempty"`

	// 4. Cho ExampleBlock
	Title       *contentRecord `json:"title,omitempty"`
	Problem     *contentRecord `json:"problem,omitempty"`
	Solution    *contentRecord `json:"solution,omitempty"`
	Explanation *contentRecord `json:"explanation,omitempty"`

	// 5. Cho ImageBlock
	SVG     string         `json:"svg,omitempty"`
	Caption *contentRecord `json:"caption,omitempty"`

	// 6. Cho ClozeBlock (Đục lỗ)
	Instruction *contentRecord    `json:"instruction,omitempty"`
	ClozeItems  []clozeItemRecord `json:"cloze_items,omitempty"`

	// 7. Cho CalloutBlock (Ghi nhớ / Mẹo)
	CalloutKind string         `json:"callout_kind,omitempty"`
	CalloutBody *contentRecord `json:"callout_body,omitempty"`
}

func encodeBlock(b lesson.Block) (blockRecord, error) {
	switch v := b.(type) {

	// 1. Đoạn văn xuôi
	case lesson.ParagraphBlock:
		body := encodeContent(v.Body())
		return blockRecord{
			Type: string(lesson.BlockParagraph),
			Body: &body,
		}, nil

	// 2. Danh sách (Gạch đầu dòng hoặc Đánh số)
	case lesson.ListBlock:
		items := make([]contentRecord, len(v.Items()))
		for i, item := range v.Items() {
			items[i] = encodeContent(item)
		}
		isOrd := v.IsOrdered()
		return blockRecord{
			Type:      string(lesson.BlockList),
			IsOrdered: &isOrd,
			Items:     items,
		}, nil

	// 3. Công thức toán đứng riêng dòng
	case lesson.FormulaBlock:
		return blockRecord{
			Type: string(lesson.BlockFormula),
			Math: v.Math(),
		}, nil

	// 4. Ví dụ mẫu
	case lesson.ExampleBlock:
		t := encodeContent(v.Title())
		p := encodeContent(v.Problem())
		s := encodeContent(v.Solution())
		e := encodeContent(v.Explanation())
		return blockRecord{
			Type:        string(lesson.BlockExample),
			Title:       &t,
			Problem:     &p,
			Solution:    &s,
			Explanation: &e,
		}, nil

	// 5. Hình vẽ minh họa SVG
	case lesson.ImageBlock:
		cap := encodeContent(v.Caption())
		return blockRecord{
			Type:    string(lesson.BlockImage),
			SVG:     v.SVG(),
			Caption: &cap,
		}, nil

	// 6. Bài tập điền khuyết / Đục lỗ
	case lesson.ClozeBlock:
		inst := encodeContent(v.Instruction())
		items := make([]clozeItemRecord, len(v.Items()))
		for i, item := range v.Items() {
			parts := make([]clozePartRecord, len(item.Parts))
			for j, p := range item.Parts {
				parts[j] = clozePartRecord{
					Type:  string(p.Type),
					Value: p.Value,
				}
			}
			items[i] = clozeItemRecord{Parts: parts}
		}
		return blockRecord{
			Type:        string(lesson.BlockCloze),
			Instruction: &inst,
			ClozeItems:  items,
		}, nil

	// 7. Hộp Ghi nhớ / Mẹo / Cảnh báo
	case lesson.CalloutBlock:
		t := encodeContent(v.Title())
		body := encodeContent(v.Body())
		return blockRecord{
			Type:        string(lesson.BlockCallout),
			CalloutKind: string(v.Kind()),
			Title:       &t,
			CalloutBody: &body,
		}, nil

	default:
		return blockRecord{}, fmt.Errorf("không hỗ trợ encode loại block: %T", b)
	}
}

type topicRecord struct {
	Title  contentRecord `json:"title"`
	Blocks []blockRecord `json:"blocks"`
}

type sectionRecord struct {
	Title  contentRecord `json:"title"`
	Topics []topicRecord `json:"topics"`
}

// encodeSection gom gọn cả phần Topic bên trong nó
func encodeSection(s lesson.Section) (sectionRecord, error) {
	secRec := sectionRecord{
		Title:  encodeContent(s.Title()),
		Topics: make([]topicRecord, len(s.Topics())),
	}

	for i, top := range s.Topics() {
		topRec := topicRecord{
			Title:  encodeContent(top.Title()),
			Blocks: make([]blockRecord, len(top.Blocks())),
		}

		for j, b := range top.Blocks() {
			bRec, err := encodeBlock(b)
			if err != nil {
				return sectionRecord{}, fmt.Errorf("lỗi encode block thứ %d ở topic '%s': %w", j+1, top.Title().String(), err)
			}
			topRec.Blocks[j] = bRec
		}

		secRec.Topics[i] = topRec
	}

	return secRec, nil
}

type materialRecord struct {
	Type string `json:"type"`
	// 1. Cho YouTube
	URL *string `json:"url,omitempty"`
	// 2. Cho PDF
	Path  *string `json:"path,omitempty"`
	Pages []int   `json:"pages,omitempty"`
	// 3. Cho Mistake
	MistakeID *uuid.UUID           `json:"mistake_id,omitempty"`
	StudentID *uuid.UUID           `json:"student_id,omitempty"`
	Topic     string               `json:"topic,omitempty"`
	Reason    string               `json:"reason,omitempty"`
	Context   []lesson.MistakeItem `json:"context,omitempty"`
}

func ptrUUID(id uuid.UUID) *uuid.UUID { return &id }

func encodeMaterial(m lesson.StudyMaterial) (materialRecord, error) {
	switch v := m.(type) {
	case lesson.YouTubeMaterial:
		url := v.SourceURL()
		return materialRecord{
			Type: string(lesson.MaterialYouTube),
			URL:  &url,
		}, nil
	case lesson.PDFMaterial:
		path := v.FilePath()
		pages := v.Pages()
		return materialRecord{
			Type:  string(lesson.MaterialPDF),
			Path:  &path,
			Pages: pages,
		}, nil
	case lesson.MistakeMaterial:
		mistakeID := v.MistakeID()
		return materialRecord{
			Type:      string(lesson.MaterialMistake),
			MistakeID: &mistakeID,
			StudentID: ptrUUID(v.StudentID()), Topic: v.Topic(), Reason: v.Reason(), Context: v.Context(),
		}, nil
	default:
		return materialRecord{}, fmt.Errorf("không hỗ trợ encode loại material: %T", m)
	}
}

// 1. DTO cho Diagram (Hình vẽ SVG hoặc URL)
type diagramRecord struct {
	Type    string `json:"type"` // "SVG" | "URL" | ""
	Content string `json:"content"`
}

// 2. DTO cho từng lựa chọn trắc nghiệm (A, B, C, D)
type optionRecord struct {
	Label   string        `json:"label"`   // "A", "B"...
	Content contentRecord `json:"content"` // Chứa text + toán
}

// 3. DTO cho từng câu hỏi con của bài tự luận (a, b, c)
type partRecord struct {
	Label    string        `json:"label"`    // "a)", "b)"...
	Question contentRecord `json:"question"` // Đề bài câu con
	Solution contentRecord `json:"solution"` // Lời giải câu con
	Rubric   contentRecord `json:"rubric"`   // Barem chấm điểm
}

// 4. DTO to nhất đại diện cho 1 bài tập bất kỳ
type exerciseRecord struct {
	// --- CÁC TRƯỜNG CHUNG ---
	Type       string        `json:"type"` // "multiple-choice" hoặc "essay"
	Topic      string        `json:"topic"`
	Difficulty string        `json:"difficulty"`
	Prompt     contentRecord `json:"prompt"` // Đề bài chung
	Diagram    diagramRecord `json:"diagram"`

	// --- RIÊNG CHO TRẮC NGHIỆM (MULTIPLE CHOICE) ---
	Options  []optionRecord `json:"options,omitempty"`
	Answer   string         `json:"answer,omitempty"`
	Solution *contentRecord `json:"solution,omitempty"` // Dùng con trỏ để omitempty nếu là tự luận

	// --- RIÊNG CHO TỰ LUẬN (ESSAY) ---
	Parts []partRecord `json:"parts,omitempty"`
}

func encodeExercise(ex sharekernel.Exercise) (exerciseRecord, error) {
	// BƯỚC 1: Lấy toàn bộ thông tin chung của bài tập
	r := exerciseRecord{
		Type:       string(ex.Type()),
		Topic:      ex.Topic(),
		Difficulty: ex.Difficulty(),
		Prompt:     encodeContent(ex.Prompt()),
		Diagram: diagramRecord{
			Type:    string(ex.Diagram().Type()),
			Content: ex.Diagram().Content(),
		},
	}

	// BƯỚC 2: Kiểm tra xem bài tập này là Trắc nghiệm hay Tự luận
	switch v := ex.(type) {

	// TRƯỜNG HỢP 1: Trắc nghiệm
	case sharekernel.MultipleChoiceExercise:
		r.Answer = v.Answer()

		// Encode lời giải (nếu có)
		sol := encodeContent(v.Solution())
		r.Solution = &sol

		// Encode danh sách các lựa chọn A, B, C, D
		options := v.Options()
		r.Options = make([]optionRecord, len(options))
		for i, opt := range options {
			r.Options[i] = optionRecord{
				Label:   opt.Label(),
				Content: encodeContent(opt.Content()),
			}
		}
		return r, nil

	// TRƯỜNG HỢP 2: Tự luận
	case sharekernel.EssayExercise:
		// Encode danh sách các câu con a), b)...
		parts := v.Parts()
		r.Parts = make([]partRecord, len(parts))
		for i, p := range parts {
			r.Parts[i] = partRecord{
				Label:    p.Label(),
				Question: encodeContent(p.Question()),
				Solution: encodeContent(p.Solution()),
				Rubric:   encodeContent(p.Rubric()),
			}
		}
		return r, nil

	default:
		return exerciseRecord{}, fmt.Errorf("không hỗ trợ encode loại bài tập: %T", ex)
	}
}

type lessonRecord struct {
	ID        uuid.UUID        `json:"id"`
	Title     contentRecord    `json:"title"`
	Overview  contentRecord    `json:"overview"`
	Sections  []sectionRecord  `json:"sections"`
	Exercises []exerciseRecord `json:"exercises"`
	Material  materialRecord   `json:"material"`
}

func encodeLesson(value *lesson.Lesson) (lessonRecord, error) {
	if value == nil {
		return lessonRecord{}, errors.New("lesson không được nil")
	}

	// 1. Encode tài liệu học (YouTube, PDF...)
	material, err := encodeMaterial(value.Material())
	if err != nil {
		return lessonRecord{}, err
	}

	// 2. Encode các Section lý thuyết (gọi hàm encodeSection ở trên)
	sections := value.Sections()
	secRecords := make([]sectionRecord, len(sections))
	for i, sec := range sections {
		sr, err := encodeSection(sec)
		if err != nil {
			return lessonRecord{}, err
		}
		secRecords[i] = sr
	}

	// 3. Encode các bài tập (Exercises)
	exercises := value.Exercises()
	exRecords := make([]exerciseRecord, len(exercises))
	for i, ex := range exercises {
		er, err := encodeExercise(ex)
		if err != nil {
			return lessonRecord{}, err
		}
		exRecords[i] = er
	}

	// 4. Đóng gói vào Record to nhất và ném sang JSON
	r := lessonRecord{
		ID:        value.ID(),
		Title:     encodeContent(value.Title()),
		Overview:  encodeContent(value.Overview()),
		Sections:  secRecords,
		Exercises: exRecords,
		Material:  material,
	}

	return r, nil
}

type lessonDraftRecord struct {
	Id          uuid.UUID      `json:"id"`
	Title       contentRecord  `json:"title"`
	Model       string         `json:"model"`
	Prompt      string         `json:"prompt"`
	Status      string         `json:"status"`
	Lesson      *lessonRecord  `json:"lesson,omitempty"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   *time.Time     `json:"updated_at"`
	ErrorString *string        `json:"error_string"`
	Material    materialRecord `json:"material"`
}

func encodeLessonDraft(d *lesson.LessonDraft) (lessonDraftRecord, error) {
	if d == nil {
		return lessonDraftRecord{}, errors.New("lesson draft không được nil")
	}

	// Encode lesson
	var lesson *lessonRecord
	if d.Lesson() != nil {
		l, err := encodeLesson(d.Lesson())
		if err != nil {
			return lessonDraftRecord{}, err
		}
		lesson = &l
	}
	material, err := encodeMaterial(d.Material())
	if err != nil {
		return lessonDraftRecord{}, err
	}
	// title := d.Title()
	// t := encodeContent(title)
	return lessonDraftRecord{
		Id:          d.ID(),
		Title:       encodeContent(d.Title()),
		Model:       d.Model(),
		Prompt:      d.Prompt(),
		Status:      string(d.Status()),
		Lesson:      lesson,
		CreatedAt:   d.CreatedAt(),
		UpdatedAt:   d.UpdatedAt(),
		ErrorString: d.ErrorString(),
		Material:    material,
	}, nil
}

// 1. DTO lưu đáp án học sinh đã nộp
type answerRecord struct {
	Kind           string   `json:"kind"` // "multiple-choice" | "essay"
	SelectedOption string   `json:"selected_option,omitempty"`
	Text           string   `json:"text,omitempty"`
	Data           [][]byte `json:"data,omitempty"`
	TargetParts    []string `json:"target_parts,omitempty"`
}

// 2. DTO lưu kết quả từng ý con của bài tự luận (ý a, ý b...)
type subItemRecord struct {
	Label      string `json:"label"`
	IsSelected bool   `json:"is_selected"`
	IsCorrect  bool   `json:"is_correct"`
	Comment    string `json:"comment,omitempty"`
}

// 3. DTO lưu kết quả chấm điểm của cả câu
type evaluationRecord struct {
	Outcome string `json:"outcome"`           // "correct" | "partially_correct" | "incorrect"
	Comment string `json:"comment,omitempty"` // Lời phê / nhận xét
}

// 4. STRUCT TRUNG TÂM: ĐẠI DIỆN CHO 1 CÂU BÀI TẬP HOÀN CHỈNH
type itemRecord struct {
	ID         uuid.UUID         `json:"id"`
	Exercise   exerciseRecord    `json:"exercise"` // Tái sử dụng exerciseRecord đã viết
	Answer     *answerRecord     `json:"answer,omitempty"`
	Evaluation *evaluationRecord `json:"evaluation,omitempty"`
	SubItems   []subItemRecord   `json:"sub_items,omitempty"`
}

// =========================================================================
// HÀM ENCODE: BIẾN []AssignmentItem THÀNH []byte JSON ĐỂ LƯU VÀO SQLITE
// =========================================================================

func encodeItems(items []assignment.AssignmentItem) ([]byte, error) {
	result := make([]itemRecord, 0, len(items))

	for _, item := range items {
		// 1. Encode đề bài chung
		exRec, err := encodeExercise(item.Exercise())
		if err != nil {
			return nil, fmt.Errorf("lỗi encode đề bài trong item %s: %w", item.ID(), err)
		}

		r := itemRecord{
			ID:       item.ID(),
			Exercise: exRec,
		}
		inner := item.Inner()
		// 3. Rẽ nhánh theo loại bài tập
		switch it := inner.(type) {

		// NHÁNH TRẮC NGHIỆM
		case *assignment.MCQAssignmentItem:
			if eval := it.Evaluation(); eval != nil {
				r.Evaluation = &evaluationRecord{
					Outcome: string(eval.Outcome()),
					Comment: eval.Comment(),
				}
			}
			if ans := it.Answer(); ans != nil {
				r.Answer = &answerRecord{
					Kind:           string(sharekernel.ExerciseTypeMultipleChoice),
					SelectedOption: ans.SelectedOption(),
					Text:           ans.WorkingText(),
					Data:           ans.WorkingData(),
				}
			}

		// NHÁNH TỰ LUẬN
		case *assignment.EssayAssigmentItem:
			if eval := it.Evaluation(); eval != nil {
				r.Evaluation = &evaluationRecord{
					Outcome: string(eval.Outcome()),
					Comment: eval.Comment(),
				}
			}
			if ans := it.Answer(); ans != nil {
				r.Answer = &answerRecord{
					Kind:        string(sharekernel.ExerciseTypeEssay),
					Text:        ans.Text(),
					Data:        ans.Data(),
					TargetParts: ans.TargetParts(),
				}
			}
			subs := it.SubItems()
			if len(subs) > 0 {
				r.SubItems = make([]subItemRecord, len(subs))
				for i, s := range subs {
					r.SubItems[i] = subItemRecord{
						Label:      s.Label(),
						IsSelected: s.IsSelected(),
						IsCorrect:  s.IsCorrect(),
						Comment:    s.Comment(),
					}
				}
			}
		default:
			return nil, fmt.Errorf("không hỗ trợ encode loại item: %T", inner)
		}

		result = append(result, r)
	}

	return json.Marshal(result)
}

type mistakeRecord struct {
	ID               uuid.UUID  `json:"id"`
	StudentID        uuid.UUID  `json:"student_id"`
	ParentID         *uuid.UUID `json:"parent_id"` // Nút gốc thì nil
	Topic            string     `json:"topic"`
	Reason           string     `json:"reason"`
	AssignmentItemID uuid.UUID  `json:"assignment_item_id"`
	Status           string     `json:"status"`
	CreatedAt        time.Time  `json:"created_at"`
	ResolvedAt       *time.Time `json:"resolved_at,omitempty"`
}

func encodeMistakeGraph(graph *mistake.MistakeGraph) ([]mistakeRecord, error) {
	if graph == nil {
		return nil, errors.New("mistake graph không được nil")
	}

	var records []mistakeRecord
	for _, root := range graph.Roots() {
		records = append(records, flattenMistakeNode(root, graph.StudentID(), nil)...)
	}

	return records, nil
}

func flattenMistakeNode(
	node *mistake.Mistake,
	studentID uuid.UUID,
	parentID *uuid.UUID,
) []mistakeRecord {
	if node == nil {
		return nil
	}

	currentRecord := mistakeRecord{
		ID:               node.ID(),
		StudentID:        studentID,
		ParentID:         parentID,
		Topic:            node.Topic(),
		Reason:           node.Reason(),
		AssignmentItemID: node.AssignmentItemID(),
		Status:           string(node.Status()),
		CreatedAt:        node.CreatedAt(),
		ResolvedAt:       node.ResolvedAt(),
	}

	rows := []mistakeRecord{currentRecord}

	for _, child := range node.Children() {
		childRows := flattenMistakeNode(child, studentID, &currentRecord.ID)
		rows = append(rows, childRows...)
	}

	return rows
}
