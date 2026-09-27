package oauth2

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"os"

	goauth "golang.org/x/oauth2"
)

var (
	ErrTokenNotFound = errors.New("không tìm thấy token")
	ErrTokenExpired  = errors.New("AUTH_EXPIRED: phiên đăng nhập đã hết hạn hoặc bị thu hồi")
)

type TokenStore interface {
	Load(ctx context.Context) (*goauth.Token, error)
	Save(ctx context.Context, token *goauth.Token) error
	Delete(ctx context.Context) error
	Exists(ctx context.Context) bool
}
type FileTokenStore struct {
	path string
}

func NewFileTokenStore(path string) *FileTokenStore {
	return &FileTokenStore{path: path}
}

func (s *FileTokenStore) Exists(_ context.Context) bool {
	_, err := os.Stat(s.path)
	return err == nil
}

func (s *FileTokenStore) Load(_ context.Context) (*goauth.Token, error) {
	file, err := os.Open(s.path)
	if err != nil {
		if os.IsNotExist(err) {
			return nil, ErrTokenNotFound
		}
		return nil, fmt.Errorf("không thể mở file token: %w", err)
	}
	defer file.Close()

	var token goauth.Token
	if err := json.NewDecoder(file).Decode(&token); err != nil {
		return nil, fmt.Errorf("giải mã token json thất bại: %w", err)
	}
	return &token, nil
}

func (s *FileTokenStore) Save(_ context.Context, token *goauth.Token) error {
	data, err := json.MarshalIndent(token, "", "  ")
	if err != nil {
		return fmt.Errorf("chuyển đổi token sang json: %w", err)
	}
	// Quyền 0600: Chỉ user hiện tại mới có quyền đọc/ghi file token này
	return os.WriteFile(s.path, data, 0600)
}

func (s *FileTokenStore) Delete(_ context.Context) error {
	if err := os.Remove(s.path); err != nil && !os.IsNotExist(err) {
		return fmt.Errorf("xóa file token: %w", err)
	}
	return nil
}
