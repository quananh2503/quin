package deepseek

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"image"
	"image/jpeg"
	_ "image/png"
	"regexp"
	"strings"

	"golang.org/x/image/draw"
	"meet-attendance-clean/infrastructure2/AI"
)

var thinkTagRegex = regexp.MustCompile(`(?s)<think>.*?</think>`)

// Provider triển khai interface ai.Provider dành riêng cho nhà cung cấp DeepSeek.
// Đảm bảo tuân thủ nghiêm ngặt quy tắc Prompt Caching (Prefix Caching) và Multimodal Vision.
type Provider struct {
	client       *Client
	defaultModel string
}

// NewProvider tạo một Provider DeepSeek mới.
func NewProvider(apiKey string, defaultModel string) *Provider {
	if defaultModel == "" {
		defaultModel = "deepseek-chat"
	}
	return &Provider{
		client:       NewClient(apiKey, ""),
		defaultModel: defaultModel,
	}
}

// WithClient gán Client tùy biến (dùng khi mock kiểm thử HTTP).
func (p *Provider) WithClient(c *Client) *Provider {
	if c != nil {
		p.client = c
	}
	return p
}

// Name trả về tên định danh của Provider.
func (p *Provider) Name() string {
	return "deepseek"
}

// Generate chuẩn bị payload, tối ưu Prompt Cache và gọi client để sinh nội dung.
func (p *Provider) Generate(ctx context.Context, req ai.Request) (*ai.Response, error) {
	model := req.Model
	if model == "" {
		model = p.defaultModel
	}

	// 1. Phân giải cấu hình từ req.Config nếu có
	var dsCfg *Config
	if req.Config != nil {
		parsed, errParse := ParseConfig(req.Config.RawBytes())
		if errParse == nil {
			dsCfg = parsed
		}
	}
	if dsCfg == nil {
		defaultMax := 64000
		if strings.Contains(model, "chat") {
			defaultMax = 8192
		}
		dsCfg = &Config{
			Temperature:    0.2,
			MaxTokens:      defaultMax,
			ResponseFormat: &ResponseFormatConfig{Type: "json_object"},
		}
	}
	if dsCfg.MaxTokens <= 0 {
		defaultMax := 64000
		if strings.Contains(model, "chat") {
			defaultMax = 8192
		}
		dsCfg.MaxTokens = defaultMax
	}

	// 2. Chuẩn bị Messages
	var messages []ChatMessage

	// System Message
	systemPrompt := strings.TrimSpace(req.SystemPrompt)
	if systemPrompt != "" {
		messages = append(messages, ChatMessage{
			Role:    "system",
			Content: systemPrompt,
		})
	}

	// Tách các Part từ tài liệu: Gom ảnh và văn bản tĩnh
	var textDocs strings.Builder
	var imageParts []ContentPart

	for _, doc := range req.Documents {
		if doc == nil {
			continue
		}
		for _, part := range doc.Parts() {
			if part == nil || len(part.Data()) == 0 {
				continue
			}
			mime := strings.ToLower(part.MimeType())
			if strings.HasPrefix(mime, "image/") {
				imgBytes, errOpt := ensureMaxImageDimension(part.Data(), 1600)
				if errOpt != nil {
					imgBytes = part.Data()
				}
				b64 := base64.StdEncoding.EncodeToString(imgBytes)
				imageParts = append(imageParts, ContentPart{
					Type: "image_url",
					ImageURL: &ImageURL{
						URL: "data:image/jpeg;base64," + b64,
					},
				})
			} else {
				textDocs.WriteString(fmt.Sprintf("\n--- TÀI LIỆU [%s] %s ---\n%s\n",
					doc.ID(), doc.Name(), string(part.Data())))
			}
		}
	}

	// QUY TẮC PROMPT CACHING DEEPSEEK:
	// Nội dung tĩnh (Ảnh + Tài liệu cố định) BẮT BUỘC ĐẶT Ở ĐẦU (Prefix)
	// Chỉ dẫn người dùng động (UserPrompt) ĐẶT Ở CUỐI CÙNG!
	if len(imageParts) > 0 {
		parts := make([]ContentPart, 0, len(imageParts)+2)
		parts = append(parts, imageParts...)
		if textDocs.Len() > 0 {
			parts = append(parts, ContentPart{
				Type: "text",
				Text: textDocs.String(),
			})
		}
		if req.UserPrompt != "" {
			parts = append(parts, ContentPart{
				Type: "text",
				Text: req.UserPrompt,
			})
		}
		messages = append(messages, ChatMessage{
			Role:    "user",
			Content: parts,
		})
	} else {
		var fullText strings.Builder
		if textDocs.Len() > 0 {
			fullText.WriteString(textDocs.String())
			fullText.WriteString("\n\n")
		}
		fullText.WriteString(req.UserPrompt)

		messages = append(messages, ChatMessage{
			Role:    "user",
			Content: fullText.String(),
		})
	}

	// 3. Tạo Payload gửi DeepSeek
	chatReq := &ChatRequest{
		Model:          model,
		Messages:       messages,
		Temperature:    dsCfg.Temperature,
		MaxTokens:      dsCfg.MaxTokens,
		ResponseFormat: dsCfg.ResponseFormat,
		Thinking:       dsCfg.Thinking,
		Stream:         dsCfg.Stream,
	}

	// Đối với model flash và yêu cầu json_object, tắt thinking để tăng tốc độ phản hồi
	if strings.Contains(model, "flash") && chatReq.Thinking == nil && chatReq.ResponseFormat != nil && chatReq.ResponseFormat.Type == "json_object" {
		chatReq.Thinking = &ThinkingConfig{Type: "disabled"}
	}

	chatResp, rawBytes, errCall := p.client.PostChatCompletion(ctx, chatReq)
	if errCall != nil {
		return nil, fmt.Errorf("gọi DeepSeek API thất bại: %w", errCall)
	}

	if len(chatResp.Choices) == 0 {
		return nil, fmt.Errorf("deepseek không trả về choices nào")
	}

	choice := chatResp.Choices[0]
	if choice.FinishReason == "length" {
		fmt.Printf("⚠️ [DeepSeekProvider] CẢNH BÁO: Model bị chạm giới hạn MaxTokens (%d), output có thể bị ngắt cụt!\n", dsCfg.MaxTokens)
	}
	rawContent := choice.Message.Content

	// Nếu Content rỗng nhưng ReasoningContent có dữ liệu, lấy dữ liệu từ ReasoningContent
	if strings.TrimSpace(rawContent) == "" && strings.TrimSpace(choice.Message.ReasoningContent) != "" {
		rawContent = choice.Message.ReasoningContent
	}

	// Làm sạch thẻ suy luận <think>...</think> nếu có
	stripped := thinkTagRegex.ReplaceAllString(rawContent, "")
	if strings.TrimSpace(stripped) != "" {
		rawContent = stripped
	}

	var usage ai.Usage
	if chatResp.Usage != nil {
		if usageBytes, errUsage := json.Marshal(chatResp.Usage); errUsage == nil {
			chatResp.Usage.rawJSON = string(usageBytes)
		}
		usage = chatResp.Usage
	} else {
		usage = ai.NewSimpleUsage("{}", 0)
	}

	return &ai.Response{
		Content: strings.TrimSpace(rawContent),
		Usage:   usage,
		Raw:     string(rawBytes),
		Model:   chatReq.Model,
	}, nil
}

// ensureMaxImageDimension thu nhỏ ảnh nếu kích thước vượt quá maxDim (bảo đảm an toàn cho Vision API)
func ensureMaxImageDimension(imgBytes []byte, maxDim int) ([]byte, error) {
	if len(imgBytes) == 0 {
		return nil, fmt.Errorf("dữ liệu ảnh rỗng")
	}
	src, _, err := image.Decode(bytes.NewReader(imgBytes))
	if err != nil {
		return imgBytes, nil // Không decode được thì giữ nguyên bản gốc
	}
	bounds := src.Bounds()
	w, h := bounds.Dx(), bounds.Dy()
	if w <= maxDim && h <= maxDim {
		return imgBytes, nil
	}

	targetW, targetH := w, h
	if w > h {
		targetW = maxDim
		targetH = int(float64(h) * float64(maxDim) / float64(w))
	} else {
		targetH = maxDim
		targetW = int(float64(w) * float64(maxDim) / float64(h))
	}

	dst := image.NewRGBA(image.Rect(0, 0, targetW, targetH))
	draw.ApproxBiLinear.Scale(dst, dst.Bounds(), src, bounds, draw.Over, nil)

	var buf bytes.Buffer
	opt := &jpeg.Options{Quality: 82}
	if errEnc := jpeg.Encode(&buf, dst, opt); errEnc != nil {
		return imgBytes, nil
	}
	return buf.Bytes(), nil
}
