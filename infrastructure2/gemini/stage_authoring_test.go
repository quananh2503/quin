package gemini_test

import (
	"context"
	"errors"
	"fmt"
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"
	"meet-attendance-clean/infrastructure2/gemini/mocks"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

func TestDefaultAuthoringStage_Author_EmptyPlan(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	authorStage := gemini.NewDefaultAuthoringStage(mockLLM, "gemini-2.5", 2)

	// Case 1: Nil plan
	_, err := authorStage.Author(context.Background(), nil, nil)
	assert.Error(t, err)

	// Case 2: Plan with 0 topics
	emptyPlan := &gemini.LessonPlan{LessonTitle: "Trống", Topics: []gemini.Topic{}}
	_, err = authorStage.Author(context.Background(), nil, emptyPlan)
	assert.Error(t, err)
}

func TestDefaultAuthoringStage_Author_ParallelSuccess(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	authorStage := gemini.NewDefaultAuthoringStage(mockLLM, "gemini-2.5", 3)

	plan := &gemini.LessonPlan{
		LessonTitle: "Tọa độ trong không gian",
		Topics: []gemini.Topic{
			{TopicID: "T1", Title: "Dạng 1: Tọa độ điểm", CoreConcept: "Khái niệm", Variants: []string{"V1"}},
			{TopicID: "T2", Title: "Dạng 2: Vectơ", CoreConcept: "Cộng vectơ", Variants: []string{"V2"}},
		},
	}

	workerResp1 := `{
		"topic_id": "T1",
		"theory_points": ["Điểm $M(x;y;z)$"],
		"drills": [{"title": "Bài 1", "prompt": "Tìm $M$", "solution": "Đáp án $M(1;2;3)$"}]
	}`
	workerResp2 := `{
		"topic_id": "T2",
		"theory_points": ["Vectơ $\vec{u}$"],
		"drills": [{"title": "Bài 2", "prompt": "Tìm $\vec{u}$", "solution": "Đáp án $\vec{u}=(1;0;0)$"}]
	}`

	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == "gemini-2.5" && (containsString(req.UserPrompt, "Dạng 1: Tọa độ điểm"))
	})).Return(&gemini.LLMResponse{RawJSON: workerResp1}, nil).Once()

	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == "gemini-2.5" && (containsString(req.UserPrompt, "Dạng 2: Vectơ"))
	})).Return(&gemini.LLMResponse{RawJSON: workerResp2}, nil).Once()

	results, err := authorStage.Author(context.Background(), nil, plan)
	assert.NoError(t, err)
	assert.Len(t, results, 2)

	// Thứ tự các topic BẮT BUỘC giữ nguyên vị trí ban đầu theo plan
	assert.Equal(t, "T1", results[0].TopicID)
	assert.Equal(t, "Dạng 1: Tọa độ điểm", results[0].Title)
	assert.Len(t, results[0].TheoryPoints, 1)

	assert.Equal(t, "T2", results[1].TopicID)
	assert.Equal(t, "Dạng 2: Vectơ", results[1].Title)
	assert.Len(t, results[1].TheoryPoints, 1)

	mockLLM.AssertExpectations(t)
}

func TestDefaultAuthoringStage_Author_WorkerFailure(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	authorStage := gemini.NewDefaultAuthoringStage(mockLLM, "gemini-2.5", 2)

	plan := &gemini.LessonPlan{
		Topics: []gemini.Topic{
			{TopicID: "T1", Title: "Dạng 1"},
		},
	}

	mockLLM.On("GenerateJSON", mock.Anything, mock.Anything).
		Return(nil, errors.New("rate limit from API")).Once()

	results, err := authorStage.Author(context.Background(), nil, plan)
	assert.Error(t, err)
	assert.Nil(t, results)
	assert.Contains(t, err.Error(), "rate limit from API")

	mockLLM.AssertExpectations(t)
}

func TestDefaultAuthoringStage_Author_ContextCancelled(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	authorStage := gemini.NewDefaultAuthoringStage(mockLLM, "gemini-2.5", 1)

	ctx, cancel := context.WithCancel(context.Background())
	cancel() // Hủy context ngay lập tức

	plan := &gemini.LessonPlan{
		Topics: []gemini.Topic{{TopicID: "T1", Title: "Dạng 1"}},
	}

	_, err := authorStage.Author(ctx, nil, plan)
	assert.Error(t, err)
	assert.True(t, errors.Is(err, context.Canceled))
}

func containsString(s, substr string) bool {
	return len(s) >= len(substr) && fmt.Sprintf("%v", s) != "" && (s == substr || len(substr) > 0 && (containsHelper(s, substr)))
}

func containsHelper(s, substr string) bool {
	for i := 0; i+len(substr) <= len(s); i++ {
		if s[i:i+len(substr)] == substr {
			return true
		}
	}
	return false
}
