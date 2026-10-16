package application2

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"os"
	"sort"
	"strconv"
	"uuid"

	"github.com/pdfcpu/pdfcpu/pkg/api"
)

// ExtractPagesCommand nhận ID tài liệu và danh sách các trang giáo viên đã chọn
type ExtractPagesCommand struct {
	DocumentID uuid.UUID `json:"document_id"`
	Pages      []int     `json:"pages"` // Ví dụ: [1, 3, 5]
}

type ExtractPagesHandler struct {
	documentRepo DocumentRepository
}

func NewExtractPagesHandler(repo DocumentRepository) *ExtractPagesHandler {
	return &ExtractPagesHandler{
		documentRepo: repo,
	}
}

// Extract cắt các trang đã chọn và trả về []byte của file PDF mini
func (h *ExtractPagesHandler) Extract(ctx context.Context, cmd ExtractPagesCommand) ([]byte, error) {
	// BƯỚC 1: Validate dữ liệu đầu vào
	if len(cmd.Pages) == 0 {
		return nil, errors.New("danh sách trang chọn không được để trống")
	}

	// BƯỚC 2: Tìm tài liệu trong DB
	doc, err := h.documentRepo.GetByID(ctx, cmd.DocumentID)
	if err != nil {
		return nil, fmt.Errorf("không tìm thấy tài liệu: %w", err)
	}
	pageMap := make(map[int]bool)
	for _, p := range cmd.Pages {
		if p < 1 || p > doc.PageCount {
			return nil, fmt.Errorf("trang %d không hợp lệ (tài liệu chỉ có %d trang)", p, doc.PageCount)
		}
		pageMap[p] = true
	}

	sortedPages := make([]int, 0, len(pageMap))
	for p := range pageMap {
		sortedPages = append(sortedPages, p)
	}
	sort.Ints(sortedPages)

	pageStrList := make([]string, len(sortedPages))
	for i, p := range sortedPages {
		pageStrList[i] = strconv.Itoa(p)
	}

	srcFile, err := os.Open(doc.FilePath)
	if err != nil {
		return nil, fmt.Errorf("không thể mở file PDF gốc: %w", err)
	}
	defer srcFile.Close()

	var outputBuffer bytes.Buffer

	err = api.Trim(srcFile, &outputBuffer, pageStrList, nil)
	if err != nil {
		return nil, fmt.Errorf("lỗi khi trích xuất trang bằng pdfcpu: %w", err)
	}
	return outputBuffer.Bytes(), nil
}
