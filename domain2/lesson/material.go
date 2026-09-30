package lesson

import (
	"errors"
	"net/url"
	"strings"
	"uuid"
)

type MaterialType string

const (
	MaterialYouTube MaterialType = "YOUTUBE"
	MaterialPDF     MaterialType = "PDF"
	MaterialMistake MaterialType = "MISTAKE"
)

// 1. ĐỊNH NGHĨA INTERFACE CHUNG
type StudyMaterial interface {
	Type() MaterialType
}

// 2. STRUCT DÀNH RIÊNG CHO YOUTUBE (Không chứa byte rác)
type YouTubeMaterial struct {
	sourceURL string
}

func (y YouTubeMaterial) Type() MaterialType { return MaterialYouTube }
func (y YouTubeMaterial) SourceURL() string  { return y.sourceURL }

func NewYouTubeMaterial(rawURL string) (YouTubeMaterial, error) {
	rawURL = strings.TrimSpace(rawURL)
	parsedURL, err := url.ParseRequestURI(rawURL)
	if err != nil || parsedURL.Host == "" {
		return YouTubeMaterial{}, errors.New("đường dẫn YouTube không hợp lệ")
	}

	host := strings.ToLower(parsedURL.Host)
	if !strings.Contains(host, "youtube.com") && !strings.Contains(host, "youtu.be") {
		return YouTubeMaterial{}, errors.New("chỉ chấp nhận link từ YouTube")
	}

	return YouTubeMaterial{sourceURL: rawURL}, nil
}

// 3. STRUCT DÀNH RIÊNG CHO PDF (Không chứa URL rác)
type PDFMaterial struct {
	filePath string
	pages    []int
}

func (p PDFMaterial) Type() MaterialType { return MaterialPDF }
func (p PDFMaterial) FilePath() string   { return p.filePath }
func (p PDFMaterial) Pages() []int       { return append([]int(nil), p.pages...) } // Trả về bản sao để tránh bị thay đổi từ bên ngoài

func NewSlicedPDFMaterial(filepath string, pages []int) (PDFMaterial, error) {
	if len(pages) == 0 {
		return PDFMaterial{}, errors.New("dữ liệu PDF rỗng")
	}
	return PDFMaterial{filePath: filepath, pages: append([]int(nil), pages...)}, nil
}

type MistakeItem struct {
	Topic  string
	Reason string
}
type MistakeMaterial struct {
	mistakeID      uuid.UUID
	studentID      uuid.UUID
	topic          string
	reason         string
	mistakeContext []MistakeItem
}

func NewMistakeMaterial(studentID uuid.UUID, mistakeID uuid.UUID, topic string, reason string, context []MistakeItem) MistakeMaterial {
	return MistakeMaterial{
		mistakeID:      mistakeID,
		studentID:      studentID,
		topic:          topic,
		reason:         reason,
		mistakeContext: append([]MistakeItem(nil), context...), // Copy slice để tránh bị thay đổi từ bên ngoài
	}
}
func (m MistakeMaterial) Type() MaterialType   { return MaterialMistake }
func (m MistakeMaterial) StudentID() uuid.UUID { return m.studentID }
func (m MistakeMaterial) MistakeID() uuid.UUID {
	return m.mistakeID
}

func (m MistakeMaterial) Topic() string  { return m.topic }
func (m MistakeMaterial) Reason() string { return m.reason }
func (m MistakeMaterial) Context() []MistakeItem {
	return append([]MistakeItem(nil), m.mistakeContext...)
}
