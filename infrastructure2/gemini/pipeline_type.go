package gemini

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"time"

	"google.golang.org/genai"
)

// ==========================================
// 1. DATA CONTRACTS (PHASE 1 & 2)
// ==========================================

// Phase 1 Output
type Topic struct {
	TopicID     string `json:"topic_id" jsonschema:"description=ID dạng: dang_1, dang_2..."`
	Title       string `json:"title" jsonschema:"description=Tên dạng toán vi kỹ năng (VD: 'Dạng 1: Nhận diện vectơ bằng nhau trên hình hộp', 'Dạng 2: Rút gọn biểu thức bằng quy tắc nối đuôi 3 điểm')"`
	StartPage   int    `json:"start_page" jsonschema:"description=Trang bắt đầu trong PDF"`
	EndPage     int    `json:"end_page" jsonschema:"description=Trang kết thúc trong PDF"`
	CoreConcept string `json:"core_concept" jsonschema:"description=Một thao tác cốt lõi duy nhất mà học sinh luyện tập trong dạng này"`
}

type LessonPlan struct {
	LessonTitle           string  `json:"lesson_title" jsonschema:"description=Tiêu đề chương"`
	Overview              string  `json:"overview" jsonschema:"description=Tổng quan chương ngắn gọn"`
	PedagogicalScratchpad string  `json:"pedagogical_scratchpad" jsonschema:"description=PHÂN TÍCH GIẢM TẢI NHẬN THỨC: Phân rã từng bài học lớn thành các vi kỹ năng đơn lẻ, kiểm tra xem dạng nào còn quá 2 bước tư duy để chẻ nhỏ tiếp"`
	Topics                []Topic `json:"topics" jsonschema:"description=Danh sách các dạng toán vi kỹ năng độc lập, được chẻ nhỏ tối đa để học sinh yếu luyện phản xạ từng bước"`
}

// -----------------------------------------------------------------------------
// STRUCTS CHO PHASE 2 OUTPUT
// -----------------------------------------------------------------------------

type ExampleItem struct {
	Title    string `json:"title" jsonschema:"description=Tiêu đề ví dụ (VD: 'Ví dụ mẫu 1')"`
	Problem  string `json:"problem" jsonschema:"description=Đề bài ví dụ, mọi công thức và điểm bọc trong $ (VD: Cho hình chóp $S.ABCD$)"`
	Solution string `json:"solution" jsonschema:"description=Lời giải chi tiết 'cầm tay chỉ việc' từng bước, công thức bọc trong $"`
}

// type DrillPart struct {
// 	Label    string `json:"label" jsonschema:"description=Nhãn ý con: a, b, c, d"`
// 	Question string `json:"question" jsonschema:"description=Đề bài ý con, công thức bọc trong $"`
// 	Solution string `json:"solution" jsonschema:"description=Lời giải chi tiết từng bước, công thức bọc trong $"`
// 	Rubric   string `json:"rubric" jsonschema:"description=Barem chấm điểm ngắn gọn (VD: 'Áp dụng đúng công thức: 0.5đ')"`
// }

// type DrillExercise struct {
// 	Prompt string      `json:"prompt" jsonschema:"description=Lời dẫn bài toán thực hành chung (VD: 'Cho hình hộp $ABCD.A'B'C'D'$. Thực hiện các yêu cầu sau:')"`
// 	Parts  []DrillPart `json:"parts" jsonschema:"description=Bắt buộc 4 ý con (a, b, c, d) theo mức độ lũy tiến từ điền số/nhận diện đến tự tính toán"`
// }

type MCQExercise struct {
	Prompt        string   `json:"prompt" jsonschema:"description=Đề bài trắc nghiệm ngắn gọn kiểm tra phản xạ, công thức bọc trong $"`
	Options       []string `json:"options" jsonschema:"description=4 lựa chọn (VD: ['A. $\\vec{a}$', 'B. $\\vec{b}$', 'C. $\\vec{0}$', 'D. $2\\vec{a}$'])"`
	Scratchpad    string   `json:"scratchpad" jsonschema:"description=BƯỚC GIẢI NHÁP CHI TIẾT TỪNG BƯỚC: Tính toán cụ thể để xác định đáp án đúng trước khi chốt nhãn"`
	CorrectAnswer string   `json:"correct_answer" jsonschema:"enum=A,enum=B,enum=C,enum=D,description=Nhãn đáp án đúng sau khi đã giải nháp ở scratchpad"`
	Solution      string   `json:"solution" jsonschema:"description=Lời giải giải thích ngắn gọn vì sao chọn phương án đó"`
}
type DrillPart struct {
	Label    string `json:"label" jsonschema:"description=Nhãn ý con: a, b, c, d, e"`
	Question string `json:"question" jsonschema:"description=Đề bài ý con (cùng khuôn mẫu thao tác với các ý khác, dạng điền khuyết hoặc tính tương tự), toán kẹp trong $"`
	Solution string `json:"solution" jsonschema:"description=Lời giải chi tiết hoặc đáp án điền khuyết, toán kẹp trong $"`
	Rubric   string `json:"rubric" jsonschema:"description=Barem chấm điểm ngắn gọn"`
}

type DrillExercise struct {
	Prompt string      `json:"prompt" jsonschema:"description=Lời dẫn bài tập thực hành lặp lại (VD: 'Áp dụng quy tắc nối đuôi để điền vào chỗ trống:' hoặc 'Tính tọa độ các vectơ sau:')"`
	Parts  []DrillPart `json:"parts" jsonschema:"description=Bắt buộc 4-5 ý con LẶP LẠI CÙNG 1 KHUÔN MẪU THAO TÁC (chỉ đổi tên điểm hoặc số liệu) để học sinh rèn phản xạ cơ bắp quen tay"`
}

type WorkerResult struct {
	TopicID               string `json:"topic_id"`
	Title                 string `json:"title"`
	PedagogicalScratchpad string `json:"pedagogical_scratchpad" jsonschema:"description=BÀN NHÁP SƯ PHẠM & TOÁN: 1. Chọn khuôn mẫu bài tập lặp lại (Pattern) để học sinh làm quen tay. 2. Nháp số đẹp/chữ cái. 3. Soạn 2 câu trắc nghiệm khởi động cực dễ."`

	TheoryPoints []string `json:"theory_points" jsonschema:"description=2-3 ý lý thuyết cốt lõi dễ nhớ nhất, toán kẹp trong $"`
	CalloutTip   string   `json:"callout_tip" jsonschema:"description=Mẹo nhớ siêu tốc hoặc câu khẩu quyết dân dã, toán kẹp trong $"`
	ClozeFormula string   `json:"cloze_formula" jsonschema:"description=1 câu công thức cốt lõi có chỗ trống '...' để điền, toán kẹp trong $"`

	// 👉 ĐẨY TRẮC NGHIỆM LÊN TRƯỚC LÀM PHẦN KHỞI ĐỘNG
	MCQs []MCQExercise `json:"mcqs" jsonschema:"description=2 câu trắc nghiệm KHỞI ĐỘNG NHẬN BIẾT cực kỳ cơ bản (hỏi thẳng định nghĩa/công thức vừa học để học sinh tự tin)"`

	// 👉 VÍ DỤ VÀ DRILL Ở SAU
	Examples []ExampleItem   `json:"examples" jsonschema:"description=1 ví dụ mẫu điển hình giải mẫu từng bước"`
	Drills   []DrillExercise `json:"drills" jsonschema:"description=Bài tập thực hành lặp lại (4-5 ý con cùng một kiểu thao tác làm đi làm lại)"`
}

// ==========================================
// 2. DATA CONTRACTS CHO TẦNG BATCH REPAIR (PHASE 4)
// ==========================================

type RepairItemRequest struct {
	AnchorID      string `json:"anchor_id" jsonschema:"description=Tọa độ điểm neo của câu bị lỗi,required"`
	ContextPrompt string `json:"context_prompt" jsonschema:"description=Đề bài làm bối cảnh,required"`
	BrokenContent string `json:"broken_content" jsonschema:"description=Nội dung đang bị lỗi cú pháp toán hoặc thiếu $,required"`
}

type RepairBatchRequest struct {
	Items []RepairItemRequest `json:"items" jsonschema:"description=Danh sách các mục cần sửa cú pháp toán theo lô,required"`
}

type RepairedItemResponse struct {
	AnchorID     string `json:"anchor_id" jsonschema:"description=Tọa độ điểm neo tương ứng,required"`
	FixedContent string `json:"fixed_content" jsonschema:"description=Nội dung đã được sửa lại cú pháp LaTeX chuẩn và bọc đầy đủ trong cặp dấu $,required"`
}

type RepairBatchResponse struct {
	RepairedItems []RepairedItemResponse `json:"repaired_items" jsonschema:"description=Danh sách kết quả đã sửa xong,required"`
}

// ==========================================
// 3. LOGGING & ARTIFACT PERSISTENCE
// ==========================================

const ArtifactDir = ".artifacts"

func init() {
	_ = os.MkdirAll(ArtifactDir, 0755)
}

func LogPhase(phase string, msg string, a ...any) {
	formatted := fmt.Sprintf(msg, a...)
	timestamp := time.Now().Format("15:04:05")
	fmt.Printf("[%s] \033[1;36m%-10s\033[0m %s\n", timestamp, phase, formatted)
}

func LogTokenUsage(phase string, usage *genai.GenerateContentResponseUsageMetadata) {
	if usage == nil {
		return
	}
	fmt.Printf("           \033[33m↳ Tokens: In=%d, Out=%d, Total=%d\033[0m\n",
		usage.PromptTokenCount, usage.CandidatesTokenCount, usage.TotalTokenCount)
}

func SaveArtifact(filename string, data any) error {
	path := filepath.Join(ArtifactDir, filename)
	var bytes []byte
	var err error
	if str, ok := data.(string); ok {
		bytes = []byte(str)
	} else {
		bytes, err = json.MarshalIndent(data, "", "  ")
		if err != nil {
			return err
		}
	}
	return os.WriteFile(path, bytes, 0644)
}

func LoadArtifact(filename string, target any) error {
	path := filepath.Join(ArtifactDir, filename)
	bytes, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	return json.Unmarshal(bytes, target)
}
