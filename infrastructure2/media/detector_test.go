package media_test

import (
	"context"
	"image/color"
	"os"
	"path/filepath"
	"testing"

	"meet-attendance-clean/domain2/document"
	"meet-attendance-clean/infrastructure2/media"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// =============================================================================
// UNIT TESTS: TYPE DETECTOR
// =============================================================================

func TestTypeDetector_DetectBytes_MagicBytes(t *testing.T) {
	ctx := context.Background()
	detector := media.NewTypeDetector()

	cases := []struct {
		name     string
		raw      []byte
		fileName string
		expected document.FileType
	}{
		{
			name:     "PDF Magic Bytes",
			raw:      []byte("%PDF-1.7 header content"),
			fileName: "document.pdf",
			expected: document.FileTypePDF,
		},
		{
			name:     "PNG Magic Bytes",
			raw:      []byte{0x89, 'P', 'N', 'G', 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00},
			fileName: "photo.png",
			expected: document.FileTypePNG,
		},
		{
			name:     "JPEG Magic Bytes",
			raw:      []byte{0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10},
			fileName: "scan.jpg",
			expected: document.FileTypeJPEG,
		},
		{
			name:     "WebP Magic Bytes",
			raw:      []byte("RIFF1234WEBPVP8 "),
			fileName: "graphic.webp",
			expected: document.FileTypeWEBP,
		},
		{
			name:     "GIF Magic Bytes",
			raw:      []byte("GIF89a..."),
			fileName: "animation.gif",
			expected: document.FileTypeGIF,
		},
		{
			name:     "BMP Magic Bytes",
			raw:      []byte("BM123456"),
			fileName: "bitmap.bmp",
			expected: document.FileTypeBMP,
		},
		{
			name:     "DOCX Magic Bytes",
			raw:      []byte{0x50, 0x4B, 0x03, 0x04, 0x14, 0x00},
			fileName: "document.docx",
			expected: document.FileTypeDOCX,
		},
		{
			name:     "DOC OLE2 Magic Bytes",
			raw:      []byte{0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1},
			fileName: "legacy.doc",
			expected: document.FileTypeDOCX,
		},
		{
			name:     "Fallback theo extension khi bytes trống",
			raw:      []byte("plain text"),
			fileName: "notes.docx",
			expected: document.FileTypeDOCX,
		},
		{
			name:     "Unknown format",
			raw:      []byte{0x01, 0x02, 0x03, 0x04},
			fileName: "archive.xyz",
			expected: document.FileTypeUnknown,
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			ft, err := detector.DetectBytes(ctx, tc.raw, tc.fileName)
			assert.NoError(t, err)
			assert.Equal(t, tc.expected, ft)
		})
	}
}

func TestTypeDetector_Detect_FromDisk(t *testing.T) {
	ctx := context.Background()
	detector := media.NewTypeDetector()

	tmpDir := t.TempDir()
	pngPath := filepath.Join(tmpDir, "test.png")
	pngBytes := createSamplePNG(t, 10, 10, color.RGBA{R: 255, A: 255})
	errWrite := os.WriteFile(pngPath, pngBytes, 0644)
	require.NoError(t, errWrite)

	ft, err := detector.Detect(ctx, pngPath)
	assert.NoError(t, err)
	assert.Equal(t, document.FileTypePNG, ft)

	// Lỗi file không tồn tại
	_, errMissing := detector.Detect(ctx, filepath.Join(tmpDir, "non_existent.pdf"))
	assert.Error(t, errMissing)

	// Lỗi path rỗng
	_, errEmpty := detector.Detect(ctx, "")
	assert.Error(t, errEmpty)
}
