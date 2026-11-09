package media

import (
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
)

// =============================================================================
// BINARY RESOLVER: HỖ TRỢ TỰ ĐỘNG ĐÓNG GÓI VÀ CHẠY ĐA NỀN TẢNG (LINUX, WINDOWS)
// =============================================================================

// ResolveExecutable tìm đường dẫn thực thi của một binary theo độ ưu tiên:
// 1. Cùng thư mục với file thực thi của ứng dụng (appDir)
// 2. Thư mục con "bin/" bên trong appDir (cấu trúc Wails / NSIS installer)
// 3. Thư mục làm việc hiện tại (working directory)
// 4. Biến môi trường %PATH% hệ thống qua exec.LookPath
func ResolveExecutable(binName string) string {
	binName = strings.TrimSpace(binName)
	if binName == "" {
		return ""
	}

	names := []string{binName}
	if runtime.GOOS == "windows" && !strings.HasSuffix(strings.ToLower(binName), ".exe") {
		names = append([]string{binName + ".exe"}, binName)
	}

	// 1. Kiểm tra cùng thư mục với file app thực thi và thư mục bin/
	if exePath, err := os.Executable(); err == nil && exePath != "" {
		appDir := filepath.Dir(exePath)
		for _, name := range names {
			candidate := filepath.Join(appDir, name)
			if fi, errStat := os.Stat(candidate); errStat == nil && !fi.IsDir() {
				return candidate
			}

			binCandidate := filepath.Join(appDir, "bin", name)
			if fi, errStat := os.Stat(binCandidate); errStat == nil && !fi.IsDir() {
				return binCandidate
			}
		}
	}

	// 2. Kiểm tra thư mục làm việc hiện tại
	if cwd, err := os.Getwd(); err == nil && cwd != "" {
		for _, name := range names {
			candidate := filepath.Join(cwd, name)
			if fi, errStat := os.Stat(candidate); errStat == nil && !fi.IsDir() {
				return candidate
			}

			binCandidate := filepath.Join(cwd, "bin", name)
			if fi, errStat := os.Stat(binCandidate); errStat == nil && !fi.IsDir() {
				return binCandidate
			}
		}
	}

	// 3. Kiểm tra trong PATH hệ thống
	for _, name := range names {
		if path, errLook := exec.LookPath(name); errLook == nil && path != "" {
			return path
		}
	}

	// 4. Kiểm tra các thư mục binary người dùng trên Linux/macOS
	if runtime.GOOS != "windows" {
		if home, err := os.UserHomeDir(); err == nil {
			for _, name := range names {
				candidates := []string{
					filepath.Join(home, ".local", "bin", name),
					filepath.Join(home, ".cargo", "bin", name),
					filepath.Join("/usr/local/bin", name),
					filepath.Join("/usr/bin", name),
					filepath.Join("/snap/bin", name),
				}
				for _, c := range candidates {
					if fi, errStat := os.Stat(c); errStat == nil && !fi.IsDir() {
						return c
					}
				}
			}
		}
	}

	return ""
}

// ResolveTypst tìm đường dẫn thực thi của Typst CLI (typst / typst.exe)
func ResolveTypst() string {
	return ResolveExecutable("typst")
}

// ResolvePdftoppm tìm đường dẫn thực thi của pdftoppm (Poppler utility)
func ResolvePdftoppm() string {
	return ResolveExecutable("pdftoppm")
}

// ResolveLibreOffice tìm file thực thi của LibreOffice (soffice / libreoffice).
// Trên Windows, tự động quét các thư mục cài đặt tiêu chuẩn của LibreOffice.
func ResolveLibreOffice() string {
	// 1. Kiểm tra theo chuẩn binary resolver thông thường
	if path := ResolveExecutable("soffice"); path != "" {
		return path
	}
	if path := ResolveExecutable("libreoffice"); path != "" {
		return path
	}

	// 2. Trên Windows, quét các thư mục cài đặt mặc định (thường không được thêm vào %PATH%)
	if runtime.GOOS == "windows" {
		candidates := []string{
			`C:\Program Files\LibreOffice\program\soffice.exe`,
			`C:\Program Files (x86)\LibreOffice\program\soffice.exe`,
			`D:\Program Files\LibreOffice\program\soffice.exe`,
		}

		// Quét theo các biến môi trường hệ thống Windows
		if pf := os.Getenv("ProgramFiles"); pf != "" {
			candidates = append(candidates, filepath.Join(pf, "LibreOffice", "program", "soffice.exe"))
		}
		if pf86 := os.Getenv("ProgramFiles(x86)"); pf86 != "" {
			candidates = append(candidates, filepath.Join(pf86, "LibreOffice", "program", "soffice.exe"))
		}
		if localApp := os.Getenv("LOCALAPPDATA"); localApp != "" {
			candidates = append(candidates, filepath.Join(localApp, "Programs", "LibreOffice", "program", "soffice.exe"))
		}

		for _, candidate := range candidates {
			if fi, err := os.Stat(candidate); err == nil && !fi.IsDir() {
				return candidate
			}
		}
	}

	return ""
}

// ConvertDocxWithWordOnWindows chuyển đổi DOCX sang PDF bằng Microsoft Word ngầm qua PowerShell COM Automation.
// Áp dụng riêng cho môi trường Windows khi máy đã cài MS Word nhưng không có LibreOffice.
func ConvertDocxWithWordOnWindows(ctx context.Context, docxPath, outPDFPath string) error {
	if runtime.GOOS != "windows" {
		return fmt.Errorf("chuyển đổi bằng Microsoft Word chỉ hỗ trợ trên hệ điều hành Windows")
	}

	absDocx, errDocx := filepath.Abs(docxPath)
	if errDocx != nil {
		return fmt.Errorf("không lấy được đường dẫn tuyệt đối của docx %s: %w", docxPath, errDocx)
	}

	absPDF, errPDF := filepath.Abs(outPDFPath)
	if errPDF != nil {
		return fmt.Errorf("không lấy được đường dẫn tuyệt đối của pdf %s: %w", outPDFPath, errPDF)
	}

	// PowerShell Script tạo COM Object Word.Application chuyển đổi ngầm sang định dạng PDF (wdFormatPDF = 17)
	psScript := fmt.Sprintf(`$ErrorActionPreference = 'Stop'
$word = New-Object -ComObject Word.Application
$word.Visible = $false
try {
    $doc = $word.Documents.Open('%s')
    $doc.SaveAs('%s', 17)
    $doc.Close()
} finally {
    $word.Quit()
}
`, strings.ReplaceAll(absDocx, "'", "''"), strings.ReplaceAll(absPDF, "'", "''"))

	cmd := exec.CommandContext(ctx, "powershell", "-NoProfile", "-NonInteractive", "-Command", psScript)
	output, errRun := cmd.CombinedOutput()
	if errRun != nil {
		return fmt.Errorf("Microsoft Word COM automation thất bại: %w (output: %s)", errRun, string(output))
	}

	if _, errStat := os.Stat(absPDF); errStat != nil {
		return fmt.Errorf("không tìm thấy file PDF đầu ra sau khi Word xuất: %w", errStat)
	}

	return nil
}
