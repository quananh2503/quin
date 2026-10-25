package gemini_test

import (
	"os"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"meet-attendance-clean/infrastructure2/gemini"
)

func TestExtractVideoID(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected string
	}{
		{
			name:     "Full watch URL",
			input:    "https://www.youtube.com/watch?v=7urfQ8s20oY",
			expected: "7urfQ8s20oY",
		},
		{
			name:     "Full watch URL with extra params",
			input:    "https://www.youtube.com/watch?v=7urfQ8s20oY&t=120s&feature=shared",
			expected: "7urfQ8s20oY",
		},
		{
			name:     "Short youtu.be URL",
			input:    "https://youtu.be/7urfQ8s20oY",
			expected: "7urfQ8s20oY",
		},
		{
			name:     "Short youtu.be with timestamp",
			input:    "https://youtu.be/7urfQ8s20oY?t=15",
			expected: "7urfQ8s20oY",
		},
		{
			name:     "Raw 11-char Video ID",
			input:    "7urfQ8s20oY",
			expected: "7urfQ8s20oY",
		},
		{
			name:     "Invalid URL",
			input:    "https://google.com/search?q=math",
			expected: "",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			actual := gemini.ExtractVideoID(tc.input)
			assert.Equal(t, tc.expected, actual)
		})
	}
}

func TestFetchTranscript_Success(t *testing.T) {
	extractor := gemini.NewYouTubeTranscriptExtractor(15)
	videoURL := "https://www.youtube.com/watch?v=7urfQ8s20oY"

	transcript, err := extractor.FetchTranscript(videoURL)
	require.NoError(t, err)
	assert.NotEmpty(t, transcript)

	// Kiểm tra độ dài văn bản và nội dung sư phạm
	assert.Greater(t, len(transcript), 5000, "Bản chép lời phải có nội dung bài giảng đầy đủ")
	assert.True(t, strings.Contains(strings.ToLower(transcript), "nguyên hàm") || strings.Contains(transcript, "hàm"),
		"Bản chép lời phải chứa nội dung bài giảng nguyên hàm")

	// Lưu file kết quả để user kiểm tra/verify
	outPath := "youtube_transcript_7urfQ8s20oY.txt"
	errWrite := os.WriteFile(outPath, []byte(transcript), 0644)
	require.NoError(t, errWrite)
}

func TestFetchTranscript_VideoWithoutCaptions(t *testing.T) {
	extractor := gemini.NewYouTubeTranscriptExtractor(15)
	// Video không có CC -> Phải trả về error chuẩn mực, không được panic hay crash
	noCCVideoURL := "https://www.youtube.com/watch?v=j615s9znk4U"

	transcript, err := extractor.FetchTranscript(noCCVideoURL)
	assert.Error(t, err)
	assert.Empty(t, transcript)
}

func TestCleanTranscriptToParagraphs(t *testing.T) {
	raw := `0.00: chào các em hôm nay chúng ta học nguyên hàm
1.50: học nguyên hàm của hàm phân thức
6.20: bây giờ thầy hướng dẫn phương pháp che
7.10: phương pháp che để tìm hệ số
`
	paras := gemini.CleanTranscriptToParagraphs(raw)
	require.NotEmpty(t, paras)
	assert.GreaterOrEqual(t, len(paras), 1)
	assert.Contains(t, paras[0], "[00:00]")
	assert.Contains(t, paras[0], "nguyên hàm")
}

func TestRenderTranscriptTypst(t *testing.T) {
	paras := []string{
		"[00:00] bài 1.2 nguyên hàm đặc biệt",
		"[01:30] áp dụng phương pháp che cực nhanh",
	}
	markup := gemini.RenderTranscriptTypst("7urfQ8s20oY", "https://youtu.be/7urfQ8s20oY", paras)
	assert.Contains(t, markup, "7urfQ8s20oY")
	assert.Contains(t, markup, "#columns(2")
	assert.Contains(t, markup, "[00:00]")
}

func TestCompressPDFToNUp4(t *testing.T) {
	// Kiểm tra với dữ liệu rỗng
	_, err := gemini.CompressPDFToNUp4(nil)
	assert.Error(t, err)
}
