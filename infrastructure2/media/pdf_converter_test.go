package media_test

import (
	"context"
	"os"
	"path/filepath"
	"testing"
	"time"

	"meet-attendance-clean/infrastructure2/media"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// =============================================================================
// INTEGRATION TESTS: PDF TO JPEG CONVERTER
// =============================================================================

func TestPDFToJPEGConverter_Integration_RealPDF(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()

	pdfPath := filepath.Join("..", "gemini", "pdfs", "tests", "testdothibbt.pdf")
	if _, errStat := os.Stat(pdfPath); errStat != nil {
		t.Skipf("Bỏ qua test vì không tìm thấy file PDF thử nghiệm: %s", pdfPath)
	}

	rawPDF, errRead := os.ReadFile(pdfPath)
	require.NoError(t, errRead)
	require.NotEmpty(t, rawPDF)

	pdfConverter := media.NewPDFToJPEGConverter(150, 82)

	startTime := time.Now()
	pages, err := pdfConverter.ConvertPages(ctx, rawPDF)
	elapsed := time.Since(startTime)

	require.NoError(t, err)
	assert.NotEmpty(t, pages, "Kỳ vọng sinh ra ít nhất 1 trang JPEG")
	assert.Less(t, elapsed, 10*time.Second, "Thời gian chuyển đổi PDF phải dưới 10 giây")

	// Đảm bảo từng trang đều là JPEG hợp lệ và có kích thước thực tế
	for i, page := range pages {
		assert.Greater(t, len(page), 1000, "Trang %d phải có dung lượng > 1KB", i+1)
		assert.Equal(t, byte(0xFF), page[0], "Trang %d phải có JPEG magic byte 0", i+1)
		assert.Equal(t, byte(0xD8), page[1], "Trang %d phải có JPEG magic byte 1", i+1)
		assert.Equal(t, byte(0xFF), page[2], "Trang %d phải có JPEG magic byte 2", i+1)
	}

	// Kiểm tra Convert (trang đầu tiên)
	firstPage, errFirst := pdfConverter.Convert(ctx, rawPDF)
	require.NoError(t, errFirst)
	assert.Equal(t, pages[0], firstPage)
}

func TestPDFToJPEGConverter_InvalidInput(t *testing.T) {
	ctx := context.Background()
	pdfConverter := media.NewPDFToJPEGConverter(150, 82)

	_, errEmpty := pdfConverter.Convert(ctx, nil)
	assert.Error(t, errEmpty)

	_, errEmptyPages := pdfConverter.ConvertPages(ctx, nil)
	assert.Error(t, errEmptyPages)
}
