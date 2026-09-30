package gemini

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"regexp"
	"strings"
	"uuid"

	"github.com/google/generative-ai-go/genai"
	"github.com/invopop/jsonschema"
	"google.golang.org/api/iterator"
	"google.golang.org/api/option"

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

	client, err := genai.NewClient(ctx, option.WithAPIKey(key))
	if err != nil {
		return nil, fmt.Errorf("khởi tạo Gemini SDK thất bại: %w", err)
	}

	return &Client{
		client: client,
		pdf:    pdf,
	}, nil
}

func (c *Client) Close() error {
	return c.client.Close()
}

type ModelInfo struct {
	ID          string `json:"id"`
	DisplayName string `json:"display_name"`
	Description string `json:"description"`
}

func (c *Client) ListModels(ctx context.Context) ([]ModelInfo, error) {
	var models []ModelInfo
	iter := c.client.ListModels(ctx)

	for {
		m, err := iter.Next()
		if errors.Is(err, iterator.Done) {
			break
		}
		if err != nil {
			return nil, err
		}

		if !strings.Contains(m.Name, "gemini") {
			continue
		}
		for _, method := range m.SupportedGenerationMethods {
			if method == "generateContent" {
				models = append(models, ModelInfo{
					ID:          strings.TrimPrefix(m.Name, "models/"),
					DisplayName: m.DisplayName,
					Description: m.Description,
				})
				break
			}
		}
	}
	return models, nil
}

// ============================================================================
// DTO ĐỊNH NGHĨA CẤU TRÚC JSON ĐỂ GEMINI SINH RA
// ============================================================================

type geminiInlinePart struct {
	Type  string `json:"type" jsonschema:"enum=text,enum=math,description=text (văn bản thuần) hoặc math (công thức toán Typst không có $),required"`
	Value string `json:"value" jsonschema:"description=Nội dung text hoặc công thức Typst,required"`
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
	Answer     string            `json:"answer,omitempty" jsonschema:"description=Chỉ ghi 1 chữ cái A, B, C hoặc D nếu là multiple-choice"`
	Solution   *geminiContent    `json:"solution,omitempty" jsonschema:"description=Lời giải nếu là multiple-choice"`
	Parts      []geminiEssayPart `json:"parts,omitempty" jsonschema:"description=Danh sách các ý con nếu là essay"`
}

type generatedLesson struct {
	Title     geminiContent    `json:"title" jsonschema:"description=Tiêu đề bài học,required"`
	Overview  geminiContent    `json:"overview" jsonschema:"description=Tổng quan tóm tắt bài học,required"`
	Sections  []geminiSection  `json:"sections" jsonschema:"description=Các phần lý thuyết,required"`
	Exercises []geminiExercise `json:"exercises" jsonschema:"description=Danh sách bài tập,required"`
}

var autoLessonSchema string

func init() {
	r := new(jsonschema.Reflector)
	r.ExpandedStruct = true
	r.DoNotReference = true
	schema := r.Reflect(&generatedLesson{})
	data, err := json.MarshalIndent(schema, "", "  ")
	if err != nil {
		panic(err)
	}
	autoLessonSchema = string(data)
}

// ============================================================================
// SYSTEM PROMPTS (CẬP NHẬT CHUẨN TYPST MATH & CẤU TRÚC 4 TẦNG)
// ============================================================================

const baseLessonPrompt = `Bạn là một chuyên gia sư phạm Toán học hàng đầu. Nhiệm vụ của bạn là phân tích tài liệu và biên soạn bài giảng cùng hệ thống bài tập chất lượng cao theo đúng cấu trúc JSON yêu cầu.

=========================================
1. NGUYÊN TẮC ƯU TIÊN CAO NHẤT (USER PROMPT PRIORITY):
=========================================
- Nếu có "Yêu cầu tùy chỉnh của giáo viên" (Custom Prompt), bạn BẮT BUỘC PHẢI ƯU TIÊN TUÂN THỦ yêu cầu của giáo viên trước tiên (về số lượng câu hỏi, dạng bài, mức độ khó, nội dung trọng tâm...).

=========================================
2. QUY TẮC CÔNG THỨC TOÁN HỌC (CHUẨN TYPST - TUYỆT ĐỐI KHÔNG DÙNG LATEX):
=========================================
- Định dạng toán phải tuân thủ 100% cú pháp TYPST:
  + CẤM DÙNG DẤU GẠCH CHÉO NGƯỢC (\): Không dùng \frac, \sqrt, \in, \le, \ge, \vec, \Delta...
  + Phân số: Dùng a/b hoặc frac(a, b).
  + Căn bậc hai: Dùng sqrt(x).
  + Ký hiệu toán học: Dùng in, infinity, times, alpha, beta, Delta, RR, NN, cases(...).
- Trong các đối tượng "parts":
  + Phần tử text: Chỉ chứa chữ tiếng Việt thuần túy.
  + Phần tử math: Chỉ chứa công thức Typst, TUYỆT ĐỐI KHÔNG BỌC TRONG DẤU $. Hệ thống hiển thị sẽ tự thêm dấu $.
- Trong FormulaBlock ("math"): Chỉ ghi công thức Typst thuần, không có dấu $.

=========================================
3. QUY TẮC VĂN BẢN VÀ CẤU TRÚC:
=========================================
- TUYỆT ĐỐI KHÔNG dùng ký hiệu Markdown như ###, ##, hoặc **in đậm** trong các chuỗi text.
- Mỗi phần lý thuyết được chia thành các Section -> Topic -> Blocks (paragraph, list, formula, example, image, cloze, callout).

=========================================
4. QUY TẮC BẮT BUỘC KHI VẼ HÌNH HỌC & BẢNG BIẾN THIÊN (SVG):
=========================================
- Nếu câu hỏi có hình học không gian, đồ thị hàm số hoặc bảng biến thiên, BẮT BUỘC phải tạo mã SVG hoàn chỉnh vào trường "svg" hoặc "diagram_svg". Nếu không có, để chuỗi rỗng "".
- Khi vẽ BẢNG BIẾN THIÊN trong SVG:
  + Bắt buộc khai báo đầu mũi tên ở đầu SVG: <defs><marker id="arrow" viewBox="0 0 10 10" refX="6" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 1 L 10 5 L 0 9 z" fill="#0f172a" /></marker></defs>
  + Hàng y BẮT BUỘC PHẢI CÓ ĐƯỜNG KẺ MŨI TÊN: Dùng <line marker-end="url(#arrow)" stroke="#0f172a" stroke-width="1.5" /> nối từ cực đại sang cực tiểu theo đúng chiều biến thiên.
  + Điểm không xác định: Vẽ 2 gạch song song "||" bằng 2 đường <line> đứng cách nhau 4px kéo dài từ hàng y' qua hàng y.`

const youtubeLessonPrompt = `
=========================================
CHỈ DẪN CHUYÊN BIỆT CHO NGUỒN VIDEO YOUTUBE:
=========================================
1. Bám sát 100% nội dung bài giảng của thầy/cô trong video, không tự ý thêm kiến thức ngoài phạm vi video.
2. VÍ DỤ MINH HỌA (ExampleBlock): Clone nguyên mẫu các ví dụ mà giáo viên đã chữa trên video.
3. BÀI TẬP THỰC HÀNH: Mặc định tạo đủ 20 câu (10 trắc nghiệm multiple-choice và 10 tự luận essay), bám sát dạng bài trong video theo hình thức thay số đổi dữ kiện.`

const pdfLessonPrompt = `
=========================================
CHỈ DẪN CHUYÊN BIỆT CHO NGUỒN TÀI LIỆU PDF:
=========================================
1. CLONE 1-1 Y HỆT NGUYÊN BẢN ĐỀ BÀI VÀ CÂU HỎI TRONG PDF ĐÃ CHỈ ĐỊNH.
2. Tóm tắt cực kỳ ngắn gọn lý thuyết cần dùng trong các Section ở đầu bài.
3. Tái hiện lại toàn bộ các câu hỏi trắc nghiệm và tự luận đúng theo barem gốc.`

const mistakeLessonPrompt = `
=========================================
CHỈ DẪN CHUYÊN BIỆT CHO BÀI HỌC SỬA LỖI SAI (REMEDIATION):
=========================================
1. ĐÁNH TRÚNG NGUYÊN NHÂN GỐC CỦA LỖI SAI (quên điều kiện, nhầm công thức, biến đổi sai dấu...).
2. BÀI TẬP PHẢN XẠ: Tạo các bài tập "TƯƠNG TỰ THAY SỐ" với câu học sinh đã làm sai để kiểm tra nhận thức.
3. LỜI GIẢI: Xoáy thẳng và làm nổi bật điểm then chốt mà học sinh hay mắc bẫy.`

// ============================================================================
// HÀM CHÍNH: GENERATE LESSON TỪ GEMINI
// ============================================================================

func (c *Client) Generate(ctx context.Context, title string, material lesson.StudyMaterial, model, prompt string) (*lesson.Lesson, error) {
	if material == nil {
		return nil, errors.New("material không được để trống")
	}

	parts := make([]genai.Part, 0, 3)
	matPrompt := baseLessonPrompt

	switch source := material.(type) {
	case lesson.YouTubeMaterial:
		parts = append(parts, genai.FileData{URI: source.SourceURL(), MIMEType: "video/mp4"})
		matPrompt += "\n\n" + youtubeLessonPrompt
	case lesson.MistakeMaterial:
		parts = append(parts, genai.Text(fmt.Sprintf("Khắc phục lỗi: %s | Lý do: %s", source.Topic(), source.Reason())))
		matPrompt += "\n\n" + mistakeLessonPrompt
	case lesson.PDFMaterial:
		if c.pdf == nil {
			return nil, errors.New("chưa cấu hình PDF processor")
		}
		pdfBytes, err := c.pdf.ExtractPages(ctx, source.FilePath(), source.Pages())
		if err != nil {
			return nil, err
		}
		parts = append(parts, genai.Blob{MIMEType: "application/pdf", Data: pdfBytes})
		matPrompt += "\n\n" + pdfLessonPrompt
	default:
		return nil, fmt.Errorf("loại material không hỗ trợ: %T", material)
	}

	fullPrompt := fmt.Sprintf("%s\n\nJSON SCHEMA BẮT BUỘC:\n%s\n\nTiêu đề gợi ý: %s\nYêu cầu tùy chỉnh: %s",
		matPrompt, autoLessonSchema, strings.TrimSpace(title), strings.TrimSpace(prompt))
	parts = append(parts, genai.Text(fullPrompt))

	raw, err := c.generateRequest(ctx, model, parts, 65536)
	if err != nil {
		return nil, err
	}
	raw = repairGeminiJSON(raw)
	var generated generatedLesson
	if err := json.Unmarshal([]byte(raw), &generated); err != nil {
		return nil, fmt.Errorf("Gemini trả JSON không hợp lệ: %w (Gốc: %s)", err, raw)
	}

	// 1. Ánh xạ Sections -> Topics -> Blocks
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

	// 2. Ánh xạ Exercises (Trắc nghiệm & Tự luận)
	if len(generated.Exercises) == 0 {
		return nil, errors.New("Gemini không tạo bài tập nào")
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
					return nil, fmt.Errorf("câu %d option %s lỗi: %w", i+1, lbl, err)
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
			return nil, fmt.Errorf("câu %d không hợp lệ: %w", i+1, err)
		}
		exercises = append(exercises, built)
	}

	lessonTitle := toDomainContent(generated.Title)
	if lessonTitle.IsEmpty() {
		lessonTitle = sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Bài học không có tiêu đề"})
	}
	lessonOverview := toDomainContent(generated.Overview)

	return lesson.NewLesson(lessonTitle, lessonOverview, sections, exercises, material)
}

func (c *Client) generateRequest(ctx context.Context, modelName string, parts []genai.Part, maxTokens int) (string, error) {
	modelName = strings.TrimSpace(modelName)
	if modelName == "" {
		modelName = "gemini-3.8-flash"
	}
	model := c.client.GenerativeModel(modelName)
	model.ResponseMIMEType = "application/json"
	model.SetTemperature(0.1)
	if maxTokens > 0 {
		model.SetMaxOutputTokens(int32(maxTokens))
	}
	resp, err := model.GenerateContent(ctx, parts...)
	if err != nil {
		return "", err
	}
	if len(resp.Candidates) == 0 || resp.Candidates[0].Content == nil {
		return "", errors.New("Gemini không trả về nội dung")
	}
	var sb strings.Builder
	for _, p := range resp.Candidates[0].Content.Parts {
		if t, ok := p.(genai.Text); ok {
			sb.WriteString(string(t))
		}
	}
	text := strings.TrimSpace(sb.String())
	text = strings.TrimPrefix(text, "```json")
	text = strings.TrimPrefix(text, "```")
	text = strings.TrimSuffix(text, "```")
	return strings.TrimSpace(text), nil
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
Trả đúng JSON {"results":[{"item_id":"UUID","comment":"nhận xét ngắn","detected_mistakes":[{"topic":"...","reason":"..."}],"sub_items":[{"label":"a","is_correct":true,"comment":"..."}]}]}.
Với mỗi MCQ, nhận xét cách làm; việc chọn đúng/sai đáp án do domain xử lý. Với essay, trả kết quả riêng cho mọi target_parts đã yêu cầu. Không dùng Markdown.`

func (c *Client) Evaluate(ctx context.Context, requests []assignment.EvaluationRequest, items []assignment.AssignmentItem, pageInk []byte, prompt, model string) ([]assignment.EvaluationResult, error) {
	if len(requests) == 0 {
		return nil, nil
	}

	byID := make(map[uuid.UUID]assignment.AssignmentItem, len(items))
	for _, item := range items {
		byID[item.ID()] = item
	}

	parts := []genai.Part{
		genai.Text(gradingPrompt + "\nYêu cầu thêm: " + strings.TrimSpace(prompt)),
	}

	if len(pageInk) > 0 {
		parts = append(parts, genai.Text("Nét bút toàn trang:"), detectImageBlob(pageInk))
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
	parts = append(parts, genai.Text("Danh sách câu cần chấm: "+string(encoded)))

	for _, in := range inputs {
		for index, image := range in.Images {
			parts = append(parts,
				genai.Text(fmt.Sprintf("Ảnh item %s số %d:", in.ItemID, index+1)),
				detectImageBlob(image),
			)
		}
	}

	raw, err := c.generateRequest(ctx, model, parts, 16384)
	if err != nil {
		return nil, err
	}

	var decoded struct {
		Results []struct {
			ItemID   uuid.UUID `json:"item_id"`
			Comment  string    `json:"comment"`
			Mistakes []struct {
				Topic  string `json:"topic"`
				Reason string `json:"reason"`
			} `json:"detected_mistakes"`
			SubItems []struct {
				Label     string `json:"label"`
				IsCorrect bool   `json:"is_correct"`
				Comment   string `json:"comment"`
			} `json:"sub_items"`
		} `json:"results"`
	}
	if err := json.Unmarshal([]byte(raw), &decoded); err != nil {
		return nil, fmt.Errorf("Gemini trả grading JSON không hợp lệ: %w", err)
	}

	results := make([]assignment.EvaluationResult, 0, len(decoded.Results))
	seen := make(map[uuid.UUID]bool)
	for _, result := range decoded.Results {
		item := byID[result.ItemID]
		if item == nil || seen[result.ItemID] {
			continue
		}
		seen[result.ItemID] = true
		mistakes := make([]assignment.DetectedMistake, 0, len(result.Mistakes))
		for _, m := range result.Mistakes {
			mistakes = append(mistakes, assignment.NewDetectedMistake(m.Topic, m.Reason, result.ItemID))
		}
		switch item.Exercise().(type) {
		case sharekernel.MultipleChoiceExercise:
			results = append(results, assignment.NewMCQEvalRes(result.ItemID, result.Comment, mistakes))
		case sharekernel.EssayExercise:
			var subResults []assignment.SubEssayRes
			for _, sub := range result.SubItems {
				subResults = append(subResults, assignment.NewSubEssayRes(sub.Label, sub.IsCorrect, sub.Comment))
			}
			results = append(results, assignment.NewEssayEvalRes(result.ItemID, subResults, mistakes))
		}
	}
	return results, nil
}

func detectImageBlob(data []byte) genai.Blob {
	contentType := http.DetectContentType(data)
	if !strings.HasPrefix(contentType, "image/") {
		contentType = "image/jpeg"
	}
	return genai.Blob{
		MIMEType: contentType,
		Data:     data,
	}
}

var (
	// Bắt trường hợp quên { }: [ "type": "text", "value": "..." ] -> [{ "type": "text", "value": "..." }]
	missingBracesTypeFirst = regexp.MustCompile(`(?s)\[\s*"type"\s*:\s*("[^"]*")\s*,\s*"value"\s*:\s*("(?:[^"\\]|\\.)*")\s*\]`)
	missingBracesValFirst  = regexp.MustCompile(`(?s)\[\s*"value"\s*:\s*("(?:[^"\\]|\\.)*")\s*,\s*"type"\s*:\s*("[^"]*")\s*\]`)
)

func repairGeminiJSON(raw string) string {
	// 1. Vá lỗi quên ngoặc nhọn trong mảng parts có 1 phần tử
	raw = missingBracesTypeFirst.ReplaceAllString(raw, `[{"type": $1, "value": $2}]`)
	raw = missingBracesValFirst.ReplaceAllString(raw, `[{"value": $1, "type": $2}]`)

	return raw
}
