package gemini

import "context"

// =============================================================================
// PROVIDER INTERFACES: TRỪU TƯỢNG HÓA CÁC PHỤ THUỘC BÊN NGOÀI (EXTERNAL DRIVERS)
// Cho phép Mock 100% khi Unit Test mà không cần API key và không cần cài Typst CLI.
// =============================================================================

// LLMProvider interface trừu tượng hóa cho mọi nhà cung cấp AI (Gemini, DeepSeek, OpenAI, Claude, v.v.)
type LLMProvider interface {
	ProviderName() string
	GenerateJSON(ctx context.Context, req LLMRequest) (*LLMResponse, error)
}

// TypstCompiler interface trừu tượng hóa việc biên dịch file Typst ra PDF.
type TypstCompiler interface {
	Compile(ctx context.Context, typstMarkup string, opts CompileOptions) (*CompileResult, error)
}

// PlanAuditor kiểm định độ bao phủ và phát hiện bất thường trên LessonPlan
type PlanAuditor interface {
	Audit(plan *LessonPlan) AuditReport
}

// PlanReviewerStage Giai đoạn 1.5 - Thẩm định và tinh chỉnh danh mục dạng toán
type PlanReviewerStage interface {
	Review(ctx context.Context, plan *LessonPlan, docs []DocumentInput) (*LessonPlan, error)
}

// PlanPolisherStage Giai đoạn 1.75 - Chuốt lại, khử trùng lặp và sắp xếp sư phạm toàn diện
type PlanPolisherStage interface {
	Polish(ctx context.Context, plan *LessonPlan) (*LessonPlan, error)
}
