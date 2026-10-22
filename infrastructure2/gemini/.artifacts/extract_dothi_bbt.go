package main

import (
	"context"
	"fmt"
	"os"
	"strings"

	"google.golang.org/genai"
)

func loadKeys() []string {
	var keys []string
	seen := make(map[string]bool)
	for _, fn := range []string{
		"infrastructure2/gemini/key1.txt",
		"infrastructure2/gemini/key2.txt",
		"infrastructure2/gemini/key3.txt",
		"infrastructure2/gemini/key4.txt",
		"infrastructure2/gemini/key5.txt",
		"infrastructure2/gemini/key.txt",
	} {
		data, err := os.ReadFile(fn)
		if err == nil {
			k := strings.TrimSpace(string(data))
			if k != "" && !seen[k] {
				seen[k] = true
				keys = append(keys, k)
			}
		}
	}
	if envKey := strings.TrimSpace(os.Getenv("GEMINI_API_KEY")); envKey != "" && !seen[envKey] {
		seen[envKey] = true
		keys = append(keys, envKey)
	}
	return keys
}

func main() {
	ctx := context.Background()
	keys := loadKeys()
	if len(keys) == 0 {
		fmt.Println("❌ Không tìm thấy API key")
		return
	}

	pdfPath := "infrastructure2/gemini/pdfs/tests/testdothibbt.pdf"
	data, err := os.ReadFile(pdfPath)
	if err != nil {
		fmt.Printf("❌ Lỗi đọc file PDF: %v\n", err)
		return
	}
	fmt.Printf("📖 Đã đọc file PDF testdothibbt.pdf (%d bytes)\n", len(data))

	prompt := `Bạn được cung cấp file tài liệu PDF 'testdothibbt.pdf' về Đồ thị hàm số và Bảng biến thiên (BBT).
Hãy quét tài liệu và trích xuất:
1. ĐÚNG 5 BÀI TOÁN CÓ ĐỒ THỊ TIÊU BIỂU thuộc 5 DẠNG KHÁC NHAU:
   - Dạng 1: Hàm số bậc 3 (ví dụ: y = ax^3 + bx^2 + cx + d có 2 điểm cực trị hoặc đồng biến/nghịch biến).
   - Dạng 2: Hàm số bậc 4 trùng phương (ví dụ: y = ax^4 + bx^2 + c có 3 điểm cực trị hoặc 1 cực trị).
   - Dạng 3: Hàm số phân thức bậc nhất / bậc nhất (y = (ax+b)/(cx+d) có tiệm cận đứng, tiệm cận ngang).
   - Dạng 4: Hàm số phân thức bậc hai / bậc nhất (y = (ax^2+bx+c)/(dx+e) có tiệm cận xiên và tiệm cận đứng) HOẶC Đồ thị hàm số Parabol bậc 2 / Hàm số chứa trị tuyệt đối.
   - Dạng 5: Đồ thị đạo hàm y = f'(x) hoặc đồ thị đặc biệt khác trong đề.

2. ĐÚNG 3 BÀI TOÁN CÓ BẢNG BIẾN THIÊN (BBT) TIÊU BIỂU thuộc 3 LOẠI KHÁC NHAU:
   - Loại 1: BBT của hàm đa thức bậc 3 (có 2 cực đại, cực tiểu, đổi dấu + sang - sang +).
   - Loại 2: BBT của hàm phân thức hữu tỉ có điểm gián đoạn (tiệm cận đứng với ký hiệu 2 gạch thẳng đứng || ở dòng y' và y, giới hạn ra + vô cùng và - vô cùng).
   - Loại 3: BBT của hàm bậc 4 trùng phương (có 3 điểm cực trị uốn lượn) hoặc hàm số có đạo hàm không xác định tại 1 điểm.

Đối với MỖI BÀI TOÁN, hãy ghi rõ:
- Tên mục: [ĐỒ THỊ 1], [ĐỒ THỊ 2], ... [BBT 1], [BBT 2], [BBT 3]
- Đề bài nguyên văn
- Phương trình hàm số cụ thể (hoặc dạng hàm số nếu đề cho ẩn số)
- Tọa độ các điểm đặc biệt: điểm cực trị, giao điểm trục Ox, Oy, phương trình các đường tiệm cận đứng/ngang/xiên
- Đối với BBT: Giá trị dòng x, các dấu và số 0 hoặc || ở dòng y', chiều biến thiên và giá trị ở dòng y.

Định dạng xuất chuẩn Markdown có phân cách '---' giữa các bài để dễ parse.
`

	var extractedText string
	for _, key := range keys {
		client, err := genai.NewClient(ctx, &genai.ClientConfig{
			APIKey:  key,
			Backend: genai.BackendGeminiAPI,
		})
		if err != nil {
			continue
		}

		fmt.Printf("⏳ Đang gọi Gemini Flash với key %s... để quét PDF testdothibbt.pdf\n", key[:8])
		resp, err := client.Models.GenerateContent(ctx, "gemini-3.8-flash", []*genai.Content{
			{
				Parts: []*genai.Part{
					{
						InlineData: &genai.Blob{
							MIMEType: "application/pdf",
							Data:     data,
						},
					},
					{
						Text: prompt,
					},
				},
			},
		}, nil)
		if err != nil {
			fmt.Printf("⚠️ Lỗi gọi API: %v, thử key tiếp theo...\n", err)
			continue
		}
		if len(resp.Candidates) > 0 && resp.Candidates[0].Content != nil {
			for _, p := range resp.Candidates[0].Content.Parts {
				extractedText += p.Text
			}
			if extractedText != "" {
				fmt.Println("✅ Trích xuất thành công nội dung từ testdothibbt.pdf!")
				break
			}
		}
	}

	if extractedText == "" {
		fmt.Println("❌ Không thể trích xuất nội dung từ PDF")
		return
	}

	outPath := "infrastructure2/gemini/.artifacts/extracted_dothi_bbt.txt"
	_ = os.WriteFile(outPath, []byte(extractedText), 0644)
	fmt.Printf("💾 Đã lưu kết quả trích xuất vào: %s\n", outPath)
}
