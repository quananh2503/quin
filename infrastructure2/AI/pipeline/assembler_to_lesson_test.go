package pipeline_test

import (
	"testing"
	"uuid"

	"meet-attendance-clean/domain2/assignment"
	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/AI/pipeline"
)

func TestDefaultAssembler_AssembleToLesson_Validation(t *testing.T) {
	assembler := pipeline.NewAssembler()
	mat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
	if err != nil {
		t.Fatalf("tạo material thất bại: %v", err)
	}
	materials := []lesson.StudyMaterial{mat}
	validPlan := &pipeline.LessonPlan{
		LessonTitle: "Bài 1: Vectơ",
		Overview:    "Tổng quan kiến thức",
	}
	validContents := []pipeline.TopicContent{
		{
			TopicID: "T1",
			Title:   "Khái niệm vectơ",
		},
	}

	tests := []struct {
		name      string
		plan      *pipeline.LessonPlan
		contents  []pipeline.TopicContent
		materials []lesson.StudyMaterial
	}{
		{"nil_plan", nil, validContents, materials},
		{"empty_title", &pipeline.LessonPlan{LessonTitle: ""}, validContents, materials},
		{"empty_contents", validPlan, nil, materials},
		{"empty_materials", validPlan, validContents, nil},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			lsn, err := assembler.AssembleToLesson(tc.plan, tc.contents, tc.materials)
			if err == nil {
				t.Fatalf("kỳ vọng lỗi nhưng nhận nil: lsn=%v", lsn)
			}
		})
	}
}

func TestDefaultAssembler_AssembleToLesson_Success(t *testing.T) {
	assembler := pipeline.NewAssembler()
	mat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
	if err != nil {
		t.Fatalf("tạo material thất bại: %v", err)
	}
	materials := []lesson.StudyMaterial{mat}

	plan := &pipeline.LessonPlan{
		LessonTitle: "Toán 12 - Tích vô hướng của hai vectơ",
		Overview:    "Tổng quan phương pháp giải tích vô hướng",
	}

	contents := []pipeline.TopicContent{
		{
			TopicID:      "T1",
			Title:        "Tích vô hướng và góc giữa hai vectơ",
			Difficulty:   "Cơ bản",
			TheoryPoints: []string{"Định nghĩa tích vô hướng: $\\vec{a} \\cdot \\vec{b} = |\\vec{a}||\\vec{b}|\\cos(\\vec{a}, \\vec{b})$"},
			ClozeFormula: "$\\vec{a} \\cdot \\vec{b} = ...$",
			CalloutTip:   "Khẩu quyết: Vuông góc thì tích vô hướng bằng 0.",
			Variants: []pipeline.VariantGuide{
				{
					VariantID:   "V1",
					VariantName: "Tính góc khi biết tọa độ hai vectơ",
					Recognition: "Đề bài cho tọa độ $\\vec{u}(x_1; y_1; z_1)$ và $\\vec{v}(x_2; y_2; z_2)$",
					QuickTip:    "Bấm máy Casio: Menu 5 (Vector) -> Tính tích vô hướng DotProd.",
					ActionSteps: []string{
						"Bước 1: Tính tích vô hướng $\\vec{u} \\cdot \\vec{v} = x_1 x_2 + y_1 y_2 + z_1 z_2$.",
						"Bước 2: Tính độ dài hai vectơ $|\\vec{u}|$ và $|\\vec{v}|$.",
						"Bước 3: Lập tỉ số $\\cos = \\frac{\\vec{u} \\cdot \\vec{v}}{|\\vec{u}||\\vec{v}|}$.",
					},
					Example: pipeline.ExampleItem{
						Title:       "Ví dụ 1",
						Problem:     "Cho $\\vec{a}=(1; 2; 3)$ và $\\vec{b}=(2; 1; -1)$. Tính góc giữa hai vectơ.",
						Solution:    "Áp dụng công thức: $\\vec{a}\\cdot\\vec{b} = 1(2)+2(1)+3(-1) = 1$.",
						Explanation: "Chú ý dấu âm của tọa độ z.",
					},
					Drills: []pipeline.DrillExercise{
						{
							Title:    "Bài tập 1",
							Level:    "Nhận biết",
							Prompt:   "Cho $\\vec{u}=(1; 0; 0)$ và $\\vec{v}=(0; 1; 0)$. Tính tích vô hướng.",
							Solution: "$\\vec{u}\\cdot\\vec{v} = 0$.",
							Answer:   "0",
						},
						{
							Title:    "Bài tập 2",
							Level:    "Vận dụng",
							Prompt:   "Tìm m để hai vectơ vuông góc.",
							Solution: "Điều kiện vuông góc: tích vô hướng = 0.",
							Answer:   "m = 2",
						},
					},
				},
			},
		},
	}

	lsn, err := assembler.AssembleToLesson(plan, contents, materials)
	if err != nil {
		t.Fatalf("AssembleToLesson trả về lỗi: %v", err)
	}
	if lsn == nil {
		t.Fatal("Lesson trả về nil")
	}

	// 1. Kiểm tra Tiêu đề & Tổng quan
	if lsn.Title().String() != plan.LessonTitle {
		t.Errorf("Tiêu đề bài học không khớp: got %q, want %q", lsn.Title().String(), plan.LessonTitle)
	}
	if lsn.Overview().String() != plan.Overview {
		t.Errorf("Tổng quan bài học không khớp: got %q, want %q", lsn.Overview().String(), plan.Overview)
	}

	// 2. Kiểm tra Section & Topic
	sections := lsn.Sections()
	if len(sections) != 1 {
		t.Fatalf("Số lượng section không đúng: got %d, want 1", len(sections))
	}
	topics := sections[0].Topics()
	if len(topics) != 1 {
		t.Fatalf("Số lượng topic không đúng: got %d, want 1", len(topics))
	}
	topic := topics[0]

	// 3. Kiểm tra các Blocks (Phải có Theory, Formula, CalloutTip, Recognition, QuickTip, ActionSteps, Example)
	blocks := topic.Blocks()
	if len(blocks) < 6 {
		t.Fatalf("Số lượng blocks trong topic quá ít: got %d, want >= 6", len(blocks))
	}

	hasParagraph := false
	hasFormula := false
	hasQuickTip := false
	hasActionSteps := false
	hasExample := false

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
				hasActionSteps = true
			}
		case lesson.ExampleBlock:
			if blk.Title().String() == "Ví dụ 1" {
				hasExample = true
			}
		}
	}

	if !hasParagraph {
		t.Error("Không tìm thấy ParagraphBlock (Lý thuyết)")
	}
	if !hasFormula {
		t.Error("Không tìm thấy FormulaBlock (Công thức then chốt)")
	}
	if !hasQuickTip {
		t.Error("Không tìm thấy CalloutBlock Mẹo giải nhanh & Casio")
	}
	if !hasActionSteps {
		t.Error("Không tìm thấy ListBlock Các bước giải chi tiết")
	}
	if !hasExample {
		t.Error("Không tìm thấy ExampleBlock Ví dụ minh họa")
	}

	// 4. Kiểm tra Exercises tổng hợp qua lsn.Exercises()
	exercises := lsn.Exercises()
	if len(exercises) != 2 {
		t.Fatalf("Số lượng bài tập rèn luyện không khớp: got %d, want 2", len(exercises))
	}

	firstEx, ok := exercises[0].(sharekernel.EssayExercise)
	if !ok {
		t.Fatalf("Bài tập 1 không phải là EssayExercise: %T", exercises[0])
	}
	if len(firstEx.Parts()) != 1 {
		t.Fatalf("Bài tập 1 phải có đúng 1 phần câu hỏi: got %d", len(firstEx.Parts()))
	}
	if firstEx.Parts()[0].Question().String() != "Cho $\\vec{u}=(1; 0; 0)$ và $\\vec{v}=(0; 1; 0)$. Tính tích vô hướng." {
		t.Errorf("Đề bài bài tập 1 không khớp: %s", firstEx.Parts()[0].Question().String())
	}

	// 5. Kiểm tra tính tương thích 100% với Assignment (Bóc tách bài tập cho OneNote và chấm điểm)
	asgn, errAsgn := assignment.NewNormalAssignmentFromLesson(uuid.New(), "Phiếu bài tập", *lsn)
	if errAsgn != nil {
		t.Fatalf("NewNormalAssignmentFromLesson thất bại: %v", errAsgn)
	}
	if len(asgn.Items()) != 2 {
		t.Fatalf("Số lượng AssignmentItem không đúng: got %d, want 2", len(asgn.Items()))
	}
}
