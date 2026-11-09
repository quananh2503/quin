package pipeline_test

import (
	"context"
	"os"
	"path/filepath"
	"testing"

	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/AI/pipeline"
)

type mockVerifier struct {
	report *pipeline.AuditReport
	err    error
}

func (m *mockVerifier) VerifyPlan(ctx context.Context, plan *pipeline.LessonPlan, docs []ai.Document, userPrompt string) (*pipeline.AuditReport, error) {
	if m.err != nil {
		return nil, m.err
	}
	if m.report != nil {
		return m.report, nil
	}
	return &pipeline.AuditReport{NeedsRefinement: false}, nil
}

func (m *mockVerifier) VerifyContent(ctx context.Context, contents []pipeline.TopicContent, plan *pipeline.LessonPlan, userPrompt string) (*pipeline.AuditReport, error) {
	return &pipeline.AuditReport{NeedsRefinement: false}, nil
}

func TestDefaultOrchestrator_Execute_Success(t *testing.T) {
	ctx := context.Background()

	// 1. Mock Planner
	mockInventory := `{
		"total_items": 1,
		"items": [
			{"id": "item_1", "source_name": "SGK", "source_label": "HĐ 1", "item_type": "hoat_dong", "snippet": "Vectơ"}
		]
	}`
	mockPlan := `{
		"lesson_id": "L1",
		"lesson_title": "Hình học không gian vectơ",
		"overview": "Tổng quan bài học",
		"topics": [
			{
				"topic_id": "T1",
				"title": "Khái niệm vectơ",
				"assigned_item_ids": ["item_1"]
			}
		]
	}`
	plannerAI := &mockAIProvider{
		responses: []string{mockInventory, mockPlan},
	}
	planner := pipeline.NewPlanner(plannerAI, "deepseek-flash")

	// 2. Mock Generator
	mockTopic := `{
		"topic_id": "T1",
		"title": "Khái niệm vectơ",
		"theory_points": ["Vectơ là đoạn thẳng có hướng $\\vec{a}$."],
		"variants": [
			{
				"variant_id": "V1",
				"recognition": "Đề bài cho tứ diện $ABCD$.",
				"action_steps": ["Bước 1: Xác định điểm đầu và cuối."],
				"drills": [
					{
						"prompt": "Cho hình chóp $S.ABCD$.",
						"solution": "Có $8$ vectơ."
					}
				]
			}
		]
	}`
	genAI := &mockAIProvider{
		responseContent: mockTopic,
	}
	generator := pipeline.NewGenerator(genAI, "deepseek-flash", 2)

	// 3. Verifier
	verifier := &mockVerifier{}

	// 4. Repairer
	repairer := pipeline.NewRepairer(nil, "")

	// 5. Assembler
	assembler := pipeline.NewAssembler()

	// 6. Orchestrator
	orchestrator := pipeline.NewOrchestrator(
		nil,
		planner,
		generator,
		verifier,
		repairer,
		assembler,
	)

	// Chuẩn bị thư mục tạm để xuất file
	tmpDir := t.TempDir()

	req := pipeline.PipelineRequest{
		Title: "Bài 1: Vectơ không gian",
		Documents: []ai.Document{
			ai.NewDocument("DOC1", "source.txt", ai.NewTextPart("Nội dung bài học về vectơ trong không gian")),
		},
		UserPrompt: "Dành cho học sinh yếu mất gốc",
		OutputDir:  tmpDir,
	}

	res, err := orchestrator.Execute(ctx, req)
	if err != nil {
		t.Fatalf("Orchestrator.Execute() failed: %v", err)
	}

	if res == nil {
		t.Fatal("Orchestrator.Execute() returned nil result")
	}

	if res.Plan == nil || res.Plan.LessonTitle != "Hình học không gian vectơ" {
		t.Errorf("Plan title mismatch: %+v", res.Plan)
	}

	if len(res.TopicsContent) != 1 || res.TopicsContent[0].TopicID != "T1" {
		t.Errorf("TopicsContent mismatch: %+v", res.TopicsContent)
	}

	if res.TeacherTypst == "" || res.StudentTypst == "" {
		t.Errorf("Typst markup is empty")
	}

	// Kiểm tra các file đã được ghi vào raw_data
	planFile := filepath.Join(tmpDir, "raw_data", "plan_output.json")
	if _, err := os.Stat(planFile); err != nil {
		t.Errorf("File %s không tồn tại", planFile)
	}

	contentFile := filepath.Join(tmpDir, "raw_data", "topics_content.json")
	if _, err := os.Stat(contentFile); err != nil {
		t.Errorf("File %s không tồn tại", contentFile)
	}

	typFile := filepath.Join(tmpDir, "raw_data", "lesson.typ")
	if _, err := os.Stat(typFile); err != nil {
		t.Errorf("File %s không tồn tại", typFile)
	}
}

func TestDefaultOrchestrator_Execute_EmptyDocuments(t *testing.T) {
	orchestrator := pipeline.NewOrchestrator(nil, nil, nil, nil, nil, nil)
	_, err := orchestrator.Execute(context.Background(), pipeline.PipelineRequest{})
	if err == nil {
		t.Error("Execute with empty documents should return error, got nil")
	}
}

func TestDefaultOrchestrator_Execute_NilPlanner(t *testing.T) {
	orchestrator := pipeline.NewOrchestrator(nil, nil, nil, nil, nil, nil)
	req := pipeline.PipelineRequest{
		Documents: []ai.Document{
			ai.NewDocument("DOC1", "doc1.txt", ai.NewTextPart("test")),
		},
	}
	_, err := orchestrator.Execute(context.Background(), req)
	if err == nil {
		t.Error("Execute with nil planner should return error, got nil")
	}
}
