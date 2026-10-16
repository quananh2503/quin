package document

import (
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
)

type OfficeConverter struct {
	Command string
}

func NewOfficeConverter(command string) *OfficeConverter {
	if strings.TrimSpace(command) == "" {
		command = "soffice"
	}
	return &OfficeConverter{Command: command}
}

func (c *OfficeConverter) ConvertWordToPDF(ctx context.Context, docxStream io.Reader) (io.ReadCloser, error) {
	if strings.TrimSpace(c.Command) == "" {
		return nil, errors.New("chưa cấu hình trình chuyển đổi Word")
	}
	dir, err := os.MkdirTemp("", "docx-convert-*")
	if err != nil {
		return nil, err
	}
	input := filepath.Join(dir, "source.docx")
	if err := writeStream(input, docxStream); err != nil {
		os.RemoveAll(dir)
		return nil, err
	}
	cmd := exec.CommandContext(ctx, c.Command, "--headless", "--convert-to", "pdf", "--outdir", dir, input)
	output, err := cmd.CombinedOutput()
	if err != nil {
		os.RemoveAll(dir)
		return nil, fmt.Errorf("chuyển DOCX sang PDF thất bại: %w (%s)", err, strings.TrimSpace(string(output)))
	}
	pdfPath := filepath.Join(dir, "source.pdf")
	file, err := os.Open(pdfPath)
	if err != nil {
		os.RemoveAll(dir)
		return nil, fmt.Errorf("trình chuyển đổi không tạo PDF: %w", err)
	}
	return &temporaryReadCloser{ReadCloser: file, dir: dir}, nil
}

type PopplerProcessor struct {
	PDFInfo     string
	PDFToPPM    string
	PDFSeparate string
	PDFUnite    string
}

func NewPopplerProcessor() *PopplerProcessor {
	return &PopplerProcessor{PDFInfo: "pdfinfo", PDFToPPM: "pdftoppm", PDFSeparate: "pdfseparate", PDFUnite: "pdfunite"}
}

// RenderPagesToDisk is retained for the AI flow, which only invokes it after
// the user has explicitly selected pages. Upload itself uses PageCount and
// lazy RenderPageToDisk instead.
func (p *PopplerProcessor) RenderPagesToDisk(ctx context.Context, pdfFilePath, outputDir string) (int, []string, error) {
	if err := os.MkdirAll(outputDir, 0755); err != nil {
		return 0, nil, err
	}
	count, err := p.PageCount(ctx, pdfFilePath)
	if err != nil {
		return 0, nil, err
	}
	prefix := filepath.Join(outputDir, "page")
	cmd := exec.CommandContext(ctx, p.PDFToPPM, "-png", "-r", "144", pdfFilePath, prefix)
	if output, err := cmd.CombinedOutput(); err != nil {
		return 0, nil, fmt.Errorf("render PDF thất bại: %w (%s)", err, strings.TrimSpace(string(output)))
	}
	paths := make([]string, 0, count)
	for page := 1; page <= count; page++ {
		path := fmt.Sprintf("%s-%02d.png", prefix, page)
		if _, err := os.Stat(path); err != nil {
			path = fmt.Sprintf("%s-%d.png", prefix, page)
		}
		if _, err := os.Stat(path); err != nil {
			return 0, nil, fmt.Errorf("không tìm thấy ảnh trang %d: %w", page, err)
		}
		paths = append(paths, path)
	}
	return count, paths, nil
}

func (p *PopplerProcessor) RenderPageToDisk(ctx context.Context, pdfFilePath string, page int, outputPath string) error {
	if page < 1 {
		return fmt.Errorf("số trang không hợp lệ: %d", page)
	}
	if err := os.MkdirAll(filepath.Dir(outputPath), 0755); err != nil {
		return err
	}
	// JPEG thumbnail 1000px đủ đọc trong UI, nhanh và nhỏ hơn PNG 144 DPI rất nhiều.
	cmd := exec.CommandContext(ctx, p.PDFToPPM,
		"-jpeg", "-jpegopt", "quality=75", "-scale-to", "1000",
		"-f", strconv.Itoa(page), "-l", strconv.Itoa(page), "-singlefile",
		pdfFilePath, strings.TrimSuffix(outputPath, filepath.Ext(outputPath)))
	if output, err := cmd.CombinedOutput(); err != nil {
		return fmt.Errorf("render preview trang %d thất bại: %w (%s)", page, err, strings.TrimSpace(string(output)))
	}
	if _, err := os.Stat(outputPath); err != nil {
		return fmt.Errorf("không tạo được preview trang %d: %w", page, err)
	}
	return nil
}

func (p *PopplerProcessor) ExtractPagesToFile(ctx context.Context, srcPDFPath, destPDFPath string, pages []int) error {
	if len(pages) == 0 {
		return errors.New("danh sách trang không được để trống")
	}
	dir, err := os.MkdirTemp("", "pdf-split-*")
	if err != nil {
		return err
	}
	defer os.RemoveAll(dir)
	parts := make([]string, 0, len(pages))
	for index, page := range pages {
		if page < 1 {
			return fmt.Errorf("số trang không hợp lệ: %d", page)
		}
		part := filepath.Join(dir, fmt.Sprintf("part-%04d.pdf", index))
		cmd := exec.CommandContext(ctx, p.PDFSeparate, "-f", strconv.Itoa(page), "-l", strconv.Itoa(page), srcPDFPath, part)
		if output, err := cmd.CombinedOutput(); err != nil {
			return fmt.Errorf("tách trang %d thất bại: %w (%s)", page, err, strings.TrimSpace(string(output)))
		}
		parts = append(parts, part)
	}
	if err := os.MkdirAll(filepath.Dir(destPDFPath), 0755); err != nil {
		return err
	}
	cmd := exec.CommandContext(ctx, p.PDFUnite, append(parts, destPDFPath)...)
	if output, err := cmd.CombinedOutput(); err != nil {
		return fmt.Errorf("gộp các trang PDF thất bại: %w (%s)", err, strings.TrimSpace(string(output)))
	}
	return nil
}

func (p *PopplerProcessor) PageCount(ctx context.Context, path string) (int, error) {
	output, err := exec.CommandContext(ctx, p.PDFInfo, path).Output()
	if err != nil {
		return 0, fmt.Errorf("đọc thông tin PDF thất bại: %w", err)
	}
	for _, line := range strings.Split(string(output), "\n") {
		parts := strings.SplitN(line, ":", 2)
		if len(parts) == 2 && strings.TrimSpace(parts[0]) == "Pages" {
			count, err := strconv.Atoi(strings.TrimSpace(parts[1]))
			if err != nil || count < 1 {
				break
			}
			return count, nil
		}
	}
	return 0, errors.New("PDF không có thông tin số trang")
}

func writeStream(path string, reader io.Reader) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	if _, err := io.Copy(file, reader); err != nil {
		file.Close()
		return err
	}
	return file.Close()
}

type temporaryReadCloser struct {
	io.ReadCloser
	dir string
}

func (r *temporaryReadCloser) Close() error {
	err := r.ReadCloser.Close()
	removeErr := os.RemoveAll(r.dir)
	if err != nil {
		return err
	}
	return removeErr
}

var _ interface {
	ConvertWordToPDF(context.Context, io.Reader) (io.ReadCloser, error)
} = (*OfficeConverter)(nil)

var _ interface {
	PageCount(context.Context, string) (int, error)
	RenderPageToDisk(context.Context, string, int, string) error
	ExtractPagesToFile(context.Context, string, string, []int) error
} = (*PopplerProcessor)(nil)
