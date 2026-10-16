package gemini

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"regexp"
	"strings"
	"time"

	"uuid"

	"github.com/invopop/jsonschema"

	// DUY NHẤT 1 PACKAGE CHUẨN CỦA GOOGLE
	"google.golang.org/genai"

	"meet-attendance-clean/domain2/assignment"
	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
)

type PDFProcessor interface {
	ExtractPages(ctx context.Context, filePath string, pages []int) ([]byte, error)
	PageCount(ctx context.Context, filePath string) (int, error)
}

type Client struct {
	client *genai.Client
	pdf    PDFProcessor
}

func New(ctx context.Context, key string, pdf PDFProcessor) (*Client, error) {
	key = strings.TrimSpace(key)
	if key == "" {
		return nil, errors.New("chưa cấu hình Gemini API key")
	}

	// Khởi tạo client theo chuẩn Google Gen AI SDK
	client, err := genai.NewClient(ctx, &genai.ClientConfig{
		APIKey:  key,
		Backend: genai.BackendGeminiAPI,
	})
	if err != nil {
		return nil, fmt.Errorf("khởi tạo Google GenAI SDK thất bại: %w", err)
	}

	return &Client{
		client: client,
		pdf:    pdf,
	}, nil
}

func (c *Client) Close() error {
	return nil
}

type ModelInfo struct {
	ID          string `json:"id"`
	DisplayName string `json:"display_name"`
	Description string `json:"description"`
}

func (c *Client) ListModels(ctx context.Context) ([]ModelInfo, error) {
	var models []ModelInfo
	page, err := c.client.Models.List(ctx, nil)
	if err != nil {
		return nil, err
	}

	for _, m := range page.Items {
		if !strings.Contains(m.Name, "gemini") {
			continue
		}
		models = append(models, ModelInfo{
			ID:          strings.TrimPrefix(m.Name, "models/"),
			DisplayName: m.DisplayName,
			Description: m.Description,
		})
	}
	return models, nil
}

// ============================================================================
// DTO ĐỊNH NGHĨA CẤU TRÚC JSON ĐỂ GEMINI SINH RA
// ============================================================================

type geminiInlinePart struct {
	Type  string `json:"type" jsonschema:"enum=text,enum=math,description=BẮT BUỘC: 'text' (chỉ chứa chữ tiếng Việt thuần, CẤM chứa biến số x y hoặc phép tính) hoặc 'math' (chứa công thức Typst, biến số x y, số liệu phép tính),required"`
	Value string `json:"value" jsonschema:"description=Nội dung chữ hoặc công thức Typst (TUYỆT ĐỐI KHÔNG có dấu $),required"`
}

type geminiContent struct {
	Parts []geminiInlinePart `json:"parts" jsonschema:"description=Danh sách các phần tử chữ và toán xen kẽ,required"`
}

type geminiClozePart struct {
	Type  string `json:"type" jsonschema:"enum=text,enum=math,enum=blank,description=text, math, hoặc blank (chỗ trống cần điền),required"`
	Value string `json:"value" jsonschema:"description=Nội dung chữ, công thức, hoặc ĐÁP ÁN ĐÚNG của chỗ trống,required"`
}

type geminiClozeItem struct {
	Parts []geminiClozePart `json:"parts" jsonschema:"description=Mẩu câu tạo nên 1 dòng đục lỗ,required"`
}

type geminiBlock struct {
	Type string `json:"type" jsonschema:"enum=paragraph,enum=list,enum=formula,enum=example,enum=image,enum=cloze,enum=callout,description=Loại khối nội dung,required"`

	// 1. Cho Paragraph
	Body *geminiContent `json:"body,omitempty" jsonschema:"description=Dành cho paragraph"`

	// 2. Cho List
	IsOrdered *bool           `json:"is_ordered,omitempty" jsonschema:"description=true nếu đánh số 1. 2. 3., false nếu là gạch đầu dòng"`
	Items     []geminiContent `json:"items,omitempty" jsonschema:"description=Dành cho list: danh sách các mục"`

	// 3. Cho Formula
	Math string `json:"math,omitempty" jsonschema:"description=Dành cho formula: công thức toán khối căn giữa (không có $)"`

	// 4. Cho Example
	Title       *geminiContent `json:"title,omitempty" jsonschema:"description=Tiêu đề ví dụ (VD: 'Ví dụ 1')"`
	Problem     *geminiContent `json:"problem,omitempty" jsonschema:"description=Đề bài ví dụ"`
	Solution    *geminiContent `json:"solution,omitempty" jsonschema:"description=Lời giải chi tiết của giáo viên"`
	Explanation *geminiContent `json:"explanation,omitempty" jsonschema:"description=Giải thích thêm cho học sinh"`

	// 5. Cho Image
	SVG     string         `json:"svg,omitempty" jsonschema:"description=Mã <svg>...</svg> hoàn chỉnh nếu có hình vẽ/đồ thị/bảng biến thiên"`
	Caption *geminiContent `json:"caption,omitempty" jsonschema:"description=Chú thích ảnh"`

	// 6. Cho Cloze
	Instruction *geminiContent    `json:"instruction,omitempty" jsonschema:"description=Lời dẫn: 'Điền vào chỗ trống...'"`
	ClozeItems  []geminiClozeItem `json:"cloze_items,omitempty" jsonschema:"description=Danh sách các câu đục lỗ"`

	// 7. Cho Callout
	CalloutKind string         `json:"callout_kind,omitempty" jsonschema:"enum=tip,enum=note,enum=warning,description=tip (mẹo), note (ghi nhớ), warning (cảnh báo)"`
	CalloutBody *geminiContent `json:"callout_body,omitempty" jsonschema:"description=Nội dung ghi nhớ/mẹo"`
}

type geminiTopic struct {
	Title  geminiContent `json:"title" jsonschema:"description=Tiêu đề mục nhỏ (VD: '1. Khảo sát hàm số y = sin x'),required"`
	Blocks []geminiBlock `json:"blocks" jsonschema:"description=Danh sách các khối nội dung của mục này,required"`
}

type geminiSection struct {
	Title  geminiContent `json:"title" jsonschema:"description=Tiêu đề phần lớn (VD: 'I. ĐẠI SỐ TRỌNG TÂM'),required"`
	Topics []geminiTopic `json:"topics" jsonschema:"description=Danh sách các mục nhỏ trong phần này,required"`
}

type geminiOption struct {
	Label   string        `json:"label" jsonschema:"description=Nhãn đáp án: A, B, C, D,required"`
	Content geminiContent `json:"content" jsonschema:"description=Nội dung lựa chọn,required"`
}

type geminiEssayPart struct {
	Label    string        `json:"label" jsonschema:"description=Nhãn câu con: a, b, c,required"`
	Question geminiContent `json:"question" jsonschema:"description=Đề bài câu con,required"`
	Solution geminiContent `json:"solution" jsonschema:"description=Lời giải chi tiết câu con,required"`
	Rubric   geminiContent `json:"rubric" jsonschema:"description=Barem chấm điểm,required"`
}

type geminiExercise struct {
	Type       string            `json:"type" jsonschema:"enum=multiple-choice,enum=essay,description=multiple-choice hoặc essay,required"`
	Topic      string            `json:"topic" jsonschema:"description=Chủ đề kiến thức,required"`
	Difficulty string            `json:"difficulty" jsonschema:"enum=Nhận biết,enum=Thông hiểu,enum=Vận dụng,enum=Vận dụng cao,required"`
	Prompt     geminiContent     `json:"prompt" jsonschema:"description=Đề bài câu hỏi,required"`
	DiagramSVG string            `json:"diagram_svg,omitempty" jsonschema:"description=Mã SVG nếu câu hỏi có hình vẽ"`
	Options    []geminiOption    `json:"options,omitempty" jsonschema:"description=Bắt buộc 4 lựa chọn nếu là multiple-choice"`
	Solution   *geminiContent    `json:"solution,omitempty" jsonschema:"description=Lời giải chi tiết nếu là multiple-choice"`
	Parts      []geminiEssayPart `json:"parts,omitempty" jsonschema:"description=Danh sách các ý con nếu là essay"`
	Answer     string            `json:"answer" jsonschema:"enum=A,enum=B,enum=C,enum=D,enum=NONE,description=BẮT BUỘC: Điền A, B, C hoặc D nếu là multiple-choice. Điền NONE nếu là essay.,required"`
}

type generatedLesson struct {
	Title     geminiContent    `json:"title" jsonschema:"description=Tiêu đề bài học,required"`
	Overview  geminiContent    `json:"overview" jsonschema:"description=Tổng quan tóm tắt bài học,required"`
	Sections  []geminiSection  `json:"sections" jsonschema:"description=Các phần lý thuyết,required"`
	Exercises []geminiExercise `json:"exercises" jsonschema:"description=Danh sách bài tập,required"`
}

// Schemas định dạng cho Structured Output của Google SDK
var (
	lessonSchema  *genai.Schema
	gradingSchema *genai.Schema
)

type gradingMistakeResult struct {
	Topic  string `json:"topic" jsonschema:"description=Chủ đề kiến thức bị hổng,required"`
	Reason string `json:"reason" jsonschema:"description=Nguyên nhân sai lầm cụ thể,required"`
}

type gradingSubItemResult struct {
	Label     string `json:"label" jsonschema:"description=Nhãn câu con: a, b, c,required"`
	IsCorrect bool   `json:"is_correct" jsonschema:"description=true nếu làm đúng,required"`
	Comment   string `json:"comment" jsonschema:"description=Nhận xét câu con,required"`
}

type gradingItemResult struct {
	ItemID           string                 `json:"item_id" jsonschema:"description=UUID của câu hỏi,required"`
	Comment          string                 `json:"comment" jsonschema:"description=Nhận xét tổng quan,required"`
	DetectedMistakes []gradingMistakeResult `json:"detected_mistakes" jsonschema:"description=Các lỗi sai phát hiện được,required"`
	SubItems         []gradingSubItemResult `json:"sub_items" jsonschema:"description=Kết quả cho từng ý con essay,required"`
}

type gradingResponse struct {
	Results []gradingItemResult `json:"results" jsonschema:"description=Danh sách kết quả chấm bài,required"`
}

func init() {
	r := new(jsonschema.Reflector)
	r.ExpandedStruct = true
	r.DoNotReference = true

	// 1. Chuyển đổi generatedLesson thành genai.Schema
	lSchema := r.Reflect(&generatedLesson{})
	data, err := json.Marshal(lSchema)
	if err != nil {
		panic(err)
	}
	lessonSchema = &genai.Schema{}
	if err := json.Unmarshal(data, lessonSchema); err != nil {
		panic(err)
	}

	// 2. Chuyển đổi gradingResponse thành genai.Schema
	gSchema := r.Reflect(&gradingResponse{})
	gData, err := json.Marshal(gSchema)
	if err != nil {
		panic(err)
	}
	gradingSchema = &genai.Schema{}
	if err := json.Unmarshal(gData, gradingSchema); err != nil {
		panic(err)
	}
}

// ============================================================================
// SYSTEM PROMPTS (CHUẨN TYPST MATH & CẤU TRÚC 4 TẦNG)
// ==========================================

const baseLessonPrompt = `Bạn là một chuyên gia sư phạm Toán học hàng đầu. Nhiệm vụ của bạn là phân tích tài liệu và biên soạn bài giảng cùng hệ thống bài tập chất lượng cao theo đúng cấu trúc JSON yêu cầu.

=========================================
1. NGUYÊN TẮC ƯU TIÊN CAO NHẤT (USER PROMPT PRIORITY):
=========================================
- Nếu có "Yêu cầu tùy chỉnh của giáo viên" (Custom Prompt), bạn BẮT BUỘC PHẢI ƯU TIÊN TUÂN THỦ yêu cầu của giáo viên trước tiên (về số lượng câu hỏi, dạng bài, mức độ khó, nội dung trọng tâm...).

=========================================
2. QUY TẮC BẮT BUỘC TÁCH INLINE MATH VÀ TEXT TRONG "PARTS":
=========================================
- Định dạng toán phải tuân thủ 100% cú pháp TYPST (không dùng LaTeX, không có dấu gạch chéo ngược \, không có dấu $).
- BẮT BUỘC CHẺ NHỎ CÂU THÀNH NHIỀU PHẦN TỬ TRONG MẢNG "parts" NẾU CÂU CÓ CHỨA TOÁN:
  + "text": CHỈ ĐƯỢC CHỨA CHỮ TIẾNG VIỆT THUẦN TÚY. TUYỆT ĐỐI CẤM chứa bất kỳ ký hiệu toán học nào, cấm chứa dấu bằng (=), dấu bất đẳng thức (<=, >=, <, >), dấu căn (sqrt), lũy thừa (^), hoặc các biến số đơn lẻ (x, y, a, b, P, S...).
  + "math": Chứa toàn bộ các công thức toán, biểu thức, phương trình, VÀ TẤT CẢ CÁC BIẾN SỐ (x, y, (x; y)...). TUYỆT ĐỐI KHÔNG BỌC TRONG DẤU $.

- CÁC VÍ DỤ BẮT BUỘC PHẢI HỌC THEO:
  Ví dụ 1 (Đề bài/Câu hỏi):
  [SAI]: {"type": "text", "value": "Tìm cặp số (x; y) thỏa mãn 2x^2 - 12x - y + 19 = 0"}
  [ĐÚNG]: [
    {"type": "text", "value": "Tìm cặp số "},
    {"type": "math", "value": "(x, y)"},
    {"type": "text", "value": " thỏa mãn "},
    {"type": "math", "value": "2x^2 - 12x - y + 19 = 0"}
  ]

  Ví dụ 2 (Chứng minh bất đẳng thức):
  [SAI]: {"type": "text", "value": "Chứng minh rằng (am + bn)^2 <= (a^2 + b^2)(m^2 + n^2)."}
  [ĐÚNG]: [
    {"type": "text", "value": "Chứng minh rằng "},
    {"type": "math", "value": "(a m + b n)^2 <= (a^2 + b^2)(m^2 + n^2)"},
    {"type": "text", "value": "."}
  ]

  Ví dụ 3 (Lời giải / Solution):
  [SAI]: {"type": "text", "value": "Vì x >= 0 nên sqrt(x) >= 0, suy ra C <= 1/2."}
  [ĐÚNG]: [
    {"type": "text", "value": "Vì "},
    {"type": "math", "value": "x >= 0"},
    {"type": "text", "value": " nên "},
    {"type": "math", "value": "sqrt(x) >= 0"},
    {"type": "text", "value": ", suy ra "},
    {"type": "math", "value": "C <= 1/2"},
    {"type": "text", "value": "."}
  ]
`
const pedagogicalMasterPrompt = `Bạn là Chuyên gia Biên soạn Giáo trình Toán học chuẩn mực.
Nhiệm vụ: Phân tích tài liệu đầu vào để biên soạn một BÀI GIẢNG TOÁN HỌC MẠCH LẠC kèm HỆ THỐNG BÀI TẬP LUYỆN TẬP SỐ NHIỀU, xuất ra định dạng JSON.

# 1. YÊU CẦU QUÉT TÀI LIỆU VÀ XÂY DỰNG LÝ THUYẾT
- Bao quát 100%: Bắt buộc quét toàn bộ tài liệu, phân loại và không bỏ sót bất kỳ dạng bài hay trường hợp đặc biệt nào.
- Giới hạn khống chế (Chống lặp nội dung): Với mỗi dạng toán (Topic), lý thuyết phải tinh gọn và tuân thủ NGHIÊM NGẶT giới hạn sau:
  + Tối đa 6 blocks cho mỗi Topic.
  + Tối đa 1 khối Ghi nhớ/Mẹo (Callout) và tối đa 1 khối Ví dụ (Example).
- Quy định điền dữ liệu (Không để rỗng ruột):
  + Example: Phải điền đầy đủ "title", "problem" (đề bài mẫu), và "solution" (lời giải chi tiết).
  + Callout: Phải điền đầy đủ "callout_kind", "title", và "callout_body" (nội dung mẹo Casio hoặc lưu ý).
  + Cloze (Điền từ): Tạo 1-2 câu điền khuyết công thức cốt lõi.

# 2. HỆ THỐNG BÀI TẬP: TỰ LUẬN SỐ NHIỀU (DRILL)
- Tương ứng 1-1: Trong lý thuyết có dạng toán nào, phần bài tập phải có câu tự luận (essay) rèn luyện cho dạng đó.
- Cấu trúc "Số nhiều" (Drill) cho một câu Tự luận:
  + Lời dẫn ("prompt"): CHỈ viết yêu cầu toán học trực tiếp dành cho học sinh (VD: "Giải các phương trình sau:", "Đổi các số đo sau sang radian:"). Không dùng từ ngữ sư phạm (như "tầng 1", "kỹ năng vi mô").
  + Các ý con ("parts"): Bắt buộc chứa 4 đến 5 ý con (a, b, c, d, e). Mỗi ý là một bài toán độc lập có cùng chung phương pháp giải nhưng thay đổi số liệu, đổi dấu, hoặc cài bẫy điều kiện để học sinh luyện làm cho quen tay.
  + Mỗi ý con đều phải có "question" và "solution" rõ ràng.
- Trắc nghiệm (multiple-choice): Chỉ tạo 1-2 câu nếu cần thiết để hỏi lý thuyết hoặc hướng dẫn bấm máy tính. Không lạm dụng trắc nghiệm.

# 3. QUY CHUẨN TOÁN TYPST VÀ PHÂN TÁCH KÝ TỰ
Trình biên dịch hệ thống sử dụng Typst. Nếu bạn dùng cú pháp LaTeX, hệ thống sẽ sập. Bắt buộc tuân thủ bảng quy đổi sau:
- Ký hiệu Độ: Dùng "30 degree" hoặc "30°". (Tuyệt đối không dùng ^circ hay \circ).
- Dấu nhân: Dùng "cdot". (Không dùng \cdot hay \times).
- Phân số: Dùng "A / B" hoặc phân thức. (Không dùng \frac).
- Hệ phương trình: Dùng "cases(A, B)". (Không dùng \begin{cases}).
- Tập hợp số: Dùng RR, ZZ, NN. (Không dùng \mathbb).
- Ký hiệu khác: Dùng "plus.minus" (±), "=>" (suy ra), "<=>" (tương đương), "!= " (khác).

Nguyên tắc tách mảng "parts" trong JSON:
- "text": CHỈ chứa chữ tiếng Việt thuần túy (VD: "Giải phương trình "). Không chứa x, y, công thức hay số liệu.
- "math": CHỈ chứa công thức, biến số, số liệu (VD: "2x + 1 = 0"). Không bọc trong dấu $.
`
const mistakeLessonPrompt = `
=========================================
CHỈ DẪN CHUYÊN BIỆT CHO BÀI HỌC SỬA LỖI SAI (REMEDIATION):
=========================================
1. ĐÁNH TRÚNG NGUYÊN NHÂN GỐC CỦA LỖI SAI (quên điều kiện, nhầm công thức, biến đổi sai dấu...).
2. BÀI TẬP PHẢN XẠ: Tạo các bài tập "TƯƠNG TỰ THAY SỐ" với câu học sinh đã làm sai để kiểm tra nhận thức.
3. LỜI GIẢI: Xoáy thẳng và làm nổi bật điểm then chốt mà học sinh hay mắc bẫy.`

// ============================================================================
// HÀM CALL API TRUNG TÂM SỬ DỤNG STRUCTURED OUTPUT & THINKING LEVEL
// ============================================================================

func (c *Client) generateRequest(ctx context.Context, modelName string, parts []*genai.Part, schema *genai.Schema, maxTokens int) (string, error) {
	modelName = strings.TrimSpace(modelName)
	if modelName == "" {
		modelName = "gemini-3.8-flash"
	}

	// Cấu hình chuẩn mới:
	// - ResponseSchema ép cấu trúc JSON phần cứng (Structured Outputs)
	// - ThinkingLevelMedium thay thế cho temperature cũ
	config := &genai.GenerateContentConfig{
		ResponseMIMEType: "application/json",
		ResponseSchema:   schema,
		ThinkingConfig: &genai.ThinkingConfig{
			ThinkingLevel: genai.ThinkingLevelMedium,
		},
	}

	if maxTokens > 0 {
		config.MaxOutputTokens = int32(maxTokens)
	}

	contents := []*genai.Content{
		{Parts: parts},
	}

	resp, err := c.client.Models.GenerateContent(ctx, modelName, contents, config)
	if err != nil {
		return "", err
	}

	text := strings.TrimSpace(resp.Text())
	text = strings.TrimPrefix(text, "```json")
	text = strings.TrimPrefix(text, "```")
	text = strings.TrimSuffix(text, "```")
	return strings.TrimSpace(text), nil
}

// ============================================================================
// HÀM CHÍNH: GENERATE LESSON TỪ GEMINI
// ============================================================================

func (c *Client) Generate(ctx context.Context, title string, materials []lesson.StudyMaterial, model, prompt string) (*lesson.Lesson, error) {
	if len(materials) == 0 {
		return nil, errors.New("danh sách study material không được để trống")
	}

	parts := make([]*genai.Part, 0)
	var materialSummaries []string

	// 1. Duyệt qua toàn bộ danh sách materials (xử lý đa file PDF và đa video YouTube)
	for idx, mat := range materials {
		switch source := mat.(type) {
		case lesson.YouTubeMaterial:
			parts = append(parts, &genai.Part{
				FileData: &genai.FileData{
					FileURI:  source.SourceURL(),
					MIMEType: "video/mp4",
				},
			})
			materialSummaries = append(materialSummaries, fmt.Sprintf("- Nguồn YouTube [%d]: URL %s (Khai thác mẹo giải nhanh, Casio)", idx+1, source.SourceURL()))

		case lesson.PDFMaterial:
			if c.pdf == nil {
				return nil, errors.New("chưa cấu hình PDF processor")
			}
			pdfBytes, err := c.pdf.ExtractPages(ctx, source.FilePath(), source.Pages())
			if err != nil {
				return nil, fmt.Errorf("lỗi đọc file PDF %s: %w", source.FilePath(), err)
			}
			parts = append(parts, &genai.Part{
				InlineData: &genai.Blob{
					MIMEType: "application/pdf",
					Data:     pdfBytes,
				},
			})
			materialSummaries = append(materialSummaries, fmt.Sprintf("- Nguồn PDF [%d]: %s (Khai thác lý thuyết, phân loại dạng bài)", idx+1, source.FilePath()))

		case lesson.MistakeMaterial:
			parts = append(parts, &genai.Part{
				Text: fmt.Sprintf("Mục tiêu khắc phục lỗi sai: Chủ đề %s | Nguyên nhân: %s", source.Topic(), source.Reason()),
			})
			materialSummaries = append(materialSummaries, fmt.Sprintf("- Nguồn khắc phục lỗi sai: %s", source.Topic()))

		default:
			return nil, fmt.Errorf("loại study material thứ %d không được hỗ trợ: %T", idx+1, mat)
		}
	}

	// 2. Kết hợp Master Prompt và Custom Prompt của giáo viên
	fullPrompt := fmt.Sprintf("%s\n\nDANH SÁCH NGUỒN TÀI LIỆU CUNG CẤP:\n%s\n\nTIÊU ĐỀ GỢI Ý: %s\nYÊU CẦU TÙY CHỈNH CỦA GIÁO VIÊN: %s",
		pedagogicalMasterPrompt,
		strings.Join(materialSummaries, "\n"),
		strings.TrimSpace(title),
		strings.TrimSpace(prompt),
	)
	parts = append(parts, &genai.Part{Text: fullPrompt})

	fmt.Printf("[Google GenAI] Bắt đầu gọi API: %v (Số lượng materials: %d)\n", time.Now().Format("15:04:05"), len(materials))
	raw, err := c.generateRequest(ctx, model, parts, lessonSchema, 65536)
	if err != nil {
		return nil, err
	}
	fmt.Printf("[Google GenAI] Nhận phản hồi thành công: %v\n", time.Now().Format("15:04:05"))

	var generated generatedLesson
	if err := json.Unmarshal([]byte(raw), &generated); err != nil {
		return nil, fmt.Errorf("Gemini trả JSON không hợp lệ: %w (Gốc: %s)", err, raw)
	}

	// 3. Chuyển đổi Sections -> Topics -> Blocks vào Domain model
	sections := make([]lesson.Section, 0, len(generated.Sections))
	for _, secGen := range generated.Sections {
		topics := make([]lesson.Topic, 0, len(secGen.Topics))

		for _, topGen := range secGen.Topics {
			blocks := make([]lesson.Block, 0, len(topGen.Blocks))

			for _, bGen := range topGen.Blocks {
				block, err := convertGeminiBlock(bGen)
				if err != nil {
					return nil, err
				}
				blocks = append(blocks, block)
			}

			topic, err := lesson.NewTopic(toDomainContent(topGen.Title), blocks)
			if err != nil {
				return nil, err
			}
			topics = append(topics, topic)
		}

		section, err := lesson.NewSection(toDomainContent(secGen.Title), topics)
		if err != nil {
			return nil, err
		}
		sections = append(sections, section)
	}

	// 4. Chuyển đổi Bài tập (Đảm bảo quy tắc Clean Architecture / Domain kernel)
	if len(generated.Exercises) == 0 {
		return nil, errors.New("Gemini không sinh ra bài tập nào")
	}

	exercises := make([]sharekernel.Exercise, 0, len(generated.Exercises))
	for i, exGen := range generated.Exercises {
		topic := strings.TrimSpace(exGen.Topic)
		if topic == "" {
			topic = "Toán tổng hợp"
		}
		diff := strings.TrimSpace(exGen.Difficulty)
		if diff == "" {
			diff = "Thông hiểu"
		}

		var diag sharekernel.Diagram
		if strings.TrimSpace(exGen.DiagramSVG) != "" {
			diag = sharekernel.NewDiagram(sharekernel.DiagramSVG, exGen.DiagramSVG)
		} else {
			diag = sharekernel.NewDiagram(sharekernel.DiagramNone, "")
		}

		promptContent := toDomainContent(exGen.Prompt)
		var built sharekernel.Exercise

		switch exGen.Type {
		case "multiple-choice":
			opts := make([]sharekernel.MCOption, 0, len(exGen.Options))
			for _, opt := range exGen.Options {
				lbl := strings.TrimSpace(strings.ToUpper(opt.Label))
				mcOpt, err := sharekernel.NewMCOption(lbl, toDomainContent(opt.Content))
				if err != nil {
					return nil, fmt.Errorf("câu trắc nghiệm %d nhãn %s lỗi: %w", i+1, lbl, err)
				}
				opts = append(opts, mcOpt)
			}
			ans := strings.TrimSpace(strings.ToUpper(exGen.Answer))
			if len(ans) > 1 {
				ans = ans[:1]
			}

			var sol sharekernel.Content
			if exGen.Solution != nil {
				sol = toDomainContent(*exGen.Solution)
			}

			built, err = sharekernel.NewMultipleChoiceExercise(topic, diff, promptContent, opts, ans, sol, diag)

		case "essay":
			parts := make([]sharekernel.EssayPart, 0, len(exGen.Parts))
			for _, p := range exGen.Parts {
				lbl := strings.TrimSpace(p.Label)
				parts = append(parts, sharekernel.NewEssayPart(
					lbl,
					toDomainContent(p.Question),
					toDomainContent(p.Solution),
					toDomainContent(p.Rubric),
				))
			}
			built, err = sharekernel.NewEssayExercise(topic, diff, promptContent, parts, diag)

		default:
			return nil, fmt.Errorf("câu %d có loại bài tập không hợp lệ: %s", i+1, exGen.Type)
		}

		if err != nil {
			return nil, fmt.Errorf("câu %d khởi tạo thất bại: %w", i+1, err)
		}
		exercises = append(exercises, built)
	}

	lessonTitle := toDomainContent(generated.Title)
	if lessonTitle.IsEmpty() {
		lessonTitle = sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Bài giảng tổng hợp"})
	}
	lessonOverview := toDomainContent(generated.Overview)

	// Khởi tạo Lesson Domain Entity với mảng materials
	return lesson.NewLesson(lessonTitle, lessonOverview, sections, exercises, materials)
}

// ============================================================================
// HÀM CHUYỂN ĐỔI GEMINI DTO -> DOMAIN TYPES
// ============================================================================

func toDomainContent(gc geminiContent) sharekernel.Content {
	if len(gc.Parts) == 0 {
		return sharekernel.NewContent()
	}
	parts := make([]sharekernel.InlinePart, len(gc.Parts))
	for i, p := range gc.Parts {
		parts[i] = sharekernel.InlinePart{
			Type:  sharekernel.InlinePartType(p.Type),
			Value: p.Value,
		}
	}
	return sharekernel.NewContent(parts...)
}

func convertGeminiBlock(gb geminiBlock) (lesson.Block, error) {
	switch gb.Type {
	case "paragraph":
		body := sharekernel.NewContent()
		if gb.Body != nil {
			body = toDomainContent(*gb.Body)
		}
		return lesson.NewParagraphBlock(body), nil

	case "list":
		items := make([]sharekernel.Content, len(gb.Items))
		for i, it := range gb.Items {
			items[i] = toDomainContent(it)
		}
		isOrd := false
		if gb.IsOrdered != nil {
			isOrd = *gb.IsOrdered
		}
		return lesson.NewListBlock(isOrd, items), nil

	case "formula":
		return lesson.NewFormulaBlock(strings.TrimSpace(gb.Math)), nil

	case "example":
		var t, p, s, e sharekernel.Content
		if gb.Title != nil {
			t = toDomainContent(*gb.Title)
		}
		if gb.Problem != nil {
			p = toDomainContent(*gb.Problem)
		}
		if gb.Solution != nil {
			s = toDomainContent(*gb.Solution)
		}
		if gb.Explanation != nil {
			e = toDomainContent(*gb.Explanation)
		}
		return lesson.NewExampleBlock(t, p, s, e), nil

	case "image":
		var cap sharekernel.Content
		if gb.Caption != nil {
			cap = toDomainContent(*gb.Caption)
		}
		return lesson.NewImageBlock(strings.TrimSpace(gb.SVG), cap), nil

	case "cloze":
		var inst sharekernel.Content
		if gb.Instruction != nil {
			inst = toDomainContent(*gb.Instruction)
		}
		items := make([]lesson.ClozeItem, len(gb.ClozeItems))
		for i, it := range gb.ClozeItems {
			parts := make([]lesson.ClozePart, len(it.Parts))
			for j, p := range it.Parts {
				parts[j] = lesson.ClozePart{
					Type:  lesson.ClozePartType(p.Type),
					Value: p.Value,
				}
			}
			items[i] = lesson.ClozeItem{Parts: parts}
		}
		return lesson.NewClozeBlock(inst, items), nil

	case "callout":
		var t, b sharekernel.Content
		if gb.Title != nil {
			t = toDomainContent(*gb.Title)
		}
		if gb.CalloutBody != nil {
			b = toDomainContent(*gb.CalloutBody)
		}
		return lesson.NewCalloutBlock(lesson.CalloutKind(gb.CalloutKind), t, b), nil

	default:
		return nil, fmt.Errorf("loại block từ Gemini không hợp lệ: %s", gb.Type)
	}
}

// ============================================================================
// CHẤM BÀI (EVALUATE / GRADING)
// ============================================================================

type gradeInput struct {
	ItemID         uuid.UUID                `json:"item_id"`
	Type           sharekernel.ExerciseType `json:"type"`
	Topic          string                   `json:"topic"`
	Question       string                   `json:"question"`
	Options        []string                 `json:"options,omitempty"`
	CorrectAnswer  string                   `json:"correct_answer,omitempty"`
	Solution       string                   `json:"solution,omitempty"`
	SelectedOption string                   `json:"selected_option,omitempty"`
	TargetParts    []string                 `json:"target_parts,omitempty"`
	WorkingText    string                   `json:"working_text"`
	Images         [][]byte                 `json:"-"`
}

const gradingPrompt = `Bạn là giáo viên chấm bài Toán. Hãy đọc chữ gõ, ảnh dán của từng câu và ảnh nét bút toàn trang.
Với mỗi MCQ, nhận xét cách làm; việc chọn đúng/sai đáp án do domain xử lý. Với essay, trả kết quả riêng cho mọi target_parts đã yêu cầu. Không dùng Markdown.`

func (c *Client) Evaluate(ctx context.Context, requests []assignment.EvaluationRequest, items []assignment.AssignmentItem, pageInk []byte, prompt, model string) ([]assignment.EvaluationResult, error) {
	if len(requests) == 0 {
		return nil, nil
	}

	byID := make(map[uuid.UUID]assignment.AssignmentItem, len(items))
	for _, item := range items {
		byID[item.ID()] = item
	}

	parts := []*genai.Part{
		{Text: gradingPrompt + "\nYêu cầu thêm: " + strings.TrimSpace(prompt)},
	}

	if len(pageInk) > 0 {
		parts = append(parts,
			&genai.Part{Text: "Nét bút toàn trang:"},
			detectImagePart(pageInk),
		)
	}

	inputs := make([]gradeInput, 0, len(requests))
	for _, request := range requests {
		item := byID[request.ItemID()]
		if item == nil {
			return nil, fmt.Errorf("không tìm thấy item %s trong assignment", request.ItemID())
		}

		ex := item.Exercise()
		in := gradeInput{
			ItemID:   item.ID(),
			Type:     ex.Type(),
			Topic:    ex.Topic(),
			Question: ex.Prompt().String(),
		}

		switch typedEx := ex.(type) {
		case sharekernel.MultipleChoiceExercise:
			req, ok := request.(assignment.MCQEvalReq)
			if !ok {
				return nil, fmt.Errorf("request MCQ %s sai type", item.ID())
			}
			for _, option := range typedEx.Options() {
				in.Options = append(in.Options, option.Label()+". "+option.Content().String())
			}
			in.CorrectAnswer = typedEx.Answer()
			in.Solution = typedEx.Solution().String()
			in.SelectedOption = req.SelectedOption()
			in.WorkingText = req.WorkingText()
			in.Images = req.WorkingData()

		case sharekernel.EssayExercise:
			req, ok := request.(assignment.EssayEvalReq)
			if !ok {
				return nil, fmt.Errorf("request essay %s sai type", item.ID())
			}
			in.TargetParts = req.TargetParts()
			in.WorkingText = req.Text()
			in.Images = req.Data()
			for _, part := range typedEx.Parts() {
				in.Options = append(in.Options, part.Label()+": "+part.Question().String()+" | Đáp án: "+part.Solution().String()+" | Tiêu chí: "+part.Rubric().String())
			}
		}
		inputs = append(inputs, in)
	}

	encoded, err := json.Marshal(inputs)
	if err != nil {
		return nil, err
	}
	parts = append(parts, &genai.Part{Text: "Danh sách câu cần chấm: " + string(encoded)})

	for _, in := range inputs {
		for index, image := range in.Images {
			parts = append(parts,
				&genai.Part{Text: fmt.Sprintf("Ảnh item %s số %d:", in.ItemID, index+1)},
				detectImagePart(image),
			)
		}
	}

	raw, err := c.generateRequest(ctx, model, parts, gradingSchema, 16384)
	if err != nil {
		return nil, err
	}

	var decoded gradingResponse
	if err := json.Unmarshal([]byte(raw), &decoded); err != nil {
		return nil, fmt.Errorf("Gemini trả grading JSON không hợp lệ: %w", err)
	}

	results := make([]assignment.EvaluationResult, 0, len(decoded.Results))
	seen := make(map[uuid.UUID]bool)
	for _, result := range decoded.Results {
		parsedUUID, err := uuid.Parse(result.ItemID)
		if err != nil || seen[parsedUUID] {
			continue
		}
		item := byID[parsedUUID]
		if item == nil {
			continue
		}
		seen[parsedUUID] = true

		mistakes := make([]assignment.DetectedMistake, 0, len(result.DetectedMistakes))
		for _, m := range result.DetectedMistakes {
			mistakes = append(mistakes, assignment.NewDetectedMistake(m.Topic, m.Reason, parsedUUID))
		}

		switch item.Exercise().(type) {
		case sharekernel.MultipleChoiceExercise:
			results = append(results, assignment.NewMCQEvalRes(parsedUUID, result.Comment, mistakes))
		case sharekernel.EssayExercise:
			var subResults []assignment.SubEssayRes
			for _, sub := range result.SubItems {
				subResults = append(subResults, assignment.NewSubEssayRes(sub.Label, sub.IsCorrect, sub.Comment))
			}
			results = append(results, assignment.NewEssayEvalRes(parsedUUID, subResults, mistakes))
		}
	}
	return results, nil
}

func detectImagePart(data []byte) *genai.Part {
	contentType := http.DetectContentType(data)
	if !strings.HasPrefix(contentType, "image/") {
		contentType = "image/jpeg"
	}
	return &genai.Part{
		InlineData: &genai.Blob{
			MIMEType: contentType,
			Data:     data,
		},
	}
}

var (
	missingBracesTypeFirst = regexp.MustCompile(`(?s)\[\s*"type"\s*:\s*("[^"]*")\s*,\s*"value"\s*:\s*("(?:[^"\\]|\\.)*")\s*\]`)
	missingBracesValFirst  = regexp.MustCompile(`(?s)\[\s*"value"\s*:\s*("(?:[^"\\]|\\.)*")\s*,\s*"type"\s*:\s*("[^"]*")\s*\]`)
)

func repairGeminiJSON(raw string) string {
	raw = missingBracesTypeFirst.ReplaceAllString(raw, `[{"type": $1, "value": $2}]`)
	raw = missingBracesValFirst.ReplaceAllString(raw, `[{"value": $1, "type": $2}]`)
	return raw
}
