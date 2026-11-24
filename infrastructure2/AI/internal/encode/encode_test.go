package encode_test

import (
	"encoding/base64"
	"strings"
	"testing"

	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/AI/internal/encode"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
	"uuid"
)

func TestMaterialsToSpecs(t *testing.T) {
	pdfFull, err := lesson.NewFullPDFMaterial("/tmp/sgk_toan12.pdf")
	if err != nil {
		t.Fatalf("NewFullPDFMaterial failed: %v", err)
	}
	pdfSliced, err := lesson.NewSlicedPDFMaterial("/tmp/de_thi.pdf", []int{1, 2})
	if err != nil {
		t.Fatalf("NewSlicedPDFMaterial failed: %v", err)
	}
	yt, err := lesson.NewYouTubeMaterial("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
	if err != nil {
		t.Fatalf("NewYouTubeMaterial failed: %v", err)
	}
	mistake := lesson.NewMistakeMaterial(
		uuid.New(),
		uuid.New(),
		"Tích vô hướng",
		"Nhầm dấu cos góc tù",
		[]lesson.MistakeItem{{Topic: "Vectơ", Reason: "Quên đổi dấu"}},
	)

	t.Run("FullPayload_AllMaterialTypes", func(t *testing.T) {
		specs, errSpec := encode.MaterialsToSpecs([]lesson.StudyMaterial{pdfFull, pdfSliced, yt, mistake})
		if errSpec != nil {
			t.Fatalf("MaterialsToSpecs failed: %v", errSpec)
		}
		if len(specs) != 4 {
			t.Fatalf("got %d specs, want 4", len(specs))
		}
		if specs[0].Kind != raw.MaterialPDF || specs[0].FilePath != "/tmp/sgk_toan12.pdf" {
			t.Errorf("unexpected PDF spec: %+v", specs[0])
		}
		if specs[2].Kind != raw.MaterialYouTube || specs[2].URL == "" {
			t.Errorf("unexpected YouTube spec: %+v", specs[2])
		}
		if specs[3].Kind != raw.MaterialMistake || !strings.Contains(specs[3].Text, "Nhầm dấu cos góc tù") {
			t.Errorf("unexpected Mistake spec: %+v", specs[3])
		}
	})

	t.Run("InvalidEmptyOrNilMaterials", func(t *testing.T) {
		if _, err := encode.MaterialsToSpecs(nil); err == nil {
			t.Fatal("expected error for nil materials")
		}
		if _, err := encode.MaterialsToSpecs([]lesson.StudyMaterial{nil}); err == nil {
			t.Fatal("expected error when all materials are nil")
		}
	})
}

func TestDefaultModelConfig(t *testing.T) {
	chatCfg := encode.DefaultModelConfig("deepseek-chat", 0)
	if chatCfg.MaxTokens != 8192 {
		t.Errorf("deepseek-chat MaxTokens = %d, want 8192", chatCfg.MaxTokens)
	}
	flashCfg := encode.DefaultModelConfig("deepseek-flash", 0)
	if flashCfg.MaxTokens != 64000 {
		t.Errorf("deepseek-flash MaxTokens = %d, want 64000", flashCfg.MaxTokens)
	}
	customCfg := encode.DefaultModelConfig("deepseek-flash", 4096)
	if customCfg.MaxTokens != 4096 {
		t.Errorf("custom MaxTokens = %d, want 4096", customCfg.MaxTokens)
	}
}

func TestChatRequest(t *testing.T) {
	imgPayload := []byte{0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10}
	expectedB64 := "data:image/jpeg;base64," + base64.StdEncoding.EncodeToString(imgPayload)

	t.Run("FullMultimodalPayload_PrefixOrdering", func(t *testing.T) {
		req := raw.LLMRequest{
			Model:        "deepseek-flash",
			SystemPrompt: "System JSON",
			UserPrompt:   "Hãy phân tích tài liệu",
			Documents: []raw.Document{
				{
					ID:   "DOC_1",
					Name: "sgk.pdf",
					Parts: []raw.Part{
						{MimeType: "image/jpeg", Data: imgPayload},
						{MimeType: "text/plain", Text: "Nội dung định lý cosin: $\\cos\\alpha$"},
					},
				},
			},
			Config: &raw.GenerationConfig{
				Temperature:    0.1,
				MaxTokens:      16000,
				ResponseFormat: &raw.ResponseFormatConfig{Type: "json_object"},
			},
		}

		chatReq, err := encode.ChatRequest(req)
		if err != nil {
			t.Fatalf("ChatRequest failed: %v", err)
		}
		if chatReq.Model != "deepseek-flash" {
			t.Errorf("Model = %q, want deepseek-flash", chatReq.Model)
		}
		if chatReq.Thinking == nil || chatReq.Thinking.Type != "disabled" {
			t.Errorf("expected thinking disabled for flash json_object, got %+v", chatReq.Thinking)
		}
		if len(chatReq.Messages) != 2 {
			t.Fatalf("Messages count = %d, want 2", len(chatReq.Messages))
		}
		parts, ok := chatReq.Messages[1].Content.([]raw.ContentPart)
		if !ok || len(parts) < 3 {
			t.Fatalf("expected multimodal ContentPart slice (>=3), got %T (%v)", chatReq.Messages[1].Content, chatReq.Messages[1].Content)
		}
		if parts[0].Type != "image_url" || parts[0].ImageURL == nil || parts[0].ImageURL.URL != expectedB64 {
			t.Errorf("first part must be image_url prefix, got %+v", parts[0])
		}
		last := parts[len(parts)-1]
		if last.Type != "text" || !strings.Contains(last.Text, "Hãy phân tích tài liệu") {
			t.Errorf("last part must be UserPrompt, got %+v", last)
		}
	})

	t.Run("MinimalZeroValueAndBoundaryUnicode", func(t *testing.T) {
		req := raw.LLMRequest{
			UserPrompt: "Tính góc $(\\vec{u}, \\vec{v})$ với \"ngoặc\" & 'nháy'",
		}
		chatReq, err := encode.ChatRequest(req)
		if err != nil {
			t.Fatalf("ChatRequest failed: %v", err)
		}
		if chatReq.Model == "" {
			t.Error("expected default model when empty")
		}
		if len(chatReq.Messages) != 1 {
			t.Fatalf("expected only user message when SystemPrompt is empty, got %d", len(chatReq.Messages))
		}
		contentStr, ok := chatReq.Messages[0].Content.(string)
		if !ok || !strings.Contains(contentStr, "\\vec{u}") {
			t.Errorf("unexpected text message content: %v", chatReq.Messages[0].Content)
		}
	})

	t.Run("InvalidEmptyRequest", func(t *testing.T) {
		if _, err := encode.ChatRequest(raw.LLMRequest{}); err == nil {
			t.Fatal("expected error for completely empty LLMRequest")
		}
	})
}
