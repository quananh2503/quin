package pipeline

import (
	"errors"
	"fmt"
	"regexp"
	"strings"

	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
)

var (
	htmlBrRegex     = regexp.MustCompile(`(?i)<br\s*/?>`)
	blockMathRegex  = regexp.MustCompile(`\$\$(.*?)\$\$`)
	inlineMathRegex = regexp.MustCompile(`\$([^\$]+)\$`)
	stepSplitRegex  = regexp.MustCompile(`(?i)([^\n])\s+((?:[-*]\s*)?bước\s*\d+[:.-])`)
)

// SplitStepLines chuẩn hoá tách các bước giải (Bước 1, Bước 2...) bị dồn trên 1 dòng thành các dòng riêng biệt
func SplitStepLines(text string) string {
	trimmed := strings.TrimSpace(text)
	if trimmed == "" {
		return ""
	}
	return stepSplitRegex.ReplaceAllString(trimmed, "$1\n$2")
}

// formatStepSolutionForTypst chuẩn hóa ngắt dòng các bước giải trong card ví dụ cho tài liệu Typst
func formatStepSolutionForTypst(sol string) string {
	sol = SplitStepLines(sol)
	sol = LaTeXToMiTeX(sol)
	lines := strings.Split(sol, "\n")
	var formatted []string
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

// LaTeXToMiTeX chuyển đổi các biểu thức toán kẹp trong $ hoặc $$ sang cú pháp của Typst MiTeX (#mi(...) và #mitex(...)).
func LaTeXToMiTeX(content string) string {
	content = strings.TrimSpace(content)
	if content == "" {
		return ""
	}

	// 0. Chuẩn hóa các thẻ HTML ngắt dòng sang dấu xuống dòng Typst
	content = htmlBrRegex.ReplaceAllString(content, " \\ ")

	// 1. Chuyển $$...$$ sang block mitex
	content = blockMathRegex.ReplaceAllStringFunc(content, func(m string) string {
		latex := strings.Trim(m, "$")
		return fmt.Sprintf("\n#align(center)[#mitex(`%s`)]\n", strings.TrimSpace(latex))
	})

	// 2. Vá nhanh từng dòng độc lập nếu số lượng $ trên dòng đó bị lẻ (đảm bảo $ không bao giờ tràn qua dòng mới)
	lines := strings.Split(content, "\n")
	for i, line := range lines {
		if strings.Count(line, "$")%2 != 0 {
			lines[i] = line + "$"
		}
	}
	content = strings.Join(lines, "\n")

	// 3. Chuyển $...$ nội dòng sang inline mi(`...`)
	content = inlineMathRegex.ReplaceAllStringFunc(content, func(m string) string {
		latex := strings.Trim(m, "$")
		latex = strings.TrimSpace(latex)
		if latex == "" {
			return ""
		}
		// Làm sạch triệt để dấu xuống dòng vô tình lọt vào chuỗi inline math
		latex = strings.ReplaceAll(latex, "\n", " ")

		return fmt.Sprintf(" #mi(`%s`) ", latex)
	})

	// Escape các ký tự đặc biệt Typst nếu còn sót ngoài toán
	content = strings.ReplaceAll(content, "$", `\$`)
	return content
}

// DefaultAssembler triển khai Assembler interface.
// Nhiệm vụ: Ghép tất cả các mảnh nội dung đã biên soạn thành Domain Lesson Entity và tài liệu dàn trang Typst.
type DefaultAssembler struct{}

// NewAssembler khởi tạo DefaultAssembler.
func NewAssembler() *DefaultAssembler {
	return &DefaultAssembler{}
}

// AssembleToLesson chuyển đổi dữ liệu từ AI Pipeline thành Lesson Entity của domain,
// bao gồm đầy đủ Lý thuyết, Mẹo giải nhanh/Casio, Bước giải chi tiết từng dạng và Bài tập rèn luyện.
func (a *DefaultAssembler) AssembleToLesson(plan *LessonPlan, contents []TopicContent, materials []lesson.StudyMaterial) (*lesson.Lesson, error) {
	if plan == nil {
		return nil, errors.New("lesson plan không được nil")
	}
	if strings.TrimSpace(plan.LessonTitle) == "" {
		return nil, errors.New("tiêu đề bài học (lesson title) không được để trống")
	}
	if len(contents) == 0 {
		return nil, errors.New("danh sách topic contents không được để trống")
	}
	if len(materials) == 0 {
		return nil, errors.New("danh sách tài liệu học tập (materials) không được để trống")
	}

	topics := make([]lesson.Topic, 0, len(contents))
	for _, tc := range contents {
		var blocks []lesson.Block

		// 1. Lý thuyết cốt lõi tối giản (TheoryPoints)
		if len(tc.TheoryPoints) > 0 {
			theoryText := strings.TrimSpace(strings.Join(tc.TheoryPoints, "\n"))
			if theoryText != "" {
				blocks = append(blocks, lesson.NewParagraphBlock(textToContent(theoryText)))
			}
		}

		// 2. Công thức then chốt (ClozeFormula)
		if strings.TrimSpace(tc.ClozeFormula) != "" {
			blocks = append(blocks, lesson.NewFormulaBlock(tc.ClozeFormula))
		}

		// 3. Khẩu quyết cốt lõi chung của dạng (CalloutTip)
		if strings.TrimSpace(tc.CalloutTip) != "" {
			blocks = append(blocks, lesson.NewCalloutBlock(
				lesson.CalloutTip,
				textToContent("Mẹo giải nhanh & Khẩu quyết"),
				textToContent(tc.CalloutTip),
			))
		}

		// 4. Các biến thể phương pháp giải (Variants: Nhận diện, Mẹo Casio, Bước giải, Ví dụ)
		for vIdx, v := range tc.Variants {
			vTitle := strings.TrimSpace(v.VariantName)
			if vTitle == "" {
				vTitle = strings.TrimSpace(v.VariantID)
			}
			if vTitle == "" {
				vTitle = fmt.Sprintf("Biến thể %d", vIdx+1)
			}

			// 4.1. Dấu hiệu nhận biết biến thể (đảm bảo luôn có để Frontend trích xuất được variantName)
			recText := strings.TrimSpace(v.Recognition)
			if recText == "" {
				recText = "Áp dụng cho các bài toán thuộc dạng: " + vTitle
			}
			blocks = append(blocks, lesson.NewCalloutBlock(
				lesson.CalloutNote,
				textToContent("Dấu hiệu nhận biết - "+vTitle),
				textToContent(recText),
			))

			// 4.2. Mẹo giải nhanh & Casio thực chiến
			if strings.TrimSpace(v.QuickTip) != "" {
				blocks = append(blocks, lesson.NewCalloutBlock(
					lesson.CalloutTip,
					textToContent("Mẹo giải nhanh & Casio"),
					textToContent(v.QuickTip),
				))
			}

			// 4.3. Các bước giải chi tiết (ActionSteps)
			if len(v.ActionSteps) > 0 {
				stepItems := make([]sharekernel.Content, 0, len(v.ActionSteps))
				for _, step := range v.ActionSteps {
					stepStr := strings.TrimSpace(step)
					if stepStr != "" {
						stepItems = append(stepItems, textToContent(stepStr))
					}
				}
				if len(stepItems) > 0 {
					blocks = append(blocks, lesson.NewListBlock(true, stepItems))
				}
			}

			// 4.4. Ví dụ giải mẫu (Example)
			if strings.TrimSpace(v.Example.Problem) != "" {
				exTitle := strings.TrimSpace(v.Example.Title)
				if exTitle == "" {
					exTitle = "Ví dụ minh họa"
				}
				blocks = append(blocks, lesson.NewExampleBlock(
					textToContent(exTitle),
					textToContent(v.Example.Problem),
					textToContent(SplitStepLines(v.Example.Solution)),
					textToContent(v.Example.Explanation),
				))
			}
		}

		// 5. Tương thích ngược: Examples nằm ngoài Variants
		for _, ex := range tc.Examples {
			blocks = append(blocks, lesson.NewExampleBlock(
				textToContent(ex.Title),
				textToContent(ex.Problem),
				textToContent(SplitStepLines(ex.Solution)),
				textToContent(ex.Explanation),
			))
		}

		// 6. Bài tập rèn luyện (Exercises)
		var exercises []sharekernel.Exercise

		// 6.1. Thu thập Drills từ Variants
		for _, v := range tc.Variants {
			for _, d := range v.Drills {
				ex, errEx := buildExerciseFromDrill(tc.Title, d)
				if errEx != nil {
					return nil, fmt.Errorf("tạo bài tập drill từ variant '%s' thất bại: %w", v.VariantID, errEx)
				}
				exercises = append(exercises, ex)
			}
		}

		// 6.2. Thu thập ShortAnswers từ TopicContent (tương thích ngược)
		for _, s := range tc.ShortAnswers {
			rubric := textToContent(s.FinalNumber)
			if rubric.IsEmpty() {
				rubric = textToContent(s.Solution)
			}
			if rubric.IsEmpty() {
				rubric = textToContent("-")
			}
			part := sharekernel.NewEssayPart("a", textToContent(s.Prompt), textToContent(s.Solution), rubric)
			diag := sharekernel.NewDiagram(sharekernel.DiagramNone, "")
			ex, errEx := sharekernel.NewEssayExercise(tc.Title, "Thông hiểu", textToContent(s.Prompt), []sharekernel.EssayPart{part}, diag)
			if errEx != nil {
				return nil, fmt.Errorf("tạo bài tập trả lời ngắn thất bại: %w", errEx)
			}
			exercises = append(exercises, ex)
		}

		// 6.3. Thu thập Drills ngoài Variants (tương thích ngược)
		for _, d := range tc.Drills {
			ex, errEx := buildExerciseFromDrill(tc.Title, d)
			if errEx != nil {
				return nil, fmt.Errorf("tạo bài tập tự luyện ngoài variant thất bại: %w", errEx)
			}
			exercises = append(exercises, ex)
		}

		// 7. Tạo Topic
		topTitle := strings.TrimSpace(tc.Title)
		if tc.TopicID != "" && !strings.HasPrefix(topTitle, tc.TopicID) {
			topTitle = fmt.Sprintf("[%s] %s", tc.TopicID, topTitle)
		}
		top, errTop := lesson.NewTopic(textToContent(topTitle), blocks, exercises)
		if errTop != nil {
			return nil, fmt.Errorf("tạo topic '%s' thất bại: %w", tc.TopicID, errTop)
		}
		topics = append(topics, top)
	}

	section, errSec := lesson.NewSection(textToContent("Nội Dung Chuyên Đề & Dạng Bài"), topics)
	if errSec != nil {
		return nil, fmt.Errorf("tạo section bài giảng thất bại: %w", errSec)
	}

	lsn, errLsn := lesson.NewLesson(
		textToContent(plan.LessonTitle),
		textToContent(plan.Overview),
		[]lesson.Section{section},
		materials,
	)
	if errLsn != nil {
		return nil, fmt.Errorf("tạo lesson entity thất bại: %w", errLsn)
	}

	return lsn, nil
}

func buildExerciseFromDrill(topicTitle string, d DrillExercise) (sharekernel.Exercise, error) {
	promptContent := textToContent(d.Prompt)
	diag := sharekernel.NewDiagram(sharekernel.DiagramNone, "")
	diff := strings.TrimSpace(d.Level)
	if diff == "" {
		diff = "Vận dụng"
	}

	rubric := textToContent(d.Solution)
	if rubric.IsEmpty() {
		rubric = textToContent(d.Answer)
	}
	if rubric.IsEmpty() {
		rubric = textToContent("-")
	}

	part := sharekernel.NewEssayPart(
		"a",
		promptContent,
		textToContent(d.Solution),
		rubric,
	)
	return sharekernel.NewEssayExercise(topicTitle, diff, promptContent, []sharekernel.EssayPart{part}, diag)
}

// RenderTopicTypst chuyển một TopicContent thành tài liệu Typst hoàn chỉnh hỗ trợ cờ IS_TEACHER.
func RenderTopicTypst(tc *TopicContent) string {
	if tc == nil {
		return ""
	}

	var sb strings.Builder

	// 1. Header & Prelude Typst
	sb.WriteString(`#import "@preview/mitex:0.2.7": mitex, mi` + "\n\n")
	sb.WriteString(`#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"` + "\n\n")
	sb.WriteString(`#set page(paper: "a4", margin: (x: 1.5cm, y: 1.5cm))` + "\n")
	sb.WriteString(`#set text(font: "New Computer Modern", size: 10.5pt, lang: "vi")` + "\n")
	sb.WriteString(`#set par(justify: true, leading: 0.75em)` + "\n\n")

	// Định nghĩa các khối giao diện chuẩn
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

	// 2. Tiêu đề chuyên đề
	diff := tc.Difficulty
	if diff == "" {
		diff = "Cơ bản - Trọng tâm"
	}
	sb.WriteString(fmt.Sprintf(`#align(center)[
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
`, tc.TopicID, LaTeXToMiTeX(tc.Title), LaTeXToMiTeX(diff)))

	// 3. Phần I: Lý thuyết cốt lõi tối giản
	if len(tc.TheoryPoints) > 0 || tc.ClozeFormula != "" || tc.CalloutTip != "" {
		sb.WriteString(`#block-box(
  title: "I. LÝ THUYẾT NỀN TẢNG CỐT LÕI (Dành cho học sinh mất gốc)",
  stroke-color: rgb("#2563eb"),
  fill-color: rgb("#eff6ff")
)[` + "\n")
		for tpIdx, tp := range tc.TheoryPoints {
			sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|theory|%d\n  - %s\n", tc.TopicID, tpIdx, LaTeXToMiTeX(tp)))
		}
		if tc.ClozeFormula != "" {
			sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|cloze\n  - *Công thức then chốt:* %s\n", tc.TopicID, LaTeXToMiTeX(tc.ClozeFormula)))
		}
		if tc.CalloutTip != "" {
			sb.WriteString(fmt.Sprintf(`// @ANCHOR:%s|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] %s
  ]
`, tc.TopicID, LaTeXToMiTeX(tc.CalloutTip)))
		}
		sb.WriteString("]\n\n#v(10pt)\n\n")
	}

	// 4. Phần II: Các biến thể bài toán thực chiến
	if len(tc.Variants) > 0 {
		sb.WriteString(`#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]` + "\n#v(6pt)\n\n")

		for vIdx, v := range tc.Variants {
			vTitle := v.VariantName
			if vTitle == "" {
				vTitle = fmt.Sprintf("Biến thể %d", vIdx+1)
			}
			vID := v.VariantID
			if vID == "" {
				vID = fmt.Sprintf("BT%d", vIdx+1)
			}

			sb.WriteString(fmt.Sprintf(`// ==================== BIẾN THỂ %d ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[%s] %s]
#v(3pt)
`, vIdx+1, vID, LaTeXToMiTeX(vTitle)))

			// Box khung hành động
			sb.WriteString(`#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[` + "\n")

			if v.Recognition != "" {
				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|v|%d|rec\n  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*\n  %s\n\n", tc.TopicID, vIdx, LaTeXToMiTeX(v.Recognition)))
			}

			if len(v.ActionSteps) > 0 {
				sb.WriteString("  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*\n")
				for sIdx, step := range v.ActionSteps {
					stepText := strings.TrimSpace(step)
					if !strings.HasPrefix(strings.ToLower(stepText), "bước") {
						sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|v|%d|step|%d\n  - *Bước %d:* %s\n", tc.TopicID, vIdx, sIdx, sIdx+1, LaTeXToMiTeX(stepText)))
					} else {
						sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|v|%d|step|%d\n  - %s\n", tc.TopicID, vIdx, sIdx, LaTeXToMiTeX(stepText)))
					}
				}
			}

			if v.QuickTip != "" {
				sb.WriteString(fmt.Sprintf(`// @ANCHOR:%s|v|%d|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] %s
  ]
`, tc.TopicID, vIdx, LaTeXToMiTeX(v.QuickTip)))
			}

			sb.WriteString("]\n#v(6pt)\n\n")

			// Ví dụ mẫu minh họa (luôn hiển thị lời giải mẫu cho cả giáo viên và học sinh)
			if v.Example.Problem != "" {
				exTitle := v.Example.Title
				if exTitle == "" {
					exTitle = fmt.Sprintf("Ví dụ minh họa cho %s", vID)
				}
				sb.WriteString(fmt.Sprintf(`// @ANCHOR:%s|v|%d|ex_prob
#example-card(title: "%s")[
  %s

  #v(4pt)
  #text(weight: "bold", fill: rgb("#15803d"))[Lời giải mẫu theo đúng các bước hành động trên:]
  \ #v(2pt)
// @ANCHOR:%s|v|%d|ex_sol
  %s
]
#v(8pt)
`, tc.TopicID, vIdx, LaTeXToMiTeX(exTitle), LaTeXToMiTeX(v.Example.Problem), tc.TopicID, vIdx, formatStepSolutionForTypst(v.Example.Solution)))
			}

			// Bài tập rèn luyện tương tự
			if len(v.Drills) > 0 {
				sb.WriteString(fmt.Sprintf(`*Bài tập rèn luyện tương tự cho %s (Luyện phản xạ cơ bắp):*`+"\n", vID))
				for dIdx, dr := range v.Drills {
					drTitle := dr.Title
					if drTitle == "" {
						drTitle = fmt.Sprintf("Bài %d.%d", vIdx+1, dIdx+1)
					}
					sb.WriteString(fmt.Sprintf(`// @ANCHOR:%s|v|%d|drill|%d|prompt
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
`, tc.TopicID, vIdx, dIdx, drTitle, LaTeXToMiTeX(dr.Prompt), tc.TopicID, vIdx, dIdx, LaTeXToMiTeX(dr.Solution), dr.Answer, LaTeXToMiTeX(dr.Answer)))
				}
				sb.WriteString("#v(8pt)\n\n")
			}
		}
	}

	// 5. Phần III: Bảng đáp án & hướng dẫn vắn tắt cuối bài
	if len(tc.AnswerKey) > 0 {
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
			sb.WriteString(fmt.Sprintf("  [%s], [%s], [%s],\n",
				LaTeXToMiTeX(ans.DrillID), LaTeXToMiTeX(ans.ShortGuide), LaTeXToMiTeX(ans.FinalAnswer)))
		}
		sb.WriteString(")\n")
	}

	return sb.String()
}

// AssembleToTypst tạo mã tài liệu Typst hoàn chỉnh cho bản Giáo viên và Học sinh từ toàn bộ TopicContent.
func (a *DefaultAssembler) AssembleToTypst(plan *LessonPlan, contents []TopicContent) (string, string, error) {
	if len(contents) == 0 {
		return "", "", fmt.Errorf("danh sách TopicContent rỗng")
	}

	// Trường hợp có 1 topic (biên soạn đơn lẻ)
	if len(contents) == 1 {
		typstRaw := RenderTopicTypst(&contents[0])
		return typstRaw, typstRaw, nil
	}

	// Ghép toàn bộ các topic
	var sb strings.Builder
	sb.WriteString(`#import "@preview/mitex:0.2.7": mitex, mi` + "\n\n")
	sb.WriteString(`#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"` + "\n\n")
	sb.WriteString(`#set page(paper: "a4", margin: (x: 1.5cm, y: 1.5cm))` + "\n")
	sb.WriteString(`#set text(font: "New Computer Modern", size: 10.5pt, lang: "vi")` + "\n")
	sb.WriteString(`#set par(justify: true, leading: 0.75em)` + "\n\n")

	// Helpers
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

	lessonTitle := "TÀI LIỆU BÀI GIẢNG TOÁN THPT"
	overview := ""
	if plan != nil {
		if plan.LessonTitle != "" {
			lessonTitle = plan.LessonTitle
		}
		overview = plan.Overview
	}

	sb.WriteString(fmt.Sprintf(`#align(center)[
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
`, LaTeXToMiTeX(lessonTitle), LaTeXToMiTeX(overview)))

	for idx := range contents {
		if idx > 0 {
			sb.WriteString("\n#pagebreak()\n\n")
		}
		topicBody := RenderTopicTypst(&contents[idx])
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
			sb.WriteString(strings.Join(filtered, "\n"))
		} else {
			sb.WriteString(topicBody)
		}
	}

	typstMarkup := sb.String()
	return typstMarkup, typstMarkup, nil
}

// FindNearestAnchor quét ngược từ vị trí dòng báo lỗi lên trên để tìm thẻ @ANCHOR gần nhất.
func FindNearestAnchor(lines []string, errLine int) string {
	if errLine <= 0 {
		return ""
	}
	startIdx := errLine - 1
	if startIdx >= len(lines) {
		startIdx = len(lines) - 1
	}
	for i := startIdx; i >= 0; i-- {
		trimmed := strings.TrimSpace(lines[i])
		if strings.HasPrefix(trimmed, "// @ANCHOR:") {
			return strings.TrimSpace(strings.TrimPrefix(trimmed, "// @ANCHOR:"))
		}
	}
	return ""
}
