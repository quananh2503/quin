package deepseek_test

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"meet-attendance-clean/infrastructure2/AI/deepseek"
)

func TestClient_PostChatCompletion_Success(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Header.Get("Authorization") != "Bearer test-key" {
			http.Error(w, "unauthorized", http.StatusUnauthorized)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		_, err := w.Write([]byte(`{
			"id": "chatcmpl-123",
			"choices": [
				{
					"index": 0,
					"message": {
						"role": "assistant",
						"content": "{\"lesson_title\": \"Đạo hàm\", \"topics\": []}"
					},
					"finish_reason": "stop"
				}
			],
			"usage": {
				"prompt_tokens": 100,
				"completion_tokens": 50,
				"total_tokens": 150,
				"prompt_cache_hit_tokens": 80,
				"prompt_cache_miss_tokens": 20
			}
		}`))
		if err != nil {
			t.Errorf("write response thất bại: %v", err)
		}
	}))
	defer ts.Close()

	cli := deepseek.NewClient("test-key", ts.URL)
	req := &deepseek.ChatRequest{
		Model: "deepseek-flash",
		Messages: []deepseek.ChatMessage{
			{Role: "user", Content: "Hello"},
		},
	}
	resp, raw, err := cli.PostChatCompletion(context.Background(), req)
	if err != nil {
		t.Fatalf("PostChatCompletion thất bại: %v", err)
	}

	if len(resp.Choices) == 0 {
		t.Fatalf("Choices rỗng")
	}
	if resp.Choices[0].Message.Content != `{"lesson_title": "Đạo hàm", "topics": []}` {
		t.Errorf("Nội dung phản hồi không khớp: %s", resp.Choices[0].Message.Content)
	}
	if resp.Usage == nil || resp.Usage.PromptCacheHitTokens != 80 {
		t.Errorf("Usage prompt cache hit tokens sai: %v", resp.Usage)
	}
	if len(raw) == 0 {
		t.Errorf("raw response bytes rỗng")
	}
}

func TestClient_PostChatCompletion_Unauthorized(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		http.Error(w, `{"error":{"message":"invalid api key","type":"auth_error","code":"invalid_api_key"}}`, http.StatusUnauthorized)
	}))
	defer ts.Close()

	cli := deepseek.NewClient("invalid-key", ts.URL)
	req := &deepseek.ChatRequest{
		Model: "deepseek-flash",
	}
	_, _, err := cli.PostChatCompletion(context.Background(), req)
	if err == nil {
		t.Fatalf("Kỳ vọng lỗi Unauthorized nhưng lại thành công")
	}
}
