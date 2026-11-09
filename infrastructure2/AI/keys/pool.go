package keys

import (
	"fmt"
	"sync"
	"time"
)

// KeySlot đại diện cho 1 slot API key cùng trạng thái cooldown.
type KeySlot struct {
	Key       string
	Disabled  bool
	LastUsed  time.Time
	FailCount int
}

// Pool quản lý xoay vòng danh sách các API Key, hỗ trợ cooldown khi gặp rate-limit.
type Pool struct {
	mu           sync.Mutex
	slots        []*KeySlot
	currentIndex int
	cooldown     time.Duration
}

// NewPool khởi tạo Key Pool từ mảng các API Key.
func NewPool(apiKeys []string, cooldown time.Duration) (*Pool, error) {
	if len(apiKeys) == 0 {
		return nil, fmt.Errorf("danh sách key không được để trống")
	}
	slots := make([]*KeySlot, len(apiKeys))
	for i, k := range apiKeys {
		slots[i] = &KeySlot{Key: k}
	}
	return &Pool{
		slots:    slots,
		cooldown: cooldown,
	}, nil
}

// Acquire lấy key tiếp theo khả dụng theo vòng round-robin.
// Stub rỗng chờ duyệt pattern.
func (p *Pool) Acquire() (string, error) {
	// TODO: Sau khi được duyệt, sẽ implement logic xoay vòng và kiểm tra cooldown.
	return "", nil
}

// ReportSuccess ghi nhận lượt gọi thành công để reset fail count.
func (p *Pool) ReportSuccess(key string) {
	// TODO: Implement sau khi duyệt pattern.
}

// ReportFailure ghi nhận lỗi (vd: 429 rate limit) để kích hoạt cooldown cho key.
func (p *Pool) ReportFailure(key string, err error) {
	// TODO: Implement sau khi duyệt pattern.
}
