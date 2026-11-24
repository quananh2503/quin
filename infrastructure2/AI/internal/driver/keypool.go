package driver

import (
	"errors"
	"strings"
	"sync"
	"time"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

const maxConsecutiveFailures = 5

// KeyPool manages round-robin API key rotation, cooldowns, and auto-disabling.
type KeyPool struct {
	mu       *sync.Mutex
	slots    []*raw.KeySlot
	current  int
	cooldown time.Duration
}

// NewKeyPool creates a KeyPool from one or more API keys and a cooldown duration.
func NewKeyPool(apiKeys []string, cooldown time.Duration) (*KeyPool, error) {
	if cooldown < 0 {
		cooldown = 0
	}
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
		cooldown: cooldown,
	}, nil
}

// Acquire returns the next available non-disabled, non-cooling key.
func (p *KeyPool) Acquire() (string, error) {
	p.mu.Lock()
	defer p.mu.Unlock()

	if len(p.slots) == 0 {
		return "", errors.New("no API keys configured")
	}

	now := time.Now()
	n := len(p.slots)
	disabledCount := 0
	for i := range n {
		idx := (p.current + i) % n
		slot := p.slots[idx]
		if slot.Disabled {
			disabledCount++
			continue
		}
		if !slot.CooldownUntil.IsZero() && now.Before(slot.CooldownUntil) {
			continue
		}
		slot.LastUsed = now
		p.current = (idx + 1) % n
		return slot.Key, nil
	}

	if disabledCount == n {
		return "", errors.New("all API keys are disabled")
	}
	return "", errors.New("all available API keys are in cooldown")
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

	now := time.Now()
	for _, slot := range p.slots {
		if slot.Key == key {
			slot.FailCount++
			if permanent || slot.FailCount >= maxConsecutiveFailures {
				slot.Disabled = true
				return
			}
			slot.CooldownUntil = now.Add(p.cooldown)
			return
		}
	}
}
