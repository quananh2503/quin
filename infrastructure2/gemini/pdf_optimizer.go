package gemini

import (
	"fmt"
	"image"
	"image/jpeg"
	_ "image/png"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"

	"github.com/pdfcpu/pdfcpu/pkg/api"
	"github.com/pdfcpu/pdfcpu/pkg/pdfcpu"
	"github.com/pdfcpu/pdfcpu/pkg/pdfcpu/model"
	"golang.org/x/image/draw"
)

// ScannedPDFThreshold dung lượng ngưỡng (10 MB) để kích hoạt tối ưu ảnh scan
const ScannedPDFThreshold = 10 * 1024 * 1024

// MaxScannedImageWidth chiều rộng pixel tối đa (1600px - tương đương 2 tiles 768px của Google Vision)
const MaxScannedImageWidth = 1600

// JpegQuality chất lượng nén ảnh JPEG (75%)
const JpegQuality = 75

var pageNumRegex = regexp.MustCompile(`_(\d+)_`)

func extractPageNumber(filename string) int {
	matches := pageNumRegex.FindStringSubmatch(filename)
	if len(matches) >= 2 {
		n, err := strconv.Atoi(matches[1])
		if err == nil {
			return n
		}
	}
	return 0
}

// OptimizeScannedPDF kiểm tra và tối ưu hóa tài liệu PDF ảnh scan dung lượng lớn (> 10MB).
// Các trang ảnh raster được trích xuất, co về chiều rộng tối đa 1600px và nén JPEG 75%,
// sau đó đóng gói lại thành PDF nhẹ (~5-8MB) để đảm bảo không vượt quá giới hạn 20MB inline của Gemini API.
// Nếu file <= 10MB hoặc không trích xuất được ảnh, hàm trả về nguyên bản dữ liệu đầu vào.
func OptimizeScannedPDF(pdfBytes []byte) ([]byte, error) {
	if len(pdfBytes) == 0 {
		return nil, fmt.Errorf("dữ liệu PDF rỗng")
	}

	// Nếu file nhỏ hơn hoặc bằng ngưỡng 10MB, bỏ qua để bảo toàn nguyên vẹn
	if len(pdfBytes) <= ScannedPDFThreshold {
		return pdfBytes, nil
	}

	tmpDir, err := os.MkdirTemp("", "quin_pdf_opt_*")
	if err != nil {
		return nil, fmt.Errorf("tạo thư mục tạm thất bại: %w", err)
	}
	defer func() {
		if rmErr := os.RemoveAll(tmpDir); rmErr != nil {
			log.Printf("dọn dẹp thư mục tạm %s thất bại: %v", tmpDir, rmErr)
		}
	}()

	inputPath := filepath.Join(tmpDir, "input.pdf")
	if errWrite := os.WriteFile(inputPath, pdfBytes, 0600); errWrite != nil {
		return nil, fmt.Errorf("ghi file PDF tạm thất bại: %w", errWrite)
	}

	extractDir := filepath.Join(tmpDir, "extracted")
	if errMkdir := os.MkdirAll(extractDir, 0755); errMkdir != nil {
		return nil, fmt.Errorf("tạo thư mục giải nén ảnh thất bại: %w", errMkdir)
	}

	conf := model.NewDefaultConfiguration()
	conf.ValidationMode = model.ValidationRelaxed

	errExtract := api.ExtractImagesFile(inputPath, extractDir, nil, conf)
	if errExtract != nil {
		// Nếu trích xuất ảnh thất bại (file bị mã hóa hoặc định dạng không chuẩn), fallback về file gốc
		log.Printf("trích xuất ảnh PDF thất bại (%v), giữ nguyên file gốc", errExtract)
		return pdfBytes, nil
	}

	entries, errRead := os.ReadDir(extractDir)
	if errRead != nil {
		return nil, fmt.Errorf("đọc thư mục ảnh giải nén thất bại: %w", errRead)
	}

	var rawImages []string
	for _, e := range entries {
		ext := strings.ToLower(filepath.Ext(e.Name()))
		if ext == ".png" || ext == ".jpg" || ext == ".jpeg" || ext == ".tif" || ext == ".tiff" {
			rawImages = append(rawImages, filepath.Join(extractDir, e.Name()))
		}
	}

	// Nếu không có ảnh nào trong file (PDF dạng text thuần túy), giữ nguyên file gốc
	if len(rawImages) == 0 {
		return pdfBytes, nil
	}

	// Sắp xếp các trang theo đúng thứ tự trang gốc
	sort.Slice(rawImages, func(i, j int) bool {
		p1 := extractPageNumber(filepath.Base(rawImages[i]))
		p2 := extractPageNumber(filepath.Base(rawImages[j]))
		if p1 != p2 {
			return p1 < p2
		}
		return rawImages[i] < rawImages[j]
	})

	compressedDir := filepath.Join(tmpDir, "compressed")
	if errMkdirComp := os.MkdirAll(compressedDir, 0755); errMkdirComp != nil {
		return nil, fmt.Errorf("tạo thư mục nén ảnh thất bại: %w", errMkdirComp)
	}

	var compressedImages []string
	for idx, imgPath := range rawImages {
		inF, errOpen := os.Open(imgPath)
		if errOpen != nil {
			log.Printf("mở ảnh %s thất bại: %v", imgPath, errOpen)
			continue
		}

		img, _, errDecode := image.Decode(inF)
		if errClose := inF.Close(); errClose != nil {
			log.Printf("đóng ảnh %s thất bại: %v", imgPath, errClose)
		}
		if errDecode != nil {
			log.Printf("giải mã ảnh %s thất bại: %v", imgPath, errDecode)
			continue
		}

		bounds := img.Bounds()
		origW := bounds.Dx()
		origH := bounds.Dy()

		targetW := origW
		targetH := origH
		if targetW > MaxScannedImageWidth {
			targetW = MaxScannedImageWidth
			targetH = int(float64(origH) * float64(MaxScannedImageWidth) / float64(origW))
		}

		var finalImg image.Image = img
		if targetW != origW {
			dst := image.NewRGBA(image.Rect(0, 0, targetW, targetH))
			draw.BiLinear.Scale(dst, dst.Bounds(), img, bounds, draw.Over, nil)
			finalImg = dst
		}

		outFileName := fmt.Sprintf("page_%04d.jpg", idx+1)
		outFilePath := filepath.Join(compressedDir, outFileName)
		outF, errCreate := os.Create(outFilePath)
		if errCreate != nil {
			log.Printf("tạo file ảnh nén %s thất bại: %v", outFilePath, errCreate)
			continue
		}

		errEncode := jpeg.Encode(outF, finalImg, &jpeg.Options{Quality: JpegQuality})
		if errCloseOut := outF.Close(); errCloseOut != nil {
			log.Printf("đóng file ảnh nén %s thất bại: %v", outFilePath, errCloseOut)
		}
		if errEncode != nil {
			log.Printf("mã hóa JPEG ảnh %s thất bại: %v", outFilePath, errEncode)
			continue
		}

		compressedImages = append(compressedImages, outFilePath)
	}

	if len(compressedImages) == 0 {
		return pdfBytes, nil
	}

	outPDFPath := filepath.Join(tmpDir, "optimized.pdf")
	imp := pdfcpu.DefaultImportConfig()

	if errImport := api.ImportImagesFile(compressedImages, outPDFPath, imp, conf); errImport != nil {
		log.Printf("đóng gói ảnh thành PDF thất bại: %v, fallback file gốc", errImport)
		return pdfBytes, nil
	}

	optimizedBytes, errReadOpt := os.ReadFile(outPDFPath)
	if errReadOpt != nil {
		log.Printf("đọc file PDF tối ưu thất bại: %v, fallback file gốc", errReadOpt)
		return pdfBytes, nil
	}

	// Đảm bảo file sau nén thực sự nhẹ hơn file gốc
	if len(optimizedBytes) < len(pdfBytes) {
		return optimizedBytes, nil
	}

	return pdfBytes, nil
}
