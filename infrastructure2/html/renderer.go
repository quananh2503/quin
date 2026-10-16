package html

import (
	"context"
	"errors"
	"fmt"
	stdhtml "html"
	"strings"
	"time"

	"meet-attendance-clean/domain2/assignment"
	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/renderer"
)

type AttachedImage struct {
	PartName string
	MimeType string
	Data     []byte
}

type Renderer struct {
	imageRenderer renderer.ImageRenderer
}

func NewRenderer(imgRenderer renderer.ImageRenderer) *Renderer {
	return &Renderer{imageRenderer: imgRenderer}
}

func (r *Renderer) Render(
	ctx context.Context,
	pageTitle string,
	content lesson.Lesson,
	audience lesson.Audience,
	items []assignment.AssignmentItem,
) (string, []AttachedImage, error) {
	exercises := content.Exercises()
	if len(exercises) != len(items) {
		return "", nil, errors.New("số item của assignment không khớp với lesson")
	}

	var body strings.Builder
	var images []AttachedImage

	if audience == lesson.AudienceTeacher {
		body.WriteString(`<h1 style="color:#1e3a8a; font-size:20pt;">GIÁO ÁN GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)</h1>`)
	} else {
		body.WriteString(`<h1 style="color:#0f766e; font-size:20pt;">PHIẾU BÀI TẬP HỌC SINH</h1>`)
	}

	// =========================================================================
	// PHẦN 1: LÝ THUYẾT (4 TẦNG) -> COMPILE RA 1 TẤM ẢNH DUY NHẤT
	// =========================================================================
	sections := content.Sections()
	if len(sections) > 0 {
		body.WriteString(`<h2 style="color:#0f766e; font-size:18pt;">PHẦN 1: LÝ THUYẾT TRỌNG TÂM</h2>`)

		theoryTypstMarkup := buildTheoryTypst(content, audience)
		theoryPartName := "img-theory-section"

		if r.imageRenderer != nil {
			title := content.Title().String()
			if strings.TrimSpace(title) == "" {
				title = "LÝ THUYẾT BÀI HỌC"
			}

			theoryImgBytes, err := r.imageRenderer.RenderCard(ctx, title, theoryTypstMarkup, "")
			if err == nil && len(theoryImgBytes) > 0 {
				body.WriteString(fmt.Sprintf(`
					<div style="margin: 12pt 0;">
						<img src="name:%s" alt="Lý thuyết" style="max-width:760px; width:760px; border: 1px solid #cbd5e1; border-radius: 6px; display:block;" />
					</div>
				`, theoryPartName))

				images = append(images, AttachedImage{
					PartName: theoryPartName,
					MimeType: "image/png",
					Data:     theoryImgBytes,
				})
			} else {
				fmt.Printf("\n❌❌❌ [LỖI BIÊN DỊCH TYPST LÝ THUYẾT]: %v\n\n", err)
				body.WriteString(fmt.Sprintf(`<div><p>%s</p></div>`, stdhtml.EscapeString(content.Overview().String())))
			}
		}
	}

	// =========================================================================
	// PHẦN 2: BÀI TẬP (EXERCISES)
	// =========================================================================
	body.WriteString(`<h2 style="color:#0f766e; font-size:18pt;">PHẦN 2: BÀI TẬP</h2>`)

	for i, ex := range exercises {
		item := items[i]
		key := "exercise-" + item.ID().String()
		questionImgPartName := fmt.Sprintf("img-%s", key)

		body.WriteString(fmt.Sprintf(`<div data-id="%s-region" style="margin:16pt 0 24pt 0;">`, key))

		// 1. Soạn nội dung Typst cho đề bài (TĂNG SIZE CHỮ LÊN 13.5pt ĐỂ KHÔNG BỊ NHỎ)
		var cardText strings.Builder
		cardText.WriteString("#set text(size: 13.5pt)\n")
		cardText.WriteString("#set par(leading: 0.7em)\n")
		cardText.WriteString(contentToTypst(ex.Prompt()))
		cardText.WriteString("\n\n")

		switch value := ex.(type) {
		case sharekernel.MultipleChoiceExercise:
			for _, opt := range value.Options() {
				cardText.WriteString(fmt.Sprintf("*%s.* %s\n\n", opt.Label(), contentToTypst(opt.Content())))
			}

		case sharekernel.EssayExercise:
			parts := value.Parts()
			for _, part := range parts {
				cardText.WriteString(fmt.Sprintf("*%s.* %s\n\n", part.Label(), contentToTypst(part.Question())))
			}
		}

		// 2. Render Card ảnh câu hỏi bằng Typst
		if r.imageRenderer != nil {
			title := fmt.Sprintf("Câu %d (%s - %s)", i+1, string(ex.Type()), ex.Difficulty())
			var diagramContent string
			if ex.Diagram().HasDiagram() {
				diagramContent = ex.Diagram().Content()
			}

			qImgBytes, err := r.imageRenderer.RenderCard(ctx, title, cardText.String(), diagramContent)
			if err == nil && len(qImgBytes) > 0 {
				body.WriteString(fmt.Sprintf(`
					<div style="margin: 6pt 0;">
						<img src="name:%s" alt="Đề câu %d" style="max-width:760px; width:760px; display:block;" />
					</div>
				`, questionImgPartName, i+1))

				images = append(images, AttachedImage{
					PartName: questionImgPartName,
					MimeType: "image/png",
					Data:     qImgBytes,
				})
			} else {
				body.WriteString(fmt.Sprintf(`<p><strong>Câu %d:</strong> %s</p>`, i+1, stdhtml.EscapeString(ex.Prompt().String())))
			}
		}

		// 3. Hiển thị đáp án & lời giải (Dành cho Giáo viên)
		if audience == lesson.AudienceTeacher {
			body.WriteString(`<div style="margin-top:8pt; padding:10pt; background:#f0fdf4; border-left:4px solid #16a34a; border-radius:4px;">`)
			switch value := ex.(type) {
			case sharekernel.MultipleChoiceExercise:
				body.WriteString(fmt.Sprintf(`<p style="color:#15803d; font-weight:bold; margin-bottom:4pt;">Đáp án đúng: %s</p>`, stdhtml.EscapeString(value.Answer())))
				if !value.Solution().IsEmpty() {
					body.WriteString(fmt.Sprintf(`<p style="margin:0;"><strong>Lời giải:</strong> %s</p>`, stdhtml.EscapeString(value.Solution().String())))
				}
			case sharekernel.EssayExercise:
				for _, part := range value.Parts() {
					body.WriteString(fmt.Sprintf(`<p style="margin-bottom:4pt;"><strong>%s:</strong> Lời giải: %s | <em>Barem: %s</em></p>`,
						part.Label(),
						stdhtml.EscapeString(part.Solution().String()),
						stdhtml.EscapeString(part.Rubric().String()),
					))
				}
			}
			body.WriteString(`</div>`)
		}

		// 4. Khung làm bài & Checkbox đáp án (Dành cho Học sinh)
		if audience == lesson.AudienceStudent {
			// BẢNG CHECKBOX HÀNG NGANG - GỘP THÀNH 1 THANH LIỀN MẠCH DUY NHẤT
			if mcq, ok := ex.(sharekernel.MultipleChoiceExercise); ok {
				opts := mcq.Options()
				body.WriteString(fmt.Sprintf(`
					<table data-id="%s-choice" style="border-collapse:separate; border-spacing:0; margin:10pt 0 12pt 0; background:#f8fafc; border:1.5px solid #cbd5e1; border-radius:8px; overflow:hidden;">
						<tr>
				`, key))

				for idx, opt := range opts {
					// Ô cuối cùng không cần vách ngăn bên phải
					borderRight := "border-right: 1.5px solid #cbd5e1;"
					if idx == len(opts)-1 {
						borderRight = ""
					}

					body.WriteString(fmt.Sprintf(`
							<td style="min-width:68px; padding:6pt 20pt; text-align:center; vertical-align:middle; %s">
								<p data-id="%s-option-%s" data-tag="to-do" style="margin:0; font-size:16pt; line-height:1.2;">
									<strong>%s</strong>
								</p>
							</td>
					`, borderRight, key, opt.Label(), opt.Label()))
				}

				body.WriteString(`
						</tr>
					</table>
				`)
			}

			// Khung làm bài tự luận / nháp
			body.WriteString(fmt.Sprintf(`
				<table width="1050" style="width:1050px; border-collapse:collapse; margin:8pt 0 6pt 0;">
					<tr>
						<td width="760" style="vertical-align:top;">
							<table data-id="%s-work" width="760">
								<tr>
									<td height="160" style="height:160pt; padding:10pt; border:1.5px dashed #94a3b8; background:#f8fafc; vertical-align:top;">
										<div data-id="%s-answer-content">
											<p style="color:#94a3b8;"><em>✍️ Bài làm (Gõ chữ hoặc viết/chèn ảnh vào khung này):</em></p>
											<p style="line-height:28pt;">&nbsp;</p>
											<p style="line-height:28pt;">&nbsp;</p>
										</div>
									</td>
								</tr>
							</table>
						</td>
						<td width="290" style="vertical-align:top; padding-left:12pt;">
							<div data-id="%s-feedback" style="width:270px; min-height:1px;">&nbsp;</div>
						</td>
					</tr>
				</table>
			`, key, key, key))
		}

		body.WriteString(`</div>`)
	}

	htmlPage := fmt.Sprintf(`<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>%s</title>
	<meta name="created" content="%s">
	<style>
		body { font-family: Calibri, Arial, sans-serif; font-size: 14pt; color: #1e293b; line-height: 1.6; margin: 0; padding: 10pt; }
		p { margin: 0 0 6pt; }
	</style>
</head>
<body>
%s
</body>
</html>`, stdhtml.EscapeString(pageTitle), time.Now().UTC().Format(time.RFC3339), body.String())

	return htmlPage, images, nil
}

func buildTheoryTypst(lsn lesson.Lesson, audience lesson.Audience) string {
	var sb strings.Builder

	// Đảm bảo chữ phần lý thuyết to rõ và đồng bộ
	sb.WriteString("#set text(size: 13.5pt)\n")

	if !lsn.Overview().IsEmpty() {
		sb.WriteString(fmt.Sprintf("#text(style: \"italic\")[*Tổng quan:* %s]\n#v(8pt)\n", contentToTypst(lsn.Overview())))
	}

	for _, sec := range lsn.Sections() {
		// TIÊU ĐỀ PHẦN (I, II...): Dùng #text thay vì dấu '='
		secTitle := contentToTypst(sec.Title())
		sb.WriteString(fmt.Sprintf("\n#v(10pt)\n#text(size: 15pt, weight: \"bold\", fill: rgb(\"#0f766e\"))[%s]\n#v(4pt)\n", secTitle))

		for _, top := range sec.Topics() {
			// TIÊU ĐỀ MỤC NHỎ (1, 2...): Dùng #text thay vì dấu '=='
			topTitle := contentToTypst(top.Title())
			sb.WriteString(fmt.Sprintf("\n#v(6pt)\n#text(size: 13.5pt, weight: \"bold\", fill: rgb(\"#1e293b\"))[%s]\n#v(3pt)\n", topTitle))

			for _, b := range top.Blocks() {
				sb.WriteString(blockToTypst(b, audience))
				sb.WriteString("\n")
			}
			sb.WriteString("#v(4pt)\n")
		}
		sb.WriteString("#v(6pt)\n")
	}

	return sb.String()
}

// contentToTypst giữ nguyên logic
func contentToTypst(c sharekernel.Content) string {
	var sb strings.Builder
	for _, p := range c.Parts() {
		switch p.Type {
		case sharekernel.InlineText:
			sb.WriteString(escapeTypstText(p.Value))
		case sharekernel.InlineMath:
			mathStr := strings.TrimSpace(p.Value)
			if mathStr != "" {
				sb.WriteString(fmt.Sprintf(" $%s$ ", mathStr))
			}
		}
	}
	return sb.String()
}

func escapeTypstText(s string) string {
	s = strings.ReplaceAll(s, `\`, `\\`)
	s = strings.ReplaceAll(s, `$`, `\$`)
	s = strings.ReplaceAll(s, `#`, `\#`)
	return s
}

func blockToTypst(b lesson.Block, audience lesson.Audience) string {
	switch v := b.(type) {
	case lesson.ParagraphBlock:
		return contentToTypst(v.Body()) + "\n"

	case lesson.FormulaBlock:
		return fmt.Sprintf("\n#align(center, $ %s $)\n\n", strings.TrimSpace(v.Math()))

	case lesson.ListBlock:
		var sb strings.Builder
		prefix := "- "
		if v.IsOrdered() {
			prefix = "+ "
		}
		for _, item := range v.Items() {
			sb.WriteString(fmt.Sprintf("%s%s\n", prefix, contentToTypst(item)))
		}
		return sb.String()

	case lesson.ExampleBlock:
		title := contentToTypst(v.Title())
		if strings.TrimSpace(title) == "" {
			title = "Ví dụ minh họa"
		}

		teacherSolution := ""
		if audience == lesson.AudienceTeacher && !v.Solution().IsEmpty() {
			teacherSolution = fmt.Sprintf("\n#v(4pt)\n#text(weight: \"bold\", fill: rgb(\"#15803d\"))[Lời giải:] %s", contentToTypst(v.Solution()))
		}

		return fmt.Sprintf(`
#block(
  fill: rgb("#f1f5f9"),
  stroke: 1pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 6pt,
  width: 100%%,
  [
    #text(weight: "bold", fill: rgb("#0369a1"))[%s] \
    %s
    %s
  ]
)
`, title, contentToTypst(v.Problem()), teacherSolution)

	case lesson.CalloutBlock:
		var bgColor, borderColor, textColor, icon string
		switch v.Kind() {
		case lesson.CalloutTip:
			icon = "💡"
			bgColor = "#f0fdf4"
			borderColor = "#22c55e"
			textColor = "#15803d"
		case lesson.CalloutWarning:
			icon = "⚠️"
			bgColor = "#fefce8"
			borderColor = "#eab308"
			textColor = "#a16207"
		default:
			icon = "📌"
			bgColor = "#eff6ff"
			borderColor = "#3b82f6"
			textColor = "#1d4ed8"
		}

		title := contentToTypst(v.Title())
		if strings.TrimSpace(title) == "" {
			title = "Ghi nhớ"
		}

		return fmt.Sprintf(`
#block(
  fill: rgb("%s"),
  stroke: (left: 4pt + rgb("%s")),
  inset: (x: 10pt, y: 8pt),
  radius: (right: 4pt),
  width: 100%%,
  [
    #text(weight: "bold", fill: rgb("%s"))[%s %s] \
    #v(2pt)
    %s
  ]
)
`, bgColor, borderColor, textColor, icon, title, contentToTypst(v.Body()))

	case lesson.ClozeBlock:
		var sb strings.Builder
		if !v.Instruction().IsEmpty() {
			sb.WriteString(fmt.Sprintf("#text(style: \"italic\")[%s]\n", contentToTypst(v.Instruction())))
		}
		for _, item := range v.Items() {
			sb.WriteString("- ")
			for _, part := range item.Parts {
				switch part.Type {
				case lesson.ClozeText:
					sb.WriteString(escapeTypstText(part.Value))
				case lesson.ClozeMath:
					sb.WriteString(fmt.Sprintf(" $%s$ ", strings.TrimSpace(part.Value)))
				case lesson.ClozeBlank:
					if audience == lesson.AudienceTeacher {
						sb.WriteString(fmt.Sprintf(" #text(fill: rgb(\"#dc2626\"), weight: \"bold\")[ %s ] ", part.Value))
					} else {
						sb.WriteString(" #underline(stroke: 1.5pt + rgb(\"#94a3b8\"))[#h(40pt)] ")
					}
				}
			}
			sb.WriteString("\n")
		}
		return sb.String()

	case lesson.ImageBlock:
		caption := ""
		if !v.Caption().IsEmpty() {
			caption = fmt.Sprintf("\n#align(center)[#text(size: 10pt, style: \"italic\")[%s]]", contentToTypst(v.Caption()))
		}
		return fmt.Sprintf("\n#v(4pt)\n// SVG Image placeholder\n%s\n", caption)

	default:
		return ""
	}
}
