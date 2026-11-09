package deepseek

import "encoding/json"

// ImageURL chứa link data URI của ảnh (base64).
type ImageURL struct {
	URL string `json:"url"`
}

// ContentPart đại diện cho một phần tử nội dung (text hoặc image).
type ContentPart struct {
	Type     string    `json:"type"`
	Text     string    `json:"text,omitempty"`
	ImageURL *ImageURL `json:"image_url,omitempty"`
}

// ChatMessage định dạng message gửi tới DeepSeek Chat API.
type ChatMessage struct {
	Role    string      `json:"role"`
	Content interface{} `json:"content"` // string hoặc []ContentPart
}

// ResponseFormatConfig cấu hình format JSON Object cho DeepSeek.
type ResponseFormatConfig struct {
	Type string `json:"type"` // "json_object" hoặc "text"
}

// ThinkingConfig cấu hình bật/tắt chế độ suy luận cho DeepSeek.
type ThinkingConfig struct {
	Type string `json:"type"` // "disabled" hoặc "enabled"
}

// Config là struct cấu hình riêng biệt dành cho DeepSeek API.
// Triển khai interface ai.Config thông qua phương thức RawBytes().
type Config struct {
	Temperature    float32               `json:"temperature,omitempty"`
	MaxTokens      int                   `json:"max_tokens,omitempty"`
	ResponseFormat *ResponseFormatConfig `json:"response_format,omitempty"`
	Thinking       *ThinkingConfig       `json:"thinking,omitempty"`
	Stream         bool                  `json:"stream,omitempty"`
}

// RawBytes trả về JSON byte đại diện cho cấu hình của DeepSeek.
func (c *Config) RawBytes() []byte {
	if c == nil {
		return nil
	}
	b, err := json.Marshal(c)
	if err != nil {
		return nil
	}
	return b
}

// ParseConfig unmarshal raw bytes thành DeepSeek Config cụ thể.
func ParseConfig(raw []byte) (*Config, error) {
	var c Config
	if err := json.Unmarshal(raw, &c); err != nil {
		return nil, err
	}
	return &c, nil
}

// ChatRequest payload gửi tới endpoint /chat/completions của DeepSeek.
type ChatRequest struct {
	Model          string                `json:"model"`
	Messages       []ChatMessage         `json:"messages"`
	Temperature    float32               `json:"temperature,omitempty"`
	MaxTokens      int                   `json:"max_tokens,omitempty"`
	ResponseFormat *ResponseFormatConfig `json:"response_format,omitempty"`
	Thinking       *ThinkingConfig       `json:"thinking,omitempty"`
	Stream         bool                  `json:"stream"`
}

// ChoiceMessage nội dung message trong phản hồi DeepSeek.
type ChoiceMessage struct {
	Role             string `json:"role"`
	Content          string `json:"content"`
	ReasoningContent string `json:"reasoning_content,omitempty"`
}

// Choice cấu trúc choice trong JSON trả về.
type Choice struct {
	Index        int           `json:"index"`
	Message      ChoiceMessage `json:"message"`
	FinishReason string        `json:"finish_reason"`
}

// Usage là struct cụ thể của riêng DeepSeek, ánh xạ 100% với JSON schema của DeepSeek API.
// Triển khai interface ai.Usage thông qua hàm Raw() và TotalTokens().
type Usage struct {
	PromptTokens          int    `json:"prompt_tokens"`
	CompletionTokens      int    `json:"completion_tokens"`
	TotalTokensCount      int    `json:"total_tokens"`
	PromptCacheHitTokens  int    `json:"prompt_cache_hit_tokens"`
	PromptCacheMissTokens int    `json:"prompt_cache_miss_tokens"`
	rawJSON               string `json:"-"`
}

func (u *Usage) Raw() string      { return u.rawJSON }
func (u *Usage) TotalTokens() int { return u.TotalTokensCount }

// ParseUsage unmarshal chuỗi raw JSON từ ai.Usage thành DeepSeek Usage cụ thể.
func ParseUsage(rawJSON string) (*Usage, error) {
	var u Usage
	if err := json.Unmarshal([]byte(rawJSON), &u); err != nil {
		return nil, err
	}
	u.rawJSON = rawJSON
	return &u, nil
}

// Response bóc tách đầy đủ các trường chuyên biệt của DeepSeek (bao gồm cả ReasoningContent từ <think>).
type Response struct {
	Content          string `json:"content"`
	ReasoningContent string `json:"reasoning_content,omitempty"`
	Usage            *Usage `json:"usage,omitempty"`
	Raw              string `json:"raw,omitempty"`
}

// ParseResponse bóc tách chuỗi JSON phản hồi thô thành DeepSeek Response cụ thể.
func ParseResponse(rawJSON string) (*Response, error) {
	var chatResp ChatResponse
	if err := json.Unmarshal([]byte(rawJSON), &chatResp); err != nil {
		return nil, err
	}
	var content, reasoning string
	if len(chatResp.Choices) > 0 {
		content = chatResp.Choices[0].Message.Content
		reasoning = chatResp.Choices[0].Message.ReasoningContent
	}
	return &Response{
		Content:          content,
		ReasoningContent: reasoning,
		Usage:            chatResp.Usage,
		Raw:              rawJSON,
	}, nil
}

// ChatResponse payload nhận về từ DeepSeek API.
type ChatResponse struct {
	ID      string   `json:"id"`
	Choices []Choice `json:"choices"`
	Usage   *Usage   `json:"usage,omitempty"`
	Error   *struct {
		Message string `json:"message"`
		Type    string `json:"type"`
		Code    string `json:"code"`
	} `json:"error,omitempty"`
}
