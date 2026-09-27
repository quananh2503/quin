package renderer

import (
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
)

type ImageRenderer interface {
	RenderLaTeXSnippet(ctx context.Context, latex string) ([]byte, error)
	RenderSVG(ctx context.Context, svgContent string) ([]byte, error)
	RenderCard(ctx context.Context, title string, content string, svgContent string) ([]byte, error)
	RenderOption(ctx context.Context, content string) ([]byte, error)
}

type LocalRenderer struct{}

func NewLocalRenderer() *LocalRenderer {
	return &LocalRenderer{}
}

var (
	blockMathRegex  = regexp.MustCompile(`\$\$(.*?)\$\$`)
	inlineMathRegex = regexp.MustCompile(`\$([^\$\n]+)\$`)
	headingRegex    = regexp.MustCompile(`(?m)^(\d+\.\s+|[a-z]\)\s+|Ví dụ\s+\d+:|Ghi nhớ:)(.+)`)
)

// unescapeNewlinesSafely chỉ đổi \n thành xuống dòng nếu không phải lệnh LaTeX (\ne, \neq, \notin, \nu...)
func unescapeNewlinesSafely(s string) string {
	var b strings.Builder
	b.Grow(len(s))
	for i := 0; i < len(s); i++ {
		if s[i] == '\\' && i+1 < len(s) && s[i+1] == 'n' {
			// Nếu ký tự tiếp theo là chữ cái (e trong \ne, u trong \nu...), đây là lệnh LaTeX, KHÔNG được cắt dòng!
			if i+2 < len(s) && ((s[i+2] >= 'a' && s[i+2] <= 'z') || (s[i+2] >= 'A' && s[i+2] <= 'Z')) {
				b.WriteByte(s[i])
				continue
			}
			b.WriteByte('\n')
			i++ // Bỏ qua ký tự 'n'
			continue
		}
		b.WriteByte(s[i])
	}
	return b.String()
}

func wrapLaTeXWithMitex(content string) string {
	// 1. Chuyển đổi an toàn ký tự xuống dòng (không làm rách \ne, \neq)
	res := unescapeNewlinesSafely(content)

	// 2. Tự động chuẩn hóa Markdown
	res = strings.ReplaceAll(res, `### `, "")
	res = strings.ReplaceAll(res, `## `, "")
	res = strings.ReplaceAll(res, `**`, "*")

	// 3. In đậm các mục số
	res = headingRegex.ReplaceAllString(res, "*$1$2*")

	// 4. Chuyển đổi $$...$$ thành block math của MiTeX
	res = blockMathRegex.ReplaceAllStringFunc(res, func(m string) string {
		inner := strings.Trim(m, "$")
		return fmt.Sprintf("\n#align(center, mitex(`%s`))\n", inner)
	})

	// 5. Chuyển đổi $...$ thành inline math của MiTeX (#mi)
	res = inlineMathRegex.ReplaceAllStringFunc(res, func(m string) string {
		inner := strings.Trim(m, "$")
		return fmt.Sprintf(" #mi(`%s`) ", inner)
	})

	return res
}

func (r *LocalRenderer) RenderCard(ctx context.Context, title string, content string, svgContent string) ([]byte, error) {
	tempDir, err := os.MkdirTemp("", "card-render-*")
	if err != nil {
		return nil, err
	}
	defer os.RemoveAll(tempDir)

	typPath := filepath.Join(tempDir, "card.typ")
	pngPath := filepath.Join(tempDir, "card.png")

	typstBody := wrapLaTeXWithMitex(content)

	// Chuẩn hóa và nhúng SVG (nếu có)
	diagramTypstMarkup := ""
	svgContent = strings.TrimSpace(svgContent)
	if svgContent != "" && strings.HasPrefix(svgContent, "<svg") {
		cleanSVG := strings.ReplaceAll(svgContent, "&infin;", "∞")
		cleanSVG = strings.ReplaceAll(cleanSVG, "&ge;", "≥")
		cleanSVG = strings.ReplaceAll(cleanSVG, "&le;", "≤")

		svgPath := filepath.Join(tempDir, "diagram.svg")
		if err := os.WriteFile(svgPath, []byte(cleanSVG), 0644); err == nil {
			diagramTypstMarkup = "\n#v(6pt)\n#align(center, image(\"diagram.svg\", width: 70%))\n#v(6pt)\n"
		}
	}

	doc := fmt.Sprintf(`#import "@preview/mitex:0.2.7": *

#set page(width: 760pt, height: auto, margin: 15pt, fill: rgb("#ffffff"))
#set text(size: 13pt)
#set par(justify: true, leading: 0.85em)

#block(
  fill: rgb("#f8fafc"),
  inset: 14pt,
  radius: 8pt,
  stroke: 1pt + rgb("#cbd5e1"),
  width: 100%%,
  [
    #text(weight: "bold", size: 16pt, fill: rgb("#0f766e"), [%s]) \ \
    %s
    %s
  ]
)`, title, typstBody, diagramTypstMarkup)

	if err := os.WriteFile(typPath, []byte(doc), 0644); err != nil {
		return nil, err
	}

	if _, err := exec.LookPath("typst"); err != nil {
		return nil, fmt.Errorf("chưa cài đặt typst")
	}

	cmd := exec.CommandContext(ctx, "typst", "compile", "--format", "png", "--ppi", "180", typPath, pngPath)
	if output, err := cmd.CombinedOutput(); err != nil {
		return nil, fmt.Errorf("render card ảnh thất bại: %w (chi tiết: %s)", err, string(output))
	}

	return os.ReadFile(pngPath)
}

func (r *LocalRenderer) RenderLaTeXSnippet(ctx context.Context, latex string) ([]byte, error) {
	return r.RenderCard(ctx, "", "$"+latex+"$", "")
}

func (r *LocalRenderer) RenderSVG(ctx context.Context, svgContent string) ([]byte, error) {
	return r.RenderCard(ctx, "", "", svgContent)
}

// RenderOption biên dịch từng phương án trắc nghiệm thành 1 ảnh nhỏ có kích thước vừa khít nội dung
func (r *LocalRenderer) RenderOption(ctx context.Context, content string) ([]byte, error) {
	tempDir, err := os.MkdirTemp("", "opt-render-*")
	if err != nil {
		return nil, err
	}
	defer os.RemoveAll(tempDir)

	typPath := filepath.Join(tempDir, "opt.typ")
	pngPath := filepath.Join(tempDir, "opt.png")

	cleanContent := sanitizeContent(content)

	// Template Typst tự co giãn kích thước (width: auto, height: auto), nền trong suốt
	doc := fmt.Sprintf(
		"#import \"@preview/mitex:0.2.7\": *\n"+
			"#set page(width: auto, height: auto, margin: (x: 4pt, y: 3pt), fill: none)\n"+
			"#set text(size: 13pt)\n"+
			"#mitext(`%s`)",
		cleanContent,
	)

	if err := os.WriteFile(typPath, []byte(doc), 0644); err != nil {
		return nil, err
	}

	cmd := exec.CommandContext(ctx, "typst", "compile", "--format", "png", "--ppi", "180", typPath, pngPath)
	if output, err := cmd.CombinedOutput(); err != nil {
		return nil, fmt.Errorf("render option thất bại: %w (%s)", err, string(output))
	}

	return os.ReadFile(pngPath)
}

// sanitizeContent dọn dẹp các ký tự Markdown thừa và chuyển đổi ký tự xuống dòng an toàn
func sanitizeContent(s string) string {
	// 1. Chuyển đổi ký tự xuống dòng escaped \n thành xuống dòng thật
	// Kiểm tra nếu phía sau là chữ cái (e trong \ne, u trong \nu...) thì KHÔNG cắt dòng để bảo vệ lệnh LaTeX
	var b strings.Builder
	b.Grow(len(s))
	for i := 0; i < len(s); i++ {
		if s[i] == '\\' && i+1 < len(s) && s[i+1] == 'n' {
			if i+2 < len(s) && ((s[i+2] >= 'a' && s[i+2] <= 'z') || (s[i+2] >= 'A' && s[i+2] <= 'Z')) {
				b.WriteByte(s[i])
				continue
			}
			b.WriteByte('\n')
			i++ // Bỏ qua chữ 'n'
			continue
		}
		b.WriteByte(s[i])
	}

	clean := b.String()

	// 2. Dọn sạch các ký tự Markdown nếu AI lỡ sinh ra
	clean = strings.ReplaceAll(clean, "### ", "")
	clean = strings.ReplaceAll(clean, "## ", "")
	clean = strings.ReplaceAll(clean, "**", "")

	return clean
}
