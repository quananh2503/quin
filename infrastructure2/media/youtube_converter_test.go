package media_test

import (
	"context"
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
// UNIT TESTS: YOUTUBE VIDEO ID EXTRACTOR
// =============================================================================

func TestExtractVideoID(t *testing.T) {
	cases := []struct {
		url      string
		expected string
	}{
		{"https://www.youtube.com/watch?v=cNDQkKzfsfw", "cNDQkKzfsfw"},
		{"https://youtu.be/cNDQkKzfsfw", "cNDQkKzfsfw"},
		{"https://www.youtube.com/embed/cNDQkKzfsfw", "cNDQkKzfsfw"},
		{"https://www.youtube.com/shorts/cNDQkKzfsfw", "cNDQkKzfsfw"},
		{"cNDQkKzfsfw", "cNDQkKzfsfw"},
		{"https://www.youtube.com/watch?v=cNDQkKzfsfw&t=120s", "cNDQkKzfsfw"},
		{"https://example.com/watch?v=cNDQkKzfsfw", ""},
		{"invalid-youtube-url", ""},
	}

	for _, tc := range cases {
		t.Run(tc.url, func(t *testing.T) {
			actual := media.ExtractVideoID(tc.url)
			assert.Equal(t, tc.expected, actual)
		})
	}
}

// =============================================================================
// INTEGRATION TESTS: YOUTUBE REAL LINK (https://www.youtube.com/watch?v=cNDQkKzfsfw)
// =============================================================================

func TestYouTubeToJPEGConverter_Integration_RealLink(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	rawURL := "https://www.youtube.com/watch?v=cNDQkKzfsfw"
	outputDir := filepath.Join("output")
	errMk := os.MkdirAll(outputDir, 0755)
	require.NoError(t, errMk)

	converter := media.NewYouTubeToJPEGConverter(nil, nil)

	t.Logf("🚀 Đang cào phụ đề và chuyển đổi video YouTube: %s", rawURL)
	startTime := time.Now()

	// 1. Cào transcript -> Lưu file .txt thô -> Lọc số thô -> Xuất các trang JPEG
	savedImages, txtPath, err := converter.ConvertYouTubeAndSaveRaw(ctx, rawURL, outputDir)
	elapsed := time.Since(startTime)

	require.NoError(t, err, "Quá trình cào và chuyển đổi YouTube transcript thất bại")
	require.NotEmpty(t, txtPath, "Phải sinh ra file transcript .txt thô")
	require.NotEmpty(t, savedImages, "Phải sinh ra ít nhất 1 trang JPEG")

	// 2. Kiểm tra file .txt thô đã ghi xuống đĩa
	txtInfo, errTxtStat := os.Stat(txtPath)
	require.NoError(t, errTxtStat, "File transcript .txt phải tồn tại trên đĩa: %s", txtPath)
	assert.Greater(t, txtInfo.Size(), int64(1000), "File .txt phải có dung lượng > 1KB")

	t.Logf("✅ [1/2] Đã lưu file transcript thô: %s (%.1f KB)", filepath.Base(txtPath), float64(txtInfo.Size())/1024)
	t.Logf("✅ [2/2] Đã sinh %d trang JPEG trong %v:", len(savedImages), elapsed)

	// 3. Kiểm tra từng file ảnh JPEG đã ghi xuống đĩa
	for idx, imgPath := range savedImages {
		imgInfo, errImgStat := os.Stat(imgPath)
		require.NoError(t, errImgStat, "File ảnh %s phải tồn tại trên đĩa", imgPath)
		assert.Greater(t, imgInfo.Size(), int64(1000), "Ảnh trang %d phải > 1KB", idx+1)

		// Kiểm tra magic bytes JPEG thực tế (\xff\xd8\xff)
		data, errRead := os.ReadFile(imgPath)
		require.NoError(t, errRead)
		require.GreaterOrEqual(t, len(data), 3)
		assert.Equal(t, byte(0xFF), data[0], "Magic byte 0 phải là 0xFF")
		assert.Equal(t, byte(0xD8), data[1], "Magic byte 1 phải là 0xD8")
		assert.Equal(t, byte(0xFF), data[2], "Magic byte 2 phải là 0xFF")

		t.Logf("   ↳ Trang %02d: %s (%.1f KB)", idx+1, filepath.Base(imgPath), float64(imgInfo.Size())/1024)
	}
}

func TestConverter_Integration_YouTubeSourceDocument(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	rawURL := "https://www.youtube.com/watch?v=cNDQkKzfsfw"
	outputDir := filepath.Join("output")

	doc := document.NewSourceDocument("youtube_tich_phan_thay_tien")
	doc.SetStoragePath(rawURL)
	doc.SetFileType(document.FileTypeYOUTUBE)

	converter := media.NewConverter()
	savedImages, err := converter.ConvertAndSaveToDir(ctx, doc, outputDir)
	require.NoError(t, err, "ConvertAndSaveToDir với SourceDocument YouTube thất bại")
	require.NotEmpty(t, savedImages)
	assert.GreaterOrEqual(t, len(savedImages), 1)
}
