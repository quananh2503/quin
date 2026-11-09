package gemini

import (
	"context"
	"fmt"
	"strings"
	"testing"
	"time"

	"google.golang.org/genai"
)

func TestListAvailableModels(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()

	cli, err := genai.NewClient(ctx, &genai.ClientConfig{
		APIKey:  strings.TrimSpace(embeddedKey3),
		Backend: genai.BackendGeminiAPI,
	})
	if err != nil {
		t.Fatalf("Không thể tạo client: %v", err)
	}

	pager, err := cli.Models.List(ctx, nil)
	if err != nil {
		t.Fatalf("Lỗi ListModels: %v", err)
	}

	fmt.Println("DANH SÁCH CÁC MODEL KHẢ DỤNG CHO API KEY:")
	count := 0
	for _, m := range pager.Items {
		if strings.Contains(m.Name, "gemini") || strings.Contains(m.Name, "gemma") {
			fmt.Printf(" - %s (DisplayName: %s)\n", m.Name, m.DisplayName)
			count++
		}
	}
	fmt.Printf("Tổng cộng: %d models\n", count)
}
