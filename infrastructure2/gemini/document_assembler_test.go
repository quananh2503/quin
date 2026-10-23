package gemini_test

import (
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"
)

func Test_DefaultDocumentAssembler_Assemble(t *testing.T) {
	assembler := gemini.NewDefaultDocumentAssembler()

	plan := &gemini.LessonPlan{
		LessonTitle: "Bài 1. Vectơ trong không gian",
		Overview:    "Tổng quan kiến thức định nghĩa và phép toán vectơ",
		Topics: []gemini.Topic{
			{TopicID: "dang_1", Title: "Quy tắc cộng và trừ vectơ"},
		},
	}

	workers := []gemini.WorkerResult{
		{
			TopicID:      "dang_1",
			Title:        "Quy tắc cộng và trừ vectơ",
			TheoryPoints: []string{"Quy tắc ba điểm: $\\vec{AB} + \\vec{BC} = \\vec{AC}$."},
			CalloutTip:   "Khẩu quyết: Điểm cuối trùng điểm đầu thì cộng dồn.",
			ClozeFormula: "Công thức: $\\vec{AB} + \\dots = \\vec{AC}$",
			ShortAnswers: []gemini.ShortAnswerExercise{
				{Prompt: "Tính độ dài vectơ $\\vec{a}$", FinalNumber: "5", Solution: "Ta có $|\\vec{a}| = 5$"},
			},
			Examples: []gemini.ExampleItem{
				{Title: "Ví dụ 1", Problem: "Cho tứ diện $ABCD$...", Solution: "Áp dụng định nghĩa..."},
			},
			Drills: []gemini.DrillExercise{
				{Title: "Bài 1 (Chuẩn mẫu)", Prompt: "Cho hình hộp $ABCD.A'B'C'D'$...", Solution: "Lời giải chi tiết..."},
			},
		},
	}

	res, err := assembler.Assemble(plan, workers)
	if err != nil {
		t.Fatalf("Assemble thất bại: %v", err)
	}

	// 1. Kiểm tra Typst Markup sinh ra
	if !strings.Contains(res.Markup, "#import \"@preview/mitex:0.2.7\": mitex, mi") {
		t.Errorf("Markup thiếu import MiTeX")
	}
	if !strings.Contains(res.Markup, "Bài 1. Vectơ trong không gian") {
		t.Errorf("Markup thiếu tiêu đề bài học")
	}
	if !strings.Contains(res.Markup, "Quy tắc cộng và trừ vectơ") {
		t.Errorf("Markup thiếu tên dạng toán")
	}
	if !strings.Contains(res.Markup, "#if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*]") {
		t.Errorf("Markup thiếu logic phân tách tiêu đề bài tập cho Giáo viên và Học sinh")
	}

	// 2. Kiểm tra SlotRegistry đã đăng ký đầy đủ các con trỏ
	if res.Registry.Size() < 7 {
		t.Errorf("Kỳ vọng đăng ký ít nhất 7 slots (theory, callout, cloze, prompt, num, sol, ex, drill) nhưng có %d", res.Registry.Size())
	}

	// 3. Kiểm tra SourceMap đã ánh xạ dòng
	foundSlotInSM := false
	for line := 1; line < 100; line++ {
		if id, ok := res.SourceMap.GetSlotIDByLine(line); ok && strings.HasPrefix(id, "dang_1") {
			foundSlotInSM = true
			break
		}
	}
	if !foundSlotInSM {
		t.Errorf("SourceMap không ghi nhận bất kỳ ánh xạ dòng nào cho dang_1")
	}

	t.Logf("✅ DocumentAssembler: Lắp ráp thành công %d ký tự Typst, %d slots bộ nhớ và SourceMap hợp lệ!",
		len(res.Markup), res.Registry.Size())
}
