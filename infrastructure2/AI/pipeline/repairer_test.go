package pipeline_test

import (
	"context"
	"errors"
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/AI/pipeline"
)

func TestAuditMathField(t *testing.T) {
	tests := []struct {
		name       string
		input      string
		wantOK     bool
		wantReason string
	}{
		{
			name:   "Chuỗi rỗng hợp lệ",
			input:  "   ",
			wantOK: true,
		},
		{
			name:   "Chuỗi toán học chuẩn kẹp trong $",
			input:  "Cho hình chóp $S.ABCD$ có đáy là hình vuông cạnh $a$.",
			wantOK: true,
		},
		{
			name:       "Chứa mã ASCII rác FormFeed",
			input:      "Cho tam giác \f ABC",
			wantOK:     false,
			wantReason: "Dính mã điều khiển ASCII rác",
		},
		{
			name:       "Chứa mã ASCII rác Backspace",
			input:      "Cho tam giác \b ABC",
			wantOK:     false,
			wantReason: "Dính mã điều khiển ASCII rác",
		},
		{
			name:       "Số lượng dấu $ bị lẻ",
			input:      "Phương trình $x^2 + 2x = 0 và $y = 1$",
			wantOK:     false,
			wantReason: "Số lượng dấu $ bị lẻ",
		},
		{
			name:       "Lệnh LaTeX trần ngoài dấu $ (vec)",
			input:      "Xác định \\vec{AB} trong không gian",
			wantOK:     false,
			wantReason: "Chứa lệnh LaTeX trần ngoài dấu $",
		},
		{
			name:       "Lệnh LaTeX trần ngoài dấu $ (frac)",
			input:      "Tỉ số \\frac{1}{2} của đoạn thẳng",
			wantOK:     false,
			wantReason: "Chứa lệnh LaTeX trần ngoài dấu $",
		},
		{
			name:   "Lệnh LaTeX bên trong cặp dấu $ hợp lệ",
			input:  "Xác định $\\vec{AB}$ và tỉ số $\\frac{1}{2}$ trong không gian",
			wantOK: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			ok, reason := pipeline.AuditMathField(tt.input)
			if ok != tt.wantOK {
				t.Errorf("AuditMathField(%q) ok = %v, want %v (reason: %s)", tt.input, ok, tt.wantOK, reason)
			}
			if !tt.wantOK && !strings.Contains(reason, tt.wantReason) {
				t.Errorf("AuditMathField(%q) reason = %q, want substring %q", tt.input, reason, tt.wantReason)
			}
		})
	}
}

func TestFallbackSanitizeLaTeX(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected string
	}{
		{
			name:     "Chuẩn hóa các biến thể vectơ lạ về vec",
			input:    `\vecvec{a} + \overline{AB} + \textvec{u} + \bar{v} + \b{w}`,
			expected: `\vec{a} + \vec{AB} + \vec{u} + \vec{v} + \vec{w}`,
		},
		{
			name:     "Escape dấu # và dấu _ ngoài toán",
			input:    "Dạng #1: Tìm toạ_độ điểm $M(x_0; y_0)$",
			expected: `Dạng \#1: Tìm toạ\_độ điểm $M(x_0; y_0)$`,
		},
		{
			name:     "Cân bằng dấu $ bị lẻ",
			input:    "Giá trị của $x = 10",
			expected: "Giá trị của $x = 10$",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			res := pipeline.FallbackSanitizeLaTeX(tt.input)
			if res != tt.expected {
				t.Errorf("FallbackSanitizeLaTeX() = %q, want %q", res, tt.expected)
			}
		})
	}
}

func TestAuditTopicContent(t *testing.T) {
	// 1. TopicContent hoàn toàn hợp lệ
	validTC := &pipeline.TopicContent{
		TopicID:      "T1",
		Title:        "Dạng 1: Khái niệm vectơ",
		TheoryPoints: []string{"Vectơ là đoạn thẳng có hướng $A, B$."},
		ClozeFormula: "Công thức $\\vec{AB} = -\\vec{BA}$.",
		CalloutTip:   "Nhớ kỹ: Hai vectơ bằng nhau khi cùng hướng và cùng độ dài.",
		Variants: []pipeline.VariantGuide{
			{
				VariantID:   "V1",
				Recognition: "Đề bài cho hình chóp $S.ABCD$.",
				ActionSteps: []string{"Bước 1: Xác định điểm đầu và cuối."},
				QuickTip:    "Đếm các cạnh của đa diện.",
				Example: pipeline.ExampleItem{
					Problem:  "Cho tứ diện $ABCD$.",
					Solution: "Có tất cả $12$ vectơ khác vectơ-không.",
				},
				Drills: []pipeline.DrillExercise{
					{
						Prompt:   "Cho hình lập phương $ABCD.A'B'C'D'$.",
						Solution: "Các vectơ bằng nhau gồm $\\vec{AB} = \\vec{DC}$.",
					},
				},
			},
		},
		AnswerKey: []pipeline.AnswerItem{
			{
				DrillID:     "V1.1",
				FinalAnswer: "$12$",
				ShortGuide:  "Đếm các cạnh có hướng.",
			},
		},
	}

	tasksValid := pipeline.AuditTopicContent(validTC)
	if len(tasksValid) != 0 {
		t.Errorf("AuditTopicContent(validTC) phát hiện %d lỗi không đáng có: %+v", len(tasksValid), tasksValid)
	}

	// 2. TopicContent chứa các lỗi cú pháp rải rác
	brokenTC := &pipeline.TopicContent{
		TopicID:      "T1",
		Title:        "Dạng 1",
		TheoryPoints: []string{"Lỗi dính \\vec{a} ngoài toán"},
		ClozeFormula: "Lỗi dính lẻ dollar $x + 1",
		CalloutTip:   "Dính ASCII \f rác",
		Variants: []pipeline.VariantGuide{
			{
				VariantID:   "V1",
				Recognition: "Lỗi rec \\frac{1}{2}",
				ActionSteps: []string{"Lỗi step $a + b"},
				QuickTip:    "Lỗi tip \\bar{x}",
				Example: pipeline.ExampleItem{
					Problem:  "Lỗi ex_prob $p",
					Solution: "Lỗi ex_sol \\sqrt{2}",
				},
				Drills: []pipeline.DrillExercise{
					{
						Prompt:   "Lỗi drill_prompt $d",
						Solution: "Lỗi drill_sol \\Delta",
					},
				},
			},
		},
		AnswerKey: []pipeline.AnswerItem{
			{
				DrillID:     "V1.1",
				FinalAnswer: "Lỗi ans_final $ans",
				ShortGuide:  "Lỗi ans_guide \\times",
			},
		},
	}

	tasksBroken := pipeline.AuditTopicContent(brokenTC)
	if len(tasksBroken) < 10 {
		t.Errorf("AuditTopicContent(brokenTC) = %d tasks, kỳ vọng >= 10 tasks", len(tasksBroken))
	}

	// Kiểm tra các TargetID sinh ra đúng định dạng
	for _, task := range tasksBroken {
		if !strings.HasPrefix(task.TargetID, "T1|") {
			t.Errorf("TargetID %q không có prefix 'T1|'", task.TargetID)
		}
	}
}

func TestContextField_ExtractAndSet(t *testing.T) {
	tc := &pipeline.TopicContent{
		TopicID:      "T1",
		TheoryPoints: []string{"Gốc Theory 0", "Gốc Theory 1"},
		ClozeFormula: "Gốc Cloze",
		CalloutTip:   "Gốc Callout",
		Variants: []pipeline.VariantGuide{
			{
				VariantID:   "V1",
				Recognition: "Gốc Rec",
				ActionSteps: []string{"Gốc Step 0", "Gốc Step 1"},
				QuickTip:    "Gốc Tip",
				Example: pipeline.ExampleItem{
					Problem:  "Gốc Problem",
					Solution: "Gốc Solution",
				},
				Drills: []pipeline.DrillExercise{
					{
						Prompt:   "Gốc Prompt",
						Solution: "Gốc Solution Drill",
					},
				},
			},
		},
	}

	// 1. Kiểm tra Theory
	pipeline.SetContextField(tc, "T1|theory|0", "Fixed Theory 0")
	if tc.TheoryPoints[0] != "Fixed Theory 0" {
		t.Errorf("SetContextField theory failed: %v", tc.TheoryPoints[0])
	}
	if val := pipeline.ExtractContextField(tc, "T1|theory|0"); val != "Fixed Theory 0" {
		t.Errorf("ExtractContextField theory failed: %v", val)
	}

	// 2. Kiểm tra Cloze
	pipeline.SetContextField(tc, "T1|cloze", "Fixed Cloze")
	if tc.ClozeFormula != "Fixed Cloze" {
		t.Errorf("SetContextField cloze failed: %v", tc.ClozeFormula)
	}
	if val := pipeline.ExtractContextField(tc, "T1|cloze"); val != "Fixed Cloze" {
		t.Errorf("ExtractContextField cloze failed: %v", val)
	}

	// 3. Kiểm tra Callout
	pipeline.SetContextField(tc, "T1|callout", "Fixed Callout")
	if tc.CalloutTip != "Fixed Callout" {
		t.Errorf("SetContextField callout failed: %v", tc.CalloutTip)
	}

	// 4. Kiểm tra Variants: rec, step, tip, ex_prob, ex_sol, drill prompt, drill sol
	pipeline.SetContextField(tc, "T1|v|0|rec", "Fixed Rec")
	if tc.Variants[0].Recognition != "Fixed Rec" {
		t.Errorf("SetContextField rec failed")
	}

	pipeline.SetContextField(tc, "T1|v|0|step|1", "Fixed Step 1")
	if tc.Variants[0].ActionSteps[1] != "Fixed Step 1" {
		t.Errorf("SetContextField step failed")
	}

	pipeline.SetContextField(tc, "T1|v|0|tip", "Fixed Tip")
	if tc.Variants[0].QuickTip != "Fixed Tip" {
		t.Errorf("SetContextField tip failed")
	}

	pipeline.SetContextField(tc, "T1|v|0|ex_prob", "Fixed Prob")
	if tc.Variants[0].Example.Problem != "Fixed Prob" {
		t.Errorf("SetContextField ex_prob failed")
	}

	pipeline.SetContextField(tc, "T1|v|0|ex_sol", "Fixed Sol")
	if tc.Variants[0].Example.Solution != "Fixed Sol" {
		t.Errorf("SetContextField ex_sol failed")
	}

	pipeline.SetContextField(tc, "T1|v|0|drill|0|prompt", "Fixed Drill Prompt")
	if tc.Variants[0].Drills[0].Prompt != "Fixed Drill Prompt" {
		t.Errorf("SetContextField drill prompt failed")
	}

	pipeline.SetContextField(tc, "T1|v|0|drill|0|sol", "Fixed Drill Sol")
	if tc.Variants[0].Drills[0].Solution != "Fixed Drill Sol" {
		t.Errorf("SetContextField drill sol failed")
	}

	// Kiểm tra các trường hợp targetID không hợp lệ hoặc out of bounds (không panic)
	pipeline.SetContextField(tc, "T1|theory|999", "Out of bounds")
	pipeline.SetContextField(tc, "T1|v|999|rec", "Out of bounds")
	pipeline.SetContextField(tc, "invalid", "Invalid")
	pipeline.SetContextField(nil, "T1|cloze", "Nil TC")

	if val := pipeline.ExtractContextField(tc, "T1|theory|999"); val != "" {
		t.Errorf("ExtractContextField out of bounds should return empty, got %q", val)
	}
	if val := pipeline.ExtractContextField(nil, "T1|cloze"); val != "" {
		t.Errorf("ExtractContextField nil should return empty, got %q", val)
	}
}

func TestExtractCompilerErrorAnchors(t *testing.T) {
	markup := `#let x = 1
// @ANCHOR:T1|theory|0
#text[Lý thuyết]
// @ANCHOR:T1|v|0|rec
#text[Nhận diện dạng toán]
`
	tc := &pipeline.TopicContent{
		TopicID:      "T1",
		TheoryPoints: []string{"Điểm lý thuyết 1"},
		Variants: []pipeline.VariantGuide{
			{
				VariantID:   "V1",
				Recognition: "Dấu hiệu nhận diện 1",
			},
		},
	}

	stderr := `error: unknown variable
  ┌─ test.typ:5:10
  │
5 │ #text[Nhận diện dạng toán]
  │       ^^^^^^^^
`

	tasks := pipeline.ExtractCompilerErrorAnchors(markup, stderr, tc)
	if len(tasks) != 1 {
		t.Fatalf("ExtractCompilerErrorAnchors returned %d tasks, want 1", len(tasks))
	}

	if tasks[0].TargetID != "T1|v|0|rec" {
		t.Errorf("TargetID = %q, want 'T1|v|0|rec'", tasks[0].TargetID)
	}
	if tasks[0].Content != "Dấu hiệu nhận diện 1" {
		t.Errorf("Content = %q, want 'Dấu hiệu nhận diện 1'", tasks[0].Content)
	}
}

func TestDefaultRepairer_RepairMath_OfflineFallback(t *testing.T) {
	repairer := pipeline.NewRepairer(nil, "")

	tasks := []pipeline.RepairTask{
		{
			TargetID: "T1|v|0|tip",
			Content:  `Mẹo: \vecvec{AB} có \#1 cách giải`,
		},
	}

	repaired, err := repairer.RepairMath(context.Background(), tasks)
	if err != nil {
		t.Fatalf("RepairMath returned unexpected error: %v", err)
	}
	if len(repaired) != 1 {
		t.Fatalf("repaired length = %d, want 1", len(repaired))
	}

	if !strings.Contains(repaired[0].FixedContent, `\vec{AB}`) {
		t.Errorf("FixedContent did not replace \\vecvec: %s", repaired[0].FixedContent)
	}
	if !strings.Contains(repaired[0].FixedContent, `\#1`) {
		t.Errorf("FixedContent did not escape #: %s", repaired[0].FixedContent)
	}
}

func TestDefaultRepairer_RepairMath_WithMockProvider(t *testing.T) {
	ctx := context.Background()

	// 1. Mock provider trả về JSON thành công
	mockSuccess := &mockAIProvider{
		responseContent: `{
				"repaired_items": [
					{
						"target_id": "T1|theory|0",
						"fixed_content": "Vectơ $\\vec{a}$ và $\\vec{b}$."
					}
				]
			}`,
	}

	repairerSuccess := pipeline.NewRepairer(mockSuccess, "deepseek-flash")
	tasks := []pipeline.RepairTask{
		{
			TargetID: "T1|theory|0",
			Content:  "Vectơ \\vec{a} và \\vec{b}.",
		},
	}

	repaired, err := repairerSuccess.RepairMath(ctx, tasks)
	if err != nil {
		t.Fatalf("RepairMath failed: %v", err)
	}
	if len(repaired) != 1 || repaired[0].FixedContent != "Vectơ $\\vec{a}$ và $\\vec{b}$." {
		t.Errorf("RepairMath output mismatch: %+v", repaired)
	}

	// 2. Mock provider trả về lỗi -> kích hoạt FallbackSanitizeLaTeX
	mockErr := &mockAIProvider{
		err: errors.New("network timeout"),
	}
	repairerErr := pipeline.NewRepairer(mockErr, "deepseek-flash")
	tasksFallback := []pipeline.RepairTask{
		{
			TargetID: "T1|theory|0",
			Content:  `Vectơ \vecvec{a}`,
		},
	}

	repairedFallback, errFB := repairerErr.RepairMath(ctx, tasksFallback)
	if errFB != nil {
		t.Fatalf("RepairMath fallback failed: %v", errFB)
	}
	if len(repairedFallback) != 1 || !strings.Contains(repairedFallback[0].FixedContent, `\vec{a}`) {
		t.Errorf("RepairMath fallback did not fix vecvec: %+v", repairedFallback)
	}
}

func TestDefaultRepairer_RepairSyntax(t *testing.T) {
	repairer := pipeline.NewRepairer(nil, "")
	raw := `Công thức \vecvec{x} và #2`
	fixed, err := repairer.RepairSyntax(context.Background(), raw, []string{"syntax error"})
	if err != nil {
		t.Fatalf("RepairSyntax failed: %v", err)
	}
	if !strings.Contains(fixed, `\vec{x}`) || !strings.Contains(fixed, `\#2`) {
		t.Errorf("RepairSyntax output unexpected: %s", fixed)
	}
}

func TestDefaultRepairer_SelfHealCompile_NilTC(t *testing.T) {
	repairer := pipeline.NewRepairer(nil, "")
	err := repairer.SelfHealCompile(context.Background(), nil, "typst", "test.typ", "test.pdf", false, 3)
	if err == nil {
		t.Error("SelfHealCompile with nil tc should return error, got nil")
	}
}
