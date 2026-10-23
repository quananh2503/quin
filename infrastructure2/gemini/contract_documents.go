package gemini

import "time"

// =============================================================================
// CONTRACT: DATA TRANSFER OBJECTS (DOCUMENTS, LLM, COMPILER & PIPELINE REQUEST/RESPONSE)
// =============================================================================

// DocumentInput đại diện cho tài liệu học tập đầu vào.
// Thiết kế đa kênh: Hỗ trợ cả Native PDF (Gemini) lẫn Text/Markdown (DeepSeek, OpenAI).
type DocumentInput struct {
	DocID       string `json:"doc_id"`       // Mã tài liệu (VD: "DOC_1", "DOC_2")
	FileName    string `json:"file_name"`    // Tên file gốc (VD: "SGK_Toan_12.pdf")
	RoleHint    string `json:"role_hint"`    // Vai trò tài liệu (VD: "Tài liệu chính / SGK", "Bài tập ôn tập")
	RawPDF      []byte `json:"-"`            // Dành cho Gemini (Multimodal PDF Blob nạp trực tiếp)
	TextContent string `json:"text_content"` // Dành cho DeepSeek / OpenAI (Markdown/Text đã trích xuất)
}

// ToDocumentInput chuyển đổi từ struct cũ PDFDocumentInput sang DocumentInput mới
func (p PDFDocumentInput) ToDocumentInput() DocumentInput {
	return DocumentInput{
		DocID:    p.DocID,
		FileName: p.FileName,
		RoleHint: p.RoleHint,
		RawPDF:   p.Data,
	}
}

// UsageMetrics ghi nhận số lượng token tiêu thụ chuẩn hóa
type UsageMetrics struct {
	PromptTokens     int `json:"prompt_tokens"`
	CandidatesTokens int `json:"candidates_tokens"`
	TotalTokens      int `json:"total_tokens"`
}

// LLMRequest đóng gói yêu cầu gọi AI hoàn toàn độc lập với mọi SDK hãng (Google, OpenAI...)
type LLMRequest struct {
	ModelName       string          `json:"model_name"`
	SystemPrompt    string          `json:"system_prompt,omitempty"`
	UserPrompt      string          `json:"user_prompt"`
	Documents       []DocumentInput `json:"documents,omitempty"`
	Temperature     float32         `json:"temperature"`
	MaxOutputTokens int             `json:"max_output_tokens"`
	JSONSchema      []byte          `json:"json_schema,omitempty"` // Chuỗi JSON Schema chuẩn (OpenAPI 3.0 / JSONSchema Draft-07)
}

// LLMResponse kết quả phản hồi chuẩn từ LLM (đã tự động gọt bỏ thẻ <think> nếu là DeepSeek-R1)
type LLMResponse struct {
	RawJSON string       `json:"raw_json"`
	Usage   UsageMetrics `json:"usage"`
}

// CompileOptions cấu hình tham số biên dịch Typst
type CompileOptions struct {
	IsTeacher  bool              `json:"is_teacher"`
	Inputs     map[string]string `json:"inputs,omitempty"`
	OutPDFPath string            `json:"out_pdf_path"`
}

// CompileResult kết quả sau khi gọi trình biên dịch
type CompileResult struct {
	Success    bool   `json:"success"`
	PDFPath    string `json:"pdf_path,omitempty"`
	ErrorLines []int  `json:"error_lines,omitempty"` // Danh sách các dòng báo lỗi cú pháp từ stderr của Typst
	RawStderr  string `json:"raw_stderr,omitempty"`
}

// TypstDiagnostic chứa thông tin lỗi cốt lõi đã được lọc sạch từ Typst stderr
type TypstDiagnostic struct {
	LineNumber    int    `json:"line_number"`
	ErrorReason   string `json:"error_reason"`
	BrokenSnippet string `json:"broken_snippet"`
}

// ValidationIssue chi tiết lỗi toán học hoặc ký tự điều khiển rác
type ValidationIssue struct {
	SlotID        string `json:"slot_id"`
	Reason        string `json:"reason"`
	Content       string `json:"content"`
	Context       string `json:"context"`
	BrokenSnippet string `json:"broken_snippet,omitempty"`
}

// AssembleResult kết quả sau khi chuyển đổi struct sang mã Typst
type AssembleResult struct {
	Markup    string       `json:"markup"`
	SourceMap SourceMap    `json:"-"`
	Registry  SlotRegistry `json:"-"`
}

// AuditReport kết quả kiểm định độ bao phủ của LessonPlan
type AuditReport struct {
	UnassignedIDs    []string `json:"unassigned_ids"`
	OverloadedTopics []Topic  `json:"overloaded_topics"`
	RedundantTopics  []Topic  `json:"redundant_topics"`
	NeedsRefinement  bool     `json:"needs_refinement"`
}

// PipelineRequest tham số đầu vào để chạy toàn bộ tiến trình
type PipelineRequest struct {
	Documents       []DocumentInput   `json:"documents"`
	UserInstruction string            `json:"user_instruction"`
	OutputDir       string            `json:"output_dir"`
	Metadata        map[string]string `json:"metadata,omitempty"`
}

// PipelineOutput kết quả sau khi hoàn tất toàn bộ tiến trình biên soạn
type PipelineOutput struct {
	Plan           *LessonPlan    `json:"plan"`
	Workers        []WorkerResult `json:"workers"`
	TypstMarkup    string         `json:"typst_markup"`
	TeacherPDFPath string         `json:"teacher_pdf_path"`
	StudentPDFPath string         `json:"student_pdf_path"`
	Duration       time.Duration  `json:"duration"`
	TotalUsage     UsageMetrics   `json:"total_usage"`
}
