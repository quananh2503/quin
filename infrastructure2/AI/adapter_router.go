package ai

import (
	"context"
	"errors"
	"strings"

	"meet-attendance-clean/domain2/lesson"
)

// DualLessonGenerator routes lesson generation requests between Gemini and DeepSeek engines.
type DualLessonGenerator struct {
	geminiFn   func(ctx context.Context, title string, materials []lesson.StudyMaterial, model string, prompt string) (*lesson.Lesson, error)
	deepseekFn func(ctx context.Context, title string, materials []lesson.StudyMaterial, model string, prompt string) (*lesson.Lesson, error)
}

// NewDualLessonGenerator constructs a DualLessonGenerator router.
func NewDualLessonGenerator(
	geminiFn func(ctx context.Context, title string, materials []lesson.StudyMaterial, model string, prompt string) (*lesson.Lesson, error),
	deepseekFn func(ctx context.Context, title string, materials []lesson.StudyMaterial, model string, prompt string) (*lesson.Lesson, error),
) *DualLessonGenerator {
	return &DualLessonGenerator{
		geminiFn:   geminiFn,
		deepseekFn: deepseekFn,
	}
}

// Generate routes to DeepSeek when model contains "deepseek", otherwise routes to Gemini.
func (d *DualLessonGenerator) Generate(
	ctx context.Context,
	title string,
	materials []lesson.StudyMaterial,
	model string,
	prompt string,
) (*lesson.Lesson, error) {
	if strings.Contains(strings.ToLower(model), "deepseek") {
		if d.deepseekFn == nil {
			return nil, errors.New("chưa cấu hình DeepSeek Generator")
		}
		return d.deepseekFn(ctx, title, materials, model, prompt)
	}
	if d.geminiFn == nil {
		return nil, errors.New("chưa cấu hình Gemini Generator")
	}
	return d.geminiFn(ctx, title, materials, model, prompt)
}
