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

	page, err := client.Models.List(ctx, nil)
	if err != nil {
		fmt.Printf("ListModels error: %v\n", err)
		return
	}

	fmt.Println("Available models:")
	for _, m := range page.Items {
		if strings.Contains(m.Name, "flash") || strings.Contains(m.Name, "gemma") || strings.Contains(m.Name, "pro") {
			fmt.Printf("- %s (display: %s)\n", m.Name, m.DisplayName)
		}
	}
}
