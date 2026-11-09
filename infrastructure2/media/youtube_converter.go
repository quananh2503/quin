package media

import (
	"context"
	"fmt"
	"net/url"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/horiagug/youtube-transcript-api-go/pkg/yt_transcript"
)

var youtubeIDRegex = regexp.MustCompile(`^[a-zA-Z0-9_-]{11}$`)

// =============================================================================
// YOUTUBE VIDEO ID EXTRACTOR
// =============================================================================

// ExtractVideoID bóc tách mã định danh Video ID (11 ký tự) từ mọi dạng link YouTube
func ExtractVideoID(rawURL string) string {
	rawURL = strings.TrimSpace(rawURL)
	if rawURL == "" {
		return ""
	}

	// Nếu truyền trực tiếp Video ID (11 ký tự Base64URL)
	if len(rawURL) == 11 && !strings.Contains(rawURL, "/") && !strings.Contains(rawURL, "?") && !strings.Contains(rawURL, ".") {
		if youtubeIDRegex.MatchString(rawURL) {
			return rawURL
		}
	}

	u, err := url.Parse(rawURL)
	if err != nil {
		return ""
	}

	var extracted string
	if u.Hostname() == "youtu.be" {
		extracted = strings.TrimPrefix(u.Path, "/")
	} else if strings.Contains(u.Hostname(), "youtube.com") {
		if strings.HasPrefix(u.Path, "/shorts/") {
			extracted = strings.TrimPrefix(u.Path, "/shorts/")
		} else if strings.HasPrefix(u.Path, "/embed/") {
			extracted = strings.TrimPrefix(u.Path, "/embed/")
		} else {
			extracted = u.Query().Get("v")
		}
	}

	if youtubeIDRegex.MatchString(extracted) {
		return extracted
	}
	return ""
}

// IsYouTubeURL kiểm tra một chuỗi có phải là đường dẫn video YouTube hay không
func IsYouTubeURL(s string) bool {
	s = strings.TrimSpace(s)
	if strings.Contains(s, "youtube.com") || strings.Contains(s, "youtu.be") {
		return ExtractVideoID(s) != ""
	}
	return false
}

// =============================================================================
// YOUTUBE TRANSCRIPT FETCHER
// =============================================================================

// YouTubeTranscriptFetcher chịu trách nhiệm gọi API phụ đề YouTube
type YouTubeTranscriptFetcher struct {
	timeoutSeconds int
}

// NewYouTubeTranscriptFetcher khởi tạo fetcher với timeout cấu hình
func NewYouTubeTranscriptFetcher(timeoutSeconds int) *YouTubeTranscriptFetcher {
	if timeoutSeconds <= 0 {
		timeoutSeconds = 25
	}
	return &YouTubeTranscriptFetcher{timeoutSeconds: timeoutSeconds}
}

// FetchTranscript gọi YouTube Transcript API lấy toàn bộ nội dung phụ đề kèm mốc thời gian
func (f *YouTubeTranscriptFetcher) FetchTranscript(ctx context.Context, rawURL string) (string, string, error) {
	videoID := ExtractVideoID(rawURL)
	if videoID == "" {
		return "", "", fmt.Errorf("đường dẫn YouTube không hợp lệ: %s", rawURL)
	}

	client := yt_transcript.NewClient(
		yt_transcript.WithTimeout(f.timeoutSeconds),
	)

	// 1. Thử ưu tiên phụ đề tiếng Việt
	transcripts, err := client.GetTranscripts(videoID, []string{"vi", "vi-VN"})
	if err != nil || len(transcripts) == 0 {
		// 2. Thử fallback lấy phụ đề mặc định bất kỳ
		transcripts, err = client.GetTranscripts(videoID, nil)
		if err != nil || len(transcripts) == 0 {
			return "", "", fmt.Errorf("không thể lấy phụ đề cho video %s: %w", videoID, err)
		}
	}

	tr := transcripts[0]
	var sb strings.Builder
	for _, line := range tr.Lines {
		min := int(line.Start) / 60
		sec := int(line.Start) % 60
		sb.WriteString(fmt.Sprintf("[%02d:%02d] %s\n", min, sec, strings.TrimSpace(line.Text)))
	}

	return videoID, sb.String(), nil
}

// =============================================================================
// YOUTUBE TO JPEG CONVERTER
// =============================================================================

// YouTubeToJPEGConverter điều phối việc cào transcript YouTube, lưu .txt và chuyển thành các trang JPEG
type YouTubeToJPEGConverter struct {
	fetcher       *YouTubeTranscriptFetcher
	textConverter *TextToJPEGConverter
}

// NewYouTubeToJPEGConverter khởi tạo YouTubeToJPEGConverter
func NewYouTubeToJPEGConverter(fetcher *YouTubeTranscriptFetcher, textConv *TextToJPEGConverter) *YouTubeToJPEGConverter {
	if fetcher == nil {
		fetcher = NewYouTubeTranscriptFetcher(25)
	}
	if textConv == nil {
		textConv = NewTextToJPEGConverter(nil, nil)
	}
	return &YouTubeToJPEGConverter{
		fetcher:       fetcher,
		textConverter: textConv,
	}
}

// Convert chuyển đổi trang đầu tiên của video transcript sang JPEG
func (c *YouTubeToJPEGConverter) Convert(ctx context.Context, raw []byte) ([]byte, error) {
	pages, err := c.ConvertPages(ctx, raw)
	if err != nil {
		return nil, err
	}
	if len(pages) == 0 {
		return nil, fmt.Errorf("không có trang ảnh nào được tạo ra từ video YouTube")
	}
	return pages[0], nil
}

// ConvertPages cào transcript từ link YouTube, lọc số thô và chuyển thành các trang ảnh JPEG
func (c *YouTubeToJPEGConverter) ConvertPages(ctx context.Context, raw []byte) ([][]byte, error) {
	inputStr := strings.TrimSpace(string(raw))
	if inputStr == "" {
		return nil, fmt.Errorf("đầu vào rỗng")
	}

	var transcriptText string
	if IsYouTubeURL(inputStr) {
		videoID, rawText, errFetch := c.fetcher.FetchTranscript(ctx, inputStr)
		if errFetch != nil {
			return nil, errFetch
		}
		c.textConverter.WithTitle(fmt.Sprintf("BẢN CHÉP LỜI BÀI GIẢNG YOUTUBE (%s)", videoID))
		transcriptText = rawText
	} else {
		// Đã là văn bản transcript sẵn
		transcriptText = inputStr
	}

	// Chuyển văn bản transcript đã lọc số thô sang các trang ảnh JPEG
	return c.textConverter.ConvertPages(ctx, []byte(transcriptText))
}

// ConvertYouTubeAndSaveRaw cào transcript, lưu file .txt thô và xuất toàn bộ các trang JPEG vào outDir
func (c *YouTubeToJPEGConverter) ConvertYouTubeAndSaveRaw(ctx context.Context, rawURL, outDir string) ([]string, string, error) {
	if errMk := os.MkdirAll(outDir, 0755); errMk != nil {
		return nil, "", fmt.Errorf("tạo thư mục %s thất bại: %w", outDir, errMk)
	}

	videoID, rawTranscript, errFetch := c.fetcher.FetchTranscript(ctx, rawURL)
	if errFetch != nil {
		return nil, "", fmt.Errorf("cào transcript YouTube %s thất bại: %w", rawURL, errFetch)
	}

	// 1. Lưu file .txt thô chứa đầy đủ transcript kèm timestamp
	txtFileName := fmt.Sprintf("youtube_%s_raw.txt", videoID)
	txtPath := filepath.Join(outDir, txtFileName)
	if errWrite := os.WriteFile(txtPath, []byte(rawTranscript), 0644); errWrite != nil {
		return nil, "", fmt.Errorf("ghi file transcript thô %s thất bại: %w", txtPath, errWrite)
	}

	// 2. Lọc bỏ số thô và chuyển sang các trang ảnh JPEG
	c.textConverter.WithTitle(fmt.Sprintf("BẢN CHÉP LỜI BÀI GIẢNG YOUTUBE (%s)", videoID))
	jpegPages, errConv := c.textConverter.ConvertPages(ctx, []byte(rawTranscript))
	if errConv != nil {
		return nil, txtPath, fmt.Errorf("chuyển transcript sang ảnh JPEG thất bại: %w", errConv)
	}

	// 3. Lưu toàn bộ các trang JPEG vào outDir
	savedImages, errSave := SaveJPEGPagesToDir(jpegPages, outDir, fmt.Sprintf("youtube_%s", videoID))
	if errSave != nil {
		return nil, txtPath, fmt.Errorf("lưu các trang ảnh JPEG thất bại: %w", errSave)
	}

	return savedImages, txtPath, nil
}
