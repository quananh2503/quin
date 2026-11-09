package pipeline

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"meet-attendance-clean/domain2/document"
	shareKernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/media"
)

// LessonGeneratorAdapter là Adapter kết nối tầng Application (application2.LessonGenerator)
// với AI Pipeline, giúp tầng Application chạy trực tiếp mà không cần sửa bất kỳ dòng code nào.
type LessonGeneratorAdapter struct {
	mediaConverter *media.Converter
	planner        Planner
	orchestrator   Orchestrator
	assembler      Assembler
	outputDir      string
	workers        int
}

// NewLessonGeneratorAdapter khởi tạo adapter với media.Converter và Planner (tương thích ngược).
func NewLessonGeneratorAdapter(mediaConverter *media.Converter, planner Planner) *LessonGeneratorAdapter {
	if mediaConverter == nil {
		mediaConverter = media.NewConverter()
	}
	return &LessonGeneratorAdapter{
		mediaConverter: mediaConverter,
		planner:        planner,
	}
}

// NewOrchestratorLessonGeneratorAdapter khởi tạo adapter kết nối trực tiếp với Full Pipeline Orchestrator.
func NewOrchestratorLessonGeneratorAdapter(
	mediaConverter *media.Converter,
	orchestrator Orchestrator,
	assembler Assembler,
	outputDir string,
	workers int,
) *LessonGeneratorAdapter {
	if mediaConverter == nil {
		mediaConverter = media.NewConverter()
	}
	if assembler == nil {
		assembler = NewAssembler()
	}
	if workers <= 0 {
		workers = 30
	}
	return &LessonGeneratorAdapter{
		mediaConverter: mediaConverter,
		orchestrator:   orchestrator,
		assembler:      assembler,
		outputDir:      outputDir,
		workers:        workers,
	}
}

// Generate triển khai hợp đồng application2.LessonGenerator:
// 1. Chuyển đổi toàn bộ StudyMaterial (PDF, YouTube, Mistake) thành các ai.Document chứa trang ảnh JPEG qua media.Converter.
// 2. Kích hoạt Full Pipeline (nếu có orchestrator) hoặc Planner Stage.
// 3. Ánh xạ kết quả thành *lesson.Lesson hoàn chỉnh chứa Mẹo, Bước giải và Bài tập.
func (a *LessonGeneratorAdapter) Generate(
	ctx context.Context,
	title string,
	materials []lesson.StudyMaterial,
	model string,
	prompt string,
) (*lesson.Lesson, error) {
	if len(materials) == 0 {
		return nil, fmt.Errorf("danh sách tài liệu học tập không được để trống")
	}

	// 1. Chuyển đổi StudyMaterial thành các ai.Document chứa ảnh JPEG
	docs, errConvert := a.ConvertMaterialsToDocuments(ctx, materials)
	if errConvert != nil {
		return nil, fmt.Errorf("tiền xử lý tài liệu sang ảnh thất bại: %w", errConvert)
	}

	// TRƯỜNG HỢP A: Có Full Pipeline Orchestrator (DeepSeek Production Flow)
	if a.orchestrator != nil {
		outDir := a.outputDir
		if outDir == "" {
			tmpDir, errTmp := os.MkdirTemp("", "quin_orchestrator_*")
			if errTmp != nil {
				return nil, fmt.Errorf("tạo thư mục tạm thất bại: %w", errTmp)
			}
			outDir = tmpDir
		}

		req := PipelineRequest{
			Title:      title,
			Documents:  docs,
			UserPrompt: prompt,
			OutputDir:  outDir,
			Workers:    a.workers,
			Metadata: map[string]string{
				"model": model,
			},
		}

		res, errExec := a.orchestrator.Execute(ctx, req)
		if errExec != nil {
			return nil, fmt.Errorf("chạy pipeline orchestrator thất bại: %w", errExec)
		}

		assembler := a.assembler
		if assembler == nil {
			assembler = NewAssembler()
		}

		lessonEntity, errAssemble := assembler.AssembleToLesson(res.Plan, res.TopicsContent, materials)
		if errAssemble != nil {
			return nil, fmt.Errorf("lắp ghép kết quả sang Domain Lesson thất bại: %w", errAssemble)
		}

		return lessonEntity, nil
	}

	// TRƯỜNG HỢP B: Chỉ có Planner (Fallback / Test mode)
	if a.planner == nil {
		return nil, fmt.Errorf("chưa cấu hình Planner hoặc Orchestrator cho LessonGeneratorAdapter")
	}

	plan, _, errPlan := a.planner.Plan(ctx, docs, prompt)
	if errPlan != nil {
		return nil, fmt.Errorf("lập kế hoạch bài giảng (Stage 1) thất bại: %w", errPlan)
	}

	lessonEntity, errMap := a.mapPlanToLesson(plan, title, materials)
	if errMap != nil {
		return nil, fmt.Errorf("ánh xạ LessonPlan sang Lesson domain thất bại: %w", errMap)
	}

	return lessonEntity, nil
}

// ConvertMaterialsToDocuments chuyển đổi danh sách StudyMaterial sang mảng ai.Document.
func (a *LessonGeneratorAdapter) ConvertMaterialsToDocuments(ctx context.Context, materials []lesson.StudyMaterial) ([]ai.Document, error) {
	var docs []ai.Document
	pdfIdx := 1
	ytIdx := 1

	for _, m := range materials {
		if m == nil {
			continue
		}
		switch source := m.(type) {
		case lesson.PDFMaterial:
			pdfPath := source.FilePath()
			rawBytes, errRead := os.ReadFile(pdfPath)
			if errRead != nil {
				return nil, fmt.Errorf("đọc file PDF %s thất bại: %w", pdfPath, errRead)
			}

			// Chuyển đổi tài liệu (PDF, Word, Ảnh PNG/JPEG, TXT) sang các trang ảnh JPEG qua media.Converter
			jpegPages, errConv := a.mediaConverter.ConvertBytesToJPEGPages(ctx, rawBytes, "", filepath.Base(pdfPath))
			if errConv != nil {
				return nil, fmt.Errorf("chuyển đổi tài liệu %s sang ảnh JPEG thất bại: %w", filepath.Base(pdfPath), errConv)
			}

			var parts []ai.Part
			for _, pageBytes := range jpegPages {
				if len(pageBytes) > 0 {
					parts = append(parts, ai.NewMediaPart("image/jpeg", pageBytes))
				}
			}

			docID := fmt.Sprintf("DOC_PDF_%d", pdfIdx)
			docs = append(docs, ai.NewDocument(docID, filepath.Base(pdfPath), parts...))
			pdfIdx++

		case lesson.YouTubeMaterial:
			ytURL := source.SourceURL()
			// Chuyển link YouTube sang ảnh JPEG dàn trang qua media.Converter
			jpegPages, errConv := a.mediaConverter.ConvertBytesToJPEGPages(ctx, []byte(ytURL), document.FileTypeYOUTUBE, "youtube_video")
			if errConv != nil {
				return nil, fmt.Errorf("chuyển đổi video YouTube %s sang ảnh thất bại: %w", ytURL, errConv)
			}

			var parts []ai.Part
			for _, pageBytes := range jpegPages {
				if len(pageBytes) > 0 {
					parts = append(parts, ai.NewMediaPart("image/jpeg", pageBytes))
				}
			}

			docID := fmt.Sprintf("DOC_YOUTUBE_%d", ytIdx)
			docs = append(docs, ai.NewDocument(docID, "YouTube: "+ytURL, parts...))
			ytIdx++

		case lesson.MistakeMaterial:
			mistakeText := fmt.Sprintf("Chủ đề cần khắc phục: %s\nNguyên nhân: %s", source.Topic(), source.Reason())
			part := ai.NewTextPart(mistakeText)
			docs = append(docs, ai.NewDocument("DOC_MISTAKE", "mistake_context.txt", part))
		}
	}

	if len(docs) == 0 {
		return nil, fmt.Errorf("không có tài liệu hợp lệ nào được chuyển đổi")
	}

	return docs, nil
}

// mapPlanToLesson tạo Lesson Entity hoàn chỉnh từ LessonPlan của Planner.
func (a *LessonGeneratorAdapter) mapPlanToLesson(plan *LessonPlan, fallbackTitle string, materials []lesson.StudyMaterial) (*lesson.Lesson, error) {
	if plan == nil {
		return nil, fmt.Errorf("LessonPlan rỗng")
	}

	lessonTitle := strings.TrimSpace(plan.LessonTitle)
	if lessonTitle == "" {
		lessonTitle = fallbackTitle
	}
	titleContent := textToContent(lessonTitle)
	overviewContent := textToContent(plan.Overview)

	topics := make([]lesson.Topic, 0, len(plan.Topics))
	for _, tp := range plan.Topics {
		topTitle := textToContent(fmt.Sprintf("%s: %s (%s)", tp.TopicID, tp.Title, tp.Difficulty))
		var blocks []lesson.Block

		if strings.TrimSpace(tp.CoreConcept) != "" {
			blocks = append(blocks, lesson.NewParagraphBlock(textToContent(tp.CoreConcept)))
		}
		if strings.TrimSpace(tp.TargetOutput) != "" {
			blocks = append(blocks, lesson.NewCalloutBlock(lesson.CalloutTip, textToContent("Mục tiêu đạt được"), textToContent(tp.TargetOutput)))
		}

		top, errTop := lesson.NewTopic(topTitle, blocks, nil)
		if errTop != nil {
			return nil, fmt.Errorf("tạo Topic %s thất bại: %w", tp.TopicID, errTop)
		}
		topics = append(topics, top)
	}

	secTitle := textToContent("Chuyên đề bài học")
	section, errSec := lesson.NewSection(secTitle, topics)
	if errSec != nil {
		return nil, fmt.Errorf("tạo Section thất bại: %w", errSec)
	}

	return lesson.NewLesson(titleContent, overviewContent, []lesson.Section{section}, materials)
}

func textToContent(text string) shareKernel.Content {
	text = strings.TrimSpace(text)
	if text == "" {
		return shareKernel.NewContent(shareKernel.InlinePart{Type: shareKernel.InlineText, Value: "-"})
	}
	return shareKernel.NewContent(shareKernel.InlinePart{
		Type:  shareKernel.InlineText,
		Value: text,
	})
}
