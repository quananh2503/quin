package media

import "context"

// =============================================================================
// INTERFACES
// =============================================================================

// Convert định nghĩa giao thức chuyển đổi dữ liệu thô sang định dạng mục tiêu đơn trang
type Convert interface {
	Convert(ctx context.Context, raw []byte) ([]byte, error)
}

// MultiPageConvert mở rộng cho tài liệu nhiều trang (như PDF, DOCX)
type MultiPageConvert interface {
	ConvertPages(ctx context.Context, raw []byte) ([][]byte, error)
}
