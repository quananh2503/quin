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

	// 1. Sinh Prelude Typst
	sb.WriteString(`#import "@preview/mitex:0.2.7": mitex, mi` + "\n")
	sb.WriteString(`#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"` + "\n")
	sb.WriteString(`#set page(paper: "a4", margin: (x: 1.5cm, top: 1.4cm, bottom: 1.5cm))` + "\n")
	sb.WriteString(`#set text(font: ("Arial", "Segoe UI", "DejaVu Sans", "Liberation Sans"), size: 11pt, lang: "vi")` + "\n")
	sb.WriteString(`#set par(justify: true, leading: 0.75em)` + "\n")
	sb.WriteString(`#let card(title: none, body) = block(fill: rgb("#f8fafc"), stroke: 1pt + rgb("#cbd5e1"), radius: 6pt, inset: 10pt, width: 100%, [ #if title != none [ #text(weight: "bold", size: 11.5pt, fill: rgb("#0f766e"))[#title] \ #v(2pt) ] #body ])` + "\n\n")

	// 2. Header bài giảng
	titleStr := LaTeXToMiTeX(lsn.Title().String())
	overviewStr := LaTeXToMiTeX(lsn.Overview().String())
	sb.WriteString(fmt.Sprintf("#align(center)[ #if IS_TEACHER [ #text(size: 17pt, weight: \"bold\", fill: rgb(\"#1e3a8a\"))[GIÁO ÁN GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)] ] else [ #text(size: 17pt, weight: \"bold\", fill: rgb(\"#0f766e\"))[PHIẾU BÀI TẬP HỌC SINH] ] \\ #v(2pt) #text(size: 13pt, weight: \"bold\")[%s] \\ #text(size: 9.5pt, style: \"italic\", fill: rgb(\"#475569\"))[%s] ]\n#v(6pt)\n", titleStr, overviewStr))

	// 3. Duyệt qua từng Section trong lsn.Sections() và từng Topic trong sec.Topics()
	for _, sec := range lsn.Sections() {
		for _, topic := range sec.Topics() {
			topicTitle := LaTeXToMiTeX(topic.Title().String())
			sb.WriteString(fmt.Sprintf("#v(8pt)\n#text(size: 13pt, weight: \"bold\", fill: rgb(\"#1e3a8a\"))[%s]\n#v(3pt)\n", topicTitle))

			// Mục I: Lý thuyết & Ghi nhớ
			var theoryLines []string
			var exampleBlocks []lesson.ExampleBlock

			for _, blk := range topic.Blocks() {
				if blk == nil {
					continue
				}
				switch b := blk.(type) {
				case lesson.ParagraphBlock:
					body := strings.TrimSpace(b.Body().String())
					if body != "" {
						theoryLines = append(theoryLines, fmt.Sprintf("  - %s\n", LaTeXToMiTeX(body)))
					}
				case *lesson.ParagraphBlock:
					body := strings.TrimSpace(b.Body().String())
					if body != "" {
						theoryLines = append(theoryLines, fmt.Sprintf("  - %s\n", LaTeXToMiTeX(body)))
					}
				case lesson.CalloutBlock:
					calloutTitle := strings.TrimSpace(b.Title().String())
					calloutTitle = strings.TrimPrefix(calloutTitle, "💡")
					calloutTitle = strings.TrimSpace(calloutTitle)
					calloutTitle = strings.TrimSuffix(calloutTitle, ":")
					if calloutTitle == "" {
						calloutTitle = "Mẹo giải nhanh"
					}
					calloutBody := strings.TrimSpace(b.Body().String())
					theoryLines = append(theoryLines, fmt.Sprintf("  #block(fill: rgb(\"#f0fdf4\"), stroke: (left: 4pt + rgb(\"#22c55e\")), inset: 8pt, width: 100%%)[ #text(weight: \"bold\", fill: rgb(\"#15803d\"))[💡 %s:] %s ]\n", LaTeXToMiTeX(calloutTitle), LaTeXToMiTeX(calloutBody)))
				case *lesson.CalloutBlock:
					calloutTitle := strings.TrimSpace(b.Title().String())
					calloutTitle = strings.TrimPrefix(calloutTitle, "💡")
					calloutTitle = strings.TrimSpace(calloutTitle)
					calloutTitle = strings.TrimSuffix(calloutTitle, ":")
					if calloutTitle == "" {
						calloutTitle = "Mẹo giải nhanh"
					}
					calloutBody := strings.TrimSpace(b.Body().String())
					theoryLines = append(theoryLines, fmt.Sprintf("  #block(fill: rgb(\"#f0fdf4\"), stroke: (left: 4pt + rgb(\"#22c55e\")), inset: 8pt, width: 100%%)[ #text(weight: \"bold\", fill: rgb(\"#15803d\"))[💡 %s:] %s ]\n", LaTeXToMiTeX(calloutTitle), LaTeXToMiTeX(calloutBody)))
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
				case lesson.ListBlock:
					for _, item := range b.Items() {
						itemStr := strings.TrimSpace(item.String())
						if itemStr != "" {
							theoryLines = append(theoryLines, fmt.Sprintf("  - %s\n", LaTeXToMiTeX(itemStr)))
						}
					}
				case *lesson.ListBlock:
					for _, item := range b.Items() {
						itemStr := strings.TrimSpace(item.String())
						if itemStr != "" {
							theoryLines = append(theoryLines, fmt.Sprintf("  - %s\n", LaTeXToMiTeX(itemStr)))
						}
					}
				case lesson.ExampleBlock:
					exampleBlocks = append(exampleBlocks, b)
				case *lesson.ExampleBlock:
					exampleBlocks = append(exampleBlocks, *b)
				default:
					if b.BlockType() == "definition" || b.BlockType() == "theorem" {
						if bodyer, ok := b.(interface{ Body() sharekernel.Content }); ok {
							body := strings.TrimSpace(bodyer.Body().String())
							if body != "" {
								theoryLines = append(theoryLines, fmt.Sprintf("  - %s\n", LaTeXToMiTeX(body)))
							}
						}
					}
				}
			}

			if len(theoryLines) > 0 {
				sb.WriteString("#card(title: \"I. Lý thuyết & Ghi nhớ\")[\n")
				for _, line := range theoryLines {
					sb.WriteString(line)
				}
				sb.WriteString("]\n#v(4pt)\n")
			}

			// Mục II: Ví dụ minh họa giải mẫu
			if len(exampleBlocks) > 0 {
				sb.WriteString("#card(title: \"II. Ví dụ minh họa giải mẫu\")[\n")
				for idx, ex := range exampleBlocks {
					if idx > 0 {
						sb.WriteString("  #v(4pt)\n")
					}
					exTitle := strings.TrimSpace(ex.Title().String())
					exTitle = strings.TrimSuffix(exTitle, ":")
					exProb := strings.TrimSpace(ex.Problem().String())
					exSol := strings.TrimSpace(ex.Solution().String())
					sb.WriteString(fmt.Sprintf("  #block(fill: rgb(\"#f1f5f9\"), stroke: 1pt + rgb(\"#cbd5e1\"), inset: 8pt, radius: 4pt, width: 100%%)[ #text(weight: \"bold\", fill: rgb(\"#0369a1\"))[%s:] %s #if IS_TEACHER [ \\ #v(3pt) #text(weight: \"bold\", fill: rgb(\"#15803d\"))[Lời giải:] %s ] else [ \\ #v(16pt) ] ]\n", LaTeXToMiTeX(exTitle), LaTeXToMiTeX(exProb), LaTeXToMiTeX(exSol)))
				}
				sb.WriteString("]\n#v(4pt)\n")
			}

			// Mục III: Bài tập rèn luyện
			exercises := topic.Exercises()
			if len(exercises) > 0 {
				sb.WriteString("#card(title: \"III. Bài tập rèn luyện\")[\n")
				for exIdx, rawEx := range exercises {
					if exIdx > 0 {
						sb.WriteString("  #v(6pt)\n")
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
						prompt := LaTeXToMiTeX(ex.Prompt().String())
						sb.WriteString(fmt.Sprintf("  *Bài %d.* %s\n", exNum, prompt))
					}
				}
				sb.WriteString("]\n#v(4pt)\n")
			}
		}
	}

	return sb.String(), nil
}

func (r *DefaultLessonTypstRenderer) renderMCQ(sb *strings.Builder, exNum int, ex sharekernel.MultipleChoiceExercise) {
	prompt := LaTeXToMiTeX(ex.Prompt().String())
	sb.WriteString(fmt.Sprintf("  *Bài %d.* %s\n", exNum, prompt))

	opts := ex.Options()
	if len(opts) > 0 {
		cols := make([]string, len(opts))
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
			optCells = append(optCells, fmt.Sprintf("[*%s.* %s]", lbl, LaTeXToMiTeX(optText)))
		}
		sb.WriteString(fmt.Sprintf("  #v(2pt)\n  #grid(columns: %s, gutter: 6pt, %s)\n", colsStr, strings.Join(optCells, ", ")))
	}

	ans := strings.TrimSpace(ex.Answer())
	sol := strings.TrimSpace(ex.Solution().String())
	if sol != "" {
		sb.WriteString(fmt.Sprintf("  #if IS_TEACHER [ #v(2pt) #text(weight: \"bold\", fill: rgb(\"#15803d\"))[Đáp án: %s] \\ #text(fill: rgb(\"#334155\"))[Lời giải: %s] ]\n", ans, LaTeXToMiTeX(sol)))
	} else {
		sb.WriteString(fmt.Sprintf("  #if IS_TEACHER [ #v(2pt) #text(weight: \"bold\", fill: rgb(\"#15803d\"))[Đáp án: %s] ]\n", ans))
	}
}

func (r *DefaultLessonTypstRenderer) renderEssay(sb *strings.Builder, exNum int, ex sharekernel.EssayExercise) {
	prompt := LaTeXToMiTeX(ex.Prompt().String())
	parts := ex.Parts()

	if len(parts) > 1 {
		sb.WriteString(fmt.Sprintf("  *Bài %d.* %s\n", exNum, prompt))
		for _, part := range parts {
			lbl := strings.TrimSpace(part.Label())
			if !strings.HasSuffix(lbl, ")") && !strings.HasSuffix(lbl, ".") {
				lbl = lbl + ")"
			}
			partQ := LaTeXToMiTeX(part.Question().String())
			sb.WriteString(fmt.Sprintf("  #v(2pt)\n  *%s* %s\n", lbl, partQ))
			sol := LaTeXToMiTeX(part.Solution().String())
			sb.WriteString(fmt.Sprintf("  #if IS_TEACHER [ #v(2pt) #text(fill: rgb(\"#15803d\"))[→ Lời giải: %s] ] else [ #v(2pt) #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 6pt, height: 45pt, width: 100%%)[ #text(size: 8.5pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm / Đáp số:] ] ]\n", sol))
		}
	} else if len(parts) == 1 {
		part := parts[0]
		sb.WriteString(fmt.Sprintf("  *Bài %d.* %s\n", exNum, prompt))
		partQ := strings.TrimSpace(part.Question().String())
		if partQ != "" && partQ != strings.TrimSpace(ex.Prompt().String()) {
			lbl := strings.TrimSpace(part.Label())
			if !strings.HasSuffix(lbl, ")") && !strings.HasSuffix(lbl, ".") {
				lbl = lbl + ")"
			}
			sb.WriteString(fmt.Sprintf("  #v(2pt)\n  *%s* %s\n", lbl, LaTeXToMiTeX(partQ)))
		}
		sol := LaTeXToMiTeX(part.Solution().String())
		sb.WriteString(fmt.Sprintf("  #if IS_TEACHER [ #v(2pt) #text(fill: rgb(\"#15803d\"))[→ Lời giải: %s] ] else [ #v(2pt) #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 6pt, height: 45pt, width: 100%%)[ #text(size: 8.5pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm / Đáp số:] ] ]\n", sol))
	} else {
		sb.WriteString(fmt.Sprintf("  *Bài %d.* %s\n", exNum, prompt))
		sb.WriteString("  #if IS_TEACHER [ #v(2pt) #text(fill: rgb(\"#15803d\"))[→ Lời giải: ] ] else [ #v(2pt) #block(stroke: (paint: rgb(\"#94a3b8\"), dash: \"dashed\"), inset: 6pt, height: 45pt, width: 100%)[ #text(size: 8.5pt, fill: rgb(\"#94a3b8\"))[✍️ Bài làm / Đáp số:] ] ]\n")
	}
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
