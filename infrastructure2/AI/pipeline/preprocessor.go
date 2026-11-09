package pipeline

import (
	"context"
	"fmt"
	"meet-attendance-clean/domain2/document"
	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/media"
)

// MediaDocumentPreprocessor triển khai Preprocessor sử dụng media.Converter đã có sẵn.
// Chuyển đổi mọi định dạng (PDF, DOCX, TXT, YouTube...) thành ai.Document chứa các Part (ảnh JPEG, text).
type MediaDocumentPreprocessor struct {
	converter *media.Converter
}

// NewMediaDocumentPreprocessor khởi tạo MediaDocumentPreprocessor.
func NewMediaDocumentPreprocessor(converter *media.Converter) *MediaDocumentPreprocessor {
	if converter == nil {
		converter = media.NewConverter()
	}
	return &MediaDocumentPreprocessor{converter: converter}
}

// Preprocess chuyển đổi SourceDocument thành ai.Document với các Part (JPEG và/hoặc text thô).
// Stub rỗng chờ duyệt pattern.
func (p *MediaDocumentPreprocessor) Preprocess(ctx context.Context, doc *document.SourceDocument) (ai.Document, error) {
	if doc == nil {
		return nil, fmt.Errorf("SourceDocument không được nil")
	}
	// TODO: Sau khi được duyệt, sẽ gọi p.converter.ConvertToJPEGPages(ctx, doc)
	// đóng gói thành ai.NewMediaPart("image/jpeg", pageBytes) và trả về ai.NewDocument(...).
	return nil, nil
}

// PreprocessBatch chuyển đổi danh sách các SourceDocument thành []ai.Document.
// Stub rỗng chờ duyệt pattern.
func (p *MediaDocumentPreprocessor) PreprocessBatch(ctx context.Context, docs []*document.SourceDocument) ([]ai.Document, error) {
	// TODO: Sau khi được duyệt, sẽ lặp qua docs và gọi Preprocess cho từng tài liệu.
	return nil, nil
}
