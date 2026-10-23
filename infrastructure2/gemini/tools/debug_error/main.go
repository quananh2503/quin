package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strings"

	"meet-attendance-clean/infrastructure2/gemini"

	"google.golang.org/genai"
)

func main() {
	keyBytes, _ := os.ReadFile("infrastructure2/gemini/key1.txt")
	apiKey := strings.TrimSpace(string(keyBytes))

	ctx := context.Background()
	cli, _ := genai.NewClient(ctx, &genai.ClientConfig{
		APIKey:  apiKey,
		Backend: genai.BackendGeminiAPI,
	})

	nupData, err := os.ReadFile("infrastructure2/gemini/consolidated_nup8.pdf")
	if err != nil {
		fmt.Printf("Read nup8 err: %v\n", err)
		return
	}
	fmt.Printf("Consolidated N-Up-8 size: %d bytes\n", len(nupData))

	var sch genai.Schema
	_ = json.Unmarshal(gemini.GetPlannerSchemaBytes(), &sch)

	cfg := &genai.GenerateContentConfig{
		ResponseMIMEType: "application/json",
		ResponseSchema:   &sch,
		MaxOutputTokens:  8192,
		Temperature:      genai.Ptr[float32](0.2),
	}

	fmt.Println("Gửi consolidated_nup8.pdf + PlannerSchema lên gemma-4-31b-it...")
	resp, err := cli.Models.GenerateContent(ctx, "gemma-4-31b-it", []*genai.Content{
		{
			Parts: []*genai.Part{
				{InlineData: &genai.Blob{MIMEType: "application/pdf", Data: nupData}},
				{Text: "Lập danh mục các dạng toán trọng tâm chương II Hình học không gian."},
			},
		},
	}, cfg)

	if err != nil {
		fmt.Printf("FAILED: %v\n", err)
	} else {
		fmt.Printf("SUCCESS! Tokens: Prompt=%d, Candidate=%d\n",
			resp.UsageMetadata.PromptTokenCount, resp.UsageMetadata.CandidatesTokenCount)
		fmt.Printf("Response preview: %.200s...\n", resp.Text())
	}
}
