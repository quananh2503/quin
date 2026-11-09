package media_test

import (
	"bytes"
	"context"
	"image"
	"image/color"
	"testing"

	"meet-attendance-clean/infrastructure2/media"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// =============================================================================
// UNIT TESTS: IMAGE TO JPEG CONVERTER
// =============================================================================

func TestImageToJPEGConverter_Convert_Success(t *testing.T) {
	ctx := context.Background()
	converter := media.NewImageToJPEGConverter(1600, 82)

	pngBytes := createSamplePNG(t, 100, 100, color.RGBA{G: 200, A: 255})
	jpegBytes, err := converter.Convert(ctx, pngBytes)
	require.NoError(t, err)
	require.NotEmpty(t, jpegBytes)

	// Kiểm tra magic bytes JPEG (\xff\xd8\xff)
	assert.Equal(t, byte(0xFF), jpegBytes[0])
	assert.Equal(t, byte(0xD8), jpegBytes[1])
	assert.Equal(t, byte(0xFF), jpegBytes[2])
}

func TestImageToJPEGConverter_Downscaling(t *testing.T) {
	ctx := context.Background()
	maxDim := 500
	converter := media.NewImageToJPEGConverter(maxDim, 80)

	// Tạo ảnh kích thước lớn: 1000 x 600
	largePNG := createSamplePNG(t, 1000, 600, color.RGBA{B: 255, A: 255})
	jpegBytes, err := converter.Convert(ctx, largePNG)
	require.NoError(t, err)

	// Giải mã lại ảnh JPEG để kiểm tra kích thước mới
	cfg, _, errCfg := image.DecodeConfig(bytes.NewReader(jpegBytes))
	require.NoError(t, errCfg)

	assert.Equal(t, 500, cfg.Width, "Cạnh rộng 1000 phải scale về 500")
	assert.Equal(t, 300, cfg.Height, "Cạnh cao 600 phải scale tỉ lệ về 300")
}

func TestImageToJPEGConverter_InvalidInput(t *testing.T) {
	ctx := context.Background()
	converter := media.NewImageToJPEGConverter(1600, 82)

	_, errEmpty := converter.Convert(ctx, nil)
	assert.Error(t, errEmpty)

	_, errCorrupt := converter.Convert(ctx, []byte("not an image"))
	assert.Error(t, errCorrupt)
}
