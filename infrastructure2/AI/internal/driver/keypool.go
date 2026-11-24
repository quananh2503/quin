package driver

import (
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"meet-attendance-clean/infrastructure2/AI/internal/policy/resilience"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

// KeyPool manages round-robin API key rotation, cooldowns, and auto-disabling.
type KeyPool struct {
	mu       *sync.Mutex
	slots    []*raw.KeySlot
	current  int
	cooldown time.Duration
}

// NewKeyPool creates a KeyPool from one or more API keys and a cooldown duration.
func NewKeyPool(apiKeys []string, cooldown time.Duration) (*KeyPool, error) {
	normalized := resilience.NormalizeClientConfig(raw.ClientConfig{Cooldown: cooldown})
	var slots []*raw.KeySlot
	for _, k := range apiKeys {
		trimmed := strings.TrimSpace(k)
		if trimmed != "" {
			slots = append(slots, &raw.KeySlot{Key: trimmed})
		}
	}
	if len(slots) == 0 {
		return nil, errors.New("api keys must not be empty")
	}
	return &KeyPool{
		mu:       &sync.Mutex{},
		slots:    slots,
		cooldown: normalized.Cooldown,
	}, nil
}

// Acquire returns the next available non-disabled, non-cooling key.
func (p *KeyPool) Acquire() (string, error) {
	p.mu.Lock()
	defer p.mu.Unlock()

	key, next, err := resilience.SelectKeySlot(p.slots, p.current, time.Now())
	if err != nil {
		return "", fmt.Errorf("select key slot: %w", err)
	}
	p.current = next
	return key, nil
}

// ReportSuccess resets the failure counter for the given key.
func (p *KeyPool) ReportSuccess(key string) {
	p.mu.Lock()
	defer p.mu.Unlock()

	for _, slot := range p.slots {
		if slot.Key == key {
			slot.FailCount = 0
			slot.CooldownUntil = time.Time{}
			return
		}
	}
}

// ReportFailure records a transient or permanent failure for the given key.
func (p *KeyPool) ReportFailure(key string, permanent bool) {
	p.mu.Lock()
	defer p.mu.Unlock()

	resilience.RecordKeyFailure(p.slots, key, permanent, p.cooldown, time.Now())
}
