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
	keyData, err := os.ReadFile("infrastructure2/gemini/key1.txt")
	if err != nil {
		fmt.Printf("Error reading key: %v\n", err)
		return
	}
	apiKey := strings.TrimSpace(string(keyData))

	client, err := genai.NewClient(ctx, &genai.ClientConfig{
		APIKey:  apiKey,
		Backend: genai.BackendGeminiAPI,
	})
	if err != nil {
		fmt.Printf("Error creating client: %v\n", err)
		return
	}

	pdfBytes, err := os.ReadFile("infrastructure2/gemini/pdfs/ÔN VEC TƠ KG 10T10.pdf")
	if err != nil {
		fmt.Printf("Error reading PDF: %v\n", err)
		return
	}
	fmt.Printf("Read PDF successfully, size: %d bytes\n", len(pdfBytes))

	// Test 1: gemma-4-31b-it with PDF
	fmt.Println("Testing gemma-4-31b-it with PDF inline data...")
	resp, err := client.Models.GenerateContent(ctx, "gemma-4-31b-it", []*genai.Content{
		{
			Parts: []*genai.Part{
				{
					InlineData: &genai.Blob{
						MIMEType: "application/pdf",
						Data:     pdfBytes,
					},
				},
				{
					Text: "Tài liệu PDF này có bao nhiêu trang và tiêu đề là gì? Hãy trả lời ngắn gọn trong 1 câu.",
				},
			},
		},
	}, nil)

	if err != nil {
		fmt.Printf("❌ gemma-4-31b-it error with PDF: %v\n", err)
		
		// Test 2: Try gemini-2.5-flash
		fmt.Println("Testing gemini-2.5-flash with PDF inline data...")
		respFlash, errFlash := client.Models.GenerateContent(ctx, "gemini-2.5-flash", []*genai.Content{
			{
				Parts: []*genai.Part{
					{
						InlineData: &genai.Blob{
							MIMEType: "application/pdf",
							Data:     pdfBytes,
						},
					},
					{
						Text: "Tài liệu PDF này có bao nhiêu trang và tiêu đề là gì? Hãy trả lời ngắn gọn trong 1 câu.",
					},
				},
			},
		}, nil)
		if errFlash != nil {
			fmt.Printf("❌ gemini-2.5-flash error with PDF: %v\n", errFlash)
		} else {
			if len(respFlash.Candidates) > 0 && respFlash.Candidates[0].Content != nil {
				fmt.Printf("✅ gemini-2.5-flash response: %s\n", respFlash.Candidates[0].Content.Parts[0].Text)
			}
		}
	} else {
		if len(resp.Candidates) > 0 && resp.Candidates[0].Content != nil {
			fmt.Printf("✅ gemma-4-31b-it response: %s\n", resp.Candidates[0].Content.Parts[0].Text)
		}
	}
}
