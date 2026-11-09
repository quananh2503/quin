package document

import (
	"time"
	"uuid"
)

type DocumentStatus string

const (
	DocStatusProcessing DocumentStatus = "PROCESSING" // Đang convert / render ảnh
	DocStatusReady      DocumentStatus = "READY"      // Đã sẵn sàng để lướt xem
	DocStatusFailed     DocumentStatus = "FAILED"
)

// FileType định nghĩa loại định dạng file tài liệu
type FileType string

const (
	FileTypePDF     FileType = "PDF"
	FileTypePNG     FileType = "PNG"
	FileTypeJPEG    FileType = "JPEG"
	FileTypeWEBP    FileType = "WEBP"
	FileTypeGIF     FileType = "GIF"
	FileTypeBMP     FileType = "BMP"
	FileTypeTIFF    FileType = "TIFF"
	FileTypeDOCX    FileType = "DOCX"
	FileTypeTXT     FileType = "TXT"
	FileTypeYOUTUBE FileType = "YOUTUBE"
	FileTypeUnknown FileType = "UNKNOWN"
)

// Aggregate Root: Tài liệu nguồn
type SourceDocument struct {
	id               uuid.UUID
	originalFileName string
	fileType         FileType
	storagePath      string   // Đường dẫn lưu file PDF gốc
	totalPages       int      // Tổng số trang
	pagePreviewURLs  []string // Danh sách link ảnh từng trang để chị bạn lướt xem
	status           DocumentStatus
	createdAt        time.Time
	ErrReason        error
}

func NewSourceDocument(fileName string) *SourceDocument {
	return &SourceDocument{
		id:               uuid.New(),
		originalFileName: fileName,
		status:           DocStatusProcessing,
		createdAt:        time.Now().UTC(),
	}
}

// Cập nhật khi hạ tầng convert & render xong
func (d *SourceDocument) MarkAsReady(pdfPath string, totalPages int, previewURLs []string) {
	d.storagePath = pdfPath
	d.totalPages = totalPages
	d.pagePreviewURLs = previewURLs
	d.status = DocStatusReady
}

func (d *SourceDocument) MarkAsFailed(err error) {
	d.ErrReason = err
	d.status = DocStatusFailed
}

// Getters and Setters...
func (d *SourceDocument) ID() uuid.UUID             { return d.id }
func (d *SourceDocument) TotalPages() int           { return d.totalPages }
func (d *SourceDocument) PagePreviewURLs() []string { return d.pagePreviewURLs }
func (d *SourceDocument) StoragePath() string       { return d.storagePath }
func (d *SourceDocument) SetStoragePath(p string)   { d.storagePath = p }
func (d *SourceDocument) FileType() FileType        { return d.fileType }
func (d *SourceDocument) SetFileType(ft FileType)   { d.fileType = ft }
func (d *SourceDocument) CreatedAt() time.Time      { return d.createdAt }
func (d *SourceDocument) OriginalFileName() string  { return d.originalFileName }
func (d *SourceDocument) ErrorReason() error        { return d.ErrReason }
func (d *SourceDocument) Status() DocumentStatus    { return d.status }
func (d *SourceDocument) IsReady() bool {
	return d.status == DocStatusReady
}
