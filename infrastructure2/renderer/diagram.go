package renderer

import (
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

type ImageRenderer interface {
	RenderCard(ctx context.Context, title string, typstMarkup string, svgContent string) ([]byte, error)
}

type LocalRenderer struct{}

func NewLocalRenderer() *LocalRenderer {
	return &LocalRenderer{}
}

func (r *LocalRenderer) RenderCard(ctx context.Context, title string, typstMarkup string, svgContent string) ([]byte, error) {
	tempDir, err := os.MkdirTemp("", "card-render-*")
	if err != nil {
		return nil, err
	}
	defer os.RemoveAll(tempDir)

	typPath := filepath.Join(tempDir, "card.typ")
	pngPath := filepath.Join(tempDir, "card.png")

	// Nhúng hình vẽ SVG nếu có
	diagramTypstMarkup := ""
	svgContent = strings.TrimSpace(svgContent)
	if svgContent != "" && strings.HasPrefix(svgContent, "<svg") {
		// Chuẩn hóa một số ký tự thực thể XML nếu AI lỡ sinh
		cleanSVG := strings.ReplaceAll(svgContent, "&infin;", "∞")
		cleanSVG = strings.ReplaceAll(cleanSVG, "&ge;", "≥")
		cleanSVG = strings.ReplaceAll(cleanSVG, "&le;", "≤")

		svgPath := filepath.Join(tempDir, "diagram.svg")
		if err := os.WriteFile(svgPath, []byte(cleanSVG), 0644); err == nil {
			diagramTypstMarkup = "\n#v(8pt)\n#align(center, image(\"diagram.svg\", width: 70%))\n#v(4pt)\n"
		}
	}

	// Tiêu đề card (nếu có)
	titleTypst := ""
	if strings.TrimSpace(title) != "" {
		titleTypst = fmt.Sprintf("#text(weight: \"bold\", size: 15pt, fill: rgb(\"#0f766e\"))[%s] \\ \n#v(6pt)\n", title)
	}

	// TEMPLATE TYPST THUẦN TÚY - KHÔNG CẦN MITEX!
	doc := fmt.Sprintf(`
#set page(width: 760pt, height: auto, margin: 14pt, fill: rgb("#ffffff"))
#set text(size: 13pt, font: ("Segoe UI", "Arial", "Liberation Sans"))
#set par(justify: true, leading: 0.85em)

#block(
  fill: rgb("#f8fafc"),
  inset: 14pt,
  radius: 8pt,
  stroke: 1pt + rgb("#cbd5e1"),
  width: 100%%,
  [
    %s
    %s
    %s
  ]
)`, titleTypst, typstMarkup, diagramTypstMarkup)

	if err := os.WriteFile(typPath, []byte(doc), 0644); err != nil {
		return nil, err
	}

	if _, err := exec.LookPath("typst"); err != nil {
		return nil, fmt.Errorf("hệ thống chưa cài đặt typst binary")
	}

	// Biên dịch Typst thẳng ra PNG với độ phân giải 180 PPI siêu nét
	cmd := exec.CommandContext(ctx, "typst", "compile", "--format", "png", "--ppi", "180", typPath, pngPath)
	if output, err := cmd.CombinedOutput(); err != nil {
		return nil, fmt.Errorf("typst compile thất bại: %w (chi tiết: %s)", err, string(output))
	}

	return os.ReadFile(pngPath)
}
