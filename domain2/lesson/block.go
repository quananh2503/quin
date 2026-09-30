package lesson

import (
	"errors"
	shareKernel "meet-attendance-clean/domain2/kernel"
)

// shareKernel "meet-attendance-clean/domain2/kernel"

// ============================================================
// TẦNG 4: CÁC KHỐI NỘI DUNG (BLOCKS - PHẲNG TUYỆT ĐỐI)
// ============================================================

type BlockType string

const (
	BlockParagraph BlockType = "paragraph"
	BlockList      BlockType = "list"
	BlockFormula   BlockType = "formula"
	BlockExample   BlockType = "example"
	BlockImage     BlockType = "image"
	BlockCloze     BlockType = "cloze"
	BlockCallout   BlockType = "callout"
)

func copyContent(c shareKernel.Content) shareKernel.Content {
	if len(c.Parts()) == 0 {
		return shareKernel.Content{}
	}
	parts := c.Parts()
	copiedParts := make([]shareKernel.InlinePart, len(parts))
	copy(copiedParts, parts)
	return shareKernel.NewContent(copiedParts...)
}

type Block interface {
	BlockType() BlockType
}

// 1. Đoạn văn xuôi
type ParagraphBlock struct {
	body shareKernel.Content
}

func NewParagraphBlock(body shareKernel.Content) ParagraphBlock {
	return ParagraphBlock{body: body}
}
func (p *ParagraphBlock) Body() shareKernel.Content { return p.body }

func (ParagraphBlock) BlockType() BlockType { return BlockParagraph }

// 2. Danh sách (Phẳng hoàn toàn, chỉ chứa Content)
type ListBlock struct {
	isOrdered bool
	items     []shareKernel.Content // Mỗi gạch đầu dòng là 1 Content
}

func NewListBlock(ordered bool, items []shareKernel.Content) ListBlock {
	return ListBlock{isOrdered: ordered, items: append([]shareKernel.Content(nil), items...)}
}

func (ListBlock) BlockType() BlockType { return BlockList }
func (l *ListBlock) IsOrdered() bool   { return l.isOrdered }
func (l *ListBlock) Items() []shareKernel.Content {
	copied := make([]shareKernel.Content, len(l.items))
	copy(copied, l.items)
	return copied
}

// 3. Công thức toán to đứng riêng một dòng
type FormulaBlock struct {
	math string // Ví dụ: "f(-x) = f(x)"
}

func NewFormulaBlock(math string) FormulaBlock {
	return FormulaBlock{math: math}
}
func (f *FormulaBlock) Math() string { return f.math }

func (FormulaBlock) BlockType() BlockType { return BlockFormula }

// 4. Ví dụ mẫu
type ExampleBlock struct {
	title       shareKernel.Content // "Ví dụ 1"
	problem     shareKernel.Content // Đề bài
	solution    shareKernel.Content // Lời giải (cho GV)
	explanation shareKernel.Content // Chú thích thêm nếu có
}

func NewExampleBlock(title, problem, solution, explanation shareKernel.Content) ExampleBlock {
	return ExampleBlock{
		title:       title,
		problem:     problem,
		solution:    solution,
		explanation: explanation,
	}
}
func (ExampleBlock) BlockType() BlockType                { return BlockExample }
func (e *ExampleBlock) Title() shareKernel.Content       { return copyContent(e.title) }
func (e *ExampleBlock) Problem() shareKernel.Content     { return copyContent(e.problem) }
func (e *ExampleBlock) Solution() shareKernel.Content    { return copyContent(e.solution) }
func (e *ExampleBlock) Explanation() shareKernel.Content { return copyContent(e.explanation) }

// 5. Hình vẽ minh họa (SVG)
type ImageBlock struct {
	svg     string              // Mã <svg>...</svg>
	caption shareKernel.Content // Chú thích dưới ảnh
}

func NewImageBlock(svg string, caption shareKernel.Content) ImageBlock {
	return ImageBlock{svg: svg, caption: caption}
}
func (ImageBlock) BlockType() BlockType            { return BlockImage }
func (i *ImageBlock) SVG() string                  { return i.svg }
func (i *ImageBlock) Caption() shareKernel.Content { return copyContent(i.caption) }

type ClozePartType string

const (
	ClozeText  ClozePartType = "text"  // Chữ bình thường
	ClozeMath  ClozePartType = "math"  // Công thức toán inline
	ClozeBlank ClozePartType = "blank" // Chỗ trống cần điền (Value chính là ĐÁP ÁN ĐÚNG)
)

type ClozePart struct {
	Type  ClozePartType // "text" | "math" | "blank"
	Value string        // Text, công thức, hoặc đáp án ẩn
}

func NewClozePart(partType ClozePartType, value string) ClozePart {
	return ClozePart{Type: partType, Value: value}
}

// Mỗi dòng đục lỗ là 1 ClozeItem (chứa các mẩu ghép lại)
type ClozeItem struct {
	Parts []ClozePart
}
type ClozeBlock struct {
	instruction shareKernel.Content // Lời dẫn: "Điền vào chỗ trống thích hợp:"
	items       []ClozeItem         // Danh sách các câu đục lỗ
}

func NewClozeBlock(instruction shareKernel.Content, items []ClozeItem) ClozeBlock {
	return ClozeBlock{instruction: instruction, items: append([]ClozeItem(nil), items...)}
}

func (c *ClozeBlock) Instruction() shareKernel.Content { return copyContent(c.instruction) }
func (c *ClozeBlock) Items() []ClozeItem {
	copied := make([]ClozeItem, len(c.items))
	copy(copied, c.items)
	return copied
}
func (ClozeBlock) BlockType() BlockType { return BlockCloze }

type CalloutKind string

const (
	CalloutTip     CalloutKind = "tip"     // 💡 Mẹo giải nhanh, mẹo bấm máy tính Casio
	CalloutNote    CalloutKind = "note"    // 📌 Ghi nhớ kiến thức cốt lõi
	CalloutWarning CalloutKind = "warning" // ⚠️ Cảnh báo bẫy, lỗi học sinh hay sai
)

type CalloutBlock struct {
	kind  CalloutKind         // "tip" | "note" | "warning"
	title shareKernel.Content // Tiêu đề hộp: "Mẹo làm nhanh", "Ghi nhớ", "Cảnh báo"
	body  shareKernel.Content // Nội dung bên trong (chứa text + math inline)
}

func NewCalloutBlock(kind CalloutKind, title, body shareKernel.Content) CalloutBlock {
	return CalloutBlock{kind: kind, title: title, body: body}
}

func (c *CalloutBlock) Kind() CalloutKind          { return c.kind }
func (c *CalloutBlock) Title() shareKernel.Content { return copyContent(c.title) }
func (c *CalloutBlock) Body() shareKernel.Content  { return copyContent(c.body) }

func (CalloutBlock) BlockType() BlockType { return BlockCallout }

type Topic struct {
	title  shareKernel.Content
	blocks []Block
}

func NewTopic(title shareKernel.Content, blocks []Block) (Topic, error) {
	if title.IsEmpty() {
		title = shareKernel.NewContent(shareKernel.InlinePart{Type: shareKernel.InlineText, Value: "Không có tiêu đề"})
	}
	return Topic{title: title, blocks: append([]Block(nil), blocks...)}, nil
}
func (t *Topic) Title() shareKernel.Content { return copyContent(t.title) }

func (t *Topic) Blocks() []Block {
	copied := make([]Block, len(t.blocks))
	copy(copied, t.blocks)
	return copied
}

type Section struct {
	title  shareKernel.Content
	topics []Topic
}

func NewSection(title shareKernel.Content, topics []Topic) (Section, error) {
	if title.IsEmpty() {
		title = shareKernel.NewContent(shareKernel.InlinePart{Type: shareKernel.InlineText, Value: "Không có tiêu đề"})
	}
	if len(topics) == 0 {
		return Section{}, errors.New("một section phải có ít nhất 1 topic")
	}
	return Section{title: title, topics: append([]Topic(nil), topics...)}, nil
}
func (s *Section) Title() shareKernel.Content { return copyContent(s.title) }

func (s *Section) Topics() []Topic {
	copied := make([]Topic, len(s.topics))
	copy(copied, s.topics)
	return copied
}

func ReconstituteParagraphBlock(body shareKernel.Content) Block { return ParagraphBlock{body: body} }
func ReconstituteListBlock(ordered bool, items []shareKernel.Content) Block {
	return ListBlock{isOrdered: ordered, items: append([]shareKernel.Content(nil), items...)}
}
func ReconstituteFormulaBlock(math string) Block { return FormulaBlock{math: math} }
func ReconstituteExampleBlock(title, problem, solution, explanation shareKernel.Content) Block {
	return ExampleBlock{title: title, problem: problem, solution: solution, explanation: explanation}
}
func ReconstituteImageBlock(svg string, caption shareKernel.Content) Block {
	return ImageBlock{svg: svg, caption: caption}
}
func ReconstituteClozeBlock(instruction shareKernel.Content, items []ClozeItem) Block {
	return ClozeBlock{instruction: instruction, items: append([]ClozeItem(nil), items...)}
}
func ReconstituteCalloutBlock(kind CalloutKind, title, body shareKernel.Content) Block {
	return CalloutBlock{kind: kind, title: title, body: body}
}
func ReconstituteTopic(title shareKernel.Content, blocks []Block) Topic {
	return Topic{title: title, blocks: append([]Block(nil), blocks...)}
}
func ReconstituteSection(title shareKernel.Content, topics []Topic) Section {
	return Section{title: title, topics: append([]Topic(nil), topics...)}
}
