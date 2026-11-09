package media_test

import (
	"context"
	"os"
	"os/exec"
	"path/filepath"
	"testing"
	"time"

	"meet-attendance-clean/infrastructure2/media"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// =============================================================================
// INTEGRATION TESTS: DOCX TO JPEG CONVERTER
// =============================================================================

func TestDocxToJPEGConverter_Integration_RealDocx(t *testing.T) {
	// Kiểm tra xem máy có soffice hoặc libreoffice không
	hasOffice := false
	if _, err := exec.LookPath("soffice"); err == nil {
		hasOffice = true
	} else if _, err2 := exec.LookPath("libreoffice"); err2 == nil {
		hasOffice = true
	}
	if !hasOffice {
		t.Skip("Bỏ qua test vì môi trường không cài đặt soffice/libreoffice")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()

	docxPath := filepath.Join("files", "de_thi_toan_sample.docx")
	if _, errStat := os.Stat(docxPath); errStat != nil {
		t.Skipf("Bỏ qua test vì không tìm thấy file docx mẫu: %s", docxPath)
	}

	rawDocx, errRead := os.ReadFile(docxPath)
	require.NoError(t, errRead)
	require.NotEmpty(t, rawDocx)

	docxConverter := media.NewDocxToJPEGConverter(nil)

	startTime := time.Now()
	pages, err := docxConverter.ConvertPages(ctx, rawDocx)
	elapsed := time.Since(startTime)

	require.NoError(t, err)
	assert.NotEmpty(t, pages, "Kỳ vọng sinh ra ít nhất 1 trang JPEG từ file docx")
	assert.Less(t, elapsed, 10*time.Second, "Chuyển đổi Docx sang JPEG phải dưới 10 giây")

	for i, page := range pages {
		assert.Greater(t, len(page), 1000, "Trang %d phải có dung lượng > 1KB", i+1)
		assert.Equal(t, byte(0xFF), page[0], "Trang %d phải có JPEG magic byte 0", i+1)
		assert.Equal(t, byte(0xD8), page[1], "Trang %d phải có JPEG magic byte 1", i+1)
		assert.Equal(t, byte(0xFF), page[2], "Trang %d phải có JPEG magic byte 2", i+1)
	}

	// Test Convert (trang đầu tiên)
	firstPage, errFirst := docxConverter.Convert(ctx, rawDocx)
	require.NoError(t, errFirst)
	assert.Equal(t, pages[0], firstPage)
}

func TestDocxToJPEGConverter_InvalidInput(t *testing.T) {
	ctx := context.Background()
	docxConverter := media.NewDocxToJPEGConverter(nil)

	_, errEmpty := docxConverter.Convert(ctx, nil)
	assert.Error(t, errEmpty)

	_, errEmptyPages := docxConverter.ConvertPages(ctx, nil)
	assert.Error(t, errEmptyPages)
}
