package main

import (
	"context"
	"fmt"
	"os"
	"strings"

	"google.golang.org/genai"
)

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

	fmt.Printf("Testing gemini-3.8-flash with PDF (%d bytes)...\n", len(pdfBytes))
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
					Text: "Hãy tóm tắt ngắn gọn: File PDF này gồm những bài tập nào, có bao nhiêu câu hỏi và chủ đề chính là gì?",
				},
			},
		},
	}, nil)

	if err != nil {
		fmt.Printf("❌ gemini-3.8-flash error: %v\n", err)
		return
	}

	if len(resp.Candidates) > 0 && resp.Candidates[0].Content != nil {
		fmt.Printf("✅ gemini-3.8-flash response:\n%s\n", resp.Candidates[0].Content.Parts[0].Text)
	}
}
