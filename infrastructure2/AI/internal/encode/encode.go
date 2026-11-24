package encode

import (
	"encoding/base64"
	"errors"
	"fmt"
	"path/filepath"
	"strings"

	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

// MaterialsToSpecs converts domain StudyMaterial entries into raw.MaterialSpec items.
func MaterialsToSpecs(materials []lesson.StudyMaterial) ([]raw.MaterialSpec, error) {
	if len(materials) == 0 {
		return nil, errors.New("study materials must not be empty")
	}

	specs := make([]raw.MaterialSpec, 0, len(materials))
	pdfIdx := 1
	ytIdx := 1

	for _, m := range materials {
		if m == nil {
			continue
		}
		switch src := m.(type) {
		case lesson.PDFMaterial:
			specs = append(specs, raw.MaterialSpec{
				Kind:     raw.MaterialPDF,
				ID:       fmt.Sprintf("DOC_PDF_%d", pdfIdx),
				Name:     filepath.Base(src.FilePath()),
				FilePath: src.FilePath(),
			})
			pdfIdx++
		case lesson.YouTubeMaterial:
			specs = append(specs, raw.MaterialSpec{
				Kind: raw.MaterialYouTube,
				ID:   fmt.Sprintf("DOC_YOUTUBE_%d", ytIdx),
				Name: "YouTube: " + src.SourceURL(),
				URL:  src.SourceURL(),
			})
			ytIdx++
		case lesson.MistakeMaterial:
			specs = append(specs, raw.MaterialSpec{
				Kind: raw.MaterialMistake,
				ID:   "DOC_MISTAKE",
				Name: "mistake_context.txt",
				Text: formatMistakeText(src),
			})
		}
	}

	if len(specs) == 0 {
		return nil, errors.New("no valid study materials provided")
	}
	return specs, nil
}

// DefaultModelConfig returns default GenerationConfig tuned for the given model variant.
func DefaultModelConfig(model string, maxTokens int) raw.GenerationConfig {
	if maxTokens <= 0 {
		if strings.Contains(strings.ToLower(model), "chat") {
			maxTokens = 8192
		} else {
			maxTokens = 64000
		}
	}
	return raw.GenerationConfig{
		Temperature:    0.2,
		MaxTokens:      maxTokens,
		ResponseFormat: &raw.ResponseFormatConfig{Type: "json_object"},
	}
}

// ChatRequest encodes an LLMRequest into a wire-ready ChatRequest honoring DeepSeek prefix caching.
func ChatRequest(req raw.LLMRequest) (raw.ChatRequest, error) {
	sysPrompt := strings.TrimSpace(req.SystemPrompt)
	userPrompt := strings.TrimSpace(req.UserPrompt)
	if sysPrompt == "" && userPrompt == "" && len(req.Documents) == 0 {
		return raw.ChatRequest{}, errors.New("LLMRequest must not be empty")
	}

	model := strings.TrimSpace(req.Model)
	if model == "" {
		model = "deepseek-chat"
	}

	cfg := resolveGenerationConfig(model, req.Config)
	messages := buildMessages(sysPrompt, userPrompt, req.Documents)

	return raw.ChatRequest{
		Model:          model,
		Messages:       messages,
		Temperature:    cfg.Temperature,
		MaxTokens:      cfg.MaxTokens,
		ResponseFormat: cfg.ResponseFormat,
		Thinking:       cfg.Thinking,
		Stream:         cfg.Stream,
	}, nil
}

func formatMistakeText(src lesson.MistakeMaterial) string {
	var sb strings.Builder
	sb.WriteString(fmt.Sprintf("Chủ đề cần khắc phục: %s\nNguyên nhân: %s", src.Topic(), src.Reason()))
	for _, item := range src.Context() {
		sb.WriteString(fmt.Sprintf("\n- %s: %s", item.Topic, item.Reason))
	}
	return sb.String()
}

func resolveGenerationConfig(model string, override *raw.GenerationConfig) raw.GenerationConfig {
	cfg := DefaultModelConfig(model, 0)
	if override != nil {
		cfg.Temperature = override.Temperature
		cfg.Stream = override.Stream
		if override.MaxTokens > 0 {
			cfg.MaxTokens = override.MaxTokens
		}
		if override.ResponseFormat != nil {
			cfg.ResponseFormat = override.ResponseFormat
		}
		if override.Thinking != nil {
			cfg.Thinking = override.Thinking
		}
	}
	if strings.Contains(strings.ToLower(model), "flash") &&
		cfg.Thinking == nil &&
		cfg.ResponseFormat != nil &&
		cfg.ResponseFormat.Type == "json_object" {
		cfg.Thinking = &raw.ThinkingConfig{Type: "disabled"}
	}
	return cfg
}

func buildMessages(sysPrompt, userPrompt string, docs []raw.Document) []raw.ChatMessage {
	var messages []raw.ChatMessage
	if sysPrompt != "" {
		messages = append(messages, raw.ChatMessage{
			Role:    "system",
			Content: sysPrompt,
		})
	}

	imageParts, textDocs := partitionDocumentParts(docs)
	if len(imageParts) > 0 {
		parts := make([]raw.ContentPart, 0, len(imageParts)+2)
		parts = append(parts, imageParts...)
		if textDocs != "" {
			parts = append(parts, raw.ContentPart{Type: "text", Text: textDocs})
		}
		if userPrompt != "" {
			parts = append(parts, raw.ContentPart{Type: "text", Text: userPrompt})
		}
		messages = append(messages, raw.ChatMessage{Role: "user", Content: parts})
		return messages
	}

	combined := combineText(textDocs, userPrompt)
	if combined != "" {
		messages = append(messages, raw.ChatMessage{Role: "user", Content: combined})
	}
	return messages
}

func partitionDocumentParts(docs []raw.Document) (imageParts []raw.ContentPart, textDocs string) {
	var textBuf strings.Builder

	for _, doc := range docs {
		for _, part := range doc.Parts {
			mime := strings.ToLower(strings.TrimSpace(part.MimeType))
			if strings.HasPrefix(mime, "image/") && len(part.Data) > 0 {
				b64 := base64.StdEncoding.EncodeToString(part.Data)
				imageParts = append(imageParts, raw.ContentPart{
					Type:     "image_url",
					ImageURL: &raw.ImageURL{URL: "data:image/jpeg;base64," + b64},
				})
				continue
			}
			body := part.Text
			if body == "" && len(part.Data) > 0 {
				body = string(part.Data)
			}
			if strings.TrimSpace(body) != "" {
				textBuf.WriteString(fmt.Sprintf("\n--- TÀI LIỆU [%s] %s ---\n%s\n", doc.ID, doc.Name, body))
			}
		}
	}
	return imageParts, textBuf.String()
}

func combineText(prefix, prompt string) string {
	switch {
	case prefix != "" && prompt != "":
		return prefix + "\n" + prompt
	case prefix != "":
		return prefix
	default:
		return prompt
	}
}
