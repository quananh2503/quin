package deepseek

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"
)

// Client chịu trách nhiệm gửi HTTP request tới DeepSeek API và nhận kết quả.
type Client struct {
	apiKey     string
	baseURL    string
	httpClient *http.Client
	maxRetries int
}

// NewClient khởi tạo Client cho DeepSeek.
func NewClient(apiKey string, baseURL string) *Client {
	baseURL = strings.TrimRight(strings.TrimSpace(baseURL), "/")
	if baseURL == "" {
		baseURL = "https://api.deepseek.com"
	}
	return &Client{
		apiKey:     strings.TrimSpace(apiKey),
		baseURL:    baseURL,
		httpClient: &http.Client{Timeout: 180 * time.Second},
		maxRetries: 3,
	}
}

// WithHTTPClient gán http.Client tùy chỉnh (dùng cho testing/mocking).
func (c *Client) WithHTTPClient(client *http.Client) *Client {
	if client != nil {
		c.httpClient = client
	}
	return c
}

// PostChatCompletion gửi yêu cầu chat completion tới DeepSeek và trả về response parsed cùng raw bytes.
func (c *Client) PostChatCompletion(ctx context.Context, req *ChatRequest) (*ChatResponse, []byte, error) {
	if c.apiKey == "" {
		return nil, nil, fmt.Errorf("chưa cấu hình API Key cho DeepSeek")
	}
	if req == nil {
		return nil, nil, fmt.Errorf("ChatRequest không được nil")
	}

	jsonBytes, errMarshal := json.Marshal(req)
	if errMarshal != nil {
		return nil, nil, fmt.Errorf("serialize DeepSeek chat request thất bại: %w", errMarshal)
	}

	endpoint := c.baseURL + "/chat/completions"
	var lastErr error
	var respBytes []byte

	for attempt := 1; attempt <= c.maxRetries; attempt++ {
		httpReq, errReq := http.NewRequestWithContext(ctx, http.MethodPost, endpoint, bytes.NewBuffer(jsonBytes))
		if errReq != nil {
			return nil, nil, fmt.Errorf("tạo HTTP request thất bại: %w", errReq)
		}
		httpReq.Header.Set("Content-Type", "application/json")
		httpReq.Header.Set("Authorization", "Bearer "+c.apiKey)

		res, errDo := c.httpClient.Do(httpReq)
		if errDo != nil {
			lastErr = fmt.Errorf("gửi request tới DeepSeek thất bại (attempt %d/%d): %w", attempt, c.maxRetries, errDo)
			select {
			case <-ctx.Done():
				return nil, nil, fmt.Errorf("context bị hủy khi chờ retry: %w", ctx.Err())
			case <-time.After(time.Duration(attempt) * 500 * time.Millisecond):
				continue
			}
		}

		body, errRead := io.ReadAll(res.Body)
		if errClose := res.Body.Close(); errClose != nil {
			return nil, nil, fmt.Errorf("đóng body thất bại: %w", errClose)
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

		// Xử lý Rate limit 429 hoặc lỗi 5xx của server DeepSeek
		if res.StatusCode == http.StatusTooManyRequests || res.StatusCode >= 500 {
			lastErr = fmt.Errorf("deepseek trả về mã HTTP %d: %s", res.StatusCode, string(body))
			select {
			case <-ctx.Done():
				return nil, nil, fmt.Errorf("context bị hủy khi chờ retry: %w", ctx.Err())
			case <-time.After(time.Duration(attempt) * time.Second):
				continue
			}
		}

		return nil, nil, fmt.Errorf("deepseek API trả về lỗi HTTP %d: %s", res.StatusCode, string(body))
	}

	if lastErr != nil {
		return nil, nil, fmt.Errorf("vượt quá số lần retry gọi DeepSeek: %w", lastErr)
	}

	var chatResp ChatResponse
	if errUnmarshal := json.Unmarshal(respBytes, &chatResp); errUnmarshal != nil {
		return nil, nil, fmt.Errorf("unmarshal DeepSeek response thất bại: %w (Raw: %s)", errUnmarshal, string(respBytes))
	}

	if chatResp.Error != nil {
		return nil, nil, fmt.Errorf("deepseek trả về lỗi: %s (Type: %s, Code: %s)",
			chatResp.Error.Message, chatResp.Error.Type, chatResp.Error.Code)
	}

	return &chatResp, respBytes, nil
}
