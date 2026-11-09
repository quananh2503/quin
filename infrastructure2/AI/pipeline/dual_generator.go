package pipeline

import (
	"context"
	"fmt"
	"strings"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/domain2/lesson"
)

// DualLessonGenerator là Router điều phối sinh bài học giữa 2 Engine:
// 1. DeepSeek Pipeline mới (5-Stage Pipeline: Vét cạn, Phân dạng, Mẹo & Bước giải, Tự sửa lỗi, Typst A4).
// 2. Google Gemini / Gemma cũ (Free tier Native PDF).
type DualLessonGenerator struct {
	geminiGenerator   application2.LessonGenerator
	deepseekGenerator application2.LessonGenerator
}

// NewDualLessonGenerator khởi tạo router.
func NewDualLessonGenerator(
	geminiGen application2.LessonGenerator,
	deepseekGen application2.LessonGenerator,
) *DualLessonGenerator {
	return &DualLessonGenerator{
		geminiGenerator:   geminiGen,
		deepseekGenerator: deepseekGen,
	}
}

// Generate kiểm tra model yêu cầu để định tuyến chính xác:
// - Nếu model chứa "deepseek" -> định tuyến sang DeepSeek Pipeline.
// - Ngược lại (mặc định hoặc chứa "gemini"/"gemma") -> định tuyến sang Gemini cũ.
func (d *DualLessonGenerator) Generate(
	ctx context.Context,
	title string,
	materials []lesson.StudyMaterial,
	model string,
	prompt string,
) (*lesson.Lesson, error) {
	if strings.Contains(strings.ToLower(model), "deepseek") {
		if d.deepseekGenerator == nil {
			return nil, fmt.Errorf("chưa cấu hình DeepSeek Generator")
		}
		return d.deepseekGenerator.Generate(ctx, title, materials, model, prompt)
	}

	if d.geminiGenerator == nil {
		return nil, fmt.Errorf("chưa cấu hình Gemini Generator")
	}
	return d.geminiGenerator.Generate(ctx, title, materials, model, prompt)
}
