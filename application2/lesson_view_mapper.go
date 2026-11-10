package application2

import (
	"errors"
	"fmt"
	"strings"

	"uuid"

	kernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
)

// LessonViewToLesson chuyển đổi LessonView (từ giao diện UI/Web editor) thành aggregate Lesson hoàn chỉnh của domain.
func LessonViewToLesson(v *LessonView, materials []lesson.StudyMaterial) (*lesson.Lesson, error) {
	if v == nil {
		return nil, errors.New("lesson view không được để trống")
	}

	lessonID := v.ID
	if lessonID == uuid.Nil() {
		lessonID = uuid.New()
	}

	matList := make([]lesson.StudyMaterial, len(materials))
	copy(matList, materials)
	if len(matList) == 0 {
		defaultMat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=placeholder")
		if err != nil {
			return nil, fmt.Errorf("tạo tài liệu mặc định thất bại: %w", err)
		}
		matList = append(matList, defaultMat)
	}

	sections := make([]lesson.Section, 0, len(v.Sections))
	for secIdx, s := range v.Sections {
		topics := make([]lesson.Topic, 0, len(s.Topics))
		for topIdx, t := range s.Topics {
			blocks := make([]lesson.Block, 0, len(t.Blocks))
			for _, b := range t.Blocks {
				block, err := mapBlockViewToBlock(b)
				if err != nil {
					return nil, fmt.Errorf("lỗi chuyển đổi block trong section %d topic %d: %w", secIdx+1, topIdx+1, err)
				}
				blocks = append(blocks, block)
			}

			exercises := make([]kernel.Exercise, 0, len(t.Exercises))
			for _, e := range t.Exercises {
				ex, err := mapExerciseViewToExercise(e)
				if err != nil {
					return nil, fmt.Errorf("lỗi chuyển đổi bài tập trong topic %d: %w", topIdx+1, err)
				}
				exercises = append(exercises, ex)
			}

			topicTitle := strToContent(t.Title)
			if topicTitle.IsEmpty() {
				topicTitle = strToContent(fmt.Sprintf("Dạng %d", topIdx+1))
			}
			topics = append(topics, lesson.ReconstituteTopic(topicTitle, blocks, exercises))
		}

		if len(topics) == 0 {
			defaultTopic := lesson.ReconstituteTopic(strToContent("Nội dung"), nil, nil)
			topics = append(topics, defaultTopic)
		}

		secTitle := strToContent(s.Title)
		if secTitle.IsEmpty() {
			secTitle = strToContent(fmt.Sprintf("Phần %d", secIdx+1))
		}
		sections = append(sections, lesson.ReconstituteSection(secTitle, topics))
	}

	// Nếu bản ghi có root exercises và chưa gán vào topic nào:
	if len(v.Exercises) > 0 && len(sections) > 0 && len(sections[0].Topics()) > 0 {
		rootExs := make([]kernel.Exercise, 0, len(v.Exercises))
		for _, e := range v.Exercises {
			ex, err := mapExerciseViewToExercise(e)
			if err != nil {
				return nil, fmt.Errorf("lỗi chuyển đổi bài tập gốc: %w", err)
			}
			rootExs = append(rootExs, ex)
		}
		firstSec := sections[0]
		firstTopic := firstSec.Topics()[0]
		allExs := append(firstTopic.Exercises(), rootExs...)
		updatedTopic := lesson.ReconstituteTopic(firstTopic.Title(), firstTopic.Blocks(), allExs)
		updatedTopics := append([]lesson.Topic{updatedTopic}, firstSec.Topics()[1:]...)
		sections[0] = lesson.ReconstituteSection(firstSec.Title(), updatedTopics)
	}

	if len(sections) == 0 {
		defaultTopic := lesson.ReconstituteTopic(strToContent("Nội dung bài học"), nil, nil)
		defaultSec := lesson.ReconstituteSection(strToContent("Phần 1: Lý thuyết"), []lesson.Topic{defaultTopic})
		sections = append(sections, defaultSec)
	}

	titleContent := strToContent(v.Title)
	if titleContent.IsEmpty() {
		titleContent = strToContent("Bài giảng chưa đặt tên")
	}

	return lesson.ReconstituteLesson(
		lessonID,
		titleContent,
		strToContent(v.Overview),
		sections,
		matList,
	)
}

func mapBlockViewToBlock(b BlockView) (lesson.Block, error) {
	switch b.Type {
	case string(lesson.BlockParagraph):
		return lesson.ReconstituteParagraphBlock(strToContent(b.Body)), nil

	case string(lesson.BlockList):
		items := make([]kernel.Content, 0, len(b.Items))
		for _, it := range b.Items {
			items = append(items, strToContent(it))
		}
		return lesson.ReconstituteListBlock(b.Ordered, items), nil

	case string(lesson.BlockFormula):
		return lesson.ReconstituteFormulaBlock(b.Math), nil

	case string(lesson.BlockExample):
		return lesson.ReconstituteExampleBlock(
			strToContent(b.Title),
			strToContent(b.Problem),
			strToContent(b.Solution),
			strToContent(b.Explanation),
		), nil

	case string(lesson.BlockImage):
		return lesson.ReconstituteImageBlock(b.SVG, strToContent(b.Caption)), nil

	case string(lesson.BlockCloze):
		items := make([]lesson.ClozeItem, 0, len(b.ClozeItems))
		for _, itemParts := range b.ClozeItems {
			parts := make([]lesson.ClozePart, 0, len(itemParts))
			for _, p := range itemParts {
				parts = append(parts, lesson.NewClozePart(lesson.ClozePartType(p.Type), p.Value))
			}
			items = append(items, lesson.ClozeItem{Parts: parts})
		}
		return lesson.ReconstituteClozeBlock(strToContent(b.Body), items), nil

	case string(lesson.BlockCallout):
		kind := lesson.CalloutKind(b.CalloutKind)
		if kind != lesson.CalloutTip && kind != lesson.CalloutNote && kind != lesson.CalloutWarning {
			kind = lesson.CalloutNote
		}
		return lesson.ReconstituteCalloutBlock(kind, strToContent(b.Title), strToContent(b.Body)), nil

	default:
		// Fallback mặc định về đoạn văn paragraph nếu type không xác định
		return lesson.ReconstituteParagraphBlock(strToContent(b.Body)), nil
	}
}

func mapExerciseViewToExercise(e ExerciseView) (kernel.Exercise, error) {
	diagram := kernel.NewDiagram(kernel.DiagramType(e.DiagramType), e.DiagramContent)
	prompt := strToContent(e.Question)
	topic := strings.TrimSpace(e.Topic)
	if topic == "" {
		topic = "Toán học"
	}
	difficulty := strings.TrimSpace(e.Difficulty)
	if difficulty == "" {
		difficulty = "Thông hiểu"
	}

	switch strings.ToLower(strings.TrimSpace(e.Type)) {
	case string(kernel.ExerciseTypeMultipleChoice), "trắc nghiệm", "mcq":
		options := make([]kernel.MCOption, 0, len(e.Options))
		for _, opt := range e.Options {
			mcOpt, err := kernel.NewMCOption(opt.Label, strToContent(opt.Content))
			if err != nil {
				return nil, fmt.Errorf("lựa chọn trắc nghiệm không hợp lệ (%s): %w", opt.Label, err)
			}
			options = append(options, mcOpt)
		}
		sol := strToContent(e.Explanation)
		return kernel.NewMultipleChoiceExercise(topic, difficulty, prompt, options, e.Answer, sol, diagram)

	default: // Essay hoặc loại khác
		parts := make([]kernel.EssayPart, 0, len(e.Parts))
		for _, p := range e.Parts {
			parts = append(parts, kernel.NewEssayPart(
				p.Label,
				strToContent(p.Question),
				strToContent(p.Solution),
				strToContent(p.Rubric),
			))
		}
		if len(parts) == 0 {
			parts = append(parts, kernel.NewEssayPart("a", prompt, strToContent(e.Answer), strToContent(e.Explanation)))
		}
		return kernel.NewEssayExercise(topic, difficulty, prompt, parts, diagram)
	}
}

func strToContent(s string) kernel.Content {
	trimmed := strings.TrimSpace(s)
	if trimmed == "" {
		return kernel.NewContent()
	}
	return kernel.NewContent(kernel.InlinePart{
		Type:  kernel.InlineText,
		Value: trimmed,
	})
}
