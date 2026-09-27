package html

import (
	"context"
	"errors"
	"fmt"
	stdhtml "html"
	"strings"
	"time"

	"meet-attendance-clean/domain2/assignment"
	exercise "meet-attendance-clean/domain2/excercise"
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
	// PHẦN 1: LÝ THUYẾT & VÍ DỤ -> 1 TẤM ẢNH DUY NHẤT
	// =========================================================================
	sections := content.Sections()
	if len(sections) > 0 {
		body.WriteString(`<h2 style="color:#0f766e; font-size:18pt;">PHẦN 1: LÝ THUYẾT & VÍ DỤ</h2>`)

		var theoryText strings.Builder
		if content.Overview() != "" {
			theoryText.WriteString("Tổng quan: " + content.Overview() + "\n\n")
		}
		for i, sec := range sections {
			theoryText.WriteString(fmt.Sprintf("%d. %s\n", i+1, sec.SectionTitle))
			if sec.DetailedContent != "" {
				theoryText.WriteString(sec.DetailedContent + "\n")
			}
			if sec.KeyTakeaway != "" {
				theoryText.WriteString("Ghi nhớ: " + sec.KeyTakeaway + "\n")
			}
			if audience == lesson.AudienceTeacher {
				for _, eg := range sec.TeacherExamples {
					theoryText.WriteString(fmt.Sprintf("Ví dụ %d: %s\nLời giải: %s\n", eg.ExampleNum, eg.Problem, eg.TeacherSolution))
				}
			} else {
				for _, eg := range sec.TeacherExamples {
					theoryText.WriteString(fmt.Sprintf("Ví dụ %d: %s\n", eg.ExampleNum, eg.Problem))
				}
			}
		}

		theoryPartName := "img-theory-section"
		if r.imageRenderer != nil {
			theoryImgBytes, err := r.imageRenderer.RenderCard(ctx, "LÝ THUYẾT TRỌNG TÂM", theoryText.String(), "")
			if err == nil && len(theoryImgBytes) > 0 {
				body.WriteString(fmt.Sprintf(`
					<div style="margin: 12pt 0;">
						<img src="name:%s" alt="Lý thuyết" style="max-width:760px; border: 1px solid #cbd5e1; border-radius: 6px;" />
					</div>
				`, theoryPartName))

				images = append(images, AttachedImage{
					PartName: theoryPartName,
					MimeType: "image/png",
					Data:     theoryImgBytes,
				})
			} else {
				body.WriteString(fmt.Sprintf(`<div><p>%s</p></div>`, stdhtml.EscapeString(theoryText.String())))
			}
		}
	}

	// =========================================================================
	// PHẦN 2: BÀI TẬP
	// =========================================================================
	body.WriteString(`<h2 style="color:#0f766e; font-size:18pt;">PHẦN 2: BÀI TẬP</h2>`)

	for i, ex := range exercises {
		item := items[i]
		key := "exercise-" + item.ID().String()
		questionImgPartName := fmt.Sprintf("img-%s", key)

		body.WriteString(fmt.Sprintf(`<div data-id="%s-region" style="margin:16pt 0 24pt 0;">`, key))

		// 1. SOẠN NỘI DUNG ĐỀ BÀI HOÀN CHỈNH CHO TYPST RENDER
		var cardText strings.Builder
		cardText.WriteString(ex.Prompt())

		switch value := ex.(type) {
		case exercise.MultipleChoiceExercise:
			cardText.WriteString("\n\n")
			for _, opt := range value.Options() {
				// ĐỔI TỪ \n SANG \n\n ĐỂ TRONG ẢNH ĐỀ BÀI MỖI ĐÁP ÁN ĐƯỢC XUỐNG DÒNG RIÊNG
				cardText.WriteString(fmt.Sprintf("*%s.* %s\n\n", opt.Label(), opt.Content()))
			}

		case exercise.EssayExercise:
			parts := value.Parts()
			if !(len(parts) == 1 && strings.TrimSpace(parts[0].Question()) == strings.TrimSpace(ex.Prompt())) {
				cardText.WriteString("\n\n")
				for _, part := range parts {
					cardText.WriteString(fmt.Sprintf("*%s.* %s\n\n", part.Label(), part.Question()))
				}
			}
		}

		// 2. RENDER CARD ẢNH HOÀN CHỈNH CHO CÂU NÀY
		if r.imageRenderer != nil {
			title := fmt.Sprintf("Câu %d (%s)", i+1, string(ex.Type()))
			var diagramContent string
			if ex.Diagram().HasDiagram() {
				diagramContent = ex.Diagram().Content()
			}

			qImgBytes, err := r.imageRenderer.RenderCard(ctx, title, cardText.String(), diagramContent)
			if err == nil && len(qImgBytes) > 0 {
				body.WriteString(fmt.Sprintf(`
					<div style="margin: 6pt 0;">
						<img src="name:%s" alt="Đề câu %d" style="max-width:760px;" />
					</div>
				`, questionImgPartName, i+1))

				images = append(images, AttachedImage{
					PartName: questionImgPartName,
					MimeType: "image/png",
					Data:     qImgBytes,
				})
			} else {
				body.WriteString(fmt.Sprintf(`<p><strong>Câu %d:</strong> %s</p>`, i+1, stdhtml.EscapeString(ex.Prompt())))
			}
		}

		// 3. Hiển thị đáp án (Dành cho Giáo viên)
		if audience == lesson.AudienceTeacher {
			body.WriteString(`<div style="margin-top:8pt; padding:8pt; background:#f0fdf4; border-left:4px solid #16a34a;">`)
			switch value := ex.(type) {
			case exercise.MultipleChoiceExercise:
				body.WriteString(fmt.Sprintf(`<p style="color:#15803d; font-weight:bold;">Đáp án đúng: %s</p>`, stdhtml.EscapeString(value.Answer())))
				body.WriteString(fmt.Sprintf(`<p>Lời giải: %s</p>`, stdhtml.EscapeString(value.Solution())))
			case exercise.EssayExercise:
				for _, part := range value.Parts() {
					body.WriteString(fmt.Sprintf(`<p><strong>%s:</strong> Đáp án: %s | Tiêu chí: %s</p>`, part.Label(), part.Solution(), part.Rubric()))
				}
			}
			body.WriteString(`</div>`)
		}

		// 4. Khung làm bài & Checkbox chọn đáp án (Dành cho Học sinh)
		if audience == lesson.AudienceStudent {
			// BẢNG CHECKBOX DỌC: MỖI ĐÁP ÁN 1 DÒNG, CHỈ CÒN A, B, C, D VỚI SIZE 18PT
			if mcq, ok := ex.(exercise.MultipleChoiceExercise); ok {
				body.WriteString(fmt.Sprintf(`<table data-id="%s-choice" style="border-collapse:separate; border-spacing:0 6pt; margin:8pt 0 10pt 0;">`, key))
				for _, opt := range mcq.Options() {
					body.WriteString(fmt.Sprintf(`
						<tr>
							<td width="90" style="width:90px; padding:6pt 16pt; background:#f8fafc; border:1.5px solid #cbd5e1; border-radius:6pt;">
								<p data-id="%s-option-%s" data-tag="to-do" style="margin:0; font-size:18pt; line-height:1.2;">
									<strong>%s</strong>
								</p>
							</td>
						</tr>
					`, key, opt.Label(), opt.Label()))
				}
				body.WriteString(`</table>`)
			}

			// Khung làm bài tự luận / nháp và khung nhận xét
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
