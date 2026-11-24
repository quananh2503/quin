package anchor_test

import (
	"embed"
	"testing"

	"meet-attendance-clean/infrastructure2/AI/internal/process/anchor"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

//go:embed testdata/fixtures/*
var fixtures embed.FS

func TestExtractAndSetContextField(t *testing.T) {
	tc := raw.TopicContent{
		TopicID:      "T1",
		TheoryPoints: []string{"Gốc Theory 0"},
		ClozeFormula: "Gốc Cloze",
		CalloutTip:   "Gốc Callout",
		Variants: []raw.VariantGuide{
			{
				VariantID:   "V1",
				Recognition: "Gốc Rec",
				ActionSteps: []string{"Gốc Step 0", "Gốc Step 1"},
				QuickTip:    "Gốc Tip",
				Example:     raw.ExampleItem{Problem: "Gốc Prob", Solution: "Gốc Sol"},
				Drills:      []raw.DrillExercise{{Prompt: "Gốc Drill Prompt", Solution: "Gốc Drill Sol"}},
			},
		},
	}

	updates := map[string]string{
		"T1|theory|0":          "Fixed Theory",
		"T1|cloze":             "Fixed Cloze",
		"T1|callout":           "Fixed Callout",
		"T1|v|0|rec":           "Fixed Rec",
		"T1|v|0|step|1":        "Fixed Step 1",
		"T1|v|0|tip":           "Fixed Tip",
		"T1|v|0|ex_prob":       "Fixed Prob",
		"T1|v|0|ex_sol":        "Fixed Sol",
		"T1|v|0|drill|0|prompt": "Fixed Drill Prompt",
		"T1|v|0|drill|0|sol":    "Fixed Drill Sol",
	}

	updated := tc
	for id, val := range updates {
		updated = anchor.SetContextField(updated, id, val)
		if got := anchor.ExtractContextField(updated, id); got != val {
			t.Errorf("field %q = %q, want %q", id, got, val)
		}
	}

	// Out-of-bounds & invalid targetID safety
	_ = anchor.SetContextField(updated, "T1|theory|999", "ignore")
	_ = anchor.SetContextField(updated, "invalid", "ignore")
	if got := anchor.ExtractContextField(updated, "T1|v|99|rec"); got != "" {
		t.Errorf("expected empty for out-of-bounds targetID, got %q", got)
	}
}

func TestExtractCompilerErrorAnchors_FromFixtures(t *testing.T) {
	markupBytes, err := fixtures.ReadFile("testdata/fixtures/topic_with_anchors.typ")
	if err != nil {
		t.Fatalf("read typ fixture: %v", err)
	}
	stderrBytes, err := fixtures.ReadFile("testdata/fixtures/compiler_stderr.txt")
	if err != nil {
		t.Fatalf("read stderr fixture: %v", err)
	}

	tc := raw.TopicContent{
		TopicID:      "T1",
		TheoryPoints: []string{"Điểm lý thuyết 1"},
		Variants:     []raw.VariantGuide{{VariantID: "V1", Recognition: "Dấu hiệu nhận diện 1"}},
	}

	tasks := anchor.ExtractCompilerErrorAnchors(string(markupBytes), string(stderrBytes), tc)
	if len(tasks) != 1 {
		t.Fatalf("got %d tasks, want 1", len(tasks))
	}
	if tasks[0].TargetID != "T1|v|0|rec" || tasks[0].Content != "Dấu hiệu nhận diện 1" {
		t.Errorf("unexpected task: %+v", tasks[0])
	}

	if nearest := anchor.FindNearestAnchor([]string{"// @ANCHOR:T1|theory|0", "#text[x]"}, 2); nearest != "T1|theory|0" {
		t.Errorf("FindNearestAnchor = %q, want T1|theory|0", nearest)
	}
}

func FuzzExtractCompilerErrorAnchors(f *testing.F) {
	if m, err := fixtures.ReadFile("testdata/fixtures/topic_with_anchors.typ"); err == nil {
		if s, err2 := fixtures.ReadFile("testdata/fixtures/compiler_stderr.txt"); err2 == nil {
			f.Add(string(m), string(s))
		}
	}
	f.Add("// @ANCHOR:T1|cloze\nline2", "error at line 2")
	f.Fuzz(func(t *testing.T, markup string, stderr string) {
		_ = anchor.ExtractCompilerErrorAnchors(markup, stderr, raw.TopicContent{TopicID: "T1"})
	})
}
