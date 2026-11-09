package pipeline

import (
	"meet-attendance-clean/domain2/document"
	"meet-attendance-clean/infrastructure2/AI"
	"time"
)

// InventoryItem định danh một mục bài tập / câu hỏi / hoạt động được bóc tách từ tài liệu.
type InventoryItem struct {
	ID          string `json:"id"`                     // Mã định danh duy nhất (vd: DOC1_B1_HD1, DOC1_B1_VD1, DOC3_C51)
	SourceName  string `json:"source_name"`            // Tên tài liệu gốc (vd: "SGK_Toan12_KNTT_Tap1")
	SourceLabel string `json:"source_label"`           // Nhãn gốc nguyên bản (vd: "Hoạt động 1 (Tr. 3)", "Bài 2.8", "Câu 51")
	ItemType    string `json:"item_type"`              // Loại mục: "hoat_dong", "luyen_tap", "van_dung", "vi_du", "bai_tap", "trac_nghiem", "dung_sai", "tra_loi_ngan", "tu_luan"
	Snippet     string `json:"snippet"`                // Tóm tắt ngắn gọn nội dung bài toán
	HasSolution bool   `json:"has_solution,omitempty"` // Có sẵn lời giải trong tài liệu hay không
}

// DocumentInventory bản kiểm kê vét cạn toàn bộ nội dung được bóc tách từ các tài liệu nguồn (Bước 1A).
type DocumentInventory struct {
	TotalItems int             `json:"total_items"`
	Items      []InventoryItem `json:"items"`
}

// CatalogItem định danh cụm câu hỏi theo dạng thức hoặc kỹ năng giải (tương thích ngược).
type CatalogItem struct {
	DocID        string   `json:"doc_id"`
	QuestionIDs  []string `json:"question_ids"`
	QuestionType string   `json:"question_type"`
	TargetOutput string   `json:"target_output"`
	CoreMethod   string   `json:"core_method"`
}

// TopicPlan kế hoạch chi tiết cho 1 dạng toán trong bài giảng.
type TopicPlan struct {
	TopicID             string   `json:"topic_id"`
	Title               string   `json:"title"`
	Difficulty          string   `json:"difficulty"`
	TargetOutput        string   `json:"target_output"`
	CoreConcept         string   `json:"core_concept"`
	AssignedQuestionIDs []string `json:"assigned_question_ids"`
	Variants            []string `json:"variants,omitempty"`
	SourceRefs          []string `json:"source_refs,omitempty"`
}

// LessonPlan kế hoạch bài học tổng thể bao gồm bản kiểm kê và phân loại các dạng toán.
type LessonPlan struct {
	LessonTitle     string            `json:"lesson_title"`
	Overview        string            `json:"overview"`
	Inventory       DocumentInventory `json:"inventory,omitempty"`
	QuestionCatalog []CatalogItem     `json:"question_catalog,omitempty"`
	Topics          []TopicPlan       `json:"topics"`
}

// ExampleItem ví dụ minh họa mẫu.
type ExampleItem struct {
	Title       string `json:"title"`
	Problem     string `json:"problem"`
	Solution    string `json:"solution"`
	Explanation string `json:"explanation,omitempty"`
}

// ShortAnswerExercise bài tập trả lời ngắn ra kết quả số cụ thể.
type ShortAnswerExercise struct {
	Prompt      string `json:"prompt"`
	Solution    string `json:"solution"`
	FinalNumber string `json:"final_number"`
}

// DrillExercise bài tập rèn luyện tương tự hoặc biến thể.
type DrillExercise struct {
	Title    string `json:"title"`
	Level    string `json:"level"`
	Prompt   string `json:"prompt"`
	Solution string `json:"solution"`
	Answer   string `json:"answer,omitempty"`
}

// AnswerItem tóm tắt đáp án và hướng dẫn giải ngắn gọn cho bảng tra cứu cuối bài.
type AnswerItem struct {
	DrillID     string `json:"drill_id"`
	ShortGuide  string `json:"short_guide"`
	FinalAnswer string `json:"final_answer"`
}

// VariantGuide cụm hướng dẫn thực chiến và rèn luyện trọn gói cho từng biến thể bài toán.
type VariantGuide struct {
	VariantID   string          `json:"variant_id"`   // Mã biến thể (vd: "V1", "V2")
	VariantName string          `json:"variant_name"` // Tên biến thể cụ thể
	Recognition string          `json:"recognition"`  // Dấu hiệu nhận diện đặc trưng của biến thể (Nhìn phát biết ngay)
	ActionSteps []string        `json:"action_steps"` // Chuỗi các bước hành động cụ thể linh hoạt (nhúng kèm thao tác Casio hoặc khẩu quyết)
	QuickTip    string          `json:"quick_tip"`    // Khẩu quyết phản xạ siêu tốc hoặc mẹo loại trừ phương án sai
	Example     ExampleItem     `json:"example"`      // Ví dụ minh họa mẫu mực giải theo đúng ActionSteps
	Drills      []DrillExercise `json:"drills"`       // Bài tập tự luyện đẳng cấu lặp lại cùng thuật toán để rèn phản xạ
}

// TopicContent nội dung sư phạm hoàn chỉnh đã biên soạn của 1 dạng toán.
type TopicContent struct {
	TopicID      string                `json:"topic_id"`
	Title        string                `json:"title"`
	Difficulty   string                `json:"difficulty,omitempty"`
	TheoryPoints []string              `json:"theory_points,omitempty"`  // 2-3 gạch đầu dòng lý thuyết tối giản, kẹp trong $...$
	CalloutTip   string                `json:"callout_tip,omitempty"`    // Khẩu quyết cốt lõi chung của dạng (nếu có)
	ClozeFormula string                `json:"cloze_formula,omitempty"`  // 1 câu điền khuyết công thức có "..."
	Variants     []VariantGuide        `json:"variants,omitempty"`       // Danh sách các biến thể thực chiến modul hóa
	AnswerKey    []AnswerItem          `json:"answer_key,omitempty"`     // Bảng đáp án & hướng dẫn vắn tắt cuối bài
	Examples     []ExampleItem         `json:"examples,omitempty"`       // Tương thích ngược
	ShortAnswers []ShortAnswerExercise `json:"short_answers,omitempty"` // Tương thích ngược
	Drills       []DrillExercise       `json:"drills,omitempty"`         // Tương thích ngược
	TypstContent string                `json:"typst_content,omitempty"`  // Mã nguồn Typst đã được biên dịch
	LaTeXContent string                `json:"latex_content,omitempty"`  // Tương thích ngược
}

// AuditReport báo cáo kết quả rà soát xem có bị thiếu sót nội dung nào không.
type AuditReport struct {
	UnassignedIDs    []string    `json:"unassigned_ids"`
	OverloadedTopics []TopicPlan `json:"overloaded_topics"`
	RedundantTopics  []TopicPlan `json:"redundant_topics"`
	NeedsRefinement  bool        `json:"needs_refinement"`
}

// RepairTask nhiệm vụ sửa lỗi cú pháp toán hoặc định dạng.
type RepairTask struct {
	TargetID      string `json:"target_id"`
	ErrorReason   string `json:"error_reason"`
	BrokenSnippet string `json:"broken_snippet"`
	Context       string `json:"context,omitempty"`
	Content       string `json:"content,omitempty"`
	FixedContent  string `json:"fixed_content,omitempty"`
}

// PipelineRequest tham số đầu vào kích hoạt toàn bộ tiến trình biên soạn bài học.
// Hỗ trợ linh hoạt: Đầu vào có thể là SourceDocument từ domain2/document (để qua bước tiền xử lý)
// hoặc các Document đã chuẩn bị sẵn theo interface ai.Document.
type PipelineRequest struct {
	Title      string                     `json:"title"`
	SourceDocs []*document.SourceDocument `json:"source_docs,omitempty"` // Tài liệu nguồn từ domain2.document
	Documents  []ai.Document              `json:"documents,omitempty"`   // Danh sách tài liệu chuẩn hóa ai.Document
	UserPrompt string                     `json:"user_prompt"`           // Bộ chỉ dẫn tùy biến của người dùng
	OutputDir        string                     `json:"output_dir"`
	Workers          int                        `json:"workers,omitempty"`            // Số worker biên soạn song song
	SelectedTopicIDs []string                   `json:"selected_topic_ids,omitempty"` // Lọc danh sách dạng toán cần biên soạn
	Metadata         map[string]string          `json:"metadata,omitempty"`
}

// PipelineResult kết quả tổng hợp đầu ra sau khi chạy xong pipeline.
type PipelineResult struct {
	Plan           *LessonPlan    `json:"plan"`
	TopicsContent  []TopicContent `json:"topics_content"`
	TeacherTypst   string         `json:"teacher_typst,omitempty"`
	StudentTypst   string         `json:"student_typst,omitempty"`
	TeacherPDFPath string         `json:"teacher_pdf_path,omitempty"`
	StudentPDFPath string         `json:"student_pdf_path,omitempty"`
	TotalUsage     ai.Usage       `json:"total_usage"` // Interface ai.Usage cho phép unmarshal cụ thể
	Duration       time.Duration  `json:"duration"`
}
