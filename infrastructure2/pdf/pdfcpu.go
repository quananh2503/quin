package pdf

import (
	"bytes"
	"context"
	"fmt"
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

// ExtractPages dùng pdfcpu cắt các trang thành []byte trong RAM
func (p *PDFProcessor) ExtractPages(ctx context.Context, filePath string, pages []int) ([]byte, error) {
	if len(pages) == 0 {
		return nil, fmt.Errorf("danh sách trang không được để trống")
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
