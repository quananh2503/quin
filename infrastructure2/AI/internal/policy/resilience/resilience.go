package resilience

import (
	"errors"
	"strings"
	"time"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

const (
	defaultBaseURL          = "https://api.deepseek.com"
	defaultTimeout          = 180 * time.Second
	defaultMaxRetries       = 3
	baseRetryBackoff        = 25 * time.Millisecond
	maxConsecutiveFailures  = 5
	statusUnauthorized      = 401
	statusForbidden         = 403
	statusTooManyRequests   = 429
	statusInternalServerErr = 500
)

// NormalizeClientConfig applies default endpoint, timeout, retry limit, and non-negative cooldown.
func NormalizeClientConfig(cfg raw.ClientConfig) raw.ClientConfig {
	cfg.BaseURL = strings.TrimRight(strings.TrimSpace(cfg.BaseURL), "/")
	if cfg.BaseURL == "" {
		cfg.BaseURL = defaultBaseURL
	}
	if cfg.Timeout <= 0 {
		cfg.Timeout = defaultTimeout
	}
	if cfg.MaxRetries <= 0 {
		cfg.MaxRetries = defaultMaxRetries
	}
	if cfg.Cooldown < 0 {
		cfg.Cooldown = 0
	}
	return cfg
}

// RetryDelays returns the per-attempt backoff schedule for maxRetries attempts.
// The final attempt has a zero backoff because no wait is needed after exhaustion.
func RetryDelays(maxRetries int) []time.Duration {
	if maxRetries <= 0 {
		return nil
	}
	delays := make([]time.Duration, maxRetries)
	for i := range maxRetries - 1 {
		delays[i] = time.Duration(i+1) * baseRetryBackoff
	}
	return delays
}

// ClassifyHTTPFailure determines whether a non-200 HTTP status is retryable or permanently disables the key.
func ClassifyHTTPFailure(statusCode int) (retryable, permanent bool) {
	if statusCode == statusTooManyRequests || statusCode >= statusInternalServerErr {
		return true, false
	}
	if statusCode == statusUnauthorized || statusCode == statusForbidden {
		return false, true
	}
	return false, false
}

// SelectKeySlot chooses the next available non-disabled, non-cooling API key slot via round-robin.
func SelectKeySlot(slots []*raw.KeySlot, current int, now time.Time) (key string, nextCurrent int, err error) {
	n := len(slots)
	if n == 0 {
		return "", 0, errors.New("no API keys configured")
	}
	if current < 0 || current >= n {
		current = 0
	}

	disabledCount := 0
	for i := range n {
		idx := (current + i) % n
		slot := slots[idx]
		if slot.Disabled {
			disabledCount++
			continue
		}
		if !slot.CooldownUntil.IsZero() && now.Before(slot.CooldownUntil) {
			continue
		}
		slot.LastUsed = now
		return slot.Key, (idx + 1) % n, nil
	}

	if disabledCount == n {
		return "", current, errors.New("all API keys are disabled")
	}
	return "", current, errors.New("all available API keys are in cooldown")
}

// RecordKeyFailure updates failure count, auto-disable threshold, and cooldown window on the matching slot.
func RecordKeyFailure(slots []*raw.KeySlot, key string, permanent bool, cooldown time.Duration, now time.Time) {
	for _, slot := range slots {
		if slot.Key == key {
			slot.FailCount++
			if permanent || slot.FailCount >= maxConsecutiveFailures {
				slot.Disabled = true
				return
			}
			slot.CooldownUntil = now.Add(cooldown)
			return
		}
	}
}
