package media_test

import (
	"context"
	"testing"
	"time"

	"meet-attendance-clean/infrastructure2/media"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// =============================================================================
// UNIT TESTS: TEXT CLEANER
// =============================================================================

func TestCleanRawText_FiltersNumbersAndTimestamps(t *testing.T) {
	rawInput := `Language: vi
Transcript: auto-generated
1
00:00:00,000 --> 00:00:02,500
0.00: [00:00] Chào mừng các em đến với buổi học hôm nay
2
00:00:02,500 --> 00:00:05,000
2.50: [00:02] Hôm nay chúng ta sẽ học về chuyên đề tích phân và toán thực tế
3
5.10: 5.10 Thầy sẽ hướng dẫn các em các công thức tính diện tích hình phẳng
`

	cleaned := media.CleanRawText(rawInput)
	require.NotEmpty(t, cleaned)

	// Kiểm tra các số thô và timestamps đã bị lọc sạch hoàn toàn
	assert.NotContains(t, cleaned, "Language:")
	assert.NotContains(t, cleaned, "-->")
	assert.NotContains(t, cleaned, "[00:00]")
	assert.NotContains(t, cleaned, "[00:02]")
	assert.NotContains(t, cleaned, "0.00:")
	assert.NotContains(t, cleaned, "2.50:")
	assert.NotContains(t, cleaned, "5.10:")

	// Kiểm tra nội dung chữ tiếng Việt cốt lõi được giữ lại nguyên vẹn
	assert.Contains(t, cleaned, "Chào mừng các em")
	assert.Contains(t, cleaned, "tích phân")
	assert.Contains(t, cleaned, "toán thực tế")
	assert.Contains(t, cleaned, "diện tích hình phẳng")
}

// =============================================================================
// INTEGRATION TESTS: TEXT TO JPEG CONVERTER
// =============================================================================

func TestTextToJPEGConverter_Convert_Success(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()

	converter := media.NewTextToJPEGConverter(nil, nil).
		WithTitle("CHUYÊN ĐỀ TÍCH PHÂN THỰC TẾ")

	sampleText := `0.00: [00:00] Chào các em, hôm nay chúng ta ôn tập về ứng dụng của tích phân.
1.50: [00:01] Bài toán tính thể tích vật thể tròn xoay và diện tích hình phẳng giới hạn bởi các đường cong.
3.00: [00:03] Ta có công thức tính diện tích hình phẳng bằng tích phân từ a đến b của trị tuyệt đối f(x) trừ g(x).
`

	pages, err := converter.ConvertPages(ctx, []byte(sampleText))
	require.NoError(t, err)
	require.NotEmpty(t, pages, "Kỳ vọng sinh ra ít nhất 1 trang JPEG")

	// Đảm bảo từng trang ảnh JPEG hợp lệ
	for i, page := range pages {
		assert.Greater(t, len(page), 1000, "Trang %d phải có dung lượng > 1KB", i+1)
		assert.Equal(t, byte(0xFF), page[0], "Magic byte 0 phải là 0xFF")
		assert.Equal(t, byte(0xD8), page[1], "Magic byte 1 phải là 0xD8")
		assert.Equal(t, byte(0xFF), page[2], "Magic byte 2 phải là 0xFF")
	}

	// Test Convert (trang đầu tiên)
	firstPage, errFirst := converter.Convert(ctx, []byte(sampleText))
	require.NoError(t, errFirst)
	assert.Equal(t, pages[0], firstPage)
}

func TestTextToJPEGConverter_InvalidInput(t *testing.T) {
	ctx := context.Background()
	converter := media.NewTextToJPEGConverter(nil, nil)

	_, errEmpty := converter.Convert(ctx, nil)
	assert.Error(t, errEmpty)

	_, errEmptyPages := converter.ConvertPages(ctx, nil)
	assert.Error(t, errEmptyPages)
}
