package process_test

import (
	"embed"
	"encoding/json"
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/AI/internal/process"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

//go:embed testdata/fixtures/*
var fixtures embed.FS

func TestExtractLLMResponse_FromGoldenFixture(t *testing.T) {
	data, err := fixtures.ReadFile("testdata/fixtures/chat_response_think.json")
	if err != nil {
		t.Fatalf("read fixture: %v", err)
	}
	var chatResp raw.ChatResponse
	if err := json.Unmarshal(data, &chatResp); err != nil {
		t.Fatalf("unmarshal fixture: %v", err)
	}

	llmResp, err := process.ExtractLLMResponse(chatResp, data, "deepseek-flash")
	if err != nil {
		t.Fatalf("ExtractLLMResponse failed: %v", err)
	}
	if strings.Contains(llmResp.Content, "<think>") {
		t.Errorf("<think> tag was not stripped: %s", llmResp.Content)
	}
	if llmResp.Usage.PromptCacheHitTokens != 960 {
		t.Errorf("PromptCacheHitTokens = %d, want 960", llmResp.Usage.PromptCacheHitTokens)
	}
	if llmResp.Model != "deepseek-flash" {
		t.Errorf("Model = %q, want deepseek-flash", llmResp.Model)
	}

	// Fallback to ReasoningContent when Content is empty
	reasoningResp := raw.ChatResponse{
		Choices: []raw.Choice{
			{Message: raw.ChoiceMessage{Content: "   ", ReasoningContent: `{"total_items": 1, "items": [{"id":"X"}]}`}},
		},
	}
	fallbackOut, err := process.ExtractLLMResponse(reasoningResp, nil, "deepseek-reasoner")
	if err != nil || !strings.Contains(fallbackOut.Content, `"total_items"`) {
		t.Errorf("ReasoningContent fallback failed: out=%+v err=%v", fallbackOut, err)
	}

	// Empty choices error
	if _, errEmpty := process.ExtractLLMResponse(raw.ChatResponse{}, nil, "deepseek-flash"); errEmpty == nil {
		t.Fatal("expected error for empty choices")
	}
}

func TestSanitizeAndParseInventory_DirtyFixture(t *testing.T) {
	dirtyBytes, err := fixtures.ReadFile("testdata/fixtures/inventory_dirty.json")
	if err != nil {
		t.Fatalf("read fixture: %v", err)
	}
	sanitized := process.SanitizeRawJSONLaTeX(string(dirtyBytes))
	if strings.Contains(sanitized, "```") {
		t.Errorf("markdown fence not stripped: %s", sanitized)
	}

	inv, err := process.ParseInventory(string(dirtyBytes))
	if err != nil {
		t.Fatalf("ParseInventory failed on dirty fixture: %v", err)
	}
	if inv.TotalItems != 1 || len(inv.Items) != 1 || inv.Items[0].ID != "DOC1_B1_BT1" {
		t.Errorf("unexpected inventory: %+v", inv)
	}

	// ASCII control char recovery
	ctrl := "{\"arrow\": \"\x0Dightarrow\", \"neq\": \"x \x0Aeq 0\"}"
	fixedCtrl := process.SanitizeRawJSONLaTeX(ctrl)
	if !strings.Contains(fixedCtrl, `\\rightarrow`) || !strings.Contains(fixedCtrl, `\\neq`) {
		t.Errorf("control chars not recovered: %s", fixedCtrl)
	}

	if _, errEmpty := process.ParseInventory(`{"total_items":0,"items":[]}`); errEmpty == nil {
		t.Fatal("expected error for empty inventory items")
	}
	if _, errCorrupt := process.ParseInventory(`not json at all`); errCorrupt == nil {
		t.Fatal("expected error for corrupted inventory JSON")
	}
}

func TestRepairTruncatedJSON_And_ParseLessonPlan(t *testing.T) {
	if got := process.RepairTruncatedJSON(""); got != "{}" {
		t.Errorf("RepairTruncatedJSON empty = %q, want {}", got)
	}
	if got := process.RepairTruncatedJSON(`{"topics":[{"id":"1"`); got != `{"topics":[{"id":"1"}]}` {
		t.Errorf("RepairTruncatedJSON = %q", got)
	}

	truncBytes, err := fixtures.ReadFile("testdata/fixtures/plan_truncated.json")
	if err != nil {
		t.Fatalf("read fixture: %v", err)
	}
	inv := raw.DocumentInventory{
		TotalItems: 1,
		Items:      []raw.InventoryItem{{ID: "DOC1_B1_HD1"}},
	}
	plan, err := process.ParseLessonPlan(string(truncBytes), inv)
	if err != nil {
		t.Fatalf("ParseLessonPlan failed on truncated fixture: %v", err)
	}
	if plan.LessonTitle != "Vectơ trong không gian" || len(plan.Topics) != 1 || plan.Inventory.TotalItems != 1 {
		t.Errorf("unexpected plan: %+v", plan)
	}

	if _, errNoTopics := process.ParseLessonPlan(`{"lesson_title":"X","topics":[]}`, inv); errNoTopics == nil {
		t.Fatal("expected error when topics is empty")
	}
}

func FuzzSanitizeAndParse(f *testing.F) {
	if b, err := fixtures.ReadFile("testdata/fixtures/inventory_dirty.json"); err == nil {
		f.Add(string(b))
	}
	if b, err := fixtures.ReadFile("testdata/fixtures/plan_truncated.json"); err == nil {
		f.Add(string(b))
	}
	f.Add(`{"a": "\frac{1}{2}`)
	f.Add("```json\n{\"total_items\":0}\n```")

	f.Fuzz(func(t *testing.T, input string) {
		sanitized := process.SanitizeRawJSONLaTeX(input)
		_ = process.RepairTruncatedJSON(sanitized)
		_, _ = process.ParseInventory(input)
	})
}
