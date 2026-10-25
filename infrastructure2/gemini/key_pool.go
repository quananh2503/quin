package gemini

import (
	"context"
	_ "embed"
	"fmt"
	"math/rand"
	"os"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"google.golang.org/genai"
)

//go:embed key1.txt
var embeddedKey1 string

//go:embed key3.txt
var embeddedKey3 string

//go:embed key4.txt
var embeddedKey4 string

type KeySlot struct {
	index    int
	client   *genai.Client
	mu       sync.Mutex
	lastCall time.Time
	disabled bool
}

func (s *KeySlot) Index() int           { return s.index }
func (s *KeySlot) Client() *genai.Client { return s.client }
func (s *KeySlot) IsDisabled() bool     { return s.disabled }

type KeyPool struct {
	slots        []*KeySlot
	counter      uint64
	staggerDelay time.Duration
}

// NewKeyPool khởi tạo Pool từ danh sách các API Keys
func NewKeyPool(ctx context.Context, apiKeys []string) (*KeyPool, error) {
	var slots []*KeySlot
	seen := make(map[string]bool)
	for _, k := range apiKeys {
		k = strings.TrimSpace(k)
		if k == "" || seen[k] {
			continue
		}
		seen[k] = true
		cli, err := genai.NewClient(ctx, &genai.ClientConfig{
			APIKey:  k,
			Backend: genai.BackendGeminiAPI,
		})
		if err != nil {
			return nil, fmt.Errorf("khởi tạo key #%d lỗi: %w", len(slots)+1, err)
		}
		slots = append(slots, &KeySlot{index: len(slots) + 1, client: cli})
	}
	if len(slots) == 0 {
		return nil, fmt.Errorf("không có API Key hợp lệ nào trong Pool")
	}
	return &KeyPool{slots: slots, staggerDelay: 2500 * time.Millisecond}, nil
}

func (p *KeyPool) Slots() []*KeySlot { return p.slots }
func (p *KeyPool) Size() int         { return len(p.slots) }

func (p *KeyPool) ActiveCount() int {
	count := 0
	for _, s := range p.slots {
		if !s.disabled {
			count++
		}
	}
	return count
}

func isKeyDeniedError(err error) bool {
	if err == nil {
		return false
	}
	msg := strings.ToLower(err.Error())
	return strings.Contains(msg, "403") || strings.Contains(msg, "permission_denied") ||
		strings.Contains(msg, "401") || strings.Contains(msg, "unauthenticated") ||
		strings.Contains(msg, "api_key_invalid")
}

func isTransientError(err error) bool {
	if err == nil {
		return false
	}
	msg := strings.ToLower(err.Error())

	// HTTP transient status codes & GenAI status errors
	if strings.Contains(msg, "429") || strings.Contains(msg, "resource_exhausted") ||
		strings.Contains(msg, "503") || strings.Contains(msg, "500") ||
		strings.Contains(msg, "unavailable") || strings.Contains(msg, "overloaded") ||
		strings.Contains(msg, "internal") || strings.Contains(msg, "deadline_exceeded") {
		return true
	}

	// Socket / Network transient errors
	transientSubstrings := []string{
		"wsarecv",
		"connection reset",
		"connection aborted",
		"unexpected eof",
		"eof",
		"timeout",
		"timed out",
		"i/o timeout",
		"broken pipe",
		"request canceled",
		"request cancelled",
	}

	for _, sub := range transientSubstrings {
		if strings.Contains(msg, sub) {
			return true
		}
	}

	return false
}

// GenerateContent: Tự động phân tải Round-Robin qua các Keys + Failover tức thì nếu gặp 429 hoặc 403
func (p *KeyPool) GenerateContent(
	ctx context.Context,
	modelName string,
	contents []*genai.Content,
	config *genai.GenerateContentConfig,
	maxRetries int,
) (*genai.GenerateContentResponse, error) {
	numSlots := len(p.slots)
	if numSlots == 0 {
		return nil, fmt.Errorf("key pool rỗng, không có key nào")
	}

	baseDelay := 3 * time.Second
	effectiveRetries := maxRetries
	activeCount := p.ActiveCount()
	if activeCount > 0 && effectiveRetries < activeCount*3 {
		effectiveRetries = activeCount * 3
	}

	for attempt := 0; attempt <= effectiveRetries; attempt++ {
		slotIdx := int(atomic.AddUint64(&p.counter, 1)-1) % numSlots
		slot := p.slots[slotIdx]

		if slot.disabled {
			found := false
			for offset := 1; offset < numSlots; offset++ {
				candIdx := (slotIdx + offset) % numSlots
				if !p.slots[candIdx].disabled {
					slot = p.slots[candIdx]
					found = true
					break
				}
			}
			if !found {
				return nil, fmt.Errorf("toàn bộ API Key trong Pool đều đã bị khóa hoặc hết quyền (403/401)")
			}
		}

		slot.mu.Lock()
		elapsed := time.Since(slot.lastCall)
		if elapsed < p.staggerDelay {
			wait := p.staggerDelay - elapsed
			slot.mu.Unlock()
			select {
			case <-time.After(wait):
			case <-ctx.Done():
				return nil, ctx.Err()
			}
			slot.mu.Lock()
		}
		slot.lastCall = time.Now()
		slot.mu.Unlock()

		resp, err := slot.client.Models.GenerateContent(ctx, modelName, contents, config)
		if err == nil {
			return resp, nil
		}

		if isKeyDeniedError(err) {
			slot.disabled = true
			LogPhase("KEY-POOL", "\033[31m[Key #%d bị từ chối 403/401] Tự động loại khỏi Pool...\033[0m", slot.index)
			attempt--
			continue
		}

		if !isTransientError(err) || attempt == effectiveRetries {
			return nil, fmt.Errorf("[Key #%d] lỗi không thể phục hồi: %w", slot.index, err)
		}

		curActive := p.ActiveCount()
		if curActive <= 0 {
			curActive = 1
		}

		// Nếu còn key active khác chưa thử trong vòng này -> chuyển ngay sang key kế tiếp (chờ 100ms jitter)
		if (attempt+1)%curActive != 0 {
			select {
			case <-time.After(100 * time.Millisecond):
			case <-ctx.Done():
				return nil, ctx.Err()
			}
			continue
		}

		// Đã duyệt hết 1 vòng toàn bộ các Key mà vẫn 429 -> backoff theo vòng
		round := attempt / curActive
		backoff := baseDelay * time.Duration(1<<round)
		if backoff > 10*time.Second {
			backoff = 10 * time.Second
		}
		sleepTime := backoff + time.Duration(rand.Intn(500))*time.Millisecond
		LogPhase("KEY-POOL", "\033[33m[Pool chạm ngưỡng 429] Đang chờ %v trước khi thử vòng mới... (Lần %d/%d)\033[0m",
			sleepTime, attempt+1, effectiveRetries)

		select {
		case <-time.After(sleepTime):
		case <-ctx.Done():
			return nil, ctx.Err()
		}
	}

	return nil, fmt.Errorf("đã thử qua toàn bộ Pool (%d lần) nhưng vẫn thất bại", effectiveRetries)
}

// LoadAvailableAPIKeys nạp các API keys đã được embed trực tiếp trong binary (key1, key3, key4)
// cùng biến môi trường GEMINI_API_KEY (nếu có). Loại bỏ đọc file và bỏ qua key2, key5.
func LoadAvailableAPIKeys() []string {
	var keys []string
	seen := make(map[string]bool)

	addKey := func(k string) {
		k = strings.TrimSpace(k)
		if k != "" && !seen[k] {
			seen[k] = true
			keys = append(keys, k)
		}
	}

	addKey(embeddedKey1)
	addKey(embeddedKey3)
	addKey(embeddedKey4)

	if envKey := strings.TrimSpace(os.Getenv("GEMINI_API_KEY")); envKey != "" {
		addKey(envKey)
	}
	return keys
}
