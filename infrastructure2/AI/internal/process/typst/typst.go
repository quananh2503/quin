package typst

import (
	"errors"
	"fmt"
	"regexp"
	"strings"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

var (
	htmlBrRegex     = regexp.MustCompile(`(?i)<br\s*/?>`)
	blockMathRegex  = regexp.MustCompile(`(?s)\$\$(.*?)\$\$`)
	inlineMathRegex = regexp.MustCompile(`\$([^\$]+)\$`)
	stepSplitRegex  = regexp.MustCompile(`(?i)([^\n])\s+((?:[-*]\s*)?bước\s*\d+[:.-])`)
)

// LaTeXToMiTeX converts $...$ and $$...$$ LaTeX math into Typst MiTeX #mi(...) and #mitex(...) calls.
func LaTeXToMiTeX(content string) string {
	content = strings.TrimSpace(content)
	if content == "" {
		return ""
	}

	content = htmlBrRegex.ReplaceAllString(content, " \\ ")
	content = blockMathRegex.ReplaceAllStringFunc(content, func(m string) string {
		latex := strings.TrimSpace(strings.Trim(m, "$"))
		return fmt.Sprintf("\n#align(center)[#mitex(%#q)]\n", latex)
	})

	lines := strings.Split(content, "\n")
	for i, line := range lines {
		if strings.Count(line, "$")%2 != 0 {
			lines[i] = line + "$"
		}
	}
	content = strings.Join(lines, "\n")

	content = inlineMathRegex.ReplaceAllStringFunc(content, func(m string) string {
		latex := strings.TrimSpace(strings.Trim(m, "$"))
		if latex == "" {
			return ""
		}
		latex = strings.ReplaceAll(latex, "\n", " ")
		return fmt.Sprintf(" #mi(%#q) ", latex)
	})

	return strings.ReplaceAll(content, "$", `\$`)
}

// SplitStepLines splits inline "Bước 1: ... Bước 2: ..." sequences onto separate lines.
func SplitStepLines(text string) string {
	trimmed := strings.TrimSpace(text)
	if trimmed == "" {
		return ""
	}
	return stepSplitRegex.ReplaceAllString(trimmed, "$1\n$2")
}

// RenderTopicTypst renders a single TopicContent into a standalone Typst document with IS_TEACHER support.
func RenderTopicTypst(tc raw.TopicContent) string {
	var sb strings.Builder
	writePrelude(&sb)
	writeTopicHeader(&sb, &tc)
	writeTheorySection(&sb, &tc)
	writeVariantsSection(&sb, &tc)
	writeAnswerKeySection(&sb, &tc)
	return sb.String()
}

// AssembleToTypst combines LessonPlan metadata and TopicContent items into teacher and student Typst documents.
func AssembleToTypst(plan raw.LessonPlan, contents []raw.TopicContent) (teacherTypst, studentTypst string, err error) {
	if len(contents) == 0 {
		return "", "", errors.New("danh sách TopicContent rỗng")
	}
	if len(contents) == 1 {
		single := RenderTopicTypst(contents[0])
		return single, single, nil
	}

	var sb strings.Builder
	writePrelude(&sb)
	writeLessonHeader(&sb, &plan)

	for idx := range contents {
		if idx > 0 {
			sb.WriteString("\n#pagebreak()\n\n")
		}
		sb.WriteString(stripTopicPrelude(RenderTopicTypst(contents[idx])))
	}

	markup := sb.String()
	return markup, markup, nil
}

func writePrelude(sb *strings.Builder) {
	sb.WriteString(`#import "@preview/mitex:0.2.7": mitex, mi` + "\n\n")
	sb.WriteString(`#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"` + "\n\n")
	sb.WriteString(`#set page(paper: "a4", margin: (x: 1.5cm, y: 1.5cm))` + "\n")
	sb.WriteString(`#set text(font: "New Computer Modern", size: 10.5pt, lang: "vi")` + "\n")
	sb.WriteString(`#set par(justify: true, leading: 0.75em)` + "\n\n")
	sb.WriteString(`#let block-box(title: none, stroke-color: rgb("#3b82f6"), fill-color: rgb("#eff6ff"), body) = block(
  fill: fill-color,
  stroke: 1pt + stroke-color,
  radius: 6pt,
  inset: 11pt,
  width: 100%,
  breakable: true,
  [
    #if title != none [
      #text(weight: "bold", size: 11pt, fill: stroke-color.darken(20%))[#title]
      #v(3pt)
      #line(length: 100%, stroke: 0.5pt + stroke-color.lighten(40%))
      #v(4pt)
    ]
    #body
  ]
)` + "\n\n")
	sb.WriteString(`#let tip-box(body) = block(
  fill: rgb("#fffbeb"),
  stroke: (left: 4pt + rgb("#f59e0b")),
  inset: (x: 10pt, y: 7pt),
  radius: (right: 4pt),
  width: 100%,
  [
    #body
  ]
)` + "\n\n")
	sb.WriteString(`#let example-card(title: none, body) = block(
  fill: rgb("#ffffff"),
  stroke: 1pt + rgb("#cbd5e1"),
  radius: 6pt,
  inset: 10pt,
  width: 100%,
  breakable: true,
  [
    #if title != none [
      #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[#title]
      #v(3pt)
      #line(length: 100%, stroke: 0.5pt + rgb("#e2e8f0"))
      #v(4pt)
    ]
    #body
  ]
)` + "\n\n")
}

func writeLessonHeader(sb *strings.Builder, plan *raw.LessonPlan) {
	lessonTitle := strings.TrimSpace(plan.LessonTitle)
	if lessonTitle == "" {
		lessonTitle = "TÀI LIỆU BÀI GIẢNG TOÁN THPT"
	}
	fmt.Fprintf(sb, `#align(center)[
  #if IS_TEACHER [
    #text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[GIÁO ÁN GIẢNG DẠY & ĐÁP ÁN CHI TIẾT (GIÁO VIÊN)]
  ] else [
    #text(size: 13pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU BÀI TẬP VÀ RÈN LUYỆN (HỌC SINH)]
  ]
  \ #v(2pt)
  #text(size: 17pt, weight: "bold", fill: rgb("#b91c1c"))[%s] \
  #v(2pt)
  #text(size: 10pt, style: "italic", fill: rgb("#475569"))[%s]
]

#v(10pt)
`, LaTeXToMiTeX(lessonTitle), LaTeXToMiTeX(plan.Overview))
}

func writeTopicHeader(sb *strings.Builder, tc *raw.TopicContent) {
	diff := tc.Difficulty
	if diff == "" {
		diff = "Cơ bản - Trọng tâm"
	}
	fmt.Fprintf(sb, `#align(center)[
  #if IS_TEACHER [
    #text(size: 11pt, weight: "bold", fill: rgb("#1e3a8a"))[TÀI LIỆU GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)]
  ] else [
    #text(size: 11pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU HỌC TẬP & RÈN LUYỆN (HỌC SINH)]
  ]
  \ #v(2pt)
  #text(size: 16pt, weight: "bold", fill: rgb("#b91c1c"))[DẠNG TOÁN [%s]: %s] \
  #v(2pt)
  #text(size: 10.5pt, style: "italic", fill: rgb("#475569"))[(Mức độ: %s - Thiết kế sư phạm cho học sinh mất gốc)]
]

#v(8pt)
`, tc.TopicID, LaTeXToMiTeX(tc.Title), LaTeXToMiTeX(diff))
}

func writeTheorySection(sb *strings.Builder, tc *raw.TopicContent) {
	if len(tc.TheoryPoints) == 0 && tc.ClozeFormula == "" && tc.CalloutTip == "" {
		return
	}
	sb.WriteString(`#block-box(
  title: "I. LÝ THUYẾT NỀN TẢNG CỐT LÕI (Dành cho học sinh mất gốc)",
  stroke-color: rgb("#2563eb"),
  fill-color: rgb("#eff6ff")
)[` + "\n")
	for tpIdx, tp := range tc.TheoryPoints {
		fmt.Fprintf(sb, "// @ANCHOR:%s|theory|%d\n  - %s\n", tc.TopicID, tpIdx, LaTeXToMiTeX(tp))
	}
	if tc.ClozeFormula != "" {
		fmt.Fprintf(sb, "// @ANCHOR:%s|cloze\n  - *Công thức then chốt:* %s\n", tc.TopicID, LaTeXToMiTeX(tc.ClozeFormula))
	}
	if tc.CalloutTip != "" {
		fmt.Fprintf(sb, `// @ANCHOR:%s|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] %s
  ]
`, tc.TopicID, LaTeXToMiTeX(tc.CalloutTip))
	}
	sb.WriteString("]\n\n#v(10pt)\n\n")
}

func writeVariantsSection(sb *strings.Builder, tc *raw.TopicContent) {
	if len(tc.Variants) == 0 {
		return
	}
	sb.WriteString(`#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]` + "\n#v(6pt)\n\n")
	for vIdx := range tc.Variants {
		writeSingleVariant(sb, tc.TopicID, vIdx, &tc.Variants[vIdx])
	}
}

func writeSingleVariant(sb *strings.Builder, topicID string, vIdx int, v *raw.VariantGuide) {
	vTitle := v.VariantName
	if vTitle == "" {
		vTitle = fmt.Sprintf("Biến thể %d", vIdx+1)
	}
	vID := v.VariantID
	if vID == "" {
		vID = fmt.Sprintf("BT%d", vIdx+1)
	}

	fmt.Fprintf(sb, "// ==================== BIẾN THỂ %d ====================\n#text(size: 11.5pt, weight: \"bold\", fill: rgb(\"#0f766e\"))[[%s] %s]\n#v(3pt)\n",
		vIdx+1, vID, LaTeXToMiTeX(vTitle))
	writeVariantActionBox(sb, topicID, vIdx, v)
	writeVariantExample(sb, topicID, vIdx, vID, &v.Example)
	writeVariantDrills(sb, topicID, vIdx, vID, v.Drills)
}

func writeVariantActionBox(sb *strings.Builder, topicID string, vIdx int, v *raw.VariantGuide) {
	sb.WriteString(`#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[` + "\n")
	if v.Recognition != "" {
		fmt.Fprintf(sb, "// @ANCHOR:%s|v|%d|rec\n  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*\n  %s\n\n",
			topicID, vIdx, LaTeXToMiTeX(v.Recognition))
	}
	if len(v.ActionSteps) > 0 {
		sb.WriteString("  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*\n")
		for sIdx, step := range v.ActionSteps {
			stepText := strings.TrimSpace(step)
			if !strings.HasPrefix(strings.ToLower(stepText), "bước") {
				fmt.Fprintf(sb, "// @ANCHOR:%s|v|%d|step|%d\n  - *Bước %d:* %s\n", topicID, vIdx, sIdx, sIdx+1, LaTeXToMiTeX(stepText))
			} else {
				fmt.Fprintf(sb, "// @ANCHOR:%s|v|%d|step|%d\n  - %s\n", topicID, vIdx, sIdx, LaTeXToMiTeX(stepText))
			}
		}
	}
	if v.QuickTip != "" {
		fmt.Fprintf(sb, `// @ANCHOR:%s|v|%d|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] %s
  ]
`, topicID, vIdx, LaTeXToMiTeX(v.QuickTip))
	}
	sb.WriteString("]\n#v(6pt)\n\n")
}

func writeVariantExample(sb *strings.Builder, topicID string, vIdx int, vID string, ex *raw.ExampleItem) {
	if ex.Problem == "" {
		return
	}
	exTitle := ex.Title
	if exTitle == "" {
		exTitle = fmt.Sprintf("Ví dụ minh họa cho %s", vID)
	}
	fmt.Fprintf(sb, `// @ANCHOR:%s|v|%d|ex_prob
#example-card(title: "%s")[
  %s

  #v(4pt)
  #text(weight: "bold", fill: rgb("#15803d"))[Lời giải mẫu theo đúng các bước hành động trên:]
  \ #v(2pt)
// @ANCHOR:%s|v|%d|ex_sol
  %s
]
#v(8pt)
`, topicID, vIdx, LaTeXToMiTeX(exTitle), LaTeXToMiTeX(ex.Problem), topicID, vIdx, formatStepSolutionForTypst(ex.Solution))
}

func writeVariantDrills(sb *strings.Builder, topicID string, vIdx int, vID string, drills []raw.DrillExercise) {
	if len(drills) == 0 {
		return
	}
	fmt.Fprintf(sb, "*Bài tập rèn luyện tương tự cho %s (Luyện phản xạ cơ bắp):*\n", vID)
	for dIdx, dr := range drills {
		drTitle := dr.Title
		if drTitle == "" {
			drTitle = fmt.Sprintf("Bài %d.%d", vIdx+1, dIdx+1)
		}
		fmt.Fprintf(sb, `// @ANCHOR:%s|v|%d|drill|%d|prompt
*Bài %s.* %s
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:%s|v|%d|drill|%d|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[%s]
    #if "%s" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: %s] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
`, topicID, vIdx, dIdx, drTitle, LaTeXToMiTeX(dr.Prompt), topicID, vIdx, dIdx, LaTeXToMiTeX(dr.Solution), dr.Answer, LaTeXToMiTeX(dr.Answer))
	}
	sb.WriteString("#v(8pt)\n\n")
}

func writeAnswerKeySection(sb *strings.Builder, tc *raw.TopicContent) {
	if len(tc.AnswerKey) == 0 {
		return
	}
	sb.WriteString(`#text(size: 11pt, weight: "bold", fill: rgb("#b91c1c"))[III. BẢNG ĐÁP ÁN VÀ HƯỚNG DẪN VẮN TẮT]` + "\n#v(4pt)\n\n")
	sb.WriteString(`#table(
  columns: (50pt, 1fr, 80pt),
  align: (center + horizon, left + horizon, center + horizon),
  fill: (col, row) => if row == 0 { rgb("#e0f2fe") } else if calc.even(row) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  table.header(
    [*Bài*], [*Hướng dẫn giải vắn tắt*], [*Đáp án*]
  ),` + "\n")
	for _, ans := range tc.AnswerKey {
		fmt.Fprintf(sb, "  [%s], [%s], [%s],\n",
			LaTeXToMiTeX(ans.DrillID), LaTeXToMiTeX(ans.ShortGuide), LaTeXToMiTeX(ans.FinalAnswer))
	}
	sb.WriteString(")\n")
}

func formatStepSolutionForTypst(sol string) string {
	sol = SplitStepLines(sol)
	sol = LaTeXToMiTeX(sol)
	lines := strings.Split(sol, "\n")
	formatted := make([]string, 0, len(lines))
	for _, l := range lines {
		trimmed := strings.TrimSpace(l)
		if trimmed != "" {
			trimmed = strings.TrimRight(trimmed, "\\ ")
			formatted = append(formatted, trimmed)
		}
	}
	if len(formatted) <= 1 {
		return sol
	}
	return strings.Join(formatted, " \\ \n")
}

func stripTopicPrelude(topicBody string) string {
	lines := strings.Split(topicBody, "\n")
	filtered := make([]string, 0, len(lines))
	skipHeader := true
	for _, l := range lines {
		if strings.HasPrefix(l, "#align(center)[") {
			skipHeader = false
		}
		if !skipHeader {
			filtered = append(filtered, l)
		}
	}
	if len(filtered) > 0 {
		return strings.Join(filtered, "\n")
	}
	return topicBody
}
