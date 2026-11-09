package media

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"meet-attendance-clean/domain2/document"
)

// =============================================================================
// MAIN CONVERTER ORCHESTRATOR
// =============================================================================

// Converter điều phối việc nhận diện và chuyển đổi mọi loại tài liệu sang JPEG
type Converter struct {
	detector         TypeDetector
	imageConverter   *ImageToJPEGConverter
	pdfConverter     *PDFToJPEGConverter
	docxConverter    *DocxToJPEGConverter
	textConverter    *TextToJPEGConverter
	youtubeConverter *YouTubeToJPEGConverter
}

// NewConverter khởi tạo Converter hoàn chỉnh với các cấu hình tối ưu mặc định
func NewConverter() *Converter {
	pdfConv := NewPDFToJPEGConverter(150, 82)
	imgConv := NewImageToJPEGConverter(1600, 82)
	textConv := NewTextToJPEGConverter(imgConv, pdfConv)
	ytConv := NewYouTubeToJPEGConverter(nil, textConv)

	return &Converter{
		detector:         *NewTypeDetector(),
		imageConverter:   imgConv,
		pdfConverter:     pdfConv,
		docxConverter:    NewDocxToJPEGConverter(pdfConv),
		textConverter:    textConv,
		youtubeConverter: ytConv,
	}
}

// WithDetector gán detector tùy biến
func (c *Converter) WithDetector(d TypeDetector) *Converter {
	c.detector = d
	return c
}

// WithImageConverter gán ImageToJPEGConverter tùy biến
func (c *Converter) WithImageConverter(ic *ImageToJPEGConverter) *Converter {
	c.imageConverter = ic
	return c
}

// WithPDFConverter gán PDFToJPEGConverter tùy biến
func (c *Converter) WithPDFConverter(pc *PDFToJPEGConverter) *Converter {
	c.pdfConverter = pc
	c.docxConverter = NewDocxToJPEGConverter(pc)
	return c
}

// WithTextConverter gán TextToJPEGConverter tùy biến
func (c *Converter) WithTextConverter(tc *TextToJPEGConverter) *Converter {
	c.textConverter = tc
	return c
}

// WithYouTubeConverter gán YouTubeToJPEGConverter tùy biến
func (c *Converter) WithYouTubeConverter(yc *YouTubeToJPEGConverter) *Converter {
	c.youtubeConverter = yc
	return c
}

// ConvertToJpeg chuyển đổi file tài liệu (SourceDocument) sang JPEG byte (trang đầu tiên)
func (c *Converter) ConvertToJpeg(ctx context.Context, doc *document.SourceDocument) ([]byte, error) {
	pages, err := c.ConvertToJPEGPages(ctx, doc)
	if err != nil {
		return nil, err
	}
	if len(pages) == 0 {
		return nil, fmt.Errorf("tài liệu không chứa trang nào")
	}
	return pages[0], nil
}

// ConvertToJepg là alias cho ConvertToJpeg để bảo đảm tương thích chính xác với draft
func (c *Converter) ConvertToJepg(ctx context.Context, doc *document.SourceDocument) ([]byte, error) {
	return c.ConvertToJpeg(ctx, doc)
}

// ConvertToJPEGPages chuyển đổi tài liệu sang danh sách đầy đủ các trang JPEG ([]byte)
func (c *Converter) ConvertToJPEGPages(ctx context.Context, doc *document.SourceDocument) ([][]byte, error) {
	if doc == nil {
		return nil, fmt.Errorf("SourceDocument nil")
	}

	storagePath := doc.StoragePath()
	if strings.TrimSpace(storagePath) == "" {
		return nil, fmt.Errorf("tài liệu %s chưa có storagePath", doc.OriginalFileName())
	}

	fileType, errDetect := c.detector.Detect(ctx, storagePath)
	if errDetect != nil {
		return nil, fmt.Errorf("nhận diện định dạng tài liệu %s thất bại: %w", storagePath, errDetect)
	}

	// Trường hợp tài liệu là YouTube URL: không đọc file từ đĩa mà gọi trực tiếp youtubeConverter
	if fileType == document.FileTypeYOUTUBE || IsYouTubeURL(storagePath) {
		return c.youtubeConverter.ConvertPages(ctx, []byte(storagePath))
	}

	raw, errRead := os.ReadFile(storagePath)
	if errRead != nil {
		return nil, fmt.Errorf("đọc file tài liệu từ %s thất bại: %w", storagePath, errRead)
	}

	return c.ConvertBytesToJPEGPages(ctx, raw, fileType, doc.OriginalFileName())
}

// ConvertBytesToJPEGPages chuyển đổi mảng byte thô sang các trang JPEG dựa theo FileType
func (c *Converter) ConvertBytesToJPEGPages(ctx context.Context, raw []byte, fileType document.FileType, fileName string) ([][]byte, error) {
	if len(raw) == 0 {
		return nil, fmt.Errorf("dữ liệu thô rỗng")
	}

	// Nếu chưa xác định FileType, tự động nhận diện từ raw bytes
	if fileType == "" || fileType == document.FileTypeUnknown {
		detected, errDet := c.detector.DetectBytes(ctx, raw, fileName)
		if errDet != nil {
			return nil, fmt.Errorf("tự động nhận diện bytes thất bại: %w", errDet)
		}
		fileType = detected
	}

	switch fileType {
	case document.FileTypePDF:
		return c.pdfConverter.ConvertPages(ctx, raw)

	case document.FileTypeDOCX:
		return c.docxConverter.ConvertPages(ctx, raw)

	case document.FileTypeTXT:
		return c.textConverter.ConvertPages(ctx, raw)

	case document.FileTypeYOUTUBE:
		return c.youtubeConverter.ConvertPages(ctx, raw)

	case document.FileTypePNG, document.FileTypeJPEG, document.FileTypeWEBP,
		document.FileTypeGIF, document.FileTypeBMP, document.FileTypeTIFF:
		jpegData, errConv := c.imageConverter.Convert(ctx, raw)
		if errConv != nil {
			return nil, fmt.Errorf("chuyển đổi ảnh %s sang JPEG thất bại: %w", fileType, errConv)
		}
		return [][]byte{jpegData}, nil

	default:
		return nil, fmt.Errorf("định dạng %s không được hỗ trợ chuyển đổi sang JPEG", fileType)
	}
}

// ConvertRawToJpeg chuyển đổi một file ảnh/pdf bất kỳ sang 1 trang JPEG
func (c *Converter) ConvertRawToJpeg(ctx context.Context, raw []byte, fileName string) ([]byte, error) {
	pages, err := c.ConvertBytesToJPEGPages(ctx, raw, "", fileName)
	if err != nil {
		return nil, err
	}
	if len(pages) == 0 {
		return nil, fmt.Errorf("không có trang nào được sinh ra")
	}
	return pages[0], nil
}

// SaveJPEGPagesToDir lưu các trang ảnh JPEG ([]byte) xuống một thư mục đầu ra trên đĩa
func SaveJPEGPagesToDir(pages [][]byte, outDir string, fileStem string) ([]string, error) {
	if len(pages) == 0 {
		return nil, fmt.Errorf("danh sách trang ảnh rỗng")
	}
	if errMk := os.MkdirAll(outDir, 0755); errMk != nil {
		return nil, fmt.Errorf("tạo thư mục xuất ảnh %s thất bại: %w", outDir, errMk)
	}

	cleanStem := strings.TrimSpace(fileStem)
	if cleanStem == "" {
		cleanStem = "page"
	}

	savedPaths := make([]string, 0, len(pages))
	for i, page := range pages {
		fileName := fmt.Sprintf("%s_page_%02d.jpg", cleanStem, i+1)
		outPath := filepath.Join(outDir, fileName)
		if errWrite := os.WriteFile(outPath, page, 0644); errWrite != nil {
			return nil, fmt.Errorf("ghi file ảnh %s thất bại: %w", outPath, errWrite)
		}
		savedPaths = append(savedPaths, outPath)
	}
	return savedPaths, nil
}

// ConvertAndSaveToDir chuyển đổi tài liệu SourceDocument và lưu thẳng tất cả các trang JPEG vào thư mục
func (c *Converter) ConvertAndSaveToDir(ctx context.Context, doc *document.SourceDocument, outDir string) ([]string, error) {
	if doc == nil {
		return nil, fmt.Errorf("SourceDocument nil")
	}

	storagePath := doc.StoragePath()

	// Nếu là tài liệu YouTube: cào transcript, lưu file .txt thô và xuất các trang JPEG
	if doc.FileType() == document.FileTypeYOUTUBE || IsYouTubeURL(storagePath) {
		savedImages, _, errYT := c.youtubeConverter.ConvertYouTubeAndSaveRaw(ctx, storagePath, outDir)
		if errYT != nil {
			return nil, errYT
		}
		return savedImages, nil
	}

	pages, err := c.ConvertToJPEGPages(ctx, doc)
	if err != nil {
		return nil, err
	}

	stem := strings.TrimSuffix(doc.OriginalFileName(), filepath.Ext(doc.OriginalFileName()))
	return SaveJPEGPagesToDir(pages, outDir, stem)
}
