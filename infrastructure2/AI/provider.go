package ai

import "context"

// Provider là interface tổng quát trừu tượng hóa cho mọi AI Provider (DeepSeek, Gemini, Qwen, Gemma...).
// Mọi implementation cụ thể (DeepSeek, Gemini,...) đều phải triển khai interface này.
type Provider interface {
	// Name trả về tên định danh của Provider (vd: "deepseek", "gemini", "qwen").
	Name() string

	// Generate gửi yêu cầu sinh nội dung tới AI Provider và trả về kết quả chuẩn hóa.
	Generate(ctx context.Context, req Request) (*Response, error)
}
