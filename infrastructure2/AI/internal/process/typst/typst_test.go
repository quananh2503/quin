package typst_test

import (
	"embed"
	"encoding/json"
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/AI/internal/process/typst"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

//go:embed testdata/fixtures/*
var fixtures embed.FS

func TestLaTeXToMiTeX_And_SplitStepLines(t *testing.T) {
	in := "Cho vectơ $\\vec{AB}$<br/>Độ dài: $$|\\vec{AB}| = 2$$"
	out := typst.LaTeXToMiTeX(in)
	if !strings.Contains(out, "#mi(`\\vec{AB}`)") {
		t.Errorf("inline mi missing: %s", out)
	}
	if !strings.Contains(out, "#mitex(`|\\vec{AB}| = 2`)") {
		t.Errorf("block mitex missing: %s", out)
	}

	// Odd '$' on a single line should be closed cleanly
	oddOut := typst.LaTeXToMiTeX("Giá trị $x = 1")
	if !strings.Contains(oddOut, "#mi(`x = 1`)") {
		t.Errorf("odd dollar line not healed: %s", oddOut)
	}

	steps := typst.SplitStepLines("Bước 1: Xác định gốc. Bước 2: Kết luận.")
	if steps != "Bước 1: Xác định gốc.\nBước 2: Kết luận." {
		t.Errorf("SplitStepLines = %q", steps)
	}
}

func TestRenderTopicTypst_And_AssembleToTypst_FromFixtures(t *testing.T) {
	topicBytes, err := fixtures.ReadFile("testdata/fixtures/topic_sample.json")
	if err != nil {
		t.Fatalf("read topic fixture: %v", err)
	}
	var tc raw.TopicContent
	if err := json.Unmarshal(topicBytes, &tc); err != nil {
		t.Fatalf("unmarshal topic fixture: %v", err)
	}

	planBytes, err := fixtures.ReadFile("testdata/fixtures/lesson_plan_sample.json")
	if err != nil {
		t.Fatalf("read plan fixture: %v", err)
	}
	var plan raw.LessonPlan
	if err := json.Unmarshal(planBytes, &plan); err != nil {
		t.Fatalf("unmarshal plan fixture: %v", err)
	}

	single := typst.RenderTopicTypst(tc)
	for _, want := range []string{"DẠNG TOÁN [T1]", "IS_TEACHER", "@ANCHOR:T1|theory|0", "BỘ KHUNG HÀNH ĐỘNG", "BẢNG ĐÁP ÁN"} {
		if !strings.Contains(single, want) {
			t.Errorf("RenderTopicTypst missing %q", want)
		}
	}

	tTyp, sTyp, err := typst.AssembleToTypst(plan, []raw.TopicContent{tc, {TopicID: "T2", Title: "Dạng 2"}})
	if err != nil {
		t.Fatalf("AssembleToTypst failed: %v", err)
	}
	if !strings.Contains(tTyp, "Bài 1: Vectơ trong không gian") || !strings.Contains(tTyp, "#pagebreak()") || sTyp == "" {
		t.Errorf("AssembleToTypst output missing header or pagebreak")
	}

	if _, _, errEmpty := typst.AssembleToTypst(plan, nil); errEmpty == nil {
		t.Fatal("expected error when contents is empty")
	}
}

func FuzzLaTeXToMiTeX(f *testing.F) {
	if b, err := fixtures.ReadFile("testdata/fixtures/topic_sample.json"); err == nil {
		f.Add(string(b))
	}
	f.Add("Cho $\\vec{a}$ và $$x^2 + y^2 = 1$$ <br> Bước 1: Tính. Bước 2: Xong.")
	f.Fuzz(func(t *testing.T, input string) {
		_ = typst.LaTeXToMiTeX(input)
		_ = typst.SplitStepLines(input)
	})
}
