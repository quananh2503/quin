package gemini

import (
	"bytes"
	"context"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"runtime"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/pdfcpu/pdfcpu/pkg/api"
)

var _ TypstCompiler = (*CLITypstCompiler)(nil)
var _ PDFRasterizer = (*CLITypstCompiler)(nil)

// PDFRasterizer định nghĩa giao diện chuyển đổi tài liệu PDF thành danh sách ảnh PNG
type PDFRasterizer interface {
	RasterizePDF(ctx context.Context, pdfBytes []byte) ([][]byte, error)
}

// CLITypstCompiler thực hiện biên dịch Typst qua công cụ dòng lệnh (CLI).
type CLITypstCompiler struct {
	cliPath string
}

// ResolveTypstCLI tìm đường dẫn thực thi của typst binary:
// Tự động tương thích cả Windows (typst.exe) và Linux/macOS (typst).
// Ưu tiên tìm file typst nằm cùng thư mục với file exe ứng dụng, sau đó tìm trong %PATH% và ~/.local/bin/typst.
func ResolveTypstCLI() string {
	binName := "typst"
	if runtime.GOOS == "windows" {
		binName = "typst.exe"
	}

	// 1. Cùng thư mục với file exe ứng dụng
	if exe, err := os.Executable(); err == nil {
		candidate := filepath.Join(filepath.Dir(exe), binName)
		if fi, err := os.Stat(candidate); err == nil && !fi.IsDir() {
			return candidate
		}
	}

	// 2. Tìm trong PATH hệ thống
	if path, err := exec.LookPath(binName); err == nil {
		return path
	}
	if path, err := exec.LookPath("typst"); err == nil {
		return path
	}

	// 3. Các đường dẫn chuẩn trên Linux/macOS (đặc biệt khi chạy từ desktop / GUI environment)
	if runtime.GOOS != "windows" {
		if home, err := os.UserHomeDir(); err == nil {
			candidates := []string{
				filepath.Join(home, ".local", "bin", "typst"),
				filepath.Join(home, ".cargo", "bin", "typst"),
			}
			for _, c := range candidates {
				if fi, err := os.Stat(c); err == nil && !fi.IsDir() {
					return c
				}
			}
		}
		for _, std := range []string{"/usr/local/bin/typst", "/usr/bin/typst", "/snap/bin/typst"} {
			if fi, err := os.Stat(std); err == nil && !fi.IsDir() {
				return std
			}
		}
	}

	return binName
}

func resolveTypstCLI() string {
	return ResolveTypstCLI()
}

// NewCLITypstCompiler khởi tạo một CLITypstCompiler mới.
func NewCLITypstCompiler() *CLITypstCompiler {
	return &CLITypstCompiler{
		cliPath: resolveTypstCLI(),
	}
}

// Compile ghi typstMarkup ra file .typ tạm và biên dịch sang PDF bằng Typst CLI.
func (c *CLITypstCompiler) Compile(ctx context.Context, typstMarkup string, opts CompileOptions) (*CompileResult, error) {
	if opts.OutPDFPath == "" {
		return nil, fmt.Errorf("out_pdf_path cannot be empty")
	}

	// 1. Đảm bảo thư mục đích tồn tại
	outDir := filepath.Dir(opts.OutPDFPath)
	if outDir != "" {
		if err := os.MkdirAll(outDir, 0755); err != nil {
			return nil, fmt.Errorf("failed to create destination directory %q: %w", outDir, err)
		}
	}

	// 2. Ghi typstMarkup ra file .typ tạm
	tmpFile, err := os.CreateTemp(outDir, "typst_*.typ")
	if err != nil {
		tmpFile, err = os.CreateTemp("", "typst_*.typ")
		if err != nil {
			return nil, fmt.Errorf("failed to create temp typst file: %w", err)
		}
	}
	tmpPath := tmpFile.Name()
	defer func() {
		if rmErr := os.Remove(tmpPath); rmErr != nil && !os.IsNotExist(rmErr) {
			log.Printf("dọn dẹp file typst tạm thất bại: %v", rmErr)
		}
	}()

	if _, err := tmpFile.WriteString(typstMarkup); err != nil {
		if closeErr := tmpFile.Close(); closeErr != nil {
			log.Printf("lỗi đóng file typst tạm: %v", closeErr)
		}
		return nil, fmt.Errorf("failed to write typst markup: %w", err)
	}
	if err := tmpFile.Close(); err != nil {
		return nil, fmt.Errorf("failed to close temp typst file: %w", err)
	}

	// 3. Chuẩn bị tham số gọi CLI: typst compile --root . --input teacher=true/false ...
	args := []string{"compile"}

	// Typst yêu cầu file nguồn phải nằm trong project root nếu chỉ định --root.
	// Nếu file tạm nằm trong ".", dùng --root .
	// Nếu file tạm nằm ngoài "." (ví dụ ổ đĩa khác trong t.TempDir() trên Windows), dùng thư mục chứa file tạm làm root.
	root := "."
	rel, relErr := filepath.Rel(".", tmpPath)
	if relErr != nil || strings.HasPrefix(rel, "..") || filepath.IsAbs(rel) {
		root = filepath.Dir(tmpPath)
	}
	args = append(args, "--root", root)

	// --input teacher=true/false
	teacherVal := "false"
	if opts.IsTeacher {
		teacherVal = "true"
	}
	args = append(args, "--input", fmt.Sprintf("teacher=%s", teacherVal))

	// Các inputs khác nếu có (Metadata/Inputs)
	if opts.Inputs != nil {
		keys := make([]string, 0, len(opts.Inputs))
		for k := range opts.Inputs {
			if k != "teacher" {
				keys = append(keys, k)
			}
		}
		sort.Strings(keys)
		for _, k := range keys {
			args = append(args, "--input", fmt.Sprintf("%s=%s", k, opts.Inputs[k]))
		}
	}

	// Tạo file PDF tạm để Typst ghi ra, tránh lỗi Windows OS 1224 (file with user-mapped section open)
	tmpPDF, err := os.CreateTemp(outDir, "typst_out_*.pdf")
	if err != nil {
		tmpPDF, err = os.CreateTemp("", "typst_out_*.pdf")
		if err != nil {
			return nil, fmt.Errorf("không thể tạo file PDF tạm: %w", err)
		}
	}
	tmpPDFPath := tmpPDF.Name()
	if errClose := tmpPDF.Close(); errClose != nil {
		log.Printf("cảnh báo: không thể đóng file PDF tạm %s: %v", tmpPDFPath, errClose)
	}
	defer func() {
		if rmErr := os.Remove(tmpPDFPath); rmErr != nil && !os.IsNotExist(rmErr) {
			log.Printf("dọn dẹp file PDF tạm thất bại: %v", rmErr)
		}
	}()

	// <temp.typ> <tmpPDFPath>
	args = append(args, tmpPath, tmpPDFPath)

	// 4. Thực thi lệnh Typst CLI
	cmd := exec.CommandContext(ctx, c.cliPath, args...)
	hideConsoleWindow(cmd)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	runErr := cmd.Run()
	if runErr == nil {
		// Đọc nội dung PDF vừa biên dịch và ghi sang opts.OutPDFPath
		pdfBytes, errRead := os.ReadFile(tmpPDFPath)
		if errRead != nil {
			return nil, fmt.Errorf("không thể đọc file PDF vừa biên dịch: %w", errRead)
		}

		var writeErr error
		for attempt := 0; attempt < 3; attempt++ {
			writeErr = os.WriteFile(opts.OutPDFPath, pdfBytes, 0644)
			if writeErr == nil {
				break
			}
			time.Sleep(100 * time.Millisecond)
		}
		if writeErr != nil {
			return nil, fmt.Errorf("không thể ghi file PDF đầu ra %s: %w", opts.OutPDFPath, writeErr)
		}

		return &CompileResult{
			Success: true,
			PDFPath: opts.OutPDFPath,
		}, nil
	}

	// 5. Xử lý khi có lỗi: bóc tách toàn bộ số dòng lỗi từ stderr của Typst
	stderrStr := stderr.String()
	if stderrStr == "" && stdout.Len() > 0 {
		stderrStr = stdout.String()
	}
	if stderrStr == "" {
		stderrStr = runErr.Error()
	}

	errorLines := extractTypstErrorLines(stderrStr)

	return &CompileResult{
		Success:    false,
		ErrorLines: errorLines,
		RawStderr:  stderrStr,
	}, fmt.Errorf("typst compilation failed: %w", runErr)
}

// CompileToBytes biên dịch trực tiếp typstMarkup ra []byte của file PDF (tự dọn dẹp file tạm)
func (c *CLITypstCompiler) CompileToBytes(ctx context.Context, typstMarkup string) ([]byte, error) {
	tmpPDF, err := os.CreateTemp("", "typst_out_*.pdf")
	if err != nil {
		return nil, fmt.Errorf("không thể tạo file PDF tạm: %w", err)
	}
	tmpPDFPath := tmpPDF.Name()
	if errClose := tmpPDF.Close(); errClose != nil {
		if rmErr := os.Remove(tmpPDFPath); rmErr != nil && !os.IsNotExist(rmErr) {
			log.Printf("dọn dẹp file pdf tạm thất bại: %v", rmErr)
		}
		return nil, fmt.Errorf("lỗi đóng file PDF tạm: %w", errClose)
	}
	defer func() {
		if rmErr := os.Remove(tmpPDFPath); rmErr != nil && !os.IsNotExist(rmErr) {
			log.Printf("dọn dẹp file pdf tạm thất bại: %v", rmErr)
		}
	}()

	opts := CompileOptions{OutPDFPath: tmpPDFPath}
	res, err := c.Compile(ctx, typstMarkup, opts)
	if err != nil {
		return nil, err
	}
	if !res.Success {
		return nil, fmt.Errorf("biên dịch Typst thất bại: %s", res.RawStderr)
	}
	return os.ReadFile(tmpPDFPath)
}

// RasterizePDF chuyển đổi các trang trong tài liệu PDF thành danh sách ảnh PNG bằng Typst CLI.
func (c *CLITypstCompiler) RasterizePDF(ctx context.Context, pdfBytes []byte) ([][]byte, error) {
	if len(pdfBytes) == 0 {
		return nil, fmt.Errorf("dữ liệu PDF rỗng")
	}

	pageCount, err := api.PageCount(bytes.NewReader(pdfBytes), nil)
	if err != nil || pageCount <= 0 {
		pageCount = 1
	}

	tmpDir, err := os.MkdirTemp("", "quin_typst_raster_*")
	if err != nil {
		return nil, fmt.Errorf("tạo thư mục tạm thất bại: %w", err)
	}
	defer func() {
		if rmErr := os.RemoveAll(tmpDir); rmErr != nil {
			log.Printf("dọn dẹp thư mục tạm %s thất bại: %v", tmpDir, rmErr)
		}
	}()

	inputPDF := filepath.Join(tmpDir, "input.pdf")
	if errWrite := os.WriteFile(inputPDF, pdfBytes, 0644); errWrite != nil {
		return nil, fmt.Errorf("ghi file PDF tạm thất bại: %w", errWrite)
	}

	var markup strings.Builder
	markup.WriteString("#set page(width: auto, height: auto, margin: 0pt)\n")
	for p := 1; p <= pageCount; p++ {
		if p > 1 {
			markup.WriteString("#pagebreak()\n")
		}
		markup.WriteString(fmt.Sprintf("#image(\"input.pdf\", page: %d)\n", p))
	}

	typFile := filepath.Join(tmpDir, "raster.typ")
	if errWrite := os.WriteFile(typFile, []byte(markup.String()), 0644); errWrite != nil {
		return nil, fmt.Errorf("ghi file typst tạm thất bại: %w", errWrite)
	}

	outPattern := filepath.Join(tmpDir, "page-{0p}.png")

	args := []string{
		"compile",
		"--root", tmpDir,
		"--format", "png",
		typFile,
		outPattern,
	}

	cmd := exec.CommandContext(ctx, c.cliPath, args...)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if errRun := cmd.Run(); errRun != nil {
		return nil, fmt.Errorf("typst rasterize pdf thất bại: %w (stderr: %s)", errRun, stderr.String())
	}

	entries, errRead := os.ReadDir(tmpDir)
	if errRead != nil {
		return nil, fmt.Errorf("đọc danh sách ảnh raster thất bại: %w", errRead)
	}

	type pageImg struct {
		pageNum int
		path    string
	}
	var pngFiles []pageImg

	re := regexp.MustCompile(`page-(\d+)\.png`)
	for _, e := range entries {
		if e.IsDir() {
			continue
		}
		matches := re.FindStringSubmatch(e.Name())
		if len(matches) == 2 {
			pNum, errNum := strconv.Atoi(matches[1])
			if errNum == nil {
				pngFiles = append(pngFiles, pageImg{
					pageNum: pNum,
					path:    filepath.Join(tmpDir, e.Name()),
				})
			}
		}
	}

	if len(pngFiles) == 0 {
		return nil, fmt.Errorf("không tìm thấy file ảnh PNG nào sau khi Typst render")
	}

	sort.Slice(pngFiles, func(i, j int) bool {
		return pngFiles[i].pageNum < pngFiles[j].pageNum
	})

	result := make([][]byte, len(pngFiles))
	for i, pf := range pngFiles {
		data, errFile := os.ReadFile(pf.path)
		if errFile != nil {
			return nil, fmt.Errorf("đọc file ảnh %s thất bại: %w", pf.path, errFile)
		}
		result[i] = data
	}

	return result, nil
}

// extractTypstErrorLines bóc tách toàn bộ số dòng lỗi từ stderr của Typst
// Hỗ trợ các mẫu lỗi Typst 0.15+: ":(\d+):(\d+)" hoặc "\.typ:(\d+):" hoặc "\.typ:(\d+)"
func extractTypstErrorLines(stderr string) []int {
	seen := make(map[int]bool)
	var lines []int

	// Mẫu 1: .typ:(\d+) (hỗ trợ .typ:9: hoặc .typ:9:20)
	reTyp := regexp.MustCompile(`\.typ:(\d+)`)
	for _, match := range reTyp.FindAllStringSubmatch(stderr, -1) {
		if len(match) > 1 {
			if line, err := strconv.Atoi(match[1]); err == nil && line > 0 && !seen[line] {
				seen[line] = true
				lines = append(lines, line)
			}
		}
	}

	// Mẫu 2: :(\d+):(\d+) (hỗ trợ các chuỗi định vị lỗi dạng :9:20)
	reColon := regexp.MustCompile(`:(\d+):(\d+)`)
	for _, match := range reColon.FindAllStringSubmatch(stderr, -1) {
		if len(match) > 1 {
			if line, err := strconv.Atoi(match[1]); err == nil && line > 0 && !seen[line] {
				seen[line] = true
				lines = append(lines, line)
			}
		}
	}

	sort.Ints(lines)
	if lines == nil {
		lines = []int{}
	}
	return lines
}
