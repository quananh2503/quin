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
	"sort"
	"strconv"
	"strings"
)

var _ TypstCompiler = (*CLITypstCompiler)(nil)

// CLITypstCompiler thực hiện biên dịch Typst qua công cụ dòng lệnh (CLI).
type CLITypstCompiler struct {
	cliPath string
}

// ResolveTypstCLI tìm đường dẫn thực thi của typst binary:
// Ưu tiên tìm file typst.exe nằm cùng thư mục với file exe ứng dụng, sau đó tìm trong %PATH%.
func ResolveTypstCLI() string {
	if exe, err := os.Executable(); err == nil {
		candidate := filepath.Join(filepath.Dir(exe), "typst.exe")
		if _, err := os.Stat(candidate); err == nil {
			return candidate
		}
	}
	if path, err := exec.LookPath("typst"); err == nil {
		return path
	}
	return "typst"
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

	// <temp.typ> <opts.OutPDFPath>
	args = append(args, tmpPath, opts.OutPDFPath)

	// 4. Thực thi lệnh Typst CLI
	cmd := exec.CommandContext(ctx, c.cliPath, args...)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	runErr := cmd.Run()
	if runErr == nil {
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
