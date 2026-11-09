package media_test

import (
	"context"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"meet-attendance-clean/domain2/document"
	"meet-attendance-clean/infrastructure2/media"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// =============================================================================
// INTEGRATION TESTS: REAL FILES BATCH CONVERT & DETECT (NO HARDCODING)
// =============================================================================

func TestConverter_Integration_BatchFolderScanRealFiles(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	inputDir := filepath.Join("files")
	outputDir := filepath.Join("output")

	// Đảm bảo thư mục output tồn tại
	errMk := os.MkdirAll(outputDir, 0755)
	require.NoError(t, errMk)

	entries, errRead := os.ReadDir(inputDir)
	require.NoError(t, errRead, "Thư mục files/ phải tồn tại")
	require.NotEmpty(t, entries, "Thư mục files/ phải chứa các file kiểm thử")

	detector := media.NewTypeDetector()
	converter := media.NewConverter()

	var totalConvertedFiles int
	var totalJPEGPagesGenerated int

	t.Logf("🚀 BẮT ĐẦU QUÉT BATCH THƯ MỤC THỰC TẾ: %s", inputDir)

	for _, entry := range entries {
		if entry.IsDir() || strings.HasPrefix(entry.Name(), ".") {
			continue
		}

		filePath := filepath.Join(inputDir, entry.Name())
		startTime := time.Now()

		// 1. Quét nhận diện loại file động bằng hàm Detect (KHÔNG HARDCODE)
		fileType, errDetect := detector.Detect(ctx, filePath)
		require.NoError(t, errDetect, "Nhận diện định dạng file %s thất bại", entry.Name())
		require.NotEqual(t, document.FileTypeUnknown, fileType, "File %s không được nhận diện là Unknown", entry.Name())

		t.Logf("📂 [%d] File: %-55s -> Nhận diện: %s", totalConvertedFiles+1, entry.Name(), fileType)

		// 2. Tạo SourceDocument đại diện
		doc := document.NewSourceDocument(entry.Name())
		doc.SetStoragePath(filePath)
		doc.SetFileType(fileType)

		// 3. Chuyển đổi và lưu thẳng các trang JPEG xuống thư mục output
		savedPaths, errConvert := converter.ConvertAndSaveToDir(ctx, doc, outputDir)
		elapsed := time.Since(startTime)
		require.NoError(t, errConvert, "Chuyển đổi file %s sang JPEG thất bại", entry.Name())
		require.NotEmpty(t, savedPaths, "File %s phải sinh ra ít nhất 1 trang JPEG", entry.Name())

		totalConvertedFiles++
		totalJPEGPagesGenerated += len(savedPaths)

		t.Logf("   ✅ Đã sinh %d trang JPEG trong %v:", len(savedPaths), elapsed)

		// 4. Kiểm tra từng file JPEG vừa được ghi xuống đĩa
		for idx, p := range savedPaths {
			info, errStat := os.Stat(p)
			require.NoError(t, errStat, "File ảnh đã lưu %s phải tồn tại trên đĩa", p)
			assert.Greater(t, info.Size(), int64(1000), "Ảnh trang %d của file %s phải > 1KB", idx+1, entry.Name())

			// Kiểm tra magic bytes JPEG thực tế (\xff\xd8\xff)
			data, errFile := os.ReadFile(p)
			require.NoError(t, errFile, "Đọc file ảnh %s thất bại", p)
			require.GreaterOrEqual(t, len(data), 3)
			assert.Equal(t, byte(0xFF), data[0], "Trang %s phải có magic byte 0", filepath.Base(p))
			assert.Equal(t, byte(0xD8), data[1], "Trang %s phải có magic byte 1", filepath.Base(p))
			assert.Equal(t, byte(0xFF), data[2], "Trang %s phải có magic byte 2", filepath.Base(p))

			t.Logf("      ↳ Trang %02d: %s (%.1f KB)", idx+1, filepath.Base(p), float64(info.Size())/1024)
		}
	}

	t.Logf("\n🎉 TỔNG KẾT BATCH:")
	t.Logf("   • Tổng số file đầu vào thực tế đã xử lý: %d", totalConvertedFiles)
	t.Logf("   • Tổng số trang JPEG đã ghi vào output/:   %d", totalJPEGPagesGenerated)

	assert.GreaterOrEqual(t, totalConvertedFiles, 4, "Phải quét và xử lý tối thiểu 4 loại file thực tế")
	assert.GreaterOrEqual(t, totalJPEGPagesGenerated, 4, "Phải sinh ra tối thiểu 4 trang ảnh JPEG")

	// Đảm bảo thư mục output chứa các file hợp lệ (.jpg, .jpeg, hoặc .txt)
	outEntries, errOutRead := os.ReadDir(outputDir)
	require.NoError(t, errOutRead)
	assert.NotEmpty(t, outEntries)
	for _, oe := range outEntries {
		assert.True(t, strings.HasSuffix(oe.Name(), ".jpg") || strings.HasSuffix(oe.Name(), ".jpeg") || strings.HasSuffix(oe.Name(), ".txt"),
			"Tất cả file trong thư mục output phải là ảnh JPG hoặc transcript TXT: %s", oe.Name())
	}
}
