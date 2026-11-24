package decode_test

import (
	"strings"
	"testing"

	"meet-attendance-clean/domain2/assignment"
	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/AI/internal/decode"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
	"uuid"
)

func TestAssembleToLesson_ValidReconstitution_And_AssignmentCompat(t *testing.T) {
	mat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
	if err != nil {
		t.Fatalf("NewYouTubeMaterial failed: %v", err)
	}
	materials := []lesson.StudyMaterial{mat}

	plan := raw.LessonPlan{
		LessonTitle: "Toán 12 - Tích vô hướng của hai vectơ",
		Overview:    "Tổng quan phương pháp giải tích vô hướng",
	}

	contents := []raw.TopicContent{
		{
			TopicID:      "T1",
			Title:        "Tích vô hướng và góc giữa hai vectơ",
			Difficulty:   "Cơ bản",
			TheoryPoints: []string{"Định nghĩa: $\\vec{a}\\cdot\\vec{b} = |\\vec{a}||\\vec{b}|\\cos(\\vec{a},\\vec{b})$."},
			ClozeFormula: "$\\vec{a}\\cdot\\vec{b} = ...$",
			CalloutTip:   "Vuông góc thì tích vô hướng bằng 0.",
			Variants: []raw.VariantGuide{
				{
					VariantID:   "V1",
					VariantName: "Tính góc khi biết tọa độ",
					Recognition: "Đề bài cho tọa độ hai vectơ.",
					QuickTip:    "Dùng Casio Menu 5 -> DotProd.",
					ActionSteps: []string{
						"Bước 1: Tính tích vô hướng.",
						"Bước 2: Tính độ dài hai vectơ.",
						"Bước 3: Lập tỉ số cos.",
					},
					Example: raw.ExampleItem{
						Title:       "Ví dụ 1",
						Problem:     "Cho $\\vec{a}=(1;2;3)$ và $\\vec{b}=(2;1;-1)$.",
						Solution:    "Bước 1: Tính $\\vec{a}\\cdot\\vec{b}=1$. Bước 2: Kết luận.",
						Explanation: "Chú ý dấu âm.",
					},
					Drills: []raw.DrillExercise{
						{
							Title:    "Bài tập 1",
							Level:    "Nhận biết",
							Prompt:   "Cho $\\vec{u}=(1;0;0)$ và $\\vec{v}=(0;1;0)$.",
							Solution: "$\\vec{u}\\cdot\\vec{v} = 0$.",
							Answer:   "0",
						},
					},
				},
			},
			Examples: []raw.ExampleItem{
				{Title: "Ví dụ bổ sung", Problem: "Đề mẫu", Solution: "Giải mẫu"},
			},
			ShortAnswers: []raw.ShortAnswerExercise{
				{Prompt: "Tính $1+1$", Solution: "$2$", FinalNumber: "2"},
			},
			Drills: []raw.DrillExercise{
				{Title: "Bài ngoài", Level: "Vận dụng", Prompt: "Tìm $m$.", Solution: "$m=2$", Answer: "2"},
			},
			AnswerKey: []raw.AnswerItem{
				{DrillID: "Bài tập 1", ShortGuide: "Tích vô hướng", FinalAnswer: "0"},
			},
		},
	}

	lsn, err := decode.AssembleToLesson(plan, contents, materials)
	if err != nil {
		t.Fatalf("AssembleToLesson failed: %v", err)
	}
	if lsn.Title().String() != plan.LessonTitle || lsn.Overview().String() != plan.Overview {
		t.Errorf("Title/Overview mismatch: %q / %q", lsn.Title().String(), lsn.Overview().String())
	}

	sections := lsn.Sections()
	if len(sections) != 1 || len(sections[0].Topics()) != 1 {
		t.Fatalf("unexpected section/topic structure: %d sections", len(sections))
	}
	top := sections[0].Topics()[0]
	blocks := top.Blocks()
	if len(blocks) < 7 {
		t.Fatalf("got %d blocks, want >= 7", len(blocks))
	}

	var hasParagraph, hasFormula, hasQuickTip, hasSteps, hasExample bool
	for _, b := range blocks {
		switch blk := b.(type) {
		case lesson.ParagraphBlock:
			hasParagraph = true
		case lesson.FormulaBlock:
			hasFormula = true
		case lesson.CalloutBlock:
			if blk.Title().String() == "Mẹo giải nhanh & Casio" {
				hasQuickTip = true
			}
		case lesson.ListBlock:
			if blk.IsOrdered() && len(blk.Items()) == 3 {
				hasSteps = true
			}
		case lesson.ExampleBlock:
			if blk.Title().String() == "Ví dụ 1" {
				hasExample = true
				if !strings.Contains(blk.Solution().String(), "\nBước 2:") {
					t.Errorf("expected split step lines in ExampleBlock solution, got %q", blk.Solution().String())
				}
			}
		}
	}
	if !hasParagraph || !hasFormula || !hasQuickTip || !hasSteps || !hasExample {
		t.Errorf("missing expected blocks: para=%v formula=%v tip=%v steps=%v ex=%v",
			hasParagraph, hasFormula, hasQuickTip, hasSteps, hasExample)
	}

	exercises := lsn.Exercises()
	if len(exercises) != 3 {
		t.Fatalf("Exercises len = %d, want 3 (1 variant drill + 1 short answer + 1 extra drill)", len(exercises))
	}
	if _, ok := exercises[0].(sharekernel.EssayExercise); !ok {
		t.Fatalf("exercise 0 type = %T, want EssayExercise", exercises[0])
	}

	asgn, errAsgn := assignment.NewNormalAssignmentFromLesson(uuid.New(), "Phiếu bài tập", *lsn)
	if errAsgn != nil || len(asgn.Items()) != 3 {
		t.Fatalf("NewNormalAssignmentFromLesson failed: asgn=%v err=%v", asgn, errAsgn)
	}
}

func TestAssembleToLesson_DomainInvariantRejections(t *testing.T) {
	mat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
	if err != nil {
		t.Fatalf("NewYouTubeMaterial failed: %v", err)
	}
	materials := []lesson.StudyMaterial{mat}
	validPlan := raw.LessonPlan{LessonTitle: "Bài 1", Overview: "Tổng quan"}
	validContents := []raw.TopicContent{{TopicID: "T1", Title: "Dạng 1"}}

	cases := []struct {
		name      string
		plan      raw.LessonPlan
		contents  []raw.TopicContent
		materials []lesson.StudyMaterial
	}{
		{"EmptyTitle", raw.LessonPlan{LessonTitle: ""}, validContents, materials},
		{"EmptyContents", validPlan, nil, materials},
		{"EmptyMaterials", validPlan, validContents, nil},
		{"InvalidDrillEmptyPrompt", validPlan, []raw.TopicContent{
			{TopicID: "T1", Title: "Dạng 1", Drills: []raw.DrillExercise{{Title: "Bad", Prompt: "   "}}},
		}, materials},
		{"InvalidVariantDrillEmptyPrompt", validPlan, []raw.TopicContent{
			{TopicID: "T1", Title: "Dạng 1", Variants: []raw.VariantGuide{{VariantID: "V1", Drills: []raw.DrillExercise{{Prompt: ""}}}}},
		}, materials},
		{"InvalidShortAnswerEmptyPrompt", validPlan, []raw.TopicContent{
			{TopicID: "T1", Title: "Dạng 1", ShortAnswers: []raw.ShortAnswerExercise{{Prompt: "\t"}}},
		}, materials},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if _, err := decode.AssembleToLesson(tc.plan, tc.contents, tc.materials); err == nil {
				t.Fatalf("expected error for %s, got nil", tc.name)
			}
		})
	}
}

func TestPlanToLesson_And_FormatStepSolution(t *testing.T) {
	mat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
	if err != nil {
		t.Fatalf("NewYouTubeMaterial failed: %v", err)
	}

	if got := decode.FormatStepSolution("   "); got != "" {
		t.Errorf("FormatStepSolution blank = %q, want empty", got)
	}
	split := decode.FormatStepSolution("Bước 1: Xác định điểm đầu. Bước 2: Kết luận.")
	if split != "Bước 1: Xác định điểm đầu.\nBước 2: Kết luận." {
		t.Errorf("FormatStepSolution = %q", split)
	}

	plan := raw.LessonPlan{
		LessonTitle: "",
		Overview:    "Tổng quan",
		Topics: []raw.TopicPlan{
			{TopicID: "T1", Title: "Dạng 1", Difficulty: "Cơ bản", CoreConcept: "Khái niệm", TargetOutput: "Làm được bài"},
			{TopicID: "T2", Title: "Dạng 2", Difficulty: "Nâng cao"},
		},
	}
	lsn, err := decode.PlanToLesson(plan, "Fallback Title", []lesson.StudyMaterial{mat})
	if err != nil {
		t.Fatalf("PlanToLesson failed: %v", err)
	}
	if lsn.Title().String() != "Fallback Title" || len(lsn.Sections()) != 1 || len(lsn.Sections()[0].Topics()) != 2 {
		t.Fatalf("unexpected PlanToLesson result: title=%q", lsn.Title().String())
	}
	t1Blocks := lsn.Sections()[0].Topics()[0].Blocks()
	t2Blocks := lsn.Sections()[0].Topics()[1].Blocks()
	if len(t1Blocks) != 2 || len(t2Blocks) != 0 {
		t.Errorf("unexpected PlanToLesson block counts: t1=%d (want 2), t2=%d (want 0)", len(t1Blocks), len(t2Blocks))
	}

	explicitPlan := raw.LessonPlan{LessonTitle: "Tiêu đề chính", Topics: []raw.TopicPlan{{TopicID: "T1", Title: "D1"}}}
	lsnExplicit, err := decode.PlanToLesson(explicitPlan, "Fallback", []lesson.StudyMaterial{mat})
	if err != nil || lsnExplicit.Title().String() != "Tiêu đề chính" {
		t.Errorf("explicit LessonTitle failed: lsn=%v err=%v", lsnExplicit, err)
	}

	if _, errNoMats := decode.PlanToLesson(plan, "T", nil); errNoMats == nil {
		t.Fatal("expected error when materials is empty")
	}
}

func TestAssembleToLesson_FallbacksAndBoundaryVariants(t *testing.T) {
	mat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
	if err != nil {
		t.Fatalf("NewYouTubeMaterial failed: %v", err)
	}
	plan := raw.LessonPlan{LessonTitle: "Bài tổng hợp", Overview: "Tóm tắt"}
	contents := []raw.TopicContent{
		{
			TopicID:      "T2",
			Title:        "T2: Đã có prefix",
			TheoryPoints: []string{"   "},
			CalloutTip:   "Ghi nhớ trọng tâm",
			Variants: []raw.VariantGuide{
				{VariantID: "V_ID", ActionSteps: []string{"  "}, Example: raw.ExampleItem{Problem: "Giải x"}},
				{Recognition: ""},
			},
			AnswerKey: []raw.AnswerItem{
				{DrillID: "D1", FinalAnswer: "A1", ShortGuide: "G1"},
				{DrillID: "D2", FinalAnswer: "A2", ShortGuide: "G2"},
			},
		},
		{TopicID: "", Title: "Không mã"},
	}

	lsn, err := decode.AssembleToLesson(plan, contents, []lesson.StudyMaterial{mat})
	if err != nil {
		t.Fatalf("AssembleToLesson failed: %v", err)
	}
	topics := lsn.Sections()[0].Topics()
	if topics[0].Title().String() != "T2: Đã có prefix" || topics[1].Title().String() != "Không mã" {
		t.Errorf("unexpected topic titles: %q, %q", topics[0].Title().String(), topics[1].Title().String())
	}
	if len(topics[1].Blocks()) != 0 {
		t.Errorf("empty topic should have 0 blocks, got %d", len(topics[1].Blocks()))
	}

	var calloutTitles []string
	var hasExDefaultTitle, hasPara, hasList bool
	for _, b := range topics[0].Blocks() {
		switch blk := b.(type) {
		case lesson.ParagraphBlock:
			hasPara = true
		case lesson.ListBlock:
			hasList = true
		case lesson.ExampleBlock:
			if blk.Title().String() == "Ví dụ minh họa" {
				hasExDefaultTitle = true
			}
		case lesson.CalloutBlock:
			calloutTitles = append(calloutTitles, blk.Title().String()+"="+blk.Body().String())
		}
	}
	if hasPara || hasList || !hasExDefaultTitle {
		t.Errorf("unexpected block flags: para=%v list=%v exDefault=%v", hasPara, hasList, hasExDefaultTitle)
	}
	joined := strings.Join(calloutTitles, "|")
	for _, want := range []string{
		"Mẹo giải nhanh & Khẩu quyết=Ghi nhớ trọng tâm",
		"Dấu hiệu nhận biết - V_ID=Áp dụng cho các bài toán thuộc dạng: V_ID",
		"Dấu hiệu nhận biết - Biến thể 2=Áp dụng cho các bài toán thuộc dạng: Biến thể 2",
		"Bảng đáp án nhanh=D1: A1 (G1)\nD2: A2 (G2)",
	} {
		if !strings.Contains(joined, want) {
			t.Errorf("missing expected callout %q in %q", want, joined)
		}
	}
}

func TestAssembleToLesson_ExerciseDefaultsAndRubricFallbacks(t *testing.T) {
	mat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
	if err != nil {
		t.Fatalf("NewYouTubeMaterial failed: %v", err)
	}
	plan := raw.LessonPlan{LessonTitle: "Bài tập", Overview: "Tổng quan"}
	contents := []raw.TopicContent{
		{
			TopicID: "T1",
			Title:   "Chuyên đề",
			Drills: []raw.DrillExercise{
				{Prompt: "P1", Solution: "", Answer: "42"},
				{Level: "Nhận biết", Prompt: "P2", Solution: "Chi tiết", Answer: "99"},
			},
			ShortAnswers: []raw.ShortAnswerExercise{
				{Prompt: "SA1", Solution: "Lời giải SA", FinalNumber: ""},
				{Prompt: "SA2", Solution: "Lời giải SA2", FinalNumber: "7"},
			},
		},
	}
	lsn, err := decode.AssembleToLesson(plan, contents, []lesson.StudyMaterial{mat})
	if err != nil {
		t.Fatalf("AssembleToLesson failed: %v", err)
	}
	exs := lsn.Exercises()
	if len(exs) != 4 {
		t.Fatalf("got %d exercises, want 4", len(exs))
	}
	var essays [4]sharekernel.EssayExercise
	for i, ex := range exs {
		ee, ok := ex.(sharekernel.EssayExercise)
		if !ok {
			t.Fatalf("exercise %d type = %T, want EssayExercise", i, ex)
		}
		essays[i] = ee
	}
	if essays[2].Difficulty() != "Vận dụng" || essays[2].Parts()[0].Rubric().String() != "42" {
		t.Errorf("drill 0 fallback mismatch: diff=%q rubric=%q", essays[2].Difficulty(), essays[2].Parts()[0].Rubric().String())
	}
	if essays[3].Difficulty() != "Nhận biết" || essays[3].Parts()[0].Rubric().String() != "Chi tiết" {
		t.Errorf("drill 1 explicit mismatch: diff=%q rubric=%q", essays[3].Difficulty(), essays[3].Parts()[0].Rubric().String())
	}
	if essays[0].Parts()[0].Rubric().String() != "Lời giải SA" || essays[1].Parts()[0].Rubric().String() != "7" {
		t.Errorf("short answer rubric mismatch: sa0=%q sa1=%q", essays[0].Parts()[0].Rubric().String(), essays[1].Parts()[0].Rubric().String())
	}
}
