package sharekernel

import "strings"

type InlinePartType string

const (
	InlineText InlinePartType = "text"
	InlineMath InlinePartType = "math"
)

type InlinePart struct {
	Type  InlinePartType `json:"type"`  // "text" hoặc "math"
	Value string         `json:"value"` // Nội dung chữ hoặc công thức Typst
}

type Content struct {
	parts []InlinePart
}

func NewContent(parts ...InlinePart) Content {
	if len(parts) == 0 {
		return Content{parts: nil}
	}
	cp := make([]InlinePart, len(parts))
	copy(cp, parts)
	return Content{parts: cp}
}
func (c Content) IsEmpty() bool {
	if len(c.parts) == 0 {
		return true
	}
	for _, p := range c.parts {
		if strings.TrimSpace(p.Value) != "" {
			return false // Chỉ cần có 1 part có chữ/toán là không rỗng
		}
	}
	return true
}
func (c Content) String() string {
	if len(c.parts) == 0 {
		return ""
	}
	var sb strings.Builder
	for _, p := range c.parts {
		sb.WriteString(p.Value)
	}
	return sb.String()
}
func (c Content) Parts() []InlinePart {
	if len(c.parts) == 0 {
		return nil
	}
	cp := make([]InlinePart, len(c.parts))
	copy(cp, c.parts)
	return cp
}
