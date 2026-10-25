package gemini

import (
	"bufio"
	"bytes"
	"context"
	"fmt"
	"net/url"
	"regexp"
	"strconv"
	"strings"

	"github.com/horiagug/youtube-transcript-api-go/pkg/yt_transcript"
	"github.com/horiagug/youtube-transcript-api-go/pkg/yt_transcript_formatters"
	"github.com/pdfcpu/pdfcpu/pkg/api"
	"github.com/pdfcpu/pdfcpu/pkg/pdfcpu/model"
)

// ExtractVideoID: Trích xuất Video ID (11 ký tự) từ các dạng đường dẫn YouTube khác nhau
func ExtractVideoID(rawURL string) string {
	rawURL = strings.TrimSpace(rawURL)
	if len(rawURL) == 11 && !strings.Contains(rawURL, "/") && !strings.Contains(rawURL, "?") {
		return rawURL
	}
	u, err := url.Parse(rawURL)
	if err != nil {
		return ""
	}
	if u.Hostname() == "youtu.be" {
		return strings.TrimPrefix(u.Path, "/")
	}
	if strings.Contains(u.Hostname(), "youtube.com") {
		return u.Query().Get("v")
	}
	return ""
}

// YouTubeTranscriptExtractor: Bộ trích xuất bản chép lời (CC/Subtitles) từ YouTube
type YouTubeTranscriptExtractor struct {
	timeoutSeconds int
}

// NewYouTubeTranscriptExtractor: Khởi tạo bộ trích xuất transcript
func NewYouTubeTranscriptExtractor(timeoutSeconds int) *YouTubeTranscriptExtractor {
	if timeoutSeconds <= 0 {
		timeoutSeconds = 15
	}
	return &YouTubeTranscriptExtractor{
		timeoutSeconds: timeoutSeconds,
	}
}

// FetchTranscript: Lấy toàn bộ văn bản phụ đề tiếng Việt kèm mốc thời gian từ link YouTube
func (y *YouTubeTranscriptExtractor) FetchTranscript(rawURL string) (string, error) {
	videoID := ExtractVideoID(rawURL)
	if videoID == "" {
		return "", fmt.Errorf("đường dẫn YouTube không hợp lệ: %s", rawURL)
	}

	client := yt_transcript.NewClient(
		yt_transcript.WithTimeout(y.timeoutSeconds),
		yt_transcript.WithFormatter(yt_transcript_formatters.NewTextFormatter(
			yt_transcript_formatters.WithTimestamps(true),
		)),
	)

	// 1. Thử ưu tiên phụ đề tiếng Việt
	languages := []string{"vi", "vi-VN"}
	formatted, err := client.GetFormattedTranscripts(videoID, languages, false)
	if err == nil && strings.TrimSpace(formatted) != "" {
		return formatted, nil
	}

	// 2. Thử fallback lấy phụ đề mặc định (nếu video lưu mã ngôn ngữ khác)
	formattedDef, errDef := client.GetFormattedTranscripts(videoID, nil, false)
	if errDef == nil && strings.TrimSpace(formattedDef) != "" {
		return formattedDef, nil
	}

	return "", fmt.Errorf("không thể lấy phụ đề cho video %s (Lỗi vi: %v, Lỗi mặc định: %w)", videoID, err, errDef)
}

// CompressPDFToNUp4 nén tài liệu PDF bất kỳ theo lưới 2x2 (4 trang vào 1 sheet) bằng pdfcpu
func CompressPDFToNUp4(pdfBytes []byte) ([]byte, error) {
	if len(pdfBytes) == 0 {
		return nil, fmt.Errorf("dữ liệu PDF rỗng")
	}

	conf := model.NewDefaultConfiguration()
	conf.ValidationMode = model.ValidationRelaxed
	conf.Optimize = true

	nup, err := api.PDFNUpConfig(4, "", conf)
	if err != nil {
		return nil, fmt.Errorf("lỗi cấu hình N-Up 4: %w", err)
	}

	var nupBuf bytes.Buffer
	rs := bytes.NewReader(pdfBytes)
	if errNUp := api.NUp(rs, &nupBuf, nil, nil, nup, conf); errNUp != nil {
		return nil, fmt.Errorf("lỗi nén N-Up 4 bằng pdfcpu: %w", errNUp)
	}

	return nupBuf.Bytes(), nil
}

// CleanTranscriptToParagraphs gom các dòng ASR vụn vặt thành các đoạn văn mạch lạc theo khoảng nghỉ thời gian
func CleanTranscriptToParagraphs(rawTranscript string) []string {
	scanner := bufio.NewScanner(strings.NewReader(rawTranscript))
	timeRegex := regexp.MustCompile(`^([0-9.]+):\s*(.*)$`)

	type subLine struct {
		StartTime float64
		Text      string
	}

	var lines []subLine
	for scanner.Scan() {
		text := strings.TrimSpace(scanner.Text())
		if text == "" || strings.HasPrefix(text, "Language:") {
			continue
		}
		m := timeRegex.FindStringSubmatch(text)
		if len(m) == 3 {
			sec, errParse := strconv.ParseFloat(m[1], 64)
			if errParse != nil {
				continue
			}
			lines = append(lines, subLine{
				StartTime: sec,
				Text:      strings.TrimSpace(m[2]),
			})
		}
	}

	if len(lines) == 0 {
		return nil
	}

	var paragraphs []string
	var currentWords []string
	var paraStartTime float64 = -1

	for i := 0; i < len(lines); i++ {
		cur := lines[i]
		if paraStartTime < 0 {
			paraStartTime = cur.StartTime
		}

		words := strings.Fields(cur.Text)
		for _, w := range words {
			n := len(currentWords)
			if n > 0 && strings.EqualFold(currentWords[n-1], w) {
				continue
			}
			if n > 1 && strings.EqualFold(currentWords[n-2], w) {
				continue
			}
			currentWords = append(currentWords, w)
		}

		shouldBreak := false
		if i < len(lines)-1 {
			diff := lines[i+1].StartTime - cur.StartTime
			if diff > 5.0 || (diff > 3.0 && len(currentWords) > 35) {
				shouldBreak = true
			}
		} else {
			shouldBreak = true
		}

		if shouldBreak && len(currentWords) > 0 {
			paraText := strings.Join(currentWords, " ")
			min := int(paraStartTime) / 60
			sec := int(paraStartTime) % 60
			paragraphs = append(paragraphs, fmt.Sprintf("[%02d:%02d] %s", min, sec, paraText))
			currentWords = nil
			paraStartTime = -1
		}
	}

	return paragraphs
}

// RenderTranscriptTypst tạo tài liệu Typst 2 cột gọn gàng cho transcript YouTube
func RenderTranscriptTypst(videoID, rawURL string, paragraphs []string) string {
	var sb strings.Builder
	sb.WriteString(`#set page(
  paper: "a4",
  margin: (x: 1.2cm, top: 1.2cm, bottom: 1.2cm),
  numbering: "1",
  header: align(right)[#text(size: 8pt, fill: luma(100))[Bản chép lời bài giảng: ` + videoID + `]]
)
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans", "Liberation Sans"), size: 9pt, lang: "vi")
#set par(justify: true, leading: 0.55em, first-line-indent: 1.2em)

#align(center)[
  #text(size: 13pt, weight: "bold")[BẢN CHÉP LỜI MẠCH LẠC BÀI GIẢNG YOUTUBE] \
  #text(size: 9pt, fill: blue)[URL: ` + rawURL + `]
]

#v(0.5em)
#line(length: 100%, stroke: 0.5pt + gray)
#v(0.5em)

#columns(2, gutter: 1.0cm)[
`)

	timeTagRegex := regexp.MustCompile(`^(\[\d{2}:\d{2}\])\s*(.*)$`)
	for _, p := range paragraphs {
		m := timeTagRegex.FindStringSubmatch(p)
		if len(m) == 3 {
			escapedText := strings.ReplaceAll(m[2], "#", "\\#")
			escapedText = strings.ReplaceAll(escapedText, "$", "\\$")
			sb.WriteString(fmt.Sprintf("#text(fill: rgb(160, 30, 20), weight: \"bold\", size: 8pt)[%s] %s\n\n", m[1], escapedText))
		} else {
			escapedText := strings.ReplaceAll(p, "#", "\\#")
			escapedText = strings.ReplaceAll(escapedText, "$", "\\$")
			sb.WriteString(escapedText + "\n\n")
		}
	}

	sb.WriteString("]\n")
	return sb.String()
}

// ConvertYouTubeToNUpPDF: Cào transcript -> Ngắt đoạn -> Biên dịch Typst -> Nén N-Up 4
func ConvertYouTubeToNUpPDF(ctx context.Context, rawURL string) ([]byte, error) {
	extractor := NewYouTubeTranscriptExtractor(25)
	rawText, err := extractor.FetchTranscript(rawURL)
	if err != nil {
		return nil, fmt.Errorf("không thể tải phụ đề YouTube (%s): %w", rawURL, err)
	}

	paras := CleanTranscriptToParagraphs(rawText)
	if len(paras) == 0 {
		return nil, fmt.Errorf("transcript rỗng hoặc không trích xuất được nội dung: %s", rawURL)
	}

	videoID := ExtractVideoID(rawURL)
	typstMarkup := RenderTranscriptTypst(videoID, rawURL, paras)

	compiler := NewCLITypstCompiler()
	rawPDFBytes, err := compiler.CompileToBytes(ctx, typstMarkup)
	if err != nil {
		return nil, fmt.Errorf("biên dịch Typst transcript thất bại: %w", err)
	}

	nupBytes, err := CompressPDFToNUp4(rawPDFBytes)
	if err != nil {
		return rawPDFBytes, nil
	}

	return nupBytes, nil
}

// NewDocumentInputFromYouTube tạo DocumentInput chuẩn tự động từ link YouTube
func NewDocumentInputFromYouTube(ctx context.Context, docID, rawURL, roleHint string) (DocumentInput, error) {
	videoID := ExtractVideoID(rawURL)
	if videoID == "" {
		return DocumentInput{}, fmt.Errorf("đường dẫn YouTube không hợp lệ: %s", rawURL)
	}

	if roleHint == "" {
		roleHint = fmt.Sprintf("Video bài giảng YouTube (ID: %s): Trích xuất mẹo giải nhanh, phương pháp Casio và kỹ năng tư duy", videoID)
	}

	nupBytes, err := ConvertYouTubeToNUpPDF(ctx, rawURL)
	if err != nil {
		return DocumentInput{}, err
	}

	return DocumentInput{
		DocID:    docID,
		FileName: fmt.Sprintf("youtube_%s_nup4.pdf", videoID),
		RoleHint: roleHint,
		RawPDF:   nupBytes,
	}, nil
}
