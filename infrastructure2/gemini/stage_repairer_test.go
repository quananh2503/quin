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

func TestDefaultBatchRepairer_RepairIssues_Empty(t *testing.T) {
	repairer := gemini.NewDefaultBatchRepairer(nil, "any")
	result, err := repairer.RepairIssues(context.Background(), nil)
	assert.NoError(t, err)
	assert.Empty(t, result)
}

func TestDefaultBatchRepairer_RepairIssues_OfflineFallbackRegex(t *testing.T) {
	// Không truyền LLM (nil) -> chạy chế độ fallback thuần regex offline
	repairer := gemini.NewDefaultBatchRepairer(nil, "")

	issues := []gemini.ValidationIssue{
		{
			SlotID:  "slot.1",
			Content: "Ta có $x + y = 10 thiếu dấu đóng đô la",
			Reason:  "Unclosed math delimiter",
		},
		{
			SlotID:  "slot.2",
			Content: "Ký tự thăng # đứng một mình",
			Reason:  "Typst hash error",
		},
	}

	result, err := repairer.RepairIssues(context.Background(), issues)
	assert.NoError(t, err)
	assert.Len(t, result, 2)

	// Kiểm tra đã tự động đóng dấu $
	assert.Equal(t, "Ta có $x + y = 10 thiếu dấu đóng đô la$", result["slot.1"])

	// Kiểm tra đã escape ký tự #
	assert.Equal(t, `Ký tự thăng \# đứng một mình`, result["slot.2"])
}

func TestDefaultBatchRepairer_RepairIssues_WithLLMSuccess(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	repairer := gemini.NewDefaultBatchRepairer(mockLLM, "gemini-2.5")

	issues := []gemini.ValidationIssue{
		{
			SlotID:  "dang_1.drill.0.prompt",
			Content: "Cho tam giác ABC có vecto AB = a",
			Reason:  "Missing math notation",
		},
	}

	llmJSON := `{
		"repaired_items": [
			{
				"anchor_id": "dang_1.drill.0.prompt",
				"fixed_content": "Cho tam giác $A B C$ có vectơ $\\vec{AB} = \\vec{a}$"
			}
		]
	}`

	mockLLM.On("GenerateJSON", mock.Anything, mock.MatchedBy(func(req gemini.LLMRequest) bool {
		return req.ModelName == "gemini-2.5"
	})).Return(&gemini.LLMResponse{RawJSON: llmJSON}, nil).Once()

	result, err := repairer.RepairIssues(context.Background(), issues)
	assert.NoError(t, err)
	assert.Len(t, result, 1)
	assert.Equal(t, "Cho tam giác $A B C$ có vectơ $\\vec{AB} = \\vec{a}$", result["dang_1.drill.0.prompt"])

	mockLLM.AssertExpectations(t)
}

func TestDefaultBatchRepairer_RepairIssues_LLMErrorFallback(t *testing.T) {
	mockLLM := mocks.NewLLMProvider(t)
	repairer := gemini.NewDefaultBatchRepairer(mockLLM, "gemini-2.5")

	issues := []gemini.ValidationIssue{
		{
			SlotID:  "slot.1",
			Content: "$a + b",
		},
	}

	// Giả lập LLM sập mạng / hết quota -> BatchRepairer không được crash mà fallback về regex
	mockLLM.On("GenerateJSON", mock.Anything, mock.Anything).
		Return(nil, errors.New("network timeout")).Once()

	result, err := repairer.RepairIssues(context.Background(), issues)
	assert.NoError(t, err)
	assert.Len(t, result, 1)
	assert.Equal(t, "$a + b$", result["slot.1"])

	mockLLM.AssertExpectations(t)
}
