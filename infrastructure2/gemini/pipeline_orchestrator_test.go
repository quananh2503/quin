package gemini_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"meet-attendance-clean/infrastructure2/gemini"
	"meet-attendance-clean/infrastructure2/gemini/mocks"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

func TestDefaultLessonPipeline_Execute_Success(t *testing.T) {
	ctx := context.Background()

	mockPlanner := mocks.NewPlannerStage(t)
	mockAuthor := mocks.NewAuthoringStage(t)
	mockVisual := mocks.NewVisualEnrichmentStage(t)
	mockQG := mocks.NewQualityGateStage(t)

	pipeline := gemini.NewDefaultLessonPipeline(mockPlanner, mockAuthor, mockVisual, mockQG)

	req := gemini.PipelineRequest{
		Documents: []gemini.DocumentInput{
			{DocID: "DOC_1", FileName: "hinh_hoc.pdf"},
		},
		UserInstruction: "Soạn bài chuyên đề tọa độ",
		OutputDir:       "test_out",
	}

	expectedPlan := &gemini.LessonPlan{
		LessonTitle: "Tọa độ không gian",
		Topics:      []gemini.Topic{{TopicID: "T1", Title: "Dạng 1"}},
	}
	expectedWorkers := []gemini.WorkerResult{
		{
			TopicID:      "T1",
			Title:        "Dạng 1",
			TheoryPoints: []string{"$x = y$"},
		},
	}
	expectedQGOutput := &gemini.PipelineOutput{
		TeacherPDFPath: "test_out/teacher.pdf",
		StudentPDFPath: "test_out/student.pdf",
		Duration:       50 * time.Millisecond,
	}

	// 1. Planner Stage
	mockPlanner.On("Plan", mock.Anything, req.Documents, req.UserInstruction).
		Return(expectedPlan, nil).Once()

	// 2. Authoring Stage
	mockAuthor.On("Author", mock.Anything, req.Documents, expectedPlan).
		Return(expectedWorkers, nil).Once()

	// 3. Visual Enrichment Stage (Stage 2.5 Hook)
	mockVisual.On("Enrich", mock.Anything, expectedPlan, expectedWorkers).
		Return(expectedWorkers, nil).Once()

	// 4. Quality Gate Stage
	mockQG.On("VerifyAndCompile", mock.Anything, expectedPlan, expectedWorkers, req.OutputDir).
		Return(expectedQGOutput, nil).Once()

	out, err := pipeline.Execute(ctx, req)
	assert.NoError(t, err)
	assert.NotNil(t, out)
	assert.Equal(t, expectedPlan, out.Plan)
	assert.Equal(t, expectedWorkers, out.Workers)
	assert.Equal(t, "test_out/teacher.pdf", out.TeacherPDFPath)
	assert.Equal(t, "test_out/student.pdf", out.StudentPDFPath)

	mockPlanner.AssertExpectations(t)
	mockAuthor.AssertExpectations(t)
	mockVisual.AssertExpectations(t)
	mockQG.AssertExpectations(t)
}

func TestDefaultLessonPipeline_Execute_PlannerFails(t *testing.T) {
	ctx := context.Background()

	mockPlanner := mocks.NewPlannerStage(t)
	mockAuthor := mocks.NewAuthoringStage(t)
	mockVisual := mocks.NewVisualEnrichmentStage(t)
	mockQG := mocks.NewQualityGateStage(t)
	pipeline := gemini.NewDefaultLessonPipeline(mockPlanner, mockAuthor, mockVisual, mockQG)

	mockPlanner.On("Plan", mock.Anything, mock.Anything, mock.Anything).
		Return(nil, errors.New("planner LLM rate limit")).Once()

	req := gemini.PipelineRequest{
		Documents: []gemini.DocumentInput{{DocID: "DOC_1"}},
	}

	out, err := pipeline.Execute(ctx, req)
	assert.Error(t, err)
	assert.Nil(t, out)
	assert.Contains(t, err.Error(), "planner LLM rate limit")

	mockPlanner.AssertExpectations(t)
}

func TestDefaultLessonPipeline_Execute_AuthoringFails(t *testing.T) {
	ctx := context.Background()

	mockPlanner := mocks.NewPlannerStage(t)
	mockAuthor := mocks.NewAuthoringStage(t)
	mockVisual := mocks.NewVisualEnrichmentStage(t)
	mockQG := mocks.NewQualityGateStage(t)
	pipeline := gemini.NewDefaultLessonPipeline(mockPlanner, mockAuthor, mockVisual, mockQG)

	plan := &gemini.LessonPlan{
		LessonTitle: "Tọa độ không gian",
		Topics:      []gemini.Topic{{TopicID: "T1"}},
	}

	mockPlanner.On("Plan", mock.Anything, mock.Anything, mock.Anything).Return(plan, nil).Once()
	mockAuthor.On("Author", mock.Anything, mock.Anything, plan).
		Return(nil, errors.New("worker execution failed")).Once()

	out, err := pipeline.Execute(ctx, gemini.PipelineRequest{})
	assert.Error(t, err)
	assert.Nil(t, out)
	assert.Contains(t, err.Error(), "worker execution failed")

	mockPlanner.AssertExpectations(t)
	mockAuthor.AssertExpectations(t)
}

func TestDefaultLessonPipeline_Execute_MissingStages(t *testing.T) {
	pipeline := gemini.NewDefaultLessonPipeline(nil, nil, nil, nil)
	_, err := pipeline.Execute(context.Background(), gemini.PipelineRequest{})
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "pipeline chưa được cấu hình đầy đủ")
}

func TestDefaultLessonPipeline_Execute_WithReviewerAndPolisher(t *testing.T) {
	ctx := context.Background()

	mockPlanner := mocks.NewPlannerStage(t)
	mockReviewer := mocks.NewPlanReviewerStage(t)
	mockPolisher := mocks.NewPlanPolisherStage(t)
	mockAuthor := mocks.NewAuthoringStage(t)
	mockVisual := mocks.NewVisualEnrichmentStage(t)
	mockQG := mocks.NewQualityGateStage(t)

	pipeline := gemini.NewDefaultLessonPipeline(mockPlanner, mockAuthor, mockVisual, mockQG).
		WithReviewer(mockReviewer).
		WithPolisher(mockPolisher)

	req := gemini.PipelineRequest{
		Documents: []gemini.DocumentInput{{DocID: "DOC_1"}},
		OutputDir: "test_out",
	}

	rawPlan := &gemini.LessonPlan{
		LessonTitle: "Toán học",
		Topics:      []gemini.Topic{{TopicID: "T1", Title: "Dạng 1"}},
	}
	reviewedPlan := &gemini.LessonPlan{
		LessonTitle: "Toán học",
		Topics:      []gemini.Topic{{TopicID: "T1", Title: "Dạng 1"}, {TopicID: "T2", Title: "Dạng 2"}},
	}
	polishedPlan := &gemini.LessonPlan{
		LessonTitle: "Toán học",
		Topics:      []gemini.Topic{{TopicID: "T2", Title: "Dạng 2"}, {TopicID: "T1", Title: "Dạng 1"}},
	}

	mockPlanner.On("Plan", mock.Anything, req.Documents, req.UserInstruction).Return(rawPlan, nil).Once()
	mockReviewer.On("Review", mock.Anything, rawPlan, req.Documents).Return(reviewedPlan, nil).Once()
	mockPolisher.On("Polish", mock.Anything, reviewedPlan).Return(polishedPlan, nil).Once()
	mockAuthor.On("Author", mock.Anything, req.Documents, polishedPlan).Return([]gemini.WorkerResult{}, nil).Once()
	mockVisual.On("Enrich", mock.Anything, polishedPlan, mock.Anything).Return([]gemini.WorkerResult{}, nil).Once()
	mockQG.On("VerifyAndCompile", mock.Anything, polishedPlan, mock.Anything, req.OutputDir).
		Return(&gemini.PipelineOutput{Plan: polishedPlan}, nil).Once()

	out, err := pipeline.Execute(ctx, req)
	assert.NoError(t, err)
	assert.NotNil(t, out)
	assert.Equal(t, polishedPlan, out.Plan)

	mockPlanner.AssertExpectations(t)
	mockReviewer.AssertExpectations(t)
	mockPolisher.AssertExpectations(t)
	mockAuthor.AssertExpectations(t)
	mockVisual.AssertExpectations(t)
	mockQG.AssertExpectations(t)
}
