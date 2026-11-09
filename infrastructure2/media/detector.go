package media

import (
	"bytes"
	"context"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"meet-attendance-clean/domain2/document"
)

// =============================================================================
// TYPE DETECTOR
// =============================================================================

// TypeDetector chịu trách nhiệm nhận diện định dạng file dựa trên magic bytes và phần mở rộng
type TypeDetector struct{}

// TypeDetecter là alias đảm bảo tương thích ngược với draft
type TypeDetecter = TypeDetector

// NewTypeDetector khởi tạo TypeDetector
func NewTypeDetector() *TypeDetector {
	return &TypeDetector{}
}

// Detect nhận diện loại file từ đường dẫn lưu trữ trên đĩa hoặc URL
func (t TypeDetector) Detect(ctx context.Context, path string) (document.FileType, error) {
	trimmed := strings.TrimSpace(path)
	if trimmed == "" {
		return document.FileTypeUnknown, fmt.Errorf("đường dẫn file rỗng")
	}

	// 1. Kiểm tra nếu là URL YouTube
	if IsYouTubeURL(trimmed) {
		return document.FileTypeYOUTUBE, nil
	}

	f, err := os.Open(trimmed)
	if err != nil {
		return document.FileTypeUnknown, fmt.Errorf("mở file %s để nhận diện thất bại: %w", trimmed, err)
	}
	defer func() {
		if closeErr := f.Close(); closeErr != nil {
			log.Printf("[TypeDetector] Đóng file %s thất bại: %v", trimmed, closeErr)
		}
	}()

	header := make([]byte, 512)
	n, readErr := f.Read(header)
	if readErr != nil && readErr != io.EOF {
		return document.FileTypeUnknown, fmt.Errorf("đọc header file %s thất bại: %w", trimmed, readErr)
	}

	return t.DetectBytes(ctx, header[:n], filepath.Base(trimmed))
}

// DetectBytes nhận diện loại file dựa trên mảng byte header và tên file
func (t TypeDetector) DetectBytes(ctx context.Context, raw []byte, fileName string) (document.FileType, error) {
	ext := strings.ToLower(filepath.Ext(fileName))

	// 0. Kiểm tra nếu là URL YouTube (trong fileName hoặc trong nội dung text)
	if IsYouTubeURL(fileName) {
		return document.FileTypeYOUTUBE, nil
	}
	if len(raw) > 0 && len(raw) < 512 && IsYouTubeURL(string(raw)) {
		return document.FileTypeYOUTUBE, nil
	}

	// 1. Kiểm tra Magic Bytes đặc trưng
	if len(raw) >= 4 && bytes.HasPrefix(raw, []byte("%PDF-")) {
		return document.FileTypePDF, nil
	}
	if len(raw) >= 8 && bytes.Equal(raw[:8], []byte{0x89, 'P', 'N', 'G', 0x0D, 0x0A, 0x1A, 0x0A}) {
		return document.FileTypePNG, nil
	}
	if len(raw) >= 3 && raw[0] == 0xFF && raw[1] == 0xD8 && raw[2] == 0xFF {
		return document.FileTypeJPEG, nil
	}
	if len(raw) >= 12 && string(raw[:4]) == "RIFF" && string(raw[8:12]) == "WEBP" {
		return document.FileTypeWEBP, nil
	}
	if len(raw) >= 6 && (string(raw[:6]) == "GIF87a" || string(raw[:6]) == "GIF89a") {
		return document.FileTypeGIF, nil
	}
	if len(raw) >= 2 && raw[0] == 'B' && raw[1] == 'M' {
		return document.FileTypeBMP, nil
	}
	if len(raw) >= 4 && ((raw[0] == 'I' && raw[1] == 'I' && raw[2] == 0x2A && raw[3] == 0x00) ||
		(raw[0] == 'M' && raw[1] == 'M' && raw[2] == 0x00 && raw[3] == 0x2A)) {
		return document.FileTypeTIFF, nil
	}
	if len(raw) >= 4 && raw[0] == 'P' && raw[1] == 'K' && raw[2] == 0x03 && raw[3] == 0x04 {
		if ext == ".docx" {
			return document.FileTypeDOCX, nil
		}
	}
	// OLE2 Compound Document (định dạng .doc cũ)
	if len(raw) >= 8 && raw[0] == 0xD0 && raw[1] == 0xCF && raw[2] == 0x11 && raw[3] == 0xE0 &&
		raw[4] == 0xA1 && raw[5] == 0xB1 && raw[6] == 0x1A && raw[7] == 0xE1 {
		return document.FileTypeDOCX, nil
	}

	// 2. Sử dụng http.DetectContentType để phân tích MIME
	mime := http.DetectContentType(raw)
	switch {
	case strings.Contains(mime, "pdf"):
		return document.FileTypePDF, nil
	case strings.Contains(mime, "png"):
		return document.FileTypePNG, nil
	case strings.Contains(mime, "jpeg"):
		return document.FileTypeJPEG, nil
	case strings.Contains(mime, "webp"):
		return document.FileTypeWEBP, nil
	case strings.Contains(mime, "gif"):
		return document.FileTypeGIF, nil
	case strings.Contains(mime, "bmp"):
		return document.FileTypeBMP, nil
	case strings.Contains(mime, "tiff"):
		return document.FileTypeTIFF, nil
	}

	// 3. Fallback theo phần mở rộng đuôi file
	switch ext {
	case ".pdf":
		return document.FileTypePDF, nil
	case ".png":
		return document.FileTypePNG, nil
	case ".jpg", ".jpeg":
		return document.FileTypeJPEG, nil
	case ".webp":
		return document.FileTypeWEBP, nil
	case ".gif":
		return document.FileTypeGIF, nil
	case ".bmp":
		return document.FileTypeBMP, nil
	case ".tiff", ".tif":
		return document.FileTypeTIFF, nil
	case ".docx", ".doc":
		return document.FileTypeDOCX, nil
	case ".txt":
		return document.FileTypeTXT, nil
	default:
		if strings.HasPrefix(mime, "text/") {
			return document.FileTypeTXT, nil
		}
		return document.FileTypeUnknown, nil
	}
}
