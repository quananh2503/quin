package database

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"log"
	"strings"
	"time"
)

type APIKeyRecord struct {
	Provider  string    `json:"provider"`
	APIKey    string    `json:"api_key"`
	UpdatedAt time.Time `json:"updated_at"`
}

// APIKeys quản lý bảng api_keys trong SQLite (lưu trữ key cho Gemini và DeepSeek).
type APIKeys struct {
	Store *SQLite
}

// GetKey lấy giá trị api_key theo tên provider (vd: "gemini", "deepseek").
func (r APIKeys) GetKey(ctx context.Context, provider string) (string, error) {
	provider = strings.TrimSpace(strings.ToLower(provider))
	if provider == "" {
		return "", errors.New("provider không được để trống")
	}

	var apiKey string
	err := r.Store.DB.QueryRowContext(ctx, `SELECT api_key FROM api_keys WHERE provider = ?`, provider).Scan(&apiKey)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return "", nil
		}
		return "", fmt.Errorf("lấy api_key cho %s: %w", provider, err)
	}
	return apiKey, nil
}

// SetKey lưu hoặc cập nhật giá trị api_key cho một provider.
func (r APIKeys) SetKey(ctx context.Context, provider, apiKey string) error {
	provider = strings.TrimSpace(strings.ToLower(provider))
	if provider == "" {
		return errors.New("provider không được để trống")
	}
	apiKey = strings.TrimSpace(apiKey)

	now := timeText(time.Now().UTC())
	_, err := r.Store.DB.ExecContext(ctx, `
		INSERT INTO api_keys(provider, api_key, updated_at)
		VALUES (?, ?, ?)
		ON CONFLICT(provider) DO UPDATE SET
			api_key = excluded.api_key,
			updated_at = excluded.updated_at
	`, provider, apiKey, now)
	if err != nil {
		return fmt.Errorf("lưu api_key cho %s: %w", provider, err)
	}
	return nil
}

// GetAll lấy toàn bộ danh sách key dưới dạng map[provider]apiKey.
func (r APIKeys) GetAll(ctx context.Context) (map[string]string, error) {
	rows, err := r.Store.DB.QueryContext(ctx, `SELECT provider, api_key FROM api_keys`)
	if err != nil {
		return nil, fmt.Errorf("truy vấn danh sách api_keys: %w", err)
	}
	defer func() {
		if closeErr := rows.Close(); closeErr != nil {
			log.Printf("cảnh báo đóng rows api_keys: %v", closeErr)
		}
	}()

	result := make(map[string]string)
	for rows.Next() {
		var provider, key string
		if err := rows.Scan(&provider, &key); err != nil {
			return nil, fmt.Errorf("đọc bản ghi api_key: %w", err)
		}
		result[provider] = key
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("lỗi duyệt api_keys: %w", err)
	}
	return result, nil
}
