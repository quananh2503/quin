package html

import (
	"strings"
	"testing"
)

// Test làm sạch các phương án trắc nghiệm có công thức toán phức tạp
func TestCleanLaTeXForHTML(t *testing.T) {
	testCases := []struct {
		name     string
		input    string
		expected string
	}{
		{
			name:     `Câu 6 Đáp án A: Tập hợp có \setminus và \mathbb{Z}`,
			input:    `$D = \mathbb{R} \setminus \{k\pi, k \in \mathbb{Z}\}$`,
			expected: `D = ℝ \ {kπ, k ∈ ℤ}`,
		},
		{
			name:     `Câu 6 Đáp án B: Phân số \frac lồng trong \left\{ \right\} (Tránh lỗi ≤ft)`,
			input:    `$D = \mathbb{R} \setminus \left\{\frac{\pi}{2} + k\pi, k \in \mathbb{Z}\right\}$`,
			expected: `D = ℝ \ {π/2 + kπ, k ∈ ℤ}`,
		},
		{
			name:     `Câu 6 Đáp án C: Tập số thực ℝ`,
			input:    `$D = \mathbb{R}$`,
			expected: `D = ℝ`,
		},
		{
			name:     `Câu 7 Đáp án A: Khoảng vô cùng (-∞; +∞)`,
			input:    `$(-\infty; +\infty)$`,
			expected: `(-∞; +∞)`,
		},
		{
			name:     `Câu 3 Đáp án C: Chu kỳ hàm số phân số \frac{\pi}{2}`,
			input:    `$T = \frac{\pi}{2}$`,
			expected: `T = π/2`,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			actual := cleanLaTeXForHTML(tc.input)

			// Kiểm tra tuyệt đối không còn sót lại ký tự LaTeX thô
			if strings.Contains(actual, `\`) && !strings.Contains(actual, `\ {`) && !strings.Contains(actual, `ℝ \`) {
				t.Errorf("Vẫn còn sót dấu gạch chéo ngược LaTeX: %s", actual)
			}
			if strings.Contains(actual, "≤ft") {
				t.Errorf("BỊ LỖI ≤ft (chữ \\left bị biến thành ≤ft): %s", actual)
			}
			if strings.Contains(actual, "mathbb") {
				t.Errorf("Chưa dịch mã mathbb: %s", actual)
			}
			if strings.Contains(actual, "setminus") {
				t.Errorf("Chưa dịch mã setminus: %s", actual)
			}

			t.Logf("✅ Input:  %s", tc.input)
			t.Logf("👉 Output: %s", actual)

			if actual != tc.expected {
				t.Errorf("Kết quả chưa khớp mong đợi.\nMong đợi: %s\nThực tế:  %s", tc.expected, actual)
			}
		})
	}
}
