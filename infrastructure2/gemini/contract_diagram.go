package gemini

// =============================================================================
// CONTRACT: ĐẶC TẢ HÌNH VẼ & MINH HỌA (DIAGRAM & VISUAL SPECIFICATION)
// Đón đầu tính năng Stage 2.5: VisualEnrichmentStage (CeTZ Vector & PDF Image Crop)
// =============================================================================

// DiagramType định nghĩa phân loại nguồn gốc hình vẽ
type DiagramType string

const (
	// DiagramTypeCeTZ: Mã vẽ vector native của Typst (#cetz.canvas) do LLM code
	DiagramTypeCeTZ DiagramType = "cetz"

	// DiagramTypeImage: Hình ảnh cắt trực tiếp từ file PDF nguồn
	DiagramTypeImage DiagramType = "image"
)

// DiagramSpec chứa thông số hình minh họa cho một bài tập hoặc ví dụ
type DiagramSpec struct {
	Type      DiagramType `json:"type"`                 // "cetz" hoặc "image"
	Code      string      `json:"code,omitempty"`       // Đoạn mã Typst CeTZ: #cetz.canvas(...)
	AssetPath string      `json:"asset_path,omitempty"` // Đường dẫn tương đối đến file ảnh đã crop
	Caption   string      `json:"caption,omitempty"`    // Chú thích hình (VD: "Hình 1. Hình chóp S.ABCD")
	WidthPct  int         `json:"width_pct,omitempty"`  // Độ rộng phần trăm trên trang Typst (VD: 60, 80)
}
