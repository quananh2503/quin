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
	polisher := gemini.NewDefaultPlanPolisherStage(mockLLM, "gemini-3.5-flash")
	res, err := polisher.Polish(context.Background(), nil)
	assert.NoError(t, err)
	assert.Nil(t, res)
}

func TestDefaultPlanPolisherStage_NilLLM(t *testing.T) {
	polisher := gemini.NewDefaultPlanPolisherStage(nil, "gemini-3.5-flash")
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

func TestDefaultPlanPolisherStage_FluentAPI(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	polisher := gemini.NewDefaultPlanPolisherStage(mockLLM, "gemini-3.5-flash").
		WithFallback(gemini.ModelGemma4_31B, gemini.ModelGemma4_26B_A4B)

	assert.Equal(t, "gemini-3.5-flash", polisher.PrimaryModel())
	assert.Equal(t, []string{gemini.ModelGemma4_31B, gemini.ModelGemma4_26B_A4B}, polisher.FallbackModels())
	assert.Equal(t, []string{"gemini-3.5-flash", gemini.ModelGemma4_31B, gemini.ModelGemma4_26B_A4B}, polisher.CandidateModels())
}

func TestDefaultPlanPolisherStage_Success(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	polisher := gemini.NewDefaultPlanPolisherStage(mockLLM, "gemini-3.5-flash")

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
		return req.ModelName == "gemini-3.5-flash" && len(req.Documents) == 0
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

func TestDefaultPlanPolisherStage_FallbackToGemmaOnPrimaryFailure(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	polisher := gemini.NewDefaultPlanPolisherStage(mockLLM, "gemini-3.5-flash").
		WithFallback(gemini.ModelGemma4_31B)

	initialPlan := &gemini.LessonPlan{
		LessonTitle: "Chuyên đề Toán học",
		Topics: []gemini.Topic{
			{TopicID: "dang_1", Title: "Dạng 1"},
		},
	}

	mockJSON := `{
		"topics": [
			{
				"topic_id": "dang_1",
				"title": "Dạng 1 Tinh Chỉnh từ Gemma",
				"difficulty": "NhanBiet_ThongHieu",
				"core_concept": "Khái niệm",
				"target_output": "Mục tiêu",
				"assigned_question_ids": ["C1"]
			}
		]
	}`

	// 1. Primary Model (gemini-3.5-flash) gặp lỗi quota/429
	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == "gemini-3.5-flash"
	})).Return(nil, errors.New("429 resource exhausted")).Once()

	// 2. Tự động chuyển giao sang Fallback Model (gemma-4-31b-it) và thành công
	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == gemini.ModelGemma4_31B
	})).Return(&gemini.LLMResponse{RawJSON: mockJSON}, nil).Once()

	polished, err := polisher.Polish(context.Background(), initialPlan)
	assert.NoError(t, err)
	assert.NotNil(t, polished)
	assert.Len(t, polished.Topics, 1)
	assert.Equal(t, "Dạng 1 Tinh Chỉnh từ Gemma", polished.Topics[0].Title)

	mockLLM.AssertExpectations(t)
}

func TestDefaultPlanPolisherStage_CascadingToSecondFallback(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	polisher := gemini.NewDefaultPlanPolisherStage(mockLLM, "gemini-3.5-flash").
		WithFallback(gemini.ModelGemma4_31B, gemini.ModelGemma4_26B_A4B)

	initialPlan := &gemini.LessonPlan{
		LessonTitle: "Chuyên đề Toán học",
		Topics: []gemini.Topic{
			{TopicID: "dang_1", Title: "Dạng 1"},
		},
	}

	mockJSON := `{
		"topics": [
			{
				"topic_id": "dang_1",
				"title": "Dạng 1 Tinh Chỉnh từ Gemma 26B",
				"difficulty": "NhanBiet_ThongHieu",
				"core_concept": "Khái niệm",
				"target_output": "Mục tiêu",
				"assigned_question_ids": ["C1"]
			}
		]
	}`

	// 1. gemini-3.5-flash lỗi
	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == "gemini-3.5-flash"
	})).Return(nil, errors.New("503 service unavailable")).Once()

	// 2. gemma-4-31b-it lỗi
	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == gemini.ModelGemma4_31B
	})).Return(nil, errors.New("deadline exceeded")).Once()

	// 3. gemma-4-26b-a4b-it thành công
	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == gemini.ModelGemma4_26B_A4B
	})).Return(&gemini.LLMResponse{RawJSON: mockJSON}, nil).Once()

	polished, err := polisher.Polish(context.Background(), initialPlan)
	assert.NoError(t, err)
	assert.NotNil(t, polished)
	assert.Len(t, polished.Topics, 1)
	assert.Equal(t, "Dạng 1 Tinh Chỉnh từ Gemma 26B", polished.Topics[0].Title)

	mockLLM.AssertExpectations(t)
}

func TestDefaultPlanPolisherStage_AllModelsFailGracefulFallback(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	polisher := gemini.NewDefaultPlanPolisherStage(mockLLM, "gemini-3.5-flash").
		WithFallback(gemini.ModelGemma4_31B)

	initialPlan := &gemini.LessonPlan{
		LessonTitle: "Chuyên đề Toán học",
		Topics: []gemini.Topic{
			{TopicID: "dang_1", Title: "Dạng Gốc Ban Đầu"},
		},
	}

	// Cả 2 model đều lỗi
	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == "gemini-3.5-flash"
	})).Return(nil, errors.New("rate limit")).Once()

	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == gemini.ModelGemma4_31B
	})).Return(nil, errors.New("quota exceeded")).Once()

	res, err := polisher.Polish(context.Background(), initialPlan)
	assert.NoError(t, err)
	assert.Equal(t, initialPlan, res, "Khi toàn bộ mô hình thất bại, bắt buộc giữ nguyên plan gốc")

	mockLLM.AssertExpectations(t)
}

func TestDefaultPlanPolisherStage_FallbackOnMalformedJSON(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	polisher := gemini.NewDefaultPlanPolisherStage(mockLLM, "gemini-3.5-flash").
		WithFallback(gemini.ModelGemma4_31B)

	initialPlan := &gemini.LessonPlan{
		LessonTitle: "Chuyên đề Toán học",
		Topics: []gemini.Topic{
			{TopicID: "dang_1", Title: "Dạng 1"},
		},
	}

	validJSON := `{
		"topics": [
			{
				"topic_id": "dang_1",
				"title": "Dạng chuẩn từ Fallback",
				"difficulty": "NhanBiet_ThongHieu",
				"core_concept": "Khái niệm",
				"target_output": "Mục tiêu",
				"assigned_question_ids": ["C1"]
			}
		]
	}`

	// 1. Primary Model trả về JSON hỏng không parse được
	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == "gemini-3.5-flash"
	})).Return(&gemini.LLMResponse{RawJSON: "{broken json <<<"}, nil).Once()

	// 2. Chuyển sang Fallback Model và trả về JSON chuẩn
	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == gemini.ModelGemma4_31B
	})).Return(&gemini.LLMResponse{RawJSON: validJSON}, nil).Once()

	polished, err := polisher.Polish(context.Background(), initialPlan)
	assert.NoError(t, err)
	assert.NotNil(t, polished)
	assert.Len(t, polished.Topics, 1)
	assert.Equal(t, "Dạng chuẩn từ Fallback", polished.Topics[0].Title)

	mockLLM.AssertExpectations(t)
}
