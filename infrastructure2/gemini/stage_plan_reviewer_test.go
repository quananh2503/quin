package gemini_test

import (
	"context"
	"errors"
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"
	"meet-attendance-clean/infrastructure2/gemini/mocks"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"
)

func TestDefaultPlanReviewerStage_NoRefinementNeeded(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	mockAuditor := mocks.NewPlanAuditor(t)

	reviewer := gemini.NewDefaultPlanReviewerStage(mockLLM, mockAuditor, "model-test")

	originalPlan := &gemini.LessonPlan{
		LessonTitle: "Bài 1",
		Topics: []gemini.Topic{
			{TopicID: "dang_1", Title: "Dạng 1"},
		},
	}

	mockAuditor.On("Audit", originalPlan).Return(gemini.AuditReport{
		NeedsRefinement: false,
	}).Once()

	refined, err := reviewer.Review(context.Background(), originalPlan, nil)
	require.NoError(t, err)
	assert.Equal(t, originalPlan, refined)

	mockAuditor.AssertExpectations(t)
	mockLLM.AssertNotCalled(t, "GenerateJSON")
}

func TestDefaultPlanReviewerStage_RefinesPlanWithLLM(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	mockAuditor := mocks.NewPlanAuditor(t)

	reviewer := gemini.NewDefaultPlanReviewerStage(mockLLM, mockAuditor, "model-test")

	originalPlan := &gemini.LessonPlan{
		LessonTitle: "Bài 1",
		Topics: []gemini.Topic{
			{TopicID: "dang_1", Title: "Dạng cũ bị quá tải", AssignedQuestionIDs: []string{"C1", "C2"}},
			{TopicID: "dang_2", Title: "Dạng giữ nguyên", AssignedQuestionIDs: []string{"C3"}},
		},
	}

	mockAuditor.On("Audit", originalPlan).Return(gemini.AuditReport{
		NeedsRefinement:  true,
		UnassignedIDs:    []string{"E5 (Tính góc)"},
		OverloadedTopics: []gemini.Topic{{TopicID: "dang_1", Title: "Dạng cũ bị quá tải"}},
	}).Once()

	rawDeltaJSON := `{
		"additional_topics": [
			{"topic_id": "new_1", "title": "Dạng mới tách 1", "assigned_question_ids": ["C1"]},
			{"topic_id": "new_2", "title": "Dạng bổ sung câu E5", "assigned_question_ids": ["E5"]}
		]
	}`

	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == "model-test" && len(req.JSONSchema) > 0
	})).Return(&gemini.LLMResponse{RawJSON: rawDeltaJSON}, nil).Once()

	refined, err := reviewer.Review(context.Background(), originalPlan, nil)
	require.NoError(t, err)
	require.NotNil(t, refined)

	// Dạng dang_1 bị gộp quá tải đã bị loại bỏ, dạng_2 được giữ, cộng thêm 2 dạng mới = 3 dạng
	assert.Len(t, refined.Topics, 3)
	assert.Equal(t, "dang_1", refined.Topics[0].TopicID)
	assert.Equal(t, "Dạng giữ nguyên", refined.Topics[0].Title)
	assert.Equal(t, "dang_2", refined.Topics[1].TopicID)
	assert.Equal(t, "Dạng mới tách 1", refined.Topics[1].Title)
	assert.Equal(t, "dang_3", refined.Topics[2].TopicID)
	assert.Equal(t, "Dạng bổ sung câu E5", refined.Topics[2].Title)

	mockAuditor.AssertExpectations(t)
	mockLLM.AssertExpectations(t)
}

func TestDefaultPlanReviewerStage_LLMErrorGracefulFallback(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	mockAuditor := mocks.NewPlanAuditor(t)

	reviewer := gemini.NewDefaultPlanReviewerStage(mockLLM, mockAuditor, "model-test")

	originalPlan := &gemini.LessonPlan{
		LessonTitle: "Bài 1",
		Topics: []gemini.Topic{
			{TopicID: "dang_1", Title: "Dạng 1"},
		},
	}

	mockAuditor.On("Audit", originalPlan).Return(gemini.AuditReport{
		NeedsRefinement: true,
		UnassignedIDs:   []string{"C10"},
	}).Once()

	mockLLM.On("GenerateJSON", mock.Anything, mock.Anything).
		Return(nil, errors.New("rate limit or quota exceeded")).Once()

	refined, err := reviewer.Review(context.Background(), originalPlan, nil)
	// Graceful fallback: không làm sập pipeline, giữ nguyên plan cũ kèm log
	assert.NoError(t, err)
	assert.Equal(t, originalPlan, refined)

	mockAuditor.AssertExpectations(t)
	mockLLM.AssertExpectations(t)
}

func TestDefaultPlanReviewerStage_NilAuditor(t *testing.T) {
	reviewer := gemini.NewDefaultPlanReviewerStage(nil, nil, "model-test")

	plan := &gemini.LessonPlan{LessonTitle: "Bài 1"}
	refined, err := reviewer.Review(context.Background(), plan, nil)
	assert.NoError(t, err)
	assert.Equal(t, plan, refined)
}
