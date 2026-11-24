package topic_test

import (
	"embed"
	"encoding/json"
	"fmt"
	"testing"

	"meet-attendance-clean/infrastructure2/AI/internal/process/topic"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

//go:embed testdata/fixtures/*
var fixtures embed.FS

func TestParseTopicContent_FromFixture(t *testing.T) {
	data, err := fixtures.ReadFile("testdata/fixtures/topic_content_full.json")
	if err != nil {
		t.Fatalf("read fixture: %v", err)
	}

	planTopic := raw.TopicPlan{
		TopicID:  "T1",
		Title:    "Khái niệm vectơ trong không gian",
		Variants: []string{"Xác định điểm thỏa mãn đẳng thức vectơ"},
	}

	tc, err := topic.ParseTopicContent(string(data), planTopic)
	if err != nil {
		t.Fatalf("ParseTopicContent failed: %v", err)
	}
	if tc.TopicID != "T1" || len(tc.Variants) != 1 {
		t.Fatalf("unexpected TopicContent: %+v", tc)
	}
	if tc.Variants[0].VariantName != "Xác định điểm thỏa mãn đẳng thức vectơ" {
		t.Errorf("expected VariantName fallback from planTopic.Variants, got %q", tc.Variants[0].VariantName)
	}

	if _, errBad := topic.ParseTopicContent("{not-json", planTopic); errBad == nil {
		t.Fatal("expected error for malformed TopicContent JSON")
	}
	if _, errEmpty := topic.ParseTopicContent("   ", planTopic); errEmpty == nil {
		t.Fatal("expected error for empty TopicContent JSON")
	}
}

func TestParseTopicContent_FallbacksAndTruncatedRepair(t *testing.T) {
	planTopic := raw.TopicPlan{
		TopicID:    "T_PLAN",
		Title:      "Tiêu đề từ plan",
		Difficulty: "Vận dụng",
		Variants:   []string{"Biến thể plan 1"},
	}

	t.Run("FallbacksWhenEmptyAndPreservedWhenSet", func(t *testing.T) {
		rawJSON := `{
			"theory_points": ["Lý thuyết"],
			"variants": [
				{"variant_id": "V1", "drills": [{"prompt": "P1"}]},
				{"variant_id": "V2", "drills": [{"prompt": "P2"}]},
				{"variant_id": "V3", "variant_name": "Tên có sẵn", "drills": [{"prompt": "P3"}]}
			]
		}`
		tc, err := topic.ParseTopicContent(rawJSON, planTopic)
		if err != nil {
			t.Fatalf("ParseTopicContent failed: %v", err)
		}
		if tc.TopicID != "T_PLAN" || tc.Title != "Tiêu đề từ plan" || tc.Difficulty != "Vận dụng" {
			t.Errorf("fallback metadata mismatch: %+v", tc)
		}
		if tc.Variants[0].VariantName != "Biến thể plan 1" ||
			tc.Variants[1].VariantName != "Biến thể 2" ||
			tc.Variants[2].VariantName != "Tên có sẵn" {
			t.Errorf("variant name fallback mismatch: %+v", tc.Variants)
		}

		explicitJSON := `{"topic_id":"T_OWN","title":"Tiêu đề riêng","difficulty":"Nâng cao","theory_points":["A"]}`
		tc2, err := topic.ParseTopicContent(explicitJSON, planTopic)
		if err != nil {
			t.Fatalf("ParseTopicContent explicit failed: %v", err)
		}
		if tc2.TopicID != "T_OWN" || tc2.Title != "Tiêu đề riêng" || tc2.Difficulty != "Nâng cao" {
			t.Errorf("explicit fields must not be overwritten: %+v", tc2)
		}
	})

	t.Run("TruncatedJSONWithEscapedQuotes", func(t *testing.T) {
		truncated := `{"topic_id":"T1","title":"Cho \"vectơ","theory_points":["A"],"variants":[{"variant_id":"V1","drills":[{"prompt":"P"}]},{"variant_id":"V2","action_steps":["Bước 1`
		tc, err := topic.ParseTopicContent(truncated, planTopic)
		if err != nil {
			t.Fatalf("ParseTopicContent failed to repair truncated JSON: %v", err)
		}
		if tc.TopicID != "T1" || tc.Title != `Cho "vectơ` || len(tc.Variants) != 2 || len(tc.Variants[1].ActionSteps) != 1 {
			t.Errorf("unexpected repaired TopicContent: %+v", tc)
		}
	})
}

func TestVerifyPlan_BoundaryAndIsolatedConditions(t *testing.T) {
	planBytes, err := fixtures.ReadFile("testdata/fixtures/plan_coverage.json")
	if err != nil {
		t.Fatalf("read fixture: %v", err)
	}
	var plan raw.LessonPlan
	if err := json.Unmarshal(planBytes, &plan); err != nil {
		t.Fatalf("unmarshal fixture: %v", err)
	}

	report := topic.VerifyPlan(plan, "Không bỏ sót bài tập")
	if !report.NeedsRefinement || len(report.UnassignedIDs) != 1 || report.UnassignedIDs[0] != "DOC1_BT1" ||
		len(report.RedundantTopics) != 1 || report.RedundantTopics[0].TopicID != "T2" {
		t.Errorf("unexpected fixture VerifyPlan report: %+v", report)
	}

	twelve := make([]string, 12)
	for i := range twelve {
		twelve[i] = fmt.Sprintf("Q%d", i+1)
	}
	cleanItems := make([]raw.InventoryItem, 12)
	for i, id := range twelve {
		cleanItems[i] = raw.InventoryItem{ID: id}
	}
	cleanPlan := raw.LessonPlan{
		Inventory: raw.DocumentInventory{Items: cleanItems},
		Topics:    []raw.TopicPlan{{TopicID: "T12", AssignedQuestionIDs: twelve}},
	}
	if r := topic.VerifyPlan(cleanPlan, ""); r.NeedsRefinement || len(r.OverloadedTopics) != 0 || len(r.UnassignedIDs) != 0 || len(r.RedundantTopics) != 0 {
		t.Errorf("12 questions (exact max) must be clean, got %+v", r)
	}

	thirteen := append(append([]string(nil), twelve...), "Q13")
	overItems := append(append([]raw.InventoryItem(nil), cleanItems...), raw.InventoryItem{ID: "Q13"})
	overOnly := topic.VerifyPlan(raw.LessonPlan{
		Inventory: raw.DocumentInventory{Items: overItems},
		Topics:    []raw.TopicPlan{{TopicID: "T13", AssignedQuestionIDs: thirteen}},
	}, "")
	if !overOnly.NeedsRefinement || len(overOnly.OverloadedTopics) != 1 || len(overOnly.UnassignedIDs) != 0 || len(overOnly.RedundantTopics) != 0 {
		t.Errorf("expected overloaded-only report, got %+v", overOnly)
	}

	unassignedOnly := topic.VerifyPlan(raw.LessonPlan{
		Inventory: raw.DocumentInventory{Items: []raw.InventoryItem{{ID: "Q1"}, {ID: "Q2"}}},
		Topics:    []raw.TopicPlan{{TopicID: "T1", AssignedQuestionIDs: []string{"Q1"}}},
	}, "")
	if !unassignedOnly.NeedsRefinement || len(unassignedOnly.UnassignedIDs) != 1 || len(unassignedOnly.OverloadedTopics) != 0 || len(unassignedOnly.RedundantTopics) != 0 {
		t.Errorf("expected unassigned-only report, got %+v", unassignedOnly)
	}

	redundantOnly := topic.VerifyPlan(raw.LessonPlan{
		Topics: []raw.TopicPlan{{TopicID: "T_EMPTY"}},
	}, "")
	if !redundantOnly.NeedsRefinement || len(redundantOnly.RedundantTopics) != 1 || len(redundantOnly.UnassignedIDs) != 0 || len(redundantOnly.OverloadedTopics) != 0 {
		t.Errorf("expected redundant-only report, got %+v", redundantOnly)
	}
}

func TestVerifyContent_CompletenessRules(t *testing.T) {
	topicBytes, err := fixtures.ReadFile("testdata/fixtures/topic_content_full.json")
	if err != nil {
		t.Fatalf("read topic fixture: %v", err)
	}
	var tc raw.TopicContent
	if err := json.Unmarshal(topicBytes, &tc); err != nil {
		t.Fatalf("unmarshal topic fixture: %v", err)
	}
	plan := raw.LessonPlan{Topics: []raw.TopicPlan{{TopicID: "T1", Title: "Plan T1"}}}
	if r := topic.VerifyContent([]raw.TopicContent{tc}, plan); r.NeedsRefinement {
		t.Errorf("valid TopicContent must pass, got %+v", r)
	}
	if r := topic.VerifyContent(nil, plan); !r.NeedsRefinement {
		t.Error("empty contents slice must require refinement")
	}

	cases := []struct {
		name     string
		content  raw.TopicContent
		wantFail bool
	}{
		{"NoTheory", raw.TopicContent{TopicID: "T1", Drills: []raw.DrillExercise{{Prompt: "P"}}}, true},
		{"TheoryOnlyNoExamplesVariantsDrills", raw.TopicContent{TopicID: "T_UNLISTED", Title: "Unlisted", TheoryPoints: []string{"L"}}, true},
		{"TheoryWithExamplesOnly", raw.TopicContent{TopicID: "T1", TheoryPoints: []string{"L"}, Examples: []raw.ExampleItem{{Problem: "E"}}}, false},
		{"TheoryWithDrillsOnly", raw.TopicContent{TopicID: "T1", TheoryPoints: []string{"L"}, Drills: []raw.DrillExercise{{Prompt: "P"}}}, false},
		{"VariantWithoutDrillsAndNoTopDrills", raw.TopicContent{TopicID: "T1", TheoryPoints: []string{"L"}, Variants: []raw.VariantGuide{{VariantID: "V1"}}}, true},
		{"VariantWithoutDrillsButTopDrillsPresent", raw.TopicContent{TopicID: "T1", TheoryPoints: []string{"L"}, Variants: []raw.VariantGuide{{VariantID: "V1"}}, Drills: []raw.DrillExercise{{Prompt: "P"}}}, false},
	}
	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			r := topic.VerifyContent([]raw.TopicContent{c.content}, plan)
			if r.NeedsRefinement != c.wantFail {
				t.Errorf("%s: NeedsRefinement=%v, want %v", c.name, r.NeedsRefinement, c.wantFail)
			}
			if c.name == "TheoryOnlyNoExamplesVariantsDrills" && (len(r.RedundantTopics) != 1 || r.RedundantTopics[0].Title != "Unlisted") {
				t.Errorf("expected fallback TopicPlan for unlisted TopicID, got %+v", r.RedundantTopics)
			}
		})
	}
}

func TestFilterTopics_EdgeCases(t *testing.T) {
	plan := raw.LessonPlan{
		Topics: []raw.TopicPlan{{TopicID: "T1"}, {TopicID: "T2"}},
	}
	if got := topic.FilterTopics(plan, nil); len(got.Topics) != 2 {
		t.Errorf("empty selectedIDs should keep all topics, got %d", len(got.Topics))
	}
	if got := topic.FilterTopics(plan, []string{"  ", ""}); len(got.Topics) != 2 {
		t.Errorf("whitespace-only selectedIDs should keep all topics, got %d", len(got.Topics))
	}
	if got := topic.FilterTopics(plan, []string{" t2 "}); len(got.Topics) != 1 || got.Topics[0].TopicID != "T2" {
		t.Errorf("case-insensitive filter failed: %+v", got.Topics)
	}
	if got := topic.FilterTopics(plan, []string{"MISSING"}); len(got.Topics) != 2 {
		t.Errorf("unmatched filter should keep all topics, got %d", len(got.Topics))
	}
}

func FuzzParseTopicContent(f *testing.F) {
	if b, err := fixtures.ReadFile("testdata/fixtures/topic_content_full.json"); err == nil {
		f.Add(string(b))
	}
	f.Add(`{"topic_id":"T1","variants":[{`)
	f.Fuzz(func(t *testing.T, input string) {
		_, _ = topic.ParseTopicContent(input, raw.TopicPlan{TopicID: "T1", Title: "Fallback"})
	})
}
