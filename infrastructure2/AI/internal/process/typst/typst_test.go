package typst_test

import (
	"bytes"
	"embed"
	"encoding/json"
	"strings"
	"testing"

	"goa/pkg/cmdvcr"

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
	if typst.LaTeXToMiTeX("   ") != "" || typst.SplitStepLines("   ") != "" {
		t.Error("blank inputs must return empty string")
	}
	if got := typst.LaTeXToMiTeX("A $   $ B"); strings.Contains(got, "#mi(") {
		t.Errorf("empty inline math should be stripped, got %q", got)
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
	if !strings.Contains(tTyp, "Bài 1: Vectơ trong không gian") || sTyp != tTyp {
		t.Errorf("AssembleToTypst output missing header or teacher/student mismatch")
	}
	if strings.Count(tTyp, "#pagebreak()") != 1 {
		t.Errorf("expected exactly 1 #pagebreak() for 2 topics, got %d", strings.Count(tTyp, "#pagebreak()"))
	}
	if strings.Count(tTyp, `#import "@preview/mitex:0.2.7"`) != 1 {
		t.Errorf("expected prelude stripped from per-topic bodies, got %d imports", strings.Count(tTyp, `#import "@preview/mitex:0.2.7"`))
	}
	if !strings.Contains(tTyp, "Mức độ: Cơ bản - Trọng tâm") {
		t.Errorf("expected default Difficulty fallback on T2")
	}

	if _, _, errEmpty := typst.AssembleToTypst(plan, nil); errEmpty == nil {
		t.Fatal("expected error when contents is empty")
	}
}

func TestRenderTopicTypst_OptionalSectionsAndDefaults(t *testing.T) {
	minimal := typst.RenderTopicTypst(raw.TopicContent{TopicID: "T_MIN", Title: "Tối giản", Difficulty: "Vận dụng"})
	for _, forbidden := range []string{"I. LÝ THUYẾT", "Công thức then chốt", "Khẩu quyết cốt lõi", "II. CÁC BIẾN THỂ", "III. BẢNG ĐÁP ÁN", "#example-card"} {
		if strings.Contains(minimal, forbidden) {
			t.Errorf("minimal topic must not contain %q", forbidden)
		}
	}
	if !strings.Contains(minimal, "Mức độ: Vận dụng") {
		t.Errorf("expected explicit Difficulty in header")
	}

	theoryOnly := typst.RenderTopicTypst(raw.TopicContent{
		TopicID:      "T_TH",
		Title:        "Chỉ lý thuyết",
		TheoryPoints: []string{"Điểm 1"},
		Variants: []raw.VariantGuide{
			{
				ActionSteps: []string{"Xác định công thức", "Bước 2: Thay số"},
				Example:     raw.ExampleItem{Problem: "Giải $x=1$", Solution: "Bước 1: Ghi. Bước 2: Xong."},
				Drills:      []raw.DrillExercise{{Prompt: "Tính $1+1$", Solution: "$2$", Answer: "2"}},
			},
			{Recognition: "Chỉ có nhận diện"},
		},
	})
	for _, want := range []string{
		"I. LÝ THUYẾT", "[BT1] Biến thể 1", "- *Bước 1:* Xác định công thức", "- Bước 2: Thay số",
		"Ví dụ minh họa cho BT1", " \\ \n", "*Bài Bài 1.1.*", "1. Dấu hiệu nhận diện",
	} {
		if !strings.Contains(theoryOnly, want) {
			t.Errorf("theoryOnly missing %q", want)
		}
	}
	for _, forbidden := range []string{"Công thức then chốt", "Khẩu quyết cốt lõi", "Mẹo & Phản xạ nhanh"} {
		if strings.Contains(theoryOnly, forbidden) {
			t.Errorf("theoryOnly must not contain %q", forbidden)
		}
	}
}

func TestAssembleToTypst_SingleAndFallbackTitle(t *testing.T) {
	single := raw.TopicContent{TopicID: "T1", Title: "Một dạng"}
	t1, s1, err := typst.AssembleToTypst(raw.LessonPlan{LessonTitle: "Ignored"}, []raw.TopicContent{single})
	if err != nil || t1 != s1 || !strings.Contains(t1, "DẠNG TOÁN [T1]") || strings.Contains(t1, "#pagebreak()") {
		t.Errorf("single-topic AssembleToTypst failed: err=%v", err)
	}

	t2, _, err := typst.AssembleToTypst(raw.LessonPlan{Overview: "Tóm tắt"}, []raw.TopicContent{single, {TopicID: "T2", Title: "Hai"}})
	if err != nil || !strings.Contains(t2, "TÀI LIỆU BÀI GIẢNG TOÁN THPT") {
		t.Errorf("expected fallback lesson title, err=%v", err)
	}
}

func TestTypstErrorCassette_ParseRealStderrInRAM(t *testing.T) {
	casBytes, err := fixtures.ReadFile("testdata/fixtures/cassettes/typst_error.yaml")
	if err != nil {
		t.Fatalf("read embedded typst_error cassette: %v", err)
	}
	cas, err := cmdvcr.Parse(bytes.NewReader(casBytes))
	if err != nil {
		t.Fatalf("parse typst_error cassette: %v", err)
	}
	if cas.Meta.Tool != "typst" || cas.Response.ExitCode != 1 {
		t.Fatalf("unexpected cassette meta/exit: tool=%q exit=%d", cas.Meta.Tool, cas.Response.ExitCode)
	}
	if !strings.Contains(cas.Response.Stderr, "broken.typ:5:") || !strings.Contains(cas.Response.Stderr, "unknown_typst_symbol") {
		t.Errorf("unexpected real typst stderr in cassette:\n%s", cas.Response.Stderr)
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
