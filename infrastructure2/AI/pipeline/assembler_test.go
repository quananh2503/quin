package pipeline_test

import (
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/AI/pipeline"
)

func TestLaTeXToMiTeX(t *testing.T) {
	input := "Cho vectơ $\\vec{AB}$ và $\\vec{CD}$. Độ dài là: $$|\\vec{AB}| = 2$$"
	output := pipeline.LaTeXToMiTeX(input)

	if !strings.Contains(output, "#mi(`\\vec{AB}`)") {
		t.Errorf("Chuyển đổi inline math thất bại: %s", output)
	}
	if !strings.Contains(output, "#mitex(`|\\vec{AB}| = 2`)") {
		t.Errorf("Chuyển đổi block math thất bại: %s", output)
	}
}

func TestRenderTopicTypst(t *testing.T) {
	tc := &pipeline.TopicContent{
		TopicID:      "T1",
		Title:        "Khái niệm vectơ",
		Difficulty:   "Nhận biết",
		TheoryPoints: []string{"Vectơ là đoạn thẳng có hướng."},
		ClozeFormula: "$|\\vec{AB}| = ...$",
		CalloutTip:   "Khẩu quyết nhớ nhanh",
		Variants: []pipeline.VariantGuide{
			{
				VariantID:   "V1",
				VariantName: "Nhận biết vectơ",
				Recognition: "Đề cho hình vẽ",
				ActionSteps: []string{
					"Bước 1: Tìm gốc ngọn",
					"Bước 2: Bấm Casio",
				},
				QuickTip: "Mẹo loại trừ đáp án",
				Example: pipeline.ExampleItem{
					Title:    "Ví dụ 1",
					Problem:  "Cho hình chóp",
					Solution: "Lời giải ví dụ",
				},
				Drills: []pipeline.DrillExercise{
					{
						Title:    "Bài 1",
						Level:    "TuongTu100",
						Prompt:   "Bài tập 1",
						Solution: "Lời giải bài 1",
						Answer:   "A",
					},
				},
			},
		},
		AnswerKey: []pipeline.AnswerItem{
			{
				DrillID:     "Bài 1",
				ShortGuide:  "Dùng quy tắc",
				FinalAnswer: "A",
			},
		},
	}

	typstCode := pipeline.RenderTopicTypst(tc)
	if !strings.Contains(typstCode, "DẠNG TOÁN [T1]") {
		t.Errorf("Không chứa tiêu đề dạng toán")
	}
	if !strings.Contains(typstCode, "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN") {
		t.Errorf("Không chứa khung hành động")
	}
	if !strings.Contains(typstCode, "IS_TEACHER") {
		t.Errorf("Không chứa cờ IS_TEACHER")
	}
}

func TestAssembleToTypst(t *testing.T) {
	assembler := pipeline.NewAssembler()
	plan := &pipeline.LessonPlan{
		LessonTitle: "Bài 1: Vectơ",
		Overview:    "Tổng quan bài 1",
	}
	contents := []pipeline.TopicContent{
		{
			TopicID: "T1",
			Title:   "Dạng 1",
		},
		{
			TopicID: "T2",
			Title:   "Dạng 2",
		},
	}

	tTypst, sTypst, err := assembler.AssembleToTypst(plan, contents)
	if err != nil {
		t.Fatalf("AssembleToTypst thất bại: %v", err)
	}
	if len(tTypst) == 0 || len(sTypst) == 0 {
		t.Fatal("Typst markup rỗng")
	}
	if !strings.Contains(tTypst, "Bài 1: Vectơ") {
		t.Errorf("Không chứa tiêu đề bài học")
	}
}

func TestSplitStepLines(t *testing.T) {
	in := "Bước 1: Xác định điểm đầu và ngọn. Bước 2: Dựa vào tính chất hình bình hành. Bước 3: Kết luận điểm cần tìm."
	out := pipeline.SplitStepLines(in)
	expected := "Bước 1: Xác định điểm đầu và ngọn.\nBước 2: Dựa vào tính chất hình bình hành.\nBước 3: Kết luận điểm cần tìm."
	if out != expected {
		t.Errorf("Kỳ vọng:\n%s\nNhận được:\n%s", expected, out)
	}

	alreadySplit := "Bước 1: A.\nBước 2: B."
	if pipeline.SplitStepLines(alreadySplit) != alreadySplit {
		t.Errorf("Kỳ vọng chuỗi giữ nguyên khi đã có dấu xuống dòng")
	}
}
