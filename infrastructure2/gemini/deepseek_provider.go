package gemini

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"image"
	"image/jpeg"
	_ "image/png" // Hỗ trợ giải mã ảnh PNG
	"io"
	"log"
	"net/http"
	"os"
	"regexp"
	"strings"
	"sync"
	"time"

	"golang.org/x/image/draw"
)

var thinkTagRegex = regexp.MustCompile(`(?s)<think>.*?</think>`)

// resizeAndCompressImage thu nhỏ ảnh về kích thước tối đa maxDim (1600px) và nén sang JPEG.
// Quy định bắt buộc của DeepSeek Vision: Khi tải lên từ 15 ảnh trở lên, kích thước mỗi cạnh KHÔNG ĐƯỢC vượt quá 4096px.
func resizeAndCompressImage(imgBytes []byte, maxDim int, quality int) ([]byte, error) {
	if len(imgBytes) == 0 {
		return nil, fmt.Errorf("dữ liệu ảnh rỗng")
	}
	src, _, err := image.Decode(bytes.NewReader(imgBytes))
	if err != nil {
		return nil, fmt.Errorf("giải mã ảnh thất bại: %w", err)
	}

	bounds := src.Bounds()
	w := bounds.Dx()
	h := bounds.Dy()

	targetW, targetH := w, h
	if w > maxDim || h > maxDim {
		if w > h {
			targetW = maxDim
			targetH = int(float64(h) * float64(maxDim) / float64(w))
		} else {
			targetH = maxDim
			targetW = int(float64(w) * float64(maxDim) / float64(h))
		}
	}

	var finalImg image.Image = src
	if targetW != w || targetH != h {
		dst := image.NewRGBA(image.Rect(0, 0, targetW, targetH))
		draw.ApproxBiLinear.Scale(dst, dst.Bounds(), src, bounds, draw.Over, nil)
		finalImg = dst
	}

	var buf bytes.Buffer
	opt := &jpeg.Options{Quality: quality}
	if errEnc := jpeg.Encode(&buf, finalImg, opt); errEnc != nil {
		return nil, fmt.Errorf("encode JPEG thất bại: %w", errEnc)
	}
	return buf.Bytes(), nil
}

// dsImageURL chứa đường dẫn URL (hỗ trợ data:image/png;base64)
type dsImageURL struct {
	URL string `json:"url"`
}

// dsContentPart đại diện cho 1 phần tử trong mảng content (Multimodal cho deepseek-flash)
type dsContentPart struct {
	Type     string      `json:"type"`
	Text     string      `json:"text,omitempty"`
	ImageURL *dsImageURL `json:"image_url,omitempty"`
}

// dsMessage định dạng message gửi tới DeepSeek Chat API
type dsMessage struct {
	Role    string      `json:"role"`
	Content interface{} `json:"content"` // string hoặc []dsContentPart
}

// dsResponseFormat cấu hình format JSON Object cho DeepSeek
type dsResponseFormat struct {
	Type string `json:"type"`
}

// dsThinkingConfig cấu hình bật/tắt chế độ suy luận (Thinking Mode)
type dsThinkingConfig struct {
	Type string `json:"type"` // "disabled" hoặc "enabled"
}

// dsChatRequest payload gửi tới DeepSeek /chat/completions
type dsChatRequest struct {
	Model          string            `json:"model"`
	Messages       []dsMessage       `json:"messages"`
	Temperature    float32           `json:"temperature,omitempty"`
	MaxTokens      int               `json:"max_tokens,omitempty"`
	ResponseFormat *dsResponseFormat `json:"response_format,omitempty"`
	Thinking       *dsThinkingConfig `json:"thinking,omitempty"`
	Stream         bool              `json:"stream"`
}

// dsChoiceMessage nội dung message trong phản hồi DeepSeek
type dsChoiceMessage struct {
	Role             string `json:"role"`
	Content          string `json:"content"`
	ReasoningContent string `json:"reasoning_content,omitempty"`
}

// dsChoice cấu trúc choice trong JSON trả về
type dsChoice struct {
	Index        int             `json:"index"`
	Message      dsChoiceMessage `json:"message"`
	FinishReason string          `json:"finish_reason"`
}

// dsUsage thông số token tiêu thụ
type dsUsage struct {
	PromptTokens          int `json:"prompt_tokens"`
	CompletionTokens      int `json:"completion_tokens"`
	TotalTokens           int `json:"total_tokens"`
	PromptCacheHitTokens  int `json:"prompt_cache_hit_tokens"`
	PromptCacheMissTokens int `json:"prompt_cache_miss_tokens"`
}

// dsChatResponse response nhận được từ DeepSeek
type dsChatResponse struct {
	ID      string     `json:"id"`
	Choices []dsChoice `json:"choices"`
	Usage   *dsUsage   `json:"usage,omitempty"`
	Error   *struct {
		Message string `json:"message"`
		Type    string `json:"type"`
		Code    string `json:"code"`
	} `json:"error,omitempty"`
}

// DeepSeekLLMProvider triển khai interface LLMProvider giao tiếp với DeepSeek API (deepseek-flash, deepseek-chat)
type DeepSeekLLMProvider struct {
	apiKey       string
	baseURL      string
	defaultModel string
	client       *http.Client
	rasterizer   PDFRasterizer

	mu           sync.Mutex
	accumUsage   UsageMetrics
	requestCount int
}

// GetAccumulatedUsage trả về tổng token và số request đã thực thi qua provider này
func (p *DeepSeekLLMProvider) GetAccumulatedUsage() (UsageMetrics, int) {
	p.mu.Lock()
	defer p.mu.Unlock()
	return p.accumUsage, p.requestCount
}

// NewDeepSeekLLMProvider khởi tạo DeepSeekLLMProvider với apiKey và defaultModel
func NewDeepSeekLLMProvider(apiKey string, defaultModel string) *DeepSeekLLMProvider {
	if defaultModel == "" {
		defaultModel = "deepseek-flash"
	}
	baseURL := strings.TrimRight(os.Getenv("DEEPSEEK_BASE_URL"), "/")
	if baseURL == "" {
		baseURL = "https://api.deepseek.com"
	}
	return &DeepSeekLLMProvider{
		apiKey:       strings.TrimSpace(apiKey),
		baseURL:      baseURL,
		defaultModel: defaultModel,
		client:       &http.Client{Timeout: 180 * time.Second},
		rasterizer:   NewCLITypstCompiler(),
	}
}

// WithRasterizer cấu hình rasterizer tùy biến
func (p *DeepSeekLLMProvider) WithRasterizer(r PDFRasterizer) *DeepSeekLLMProvider {
	p.rasterizer = r
	return p
}

// ProviderName trả về tên định danh "deepseek"
func (p *DeepSeekLLMProvider) ProviderName() string {
	return "deepseek"
}

// GenerateJSON gọi DeepSeek API và trả về LLMResponse chuẩn hóa
func (p *DeepSeekLLMProvider) GenerateJSON(ctx context.Context, req LLMRequest) (*LLMResponse, error) {
	if p.apiKey == "" {
		return nil, fmt.Errorf("chưa cấu hình DEEPSEEK_API_KEY")
	}

	model := req.ModelName
	if model == "" {
		model = p.defaultModel
	}

	// 1. Chuẩn bị Messages
	messages := make([]dsMessage, 0, 2)

	// System Instruction
	systemPrompt := strings.TrimSpace(req.SystemPrompt)
	if len(req.JSONSchema) > 0 {
		schemaNotice := fmt.Sprintf("\n\n[BẮT BUỘC ĐỊNH DẠNG JSON]: Bạn PHẢI trả về một JSON Object hợp lệ (không kèm thẻ code block ngoài lề) tuân thủ đúng cấu trúc JSON Schema sau:\n%s\n", string(req.JSONSchema))
		if systemPrompt == "" {
			systemPrompt = "Bạn là trợ lý AI chuyên gia. Hãy xử lý yêu cầu và trả về kết quả theo đúng định dạng JSON yêu cầu." + schemaNotice
		} else {
			systemPrompt += schemaNotice
		}
	}

	if systemPrompt != "" {
		messages = append(messages, dsMessage{
			Role:    "system",
			Content: systemPrompt,
		})
	}

	// Xử lý Documents & User Prompt
	var textDocs strings.Builder
	var images [][]byte

	for _, doc := range req.Documents {
		if doc.TextContent != "" {
			textDocs.WriteString(fmt.Sprintf("\n--- TÀI LIỆU [%s] %s (%s) ---\n%s\n", doc.DocID, doc.FileName, doc.RoleHint, doc.TextContent))
		}
		// Nạp các trang ảnh có sẵn
		if len(doc.PageImages) > 0 {
			for _, img := range doc.PageImages {
				if len(img) > 0 {
					images = append(images, img)
				}
			}
		} else if len(doc.RawPDF) > 0 && p.rasterizer != nil {
			// Tự động rasterize PDF sang ảnh PNG để model deepseek-flash có thể đọc
			imgs, errRast := p.rasterizer.RasterizePDF(ctx, doc.RawPDF)
			if errRast != nil {
				log.Printf("[DeepSeekProvider] Cảnh báo rasterize PDF %s thất bại: %v", doc.FileName, errRast)
			} else {
				images = append(images, imgs...)
			}
		}
	}

	if len(images) > 0 {
		// DeepSeek-Flash hỗ trợ multi-part content (ImageURL + Text).
		// QUY TẮC CACHE HIT: Để tối đa hóa Prompt Caching của DeepSeek, nội dung tĩnh cố định (Ảnh & Tài liệu)
		// BẮT BUỘC PHẢI ĐẶT Ở ĐẦU (tiền tố Prefix). Văn bản yêu cầu riêng (UserPrompt) đặt ở CUỐI CÙNG!
		parts := make([]dsContentPart, 0, len(images)+2)

		// Giới hạn an toàn tối đa 25 trang tiêu biểu nhất
		maxPages := len(images)
		if maxPages > 25 {
			maxPages = 25
			log.Printf("[DeepSeekProvider] Tài liệu có %d trang, tự động lấy 25 trang đầu để đảm bảo giới hạn tải mạng", len(images))
		}

		// 1. NẠP TOÀN BỘ ẢNH LÊN ĐẦU TIÊN ĐỂ ĂN CACHE HIT TUYỆT ĐỐI CHO CÁC REQUEST TIẾP THEO
		for idx := 0; idx < maxPages; idx++ {
			compressed, errComp := resizeAndCompressImage(images[idx], 1600, 75)
			if errComp != nil {
				log.Printf("[DeepSeekProvider] Cảnh báo xử lý ảnh trang %d thất bại: %v (bỏ qua trang này)", idx+1, errComp)
				continue
			}
			b64 := base64.StdEncoding.EncodeToString(compressed)
			parts = append(parts, dsContentPart{
				Type: "image_url",
				ImageURL: &dsImageURL{
					URL: "data:image/jpeg;base64," + b64,
				},
			})
		}

		// 2. Nạp văn bản tài liệu tĩnh (nếu có)
		if textDocs.Len() > 0 {
			parts = append(parts, dsContentPart{
				Type: "text",
				Text: textDocs.String(),
			})
		}

		// 3. ĐƯA PROMPT ĐỘNG CỦA USER / WORKER XUỐNG CUỐI CÙNG
		if req.UserPrompt != "" {
			parts = append(parts, dsContentPart{
				Type: "text",
				Text: req.UserPrompt,
			})
		}

		messages = append(messages, dsMessage{
			Role:    "user",
			Content: parts,
		})
	} else {
		// Nội dung thuần văn bản (Tài liệu tĩnh trước, UserPrompt động sau)
		fullUserText := textDocs.String()
		if fullUserText != "" && req.UserPrompt != "" {
			fullUserText = fullUserText + "\n\n" + req.UserPrompt
		} else if req.UserPrompt != "" {
			fullUserText = req.UserPrompt
		}

		messages = append(messages, dsMessage{
			Role:    "user",
			Content: fullUserText,
		})
	}

	// 2. Tạo Request Body
	maxTokens := req.MaxOutputTokens
	if maxTokens <= 0 {
		maxTokens = 8192
	}
	temp := req.Temperature
	if temp <= 0 {
		temp = 0.2
	}

	chatReq := dsChatRequest{
		Model:       model,
		Messages:    messages,
		Temperature: temp,
		MaxTokens:   maxTokens,
		Stream:      false,
	}

	// Bật JSON mode nếu không phải deepseek-reasoner (R1)
	if !strings.Contains(model, "reasoner") {
		chatReq.ResponseFormat = &dsResponseFormat{Type: "json_object"}
	}

	// Cấu hình Thinking Mode:
	// Đối với deepseek-flash: Model mặc định bật Thinking Mode.
	// Tuy nhiên khi kết hợp Thinking Mode với response_format: json_object,
	// DeepSeek khuyến cáo tắt thinking ("type": "disabled") để tránh lỗi output content rỗng
	// và giúp tăng tốc độ sinh JSON lên gấp 5-10 lần (không tốn hàng chục giây suy luận ngầm).
	thinkingEnv := strings.ToLower(strings.TrimSpace(os.Getenv("DEEPSEEK_THINKING")))
	if thinkingEnv == "enabled" || thinkingEnv == "true" {
		chatReq.Thinking = &dsThinkingConfig{Type: "enabled"}
	} else if strings.Contains(model, "flash") {
		chatReq.Thinking = &dsThinkingConfig{Type: "disabled"}
	}

	jsonBytes, errMarshal := json.Marshal(chatReq)
	if errMarshal != nil {
		return nil, fmt.Errorf("marshal DeepSeek chat request thất bại: %w", errMarshal)
	}

	// 3. Thực thi HTTP Call với cơ chế Retry khi gặp Rate Limit (429) hoặc tạm nghẽn (503)
	endpoint := p.baseURL + "/chat/completions"
	var lastErr error
	var respBytes []byte

	maxRetries := 3
	for attempt := 1; attempt <= maxRetries; attempt++ {
		httpReq, errReq := http.NewRequestWithContext(ctx, "POST", endpoint, bytes.NewBuffer(jsonBytes))
		if errReq != nil {
			return nil, fmt.Errorf("tạo HTTP request thất bại: %w", errReq)
		}
		httpReq.Header.Set("Content-Type", "application/json")
		httpReq.Header.Set("Authorization", "Bearer "+p.apiKey)

		res, errDo := p.client.Do(httpReq)
		if errDo != nil {
			lastErr = fmt.Errorf("gửi request tới DeepSeek thất bại: %w", errDo)
			select {
			case <-ctx.Done():
				return nil, ctx.Err()
			case <-time.After(time.Duration(attempt*2) * time.Second):
				continue
			}
		}

		body, errRead := io.ReadAll(res.Body)
		if closeErr := res.Body.Close(); closeErr != nil {
			log.Printf("[DeepSeekProvider] Đóng body thất bại: %v", closeErr)
		}
		if errRead != nil {
			lastErr = fmt.Errorf("đọc response body thất bại: %w", errRead)
			continue
		}

		if res.StatusCode == http.StatusOK {
			respBytes = body
			lastErr = nil
			break
		}

		// Nếu gặp 429 hoặc 5xx, chờ rồi thử lại
		if res.StatusCode == http.StatusTooManyRequests || res.StatusCode >= 500 {
			lastErr = fmt.Errorf("deepseek trả về mã HTTP %d: %s", res.StatusCode, string(body))
			log.Printf("[DeepSeekProvider] Thử lại lần %d/%d (HTTP %d)...", attempt, maxRetries, res.StatusCode)
			select {
			case <-ctx.Done():
				return nil, ctx.Err()
			case <-time.After(time.Duration(attempt*3) * time.Second):
				continue
			}
		}

		return nil, fmt.Errorf("deepseek API trả về lỗi HTTP %d: %s", res.StatusCode, string(body))
	}

	if lastErr != nil {
		return nil, lastErr
	}

	// 4. Parse phản hồi JSON
	var chatResp dsChatResponse
	if errUnmarshal := json.Unmarshal(respBytes, &chatResp); errUnmarshal != nil {
		return nil, fmt.Errorf("unmarshal DeepSeek response thất bại: %w (Raw: %s)", errUnmarshal, string(respBytes))
	}

	if chatResp.Error != nil {
		return nil, fmt.Errorf("deepseek trả về lỗi: %s (Type: %s, Code: %s)", chatResp.Error.Message, chatResp.Error.Type, chatResp.Error.Code)
	}

	if len(chatResp.Choices) == 0 {
		return nil, fmt.Errorf("deepseek không trả về choices nào")
	}

	choice := chatResp.Choices[0]
	if choice.FinishReason == "length" {
		log.Printf("[DeepSeekProvider] CẢNH BÁO: Model bị chạm giới hạn MaxTokens (%d), JSON có thể bị ngắt cụt", maxTokens)
	}

	rawContent := choice.Message.Content

	// 1. Nếu Content rỗng nhưng ReasoningContent có dữ liệu, tự động fallback lấy từ ReasoningContent
	if strings.TrimSpace(rawContent) == "" && strings.TrimSpace(choice.Message.ReasoningContent) != "" {
		log.Printf("[DeepSeekProvider] Phản hồi content rỗng, tự động lấy dữ liệu từ reasoning_content (%d bytes)...", len(choice.Message.ReasoningContent))
		rawContent = choice.Message.ReasoningContent
	}

	// 2. Làm sạch thẻ suy luận <think>...</think> nếu có (chỉ gọt bỏ nếu phần ngoài không rỗng)
	stripped := thinkTagRegex.ReplaceAllString(rawContent, "")
	if strings.TrimSpace(stripped) != "" {
		rawContent = stripped
	}
	cleanContent := SanitizeRawJSONLaTeX(strings.TrimSpace(rawContent))
	if cleanContent == "" {
		return nil, fmt.Errorf("deepseek trả về JSON rỗng (finish_reason: %s, reasoning_len: %d)",
			choice.FinishReason,
			len(choice.Message.ReasoningContent),
		)
	}

	var usage UsageMetrics
	if chatResp.Usage != nil {
		usage = UsageMetrics{
			PromptTokens:          chatResp.Usage.PromptTokens,
			CandidatesTokens:      chatResp.Usage.CompletionTokens,
			TotalTokens:           chatResp.Usage.TotalTokens,
			PromptCacheHitTokens:  chatResp.Usage.PromptCacheHitTokens,
			PromptCacheMissTokens: chatResp.Usage.PromptCacheMissTokens,
		}
		p.mu.Lock()
		p.accumUsage.PromptTokens += chatResp.Usage.PromptTokens
		p.accumUsage.CandidatesTokens += chatResp.Usage.CompletionTokens
		p.accumUsage.TotalTokens += chatResp.Usage.TotalTokens
		p.accumUsage.PromptCacheHitTokens += chatResp.Usage.PromptCacheHitTokens
		p.accumUsage.PromptCacheMissTokens += chatResp.Usage.PromptCacheMissTokens
		p.requestCount++
		p.mu.Unlock()
	}

	return &LLMResponse{
		RawJSON: cleanContent,
		Usage:   usage,
	}, nil
}
