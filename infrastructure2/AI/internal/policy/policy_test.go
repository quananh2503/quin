package policy_test

import (
	"testing"
	"time"

	"meet-attendance-clean/infrastructure2/AI/internal/policy"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

func TestBuildPipelineDefaults(t *testing.T) {
	cfg1, opts1 := policy.BuildPipelineDefaults([]string{"k1"}, "https://api.example.com", "  ", 0)
	if cfg1.Cooldown != 0 {
		t.Errorf("single-key Cooldown = %v, want 0", cfg1.Cooldown)
	}
	if cfg1.Timeout != 180*time.Second || cfg1.MaxRetries != 3 {
		t.Errorf("unexpected default Timeout/MaxRetries: %+v", cfg1)
	}
	if opts1.Model != "deepseek-chat" || opts1.Workers != 30 {
		t.Errorf("unexpected defaults for empty model & 0 workers: %+v", opts1)
	}

	cfg0, optsNeg := policy.BuildPipelineDefaults(nil, "", "deepseek-reasoner", -5)
	if cfg0.Cooldown != 0 || optsNeg.Workers != 30 || optsNeg.Model != "deepseek-reasoner" {
		t.Errorf("unexpected defaults for nil keys & negative workers: cfg=%+v opts=%+v", cfg0, optsNeg)
	}

	cfg2, opts2 := policy.BuildPipelineDefaults([]string{"k1", "k2"}, "https://x", " deepseek-flash ", 12)
	if cfg2.Cooldown != 100*time.Millisecond {
		t.Errorf("multi-key Cooldown = %v, want 100ms", cfg2.Cooldown)
	}
	if opts2.Model != "deepseek-flash" || opts2.Workers != 12 {
		t.Errorf("unexpected explicit opts: %+v", opts2)
	}
}

func TestClampWorkers(t *testing.T) {
	cases := []struct {
		name    string
		workers int
		total   int
		want    int
	}{
		{"ZeroTotal", 4, 0, 0},
		{"NegativeTotal", 4, -2, 0},
		{"ZeroWorkers", 0, 5, 1},
		{"NegativeWorkers", -3, 5, 1},
		{"WorkersBelowTotal", 3, 5, 3},
		{"WorkersEqualTotal", 5, 5, 5},
		{"WorkersAboveTotal", 8, 5, 5},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := policy.ClampWorkers(tc.workers, tc.total); got != tc.want {
				t.Errorf("ClampWorkers(%d, %d) = %d, want %d", tc.workers, tc.total, got, tc.want)
			}
		})
	}
}

func TestClampImageDimensions(t *testing.T) {
	cases := []struct {
		name       string
		w, h, max  int
		wantW      int
		wantH      int
		wantResize bool
	}{
		{"ZeroWidth", 0, 100, 1600, 0, 100, false},
		{"ZeroHeight", 100, 0, 1600, 100, 0, false},
		{"ZeroMaxDim", 2000, 1000, 0, 2000, 1000, false},
		{"WithinBounds", 1200, 800, 1600, 1200, 800, false},
		{"ExactBounds", 1600, 1600, 1600, 1600, 1600, false},
		{"LandscapeResize", 3200, 1600, 1600, 1600, 800, true},
		{"PortraitResize", 1200, 2400, 1200, 600, 1200, true},
		{"SquareAboveMax", 2000, 2000, 1000, 1000, 1000, true},
		{"ExtremeAspectWide", 10000, 1, 100, 100, 1, true},
		{"ExtremeAspectTall", 1, 10000, 100, 1, 100, true},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			gotW, gotH, gotResize := policy.ClampImageDimensions(tc.w, tc.h, tc.max)
			if gotW != tc.wantW || gotH != tc.wantH || gotResize != tc.wantResize {
				t.Errorf("ClampImageDimensions(%d,%d,%d) = (%d,%d,%v), want (%d,%d,%v)",
					tc.w, tc.h, tc.max, gotW, gotH, gotResize, tc.wantW, tc.wantH, tc.wantResize)
			}
		})
	}
}

func TestPartitionSelfHealTasks(t *testing.T) {
	attempts := make(map[string]int)
	tasks := []raw.RepairTask{
		{TargetID: "T1|theory|0", Content: "a"},
		{TargetID: "T1|v|0|rec", Content: "b"},
	}

	// First round: both targets should go to AI repair (count becomes 1 < 2).
	ai1, fb1 := policy.PartitionSelfHealTasks(tasks, attempts)
	if len(ai1) != 2 || len(fb1) != 0 {
		t.Fatalf("round 1 = (ai=%d, fb=%d), want (2, 0)", len(ai1), len(fb1))
	}

	// Second round for T1|theory|0 only: count becomes 2 >= 2 -> fallback; new target T1|tip -> AI.
	round2 := []raw.RepairTask{
		{TargetID: "T1|theory|0", Content: "a"},
		{TargetID: "T1|tip", Content: "c"},
	}
	ai2, fb2 := policy.PartitionSelfHealTasks(round2, attempts)
	if len(ai2) != 1 || ai2[0].TargetID != "T1|tip" {
		t.Errorf("round 2 AI tasks = %+v, want [T1|tip]", ai2)
	}
	if len(fb2) != 1 || fb2[0].TargetID != "T1|theory|0" {
		t.Errorf("round 2 fallback tasks = %+v, want [T1|theory|0]", fb2)
	}

	// Nil attempts map must not panic and sends to AI.
	aiNil, fbNil := policy.PartitionSelfHealTasks(tasks, nil)
	if len(aiNil) != 2 || len(fbNil) != 0 {
		t.Errorf("nil attempts = (ai=%d, fb=%d), want (2, 0)", len(aiNil), len(fbNil))
	}
}
