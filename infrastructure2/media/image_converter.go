package media

import (
	"bytes"
	"context"
	"fmt"
	"image"
	"image/draw"
	_ "image/gif"
	"image/jpeg"
	_ "image/png"

	_ "golang.org/x/image/bmp"
	xdraw "golang.org/x/image/draw"
	_ "golang.org/x/image/tiff"
	_ "golang.org/x/image/webp"
)

// =============================================================================
// IMAGE TO JPEG CONVERTER
// =============================================================================

// ImageToJPEGConverter chuyển đổi và chuẩn hóa mọi định dạng ảnh sang JPEG tối ưu cho AI
type ImageToJPEGConverter struct {
	maxDim  int
	quality int
}

// NewImageToJPEGConverter khởi tạo converter chuẩn hóa ảnh sang JPEG
func NewImageToJPEGConverter(maxDim, quality int) *ImageToJPEGConverter {
	if maxDim <= 0 {
		maxDim = 1600
	}
	if quality <= 0 || quality > 100 {
		quality = 82
	}
	return &ImageToJPEGConverter{
		maxDim:  maxDim,
		quality: quality,
	}
}

// Convert giải mã ảnh (PNG, WEBP, GIF, BMP, TIFF, JPEG) và nén sang JPEG với kích thước tối ưu
func (c *ImageToJPEGConverter) Convert(ctx context.Context, raw []byte) ([]byte, error) {
	if len(raw) == 0 {
		return nil, fmt.Errorf("dữ liệu ảnh rỗng")
	}

	src, _, err := image.Decode(bytes.NewReader(raw))
	if err != nil {
		return nil, fmt.Errorf("giải mã ảnh thất bại: %w", err)
	}

	bounds := src.Bounds()
	w := bounds.Dx()
	h := bounds.Dy()
	if w <= 0 || h <= 0 {
		return nil, fmt.Errorf("kích thước ảnh không hợp lệ: %dx%d", w, h)
	}

	targetW, targetH := w, h
	if w > c.maxDim || h > c.maxDim {
		if w > h {
			targetW = c.maxDim
			targetH = int(float64(h) * float64(c.maxDim) / float64(w))
		} else {
			targetH = c.maxDim
			targetW = int(float64(w) * float64(c.maxDim) / float64(h))
		}
	}

	var finalImg image.Image = src
	if targetW != w || targetH != h {
		dst := image.NewRGBA(image.Rect(0, 0, targetW, targetH))
		xdraw.ApproxBiLinear.Scale(dst, dst.Bounds(), src, bounds, draw.Over, nil)
		finalImg = dst
	}

	var buf bytes.Buffer
	opt := &jpeg.Options{Quality: c.quality}
	if errEnc := jpeg.Encode(&buf, finalImg, opt); errEnc != nil {
		return nil, fmt.Errorf("mã hóa sang JPEG thất bại: %w", errEnc)
	}

	return buf.Bytes(), nil
}
