package ai

// Part đại diện cho một phần tử nội dung trong tài liệu (text, ảnh jpeg, audio...).
// Hoàn toàn trừu tượng và không phụ thuộc vào bất kỳ định dạng cụ thể nào.
type Part interface {
	MimeType() string
	Data() []byte
}

// Document là interface đại diện cho một tài liệu học tập đầu vào gửi tới AI.
// Thiết kế dạng Interface giúp nhất quán tuyệt đối, hỗ trợ mọi loại tài liệu (Text, Image, PDF...)
// mà không làm rò rỉ bất kỳ chi tiết cài đặt riêng lẻ nào.
type Document interface {
	ID() string
	Name() string
	Parts() []Part
}

// Config là interface đại diện cho cấu hình sinh nội dung (generation config) gửi tới AI.
// Do mỗi nhà cung cấp (DeepSeek, Gemini, OpenAI...) và mỗi đời model có các tham số rất khác nhau
// (temperature, max_tokens, thinking level, top_p, json_schema, response_format...),
// Config chỉ yêu cầu phương thức RawBytes() để mỗi provider tự định nghĩa struct riêng
// và serialize ra byte/JSON gửi đi theo đúng định dạng API của mình.
type Config interface {
	// RawBytes trả về dữ liệu cấu hình dưới dạng byte (thường là JSON bytes) để provider tự xử lý.
	RawBytes() []byte
}

// Usage là interface đại diện cho thông số token tiêu thụ do từng AI Provider trả về.
// Do mỗi nhà cung cấp (DeepSeek, Gemini, OpenAI...) trả về schema JSON hoàn toàn khác nhau,
// Usage trả về chuỗi JSON thô (Raw) để caller tự unmarshal vào struct cụ thể của từng hãng.
type Usage interface {
	// Raw trả về chuỗi JSON thô từ phản hồi của Provider.
	Raw() string

	// TotalTokens trả về tổng số token tiêu thụ (chỉ số cơ bản nhất dùng chung để ghi log).
	TotalTokens() int
}

// Request đóng gói đầy đủ tham số chung cho một lượt gọi AI, không hardcode bất kỳ config riêng nào.
type Request struct {
	Model        string     `json:"model"`
	SystemPrompt string     `json:"system_prompt,omitempty"`
	UserPrompt   string     `json:"user_prompt"`
	Documents    []Document `json:"documents,omitempty"`
	Config       Config     `json:"config,omitempty"` // Interface Config cho phép mỗi provider/model tự do cấu hình
}

// Response kết quả chuẩn hóa trả về từ AI Provider.
type Response struct {
	Content string `json:"content"` // Nội dung chính (văn bản hoặc JSON string) do AI sinh ra
	Usage   Usage  `json:"usage"`   // Interface Usage chứa Raw JSON để unmarshal token theo từng hãng
	Raw     string `json:"raw"`     // Chuỗi JSON thô đầy đủ từ response của Provider (để caller unmarshal reasoning, safety...)
	Model   string `json:"model"`   // Tên model thực tế đã xử lý
}

// =============================================================================
// CÁC HIỆN THỰC CƠ BẢN (DEFAULT IMPLEMENTATIONS)
// =============================================================================

// TextPart hiện thực Part cho văn bản thuần.
type TextPart struct {
	text string
}

// NewTextPart tạo một phần tử văn bản thuần.
func NewTextPart(text string) *TextPart {
	return &TextPart{text: text}
}

func (p *TextPart) MimeType() string { return "text/plain" }
func (p *TextPart) Data() []byte     { return []byte(p.text) }
func (p *TextPart) Text() string     { return p.text }

// MediaPart hiện thực Part cho dữ liệu nhị phân (JPEG, PNG, PDF blob...).
type MediaPart struct {
	mimeType string
	data     []byte
}

// NewMediaPart tạo một phần tử media với mimeType và data tương ứng.
func NewMediaPart(mimeType string, data []byte) *MediaPart {
	return &MediaPart{mimeType: mimeType, data: data}
}

func (p *MediaPart) MimeType() string { return p.mimeType }
func (p *MediaPart) Data() []byte     { return p.data }

// SimpleDocument là hiện thực mặc định của Document interface.
type SimpleDocument struct {
	id    string
	name  string
	parts []Part
}

// NewDocument tạo một Document từ danh sách các Part.
func NewDocument(id string, name string, parts ...Part) *SimpleDocument {
	return &SimpleDocument{
		id:    id,
		name:  name,
		parts: parts,
	}
}

func (d *SimpleDocument) ID() string    { return d.id }
func (d *SimpleDocument) Name() string  { return d.name }
func (d *SimpleDocument) Parts() []Part { return d.parts }

// SimpleConfig là hiện thực cơ bản của Config interface khi chỉ cần bọc chuỗi raw byte.
type SimpleConfig struct {
	raw []byte
}

// NewSimpleConfig tạo một SimpleConfig từ chuỗi byte thô.
func NewSimpleConfig(raw []byte) *SimpleConfig {
	return &SimpleConfig{raw: raw}
}

func (c *SimpleConfig) RawBytes() []byte {
	return c.raw
}

// SimpleUsage là hiện thực cơ bản của Usage interface khi chỉ cần bọc chuỗi raw.
type SimpleUsage struct {
	raw         string
	totalTokens int
}

// NewSimpleUsage tạo một SimpleUsage.
func NewSimpleUsage(raw string, totalTokens int) *SimpleUsage {
	return &SimpleUsage{raw: raw, totalTokens: totalTokens}
}

func (u *SimpleUsage) Raw() string      { return u.raw }
func (u *SimpleUsage) TotalTokens() int { return u.totalTokens }
