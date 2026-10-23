package gemini

import (
	"fmt"
	"strings"
)

// =============================================================================
// DOCUMENT ASSEMBLER: LẮP GHÉP MÃ TYPST, ĐĂNG KÝ SLOT VÀ LẬP SOURCEMAP
// =============================================================================

// DocumentAssembler interface chuyển đổi dữ liệu bài học sang mã Typst và xây dựng SourceMap song song
type DocumentAssembler interface {
	Assemble(plan *LessonPlan, workers []WorkerResult) (*AssembleResult, error)
}

// DefaultDocumentAssembler chuyển đổi dữ liệu bài học sang mã Typst
type DefaultDocumentAssembler struct{}

// NewDefaultDocumentAssembler khởi tạo assembler mặc định
func NewDefaultDocumentAssembler() *DefaultDocumentAssembler {
	return &DefaultDocumentAssembler{}
}

// Assemble: Lắp ghép struct LessonPlan và []WorkerResult thành chuỗi mã Typst hoàn chỉnh.
// Đồng thời đăng ký mọi trường toán học vào SlotRegistry và ánh xạ số dòng vào SourceMap.
func (a *DefaultDocumentAssembler) Assemble(plan *LessonPlan, workers []WorkerResult) (*AssembleResult, error) {
	if plan == nil {
		return nil, fmt.Errorf("plan không được để trống")
	}

	registry := NewInMemorySlotRegistry()
	sourceMap := NewInMemorySourceMap()

	var sb strings.Builder
	currentLine := 1

	appendLine := func(line string, slotID string) {
		linesInText := strings.Count(line, "\n") + 1
		sb.WriteString(line)
		sb.WriteString("\n")
		if slotID != "" {
			for offset := 0; offset < linesInText; offset++ {
				sourceMap.MapLine(currentLine+offset, slotID)
			}
		}
		currentLine += linesInText
	}

	// 1. Prelude Typst (Gọn nhẹ, chỉ dùng MiTeX, không import CeTZ thừa)
	appendLine(`#import "@preview/mitex:0.2.7": mitex, mi`, "")
	appendLine(``, "")
	appendLine(`#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"`, "")
	appendLine(``, "")
	appendLine(`#set page(paper: "a4", margin: (x: 1.8cm, top: 1.6cm, bottom: 1.8cm))`, "")
	appendLine(`#set text(font: ("Arial", "Segoe UI", "DejaVu Sans", "Liberation Sans"), size: 10pt, lang: "vi")`, "")
	appendLine(`#set par(justify: true, leading: 0.72em)`, "")
	appendLine(``, "")

	// 2. Card Macro
	appendLine(`#let card(title: none, body) = block(fill: rgb("#f8fafc"), stroke: 1pt + rgb("#cbd5e1"), radius: 6pt, inset: 10pt, width: 100%, [`, "")
	appendLine(`  #if title != none [ #text(weight: "bold", size: 11.5pt, fill: rgb("#0f766e"))[#title] \ #v(2pt) ]`, "")
	appendLine(`  #body`, "")
	appendLine(`])`, "")
	appendLine(``, "")

	// 3. Header bài giảng
	appendLine(`#align(center)[`, "")
	appendLine(`  #if IS_TEACHER [`, "")
	appendLine(`    #text(size: 17pt, weight: "bold", fill: rgb("#1e3a8a"))[GIÁO ÁN GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)]`, "")
	appendLine(`  ] else [`, "")
	appendLine(`    #text(size: 17pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU BÀI TẬP HỌC SINH]`, "")
	appendLine(`  ]`, "")
	appendLine(`  \ #v(2pt)`, "")
	appendLine(fmt.Sprintf(`  #text(size: 13pt, weight: "bold")[%s] \`, LaTeXToMiTeX(plan.LessonTitle)), "")
	appendLine(fmt.Sprintf(`  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[%s]`, LaTeXToMiTeX(plan.Overview)), "")
	appendLine(`]`, "")
	appendLine(`#v(6pt)`, "")

	// 4. Duyệt qua từng Dạng toán
	for idx := range workers {
		w := &workers[idx]
		appendLine(fmt.Sprintf("\n// ==================== DẠNG %d: %s ====================", idx+1, w.Title), "")
		appendLine(fmt.Sprintf("#v(8pt)\n#text(size: 13pt, weight: \"bold\", fill: rgb(\"#1e3a8a\"))[Dạng %d. %s]\n#v(3pt)", idx+1, LaTeXToMiTeX(w.Title)), "")

		// Section I: Lý thuyết & Ghi nhớ
		appendLine(`#card(title: "I. Lý thuyết & Ghi nhớ")[`, "")
		for tIdx := range w.TheoryPoints {
			slotID := fmt.Sprintf("%s.theory.%d", w.TopicID, tIdx)
			registry.Register(slotID, fmt.Sprintf("Lý thuyết %d: %s", tIdx+1, w.Title), &w.TheoryPoints[tIdx])
			appendLine(fmt.Sprintf("  - %s", LaTeXToMiTeX(w.TheoryPoints[tIdx])), slotID)
		}
		if strings.TrimSpace(w.CalloutTip) != "" {
			slotID := fmt.Sprintf("%s.callout", w.TopicID)
			registry.Register(slotID, fmt.Sprintf("Mẹo giải nhanh: %s", w.Title), &w.CalloutTip)
			appendLine(fmt.Sprintf("  #v(4pt)\n  #block(fill: rgb(\"#f0fdf4\"), stroke: (left: 4pt + rgb(\"#22c55e\")), inset: 8pt, width: 100%%)[\n    #text(weight: \"bold\", fill: rgb(\"#15803d\"))[💡 Mẹo giải nhanh:] %s\n  ]", LaTeXToMiTeX(w.CalloutTip)), slotID)
		}
		if strings.TrimSpace(w.ClozeFormula) != "" {
			slotID := fmt.Sprintf("%s.cloze", w.TopicID)
			registry.Register(slotID, fmt.Sprintf("Công thức cốt lõi: %s", w.Title), &w.ClozeFormula)
			appendLine(fmt.Sprintf("  - *Công thức cốt lõi:* %s", LaTeXToMiTeX(w.ClozeFormula)), slotID)
		}
		appendLine(`]`, "")
		appendLine(`#v(4pt)`, "")

		// Section II: Trả lời ngắn
		if len(w.ShortAnswers) > 0 {
			appendLine(`#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[`, "")
			for sIdx := range w.ShortAnswers {
				sa := &w.ShortAnswers[sIdx]
				promptSlot := fmt.Sprintf("%s.sa.%d.prompt", w.TopicID, sIdx)
				numSlot := fmt.Sprintf("%s.sa.%d.final_number", w.TopicID, sIdx)
				solSlot := fmt.Sprintf("%s.sa.%d.solution", w.TopicID, sIdx)

				registry.Register(promptSlot, fmt.Sprintf("Trả lời ngắn %d - Đề bài", sIdx+1), &sa.Prompt)
				registry.Register(numSlot, fmt.Sprintf("Trả lời ngắn %d - Đáp số", sIdx+1), &sa.FinalNumber)
				registry.Register(solSlot, fmt.Sprintf("Trả lời ngắn %d - Lời giải", sIdx+1), &sa.Solution)

				appendLine(`  #block(width: 100%, breakable: false)[`, "")
				appendLine(fmt.Sprintf("    *Câu %d.* %s", sIdx+1, LaTeXToMiTeX(sa.Prompt)), promptSlot)
				appendLine(fmt.Sprintf("    #if IS_TEACHER [\n      #v(2pt)\n      #text(weight: \"bold\", fill: rgb(\"#15803d\"))[Đáp số: %s]", FormatFinalNumber(sa.FinalNumber)), numSlot)
				appendLine(fmt.Sprintf("      \\ #text(fill: rgb(\"#334155\"))[Lời giải: %s]\n    ] else [\n      #v(3pt)\n      #align(right)[#rect(stroke: 1pt + rgb(\"#0369a1\"), radius: 3pt, inset: (x: 12pt, y: 6pt))[\n        #text(size: 9pt, weight: \"bold\", fill: rgb(\"#0369a1\"))[Đáp số: ..............]\n      ]]\n    ]\n  ]\n  #v(6pt)", LaTeXToMiTeX(sa.Solution)), solSlot)
			}
			appendLine(`]`, "")
			appendLine(`#v(4pt)`, "")
		}

		// Section III: Ví dụ minh họa
		if len(w.Examples) > 0 {
			appendLine(`#card(title: "III. Ví dụ minh họa giải mẫu")[`, "")
			for eIdx := range w.Examples {
				ex := &w.Examples[eIdx]
				probSlot := fmt.Sprintf("%s.ex.%d.problem", w.TopicID, eIdx)
				solSlot := fmt.Sprintf("%s.ex.%d.solution", w.TopicID, eIdx)

				registry.Register(probSlot, fmt.Sprintf("Ví dụ %d (%s) - Đề bài", eIdx+1, ex.Title), &ex.Problem)
				registry.Register(solSlot, fmt.Sprintf("Ví dụ %d (%s) - Lời giải", eIdx+1, ex.Title), &ex.Solution)

				appendLine(fmt.Sprintf("  #block(fill: rgb(\"#f1f5f9\"), stroke: 1pt + rgb(\"#cbd5e1\"), inset: 8pt, radius: 4pt, width: 100%%)[\n    #text(weight: \"bold\", fill: rgb(\"#0369a1\"))[%s:] %s", LaTeXToMiTeX(ex.Title), LaTeXToMiTeX(ex.Problem)), probSlot)
				appendLine(fmt.Sprintf("    #if IS_TEACHER [\n      \\ #v(3pt) #text(weight: \"bold\", fill: rgb(\"#15803d\"))[Lời giải:] %s\n    ] else [ \\ #v(16pt) ]\n  ]", LaTeXToMiTeX(ex.Solution)), solSlot)
			}
			appendLine(`]`, "")
			appendLine(`#v(4pt)`, "")
		}

		// Section IV: Bài tập tự luyện
		if len(w.Drills) > 0 {
			appendLine(`#card(title: "IV. Bài tập tự luyện")[`, "")
			for dIdx := range w.Drills {
				dr := &w.Drills[dIdx]
				titleStr := strings.TrimSpace(dr.Title)
				if titleStr == "" {
					titleStr = fmt.Sprintf("Bài %d", dIdx+1)
				}
				promptSlot := fmt.Sprintf("%s.drill.%d.prompt", w.TopicID, dIdx)
				solSlot := fmt.Sprintf("%s.drill.%d.solution", w.TopicID, dIdx)

				registry.Register(promptSlot, fmt.Sprintf("Drill %d (%s) - Đề bài", dIdx+1, titleStr), &dr.Prompt)
				registry.Register(solSlot, fmt.Sprintf("Drill %d (%s) - Lời giải", dIdx+1, titleStr), &dr.Solution)

				teacherTitle := LaTeXToMiTeX(strings.TrimSuffix(titleStr, "."))
				studentTitle := fmt.Sprintf("Bài %d", dIdx+1)
				appendLine(fmt.Sprintf("  #if IS_TEACHER [*%s.*] else [*%s.*] %s", teacherTitle, studentTitle, LaTeXToMiTeX(dr.Prompt)), promptSlot)
				appendLine(fmt.Sprintf("    #if IS_TEACHER [\n      #v(2pt) #text(fill: rgb(\"#15803d\"))[→ Lời giải: %s] \\\n    ] else [\n      #v(2pt)\n      #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 6pt, height: 50pt, width: 100%%)[\n        #text(size: 8.5pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm:]\n      ]\n    ]", LaTeXToMiTeX(dr.Solution)), solSlot)
			}
			appendLine(`]`, "")
			appendLine(`#v(6pt)`, "")
		}
	}

	return &AssembleResult{
		Markup:    sb.String(),
		SourceMap: sourceMap,
		Registry:  registry,
	}, nil
}
