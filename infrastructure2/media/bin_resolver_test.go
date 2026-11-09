package media_test

import (
	"context"
	"os"
	"path/filepath"
	"runtime"
	"testing"
	"time"

	"meet-attendance-clean/infrastructure2/media"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestResolveExecutable_Empty(t *testing.T) {
	assert.Empty(t, media.ResolveExecutable(""))
	assert.Empty(t, media.ResolveExecutable("   "))
	assert.Empty(t, media.ResolveExecutable("non_existent_binary_xyz_12345"))
}

func TestResolveExecutable_CurrentDirAndBinDir(t *testing.T) {
	tmpDir := t.TempDir()

	// 1. Tạo file giả lập binary trong thư mục tmp
	mockBinName := "my_mock_tool"
	if runtime.GOOS == "windows" {
		mockBinName += ".exe"
	}
	mockBinPath := filepath.Join(tmpDir, mockBinName)
	errCreate := os.WriteFile(mockBinPath, []byte("echo mock"), 0755)
	require.NoError(t, errCreate)

	// Đổi working dir sang tmpDir
	origWd, errWd := os.Getwd()
	require.NoError(t, errWd)
	defer func() {
		if errRestore := os.Chdir(origWd); errRestore != nil {
			t.Logf("khôi phục working directory thất bại: %v", errRestore)
		}
	}()

	errChdir := os.Chdir(tmpDir)
	require.NoError(t, errChdir)

	// Kiểm tra resolve từ working dir
	resolved := media.ResolveExecutable("my_mock_tool")
	assert.NotEmpty(t, resolved)
	assert.Equal(t, mockBinPath, resolved)

	// 2. Kiểm tra tìm trong thư mục bin/
	binSubdir := filepath.Join(tmpDir, "bin")
	errMk := os.MkdirAll(binSubdir, 0755)
	require.NoError(t, errMk)

	mockSubBinName := "sub_tool"
	if runtime.GOOS == "windows" {
		mockSubBinName += ".exe"
	}
	mockSubPath := filepath.Join(binSubdir, mockSubBinName)
	errSub := os.WriteFile(mockSubPath, []byte("echo sub"), 0755)
	require.NoError(t, errSub)

	resolvedSub := media.ResolveExecutable("sub_tool")
	assert.NotEmpty(t, resolvedSub)
	assert.Equal(t, mockSubPath, resolvedSub)
}

func TestResolveTools(t *testing.T) {
	// Kiểm tra trên Linux hiện tại: các tool có sẵn như pdftoppm / libreoffice
	if runtime.GOOS == "linux" {
		officePath := media.ResolveLibreOffice()
		t.Logf("LibreOffice resolved path: %s", officePath)
		assert.NotEmpty(t, officePath, "Trên môi trường Linux kiểm thử phải tìm thấy LibreOffice")

		pdftoppmPath := media.ResolvePdftoppm()
		t.Logf("Pdftoppm resolved path: %s", pdftoppmPath)
		assert.NotEmpty(t, pdftoppmPath, "Trên môi trường Linux kiểm thử phải tìm thấy pdftoppm")
	}

	typstPath := media.ResolveTypst()
	t.Logf("Typst resolved path: %s", typstPath)
	// Typst có thể chưa cài trên máy Linux test nhưng hàm resolve không được panic
}

func TestConvertDocxWithWordOnWindows_NonWindows(t *testing.T) {
	if runtime.GOOS != "windows" {
		ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
		defer cancel()

		err := media.ConvertDocxWithWordOnWindows(ctx, "test.docx", "test.pdf")
		assert.Error(t, err)
		assert.Contains(t, err.Error(), "chỉ hỗ trợ trên hệ điều hành Windows")
	}
}
