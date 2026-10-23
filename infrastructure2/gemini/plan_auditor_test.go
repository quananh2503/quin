package gemini_test

import (
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestDefaultPlanAuditor_CleanPlan(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	plan := &gemini.LessonPlan{
		LessonTitle: "Bài 1: Vectơ không gian",
		Overview:    "Tổng quan",
		QuestionCatalog: []gemini.CatalogItem{
			{DocID: "DOC_1", TargetOutput: "Tính độ dài", CoreMethod: "Định nghĩa", QuestionIDs: []string{"C1", "C2"}},
		},
		Topics: []gemini.Topic{
			{
				TopicID:             "dang_1",
				Title:               "Dạng 1: Khái niệm",
				AssignedQuestionIDs: []string{"C1", "C2"},
			},
		},
	}

	report := auditor.Audit(plan)
	assert.False(t, report.NeedsRefinement, "Kế hoạch sạch sẽ không cần tinh chỉnh")
	assert.Empty(t, report.UnassignedIDs)
	assert.Empty(t, report.OverloadedTopics)
	assert.Empty(t, report.RedundantTopics)
}

func TestDefaultPlanAuditor_DetectsUnassignedCatalogQuestions(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	plan := &gemini.LessonPlan{
		LessonTitle: "Bài 1: Vectơ không gian",
		QuestionCatalog: []gemini.CatalogItem{
			{DocID: "DOC_1", TargetOutput: "Tính độ dài", CoreMethod: "Định nghĩa", QuestionIDs: []string{"C1", "C2", "C3"}},
		},
		Topics: []gemini.Topic{
			{
				TopicID:             "dang_1",
				Title:               "Dạng 1: Khái niệm",
				AssignedQuestionIDs: []string{"C1"},
			},
		},
	}

	report := auditor.Audit(plan)
	assert.True(t, report.NeedsRefinement)
	require.NotEmpty(t, report.UnassignedIDs)
	assert.Contains(t, report.UnassignedIDs[0], "C2")
}

func TestDefaultPlanAuditor_DetectsSequenceHoles(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	plan := &gemini.LessonPlan{
		LessonTitle: "Bài 1: Vectơ",
		Topics: []gemini.Topic{
			{
				TopicID:             "dang_1",
				Title:               "Dạng 1: Trắc nghiệm",
				AssignedQuestionIDs: []string{"C1", "C4"}, // Thiếu C2, C3
			},
		},
	}

	report := auditor.Audit(plan)
	assert.True(t, report.NeedsRefinement)
	assert.Contains(t, report.UnassignedIDs, "C2")
	assert.Contains(t, report.UnassignedIDs, "C3")
}

func TestDefaultPlanAuditor_DetectsOverloadedTopics(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	// Topic có 12 câu (> 10 câu)
	overloadedQuestions := []string{"C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "C12"}
	plan := &gemini.LessonPlan{
		Topics: []gemini.Topic{
			{
				TopicID:             "dang_1",
				Title:               "Dạng gom gộp",
				AssignedQuestionIDs: overloadedQuestions,
			},
		},
	}

	report := auditor.Audit(plan)
	assert.True(t, report.NeedsRefinement)
	require.Len(t, report.OverloadedTopics, 1)
	assert.Equal(t, "dang_1", report.OverloadedTopics[0].TopicID)
}

func TestDefaultPlanAuditor_DetectsRedundantTopics(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	plan := &gemini.LessonPlan{
		Topics: []gemini.Topic{
			{
				TopicID: "dang_1",
				Title:   "Phân tích vectơ theo 3 cạnh tứ diện",
			},
			{
				TopicID: "dang_2",
				Title:   "Phân tích vectơ theo 3 cạnh tứ diện", // Trùng tiêu đề
			},
		},
	}

	report := auditor.Audit(plan)
	assert.True(t, report.NeedsRefinement)
	require.Len(t, report.RedundantTopics, 1)
	assert.Equal(t, "dang_2", report.RedundantTopics[0].TopicID)
}

func TestDefaultPlanAuditor_NilOrEmptyPlan(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	reportNil := auditor.Audit(nil)
	assert.False(t, reportNil.NeedsRefinement)

	reportEmpty := auditor.Audit(&gemini.LessonPlan{})
	assert.False(t, reportEmpty.NeedsRefinement)
}
