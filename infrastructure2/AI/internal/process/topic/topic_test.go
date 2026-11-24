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
}

func TestVerifyPlan_VerifyContent_FilterTopics(t *testing.T) {
	planBytes, err := fixtures.ReadFile("testdata/fixtures/plan_coverage.json")
	if err != nil {
		t.Fatalf("read fixture: %v", err)
	}
	var plan raw.LessonPlan
	if err := json.Unmarshal(planBytes, &plan); err != nil {
		t.Fatalf("unmarshal fixture: %v", err)
	}

	report := topic.VerifyPlan(plan, "Không bỏ sót bài tập")
	if !report.NeedsRefinement {
		t.Error("expected NeedsRefinement=true when DOC1_BT1 is unassigned and T2 has 0 questions")
	}
	if len(report.UnassignedIDs) != 1 || report.UnassignedIDs[0] != "DOC1_BT1" {
		t.Errorf("UnassignedIDs = %v, want [DOC1_BT1]", report.UnassignedIDs)
	}
	if len(report.RedundantTopics) != 1 || report.RedundantTopics[0].TopicID != "T2" {
		t.Errorf("RedundantTopics = %+v, want [T2]", report.RedundantTopics)
	}

	// Overloaded topic (> 12 questions)
	manyIDs := make([]string, 13)
	for i := range manyIDs {
		manyIDs[i] = fmt.Sprintf("Q%d", i+1)
	}
	overPlan := raw.LessonPlan{
		Topics: []raw.TopicPlan{{TopicID: "T_OVER", AssignedQuestionIDs: manyIDs}},
	}
	overReport := topic.VerifyPlan(overPlan, "")
	if len(overReport.OverloadedTopics) != 1 || !overReport.NeedsRefinement {
		t.Errorf("expected OverloadedTopics=1, got %+v", overReport)
	}

	// FilterTopics case-insensitive + unmatched fallback
	filtered := topic.FilterTopics(plan, []string{" t1 "})
	if len(filtered.Topics) != 1 || filtered.Topics[0].TopicID != "T1" {
		t.Errorf("FilterTopics failed: %+v", filtered.Topics)
	}
	unmatched := topic.FilterTopics(plan, []string{"NON_EXISTENT"})
	if len(unmatched.Topics) != len(plan.Topics) {
		t.Errorf("FilterTopics with no matches should keep original topics")
	}

	// VerifyContent
	topicBytes, err := fixtures.ReadFile("testdata/fixtures/topic_content_full.json")
	if err != nil {
		t.Fatalf("read topic fixture: %v", err)
	}
	var tc raw.TopicContent
	if err := json.Unmarshal(topicBytes, &tc); err != nil {
		t.Fatalf("unmarshal topic fixture: %v", err)
	}
	cleanContentReport := topic.VerifyContent([]raw.TopicContent{tc}, plan)
	if cleanContentReport.NeedsRefinement {
		t.Errorf("expected valid TopicContent to pass VerifyContent, got %+v", cleanContentReport)
	}
	emptyContentReport := topic.VerifyContent([]raw.TopicContent{{TopicID: "T1"}}, plan)
	if !emptyContentReport.NeedsRefinement {
		t.Error("expected empty TopicContent to flag NeedsRefinement=true")
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
