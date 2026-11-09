package keys

import (
	"fmt"
	"os"
	"strings"
)

// Manager phụ trách nạp và quản lý API key từ môi trường hoặc tệp cấu hình.
type Manager struct {
	defaultEnv string
}

// NewManager khởi tạo Key Manager với tên biến môi trường mặc định (vd: "DEEPSEEK_API_KEY").
func NewManager(defaultEnv string) *Manager {
	return &Manager{defaultEnv: defaultEnv}
}

// LoadFromEnv nạp key từ biến môi trường.
func (m *Manager) LoadFromEnv(envVar string) (string, error) {
	if envVar == "" {
		envVar = m.defaultEnv
	}
	key := strings.TrimSpace(os.Getenv(envVar))
	if key == "" {
		return "", fmt.Errorf("biến môi trường %s chưa được thiết lập", envVar)
	}
	return key, nil
}

// LoadMultipleFromEnv nạp danh sách key cách nhau bởi dấu phẩy từ biến môi trường.
func (m *Manager) LoadMultipleFromEnv(envVar string) ([]string, error) {
	if envVar == "" {
		envVar = m.defaultEnv
	}
	raw := strings.TrimSpace(os.Getenv(envVar))
	if raw == "" {
		return nil, fmt.Errorf("biến môi trường %s chưa được thiết lập", envVar)
	}
	parts := strings.Split(raw, ",")
	var keys []string
	for _, p := range parts {
		if k := strings.TrimSpace(p); k != "" {
			keys = append(keys, k)
		}
	}
	if len(keys) == 0 {
		return nil, fmt.Errorf("không tìm thấy key hợp lệ trong %s", envVar)
	}
	return keys, nil
}
