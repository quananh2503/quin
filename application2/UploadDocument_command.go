package application2

import (
	"context"
	"errors"
	"fmt"
	"io"
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
type UploadDocumentHandler struct {
	documentRepo DocumentRepository
	storageDir   string // Thư mục lưu trữ file trong app
}

func NewUploadDocumentHandler(repo DocumentRepository, storageDir string) (*UploadDocumentHandler, error) {
	if err := os.MkdirAll(storageDir, 0755); err != nil {
		return nil, fmt.Errorf("Không thể tạo được thư mục lưu file: %w", err)
	}
	return &UploadDocumentHandler{
		documentRepo: repo,
		storageDir:   storageDir,
	}, nil
}
func (h *UploadDocumentHandler) Upload(ctx context.Context, cmd UploadCommand) (d *Document, err error) {
	path := strings.TrimSpace(cmd.SourceFilePath)
	if path == "" {
		return nil, errors.New("Đường dẫn file không được để trống")
	}
	ext := strings.ToLower(filepath.Ext(path))
	if ext != ".pdf" {
		return nil, errors.New("Chỉ hỗ trợ upload file PDF")
	}
	documentID := uuid.New()
	destFilePath := filepath.Join(h.storageDir, documentID.String()+ext)
	err = copyFile(path, destFilePath)
	if err != nil {
		return nil, fmt.Errorf("Không thể sao chép file: %w", err)
	}
	defer func() {
		if err != nil {
			os.Remove(destFilePath) // Xóa file nếu có lỗi xảy ra
		}
	}()
	pageCount, err := api.PageCountFile(destFilePath)
	if err != nil {
		return nil, fmt.Errorf("Không thể đếm số trang của file PDF: %w", err)
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
		return nil, fmt.Errorf("Không thể lưu thông tin tài liệu vào repository: %w", err)
	}
	return d, nil
}
func copyFile(srcPath, destPath string) (err error) {
	srcFile, err := os.Open(srcPath)
	if err != nil {
		return fmt.Errorf("Không thể mở file nguồn: %w", err)
	}
	defer srcFile.Close()

	destFile, err := os.Create(destPath)
	if err != nil {
		return fmt.Errorf("Không thể tạo file đích: %w", err)
	}
	defer func() {
		destFile.Close()
		if err != nil {
			os.Remove(destPath)
		}
	}()
	_, err = io.Copy(destFile, srcFile)
	if err != nil {
		return fmt.Errorf("Không thể sao chép nội dung file: %w", err)
	}
	return destFile.Sync()
}
