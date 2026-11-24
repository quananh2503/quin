package resilience_test

import (
	"strings"
	"testing"
	"time"

	"meet-attendance-clean/infrastructure2/AI/internal/policy/resilience"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

func TestNormalizeClientConfig(t *testing.T) {
	def := resilience.NormalizeClientConfig(raw.ClientConfig{
		BaseURL:    "   ",
		Timeout:    0,
		MaxRetries: 0,
		Cooldown:   -10 * time.Millisecond,
	})
	if def.BaseURL != "https://api.deepseek.com" {
		t.Errorf("BaseURL = %q, want default", def.BaseURL)
	}
	if def.Timeout != 180*time.Second || def.MaxRetries != 3 || def.Cooldown != 0 {
		t.Errorf("unexpected defaults: %+v", def)
	}

	custom := resilience.NormalizeClientConfig(raw.ClientConfig{
		BaseURL:    " https://custom.api/v1/// ",
		Timeout:    15 * time.Second,
		MaxRetries: 5,
		Cooldown:   250 * time.Millisecond,
	})
	if custom.BaseURL != "https://custom.api/v1" {
		t.Errorf("BaseURL = %q, want trimmed", custom.BaseURL)
	}
	if custom.Timeout != 15*time.Second || custom.MaxRetries != 5 || custom.Cooldown != 250*time.Millisecond {
		t.Errorf("unexpected custom values: %+v", custom)
	}
}

func TestRetryDelays(t *testing.T) {
	if got := resilience.RetryDelays(0); got != nil {
		t.Errorf("RetryDelays(0) = %v, want nil", got)
	}
	if got := resilience.RetryDelays(-2); got != nil {
		t.Errorf("RetryDelays(-2) = %v, want nil", got)
	}
	one := resilience.RetryDelays(1)
	if len(one) != 1 || one[0] != 0 {
		t.Errorf("RetryDelays(1) = %v, want [0]", one)
	}
	three := resilience.RetryDelays(3)
	if len(three) != 3 || three[0] != 25*time.Millisecond || three[1] != 50*time.Millisecond || three[2] != 0 {
		t.Errorf("RetryDelays(3) = %v, want [25ms, 50ms, 0]", three)
	}
}

func TestClassifyHTTPFailure(t *testing.T) {
	cases := []struct {
		code          int
		wantRetry     bool
		wantPermanent bool
	}{
		{429, true, false},
		{500, true, false},
		{503, true, false},
		{401, false, true},
		{403, false, true},
		{400, false, false},
		{404, false, false},
		{499, false, false},
	}
	for _, tc := range cases {
		gotRetry, gotPerm := resilience.ClassifyHTTPFailure(tc.code)
		if gotRetry != tc.wantRetry || gotPerm != tc.wantPermanent {
			t.Errorf("ClassifyHTTPFailure(%d) = (%v, %v), want (%v, %v)",
				tc.code, gotRetry, gotPerm, tc.wantRetry, tc.wantPermanent)
		}
	}
}

func TestSelectKeySlot_And_RecordKeyFailure(t *testing.T) {
	now := time.Date(2026, 11, 24, 12, 0, 0, 0, time.UTC)

	if _, _, err := resilience.SelectKeySlot(nil, 0, now); err == nil {
		t.Fatal("expected error for empty slots")
	}

	slots := []*raw.KeySlot{
		{Key: "k1"},
		{Key: "k2"},
	}

	// Negative / out-of-range current index normalizes to 0.
	k, next, err := resilience.SelectKeySlot(slots, -1, now)
	if err != nil || k != "k1" || next != 1 || !slots[0].LastUsed.Equal(now) {
		t.Fatalf("SelectKeySlot(-1) = (%q, %d, %v)", k, next, err)
	}
	k, next, err = resilience.SelectKeySlot(slots, 99, now)
	if err != nil || k != "k1" || next != 1 {
		t.Fatalf("SelectKeySlot(99) = (%q, %d, %v)", k, next, err)
	}
	k, next, err = resilience.SelectKeySlot(slots, next, now)
	if err != nil || k != "k2" || next != 0 {
		t.Fatalf("SelectKeySlot(1) = (%q, %d, %v)", k, next, err)
	}

	// Put k1 in cooldown; SelectKeySlot skips k1 and selects k2.
	resilience.RecordKeyFailure(slots, "k1", false, 5*time.Second, now)
	if slots[0].FailCount != 1 || slots[0].Disabled || !slots[0].CooldownUntil.Equal(now.Add(5*time.Second)) {
		t.Fatalf("unexpected k1 slot state after 1 failure: %+v", slots[0])
	}
	k, _, err = resilience.SelectKeySlot(slots, 0, now.Add(4*time.Second))
	if err != nil || k != "k2" {
		t.Fatalf("expected k2 while k1 cooling, got (%q, %v)", k, err)
	}

	// Put k2 in cooldown too -> all in cooldown error.
	resilience.RecordKeyFailure(slots, "k2", false, 5*time.Second, now)
	if _, _, errCool := resilience.SelectKeySlot(slots, 0, now.Add(2*time.Second)); errCool == nil || !strings.Contains(errCool.Error(), "cooldown") {
		t.Fatalf("expected cooldown error when all keys are in cooldown, got %v", errCool)
	}

	// After cooldown expires (exact boundary now == CooldownUntil -> usable!).
	k, _, err = resilience.SelectKeySlot(slots, 0, now.Add(5*time.Second))
	if err != nil || k != "k1" {
		t.Fatalf("expected k1 at exact cooldown boundary, got (%q, %v)", k, err)
	}

	// Consecutive transient failures auto-disable k1 at 5th failure (already at 1, add 3 more -> still enabled, 5th -> disabled).
	for range 3 {
		resilience.RecordKeyFailure(slots, "k1", false, time.Second, now)
	}
	if slots[0].FailCount != 4 || slots[0].Disabled {
		t.Fatalf("k1 should not be disabled at 4 failures: %+v", slots[0])
	}
	resilience.RecordKeyFailure(slots, "k1", false, time.Second, now)
	if slots[0].FailCount != 5 || !slots[0].Disabled {
		t.Fatalf("k1 must be disabled at 5 failures: %+v", slots[0])
	}

	// One disabled + one in cooldown -> cooldown error (not all disabled).
	resilience.RecordKeyFailure(slots, "k2", false, 5*time.Second, now)
	if _, _, errMixed := resilience.SelectKeySlot(slots, 0, now.Add(time.Second)); errMixed == nil || !strings.Contains(errMixed.Error(), "cooldown") {
		t.Fatalf("expected cooldown error with 1 disabled + 1 cooling, got %v", errMixed)
	}

	// Permanent failure disables k2 immediately; unknown key is a no-op.
	resilience.RecordKeyFailure(slots, "unknown", true, time.Second, now)
	resilience.RecordKeyFailure(slots, "k2", true, time.Second, now)
	if !slots[1].Disabled {
		t.Fatal("k2 must be disabled on permanent failure")
	}
	if _, _, errDis := resilience.SelectKeySlot(slots, 0, now); errDis == nil || !strings.Contains(errDis.Error(), "disabled") {
		t.Fatalf("expected disabled error when all keys are disabled, got %v", errDis)
	}
}
