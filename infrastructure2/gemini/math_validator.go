package gemini

// =============================================================================
// MATH VALIDATOR: KIỂM TOÁN CÚ PHÁP TOÁN HỌC & PRE-AUDIT TẬP TRUNG
// =============================================================================

// MathValidator interface kiểm tra tính hợp lệ của cú pháp toán (dấu $, mã điều khiển ASCII rác, LaTeX trần)
type MathValidator interface {
	// ValidateText kiểm tra 1 chuỗi văn bản đơn lẻ
	ValidateText(text string) (bool, string)
	// AuditRegistry quét toàn bộ ô nhớ trong SlotRegistry để tìm các trường bị hỏng
	AuditRegistry(registry SlotRegistry) []ValidationIssue
}

// DefaultMathValidator kiểm tra tính hợp lệ của công thức toán học
type DefaultMathValidator struct{}

// NewDefaultMathValidator khởi tạo validator mặc định
func NewDefaultMathValidator() *DefaultMathValidator {
	return &DefaultMathValidator{}
}

// ValidateText: Kiểm tra cú pháp toán học của một chuỗi đơn lẻ.
// - text: Chuỗi văn bản cần kiểm tra
// - Trả về: (hợp lệ: bool, lý do lỗi: string)
// Quy tắc kiểm tra:
// 1. Kiểm tra mã điều khiển ASCII rác (\f, \b, \v) sinh ra do lỗi escape JSON.
// 2. Kiểm tra tính cân bằng của cặp dấu $ (số lượng $ phải là số chẵn).
// 3. Kiểm tra các lệnh LaTeX trần (\frac, \vec...) nằm ngoài cặp dấu $.
func (v *DefaultMathValidator) ValidateText(text string) (bool, string) {
	return AuditMathField(text)
}

// AuditRegistry: Quét toàn bộ ô nhớ trong SlotRegistry để tìm các trường bị hỏng.
// - registry: Danh bạ các ô nhớ trong toàn bài học
// - Trả về: Danh sách ValidationIssue chứa ID ô nhớ và nội dung lỗi để gửi cho BatchRepairer.
func (v *DefaultMathValidator) AuditRegistry(registry SlotRegistry) []ValidationIssue {
	var issues []ValidationIssue
	for _, slot := range registry.All() {
		if slot.Value == nil {
			continue
		}
		if ok, reason := v.ValidateText(*slot.Value); !ok {
			issues = append(issues, ValidationIssue{
				SlotID:  slot.ID,
				Reason:  reason,
				Content: *slot.Value,
				Context: slot.Context,
			})
		}
	}
	return issues
}
