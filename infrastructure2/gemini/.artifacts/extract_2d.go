package main

import (
	"context"
	"fmt"
	"os"
	"strings"

	"google.golang.org/genai"
)

func loadKey() string {
	for _, fn := range []string{"infrastructure2/gemini/key1.txt", "infrastructure2/gemini/key.txt"} {
		data, err := os.ReadFile(fn)
		if err == nil {
			k := strings.TrimSpace(string(data))
			if k != "" {
				return k
			}
		}
	}
	return os.Getenv("GEMINI_API_KEY")
}

func main() {
	ctx := context.Background()
	apiKey := loadKey()
	if apiKey == "" {
		fmt.Println("❌ Không tìm thấy API key")
		return
	}

	client, err := genai.NewClient(ctx, &genai.ClientConfig{
		APIKey:  apiKey,
		Backend: genai.BackendGeminiAPI,
	})
	if err != nil {
		fmt.Printf("❌ Lỗi khởi tạo client: %v\n", err)
		return
	}

	// 1. Quét PDF Toán 8
	pdf8Path := "infrastructure2/gemini/pdfs/tests/thuvienhoclieu.com-De-cuong-on-tap-Hinh-hoc-8-trong-he.pdf"
	data8, err := os.ReadFile(pdf8Path)
	if err != nil {
		fmt.Printf("❌ Lỗi đọc PDF Toán 8: %v\n", err)
		return
	}
	fmt.Printf("📖 Đã đọc file PDF Toán 8 (%d bytes)\n", len(data8))

	prompt8 := `Bạn được cung cấp file đề cương ôn tập hình học lớp 8.
Hãy trích xuất CHÍNH XÁC VÀ ĐẦY ĐỦ 5 BÀI TOÁN HÌNH HỌC TỰ LUẬN ĐẦU TIÊN trong tài liệu (bao gồm cả đề bài và tất cả các câu hỏi nhỏ/ý a, b, c, d nếu có).
Định dạng xuất:
---
BÀI 1 (LỚP 8):
[Nội dung đề bài chi tiết kèm các ý a, b, c...]

BÀI 2 (LỚP 8):
...
`

	fmt.Println("⏳ Đang quét 5 bài đầu tiên từ PDF Toán 8...")
	resp8, err := client.Models.GenerateContent(ctx, "gemini-3.8-flash", []*genai.Content{
		{
			Parts: []*genai.Part{
				{
					InlineData: &genai.Blob{
						MIMEType: "application/pdf",
						Data:     data8,
					},
				},
				{
					Text: prompt8,
				},
			},
		},
	}, nil)

	if err != nil {
		fmt.Printf("❌ Lỗi gọi Gemini cho Toán 8: %v\n", err)
		return
	}

	text8 := ""
	if len(resp8.Candidates) > 0 && resp8.Candidates[0].Content != nil {
		for _, p := range resp8.Candidates[0].Content.Parts {
			text8 += p.Text
		}
	}
	fmt.Println("✅ Đã trích xuất xong 5 bài Toán 8!")

	// 2. Quét PDF Toán 9
	pdf9Path := "infrastructure2/gemini/pdfs/tests/thuvienhoclieu.com-TOAN-9-TUYEN-SINH-10-CHU-DE-8.-CAC-BAI-TOAN-HINH-HOC.pdf"
	data9, err := os.ReadFile(pdf9Path)
	if err != nil {
		fmt.Printf("❌ Lỗi đọc PDF Toán 9: %v\n", err)
		return
	}
	fmt.Printf("📖 Đã đọc file PDF Toán 9 (%d bytes)\n", len(data9))

	prompt9 := `Bạn được cung cấp file tuyển sinh 10 chuyên đề 8 các bài toán hình học lớp 9.
Hãy trích xuất CHÍNH XÁC VÀ ĐẦY ĐỦ 5 BÀI TOÁN HÌNH HỌC ĐẦU TIÊN trong tài liệu (bao gồm cả đề bài và tất cả các câu hỏi nhỏ/ý a, b, c, d nếu có).
Định dạng xuất:
---
BÀI 1 (LỚP 9):
[Nội dung đề bài chi tiết kèm các ý a, b, c...]

BÀI 2 (LỚP 9):
...
`

	fmt.Println("⏳ Đang quét 5 bài đầu tiên từ PDF Toán 9...")
	resp9, err := client.Models.GenerateContent(ctx, "gemini-3.8-flash", []*genai.Content{
		{
			Parts: []*genai.Part{
				{
					InlineData: &genai.Blob{
						MIMEType: "application/pdf",
						Data:     data9,
					},
				},
				{
					Text: prompt9,
				},
			},
		},
	}, nil)

	if err != nil {
		fmt.Printf("❌ Lỗi gọi Gemini cho Toán 9: %v\n", err)
		return
	}

	text9 := ""
	if len(resp9.Candidates) > 0 && resp9.Candidates[0].Content != nil {
		for _, p := range resp9.Candidates[0].Content.Parts {
			text9 += p.Text
		}
	}
	fmt.Println("✅ Đã trích xuất xong 5 bài Toán 9!")

	// Ghi vào file .txt chung
	outTxt := fmt.Sprintf("=================================================================\n"+
		"DANH SÁCH 10 BÀI TOÁN HÌNH HỌC 2D (5 BÀI LỚP 8 + 5 BÀI LỚP 9)\n"+
		"Trích xuất từ thư mục pdfs/tests/\n"+
		"=================================================================\n\n"+
		"### PHẦN 1: 5 BÀI HÌNH HỌC LỚP 8 (Tứ giác, Hình thang, Hình bình hành, Hình chữ nhật, Tam giác đồng dạng)\n\n%s\n\n"+
		"=================================================================\n"+
		"### PHẦN 2: 5 BÀI HÌNH HỌC LỚP 9 (Đường tròn, Tiếp tuyến, Tứ giác nội tiếp, Cát tuyến)\n\n%s\n",
		strings.TrimSpace(text8), strings.TrimSpace(text9))

	outFile := "infrastructure2/gemini/.artifacts/extracted_2d_questions.txt"
	_ = os.WriteFile(outFile, []byte(outTxt), 0644)
	fmt.Printf("🎉 ĐÃ GHI THÀNH CÔNG 10 BÀI TOÁN VÀO FILE: %s\n", outFile)
}
