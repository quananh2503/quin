package prompts_test

import (
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/AI/internal/encode/prompts"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

func TestHarvesterRequest(t *testing.T) {
	docs := []raw.Document{
		{ID: "DOC1", Name: "sgk.pdf", Parts: []raw.Part{{MimeType: "image/jpeg", Data: []byte{1, 2, 3}}}},
	}
	req, err := prompts.HarvesterRequest(docs, "deepseek-flash", 0)
	if err != nil {
		t.Fatalf("HarvesterRequest failed: %v", err)
	}
	if !strings.Contains(req.SystemPrompt, `"items"`) || !strings.Contains(req.UserPrompt, "DOC1_B1_HD1") {
		t.Errorf("harvester prompt missing schema or ID conventions")
	}
	if len(req.Documents) != 1 {
		t.Errorf("Documents len = %d, want 1", len(req.Documents))
	}

	if _, errEmpty := prompts.HarvesterRequest(nil, "deepseek-flash", 0); errEmpty == nil {
		t.Fatal("expected error when docs is empty")
	}
}

func TestPlannerRequest(t *testing.T) {
	inv := raw.DocumentInventory{
		TotalItems: 2,
		Items: []raw.InventoryItem{
			{ID: "DOC1_HD1", SourceName: "SGK", SourceLabel: "HĐ 1", ItemType: "hoat_dong", Snippet: "Lực căng", HasSolution: true},
			{ID: "DOC1_BT1", SourceName: "SGK", SourceLabel: "BT 1", ItemType: "bai_tap", Snippet: "Tính góc $(\\vec{u}, \\vec{v})$"},
		},
	}
	req, err := prompts.PlannerRequest(inv, "Dạy kỹ học sinh mất gốc", "deepseek-chat", 0)
	if err != nil {
		t.Fatalf("PlannerRequest failed: %v", err)
	}
	if !strings.Contains(req.SystemPrompt, `"topics"`) || !strings.Contains(req.UserPrompt, "DOC1_HD1") {
		t.Errorf("planner prompt missing schema or inventory items")
	}
	if len(req.Documents) != 0 {
		t.Errorf("planner request should not resend image documents, got %d", len(req.Documents))
	}

	if _, errEmpty := prompts.PlannerRequest(raw.DocumentInventory{}, "", "deepseek-flash", 0); errEmpty == nil {
		t.Fatal("expected error when inventory has 0 items")
	}
}

func TestTopicRequest(t *testing.T) {
	topic := raw.TopicPlan{
		TopicID:             "T1",
		Title:               "Khái niệm vectơ",
		Difficulty:          "NhanBiet",
		TargetOutput:        "Nhận diện vectơ",
		CoreConcept:         "Đoạn thẳng có hướng",
		AssignedQuestionIDs: []string{"DOC1_HD1", "MISSING_ID"},
		Variants:            []string{"Xác định vectơ bằng nhau"},
	}
	inv := raw.DocumentInventory{
		TotalItems: 1,
		Items: []raw.InventoryItem{
			{ID: "DOC1_HD1", SourceLabel: "HĐ 1", ItemType: "hoat_dong", Snippet: "Vectơ lực", HasSolution: true},
		},
	}
	docs := []raw.Document{{ID: "DOC1", Name: "sgk.pdf", Parts: []raw.Part{{MimeType: "text/plain", Text: "src"}}}}

	req, err := prompts.TopicRequest(topic, docs, inv, "Nhúng Casio", "deepseek-flash", 0)
	if err != nil {
		t.Fatalf("TopicRequest failed: %v", err)
	}
	if !strings.Contains(req.UserPrompt, "DOC1_HD1") || !strings.Contains(req.UserPrompt, "MISSING_ID") {
		t.Errorf("topic prompt missing assigned question details")
	}
	if !strings.Contains(req.UserPrompt, "Nhúng Casio") {
		t.Errorf("topic prompt missing userPrompt")
	}
	if len(req.Documents) != 1 {
		t.Errorf("topic request should include prefix docs, got %d", len(req.Documents))
	}

	if _, errInvalid := prompts.TopicRequest(raw.TopicPlan{}, nil, raw.DocumentInventory{}, "", "", 0); errInvalid == nil {
		t.Fatal("expected error when TopicID and Title are empty")
	}
}

func TestRepairMathRequest(t *testing.T) {
	tasks := []raw.RepairTask{
		{TargetID: "T1|theory|0", Context: "Lý thuyết", ErrorReason: "Lẻ $", Content: "Vectơ $a"},
	}
	req, err := prompts.RepairMathRequest(tasks, "deepseek-flash")
	if err != nil {
		t.Fatalf("RepairMathRequest failed: %v", err)
	}
	if !strings.Contains(req.UserPrompt, "T1|theory|0") || !strings.Contains(req.SystemPrompt, "repaired_items") {
		t.Errorf("repair prompt missing target_id or schema instructions")
	}

	if _, errEmpty := prompts.RepairMathRequest(nil, ""); errEmpty == nil {
		t.Fatal("expected error when tasks is empty")
	}
}
