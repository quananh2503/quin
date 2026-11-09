package gemini_test

import (
	"os"
	"path/filepath"
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestOptimizeScannedPDF_EmptyData(t *testing.T) {
	_, err := gemini.OptimizeScannedPDF(nil)
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "dữ liệu PDF rỗng")

	_, errEmpty := gemini.OptimizeScannedPDF([]byte{})
	assert.Error(t, errEmpty)
	assert.Contains(t, errEmpty.Error(), "dữ liệu PDF rỗng")
}

func TestOptimizeScannedPDF_SmallPDF_BypassesOptimization(t *testing.T) {
	fakeSmallPDF := []byte("%PDF-1.4 minimal test PDF data that is smaller than 10MB threshold")
	out, err := gemini.OptimizeScannedPDF(fakeSmallPDF)
	require.NoError(t, err)
	assert.Equal(t, fakeSmallPDF, out, "File nhỏ hơn 10MB phải được giữ nguyên bản 100%")
}

func TestOptimizeScannedPDF_DownloadsSample_IfAvailable(t *testing.T) {
	userProfile := os.Getenv("USERPROFILE")
	if userProfile == "" {
		t.Skip("Không tìm thấy USERPROFILE, bỏ qua bài test file thực tế")
	}

	samplePath := filepath.Join(userProfile, "Downloads", "Minh Thư tha6 ..pdf")
	if _, err := os.Stat(samplePath); os.IsNotExist(err) {
		t.Skip("Không tìm thấy file Minh Thư tha6 ..pdf trong Downloads, bỏ qua bài test file thực tế")
	}

	data, errRead := os.ReadFile(samplePath)
	require.NoError(t, errRead)
	require.Greater(t, len(data), gemini.ScannedPDFThreshold, "File mẫu phải lớn hơn ngưỡng 10MB")

	optBytes, errOpt := gemini.OptimizeScannedPDF(data)
	require.NoError(t, errOpt)
	require.NotEmpty(t, optBytes)
	assert.Less(t, len(optBytes), len(data), "Dung lượng sau khi nén phải giảm đáng kể so với file gốc")
	t.Logf("Nén thành công! Gốc: %d bytes (%.2f MB) -> Tối ưu: %d bytes (%.2f MB)",
		len(data), float64(len(data))/(1024*1024),
		len(optBytes), float64(len(optBytes))/(1024*1024))
}
