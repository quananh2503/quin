package pipeline_test

import (
	"context"
	"testing"
	"uuid"

	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/AI/pipeline"
)

type mockPlanner struct {
	lastDocs       []ai.Document
	lastUserPrompt string
	planToReturn   *pipeline.LessonPlan
}

func (m *mockPlanner) Plan(ctx context.Context, docs []ai.Document, userPrompt string) (*pipeline.LessonPlan, *ai.Response, error) {
	m.lastDocs = docs
	m.lastUserPrompt = userPrompt
	return m.planToReturn, &ai.Response{Content: "{}"}, nil
}

func TestLessonGeneratorAdapter_Generate_Success(t *testing.T) {
	mockPlan := &pipeline.LessonPlan{
		LessonTitle: "Bài giảng Tích Vô Hướng",
		Overview:    "Tổng hợp kiến thức vectơ và tích vô hướng",
		Topics: []pipeline.TopicPlan{
			{
				TopicID:      "dang_1",
				Title:        "Xác định góc giữa hai vectơ",
				Difficulty:   "NhanBiet_ThongHieu",
				TargetOutput: "Tính góc (u, v)",
				CoreConcept:  "cos(u, v) = u.v / (|u|.|v|)",
			},
		},
	}

	planner := &mockPlanner{planToReturn: mockPlan}
	adapter := pipeline.NewLessonGeneratorAdapter(nil, planner)

	mistake := lesson.NewMistakeMaterial(uuid.New(), uuid.New(), "Góc giữa 2 vectơ", "Nhầm lẫn chiều vectơ", nil)
	materials := []lesson.StudyMaterial{mistake}

	lessonResult, errGen := adapter.Generate(context.Background(), "Tích vô hướng", materials, "deepseek-flash", "Chỉ dẫn chi tiết")
	if errGen != nil {
		t.Fatalf("Generate thất bại: %v", errGen)
	}

	if lessonResult == nil {
		t.Fatalf("lessonResult nil")
	}
	if lessonResult.Title().String() != "Bài giảng Tích Vô Hướng" {
		t.Errorf("Tiêu đề bài học sai: %s", lessonResult.Title().String())
	}
	if len(lessonResult.Sections()) == 0 {
		t.Fatalf("Sections rỗng")
	}
}

func TestLessonGeneratorAdapter_Generate_EmptyMaterials(t *testing.T) {
	adapter := pipeline.NewLessonGeneratorAdapter(nil, &mockPlanner{})
	_, err := adapter.Generate(context.Background(), "Tiêu đề", nil, "deepseek-flash", "")
	if err == nil {
		t.Fatalf("Kỳ vọng lỗi khi materials rỗng")
	}
}
