package media_test

import (
	"context"
	"image/color"
	"os"
	"path/filepath"
	"testing"
	"time"

	"meet-attendance-clean/domain2/document"
	"meet-attendance-clean/infrastructure2/media"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// =============================================================================
// UNIT & COMPONENT TESTS: CONVERTER ORCHESTRATOR
// =============================================================================

func TestConverter_Integration_SourceDocument(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	converter := media.NewConverter()

	// 1. Test với tài liệu dạng Ảnh PNG
	tmpDir := t.TempDir()
	pngPath := filepath.Join(tmpDir, "de_toan.png")
	pngBytes := createSamplePNG(t, 400, 300, color.RGBA{R: 120, G: 80, B: 200, A: 255})
	errWrite := os.WriteFile(pngPath, pngBytes, 0644)
	require.NoError(t, errWrite)

	docPNG := document.NewSourceDocument("de_toan.png")
	docPNG.SetStoragePath(pngPath)

	jpegBytes, errDocPNG := converter.ConvertToJpeg(ctx, docPNG)
	require.NoError(t, errDocPNG)
	require.NotEmpty(t, jpegBytes)
	assert.Equal(t, byte(0xFF), jpegBytes[0])
	assert.Equal(t, byte(0xD8), jpegBytes[1])

	// Alias ConvertToJepg
	jpegAlias, errAlias := converter.ConvertToJepg(ctx, docPNG)
	require.NoError(t, errAlias)
	assert.Equal(t, jpegBytes, jpegAlias)

	// 2. Test với tài liệu PDF thực tế
	pdfPath := filepath.Join("..", "gemini", "pdfs", "tests", "testdothibbt.pdf")
	if _, errStat := os.Stat(pdfPath); errStat == nil {
		docPDF := document.NewSourceDocument("testdothibbt.pdf")
		docPDF.SetStoragePath(pdfPath)

		pages, errDocPDF := converter.ConvertToJPEGPages(ctx, docPDF)
		require.NoError(t, errDocPDF)
		assert.NotEmpty(t, pages)
		assert.GreaterOrEqual(t, len(pages), 1)
	}
}

func TestConverter_ErrorCases(t *testing.T) {
	ctx := context.Background()
	converter := media.NewConverter()

	// Nil SourceDocument
	_, errNil := converter.ConvertToJpeg(ctx, nil)
	assert.Error(t, errNil)

	// Document chưa có storagePath
	emptyDoc := document.NewSourceDocument("empty.pdf")
	_, errNoPath := converter.ConvertToJpeg(ctx, emptyDoc)
	assert.Error(t, errNoPath)

	// ConvertRawToJpeg với bytes rỗng
	_, errEmptyRaw := converter.ConvertRawToJpeg(ctx, nil, "empty.jpg")
	assert.Error(t, errEmptyRaw)

	// SaveJPEGPagesToDir với mảng rỗng
	_, errEmptyPages := media.SaveJPEGPagesToDir(nil, t.TempDir(), "empty")
	assert.Error(t, errEmptyPages)
}
