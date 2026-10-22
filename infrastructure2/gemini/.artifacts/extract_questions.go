package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strings"

	"google.golang.org/genai"
)

type ExtractedQuestion struct {
	ID          string `json:"id"`
	Part        string `json:"part"`
	ProblemText string `json:"problem_text"`
	HasGeometry bool   `json:"has_geometry"`
}

func main() {
	ctx := context.Background()
	keyData, _ := os.ReadFile("infrastructure2/gemini/key1.txt")
	apiKey := strings.TrimSpace(string(keyData))

	client, err := genai.NewClient(ctx, &genai.ClientConfig{
		APIKey:  apiKey,
		Backend: genai.BackendGeminiAPI,
	})
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		return
	}

	pdfBytes, err := os.ReadFile("infrastructure2/gemini/pdfs/ÔN VEC TƠ KG 10T10.pdf")
	if err != nil {
		fmt.Printf("Error reading PDF: %v\n", err)
		return
	}

	prompt := `Bạn được cung cấp tài liệu ôn tập "ÔN VEC TƠ KG 10T10.pdf".
Hãy quét qua toàn bộ tài liệu và trích xuất danh sách tất cả các bài tập/câu hỏi CÓ YẾU TỐ HÌNH HỌC KHÔNG GIAN (tứ diện, hình chóp, hình hộp, hình lập phương, lăng trụ, hoặc bài toán lực vật lý không gian).
Bỏ qua các câu thuần lý thuyết vectơ trừu tượng không gắn với hình khối cụ thể.

Trả về mảng JSON các câu:
[
  {
    "id": "Câu 1 (Phần C)",
    "part": "C",
    "problem_text": "Nội dung đầy đủ đề bài...",
    "has_geometry": true
  }
]`

	fmt.Println("Extracting geometry questions from PDF...")
	resp, err := client.Models.GenerateContent(ctx, "gemini-3.8-flash", []*genai.Content{
		{
			Parts: []*genai.Part{
				{
					InlineData: &genai.Blob{
						MIMEType: "application/pdf",
						Data:     pdfBytes,
					},
				},
				{
					Text: prompt,
				},
			},
		},
	}, &genai.GenerateContentConfig{
		ResponseMIMEType: "application/json",
	})

	if err != nil {
		fmt.Printf("Error extracting questions: %v\n", err)
		return
	}

	if len(resp.Candidates) > 0 && resp.Candidates[0].Content != nil {
		raw := resp.Candidates[0].Content.Parts[0].Text
		_ = os.WriteFile("infrastructure2/gemini/.artifacts/extracted_vector_questions.json", []byte(raw), 0644)
		var questions []ExtractedQuestion
		_ = json.Unmarshal([]byte(raw), &questions)
		fmt.Printf("✅ Đã trích xuất thành công %d câu hỏi hình học không gian từ PDF!\n", len(questions))
		for i, q := range questions {
			if i < 5 {
				fmt.Printf("- [%s]: %s\n", q.ID, q.ProblemText[:min(80, len(q.ProblemText))])
			}
		}
	}
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
