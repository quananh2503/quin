package media

import (
	"bytes"
	"context"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
)

// =============================================================================
// DOCX TO JPEG CONVERTER
// =============================================================================

// DocxToJPEGConverter chuyển đổi tài liệu Word (.docx/.doc) sang JPEG qua LibreOffice headless
type DocxToJPEGConverter struct {
	pdfConverter *PDFToJPEGConverter
}

// NewDocxToJPEGConverter khởi tạo DocxToJPEGConverter
func NewDocxToJPEGConverter(pdfConverter *PDFToJPEGConverter) *DocxToJPEGConverter {
	if pdfConverter == nil {
		pdfConverter = NewPDFToJPEGConverter(150, 82)
	}
	return &DocxToJPEGConverter{pdfConverter: pdfConverter}
}

// Convert chuyển đổi trang đầu tiên của file Docx sang JPEG
func (c *DocxToJPEGConverter) Convert(ctx context.Context, raw []byte) ([]byte, error) {
	pages, err := c.ConvertPages(ctx, raw)
	if err != nil {
		return nil, err
	}
	if len(pages) == 0 {
		return nil, fmt.Errorf("không có trang nào được sinh ra từ file docx")
	}
	return pages[0], nil
}

// ConvertPages chuyển đổi toàn bộ các trang tài liệu Docx sang danh sách các trang JPEG
func (c *DocxToJPEGConverter) ConvertPages(ctx context.Context, raw []byte) ([][]byte, error) {
	if len(raw) == 0 {
		return nil, fmt.Errorf("dữ liệu docx rỗng")
	}

	tmpDir, err := os.MkdirTemp("", "quin_docx_*")
	if err != nil {
		return nil, fmt.Errorf("tạo thư mục tạm thất bại: %w", err)
	}
	defer func() {
		if rmErr := os.RemoveAll(tmpDir); rmErr != nil {
			log.Printf("[DocxToJPEGConverter] Dọn dẹp thư mục tạm %s thất bại: %v", tmpDir, rmErr)
		}
	}()

	inputDocx := filepath.Join(tmpDir, "document.docx")
	if errWrite := os.WriteFile(inputDocx, raw, 0644); errWrite != nil {
		return nil, fmt.Errorf("ghi file docx tạm thất bại: %w", errWrite)
	}
	outPDF := filepath.Join(tmpDir, "document.pdf")

	// 1. Phương án ưu tiên: Sử dụng LibreOffice nếu tìm thấy (hỗ trợ cả Linux và Windows)
	officeBin := ResolveLibreOffice()
	if officeBin != "" {
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
			inputDocx,
		}

		cmd := exec.CommandContext(ctx, officeBin, args...)
		var stderr bytes.Buffer
		cmd.Stderr = &stderr
		if errRun := cmd.Run(); errRun == nil {
			if pdfBytes, errRead := os.ReadFile(outPDF); errRead == nil && len(pdfBytes) > 0 {
				return c.pdfConverter.ConvertPages(ctx, pdfBytes)
			}
		} else {
			log.Printf("[DocxToJPEGConverter] Chuyển đổi qua LibreOffice gặp lỗi: %v (stderr: %s)", errRun, stderr.String())
		}
	}

	// 2. Phương án dự phòng trên Windows: Gọi Microsoft Word ngầm qua PowerShell COM
	if runtime.GOOS == "windows" {
		if errWord := ConvertDocxWithWordOnWindows(ctx, inputDocx, outPDF); errWord == nil {
			if pdfBytes, errRead := os.ReadFile(outPDF); errRead == nil && len(pdfBytes) > 0 {
				return c.pdfConverter.ConvertPages(ctx, pdfBytes)
			}
		} else {
			log.Printf("[DocxToJPEGConverter] Chuyển đổi qua Microsoft Word gặp lỗi: %v", errWord)
		}
	}

	return nil, fmt.Errorf("không tìm thấy công cụ chuyển đổi DOCX (vui lòng cài đặt LibreOffice hoặc Microsoft Word trên máy)")
}
