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

func TestDefaultPlannerStage_Plan_NilLLM(t *testing.T) {
	planner := gemini.NewDefaultPlannerStage(nil, "gemini-2.5")
	_, err := planner.Plan(context.Background(), nil, "")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "chưa cấu hình LLMProvider")
}

func TestDefaultPlannerStage_Plan_Success(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	planner := gemini.NewDefaultPlannerStage(mockLLM, "gemini-2.5")

	validPlanJSON := `{
		"lesson_title": "Hình học không gian: Tọa độ điểm",
		"overview": "Tổng quan về hệ tọa độ Oxyz",
		"topics": [
			{
				"topic_id": "dang_1",
				"title": "Xác định tọa độ điểm",
				"difficulty": "Nhận biết",
				"core_concept": "Chiếu điểm lên các trục tọa độ",
				"variants": ["Chiếu lên Ox", "Chiếu lên Oxy"]
			}
		]
	}`

	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == "gemini-2.5" && len(req.Documents) == 1
	})).Return(&gemini.LLMResponse{
		RawJSON: validPlanJSON,
		Usage:   gemini.UsageMetrics{TotalTokens: 150},
	}, nil).Once()

	docs := []gemini.DocumentInput{
		{DocID: "DOC_1", FileName: "hinh_hoc.pdf", RawPDF: []byte("%PDF-fake")},
	}

	plan, err := planner.Plan(context.Background(), docs, "Yêu cầu bám sát SGK mới")
	assert.NoError(t, err)
	assert.NotNil(t, plan)
	assert.Equal(t, "Hình học không gian: Tọa độ điểm", plan.LessonTitle)
	assert.Len(t, plan.Topics, 1)
	assert.Equal(t, "dang_1", plan.Topics[0].TopicID)
	assert.Equal(t, "Xác định tọa độ điểm", plan.Topics[0].Title)

	mockLLM.AssertExpectations(t)
}

func TestDefaultPlannerStage_Plan_LLMError(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	planner := gemini.NewDefaultPlannerStage(mockLLM, "gemini-2.5")

	mockLLM.On("GenerateJSON", mock.Anything, mock.Anything).Return(nil, errors.New("quota exceeded")).Once()

	docs := []gemini.DocumentInput{{DocID: "DOC_1", TextContent: "Lý thuyết"}}
	plan, err := planner.Plan(context.Background(), docs, "")
	assert.Error(t, err)
	assert.Nil(t, plan)
	assert.Contains(t, err.Error(), "quota exceeded")

	mockLLM.AssertExpectations(t)
}

func TestDefaultPlannerStage_Plan_JSONWithLaTeX(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	planner := gemini.NewDefaultPlannerStage(mockLLM, "gemini-2.5")

	// Test unescaped backslashes in JSON (common AI response quirk like \vec{u} or \frac{a}{b})
	rawJSONWithLaTeX := `{
		"lesson_title": "Phương trình đường thẳng",
		"overview": "Đường thẳng qua $M_0$ có vtcp $\vec{u} = (a; b; c)$",
		"topics": [
			{
				"topic_id": "dang_1",
				"title": "Viết phương trình tham số",
				"core_concept": "Dùng công thức $\frac{x-x_0}{a}$",
				"variants": []
			}
		]
	}`

	mockLLM.On("GenerateJSON", mock.Anything, mock.Anything).Return(&gemini.LLMResponse{
		RawJSON: rawJSONWithLaTeX,
	}, nil).Once()

	plan, err := planner.Plan(context.Background(), nil, "")
	assert.NoError(t, err)
	assert.NotNil(t, plan)
	assert.Equal(t, "Phương trình đường thẳng", plan.LessonTitle)
	assert.Contains(t, plan.Overview, `\vec{u}`)

	mockLLM.AssertExpectations(t)
}
