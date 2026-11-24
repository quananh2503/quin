package raw

// MaterialKind identifies the supported source material types.
type MaterialKind string

const (
	MaterialPDF     MaterialKind = "PDF"
	MaterialYouTube MaterialKind = "YOUTUBE"
	MaterialMistake MaterialKind = "MISTAKE"
)

// MaterialSpec describes a source material to be materialized into LLM-ready documents.
type MaterialSpec struct {
	Kind     MaterialKind
	ID       string
	Name     string
	FilePath string
	URL      string
	Text     string
}

// Part represents a single content piece (text or binary media) inside a Document.
type Part struct {
	MimeType string
	Data     []byte
	Text     string
}

// Document represents an input study document sent to an LLM provider.
type Document struct {
	ID    string
	Name  string
	Parts []Part
}
