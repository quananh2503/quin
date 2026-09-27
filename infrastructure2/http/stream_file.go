package main

import (
	"fmt"
	"meet-attendance-clean/application2"
	"net/http"
	"os"
	"path/filepath"
	"uuid"
	// "myapp/application2" // Import repo của bạn
)

type PDFStreamHandler struct {
	repo application2.DocumentRepository
}

func NewPDFStreamHandler(repo application2.DocumentRepository) *PDFStreamHandler {
	return &PDFStreamHandler{repo: repo}
}

// ServeHTTP: Tự động chạy mỗi khi React gọi /pdf-stream?id=...
func (h *PDFStreamHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// 1. Chỉ bắt đúng route /pdf-stream
	if r.URL.Path != "/pdf-stream" {
		http.NotFound(w, r)
		return
	}

	// 2. Lấy document ID từ query params
	idStr := r.URL.Query().Get("id")
	docID, err := uuid.Parse(idStr)
	if err != nil {
		http.Error(w, "ID tài liệu không hợp lệ", http.StatusBadRequest)
		return
	}

	// 3. Tìm đường dẫn file trong Database/Repo
	doc, err := h.repo.GetByID(r.Context(), docID)
	if err != nil {
		http.Error(w, "Không tìm thấy tài liệu", http.StatusNotFound)
		return
	}

	// 4. Mở file từ ổ cứng
	file, err := os.Open(doc.FilePath)
	if err != nil {
		http.Error(w, "Không thể mở file trên đĩa", http.StatusInternalServerError)
		return
	}
	defer file.Close()

	fi, err := file.Stat()
	if err != nil {
		http.Error(w, "Lỗi đọc metadata file", http.StatusInternalServerError)
		return
	}

	// 5. Cấu hình Range Request
	w.Header().Set("Accept-Ranges", "bytes")
	w.Header().Set("Content-Type", "application/pdf")
	w.Header().Set("Content-Disposition", fmt.Sprintf("inline; filename=\"%s\"", filepath.Base(doc.FileName)))

	// Hàm này của Go tự xử lý Header "Range: bytes=..." do React gửi xuống
	// Tốc độ bằng tốc độ đọc ổ cứng SSD, RAM Go = 0!
	http.ServeContent(w, r, doc.FileName, fi.ModTime(), file)
}
