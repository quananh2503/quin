package document

import (
	"errors"
	"time"
	"uuid"
)

func ReconstituteSourceDocument(id uuid.UUID, fileName, storagePath string, totalPages int, previews []string, status DocumentStatus, createdAt time.Time, errorReason string) (*SourceDocument, error) {
	if id == uuid.Nil() || fileName == "" || createdAt.IsZero() {
		return nil, errors.New("dữ liệu document lưu trữ không hợp lệ")
	}
	if status != DocStatusProcessing && status != DocStatusReady && status != DocStatusFailed {
		return nil, errors.New("trạng thái document lưu trữ không hợp lệ")
	}
	d := &SourceDocument{id: id, originalFileName: fileName, storagePath: storagePath, totalPages: totalPages, pagePreviewURLs: append([]string(nil), previews...), status: status, createdAt: createdAt}
	if errorReason != "" {
		d.ErrReason = errors.New(errorReason)
	}
	return d, nil
}
