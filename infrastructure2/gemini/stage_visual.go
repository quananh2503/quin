package gemini

import "context"

// =============================================================================
// STAGE 2.5: VISUAL ENRICHMENT STAGE (HOOK VẼ HÌNH MINH HỌA CETZ & CROP ẢNH)
// Nằm ở giữa AuthoringStage và DocumentAssembler.
// Tự động quét các bài tập cần hình để bổ sung DiagramSpec mà không làm quá tải Stage 2.
// =============================================================================

// VisualEnrichmentStage interface làm giàu hình ảnh cho các bài tập
type VisualEnrichmentStage interface {
	// Enrich nhận danh sách WorkerResult, quét các bài cần minh họa và gắn DiagramSpec
	Enrich(ctx context.Context, plan *LessonPlan, workers []WorkerResult) ([]WorkerResult, error)
}

// NoOpVisualStage triển khai mặc định khi chưa kích hoạt vẽ hình hoặc bài Đại số thuần
type NoOpVisualStage struct{}

// NewNoOpVisualStage khởi tạo NoOp stage
func NewNoOpVisualStage() *NoOpVisualStage {
	return &NoOpVisualStage{}
}

// Enrich giữ nguyên danh sách WorkerResult mà không can thiệp gì
func (n *NoOpVisualStage) Enrich(ctx context.Context, plan *LessonPlan, workers []WorkerResult) ([]WorkerResult, error) {
	_ = ctx
	_ = plan
	return workers, nil
}
