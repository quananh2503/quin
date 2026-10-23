package gemini_test

import (
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"
)

func Test_DefaultMathValidator_ValidateText(t *testing.T) {
	v := gemini.NewDefaultMathValidator()

	testCases := []struct {
		name    string
		input   string
		valid   bool
		wantErr string
	}{
		{
			name:  "Chuỗi chuẩn đầy đủ cặp dấu $",
			input: "Cho tam giác $ABC$ có cạnh $AB = 5$, góc $\\widehat{A} = 60^\\circ$.",
			valid: true,
		},
		{
			name:  "Vectơ bọc chuẩn trong $",
			input: "Ta có $\\vec{u} = \\vec{a} + \\vec{b}$ thỏa mãn điều kiện.",
			valid: true,
		},
		{
			name:    "Ký tự Form Feed ASCII rác",
			input:   "Đoạn văn có mã rác \f trong chuỗi",
			valid:   false,
			wantErr: "ASCII",
		},
		{
			name:    "Số lượng dấu $ bị lẻ",
			input:   "Cho hình hộp $ABCD có đỉnh.",
			valid:   false,
			wantErr: "lẻ",
		},
		{
			name:    "Lệnh LaTeX trần ngoài dấu $",
			input:   "Biểu thức \\vec{AB} nằm ngoài dấu đô la.",
			valid:   false,
			wantErr: "LaTeX trần",
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			ok, reason := v.ValidateText(tc.input)
			if ok != tc.valid {
				t.Errorf("ValidateText(%q) = %v (lý do: %q), kỳ vọng valid = %v", tc.input, ok, reason, tc.valid)
			}
		})
	}
}

func Test_DefaultMathValidator_AuditRegistry(t *testing.T) {
	v := gemini.NewDefaultMathValidator()
	registry := gemini.NewInMemorySlotRegistry()

	cleanText1 := "Cho hàm số $y = f(x)$ liên tục."
	brokenText := "Cho tam giác $ABC có cạnh thiếu đô la."
	cleanText2 := "Tính thể tích khối chóp."
	leakedLatex := "Ta có \\frac{1}{2} nằm ngoài đô la."

	registry.Register("slot.clean.1", "Sạch 1", &cleanText1)
	registry.Register("slot.broken.1", "Hỏng 1", &brokenText)
	registry.Register("slot.clean.2", "Sạch 2", &cleanText2)
	registry.Register("slot.broken.2", "Hỏng 2", &leakedLatex)

	issues := v.AuditRegistry(registry)

	if len(issues) != 2 {
		t.Fatalf("AuditRegistry phải bắt đúng 2 trường bị lỗi, nhưng tìm thấy %d", len(issues))
	}

	foundMap := make(map[string]bool)
	for _, iss := range issues {
		foundMap[iss.SlotID] = true
	}

	if !foundMap["slot.broken.1"] || !foundMap["slot.broken.2"] {
		t.Errorf("AuditRegistry không bắt đúng SlotID bị hỏng: %v", issues)
	}

	t.Logf("✅ MathValidator: Quét thành công danh bạ bộ nhớ và phát hiện chính xác %d lỗi vi điểm!", len(issues))
}
