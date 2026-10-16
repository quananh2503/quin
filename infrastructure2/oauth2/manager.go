package oauth2

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"os"

	"golang.org/x/oauth2"
)

type Manager struct {
	config    *oauth2.Config
	tokenPath string
}

func NewManager(cfg *oauth2.Config, tokenPath string) *Manager {
	return &Manager{
		config:    cfg,
		tokenPath: tokenPath,
	}
}

func (m *Manager) IsConnected() bool {
	_, err := os.Stat(m.tokenPath)
	return err == nil
}

// AuthURL nhận thêm opts để nhà cung cấp tự do thêm tham số riêng (vd: Google prompt, Microsoft tenant)
func (m *Manager) AuthURL(state string, opts ...oauth2.AuthCodeOption) string {
	return m.config.AuthCodeURL(state, opts...)
}

func (m *Manager) Exchange(ctx context.Context, code string) error {
	token, err := m.config.Exchange(ctx, code)
	if err != nil {
		return fmt.Errorf("đổi oauth token thất bại: %w", err)
	}
	return m.SaveToken(token)
}

func (m *Manager) Disconnect() error {
	if err := os.Remove(m.tokenPath); err != nil && !os.IsNotExist(err) {
		return err
	}
	return nil
}

func (m *Manager) GetHTTPClient(ctx context.Context) (*http.Client, error) {
	file, err := os.Open(m.tokenPath)
	if err != nil {
		return nil, errors.New("chưa liên kết tài khoản (không tìm thấy token)")
	}
	defer file.Close()

	var token oauth2.Token
	if err := json.NewDecoder(file).Decode(&token); err != nil {
		return nil, fmt.Errorf("đọc token lỗi: %w", err)
	}

	tokenSource := m.config.TokenSource(ctx, &token)
	freshToken, err := tokenSource.Token()
	if err != nil {
		_ = m.Disconnect()
		return nil, errors.New("AUTH_EXPIRED: phiên đăng nhập đã hết hạn hoặc bị thu hồi")
	}

	// Nếu token được tự động làm mới, lưu lại đè lên file cũ
	if freshToken.AccessToken != token.AccessToken {
		if err := m.SaveToken(freshToken); err != nil {
			return nil, err
		}
	}

	return m.config.Client(ctx, freshToken), nil
}

func (m *Manager) SaveToken(token *oauth2.Token) error {
	data, err := json.MarshalIndent(token, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(m.tokenPath, data, 0600)
}
