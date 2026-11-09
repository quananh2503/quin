package application2

import (
	"context"
	"errors"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"
	"uuid"

	"github.com/pdfcpu/pdfcpu/pkg/api"
)

type DocumentRepository interface {
	Save(ctx context.Context, doc *Document) error
	GetByID(ctx context.Context, id uuid.UUID) (*Document, error)
	List(ctx context.Context) ([]Document, error)
}

type Document struct {
	ID        uuid.UUID `json:"id"`
	FileName  string    `json:"file_name"`
	FilePath  string    `json:"file_path"`  // Đường dẫn file lưu trong thư mục app
	PageCount int       `json:"page_count"` // Tổng số trang
	CreatedAt time.Time `json:"created_at"`
}

// UploadCommand nhận đường dẫn file được chọn từ máy tính
type UploadCommand struct {
	SourceFilePath string // Ví dụ: "C:/Users/Admin/Downloads/SGK_Toan.pdf"
}

// UploadBytesCommand nhận nội dung file dạng byte (phục vụ copy-paste, kéo thả từ webview)
type UploadBytesCommand struct {
	FileName string
	Data     []byte
}

type UploadDocumentHandler struct {
	documentRepo DocumentRepository
	storageDir   string // Thư mục lưu trữ file trong app
}

func NewUploadDocumentHandler(repo DocumentRepository, storageDir string) (*UploadDocumentHandler, error) {
	if err := os.MkdirAll(storageDir, 0755); err != nil {
		return nil, fmt.Errorf("không thể tạo thư mục lưu file: %w", err)
	}
	return &UploadDocumentHandler{
		documentRepo: repo,
		storageDir:   storageDir,
	}, nil
}

func isSupportedDocumentExt(ext string) bool {
	switch strings.ToLower(ext) {
	case ".pdf", ".docx", ".doc", ".png", ".jpg", ".jpeg", ".webp", ".bmp", ".gif", ".tiff", ".txt":
		return true
	default:
		return false
	}
}

func (h *UploadDocumentHandler) Upload(ctx context.Context, cmd UploadCommand) (d *Document, err error) {
	path := strings.TrimSpace(cmd.SourceFilePath)
	if path == "" {
		return nil, errors.New("đường dẫn file không được để trống")
	}

	ext := strings.ToLower(filepath.Ext(path))
	if !isSupportedDocumentExt(ext) {
		return nil, fmt.Errorf("định dạng file %q không được hỗ trợ (chỉ hỗ trợ PDF, Word, Ảnh và TXT)", ext)
	}

	documentID := uuid.New()
	destFilePath := filepath.Join(h.storageDir, documentID.String()+ext)

	err = copyFile(path, destFilePath)
	if err != nil {
		return nil, fmt.Errorf("không thể sao chép file: %w", err)
	}
	defer func() {
		if err != nil {
			if rmErr := os.Remove(destFilePath); rmErr != nil && !os.IsNotExist(rmErr) {
				log.Printf("cảnh báo: không thể xóa file tạm %s: %v", destFilePath, rmErr)
			}
		}
	}()

	pageCount := 1
	if ext == ".pdf" {
		count, errCount := api.PageCountFile(destFilePath)
		if errCount != nil {
			log.Printf("cảnh báo: không thể đếm số trang PDF %s (mặc định 1 trang): %v", destFilePath, errCount)
			pageCount = 1
		} else if count > 0 {
			pageCount = count
		}
	}

	d = &Document{
		ID:        documentID,
		FileName:  filepath.Base(path),
		FilePath:  destFilePath,
		PageCount: pageCount,
		CreatedAt: time.Now(),
	}

	err = h.documentRepo.Save(ctx, d)
	if err != nil {
		return nil, fmt.Errorf("không thể lưu thông tin tài liệu vào repository: %w", err)
	}
	return d, nil
}

func (h *UploadDocumentHandler) UploadBytes(ctx context.Context, cmd UploadBytesCommand) (d *Document, err error) {
	name := strings.TrimSpace(cmd.FileName)
	if name == "" {
		name = fmt.Sprintf("pasted_%d.png", time.Now().Unix())
	}
	if len(cmd.Data) == 0 {
		return nil, errors.New("dữ liệu file tải lên rỗng")
	}

	ext := strings.ToLower(filepath.Ext(name))
	if ext == "" {
		ext = ".png"
		name += ext
	}
	if !isSupportedDocumentExt(ext) {
		return nil, fmt.Errorf("định dạng file %q không được hỗ trợ (chỉ hỗ trợ PDF, Word, Ảnh và TXT)", ext)
	}

	documentID := uuid.New()
	destFilePath := filepath.Join(h.storageDir, documentID.String()+ext)

	writeErr := os.WriteFile(destFilePath, cmd.Data, 0644)
	if writeErr != nil {
		return nil, fmt.Errorf("không thể ghi file đích: %w", writeErr)
	}
	defer func() {
		if err != nil {
			if rmErr := os.Remove(destFilePath); rmErr != nil && !os.IsNotExist(rmErr) {
				log.Printf("cảnh báo: không thể xóa file tạm %s: %v", destFilePath, rmErr)
			}
		}
	}()

	pageCount := 1
	if ext == ".pdf" {
		count, errCount := api.PageCountFile(destFilePath)
		if errCount != nil {
			log.Printf("cảnh báo: không thể đếm số trang PDF %s (mặc định 1 trang): %v", destFilePath, errCount)
			pageCount = 1
		} else if count > 0 {
			pageCount = count
		}
	}

	d = &Document{
		ID:        documentID,
		FileName:  filepath.Base(name),
		FilePath:  destFilePath,
		PageCount: pageCount,
		CreatedAt: time.Now(),
	}

	saveErr := h.documentRepo.Save(ctx, d)
	if saveErr != nil {
		return nil, fmt.Errorf("không thể lưu thông tin tài liệu vào repository: %w", saveErr)
	}

	return d, nil
}

func copyFile(srcPath, destPath string) (err error) {
	srcFile, err := os.Open(srcPath)
	if err != nil {
		return fmt.Errorf("không thể mở file nguồn: %w", err)
	}
	defer func() {
		if closeErr := srcFile.Close(); closeErr != nil && err == nil {
			err = fmt.Errorf("không thể đóng file nguồn: %w", closeErr)
		}
	}()

	destFile, err := os.Create(destPath)
	if err != nil {
		return fmt.Errorf("không thể tạo file đích: %w", err)
	}
	defer func() {
		if closeErr := destFile.Close(); closeErr != nil && err == nil {
			err = fmt.Errorf("không thể đóng file đích: %w", closeErr)
		}
		if err != nil {
			if rmErr := os.Remove(destPath); rmErr != nil && !os.IsNotExist(rmErr) {
				log.Printf("cảnh báo: không thể dọn dẹp file đích lỗi %s: %v", destPath, rmErr)
			}
		}
	}()

	_, err = io.Copy(destFile, srcFile)
	if err != nil {
		return fmt.Errorf("không thể sao chép nội dung file: %w", err)
	}

	if syncErr := destFile.Sync(); syncErr != nil {
		return fmt.Errorf("không thể đồng bộ file đích xuống đĩa: %w", syncErr)
	}

	return nil
}
