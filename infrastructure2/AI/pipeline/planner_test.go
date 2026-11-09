package pipeline_test

import (
	"context"
	"testing"

	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/AI/pipeline"
)

type mockAIProvider struct {
	responseContent string
	responses       []string
	callCount       int
	lastRequest     ai.Request
	err             error
}

func (m *mockAIProvider) Name() string { return "mock" }
func (m *mockAIProvider) Generate(ctx context.Context, req ai.Request) (*ai.Response, error) {
	m.lastRequest = req
	if m.err != nil {
		return nil, m.err
	}
	respContent := m.responseContent
	if len(m.responses) > 0 {
		if m.callCount < len(m.responses) {
			respContent = m.responses[m.callCount]
		} else {
			respContent = m.responses[len(m.responses)-1]
		}
		m.callCount++
	}
	return &ai.Response{
		Content: respContent,
		Usage:   ai.NewSimpleUsage("{}", 100),
		Model:   req.Model,
	}, nil
}

func TestDefaultPlanner_Plan_Success(t *testing.T) {
	mockInventoryJSON := `{
		"total_items": 3,
		"items": [
			{"id": "DOC1_B1_HD1", "source_name": "SGK", "source_label": "HĐ 1", "item_type": "hoat_dong", "snippet": "Đơn điệu cơ bản"},
			{"id": "DOC1_B1_VD1", "source_name": "SGK", "source_label": "VD 1", "item_type": "vi_du", "snippet": "Xét dấu đạo hàm"},
			{"id": "DOC1_B1_BT1", "source_name": "SGK", "source_label": "BT 1", "item_type": "bai_tap", "snippet": "Tìm m để hàm đồng biến"}
		]
	}`

	mockPlanJSON := `{
		"lesson_title": "Khảo sát hàm số nâng cao",
		"overview": "Tổng hợp các dạng toán hàm số và đồ thị GDPT 2018",
		"topics": [
			{
				"topic_id": "dang_1",
				"title": "Tính đơn điệu của hàm số chứa tham số",
				"difficulty": "VanDung",
				"target_output": "Tìm tham số m để hàm số đồng biến trên R",
				"core_concept": "Xét dấu y' >= 0 với mọi x thuộc R",
				"assigned_question_ids": ["DOC1_B1_HD1", "DOC1_B1_VD1", "DOC1_B1_BT1"],
				"source_refs": ["DOC_1 trang 1"]
			}
		]
	}`

	mock := &mockAIProvider{
		responses: []string{mockInventoryJSON, mockPlanJSON},
	}
	planner := pipeline.NewPlanner(mock, "deepseek-flash")

	doc := ai.NewDocument("DOC_1", "sgk.pdf", ai.NewTextPart("Nội dung khảo sát hàm số"))
	plan, resp, err := planner.Plan(context.Background(), []ai.Document{doc}, "Tập trung dạy học sinh yếu")
	if err != nil {
		t.Fatalf("Plan thất bại: %v", err)
	}
	if resp == nil {
		t.Fatalf("resp nil")
	}

	if plan.LessonTitle != "Khảo sát hàm số nâng cao" {
		t.Errorf("LessonTitle sai: %s", plan.LessonTitle)
	}
	if len(plan.Topics) != 1 {
		t.Fatalf("Số lượng Topics sai: %d", len(plan.Topics))
	}
	if plan.Topics[0].TopicID != "dang_1" {
		t.Errorf("TopicID sai: %s", plan.Topics[0].TopicID)
	}
	if plan.Inventory.TotalItems != 3 {
		t.Errorf("Kỳ vọng 3 items trong Inventory, nhận được: %d", plan.Inventory.TotalItems)
	}
}

func TestDefaultPlanner_PlanFromInventory_Success(t *testing.T) {
	mockPlanJSON := `{
		"lesson_title": "Hình học không gian",
		"overview": "Vectơ và tọa độ",
		"topics": [
			{
				"topic_id": "T1",
				"title": "Định nghĩa vectơ",
				"difficulty": "NhanBiet",
				"target_output": "Nhận biết vectơ",
				"core_concept": "Vectơ là đoạn thẳng có hướng",
				"assigned_question_ids": ["DOC1_HD1"]
			}
		]
	}`

	mock := &mockAIProvider{responseContent: mockPlanJSON}
	planner := pipeline.NewPlanner(mock, "deepseek-flash")

	inv := &pipeline.DocumentInventory{
		TotalItems: 1,
		Items: []pipeline.InventoryItem{
			{ID: "DOC1_HD1", SourceName: "SGK", SourceLabel: "HĐ 1", ItemType: "hoat_dong", Snippet: "Khái niệm vectơ"},
		},
	}

	plan, resp, err := planner.PlanFromInventory(context.Background(), inv, "")
	if err != nil {
		t.Fatalf("PlanFromInventory thất bại: %v", err)
	}
	if resp == nil {
		t.Fatal("Response nil")
	}
	if len(plan.Topics) != 1 || plan.Topics[0].TopicID != "T1" {
		t.Errorf("Kỳ vọng Topic T1, nhận được %v", plan.Topics)
	}
}

func TestDefaultPlanner_Plan_EmptyDocs(t *testing.T) {
	mock := &mockAIProvider{responseContent: "{}"}
	planner := pipeline.NewPlanner(mock, "deepseek-flash")

	_, _, err := planner.Plan(context.Background(), nil, "")
	if err == nil {
		t.Fatalf("Kỳ vọng lỗi khi docs rỗng")
	}
}

func TestDefaultPlanner_PlanFromInventory_NilInventory(t *testing.T) {
	mock := &mockAIProvider{responseContent: "{}"}
	planner := pipeline.NewPlanner(mock, "deepseek-flash")

	_, _, err := planner.PlanFromInventory(context.Background(), nil, "")
	if err == nil {
		t.Fatalf("Kỳ vọng lỗi khi inventory nil")
	}
}
