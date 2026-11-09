package deepseek_test

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/AI/deepseek"
)

func TestProvider_Generate_Success(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		body, errRead := io.ReadAll(r.Body)
		if errRead != nil {
			http.Error(w, "cannot read body", http.StatusBadRequest)
			return
		}

		var chatReq deepseek.ChatRequest
		if errUnmarshal := json.Unmarshal(body, &chatReq); errUnmarshal != nil {
			http.Error(w, "bad json", http.StatusBadRequest)
			return
		}

		// Kiểm tra model
		if chatReq.Model != "deepseek-flash" {
			t.Errorf("Model không đúng: %s", chatReq.Model)
		}

		// Kiểm tra Thinking mode cho flash mặc định tắt khi có json_object
		if chatReq.Thinking == nil || chatReq.Thinking.Type != "disabled" {
			t.Errorf("Thinking mode phải là disabled cho flash json_object: %v", chatReq.Thinking)
		}

		w.Header().Set("Content-Type", "application/json")
		_, errWrite := w.Write([]byte(`{
			"id": "test-id",
			"choices": [
				{
					"index": 0,
					"message": {
						"role": "assistant",
						"content": "<think>Tôi đang suy nghĩ...</think>{\"lesson_title\": \"Hình học Oxyz\", \"topics\": []}"
					},
					"finish_reason": "stop"
				}
			],
			"usage": {
				"prompt_tokens": 500,
				"completion_tokens": 100,
				"total_tokens": 600,
				"prompt_cache_hit_tokens": 400
			}
		}`))
		if errWrite != nil {
			t.Errorf("write response thất bại: %v", errWrite)
		}
	}))
	defer ts.Close()

	cli := deepseek.NewClient("test-key", ts.URL)
	prov := deepseek.NewProvider("test-key", "deepseek-flash").WithClient(cli)

	doc := ai.NewDocument("DOC_1", "test.txt", ai.NewTextPart("Nội dung tài liệu ôn tập"))
	req := ai.Request{
		Model:      "deepseek-flash",
		UserPrompt: "Hãy chia dạng toán",
		Documents:  []ai.Document{doc},
	}

	resp, errGen := prov.Generate(context.Background(), req)
	if errGen != nil {
		t.Fatalf("Generate thất bại: %v", errGen)
	}

	// Đảm bảo thẻ <think> đã bị lột bỏ khỏi Content
	if strings.Contains(resp.Content, "<think>") {
		t.Errorf("Content chưa lột bỏ thẻ think: %s", resp.Content)
	}
	if resp.Content != `{"lesson_title": "Hình học Oxyz", "topics": []}` {
		t.Errorf("Content không đúng: %s", resp.Content)
	}

	// Kiểm tra Usage Raw JSON
	if resp.Usage == nil || resp.Usage.Raw() == "" {
		t.Fatalf("Usage rỗng")
	}

	dsUsage, errParse := deepseek.ParseUsage(resp.Usage.Raw())
	if errParse != nil {
		t.Fatalf("ParseUsage thất bại: %v", errParse)
	}
	if dsUsage.PromptCacheHitTokens != 400 {
		t.Errorf("PromptCacheHitTokens sai: %d", dsUsage.PromptCacheHitTokens)
	}
}
