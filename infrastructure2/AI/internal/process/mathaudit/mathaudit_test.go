package mathaudit_test

import (
	"embed"
	"encoding/json"
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/AI/internal/process/mathaudit"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

//go:embed testdata/fixtures/*
var fixtures embed.FS

func TestAuditMathField(t *testing.T) {
	cases := []struct {
		name       string
		input      string
		wantOK     bool
		wantSubstr string
	}{
		{"Empty", "   ", true, ""},
		{"ValidMath", "Cho hình chóp $S.ABCD$ cạnh $a$.", true, ""},
		{"ASCIIFormFeed", "Cho tam giác \f ABC", false, "ASCII"},
		{"ASCIIBackspace", "Cho tam giác \b ABC", false, "ASCII"},
		{"OddDollar", "Phương trình $x^2 = 1 và $y=2$", false, "$"},
		{"NakedVec", "Xác định \\vec{AB} trong không gian", false, "LaTeX"},
		{"NakedFrac", "Tỉ số \\frac{1}{2} đoạn thẳng", false, "LaTeX"},
		{"WrappedLatex", "Xác định $\\vec{AB}$ và $\\frac{1}{2}$", true, ""},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			ok, reason := mathaudit.AuditMathField(tc.input)
			if ok != tc.wantOK {
				t.Errorf("AuditMathField(%q) ok=%v, want %v (reason=%s)", tc.input, ok, tc.wantOK, reason)
			}
			if !tc.wantOK && !strings.Contains(reason, tc.wantSubstr) {
				t.Errorf("reason=%q, want substr %q", reason, tc.wantSubstr)
			}
		})
	}
}

func TestAuditTopicContent_And_FallbackSanitize(t *testing.T) {
	brokenBytes, err := fixtures.ReadFile("testdata/fixtures/topic_broken_math.json")
	if err != nil {
		t.Fatalf("read fixture: %v", err)
	}
	var brokenTC raw.TopicContent
	if err := json.Unmarshal(brokenBytes, &brokenTC); err != nil {
		t.Fatalf("unmarshal fixture: %v", err)
	}

	tasks := mathaudit.AuditTopicContent(brokenTC)
	if len(tasks) < 10 {
		t.Fatalf("got %d repair tasks, want >= 10", len(tasks))
	}
	for _, task := range tasks {
		if !strings.HasPrefix(task.TargetID, "T1|") {
			t.Errorf("unexpected TargetID prefix: %q", task.TargetID)
		}
	}

	gotVec := mathaudit.FallbackSanitizeLaTeX(`\vecvec{a} + \overline{AB} + \bar{v} + \b{w}`)
	if gotVec != `\vec{a} + \vec{AB} + \vec{v} + \vec{w}` {
		t.Errorf("FallbackSanitizeLaTeX vec = %q", gotVec)
	}
	gotEsc := mathaudit.FallbackSanitizeLaTeX("Dạng #1: toạ_độ $M(x_0)$")
	if gotEsc != `Dạng \#1: toạ\_độ $M(x_0)$` {
		t.Errorf("FallbackSanitizeLaTeX escape = %q", gotEsc)
	}
	gotOdd := mathaudit.FallbackSanitizeLaTeX("Giá trị $x = 10")
	if gotOdd != "Giá trị $x = 10$" {
		t.Errorf("FallbackSanitizeLaTeX odd dollar = %q", gotOdd)
	}
}

func TestParseRepairBatch_FromFixture(t *testing.T) {
	respBytes, err := fixtures.ReadFile("testdata/fixtures/repair_batch_response.json")
	if err != nil {
		t.Fatalf("read fixture: %v", err)
	}
	tasks := []raw.RepairTask{
		{TargetID: "T1|theory|0", Content: "Lỗi dính \\vec{a} ngoài toán"},
		{TargetID: "T1|v|0|tip", Content: `Mẹo \vecvec{AB} #1`},
	}

	repaired := mathaudit.ParseRepairBatch(string(respBytes), tasks)
	if len(repaired) != 2 {
		t.Fatalf("repaired len = %d, want 2", len(repaired))
	}
	if repaired[0].FixedContent != "Lỗi dính $\\vec{a}$ ngoài toán" {
		t.Errorf("task 0 FixedContent = %q", repaired[0].FixedContent)
	}
	if !strings.Contains(repaired[1].FixedContent, `\vec{AB}`) || !strings.Contains(repaired[1].FixedContent, `\#1`) {
		t.Errorf("task 1 should fallback sanitize, got %q", repaired[1].FixedContent)
	}
}

func FuzzMathAuditAndSanitize(f *testing.F) {
	if b, err := fixtures.ReadFile("testdata/fixtures/topic_broken_math.json"); err == nil {
		f.Add(string(b))
	}
	f.Add(`\vecvec{a} #1 _x $y`)
	f.Fuzz(func(t *testing.T, input string) {
		_, _ = mathaudit.AuditMathField(input)
		_ = mathaudit.FallbackSanitizeLaTeX(input)
	})
}
