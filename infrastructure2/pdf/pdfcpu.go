package pdf

import (
	"bytes"
	"context"
	"fmt"
	"io"
	"meet-attendance-clean/infrastructure2/gemini"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/pdfcpu/pdfcpu/pkg/api"
	"github.com/pdfcpu/pdfcpu/pkg/pdfcpu/model"
)

type PDFProcessor struct {
	qpdfPath string
}

func NewProcessor() *PDFProcessor {
	return &PDFProcessor{
		qpdfPath: findQPDFPath(),
	}
}

var _ gemini.PDFProcessor = (*PDFProcessor)(nil)

func findQPDFPath() string {
	if p, err := exec.LookPath("qpdf"); err == nil {
		return p
	}
	matches, _ := filepath.Glob(`C:\Program Files\qpdf*\bin\qpdf.exe`)
	if len(matches) > 0 {
		return matches[len(matches)-1]
	}
	matches86, _ := filepath.Glob(`C:\Program Files (x86)\qpdf*\bin\qpdf.exe`)
	if len(matches86) > 0 {
		return matches86[len(matches86)-1]
	}
	return "qpdf"
}

// ExtractPages trích xuất các trang yêu cầu bằng QPDF (Chuẩn công nghiệp, không bao giờ lỗi XRef/Font)
// Nếu không tìm thấy QPDF thì tự động fallback về pdfcpu tối ưu hóa.
func (p *PDFProcessor) ExtractPages(ctx context.Context, filePath string, pages []int) ([]byte, error) {
	// if err := ctx.Err(); err != nil {
	// 	return nil, err
	// }

	// if len(pages) == 0 {
	// 	return os.ReadFile(filePath)
	// }

	// // 1. Lọc trùng và sắp xếp trang tăng dần
	// uniquePages := make(map[int]bool)
	// for _, pg := range pages {
	// 	uniquePages[pg] = true
	// }
	// sortedPages := make([]int, 0, len(uniquePages))
	// for pg := range uniquePages {
	// 	sortedPages = append(sortedPages, pg)
	// }
	// sort.Ints(sortedPages)

	// // Lấy số trang thực tế để chặn lỗi out-of-range
	// total, err := p.PageCount(ctx, filePath)
	// if err == nil && total > 0 {
	// 	var validPages []int
	// 	for _, page := range sortedPages {
	// 		if page >= 1 && page <= total {
	// 			validPages = append(validPages, page)
	// 		}
	// 	}
	// 	if len(validPages) == 0 {
	// 		validPages = append(validPages, total)
	// 	}
	// 	sortedPages = validPages
	// }

	// // 2. Thử trích xuất bằng QPDF trước (Ưu tiên số 1 - Streaming thẳng vào RAM)
	// qpdfBin := p.qpdfPath
	// if qpdfBin == "" {
	// 	qpdfBin = findQPDFPath()
	// }

	// var pageStrs []string
	// for _, pg := range sortedPages {
	// 	pageStrs = append(pageStrs, strconv.Itoa(pg))
	// }
	// pageRange := strings.Join(pageStrs, ",")

	// cmd := exec.CommandContext(ctx, qpdfBin, "--empty", "--pages", filePath, pageRange, "--", "-")
	// var stdout, stderr bytes.Buffer
	// cmd.Stdout = &stdout
	// cmd.Stderr = &stderr

	// if err := cmd.Run(); err == nil && stdout.Len() > 0 {
	// 	return stdout.Bytes(), nil
	// }

	// // 3. Fallback: Nếu QPDF gặp lỗi, dùng pdfcpu với chế độ Tương thích cao (PDF 1.4 Legacy)
	// srcFile, err := os.Open(filePath)
	// if err != nil {
	// 	return nil, fmt.Errorf("không thể mở file PDF: %w", err)
	// }
	// defer srcFile.Close()

	// var outputBuffer bytes.Buffer
	// conf := model.NewDefaultConfiguration()
	// conf.ValidationMode = model.ValidationRelaxed
	// conf.WriteXRefStream = false   // Dùng bảng XRef Section cổ điển để tránh lệch offset
	// conf.WriteObjectStream = false // Tách bạch object, không gộp stream
	// conf.Optimize = true

	// pageStrList := make([]string, len(sortedPages))
	// for i, page := range sortedPages {
	// 	pageStrList[i] = strconv.Itoa(page)
	// }

	// if err := api.Trim(srcFile, &outputBuffer, pageStrList, conf); err != nil {
	// 	return nil, fmt.Errorf("lỗi khi trích xuất trang (cả qpdf lẫn pdfcpu): %w (qpdf stderr: %s)", err, stderr.String())
	// }

	// return outputBuffer.Bytes(), nil
	return os.ReadFile(filePath)
}

// PageCount đếm số trang nhanh bằng QPDF hoặc pdfcpu
func (p *PDFProcessor) PageCount(ctx context.Context, filePath string) (int, error) {
	qpdfBin := p.qpdfPath
	if qpdfBin == "" {
		qpdfBin = findQPDFPath()
	}

	// Thử đếm trang bằng QPDF
	cmd := exec.CommandContext(ctx, qpdfBin, "--show-npages", filePath)
	var outBuf bytes.Buffer
	cmd.Stdout = &outBuf
	if err := cmd.Run(); err == nil {
		cntStr := strings.TrimSpace(outBuf.String())
		if cnt, parseErr := strconv.Atoi(cntStr); parseErr == nil && cnt > 0 {
			return cnt, nil
		}
	}

	// Fallback pdfcpu
	return api.PageCountFile(filePath)
}

// MergeAndNUp gộp nhiều file PDF lại làm một và nén n trang thành 1 trang (n-up grid: 2, 4, 8, 16...).
// Giúp gộp toàn bộ tài liệu thành 1 nguồn duy nhất và giảm số trang theo hệ số n, tiết kiệm input token cho LLM.
func (p *PDFProcessor) MergeAndNUp(ctx context.Context, filePaths []string, n int) ([]byte, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	if len(filePaths) == 0 {
		return nil, fmt.Errorf("danh sách file PDF trống")
	}
	if n <= 0 {
		n = 2
	}

	conf := model.NewDefaultConfiguration()
	conf.ValidationMode = model.ValidationRelaxed
	conf.Optimize = true

	var mergedBuf bytes.Buffer

	if len(filePaths) == 1 {
		srcFile, err := os.Open(filePaths[0])
		if err != nil {
			return nil, fmt.Errorf("không thể mở file PDF %s: %w", filePaths[0], err)
		}
		defer srcFile.Close()
		if _, err := io.Copy(&mergedBuf, srcFile); err != nil {
			return nil, fmt.Errorf("không thể đọc file PDF %s: %w", filePaths[0], err)
		}
	} else {
		var readers []io.ReadSeeker
		var openedFiles []*os.File
		for _, path := range filePaths {
			f, err := os.Open(path)
			if err != nil {
				for _, of := range openedFiles {
					of.Close()
				}
				return nil, fmt.Errorf("không thể mở file PDF %s: %w", path, err)
			}
			openedFiles = append(openedFiles, f)
			readers = append(readers, f)
		}
		defer func() {
			for _, of := range openedFiles {
				of.Close()
			}
		}()

		err := api.MergeRaw(readers, &mergedBuf, false, conf)
		if err != nil {
			return nil, fmt.Errorf("lỗi ghép nhiều file PDF bằng pdfcpu: %w", err)
		}
	}

	if err := ctx.Err(); err != nil {
		return nil, err
	}

	// Nén n trang vào 1 trang (N-Up = n, ví dụ n=8)
	nup, err := api.PDFNUpConfig(n, "", conf)
	if err != nil {
		return nil, fmt.Errorf("lỗi cấu hình %d-up pdfcpu: %w", n, err)
	}

	var nupBuf bytes.Buffer
	rs := bytes.NewReader(mergedBuf.Bytes())
	err = api.NUp(rs, &nupBuf, nil, nil, nup, conf)
	if err != nil {
		return nil, fmt.Errorf("lỗi nén %d trang vào 1 bằng pdfcpu: %w", n, err)
	}

	return nupBuf.Bytes(), nil
}

// MergeAndNUp2 giữ tương thích ngược
func (p *PDFProcessor) MergeAndNUp2(ctx context.Context, filePaths []string) ([]byte, error) {
	return p.MergeAndNUp(ctx, filePaths, 2)
}

// MergeAndNUp8 nén siêu nhỏ 8 trang vào 1 trang (2x4 grid)
func (p *PDFProcessor) MergeAndNUp8(ctx context.Context, filePaths []string) ([]byte, error) {
	return p.MergeAndNUp(ctx, filePaths, 8)
}
