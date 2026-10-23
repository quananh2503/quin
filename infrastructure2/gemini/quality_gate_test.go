package gemini_test

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"
	"meet-attendance-clean/infrastructure2/gemini/mocks"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

func TestQualityGateStage_CleanCompileFirstAttempt(t *testing.T) {
	ctx := context.Background()
	assembler := gemini.NewDefaultDocumentAssembler()
	compiler := mocks.NewTypstCompiler(t)
	validator := gemini.NewDefaultMathValidator()
	repairer := gemini.NewDefaultBatchRepairer(nil, "mock-model")

	qg := gemini.NewDefaultQualityGateStage(assembler, compiler, repairer, validator)

	plan := &gemini.LessonPlan{
		LessonTitle: "Bài kiểm tra sạch",
		Overview:    "Tổng quan",
		Topics:      []gemini.Topic{{TopicID: "dang_1", Title: "Dạng 1"}},
	}
	workers := []gemini.WorkerResult{
		{
			TopicID:      "dang_1",
			Title:        "Dạng 1",
			TheoryPoints: []string{"Định nghĩa sạch $A = B$."},
		},
	}

	// Kỳ vọng compiler được gọi 2 lần: 1 lần cho GV (IsTeacher=true) và 1 lần cho HS (IsTeacher=false)
	compiler.On("Compile", mock.Anything, mock.Anything, mock.MatchedBy(func(opts gemini.CompileOptions) bool {
		return opts.IsTeacher
	})).Return(&gemini.CompileResult{Success: true, PDFPath: "out/GIAO_AN_GIAO_VIEN.pdf"}, nil).Once()

	compiler.On("Compile", mock.Anything, mock.Anything, mock.MatchedBy(func(opts gemini.CompileOptions) bool {
		return !opts.IsTeacher
	})).Return(&gemini.CompileResult{Success: true, PDFPath: "out/PHIEU_BAI_TAP_HOC_SINH.pdf"}, nil).Once()

	out, err := qg.VerifyAndCompile(ctx, plan, workers, ".")
	assert.NoError(t, err)
	assert.NotNil(t, out)
	assert.Equal(t, "out/GIAO_AN_GIAO_VIEN.pdf", out.TeacherPDFPath)
	assert.Equal(t, "out/PHIEU_BAI_TAP_HOC_SINH.pdf", out.StudentPDFPath)

	compiler.AssertExpectations(t)
}

func TestQualityGateStage_SelfHealingViaSourceMapAndRAMMutation(t *testing.T) {
	ctx := context.Background()
	assembler := gemini.NewDefaultDocumentAssembler()

	plan := &gemini.LessonPlan{
		LessonTitle: "Bài kiểm tra Self-Healing",
		Overview:    "Tổng quan",
		Topics:      []gemini.Topic{{TopicID: "dang_1", Title: "Dạng 1"}},
	}
	workers := []gemini.WorkerResult{
		{
			TopicID:      "dang_1",
			Title:        "Dạng 1",
			TheoryPoints: []string{"Lý thuyết $x > 0$"},
			Drills: []gemini.DrillExercise{
				{
					Title:    "Bài 1",
					Prompt:   "Tính giá trị $x + y có thiếu đô la", // Lỗi ở đây
					Solution: "Ta có $x + y = 10$",
				},
			},
		},
	}

	mockCompiler := mocks.NewTypstCompiler(t)
	mockLLM := mocks.NewLLMProvider(t)

	// Lần 1: Compile GV báo lỗi tại dòng Prompt
	mockCompiler.On("Compile", mock.Anything, mock.MatchedBy(func(markup string) bool {
		return strings.Contains(markup, "x + y có thiếu đô la") && !strings.Contains(markup, "// [ISOLATED]")
	}), mock.MatchedBy(func(opts gemini.CompileOptions) bool {
		return opts.IsTeacher
	})).Return(func(ctx context.Context, markup string, opts gemini.CompileOptions) *gemini.CompileResult {
		lines := strings.Split(markup, "\n")
		targetLine := 30
		for idx, line := range lines {
			if strings.Contains(line, "Tính giá trị") {
				targetLine = idx + 1
				break
			}
		}
		return &gemini.CompileResult{
			Success:    false,
			ErrorLines: []int{targetLine},
			RawStderr:  fmt.Sprintf("error: unclosed delimiter at line %d", targetLine),
		}
	}, errors.New("compile error")).Twice()

	// Vòng quét ScanAllTypstErrors: khi dòng lỗi bị cách ly bằng // [ISOLATED], biên dịch thành công
	mockCompiler.On("Compile", mock.Anything, mock.MatchedBy(func(markup string) bool {
		return strings.Contains(markup, "// [ISOLATED]")
	}), mock.MatchedBy(func(opts gemini.CompileOptions) bool {
		return opts.IsTeacher
	})).Return(&gemini.CompileResult{
		Success: true,
	}, nil).Once()

	// Mock LLM Repair: trả về bản sửa đã đóng dấu $
	repairJSON := `{"repaired_items": [{"anchor_id": "dang_1.drill.0.prompt", "fixed_content": "Tính giá trị $x + y$ đã có đầy đủ đô la"}]}`
	mockLLM.On("GenerateJSON", mock.Anything, mock.Anything).Return(&gemini.LLMResponse{
		RawJSON: repairJSON,
	}, nil).Once()

	// Lần 2 (GV retry): Sau khi sửa, GV compile thành công
	mockCompiler.On("Compile", mock.Anything, mock.MatchedBy(func(markup string) bool {
		return strings.Contains(markup, "đã có đầy đủ đô la")
	}), mock.MatchedBy(func(opts gemini.CompileOptions) bool {
		return opts.IsTeacher
	})).Return(&gemini.CompileResult{
		Success: true,
		PDFPath: "out/GV_fixed.pdf",
	}, nil).Once()

	// Lần 3 (HS compile): Compile HS thành công
	mockCompiler.On("Compile", mock.Anything, mock.Anything, mock.MatchedBy(func(opts gemini.CompileOptions) bool {
		return !opts.IsTeacher
	})).Return(&gemini.CompileResult{
		Success: true,
		PDFPath: "out/HS_fixed.pdf",
	}, nil).Once()

	repairer := gemini.NewDefaultBatchRepairer(mockLLM, "gemini-2.5")
	// Bỏ qua pre-audit để kiểm thử chuyên biệt vòng lặp Self-Healing qua SourceMap khi Typst Compiler báo lỗi
	qg := gemini.NewDefaultQualityGateStage(assembler, mockCompiler, repairer, nil)

	out, err := qg.VerifyAndCompile(ctx, plan, workers, ".")
	assert.NoError(t, err)
	assert.NotNil(t, out)

	// KIỂM TRA ĐẶC TÍNH SỐNG CÒN CỦA KIẾN TRÚC MỚI:
	// Biến workers[0].Drills[0].Prompt PHẢI được tự động sửa đổi TRỰC TIẾP trong RAM!
	expectedFixed := "Tính giá trị $x + y$ đã có đầy đủ đô la"
	assert.Equal(t, expectedFixed, workers[0].Drills[0].Prompt)

	mockCompiler.AssertExpectations(t)
	mockLLM.AssertExpectations(t)
}
