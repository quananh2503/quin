package gemini

import (
	"context"
	"meet-attendance-clean/infrastructure2/AI"
)

// Provider triển khai interface ai.Provider cho Google Gemini.
// Giữ dưới dạng stub sẵn sàng tích hợp khi cần mở rộng sau DeepSeek.
type Provider struct {
	apiKey       string
	defaultModel string
}

// NewProvider khởi tạo Gemini Provider mới.
func NewProvider(apiKey string, defaultModel string) *Provider {
	if defaultModel == "" {
		defaultModel = "gemini-3.8-flash"
	}
	return &Provider{
		apiKey:       apiKey,
		defaultModel: defaultModel,
	}
}

// Name trả về định danh của Provider.
func (p *Provider) Name() string {
	return "gemini"
}

// Generate gửi request tới Google Gemini API.
// Stub rỗng chờ mở rộng sau.
func (p *Provider) Generate(ctx context.Context, req ai.Request) (*ai.Response, error) {
	return nil, nil
}
