package gemini_test

import (
	"context"
	"errors"
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"
	"meet-attendance-clean/infrastructure2/gemini/mocks"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

func TestDefaultPlanPolisherStage_NilPlan(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	polisher := gemini.NewDefaultPlanPolisherStage(mockLLM, "gemini-3.5-flash-lite")
	res, err := polisher.Polish(context.Background(), nil)
	assert.NoError(t, err)
	assert.Nil(t, res)
}

func TestDefaultPlanPolisherStage_NilLLM(t *testing.T) {
	polisher := gemini.NewDefaultPlanPolisherStage(nil, "gemini-3.5-flash-lite")
	plan := &gemini.LessonPlan{
		LessonTitle: "Bài test",
		Topics: []gemini.Topic{
			{TopicID: "dang_1", Title: "Dạng 1"},
		},
	}
	res, err := polisher.Polish(context.Background(), plan)
	assert.NoError(t, err)
	assert.Equal(t, plan, res)
}

func TestDefaultPlanPolisherStage_Success(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	polisher := gemini.NewDefaultPlanPolisherStage(mockLLM, "gemini-3.5-flash-lite")

	initialPlan := &gemini.LessonPlan{
		LessonTitle: "Chuyên đề Toán học",
		Overview:    "Tổng quan kiến thức",
		Topics: []gemini.Topic{
			{TopicID: "dang_1", Title: "Dạng Nâng Cao - Ứng dụng thực tế", Difficulty: "VanDungCao"},
			{TopicID: "dang_2", Title: "Dạng Cơ Sở - Khái niệm ban đầu", Difficulty: "NhanBiet_ThongHieu"},
		},
	}

	mockJSON := `{
		"topics": [
			{
				"topic_id": "dang_1",
				"title": "Dạng Cơ Sở - Khái niệm ban đầu",
				"difficulty": "NhanBiet_ThongHieu",
				"core_concept": "Định nghĩa và tính chất",
				"target_output": "Nhận biết khái niệm",
				"assigned_question_ids": ["C1", "C2"],
				"variants": ["Biến thể cơ bản"]
			},
			{
				"topic_id": "dang_2",
				"title": "Dạng Nâng Cao - Ứng dụng thực tế",
				"difficulty": "VanDungCao",
				"core_concept": "Mô hình hóa bài toán thực tiễn",
				"target_output": "Giải quyết bài toán thực tế",
				"assigned_question_ids": ["C3", "C4"],
				"variants": ["Biến thể thực tế"]
			}
		]
	}`

	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == "gemini-3.5-flash-lite" && len(req.Documents) == 0
	})).Return(&gemini.LLMResponse{RawJSON: mockJSON}, nil).Once()

	polished, err := polisher.Polish(context.Background(), initialPlan)
	assert.NoError(t, err)
	assert.NotNil(t, polished)
	assert.Len(t, polished.Topics, 2)
	assert.Equal(t, "dang_1", polished.Topics[0].TopicID)
	assert.Equal(t, "Dạng Cơ Sở - Khái niệm ban đầu", polished.Topics[0].Title)
	assert.Equal(t, "dang_2", polished.Topics[1].TopicID)
	assert.Equal(t, "Dạng Nâng Cao - Ứng dụng thực tế", polished.Topics[1].Title)

	mockLLM.AssertExpectations(t)
}

func TestDefaultPlanPolisherStage_LLMErrorFallback(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	polisher := gemini.NewDefaultPlanPolisherStage(mockLLM, "gemini-3.5-flash-lite")

	initialPlan := &gemini.LessonPlan{
		LessonTitle: "Chuyên đề Toán học",
		Topics: []gemini.Topic{
			{TopicID: "dang_1", Title: "Dạng 1"},
		},
	}

	mockLLM.On("GenerateJSON", mock.Anything, mock.Anything).
		Return(nil, errors.New("API rate limit")).Once()

	res, err := polisher.Polish(context.Background(), initialPlan)
	assert.NoError(t, err)
	assert.Equal(t, initialPlan, res)

	mockLLM.AssertExpectations(t)
}
