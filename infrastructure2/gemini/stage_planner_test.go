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

type mockRasterizer struct {
	mock.Mock
}

func (m *mockRasterizer) RasterizePDF(ctx context.Context, pdfBytes []byte) ([][]byte, error) {
	args := m.Called(ctx, pdfBytes)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).([][]byte), args.Error(1)
}

func TestDefaultPlannerStage_Plan_RasterizesPDFToPNGs(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	mockRast := new(mockRasterizer)

	planner := gemini.NewDefaultPlannerStage(mockLLM, "gemini-3.8-flash").
		WithRasterizer(mockRast)

	pdfBytes := []byte("%PDF-1.4 mock content")
	fakePNGs := [][]byte{
		[]byte("fake-png-page-1"),
		[]byte("fake-png-page-2"),
	}

	mockRast.On("RasterizePDF", mock.Anything, pdfBytes).Return(fakePNGs, nil).Once()

	validPlanJSON := `{
		"lesson_title": "Bài tập hình học",
		"overview": "Tổng quan",
		"topics": []
	}`

	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		if len(req.Documents) != 1 {
			return false
		}
		doc := req.Documents[0]
		return len(doc.PageImages) == 2 &&
			string(doc.PageImages[0]) == "fake-png-page-1" &&
			string(doc.PageImages[1]) == "fake-png-page-2"
	})).Return(&gemini.LLMResponse{
		RawJSON: validPlanJSON,
	}, nil).Once()

	docs := []gemini.DocumentInput{
		{DocID: "DOC_1", FileName: "de_toan.pdf", RawPDF: pdfBytes},
	}

	plan, err := planner.Plan(context.Background(), docs, "Hướng dẫn chung")
	assert.NoError(t, err)
	assert.NotNil(t, plan)
	assert.Equal(t, "Bài tập hình học", plan.LessonTitle)

	mockRast.AssertExpectations(t)
	mockLLM.AssertExpectations(t)
}

func TestDefaultPlannerStage_Plan_RasterizerFailsGracefulFallback(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	mockRast := new(mockRasterizer)

	planner := gemini.NewDefaultPlannerStage(mockLLM, "gemini-3.8-flash").
		WithRasterizer(mockRast)

	pdfBytes := []byte("%PDF-1.4 corrupt")
	mockRast.On("RasterizePDF", mock.Anything, pdfBytes).Return(nil, errors.New("typst render error")).Once()

	validPlanJSON := `{
		"lesson_title": "Fallback",
		"overview": "Overview",
		"topics": []
	}`

	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		doc := req.Documents[0]
		return len(doc.PageImages) == 0 && string(doc.RawPDF) == string(pdfBytes)
	})).Return(&gemini.LLMResponse{
		RawJSON: validPlanJSON,
	}, nil).Once()

	docs := []gemini.DocumentInput{
		{DocID: "DOC_1", FileName: "hinh.pdf", RawPDF: pdfBytes},
	}

	plan, err := planner.Plan(context.Background(), docs, "")
	assert.NoError(t, err)
	assert.NotNil(t, plan)

	mockRast.AssertExpectations(t)
	mockLLM.AssertExpectations(t)
}
