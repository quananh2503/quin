package pdf

import (
	"bytes"
	"context"
	"fmt"
	"io"
	"meet-attendance-clean/infrastructure2/gemini"
	"os"
	"sort"
	"strconv"

	"github.com/pdfcpu/pdfcpu/pkg/api"
	"github.com/pdfcpu/pdfcpu/pkg/pdfcpu/model"
)

type PDFProcessor struct{}

func NewProcessor() *PDFProcessor {
	return &PDFProcessor{}
}

var _ gemini.PDFProcessor = (*PDFProcessor)(nil)

// ExtractPages returns the requested pages as a PDF. An empty page list means
// the entire source document, matching lesson.NewFullPDFMaterial.
func (p *PDFProcessor) ExtractPages(ctx context.Context, filePath string, pages []int) ([]byte, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}

	// A full document must not go through pdfcpu.Trim: it requires an explicit
	// page selection. This is the normal path when users select one or more
	// PDFs from the lesson screen without selecting individual pages.
	if len(pages) == 0 {
		srcFile, err := os.Open(filePath)
		if err != nil {
			return nil, fmt.Errorf("không thể mở file PDF: %w", err)
		}
		defer srcFile.Close()

		var outputBuffer bytes.Buffer
		if _, err := io.Copy(&outputBuffer, srcFile); err != nil {
			return nil, fmt.Errorf("không thể đọc file PDF: %w", err)
		}
		if err := ctx.Err(); err != nil {
			return nil, err
		}
		return outputBuffer.Bytes(), nil
	}

	// 1. Lọc trùng và sắp xếp trang
	uniquePages := make(map[int]bool)
	for _, page := range pages {
		uniquePages[page] = true
	}
	sortedPages := make([]int, 0, len(uniquePages))
	for page := range uniquePages {
		sortedPages = append(sortedPages, page)
	}
	sort.Ints(sortedPages)

	pageStrList := make([]string, len(sortedPages))
	for i, page := range sortedPages {
		pageStrList[i] = strconv.Itoa(page)
	}

	// 2. Mở file PDF gốc
	srcFile, err := os.Open(filePath)
	if err != nil {
		return nil, fmt.Errorf("không thể mở file PDF: %w", err)
	}
	defer srcFile.Close()

	// 3. Trim thẳng vào RAM buffer
	var outputBuffer bytes.Buffer
	conf := model.NewDefaultConfiguration()
	err = api.Trim(srcFile, &outputBuffer, pageStrList, conf)
	if err != nil {
		return nil, fmt.Errorf("lỗi khi trích xuất trang bằng pdfcpu: %w", err)
	}

	return outputBuffer.Bytes(), nil
}

// PageCount đếm số trang nhanh bằng pdfcpu mà không cần mở toàn bộ file vào RAM
func (p *PDFProcessor) PageCount(ctx context.Context, filePath string) (int, error) {
	return api.PageCountFile(filePath)
}
