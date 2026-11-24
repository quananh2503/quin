package decode

import (
	"errors"
	"fmt"
	"regexp"
	"strings"

	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

var stepSplitRegex = regexp.MustCompile(`(?i)([^\n])\s+((?:[-*]\s*)?bước\s*\d+[:.-])`)

// AssembleToLesson converts LessonPlan and TopicContent entries into a validated domain *lesson.Lesson.
func AssembleToLesson(plan raw.LessonPlan, contents []raw.TopicContent, materials []lesson.StudyMaterial) (*lesson.Lesson, error) {
	if strings.TrimSpace(plan.LessonTitle) == "" {
		return nil, errors.New("lesson title must not be empty")
	}
	if len(contents) == 0 {
		return nil, errors.New("topic contents must not be empty")
	}
	if len(materials) == 0 {
		return nil, lesson.ErrMaterialsEmpty
	}

	topics := make([]lesson.Topic, 0, len(contents))
	for i := range contents {
		top, err := buildTopicFromContent(&contents[i])
		if err != nil {
			return nil, err
		}
		topics = append(topics, top)
	}

	section, err := lesson.NewSection(textToContent("Nội Dung Chuyên Đề & Dạng Bài"), topics)
	if err != nil {
		return nil, fmt.Errorf("create section: %w", err)
	}

	lsn, err := lesson.NewLesson(
		textToContent(plan.LessonTitle),
		textToContent(plan.Overview),
		[]lesson.Section{section},
		materials,
	)
	if err != nil {
		return nil, fmt.Errorf("create lesson: %w", err)
	}
	return lsn, nil
}

// PlanToLesson converts a LessonPlan directly into a domain *lesson.Lesson in fallback planner-only mode.
func PlanToLesson(plan raw.LessonPlan, fallbackTitle string, materials []lesson.StudyMaterial) (*lesson.Lesson, error) {
	if len(materials) == 0 {
		return nil, lesson.ErrMaterialsEmpty
	}
	lessonTitle := strings.TrimSpace(plan.LessonTitle)
	if lessonTitle == "" {
		lessonTitle = strings.TrimSpace(fallbackTitle)
	}

	topics := make([]lesson.Topic, 0, len(plan.Topics))
	for i := range plan.Topics {
		tp := &plan.Topics[i]
		topTitle := textToContent(fmt.Sprintf("%s: %s (%s)", tp.TopicID, tp.Title, tp.Difficulty))
		var blocks []lesson.Block
		if strings.TrimSpace(tp.CoreConcept) != "" {
			blocks = append(blocks, lesson.NewParagraphBlock(textToContent(tp.CoreConcept)))
		}
		if strings.TrimSpace(tp.TargetOutput) != "" {
			blocks = append(blocks, lesson.NewCalloutBlock(
				lesson.CalloutTip,
				textToContent("Mục tiêu đạt được"),
				textToContent(tp.TargetOutput),
			))
		}
		top, err := lesson.NewTopic(topTitle, blocks, nil)
		if err != nil {
			return nil, fmt.Errorf("create topic %s: %w", tp.TopicID, err)
		}
		topics = append(topics, top)
	}

	section, err := lesson.NewSection(textToContent("Chuyên đề bài học"), topics)
	if err != nil {
		return nil, fmt.Errorf("create section: %w", err)
	}

	lsn, err := lesson.NewLesson(
		textToContent(lessonTitle),
		textToContent(plan.Overview),
		[]lesson.Section{section},
		materials,
	)
	if err != nil {
		return nil, fmt.Errorf("create lesson: %w", err)
	}
	return lsn, nil
}

// FormatStepSolution splits inline "Bước N:" sequences onto separate lines for domain Content blocks.
func FormatStepSolution(text string) string {
	trimmed := strings.TrimSpace(text)
	if trimmed == "" {
		return ""
	}
	return stepSplitRegex.ReplaceAllString(trimmed, "$1\n$2")
}

func buildTopicFromContent(tc *raw.TopicContent) (lesson.Topic, error) {
	blocks := buildTopicBlocks(tc)
	exercises, err := buildTopicExercises(tc)
	if err != nil {
		return lesson.Topic{}, err
	}

	topTitle := strings.TrimSpace(tc.Title)
	if tc.TopicID != "" && !strings.HasPrefix(topTitle, tc.TopicID) {
		topTitle = fmt.Sprintf("[%s] %s", tc.TopicID, topTitle)
	}
	top, err := lesson.NewTopic(textToContent(topTitle), blocks, exercises)
	if err != nil {
		return lesson.Topic{}, fmt.Errorf("create topic %s: %w", tc.TopicID, err)
	}
	return top, nil
}

func buildTopicBlocks(tc *raw.TopicContent) []lesson.Block {
	var blocks []lesson.Block
	if len(tc.TheoryPoints) > 0 {
		theoryText := strings.TrimSpace(strings.Join(tc.TheoryPoints, "\n"))
		if theoryText != "" {
			blocks = append(blocks, lesson.NewParagraphBlock(textToContent(theoryText)))
		}
	}
	if strings.TrimSpace(tc.ClozeFormula) != "" {
		blocks = append(blocks, lesson.NewFormulaBlock(tc.ClozeFormula))
	}
	if strings.TrimSpace(tc.CalloutTip) != "" {
		blocks = append(blocks, lesson.NewCalloutBlock(
			lesson.CalloutTip,
			textToContent("Mẹo giải nhanh & Khẩu quyết"),
			textToContent(tc.CalloutTip),
		))
	}
	for vIdx := range tc.Variants {
		blocks = append(blocks, buildVariantBlocks(vIdx, &tc.Variants[vIdx])...)
	}
	for _, ex := range tc.Examples {
		blocks = append(blocks, lesson.NewExampleBlock(
			textToContent(ex.Title),
			textToContent(ex.Problem),
			textToContent(FormatStepSolution(ex.Solution)),
			textToContent(ex.Explanation),
		))
	}
	if len(tc.AnswerKey) > 0 {
		blocks = append(blocks, buildAnswerKeyBlock(tc.AnswerKey))
	}
	return blocks
}

func buildVariantBlocks(vIdx int, v *raw.VariantGuide) []lesson.Block {
	var blocks []lesson.Block
	vTitle := strings.TrimSpace(v.VariantName)
	if vTitle == "" {
		vTitle = strings.TrimSpace(v.VariantID)
	}
	if vTitle == "" {
		vTitle = fmt.Sprintf("Biến thể %d", vIdx+1)
	}

	recText := strings.TrimSpace(v.Recognition)
	if recText == "" {
		recText = "Áp dụng cho các bài toán thuộc dạng: " + vTitle
	}
	blocks = append(blocks, lesson.NewCalloutBlock(
		lesson.CalloutNote,
		textToContent("Dấu hiệu nhận biết - "+vTitle),
		textToContent(recText),
	))

	if strings.TrimSpace(v.QuickTip) != "" {
		blocks = append(blocks, lesson.NewCalloutBlock(
			lesson.CalloutTip,
			textToContent("Mẹo giải nhanh & Casio"),
			textToContent(v.QuickTip),
		))
	}

	if len(v.ActionSteps) > 0 {
		items := make([]sharekernel.Content, 0, len(v.ActionSteps))
		for _, step := range v.ActionSteps {
			if trimmed := strings.TrimSpace(step); trimmed != "" {
				items = append(items, textToContent(trimmed))
			}
		}
		if len(items) > 0 {
			blocks = append(blocks, lesson.NewListBlock(true, items))
		}
	}

	if strings.TrimSpace(v.Example.Problem) != "" {
		exTitle := strings.TrimSpace(v.Example.Title)
		if exTitle == "" {
			exTitle = "Ví dụ minh họa"
		}
		blocks = append(blocks, lesson.NewExampleBlock(
			textToContent(exTitle),
			textToContent(v.Example.Problem),
			textToContent(FormatStepSolution(v.Example.Solution)),
			textToContent(v.Example.Explanation),
		))
	}
	return blocks
}

func buildAnswerKeyBlock(items []raw.AnswerItem) lesson.Block {
	var sb strings.Builder
	for i, ans := range items {
		if i > 0 {
			sb.WriteByte('\n')
		}
		sb.WriteString(fmt.Sprintf("%s: %s (%s)", ans.DrillID, ans.FinalAnswer, ans.ShortGuide))
	}
	return lesson.NewCalloutBlock(
		lesson.CalloutNote,
		textToContent("Bảng đáp án nhanh"),
		textToContent(sb.String()),
	)
}

func buildTopicExercises(tc *raw.TopicContent) ([]sharekernel.Exercise, error) {
	var exercises []sharekernel.Exercise
	for i := range tc.Variants {
		v := &tc.Variants[i]
		for _, d := range v.Drills {
			ex, err := buildExerciseFromDrill(tc.Title, d)
			if err != nil {
				return nil, fmt.Errorf("build drill for variant %s: %w", v.VariantID, err)
			}
			exercises = append(exercises, ex)
		}
	}
	for _, s := range tc.ShortAnswers {
		ex, err := buildExerciseFromShortAnswer(tc.Title, s)
		if err != nil {
			return nil, fmt.Errorf("build short answer exercise: %w", err)
		}
		exercises = append(exercises, ex)
	}
	for _, d := range tc.Drills {
		ex, err := buildExerciseFromDrill(tc.Title, d)
		if err != nil {
			return nil, fmt.Errorf("build extra drill: %w", err)
		}
		exercises = append(exercises, ex)
	}
	return exercises, nil
}

func buildExerciseFromDrill(topicTitle string, d raw.DrillExercise) (sharekernel.Exercise, error) {
	promptContent := rawTextContent(d.Prompt)
	diag := sharekernel.NewDiagram(sharekernel.DiagramNone, "")
	diff := strings.TrimSpace(d.Level)
	if diff == "" {
		diff = "Vận dụng"
	}
	rubric := textToContent(d.Solution)
	if strings.TrimSpace(d.Solution) == "" && strings.TrimSpace(d.Answer) != "" {
		rubric = textToContent(d.Answer)
	}
	part := sharekernel.NewEssayPart("a", promptContent, textToContent(d.Solution), rubric)
	ex, err := sharekernel.NewEssayExercise(topicTitle, diff, promptContent, []sharekernel.EssayPart{part}, diag)
	if err != nil {
		return nil, fmt.Errorf("create essay exercise: %w", err)
	}
	return ex, nil
}

func buildExerciseFromShortAnswer(topicTitle string, s raw.ShortAnswerExercise) (sharekernel.Exercise, error) {
	promptContent := rawTextContent(s.Prompt)
	rubric := textToContent(s.FinalNumber)
	if strings.TrimSpace(s.FinalNumber) == "" && strings.TrimSpace(s.Solution) != "" {
		rubric = textToContent(s.Solution)
	}
	part := sharekernel.NewEssayPart("a", promptContent, textToContent(s.Solution), rubric)
	diag := sharekernel.NewDiagram(sharekernel.DiagramNone, "")
	ex, err := sharekernel.NewEssayExercise(topicTitle, "Thông hiểu", promptContent, []sharekernel.EssayPart{part}, diag)
	if err != nil {
		return nil, fmt.Errorf("create short answer essay exercise: %w", err)
	}
	return ex, nil
}

func rawTextContent(text string) sharekernel.Content {
	trimmed := strings.TrimSpace(text)
	if trimmed == "" {
		return sharekernel.Content{}
	}
	return sharekernel.NewContent(sharekernel.InlinePart{
		Type:  sharekernel.InlineText,
		Value: trimmed,
	})
}

func textToContent(text string) sharekernel.Content {
	trimmed := strings.TrimSpace(text)
	if trimmed == "" {
		trimmed = "-"
	}
	return sharekernel.NewContent(sharekernel.InlinePart{
		Type:  sharekernel.InlineText,
		Value: trimmed,
	})
}
