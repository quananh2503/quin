package gemini

import (
	"context"
	"errors"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"

	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
)

// extractVariantName trích xuất tên định danh của biến thể từ tiêu đề dấu hiệu nhận biết hoặc đề ví dụ
// bằng string split thuần túy của Go, tuyệt đối không dùng Regex.
func extractVariantName(recTitle string, exTitle string, defaultIndex int) (variantName string, cleanRecPrefix string) {
	cleanRecPrefix = "Dấu hiệu nhận biết đặc trưng"
	recTitle = strings.TrimSpace(recTitle)
	exTitle = strings.TrimSpace(exTitle)

	if strings.Contains(recTitle, "-") {
		parts := strings.SplitN(recTitle, "-", 2)
		prefix := strings.TrimSpace(parts[0])
		name := strings.TrimSpace(parts[1])
		if prefix != "" {
			cleanRecPrefix = prefix
		}
		if name != "" {
			return name, cleanRecPrefix
		}
	}

	if strings.Contains(exTitle, "-") {
		parts := strings.SplitN(exTitle, "-", 2)
		name := strings.TrimSpace(parts[1])
		if name != "" {
			return name, cleanRecPrefix
		}
	}

	if recTitle != "" && !strings.EqualFold(recTitle, "dấu hiệu nhận biết") {
		return recTitle, cleanRecPrefix
	}

	return fmt.Sprintf("Dạng biến thể %d", defaultIndex), cleanRecPrefix
}

// formatTypstMultiline xử lý chuỗi văn bản nhiều dòng cho Typst bằng string split thuần túy (tuyệt đối không dùng regex):
// 1. Chuyển đổi literal \n thành xuống dòng thật
// 2. Tách từng dòng bằng strings.Split
// 3. Chuyển LaTeX sang MiTeX trên từng dòng
// 4. Nối lại bằng " \ \n" để Typst xuống dòng chính xác
func formatTypstMultiline(content string) string {
	content = strings.TrimSpace(content)
	if content == "" {
		return ""
	}
	content = strings.ReplaceAll(content, "\\n", "\n")
	lines := strings.Split(content, "\n")
	var cleanLines []string
	for _, line := range lines {
		trimmed := strings.TrimSpace(line)
		if trimmed != "" {
			cleanLines = append(cleanLines, LaTeXToMiTeX(trimmed))
		}
	}
	if len(cleanLines) == 0 {
		return ""
	}
	return strings.Join(cleanLines, " \\ \n")
}

// LessonTypstRenderer định nghĩa hợp đồng chuyển đổi trực tiếp một Domain Lesson Entity
// thành mã nguồn Typst hoàn chỉnh (hỗ trợ cả 2 chế độ IS_TEACHER = true và false).
type LessonTypstRenderer interface {
	Render(lsn *lesson.Lesson) (string, error)
}

// DefaultLessonTypstRenderer là hiện thực mặc định của LessonTypstRenderer.
type DefaultLessonTypstRenderer struct{}

// NewDefaultLessonTypstRenderer khởi tạo renderer từ Domain Lesson sang Typst.
func NewDefaultLessonTypstRenderer() *DefaultLessonTypstRenderer {
	return &DefaultLessonTypstRenderer{}
}

// Render chuyển đổi cấu trúc Lesson (Section, Topic, Blocks, Exercises) sang mã Typst
// với giao diện Card Layout, kế thừa cấu hình chuẩn mực của Pipeline.
func (r *DefaultLessonTypstRenderer) Render(lsn *lesson.Lesson) (string, error) {
	if lsn == nil {
		return "", errors.New("lesson không được nil")
	}

	var sb strings.Builder

	// 1. Sinh Prelude Typst: Sans-serif, size 9.5pt hiện đại, gọn gàng tương đồng với giao diện Web
	sb.WriteString(`#import "@preview/mitex:0.2.7": mitex, mi` + "\n")
	sb.WriteString(`#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"` + "\n")
	sb.WriteString(`#set page(paper: "a4", margin: (x: 1.5cm, top: 1.3cm, bottom: 1.4cm))` + "\n")
	sb.WriteString(`#set text(font: ("Liberation Sans", "DejaVu Sans", "Noto Sans"), size: 9.5pt, lang: "vi")` + "\n")
	sb.WriteString(`#set par(justify: true, leading: 0.6em)` + "\n")
	sb.WriteString(`#let card(title: none, body) = block(fill: rgb("#f8fafc"), stroke: 0.75pt + rgb("#cbd5e1"), radius: 4pt, inset: 7pt, width: 100%, breakable: true, [ #if title != none [ #block(sticky: true)[#text(weight: "bold", size: 9.5pt, fill: rgb("#0f766e"))[#title] \ #v(2pt)] ] #body ])` + "\n\n")

	// 2. Header bài giảng
	titleStr := formatTypstMultiline(lsn.Title().String())
	overviewStr := formatTypstMultiline(lsn.Overview().String())
	sb.WriteString(fmt.Sprintf("#align(center)[ #if IS_TEACHER [ #text(size: 13pt, weight: \"bold\", fill: rgb(\"#1e3a8a\"))[GIÁO ÁN GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)] ] else [ #text(size: 13pt, weight: \"bold\", fill: rgb(\"#0f766e\"))[PHIẾU BÀI TẬP HỌC SINH] ] \\ #v(2.5pt) #text(size: 11.5pt, weight: \"bold\", fill: rgb(\"#0f172a\"))[%s] \\ #v(1.5pt) #text(size: 8.5pt, style: \"italic\", fill: rgb(\"#475569\"))[%s] ]\n#v(4pt)\n", titleStr, overviewStr))

	// 3. Duyệt qua từng Section trong lsn.Sections() và từng Topic trong sec.Topics()
	for _, sec := range lsn.Sections() {
		for _, topic := range sec.Topics() {
			topicTitle := formatTypstMultiline(topic.Title().String())
			sb.WriteString(fmt.Sprintf("#v(5pt)\n#text(size: 11pt, weight: \"bold\", fill: rgb(\"#1e3a8a\"))[%s]\n#v(2pt)\n", topicTitle))

			// Phân loại blocks của Topic:
			// - Mục I Lý thuyết: Paragraph, Formula, và Core Tip chung (Khẩu quyết dạng toán)
			// - Mục II Biến thể & Ví dụ: Dấu hiệu nhận biết, Mẹo Casio, Các bước giải (List), và Ví dụ
			var theoryLines []string
			blocks := topic.Blocks()

			firstVariantIdx := -1
			for idx, blk := range blocks {
				if blk == nil {
					continue
				}
				if blk.BlockType() == lesson.BlockExample || blk.BlockType() == lesson.BlockList {
					firstVariantIdx = idx
					break
				}
				if cb, ok := blk.(lesson.CalloutBlock); ok {
					title := cb.Title().String()
					if strings.Contains(title, "Dấu hiệu") || strings.Contains(title, "Casio") || strings.Contains(title, "Biến thể") {
						firstVariantIdx = idx
						break
					}
				}
			}

			// Core Callout: Callout đầu tiên trước firstVariantIdx mà không chứa Dấu hiệu/Casio
			var coreCallout *lesson.CalloutBlock
			coreCalloutIdx := -1
			for idx, blk := range blocks {
				if blk == nil {
					continue
				}
				if cb, ok := blk.(lesson.CalloutBlock); ok {
					if firstVariantIdx == -1 || idx < firstVariantIdx {
						title := cb.Title().String()
						if !strings.Contains(title, "Dấu hiệu") && !strings.Contains(title, "Casio") {
							copyCb := cb
							coreCallout = &copyCb
							coreCalloutIdx = idx
							break
						}
					}
				}
			}

			// Gom lý thuyết cho Mục I
			for _, blk := range blocks {
				if blk == nil {
					continue
				}
				switch b := blk.(type) {
				case lesson.ParagraphBlock:
					body := strings.TrimSpace(b.Body().String())
					if body != "" {
						theoryLines = append(theoryLines, fmt.Sprintf("  - %s\n", formatTypstMultiline(body)))
					}
				case *lesson.ParagraphBlock:
					body := strings.TrimSpace(b.Body().String())
					if body != "" {
						theoryLines = append(theoryLines, fmt.Sprintf("  - %s\n", formatTypstMultiline(body)))
					}
				case lesson.FormulaBlock:
					mathStr := strings.TrimSpace(b.Math())
					if mathStr != "" && !strings.Contains(mathStr, "$") {
						mathStr = "$" + mathStr + "$"
					}
					theoryLines = append(theoryLines, fmt.Sprintf("  - *Công thức cốt lõi:* %s\n", LaTeXToMiTeX(mathStr)))
				case *lesson.FormulaBlock:
					mathStr := strings.TrimSpace(b.Math())
					if mathStr != "" && !strings.Contains(mathStr, "$") {
						mathStr = "$" + mathStr + "$"
					}
					theoryLines = append(theoryLines, fmt.Sprintf("  - *Công thức cốt lõi:* %s\n", LaTeXToMiTeX(mathStr)))
				default:
					if b.BlockType() == "definition" || b.BlockType() == "theorem" {
						if bodyer, ok := b.(interface{ Body() sharekernel.Content }); ok {
							body := strings.TrimSpace(bodyer.Body().String())
							if body != "" {
								theoryLines = append(theoryLines, fmt.Sprintf("  - %s\n", formatTypstMultiline(body)))
							}
						}
					}
				}
			}

			// Thêm đúng 1 thẻ Khẩu quyết cốt lõi chung vào Mục I (nếu có)
			if coreCallout != nil {
				calloutTitle := strings.TrimSpace(coreCallout.Title().String())
				calloutTitle = strings.TrimPrefix(calloutTitle, "💡")
				calloutTitle = strings.TrimSpace(calloutTitle)
				calloutTitle = strings.TrimSuffix(calloutTitle, ":")
				if calloutTitle == "" {
					calloutTitle = "Mẹo giải nhanh & Khẩu quyết"
				}
				calloutBody := strings.TrimSpace(coreCallout.Body().String())
				theoryLines = append(theoryLines, fmt.Sprintf("  #block(fill: rgb(\"#f0fdf4\"), stroke: (left: 3pt + rgb(\"#22c55e\")), inset: 5.5pt, radius: (right: 2pt), width: 100%%)[ #text(weight: \"bold\", size: 8.5pt, fill: rgb(\"#15803d\"))[💡 %s:] %s ]\n", formatTypstMultiline(calloutTitle), formatTypstMultiline(calloutBody)))
			}

			if len(theoryLines) > 0 {
				sb.WriteString("#card(title: \"I. Lý thuyết & Ghi nhớ\")[\n")
				for _, line := range theoryLines {
					sb.WriteString(line)
				}
				sb.WriteString("]\n#v(3pt)\n")
			}

			// 2. Gom nhóm các blocks cho Mục II (Biến thể & Ví dụ)
			type typstVariantGroup struct {
				recognition *lesson.CalloutBlock
				quickTip    *lesson.CalloutBlock
				actionList  *lesson.ListBlock
				example     *lesson.ExampleBlock
				otherBlocks []lesson.Block
			}

			var variantGroups []typstVariantGroup
			currentGroup := typstVariantGroup{}

			for idx, blk := range blocks {
				if blk == nil {
					continue
				}
				if blk.BlockType() == lesson.BlockParagraph || blk.BlockType() == lesson.BlockFormula || blk.BlockType() == "definition" || blk.BlockType() == "theorem" {
					continue
				}
				if coreCallout != nil && idx == coreCalloutIdx {
					continue
				}

				switch b := blk.(type) {
				case lesson.ExampleBlock:
					ex := b
					currentGroup.example = &ex
					variantGroups = append(variantGroups, currentGroup)
					currentGroup = typstVariantGroup{}
				case *lesson.ExampleBlock:
					currentGroup.example = b
					variantGroups = append(variantGroups, currentGroup)
					currentGroup = typstVariantGroup{}
				case lesson.ListBlock:
					lb := b
					currentGroup.actionList = &lb
				case *lesson.ListBlock:
					currentGroup.actionList = b
				case lesson.CalloutBlock:
					cb := b
					title := cb.Title().String()
					if strings.Contains(title, "Dấu hiệu") || cb.Kind() == lesson.CalloutNote {
						currentGroup.recognition = &cb
					} else if strings.Contains(title, "Casio") || strings.Contains(title, "Mẹo") || cb.Kind() == lesson.CalloutTip {
						currentGroup.quickTip = &cb
					} else {
						currentGroup.otherBlocks = append(currentGroup.otherBlocks, b)
					}
				case *lesson.CalloutBlock:
					title := b.Title().String()
					if strings.Contains(title, "Dấu hiệu") || b.Kind() == lesson.CalloutNote {
						currentGroup.recognition = b
					} else if strings.Contains(title, "Casio") || strings.Contains(title, "Mẹo") || b.Kind() == lesson.CalloutTip {
						currentGroup.quickTip = b
					} else {
						currentGroup.otherBlocks = append(currentGroup.otherBlocks, b)
					}
				default:
					currentGroup.otherBlocks = append(currentGroup.otherBlocks, b)
				}
			}

			if currentGroup.recognition != nil || currentGroup.quickTip != nil || currentGroup.actionList != nil || currentGroup.example != nil || len(currentGroup.otherBlocks) > 0 {
				variantGroups = append(variantGroups, currentGroup)
			}

			// Render Mục II: Các biến thể phương pháp giải & Ví dụ minh họa giải mẫu
			if len(variantGroups) > 0 {
				sb.WriteString("#card(title: \"II. Các biến thể & Ví dụ minh họa giải mẫu\")[\n")
				for idx, vg := range variantGroups {
					if idx > 0 {
						sb.WriteString("  #v(4.5pt)\n")
					}

					recRaw := ""
					if vg.recognition != nil {
						recRaw = vg.recognition.Title().String()
					}
					exRaw := ""
					if vg.example != nil {
						exRaw = vg.example.Title().String()
					}
					variantName, cleanRecPrefix := extractVariantName(recRaw, exRaw, idx+1)

					// Bọc mỗi biến thể trong block breakable: false để toàn bộ khối luôn đi liền nhau, không bị xẻ đôi
					sb.WriteString("  #block(fill: white, stroke: 0.5pt + rgb(\"#cbd5e1\"), inset: 6pt, radius: 3pt, width: 100%, breakable: false)[\n")

					// Header định danh Biến thể
					sb.WriteString(fmt.Sprintf("    #block(fill: rgb(\"#eff6ff\"), stroke: (left: 3pt + rgb(\"#2563eb\")), inset: (x: 5pt, y: 3pt), radius: (right: 2pt), width: 100%%)[ #text(weight: \"bold\", size: 8pt, fill: rgb(\"#1d4ed8\"))[BIẾN THỂ %d] #h(4pt) #text(weight: \"bold\", size: 9.5pt, fill: rgb(\"#0f172a\"))[%s] ]\n    #v(2pt)\n", idx+1, LaTeXToMiTeX(variantName)))

					// 1. Dấu hiệu nhận biết
					if vg.recognition != nil {
						recBody := strings.TrimSpace(vg.recognition.Body().String())
						sb.WriteString(fmt.Sprintf("    #block(fill: rgb(\"#f0f9ff\"), stroke: (left: 3pt + rgb(\"#0284c7\")), inset: 5pt, radius: (right: 2pt), width: 100%%)[ #text(weight: \"bold\", size: 8pt, fill: rgb(\"#0369a1\"))[🧭 %s:] %s ]\n    #v(2pt)\n", cleanRecPrefix, formatTypstMultiline(recBody)))
					}

					// 2. Mẹo giải nhanh & Casio
					if vg.quickTip != nil {
						tipTitle := strings.TrimSpace(vg.quickTip.Title().String())
						tipTitle = strings.TrimPrefix(tipTitle, "💡")
						tipTitle = strings.TrimSpace(tipTitle)
						tipTitle = strings.TrimSuffix(tipTitle, ":")
						if tipTitle == "" {
							tipTitle = "Mẹo giải nhanh & Casio"
						}
						tipBody := strings.TrimSpace(vg.quickTip.Body().String())
						sb.WriteString(fmt.Sprintf("    #block(fill: rgb(\"#fefce8\"), stroke: (left: 3pt + rgb(\"#eab308\")), inset: 5pt, radius: (right: 2pt), width: 100%%)[ #text(weight: \"bold\", size: 8pt, fill: rgb(\"#a16207\"))[💡 %s:] %s ]\n    #v(2pt)\n", formatTypstMultiline(tipTitle), formatTypstMultiline(tipBody)))
					}

					// 3. Các bước giải tuần tự (Grid 2 cột thẳng hàng, đẹp mắt)
					if vg.actionList != nil && len(vg.actionList.Items()) > 0 {
						sb.WriteString("    #block(fill: rgb(\"#f0fdf4\"), stroke: (left: 3pt + rgb(\"#059669\")), inset: 5pt, radius: (right: 2pt), width: 100%)[\n")
						sb.WriteString("      #text(weight: \"bold\", size: 8pt, fill: rgb(\"#065f46\"))[📋 CÁC BƯỚC GIẢI TUẦN TỰ:] \\ \n      #v(2pt)\n")
						var gridCells []string
						for sIdx, step := range vg.actionList.Items() {
							stepStr := strings.TrimSpace(step.String())
							if stepStr == "" {
								continue
							}
							label := fmt.Sprintf("Bước %d", sIdx+1)
							body := stepStr
							if colonIdx := strings.Index(stepStr, ":"); colonIdx != -1 && colonIdx <= 10 {
								prefix := strings.TrimSpace(stepStr[:colonIdx])
								if strings.HasPrefix(strings.ToLower(prefix), "bước") || strings.HasPrefix(strings.ToLower(prefix), "b") {
									label = prefix
									body = strings.TrimSpace(stepStr[colonIdx+1:])
								}
							}
							badge := fmt.Sprintf("[#box(fill: rgb(\"#dcfce7\"), stroke: 0.5pt + rgb(\"#86efac\"), inset: (x: 3.5pt, y: 1.5pt), radius: 2pt)[#text(weight: \"bold\", size: 7.5pt, fill: rgb(\"#065f46\"))[%s]]]", label)
							content := fmt.Sprintf("[#text(size: 8.5pt, fill: rgb(\"#1e293b\"))[%s]]", formatTypstMultiline(body))
							gridCells = append(gridCells, badge, content)
						}
						if len(gridCells) > 0 {
							sb.WriteString(fmt.Sprintf("      #grid(columns: (auto, 1fr), row-gutter: 2.5pt, column-gutter: 5pt, %s)\n", strings.Join(gridCells, ", ")))
						}
						sb.WriteString("    ]\n    #v(2.5pt)\n")
					}

					// 4. Ví dụ minh họa giải mẫu (hiển thị lời giải mẫu cho cả giáo viên và học sinh)
					if vg.example != nil {
						exTitle := strings.TrimSpace(vg.example.Title().String())
						exTitle = strings.TrimSuffix(exTitle, ":")
						if exTitle == "" {
							exTitle = "Ví dụ minh họa"
						}
						exProb := strings.TrimSpace(vg.example.Problem().String())
						exSol := strings.TrimSpace(vg.example.Solution().String())
						if exSol != "" {
							sb.WriteString(fmt.Sprintf("    #block(fill: rgb(\"#f8fafc\"), stroke: 0.5pt + rgb(\"#cbd5e1\"), inset: 6pt, radius: 3pt, width: 100%%)[\n      #text(weight: \"bold\", size: 8.5pt, fill: rgb(\"#0369a1\"))[%s] \\ \n      #v(1.5pt)\n      #text(size: 9pt, fill: rgb(\"#1e293b\"))[%s] \\ \n      #v(2.5pt)\n      #line(length: 100%%, stroke: 0.5pt + rgb(\"#e2e8f0\"))\n      #v(2.5pt)\n      #text(weight: \"bold\", size: 8pt, fill: rgb(\"#15803d\"))[Lời giải mẫu:] \\ \n      #v(1.5pt)\n      #text(size: 8.5pt, fill: rgb(\"#334155\"))[%s]\n    ]\n", formatTypstMultiline(exTitle), formatTypstMultiline(exProb), formatTypstMultiline(exSol)))
						} else {
							sb.WriteString(fmt.Sprintf("    #block(fill: rgb(\"#f8fafc\"), stroke: 0.5pt + rgb(\"#cbd5e1\"), inset: 6pt, radius: 3pt, width: 100%%)[\n      #text(weight: \"bold\", size: 8.5pt, fill: rgb(\"#0369a1\"))[%s] \\ \n      #v(1.5pt)\n      #text(size: 9pt, fill: rgb(\"#1e293b\"))[%s]\n    ]\n", formatTypstMultiline(exTitle), formatTypstMultiline(exProb)))
						}
					}

					sb.WriteString("  ]\n")
				}
				sb.WriteString("]\n#v(3pt)\n")
			}

			// Mục III: Bài tập rèn luyện
			exercises := topic.Exercises()
			if len(exercises) > 0 {
				sb.WriteString("#card(title: \"III. Bài tập rèn luyện\")[\n")
				for exIdx, rawEx := range exercises {
					if exIdx > 0 {
						sb.WriteString("  #v(4pt)\n")
					}
					exNum := exIdx + 1

					switch ex := rawEx.(type) {
					case sharekernel.MultipleChoiceExercise:
						r.renderMCQ(&sb, exNum, ex)
					case *sharekernel.MultipleChoiceExercise:
						r.renderMCQ(&sb, exNum, *ex)
					case sharekernel.EssayExercise:
						r.renderEssay(&sb, exNum, ex)
					case *sharekernel.EssayExercise:
						r.renderEssay(&sb, exNum, *ex)
					default:
						prompt := formatTypstMultiline(ex.Prompt().String())
						sb.WriteString(fmt.Sprintf("  #block(width: 100%%, breakable: false)[ #box(fill: rgb(\"#eff6ff\"), stroke: 0.5pt + rgb(\"#bfdbfe\"), inset: (x: 4pt, y: 1.5pt), radius: 2pt)[#text(weight: \"bold\", size: 8pt, fill: rgb(\"#1e3a8a\"))[Bài %d]] #h(3pt) #text(size: 9pt, fill: rgb(\"#1e293b\"))[%s] ]\n", exNum, prompt))
					}
				}
				sb.WriteString("]\n#v(3pt)\n")
			}
		}
	}

	return sb.String(), nil
}

func (r *DefaultLessonTypstRenderer) renderMCQ(sb *strings.Builder, exNum int, ex sharekernel.MultipleChoiceExercise) {
	prompt := formatTypstMultiline(ex.Prompt().String())

	sb.WriteString("  #block(width: 100%, breakable: false)[\n")
	sb.WriteString(fmt.Sprintf("    #box(fill: rgb(\"#eff6ff\"), stroke: 0.5pt + rgb(\"#bfdbfe\"), inset: (x: 4pt, y: 1.5pt), radius: 2pt)[#text(weight: \"bold\", size: 8pt, fill: rgb(\"#1e3a8a\"))[Bài %d]] #h(3pt) #text(size: 9pt, fill: rgb(\"#1e293b\"))[%s]\n", exNum, prompt))

	opts := ex.Options()
	if len(opts) > 0 {
		maxOptLen := 0
		for _, opt := range opts {
			if l := len([]rune(opt.Content().String())); l > maxOptLen {
				maxOptLen = l
			}
		}
		numCols := len(opts)
		if maxOptLen > 25 || numCols > 4 {
			numCols = 2
		}
		cols := make([]string, numCols)
		for i := range cols {
			cols[i] = "1fr"
		}
		colsStr := "(" + strings.Join(cols, ", ") + ")"
		var optCells []string
		for i, opt := range opts {
			lbl := strings.TrimSpace(opt.Label())
			if lbl == "" {
				lbl = string(rune('A' + i))
			}
			optText := strings.TrimSpace(opt.Content().String())
			prefix := lbl + "."
			if strings.HasPrefix(optText, prefix) {
				optText = strings.TrimSpace(strings.TrimPrefix(optText, prefix))
			}
			optCells = append(optCells, fmt.Sprintf("[*%s.* %s]", lbl, formatTypstMultiline(optText)))
		}
		sb.WriteString(fmt.Sprintf("    #v(2pt)\n    #grid(columns: %s, gutter: 5pt, %s)\n", colsStr, strings.Join(optCells, ", ")))
	}

	ans := strings.TrimSpace(ex.Answer())
	sol := formatTypstMultiline(ex.Solution().String())
	if sol != "" {
		if ans != "" {
			sb.WriteString(fmt.Sprintf("    #if IS_TEACHER [ #v(2pt) #text(weight: \"bold\", size: 8pt, fill: rgb(\"#15803d\"))[Đáp án: %s] \\ #v(1pt) #text(weight: \"bold\", size: 8pt, fill: rgb(\"#15803d\"))[Lời giải chi tiết:] \\ #text(size: 8.5pt, fill: rgb(\"#334155\"))[%s] ] else [ #v(2pt) #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 4.5pt, height: 26pt, width: 100%%)[ #text(size: 8pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm / Đáp số:] ] ]\n", ans, sol))
		} else {
			sb.WriteString(fmt.Sprintf("    #if IS_TEACHER [ #v(2pt) #text(weight: \"bold\", size: 8pt, fill: rgb(\"#15803d\"))[Lời giải chi tiết:] \\ #text(size: 8.5pt, fill: rgb(\"#334155\"))[%s] ] else [ #v(2pt) #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 4.5pt, height: 26pt, width: 100%%)[ #text(size: 8pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm / Đáp số:] ] ]\n", sol))
		}
	} else if ans != "" {
		sb.WriteString(fmt.Sprintf("    #if IS_TEACHER [ #v(2pt) #text(weight: \"bold\", size: 8pt, fill: rgb(\"#15803d\"))[Đáp án: %s] ] else [ #v(2pt) #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 4.5pt, height: 26pt, width: 100%%)[ #text(size: 8pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm / Đáp số:] ] ]\n", ans))
	} else {
		sb.WriteString("    #if IS_TEACHER [ ] else [ #v(2pt) #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 4.5pt, height: 26pt, width: 100%)[ #text(size: 8pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm / Đáp số:] ] ]\n")
	}
	sb.WriteString("  ]\n")
}

func (r *DefaultLessonTypstRenderer) renderEssay(sb *strings.Builder, exNum int, ex sharekernel.EssayExercise) {
	prompt := formatTypstMultiline(ex.Prompt().String())

	sb.WriteString("  #block(width: 100%, breakable: false)[\n")
	sb.WriteString(fmt.Sprintf("    #box(fill: rgb(\"#eff6ff\"), stroke: 0.5pt + rgb(\"#bfdbfe\"), inset: (x: 4pt, y: 1.5pt), radius: 2pt)[#text(weight: \"bold\", size: 8pt, fill: rgb(\"#1e3a8a\"))[Bài %d]] #h(3pt) #text(size: 9pt, fill: rgb(\"#1e293b\"))[%s]\n", exNum, prompt))
	parts := ex.Parts()

	if len(parts) > 1 {
		for _, part := range parts {
			lbl := strings.TrimSpace(part.Label())
			if !strings.HasSuffix(lbl, ")") && !strings.HasSuffix(lbl, ".") {
				lbl = lbl + ")"
			}
			partQ := formatTypstMultiline(part.Question().String())
			sb.WriteString(fmt.Sprintf("    #v(2pt)\n    *%s* %s\n", lbl, partQ))
			sol := formatTypstMultiline(part.Solution().String())
			if sol != "" {
				sb.WriteString(fmt.Sprintf("    #if IS_TEACHER [ #v(1.5pt) #text(weight: \"bold\", size: 8pt, fill: rgb(\"#15803d\"))[→ Lời giải chi tiết:] \\ #text(size: 8.5pt, fill: rgb(\"#334155\"))[%s] ] else [ #v(2pt) #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 5pt, height: 36pt, width: 100%%)[ #text(size: 8pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm / Đáp số:] ] ]\n", sol))
			} else {
				sb.WriteString("    #if IS_TEACHER [ ] else [ #v(2pt) #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 5pt, height: 36pt, width: 100%)[ #text(size: 8pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm / Đáp số:] ] ]\n")
			}
		}
	} else if len(parts) == 1 {
		part := parts[0]
		partQ := strings.TrimSpace(part.Question().String())
		if partQ != "" && partQ != strings.TrimSpace(ex.Prompt().String()) {
			lbl := strings.TrimSpace(part.Label())
			if !strings.HasSuffix(lbl, ")") && !strings.HasSuffix(lbl, ".") {
				lbl = lbl + ")"
			}
			sb.WriteString(fmt.Sprintf("    #v(2pt)\n    *%s* %s\n", lbl, formatTypstMultiline(partQ)))
		}
		sol := formatTypstMultiline(part.Solution().String())
		if sol != "" {
			sb.WriteString(fmt.Sprintf("    #if IS_TEACHER [ #v(1.5pt) #text(weight: \"bold\", size: 8pt, fill: rgb(\"#15803d\"))[→ Lời giải chi tiết:] \\ #text(size: 8.5pt, fill: rgb(\"#334155\"))[%s] ] else [ #v(2pt) #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 5pt, height: 36pt, width: 100%%)[ #text(size: 8pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm / Đáp số:] ] ]\n", sol))
		} else {
			sb.WriteString("    #if IS_TEACHER [ ] else [ #v(2pt) #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 5pt, height: 36pt, width: 100%)[ #text(size: 8pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm / Đáp số:] ] ]\n")
		}
	} else {
		sb.WriteString("    #if IS_TEACHER [ ] else [ #v(2pt) #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 5pt, height: 36pt, width: 100%)[ #text(size: 8pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm / Đáp số:] ] ]\n")
	}
	sb.WriteString("  ]\n")
}

// RenderLessonPNGPages biên dịch một Lesson Entity thành danh sách các trang ảnh PNG chất lượng cao (mặc định 300 PPI).
// Cờ isTeacher quyết định sinh bản in cho Giáo viên (có lời giải) hay Học sinh.
func RenderLessonPNGPages(ctx context.Context, lsn *lesson.Lesson, isTeacher bool, ppi int) ([][]byte, error) {
	if lsn == nil {
		return nil, errors.New("lesson không được nil")
	}
	if ppi <= 0 {
		ppi = 300
	}

	renderer := NewDefaultLessonTypstRenderer()
	typstCode, err := renderer.Render(lsn)
	if err != nil {
		return nil, fmt.Errorf("sinh mã Typst thất bại: %w", err)
	}

	tmpDir, err := os.MkdirTemp("", "typst_png_*")
	if err != nil {
		return nil, fmt.Errorf("tạo thư mục tạm thất bại: %w", err)
	}
	defer func() {
		if rmErr := os.RemoveAll(tmpDir); rmErr != nil {
			log.Printf("cảnh báo: dọn dẹp thư mục tạm %s thất bại: %v", tmpDir, rmErr)
		}
	}()

	typFile := filepath.Join(tmpDir, "document.typ")
	if err := os.WriteFile(typFile, []byte(typstCode), 0644); err != nil {
		return nil, fmt.Errorf("ghi file typst tạm thất bại: %w", err)
	}

	teacherVal := "false"
	if isTeacher {
		teacherVal = "true"
	}

	root := filepath.Dir(typFile)
	outPattern := filepath.Join(tmpDir, "page-{p}.png")
	cliPath := ResolveTypstCLI()
	cmd := exec.CommandContext(ctx, cliPath, "compile",
		"--root", root,
		"--input", fmt.Sprintf("teacher=%s", teacherVal),
		"--ppi", strconv.Itoa(ppi),
		typFile,
		outPattern,
	)
	hideConsoleWindow(cmd)

	out, err := cmd.CombinedOutput()
	if err != nil {
		return nil, fmt.Errorf("biên dịch Typst sang PNG thất bại (%w): %s", err, string(out))
	}

	// Đọc tuần tự các file page-1.png, page-2.png, ...
	var pages [][]byte
	for i := 1; ; i++ {
		pageFile := filepath.Join(tmpDir, fmt.Sprintf("page-%d.png", i))
		data, err := os.ReadFile(pageFile)
		if err != nil {
			if os.IsNotExist(err) && i > 1 {
				break
			}
			if os.IsNotExist(err) && i == 1 {
				singleFile := filepath.Join(tmpDir, "page-1.png")
				if data2, err2 := os.ReadFile(singleFile); err2 == nil {
					pages = append(pages, data2)
				}
				break
			}
			return nil, fmt.Errorf("đọc trang PNG %d thất bại: %w", i, err)
		}
		pages = append(pages, data)
	}

	if len(pages) == 0 {
		return nil, errors.New("không tìm thấy trang PNG nào sau khi biên dịch")
	}

	return pages, nil
}
