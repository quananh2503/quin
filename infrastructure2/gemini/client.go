package gemini

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"regexp"
	"strconv"
	"strings"
	"uuid"

	"github.com/invopop/jsonschema"

	// "github.com/google/generative-ai-go/genai"
	// "github.com/google/generative-ai-go/genai"
	"github.com/google/generative-ai-go/genai"
	"google.golang.org/api/iterator"
	"google.golang.org/api/option"

	"meet-attendance-clean/domain2/assignment"
	exercise "meet-attendance-clean/domain2/excercise"
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

	// Khởi tạo SDK Client chính thức
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

// ListModels: Không cần gọi HTTP hay parse JSON thủ công nữa
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

		// Chỉ lấy các model gemini hỗ trợ generateContent
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

type FlexInt int

var numRegex = regexp.MustCompile(`\d+`)

func (fi *FlexInt) UnmarshalJSON(b []byte) error {
	var f float64
	if err := json.Unmarshal(b, &f); err == nil {
		*fi = FlexInt(int(f))
		return nil
	}
	var s string
	if err := json.Unmarshal(b, &s); err == nil {
		s = strings.TrimSpace(s)
		m := numRegex.FindString(s)
		if m != "" {
			v, _ := strconv.Atoi(m)
			*fi = FlexInt(v)
			return nil
		}
	}
	*fi = 1
	return nil
}

type generatedTeacherExample struct {
	ExampleNum                 FlexInt `json:"example_num" jsonschema:"description=Số thứ tự ví dụ nguyên dương,required"`
	Problem                    string  `json:"problem" jsonschema:"description=Đề bài ví dụ chứa LaTeX,required"`
	TeacherSolution            string  `json:"teacher_solution" jsonschema:"description=Lời giải chi tiết chứa LaTeX,required"`
	StudentFriendlyExplanation string  `json:"student_friendly_explanation" jsonschema:"description=Giải thích cho học sinh,required"`
	CommonMistake              string  `json:"common_mistake" jsonschema:"description=Sai lầm thường gặp"`
}

type generatedSection struct {
	SectionTitle      string                    `json:"section_title" jsonschema:"description=Tiêu đề mục (không ghi số thứ tự),required"`
	TransitionIntro   string                    `json:"transition_intro" jsonschema:"description=Lời dẫn nhập"`
	DetailedContent   string                    `json:"detailed_content" jsonschema:"description=Nội dung lý thuyết chứa công thức LaTeX,required"`
	KeyTakeaway       string                    `json:"key_takeaway" jsonschema:"description=Ghi nhớ trọng tâm"`
	StudentClozeNotes []string                  `json:"student_cloze_notes" jsonschema:"description=Câu điền khuyết dùng '......'"`
	TeacherExamples   []generatedTeacherExample `json:"teacher_examples" jsonschema:"description=Danh sách ví dụ minh họa"`
}

type generatedExercise struct {
	Type        string   `json:"type" jsonschema:"enum=Trắc nghiệm,enum=Tự luận,description=Loại bài tập,required"`
	Topic       string   `json:"topic" jsonschema:"description=Chủ đề kiến thức,required"`
	Difficulty  string   `json:"difficulty" jsonschema:"enum=Nhận biết,enum=Thông hiểu,enum=Vận dụng,enum=Vận dụng cao,required"`
	Question    string   `json:"question" jsonschema:"description=Đề bài chứa công thức LaTeX,required"`
	DiagramSVG  string   `json:"diagram_svg" jsonschema:"description=Hình ảnh sơ đồ SVG (nếu có)"`
	Options     []string `json:"options" jsonschema:"description=Bắt buộc 4 lựa chọn nếu trắc nghiệm: ['A. $...$', 'B. $...$', 'C. $...$', 'D. $...$']"`
	Answer      string   `json:"answer" jsonschema:"description=Đáp án đúng: chỉ ghi 1 chữ A/B/C/D nếu là trắc nghiệm,required"`
	Explanation string   `json:"explanation" jsonschema:"description=Lời giải chi tiết chứa LaTeX,required"`
}

type generatedLesson struct {
	Title     string              `json:"title" jsonschema:"description=Tiêu đề bài học,required"`
	Overview  string              `json:"overview" jsonschema:"description=Tổng quan bài học,required"`
	Sections  []generatedSection  `json:"sections" jsonschema:"description=Các phần lý thuyết,required"`
	Exercises []generatedExercise `json:"exercises" jsonschema:"description=Danh sách bài tập,required"`
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

const baseLessonPrompt = `Bạn là một chuyên gia sư phạm Toán học hàng đầu. Nhiệm vụ của bạn là phân tích tài liệu và biên soạn bài giảng cùng hệ thống bài tập chất lượng cao theo đúng cấu trúc JSON yêu cầu.

=========================================
1. NGUYÊN TẮC ƯU TIÊN CAO NHẤT (USER PROMPT PRIORITY):
=========================================
- Nếu ở cuối prompt có "Yêu cầu tùy chỉnh của giáo viên" (Custom Prompt), bạn BẮT BUỘC PHẢI ƯU TIÊN TUÂN THỦ yêu cầu của giáo viên trước tiên (về số lượng câu hỏi, dạng bài, mức độ khó, nội dung trọng tâm...).

=========================================
2. QUY TẮC CÔNG THỨC TOÁN HỌC (LATEX CHUẨN):
=========================================
- MỌI công thức toán học, biến số ($x, y$), phân số ($\frac{a}{b}$), số mũ ($x^{y+3}$), căn thức ($\sqrt{x}$), ký hiệu ($\in, \mathbb{R}, \Delta, \le, \ge, \pm, \vec{u}, \lim$) BẮT BUỘC đặt trong cặp dấu $...$ (nội dòng) hoặc $$...$$ (khối riêng).
- TUYỆT ĐỐI KHÔNG dùng ký hiệu Unicode chắp vá (không dùng x^2, x_1, 1/2, √x) hay text thường cho toán.
- Escape ký tự gạch chéo ngược chuẩn trong chuỗi JSON: \\frac, \\sqrt, \\in, \\le, \\ge, \\vec, \\lim...

=========================================
3. QUY TẮC VĂN BẢN (TRÁNH LỖI BIÊN DỊCH):
=========================================
- TUYỆT ĐỐI KHÔNG dùng các ký hiệu Markdown như ###, ## hoặc **in đậm** bên trong các chuỗi text của JSON. Chỉ viết văn bản thuần túy, hệ thống hiển thị sẽ tự lo việc định dạng tiêu đề.
- example_num BẮT BUỘC là số nguyên dương (1, 2, 3...).
- section_title ghi tên mục ngắn gọn, KHÔNG đánh số thứ tự (ví dụ: ghi "Khảo sát hàm số", không ghi "Phần 1: Khảo sát hàm số").

=========================================
4. QUY TẮC BẮT BUỘC KHI VẼ HÌNH HỌC & BẢNG BIẾN THIÊN (SVG):
=========================================
- Nếu câu hỏi có hình học không gian, đồ thị hàm số hoặc bảng biến thiên, BẮT BUỘC phải tạo mã SVG hoàn chỉnh vào trường "diagram_svg". Nếu không có, để chuỗi rỗng "".
- Khi vẽ BẢNG BIẾN THIÊN trong SVG:
  + Bắt buộc khai báo đầu mũi tên ở đầu SVG: <defs><marker id="arrow" viewBox="0 0 10 10" refX="6" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 1 L 10 5 L 0 9 z" fill="#0f172a" /></marker></defs>
  + Hàng y BẮT BUỘC PHẢI CÓ ĐƯỜNG KẺ MŨI TÊN: Dùng <line ... marker-end="url(#arrow)" stroke="#0f172a" stroke-width="1.5" /> nối từ cực đại/vô cùng sang cực tiểu/vô cùng theo đúng chiều biến thiên. Không để số nằm trơ trọi!
  + Điểm không xác định (tiệm cận đứng): Tại điểm mẫu số bằng 0, BẮT BUỘC vẽ dấu 2 gạch song song "||" bằng 2 đường thẳng <line> đứng cách nhau 4px kéo dài từ hàng y' qua hàng y.`

const youtubeLessonPrompt = `
=========================================
CHỈ DẪN CHUYÊN BIỆT CHO NGUỒN VIDEO YOUTUBE:
=========================================
1. PHẦN LÝ THUYẾT (SECTIONS):
   - Bám sát 100% nội dung bài giảng của thầy/cô trong video, không tự ý chém thêm kiến thức ngoài phạm vi video đề cập.
   - Trình bày mạch lạc đúng theo tiến trình sư phạm mà video đã dẫn dắt.

2. VÍ DỤ MINH HỌA (TEACHER EXAMPLES):
   - CLONE NGUYÊN MẪU Y HỆT các ví dụ mà giáo viên đã chữa trên video (từ số liệu, cách đặt đề bài đến phương pháp giải).

3. BÀI TẬP THỰC HÀNH (EXERCISES):
   - MẶC ĐỊNH TẠO ĐỦ 20 CÂU: Bao gồm đúng 10 câu trắc nghiệm và 10 câu tự luận (trừ khi giáo viên có yêu cầu tùy chỉnh số lượng khác trong Custom Prompt).
   - QUY TẮC ĐỘ ĐỔI MỚI: Không cần mỗi câu phải là một dạng bài hoàn toàn khác nhau. Nhiệm vụ chính là QUÉT HẾT TẤT CẢ CÁC DẠNG BÀI mà thầy/cô đã dạy trong video.
   - Với mỗi dạng bài trong video: Tạo ra nhiều bài tập tương tự theo dạng "THAY SỐ ĐỔI DỮ KIỆN" (giữ nguyên phương pháp, chỉ đổi số liệu hoặc thay đổi nhẹ biến số/đầu vào để học sinh rèn luyện kỹ năng tính toán).`

const pdfLessonPrompt = `
=========================================
CHỈ DẪN CHUYÊN BIỆT CHO NGUỒN TÀI LIỆU PDF:
=========================================
1. MỤC TIÊU CỐT LÕI: CLONE 1-1 Y HỆT NGUYÊN BẢN ĐỀ BÀI TRONG PDF:
   - Mục đích tối thượng khi học từ PDF là sao chép chính xác hệ thống câu hỏi, bài tập có trong các trang PDF được chỉ định.
   - Bám sát từng câu, từng phương án lựa chọn (A, B, C, D), từng ý tự luận đúng theo nguyên gốc trong tài liệu.

2. PHẦN LÝ THUYẾT (SECTIONS):
   - Tóm tắt cực kỳ ngắn gọn, cô đọng các công thức và định lý cần dùng ở đầu bài.
   - KHÔNG CẦN TẠO VÍ DỤ GIÁO VIÊN TRONG PHẦN NÀY (để mảng "teacher_examples" rỗng []), để tập trung toàn bộ dung lượng và chất xám vào phần bài tập.

3. HỆ THỐNG BÀI TẬP (EXERCISES):
   - Tái hiện lại toàn bộ các câu hỏi có trong các trang PDF đã chọn.
   - Giữ nguyên độ khó, văn phong đề bài và đáp án đúng theo barem của tài liệu gốc.`
const mistakeLessonPrompt = `
=========================================
CHỈ DẪN CHUYÊN BIỆT CHO BÀI HỌC SỬA LỖI SAI (REMEDIATION):
=========================================
1. MỤC TIÊU CỐT LÕI: ĐÁNH TRÚNG NGUYÊN NHÂN GỐC CỦA LỖI SAI:
   - Phân tích sâu vào lý do và cây nguyên nhân dẫn đến việc học sinh làm sai câu hỏi đó (quên điều kiện, nhầm công thức, biến đổi sai dấu...).

2. HỆ THỐNG BÀI TẬP PHẢN XẠ (EXERCISES):
   - Tạo các bài tập "TƯƠNG TỰ THAY SỐ": Giữ nguyên cấu trúc của bài toán mà học sinh đã làm sai, chỉ đổi số liệu hoặc biến đổi nhẹ một chi tiết nhỏ để kiểm tra xem học sinh đã thực sự hiểu bản chất hay chưa.
   - Chọn lọc các bài toán dễ hiểu, vừa sức, có tính phản chứng cao để học sinh nhận diện ngay bẫy sai lầm cũ.

3. LỜI GIẢI VÀ ĐÁP ÁN (TEACHER SOLUTION & EXPLANATION):
   - TUYỆT ĐỐI KHÔNG GIẢI DÀI DÒNG LÊ THÊ!
   - Lời giải phải xoáy thẳng và làm nổi bật ngay "KEY/ĐIỂM THEN CHỐT" của bài toán (ví dụ: chỉ rõ bước nào học sinh hay quên đặt điều kiện, bước nào dễ nhầm dấu) giúp học sinh "ngộ" ra ngay điểm sai.`

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
		b, _ := json.Marshal(source.Context())
		parts = append(parts, genai.Text(fmt.Sprintf("Khắc phục lỗi: %s | Lý do: %s | Cây nguyên nhân: %s", source.Topic(), source.Reason(), string(b))))
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

	var generated generatedLesson
	if err := json.Unmarshal([]byte(raw), &generated); err != nil {
		return nil, fmt.Errorf("Gemini trả JSON không hợp lệ: %w (Gốc: %s)", err, raw)
	}

	sections := make([]lesson.Section, 0, len(generated.Sections))
	for _, sec := range generated.Sections {
		examples := make([]lesson.TeacherExample, 0, len(sec.TeacherExamples))
		for _, eg := range sec.TeacherExamples {
			examples = append(examples, lesson.TeacherExample{
				ExampleNum:                 int(eg.ExampleNum),
				Problem:                    strings.TrimSpace(eg.Problem),
				TeacherSolution:            strings.TrimSpace(eg.TeacherSolution),
				StudentFriendlyExplanation: strings.TrimSpace(eg.StudentFriendlyExplanation),
				CommonMistake:              strings.TrimSpace(eg.CommonMistake),
			})
		}
		sections = append(sections, lesson.Section{
			SectionTitle:      strings.TrimSpace(sec.SectionTitle),
			TransitionIntro:   strings.TrimSpace(sec.TransitionIntro),
			DetailedContent:   strings.TrimSpace(sec.DetailedContent),
			KeyTakeaway:       strings.TrimSpace(sec.KeyTakeaway),
			StudentClozeNotes: sec.StudentClozeNotes,
			TeacherExamples:   examples,
		})
	}

	if len(generated.Exercises) == 0 {
		return nil, errors.New("Gemini không tạo bài tập nào")
	}

	exercises := make([]exercise.Exercise, 0, len(generated.Exercises))
	for i, ex := range generated.Exercises {
		topic := strings.TrimSpace(ex.Topic)
		if topic == "" {
			topic = "Toán tổng hợp"
		}
		diff := strings.TrimSpace(ex.Difficulty)
		if diff == "" {
			diff = "Thông hiểu"
		}
		q := strings.TrimSpace(ex.Question)
		var diag exercise.Diagram
		if strings.TrimSpace(ex.DiagramSVG) != "" {
			diag = exercise.NewDiagram(exercise.DiagramSVG, ex.DiagramSVG)
		} else {
			diag = exercise.NewDiagram(exercise.DiagramNone, "")
		}
		var built exercise.Exercise
		if len(ex.Options) > 0 || strings.Contains(strings.ToLower(ex.Type), "trắc") {
			opts := make([]exercise.MCOption, 0, len(ex.Options))
			for idx, text := range ex.Options {
				lbl := string(rune('A' + idx))
				ct := strings.TrimSpace(text)
				for _, prefix := range []string{lbl + ".", lbl + ")", lbl + ":"} {
					if strings.HasPrefix(strings.ToUpper(ct), prefix) {
						ct = strings.TrimSpace(ct[len(prefix):])
						break
					}
				}
				opts = append(opts, exercise.NewMCOption(lbl, ct))
			}
			ans := strings.TrimSpace(strings.ToUpper(ex.Answer))
			if len(ans) > 0 {
				ans = ans[:1]
			}
			built, err = exercise.NewMultipleChoiceExercise(topic, diff, q, opts, ans, strings.TrimSpace(ex.Explanation), diag)
		} else {
			part := exercise.NewEssayPart("a", q, strings.TrimSpace(ex.Answer), strings.TrimSpace(ex.Explanation))
			built, err = exercise.NewEssayExercise(topic, diff, q, []exercise.EssayPart{part}, diag)
		}
		if err != nil {
			return nil, fmt.Errorf("câu %d không hợp lệ: %w", i+1, err)
		}
		exercises = append(exercises, built)
	}

	t := strings.TrimSpace(generated.Title)
	if t == "" {
		t = strings.TrimSpace(title)
	}
	return lesson.NewLesson(t, strings.TrimSpace(generated.Overview), sections, exercises, material)
}

func (c *Client) generateRequest(ctx context.Context, modelName string, parts []genai.Part, maxTokens int) (string, error) {
	modelName = strings.TrimSpace(modelName)
	if modelName == "" {
		modelName = "gemini-3.5-flash"
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
// DOMAIN LOGIC: EVALUATE / GRADING
// ============================================================================

type gradeInput struct {
	ItemID         uuid.UUID             `json:"item_id"`
	Type           exercise.ExerciseType `json:"type"`
	Topic          string                `json:"topic"`
	Question       string                `json:"question"`
	Options        []string              `json:"options,omitempty"`
	CorrectAnswer  string                `json:"correct_answer,omitempty"`
	Solution       string                `json:"solution,omitempty"`
	SelectedOption string                `json:"selected_option,omitempty"`
	TargetParts    []string              `json:"target_parts,omitempty"`
	WorkingText    string                `json:"working_text"`
	Images         [][]byte              `json:"-"`
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

	// Đưa ảnh nét bút toàn trang vào (Không cần base64 thủ công!)
	if len(pageInk) > 0 {
		parts = append(parts, genai.Text("Nét bút toàn trang:"), detectImageBlob(pageInk))
	}

	inputs := make([]gradeInput, 0, len(requests))
	for _, request := range requests {
		item := byID[request.ItemID()]
		if item == nil {
			return nil, fmt.Errorf("không tìm thấy item %s trong assignment", request.ItemID())
		}
		in := gradeInput{ItemID: item.ID(), Type: item.Exercise().Type(), Topic: item.Exercise().Topic(), Question: item.Exercise().Prompt()}
		switch ex := item.Exercise().(type) {
		case exercise.MultipleChoiceExercise:
			req, ok := request.(assignment.MCQEvalReq)
			if !ok {
				return nil, fmt.Errorf("request MCQ %s sai type", item.ID())
			}
			for _, option := range ex.Options() {
				in.Options = append(in.Options, option.Label()+". "+option.Content())
			}
			in.CorrectAnswer, in.Solution, in.SelectedOption, in.WorkingText, in.Images = ex.Answer(), ex.Solution(), req.SelectedOption(), req.WorkingText(), req.WorkingData()

		case exercise.EssayExercise:
			req, ok := request.(assignment.EssayEvalReq)
			if !ok {
				return nil, fmt.Errorf("request essay %s sai type", item.ID())
			}
			in.TargetParts, in.WorkingText, in.Images = req.TargetParts(), req.Text(), req.Data()
			for _, part := range ex.Parts() {
				in.Options = append(in.Options, part.Label()+": "+part.Question()+" | Đáp án: "+part.Solution()+" | Tiêu chí: "+part.Rubric())
			}
		}
		inputs = append(inputs, in)
	}

	encoded, err := json.Marshal(inputs)
	if err != nil {
		return nil, err
	}
	parts = append(parts, genai.Text("Danh sách câu cần chấm: "+string(encoded)))

	// Đưa ảnh câu hỏi/lời giải của học sinh vào
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
		case exercise.MultipleChoiceExercise:
			results = append(results, assignment.NewMCQEvalRes(result.ItemID, result.Comment, mistakes))
		case exercise.EssayExercise:
			var subResults []assignment.SubEssayRes
			for _, sub := range result.SubItems {
				subResults = append(subResults, assignment.NewSubEssayRes(sub.Label, sub.IsCorrect, sub.Comment))
			}
			results = append(results, assignment.NewEssayEvalRes(result.ItemID, subResults, mistakes))
		}
	}
	return results, nil
}

// detectImageBlob tự động nhận diện định dạng ảnh và trả về genai.Blob chuẩn
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
