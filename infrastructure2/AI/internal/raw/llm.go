package raw

import "time"

// ImageURL holds a base64 data URI for multimodal vision input.
type ImageURL struct {
	URL string `json:"url"`
}

// ContentPart represents a text or image_url block inside a multimodal chat message.
type ContentPart struct {
	Type     string    `json:"type"`
	Text     string    `json:"text,omitempty"`
	ImageURL *ImageURL `json:"image_url,omitempty"`
}

// ChatMessage represents a single role/content entry sent to a chat completion endpoint.
type ChatMessage struct {
	Role    string `json:"role"`
	Content any    `json:"content"`
}

// ResponseFormatConfig specifies the response format mode for the LLM provider.
type ResponseFormatConfig struct {
	Type string `json:"type"`
}

// ThinkingConfig controls provider reasoning mode ("enabled" or "disabled").
type ThinkingConfig struct {
	Type string `json:"type"`
}

// GenerationConfig carries provider-level sampling and formatting options.
type GenerationConfig struct {
	Temperature    float32               `json:"temperature,omitempty"`
	MaxTokens      int                   `json:"max_tokens,omitempty"`
	ResponseFormat *ResponseFormatConfig `json:"response_format,omitempty"`
	Thinking       *ThinkingConfig       `json:"thinking,omitempty"`
	Stream         bool                  `json:"stream,omitempty"`
}

// ChatRequest is the wire JSON payload sent to /chat/completions.
type ChatRequest struct {
	Model          string                `json:"model"`
	Messages       []ChatMessage         `json:"messages"`
	Temperature    float32               `json:"temperature,omitempty"`
	MaxTokens      int                   `json:"max_tokens,omitempty"`
	ResponseFormat *ResponseFormatConfig `json:"response_format,omitempty"`
	Thinking       *ThinkingConfig       `json:"thinking,omitempty"`
	Stream         bool                  `json:"stream"`
}

// LLMRequest is the stage-level request before provider wire encoding.
type LLMRequest struct {
	Model        string
	SystemPrompt string
	UserPrompt   string
	Documents    []Document
	Config       *GenerationConfig
}

// Usage captures token consumption and prompt cache statistics.
type Usage struct {
	PromptTokens          int    `json:"prompt_tokens"`
	CompletionTokens      int    `json:"completion_tokens"`
	TotalTokens           int    `json:"total_tokens"`
	PromptCacheHitTokens  int    `json:"prompt_cache_hit_tokens"`
	PromptCacheMissTokens int    `json:"prompt_cache_miss_tokens"`
	RawJSON               string `json:"-"`
}

// ChoiceMessage holds the assistant message content and optional reasoning content.
type ChoiceMessage struct {
	Role             string `json:"role"`
	Content          string `json:"content"`
	ReasoningContent string `json:"reasoning_content,omitempty"`
}

// Choice represents a single completion candidate returned by the LLM provider.
type Choice struct {
	Index        int           `json:"index"`
	Message      ChoiceMessage `json:"message"`
	FinishReason string        `json:"finish_reason"`
}

// APIError captures provider-returned structured error payloads.
type APIError struct {
	Message string `json:"message"`
	Type    string `json:"type"`
	Code    string `json:"code"`
}

// ChatResponse is the raw JSON response returned by /chat/completions.
type ChatResponse struct {
	ID      string    `json:"id"`
	Choices []Choice  `json:"choices"`
	Usage   *Usage    `json:"usage,omitempty"`
	Error   *APIError `json:"error,omitempty"`
}

// LLMResponse is the normalized assistant output extracted from ChatResponse.
type LLMResponse struct {
	Content          string
	ReasoningContent string
	Model            string
	Raw              string
	FinishReason     string
	Usage            Usage
}

// KeySlot tracks rotation state, cooldown, and health of a single API key.
type KeySlot struct {
	Key           string
	Disabled      bool
	LastUsed      time.Time
	FailCount     int
	CooldownUntil time.Time
}

// ClientConfig configures the HTTP client, retry policy, and key pool.
type ClientConfig struct {
	APIKeys    []string
	BaseURL    string
	Timeout    time.Duration
	MaxRetries int
	Cooldown   time.Duration
}
