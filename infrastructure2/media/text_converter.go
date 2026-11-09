package media

import (
	"bufio"
	"bytes"
	"context"
	"fmt"
	"html"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
)

// =============================================================================
// TEXT CLEANER (LỌC BỎ SỐ THÔ, TIMESTAMPS, ASR ARTIFACTS)
// =============================================================================

var (
	// Regex nhận diện timestamp dạng: "00:01:23", "[01:23]", "(01:23)", "12.34:"
	timestampRegex = regexp.MustCompile(`(?i)(?:\[|\()?\b\d{1,2}:\d{2}(?::\d{2})?(?:\.\d+)?(?:\]|\))?`)
	// Regex nhận diện số giây thô ở đầu dòng: "0.00: ", "123.45: " hoặc "[123.45s]"
	rawSecondRegex = regexp.MustCompile(`^\s*\[?\d+(?:\.\d+)?(?:s)?\]?:?\s*`)
	// Regex nhận diện dòng chỉ chứa số thứ tự phụ đề (1, 2, 3...)
	pureNumberLineRegex = regexp.MustCompile(`^\s*\d+\s*$`)
	// Regex nhận diện mốc thời gian chuẩn SRT: "00:00:01,000 --> 00:00:03,500"
	srtTimeRegex = regexp.MustCompile(`\d{2}:\d{2}:\d{2}[,\.]\d{3}\s*-->\s*\d{2}:\d{2}:\d{2}[,\.]\d{3}`)
)

// CleanRawText lọc bỏ toàn bộ số thô, mốc thời gian, số thứ tự dòng và ghép thành các đoạn văn tiếng Việt hoàn chỉnh
func CleanRawText(raw string) string {
	scanner := bufio.NewScanner(strings.NewReader(raw))
	var cleanedWords []string
	var paragraphs []string

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "Language:") || strings.HasPrefix(line, "Transcript:") {
			continue
		}

		// 1. Bỏ dòng mốc thời gian SRT
		if srtTimeRegex.MatchString(line) {
			continue
		}

		// 2. Bỏ dòng chỉ chứa số thứ tự
		if pureNumberLineRegex.MatchString(line) {
			continue
		}

		// 3. Xóa số giây thô ở đầu dòng (VD: "0.00: ", "2.80: ")
		line = rawSecondRegex.ReplaceAllString(line, "")

		// 4. Xóa các timestamp kẹp ngoặc (VD: "[01:23]", "00:01:23")
		line = timestampRegex.ReplaceAllString(line, "")
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}

		// 5. Tách từ và loại bỏ các từ lặp liên tiếp do nhận diện giọng nói ASR
		words := strings.Fields(line)
		for _, w := range words {
			n := len(cleanedWords)
			if n > 0 && strings.EqualFold(cleanedWords[n-1], w) {
				continue // Bỏ từ lặp sát nhau
			}
			if n > 1 && strings.EqualFold(cleanedWords[n-2], w) {
				continue // Bỏ từ lặp xen kẽ
			}
			cleanedWords = append(cleanedWords, w)
		}

		// Gom thành đoạn văn khi đủ khoảng 70 - 85 từ
		if len(cleanedWords) >= 75 {
			para := strings.Join(cleanedWords, " ")
			paragraphs = append(paragraphs, para)
			cleanedWords = nil
		}
	}

	if len(cleanedWords) > 0 {
		para := strings.Join(cleanedWords, " ")
		paragraphs = append(paragraphs, para)
	}

	return strings.Join(paragraphs, "\n\n")
}

// =============================================================================
// TEXT TO JPEG CONVERTER
// =============================================================================

// TextToJPEGConverter chuyển đổi văn bản thô (.txt) thành các trang ảnh JPEG
type TextToJPEGConverter struct {
	imgConverter *ImageToJPEGConverter
	pdfConverter *PDFToJPEGConverter
	title        string
}

// NewTextToJPEGConverter khởi tạo TextToJPEGConverter
func NewTextToJPEGConverter(imgConv *ImageToJPEGConverter, pdfConv *PDFToJPEGConverter) *TextToJPEGConverter {
	if imgConv == nil {
		imgConv = NewImageToJPEGConverter(1600, 82)
	}
	if pdfConv == nil {
		pdfConv = NewPDFToJPEGConverter(150, 82)
	}
	return &TextToJPEGConverter{
		imgConverter: imgConv,
		pdfConverter: pdfConv,
		title:        "TÀI LIỆU VĂN BẢN TRÍCH XUẤT",
	}
}

// WithTitle đặt tiêu đề văn bản trên trang
func (c *TextToJPEGConverter) WithTitle(title string) *TextToJPEGConverter {
	c.title = title
	return c
}

// Convert chuyển đổi trang đầu tiên của văn bản sang JPEG
func (c *TextToJPEGConverter) Convert(ctx context.Context, raw []byte) ([]byte, error) {
	pages, err := c.ConvertPages(ctx, raw)
	if err != nil {
		return nil, err
	}
	if len(pages) == 0 {
		return nil, fmt.Errorf("không có trang ảnh nào được tạo ra từ văn bản")
	}
	return pages[0], nil
}

// ConvertPages lọc số thô, dàn trang văn bản và xuất thành danh sách các trang ảnh JPEG
func (c *TextToJPEGConverter) ConvertPages(ctx context.Context, raw []byte) ([][]byte, error) {
	if len(raw) == 0 {
		return nil, fmt.Errorf("dữ liệu văn bản thô rỗng")
	}

	// 1. Lọc sạch số thô, timestamps và ký tự rác
	cleaned := CleanRawText(string(raw))
	if strings.TrimSpace(cleaned) == "" {
		cleaned = string(raw) // fallback nếu đã là văn bản sạch sẵn
	}

	// 2. Chuyển văn bản thành PDF
	pdfBytes, errPDF := c.renderTextToPDF(ctx, cleaned)
	if errPDF != nil {
		return nil, fmt.Errorf("dàn trang văn bản sang PDF thất bại: %w", errPDF)
	}

	// 3. Xuất toàn bộ các trang PDF thành ảnh JPEG
	return c.pdfConverter.ConvertPages(ctx, pdfBytes)
}

// renderTextToPDF chuyển đổi văn bản thành PDF (ưu tiên Typst, fallback LibreOffice)
func (c *TextToJPEGConverter) renderTextToPDF(ctx context.Context, textContent string) ([]byte, error) {
	tmpDir, err := os.MkdirTemp("", "quin_text_pdf_*")
	if err != nil {
		return nil, fmt.Errorf("tạo thư mục tạm thất bại: %w", err)
	}
	defer func() {
		if rmErr := os.RemoveAll(tmpDir); rmErr != nil {
			log.Printf("[TextToJPEGConverter] Dọn dẹp thư mục tạm %s thất bại: %v", tmpDir, rmErr)
		}
	}()

	// Phương án 1: Nếu tìm thấy Typst (tự động phát hiện typst.exe đi kèm bộ cài Wails hoặc trong PATH)
	if typstBin := ResolveTypst(); typstBin != "" {
		pdfBytes, errTypst := c.renderWithTypst(ctx, tmpDir, textContent, typstBin)
		if errTypst == nil && len(pdfBytes) > 0 {
			return pdfBytes, nil
		}
		log.Printf("[TextToJPEGConverter] Typst gặp lỗi (%v), chuyển sang LibreOffice...", errTypst)
	}

	// Phương án 2: Sử dụng LibreOffice headless với định dạng HTML tối ưu mật độ chữ (1 cột duy nhất, đọc từ trên xuống dưới)
	officeBin := ResolveLibreOffice()
	if officeBin == "" {
		return nil, fmt.Errorf("không tìm thấy công cụ dàn trang (cần Typst đóng gói kèm app hoặc LibreOffice trên hệ thống)")
	}

	htmlFile := filepath.Join(tmpDir, "document.html")
	var htmlBuilder strings.Builder
	htmlBuilder.WriteString(`<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  @page {
    size: A4;
    margin: 1.2cm 1.5cm 1.2cm 1.5cm;
  }
  body {
    font-family: "DejaVu Sans", "Liberation Sans", "Arial", sans-serif;
    font-size: 10pt;
    line-height: 1.35;
    color: #111111;
  }
  h2 {
    text-align: center;
    font-size: 12.5pt;
    font-weight: bold;
    margin-top: 0;
    margin-bottom: 8px;
    padding-bottom: 4px;
    border-bottom: 1px solid #cccccc;
  }
  p {
    margin-top: 0;
    margin-bottom: 6px;
    text-align: justify;
    text-indent: 1.2em;
  }
</style>
</head>
<body>
`)
	if c.title != "" {
		htmlBuilder.WriteString(fmt.Sprintf("<h2>%s</h2>\n", html.EscapeString(c.title)))
	}

	paras := strings.Split(textContent, "\n\n")
	for _, p := range paras {
		p = strings.TrimSpace(p)
		if p == "" {
			continue
		}
		htmlBuilder.WriteString(fmt.Sprintf("<p>%s</p>\n", html.EscapeString(p)))
	}
	htmlBuilder.WriteString("</body>\n</html>")

	if errWrite := os.WriteFile(htmlFile, []byte(htmlBuilder.String()), 0644); errWrite != nil {
		return nil, fmt.Errorf("ghi file html tạm thất bại: %w", errWrite)
	}

	userInstall := fmt.Sprintf("-env:UserInstallation=file://%s/LibO_Profile", tmpDir)
	args := []string{
		"--headless",
		"--invisible",
		"--nologo",
		"--nodefault",
		"--nofirststartwizard",
		userInstall,
		"--convert-to", "pdf",
		"--outdir", tmpDir,
		htmlFile,
	}

	cmd := exec.CommandContext(ctx, officeBin, args...)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if errRun := cmd.Run(); errRun != nil {
		return nil, fmt.Errorf("libreoffice render text sang pdf thất bại: %w (stderr: %s)", errRun, stderr.String())
	}

	outPDF := filepath.Join(tmpDir, "document.pdf")
	pdfBytes, errRead := os.ReadFile(outPDF)
	if errRead != nil {
		return nil, fmt.Errorf("đọc file pdf kết quả %s thất bại: %w", outPDF, errRead)
	}

	return pdfBytes, nil
}

// renderWithTypst dàn trang văn bản bằng Typst CLI (1 cột duy nhất, không chia cột)
func (c *TextToJPEGConverter) renderWithTypst(ctx context.Context, tmpDir, textContent, typstBin string) ([]byte, error) {
	var sb strings.Builder
	sb.WriteString(`#set page(paper: "a4", margin: (x: 1.5cm, y: 1.2cm), numbering: "1")
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans"), size: 10pt, lang: "vi")
#set par(justify: true, leading: 0.65em, first-line-indent: 1.2em)

#align(center)[
  #text(size: 13pt, weight: "bold")[` + c.title + `]
]
#v(0.5em)
#line(length: 100%, stroke: 0.5pt + gray)
#v(0.5em)

`)

	paras := strings.Split(textContent, "\n\n")
	for _, p := range paras {
		p = strings.TrimSpace(p)
		if p == "" {
			continue
		}
		escaped := strings.ReplaceAll(p, "#", "\\#")
		escaped = strings.ReplaceAll(escaped, "$", "\\$")
		sb.WriteString(escaped + "\n\n")
	}

	typFile := filepath.Join(tmpDir, "doc.typ")
	if errWrite := os.WriteFile(typFile, []byte(sb.String()), 0644); errWrite != nil {
		return nil, fmt.Errorf("ghi file typst tạm thất bại: %w", errWrite)
	}

	outPDF := filepath.Join(tmpDir, "doc.pdf")
	cmd := exec.CommandContext(ctx, typstBin, "compile", typFile, outPDF)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if errRun := cmd.Run(); errRun != nil {
		return nil, fmt.Errorf("typst compile thất bại: %w (stderr: %s)", errRun, stderr.String())
	}

	data, errFile := os.ReadFile(outPDF)
	if errFile != nil {
		return nil, fmt.Errorf("đọc file pdf từ typst thất bại: %w", errFile)
	}
	return data, nil
}
