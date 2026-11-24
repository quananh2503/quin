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
	if !strings.Contains(llmResp.Usage.RawJSON, `"prompt_cache_hit_tokens":960`) {
		t.Errorf("Usage.RawJSON missing expected field: %s", llmResp.Usage.RawJSON)
	}
	if llmResp.FinishReason != "stop" || llmResp.Raw == "" {
		t.Errorf("expected FinishReason='stop' and non-empty Raw: %+v", llmResp)
	}

	// Fallback to ReasoningContent when Content is empty
	reasoningResp := raw.ChatResponse{
		Choices: []raw.Choice{
			{Message: raw.ChoiceMessage{Content: "   ", ReasoningContent: `{"total_items": 1, "items": [{"id":"X"}]}`}},
		},
	}
	fallbackOut, err := process.ExtractLLMResponse(reasoningResp, nil, "deepseek-reasoner")
	if err != nil || !strings.Contains(fallbackOut.Content, `"total_items"`) || fallbackOut.ReasoningContent == "" {
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
	if _, errBadPlan := process.ParseLessonPlan(`not valid json`, inv); errBadPlan == nil {
		t.Fatal("expected error when LessonPlan JSON is invalid")
	}

	planWithInv := `{"lesson_title":"X","topics":[{"topic_id":"T1"}],"inventory":{"total_items":2,"items":[{"id":"K1"}]}}`
	parsedPlan, err := process.ParseLessonPlan(planWithInv, raw.DocumentInventory{TotalItems: 99})
	if err != nil {
		t.Fatalf("ParseLessonPlan failed: %v", err)
	}
	if parsedPlan.Inventory.TotalItems != 2 || len(parsedPlan.Inventory.Items) != 1 {
		t.Errorf("empty inventory arg must not overwrite parsed plan inventory: %+v", parsedPlan.Inventory)
	}
}

func TestSanitizeRawJSONLaTeX_FencesBracketsAndVec(t *testing.T) {
	cases := []struct {
		name  string
		input string
		want  string
	}{
		{"FenceWithoutBraces", "```json\nhello\n```", "hello"},
		{"FenceUnclosed", "```json\nplain_body", "plain_body"},
		{"FenceNoNewline", "```inline```", "```inline"},
		{"ArrayLeadingBeforeObject", `prefix [{"a":1}] suffix`, `[{"a":1}]`},
		{"ArrayOnly", `lead [1, 2] tail`, `[1, 2]`},
		{"ObjectLeadingBeforeArray", `lead {"arr":[1,2]} tail`, `{"arr":[1,2]}`},
		{"UnclosedObjectPassesThrough", `lead {"arr":1`, `lead {"arr":1`},
		{"UnclosedArrayPassesThrough", `lead [1, 2`, `lead [1, 2`},
		{"OverlineAndArrow", `{"v":"\overline{AB}","p":"\overrightarrow{CD}"}`, `{"v":"\\vec{AB}","p":"\\vec{CD}"}`},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := process.SanitizeRawJSONLaTeX(tc.input); got != tc.want {
				t.Errorf("%s: got %q, want %q", tc.name, got, tc.want)
			}
		})
	}

	ctrl := "{\"iff\":\"\x0Deftrightarrow\",\"imp\":\"\x0DRightarrow\",\"neq\":\"a\x0Aeq\"}"
	fixed := process.SanitizeRawJSONLaTeX(ctrl)
	if !strings.Contains(fixed, `\\Leftrightarrow`) || !strings.Contains(fixed, `\\Rightarrow`) || !strings.Contains(fixed, `\\neq`) {
		t.Errorf("control char replacement failed: %s", fixed)
	}
}

func TestRepairTruncatedJSON_NestedEscapedAndMismatched(t *testing.T) {
	cases := []struct {
		name  string
		input string
		want  string
	}{
		{"ClosedObjectAndArray", `{"items":[{"id":"1"}],"extra":{"k":"v`, `{"items":[{"id":"1"}],"extra":{"k":"v"}}`},
		{"EscapedQuoteInString", `{"a":"x\"y","b":["z`, `{"a":"x\"y","b":["z"]}`},
		{"LeadingUnmatchedClosers", `}]{"a":[1`, `}]{"a":[1]}`},
		{"MismatchedCloserDoesNotPop", `[{"a":1]`, `[{"a":1]}]`},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := process.RepairTruncatedJSON(tc.input); got != tc.want {
				t.Errorf("%s: got %q, want %q", tc.name, got, tc.want)
			}
		})
	}
}

func TestParseInventory_TruncatedAndTotalItems(t *testing.T) {
	truncInv := `{"items":[{"id":"I1","snippet":"Đề`
	inv, err := process.ParseInventory(truncInv)
	if err != nil {
		t.Fatalf("ParseInventory failed on truncated JSON: %v", err)
	}
	if inv.TotalItems != 1 || len(inv.Items) != 1 || inv.Items[0].ID != "I1" {
		t.Errorf("unexpected repaired inventory: %+v", inv)
	}

	explicitInv, err := process.ParseInventory(`{"total_items":5,"items":[{"id":"I1"}]}`)
	if err != nil || explicitInv.TotalItems != 5 {
		t.Errorf("explicit TotalItems should be preserved, got %+v err=%v", explicitInv, err)
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
