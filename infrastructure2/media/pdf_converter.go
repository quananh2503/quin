package media

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

// =============================================================================
// PDF TO JPEG CONVERTER
// =============================================================================

// PDFToJPEGConverter chuyển đổi tài liệu PDF thành danh sách các trang ảnh JPEG
type PDFToJPEGConverter struct {
	dpi     int
	quality int
}

// NewPDFToJPEGConverter khởi tạo PDFToJPEGConverter
func NewPDFToJPEGConverter(dpi, quality int) *PDFToJPEGConverter {
	if dpi <= 0 {
		dpi = 150
	}
	if quality <= 0 || quality > 100 {
		quality = 82
	}
	return &PDFToJPEGConverter{
		dpi:     dpi,
		quality: quality,
	}
}

// Convert chuyển đổi trang đầu tiên của PDF sang JPEG (thỏa mãn interface Convert)
func (c *PDFToJPEGConverter) Convert(ctx context.Context, raw []byte) ([]byte, error) {
	pages, err := c.ConvertPages(ctx, raw)
	if err != nil {
		return nil, err
	}
	if len(pages) == 0 {
		return nil, fmt.Errorf("không có trang nào được xuất ra từ PDF")
	}
	return pages[0], nil
}

// ConvertPages chuyển đổi toàn bộ các trang PDF thành mảng các trang JPEG
func (c *PDFToJPEGConverter) ConvertPages(ctx context.Context, raw []byte) ([][]byte, error) {
	if len(raw) == 0 {
		return nil, fmt.Errorf("dữ liệu PDF rỗng")
	}

	// 1. Thử dùng pdftoppm nếu có (ưu tiên hàng đầu vì tốc độ siêu nhanh < 0.3s)
	if pdftoppmBin := ResolvePdftoppm(); pdftoppmBin != "" {
		pages, errPoppler := c.convertWithPdftoppm(ctx, raw, pdftoppmBin)
		if errPoppler == nil && len(pages) > 0 {
			return pages, nil
		}
		log.Printf("[PDFToJPEGConverter] pdftoppm gặp lỗi (%v), chuyển sang phương án dự phòng Typst...", errPoppler)
	}

	// 2. Phương án dự phòng: Typst CLI (tự động phân giải typst.exe đi kèm bộ cài Wails)
	if typstBin := ResolveTypst(); typstBin != "" {
		return c.convertWithTypst(ctx, raw, typstBin)
	}

	return nil, fmt.Errorf("không tìm thấy công cụ chuyển đổi PDF (cần cài đặt pdftoppm hoặc đóng gói kèm typst.exe)")
}

// convertWithPdftoppm sử dụng công cụ pdftoppm để xuất ảnh JPEG từng trang
func (c *PDFToJPEGConverter) convertWithPdftoppm(ctx context.Context, raw []byte, pdftoppmBin string) ([][]byte, error) {
	tmpDir, err := os.MkdirTemp("", "quin_pdftoppm_*")
	if err != nil {
		return nil, fmt.Errorf("tạo thư mục tạm thất bại: %w", err)
	}
	defer func() {
		if rmErr := os.RemoveAll(tmpDir); rmErr != nil {
			log.Printf("[PDFToJPEGConverter] Dọn dẹp thư mục tạm %s thất bại: %v", tmpDir, rmErr)
		}
	}()

	inputPDF := filepath.Join(tmpDir, "input.pdf")
	if errWrite := os.WriteFile(inputPDF, raw, 0644); errWrite != nil {
		return nil, fmt.Errorf("ghi file PDF tạm thất bại: %w", errWrite)
	}

	outPrefix := filepath.Join(tmpDir, "page")
	args := []string{
		"-jpeg",
		"-jpegopt", fmt.Sprintf("quality=%d", c.quality),
		"-r", strconv.Itoa(c.dpi),
		inputPDF,
		outPrefix,
	}

	cmd := exec.CommandContext(ctx, pdftoppmBin, args...)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if errRun := cmd.Run(); errRun != nil {
		return nil, fmt.Errorf("thực thi pdftoppm thất bại: %w (stderr: %s)", errRun, stderr.String())
	}

	entries, errRead := os.ReadDir(tmpDir)
	if errRead != nil {
		return nil, fmt.Errorf("đọc thư mục kết quả pdftoppm thất bại: %w", errRead)
	}

	type pageFile struct {
		num  int
		path string
	}
	var pageFiles []pageFile
	re := regexp.MustCompile(`page-(\d+)\.jpg`)

	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}
		matches := re.FindStringSubmatch(entry.Name())
		if len(matches) == 2 {
			pNum, errAtoi := strconv.Atoi(matches[1])
			if errAtoi == nil {
				pageFiles = append(pageFiles, pageFile{
					num:  pNum,
					path: filepath.Join(tmpDir, entry.Name()),
				})
			}
		}
	}

	if len(pageFiles) == 0 {
		return nil, fmt.Errorf("không tìm thấy file ảnh JPEG nào sau khi chạy pdftoppm")
	}

	sort.Slice(pageFiles, func(i, j int) bool {
		return pageFiles[i].num < pageFiles[j].num
	})

	results := make([][]byte, len(pageFiles))
	for i, pf := range pageFiles {
		data, errFile := os.ReadFile(pf.path)
		if errFile != nil {
			return nil, fmt.Errorf("đọc file ảnh trang %s thất bại: %w", pf.path, errFile)
		}
		results[i] = data
	}

	return results, nil
}

// convertWithTypst sử dụng Typst để xuất ảnh PNG rồi nén lại thành JPEG
func (c *PDFToJPEGConverter) convertWithTypst(ctx context.Context, raw []byte, typstBin string) ([][]byte, error) {
	pageCount := 1
	reCount := regexp.MustCompile(`/Count\s+(\d+)`)
	matches := reCount.FindSubmatch(raw)
	if len(matches) == 2 {
		if val, errAtoi := strconv.Atoi(string(matches[1])); errAtoi == nil && val > 0 {
			pageCount = val
		}
	}

	tmpDir, err := os.MkdirTemp("", "quin_typst_raster_*")
	if err != nil {
		return nil, fmt.Errorf("tạo thư mục tạm thất bại: %w", err)
	}
	defer func() {
		if rmErr := os.RemoveAll(tmpDir); rmErr != nil {
			log.Printf("[PDFToJPEGConverter] Dọn dẹp thư mục tạm %s thất bại: %v", tmpDir, rmErr)
		}
	}()

	inputPDF := filepath.Join(tmpDir, "input.pdf")
	if errWrite := os.WriteFile(inputPDF, raw, 0644); errWrite != nil {
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
	cmd := exec.CommandContext(ctx, typstBin, "compile", "--root", tmpDir, "--format", "png", typFile, outPattern)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if errRun := cmd.Run(); errRun != nil {
		return nil, fmt.Errorf("typst render ảnh thất bại: %w (stderr: %s)", errRun, stderr.String())
	}

	entries, errRead := os.ReadDir(tmpDir)
	if errRead != nil {
		return nil, fmt.Errorf("đọc thư mục tạm thất bại: %w", errRead)
	}

	type pageFile struct {
		num  int
		path string
	}
	var pngFiles []pageFile
	re := regexp.MustCompile(`page-(\d+)\.png`)
	for _, e := range entries {
		if e.IsDir() {
			continue
		}
		m := re.FindStringSubmatch(e.Name())
		if len(m) == 2 {
			pNum, errAtoi := strconv.Atoi(m[1])
			if errAtoi == nil {
				pngFiles = append(pngFiles, pageFile{
					num:  pNum,
					path: filepath.Join(tmpDir, e.Name()),
				})
			}
		}
	}

	if len(pngFiles) == 0 {
		return nil, fmt.Errorf("không tìm thấy file PNG nào từ typst render")
	}

	sort.Slice(pngFiles, func(i, j int) bool {
		return pngFiles[i].num < pngFiles[j].num
	})

	imgConverter := NewImageToJPEGConverter(1600, c.quality)
	results := make([][]byte, len(pngFiles))
	for i, pf := range pngFiles {
		pngData, errFile := os.ReadFile(pf.path)
		if errFile != nil {
			return nil, fmt.Errorf("đọc file png %s thất bại: %w", pf.path, errFile)
		}
		jpegData, errConv := imgConverter.Convert(ctx, pngData)
		if errConv != nil {
			return nil, fmt.Errorf("chuyển đổi trang %d sang JPEG thất bại: %w", pf.num, errConv)
		}
		results[i] = jpegData
	}

	return results, nil
}
