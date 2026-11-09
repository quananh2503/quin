package pipeline_test

import (
	"context"
	"testing"

	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/AI/pipeline"
)

func TestDefaultHarvester_Harvest_Success(t *testing.T) {
	mockJSON := `{
		"total_items": 2,
		"items": [
			{
				"id": "DOC1_B1_HD1",
				"source_name": "SGK_KNTT_12",
				"source_label": "Hoạt động 1",
				"item_type": "hoat_dong",
				"snippet": "Biểu diễn lực căng dây bằng vectơ",
				"has_solution": true
			},
			{
				"id": "DOC1_B1_VD1",
				"source_name": "SGK_KNTT_12",
				"source_label": "Ví dụ 1",
				"item_type": "vi_du",
				"snippet": "Tứ diện đều, tính độ dài vectơ",
				"has_solution": true
			}
		]
	}`

	mockProv := &mockAIProvider{
		responseContent: mockJSON,
	}

	harvester := pipeline.NewHarvester(mockProv, "deepseek-flash")
	docs := []ai.Document{
		ai.NewDocument("DOC_1", "test.pdf", ai.NewTextPart("Nội dung test")),
	}

	inv, resp, err := harvester.Harvest(context.Background(), docs)
	if err != nil {
		t.Fatalf("Harvest thất bại: %v", err)
	}
	if resp == nil {
		t.Fatal("Response không được nil")
	}
	if inv.TotalItems != 2 || len(inv.Items) != 2 {
		t.Fatalf("Kỳ vọng 2 items, nhận được %d", inv.TotalItems)
	}
	if inv.Items[0].ID != "DOC1_B1_HD1" {
		t.Errorf("Kỳ vọng item ID DOC1_B1_HD1, nhận được %s", inv.Items[0].ID)
	}
}

func TestDefaultHarvester_Harvest_EmptyDocs(t *testing.T) {
	mockProv := &mockAIProvider{}
	harvester := pipeline.NewHarvester(mockProv, "deepseek-flash")

	_, _, err := harvester.Harvest(context.Background(), nil)
	if err == nil {
		t.Fatal("Kỳ vọng lỗi khi docs rỗng, nhận được nil")
	}
}

func TestDefaultHarvester_Harvest_NilProvider(t *testing.T) {
	harvester := pipeline.NewHarvester(nil, "deepseek-flash")
	docs := []ai.Document{
		ai.NewDocument("DOC_1", "test.pdf", ai.NewTextPart("test")),
	}

	_, _, err := harvester.Harvest(context.Background(), docs)
	if err == nil {
		t.Fatal("Kỳ vọng lỗi khi provider nil, nhận được nil")
	}
}

func TestDefaultHarvester_Harvest_EmptyItems(t *testing.T) {
	mockJSON := `{"total_items": 0, "items": []}`
	mockProv := &mockAIProvider{
		responseContent: mockJSON,
	}

	harvester := pipeline.NewHarvester(mockProv, "deepseek-flash")
	docs := []ai.Document{
		ai.NewDocument("DOC_1", "test.pdf", ai.NewTextPart("test")),
	}

	_, _, err := harvester.Harvest(context.Background(), docs)
	if err == nil {
		t.Fatal("Kỳ vọng lỗi khi items rỗng, nhận được nil")
	}
}
