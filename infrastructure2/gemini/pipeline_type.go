package gemini

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"time"

	"google.golang.org/genai"
)

const (
	ModelGemma4_31B     = "gemma-4-31b-it"
	ModelGemma4_26B_A4B = "gemma-4-26b-a4b-it"
)

// PDFDocumentInput hỗ trợ đầu vào nhiều file PDF
type PDFDocumentInput struct {
	DocID    string `json:"doc_id"`    // VD: "DOC_1", "DOC_2"
	FileName string `json:"file_name"` // VD: "HH12-KNTT- C2-GHEP FULL GIAI.pdf"
	RoleHint string `json:"role_hint"` // Tuỳ chọn: "Tài liệu chính / SGK"
	Data     []byte `json:"-"`
}

// CatalogItem: Định danh cụm câu hỏi theo dạng thức hoặc kỹ năng giải (từ 3 đến 8 câu/cụm)
type CatalogItem struct {
	DocID        string   `json:"doc_id" jsonschema:"description=Mã tài liệu (DOC_1; DOC_2...),required"`
	QuestionIDs  []string `json:"question_ids" jsonschema:"description=Danh sách mã câu hỏi trong cụm (3 đến 8 mã/cụm, VD: ['VD1', 'VD2', 'VD3'], ['C1', 'C2', 'C3', 'C4', 'C5'], ['D1', 'D2', 'D3'], ['E5', 'E6', 'E7', 'E8']). Dùng mã gốc D1, D2..., cấm chẻ nhỏ D1a, D1b!,required"`
	QuestionType string   `json:"question_type" jsonschema:"enum=ViDu,enum=TracNghiem_ABCD,enum=DungSai_ABCD,enum=TraLoiNgan,enum=TuLuan,description=Loại câu hỏi trong tài liệu,required"`
	TargetOutput string   `json:"target_output" jsonschema:"description=Đích đến/kết quả cụ thể cần tìm của nhóm câu hỏi này (VD: 'Tìm khoảng đồng biến/nghịch biến' KHÁC VỚI 'Tìm cực trị'; 'Tính góc giữa 2 đối tượng' KHÁC VỚI 'Tính khoảng cách/thể tích'; 'Tìm hệ số biểu thức' KHÁC VỚI 'Chứng minh đẳng thức'; 'Tìm giá trị lớn nhất/nhỏ nhất' KHÁC VỚI 'Tìm tập nghiệm'),required"`
	CoreMethod   string   `json:"core_method" jsonschema:"description=Công cụ/Công thức/Định lý toán học đặc trưng dùng để giải (VD: 'Bảng biến thiên/Xét dấu đạo hàm', 'Tích phân từng phần', 'Định lý sin/cosin', 'Hệ thức định lý riêng theo cấu hình', 'Phân tích qua hệ cơ sở', 'Biến đổi tương đương'),required"`
}

// SourceRef: Tham chiếu tài liệu nguồn - dạng chuỗi để phẳng hóa Schema (chống lỗi 500 do mảng lồng nhau)
type SourceRef string

func (s *SourceRef) UnmarshalJSON(data []byte) error {
	var str string
	if err := json.Unmarshal(data, &str); err == nil {
		*s = SourceRef(str)
		return nil
	}
	var obj struct {
		DocID       string `json:"doc_id"`
		PageRange   string `json:"page_range"`
		FocusDetail string `json:"focus_detail"`
	}
	if err := json.Unmarshal(data, &obj); err == nil {
		*s = SourceRef(fmt.Sprintf("%s (Trang %s): %s", obj.DocID, obj.PageRange, obj.FocusDetail))
		return nil
	}
	*s = SourceRef(string(data))
	return nil
}

// Cập nhật struct Topic: Có TargetOutput, AssignedQuestionIDs, difficulty, variants và SourceRefs đầy đủ
type Topic struct {
	TopicID             string      `json:"topic_id" jsonschema:"description=ID dạng: dang_1; dang_2...,required"`
	Title               string      `json:"title" jsonschema:"description=Tên dạng toán cụ thể, chuyên sâu, phản ánh rõ TargetOutput và CoreMethod,required"`
	Difficulty          string      `json:"difficulty" jsonschema:"enum=NhanBiet_ThongHieu,enum=VanDung,enum=VanDungCao,description=Mức độ của dạng toán,required"`
	TargetOutput        string      `json:"target_output" jsonschema:"description=Đích đến duy nhất của dạng toán này (Mỗi dạng chỉ giải quyết 1 đích đến cụ thể, cấm gộp chung),required"`
	CoreConcept         string      `json:"core_concept" jsonschema:"description=Phương pháp giải cốt lõi và công thức đặc trưng,required"`
	AssignedQuestionIDs []string    `json:"assigned_question_ids" jsonschema:"description=Liệt kê TẤT CẢ các mã câu hỏi (VD1, C1, D1, E1...) từ question_catalog thuộc về dạng này (Tối đa 8-10 câu/dạng. Nếu nhiều hơn phải tách thành dạng riêng!),required"`
	Variants            []string    `json:"variants" jsonschema:"description=Danh sách các biến thể nhỏ (bao gồm cả biến thể Đúng/Sai 4 mệnh đề hoặc Trả lời ngắn nếu có),required"`
	SourceRefs          []SourceRef `json:"source_refs" jsonschema:"description=Danh sách tham chiếu tài liệu nguồn (VD: ['DOC_1 trang 2-4: Lý thuyết và VD3', 'DOC_2 trang 1: C5, C9, C14']),required"`
}

type LessonPlan struct {
	LessonTitle     string        `json:"lesson_title" jsonschema:"required"`
	Overview        string        `json:"overview" jsonschema:"required"`
	QuestionCatalog []CatalogItem `json:"question_catalog" jsonschema:"description=BƯỚC 1 (BOTTOM-UP CLUSTER INDEXING): Quét từng phần của file PDF, lập danh mục theo cụm 3-8 câu cùng dạng thức (khoảng 12-16 cụm để tối ưu token), dùng mã câu chuẩn (VD1..VD11, C1..C56, D1..D10, E1..E24), cấm viết tắt dải kiểu C1..C56 nhưng được gom nhiều mã trong mảng question_ids, cấm chẻ nhỏ D1a, D1b!,required"`
	Topics          []Topic       `json:"topics" jsonschema:"description=BƯỚC 2 (FINE-GRAINED CLUSTERING): Gom các mục trong question_catalog có CÙNG TargetOutput và CoreMethod thành từng Dạng toán riêng biệt (thường từ 14 đến 20 dạng). CẤM gộp 2 TargetOutput khác nhau vào 1 Dạng!,required"`
}

type DeltaTopicResponse struct {
	AdditionalTopics []Topic `json:"additional_topics" jsonschema:"description=Danh sách các dạng toán mới được tách ra hoặc bổ sung cho các câu hỏi bị sót,required"`
}

type ExampleItem struct {
	Title    string `json:"title" jsonschema:"description=Tiêu đề ví dụ mẫu (VD: 'Ví dụ 1 - Áp dụng công thức cơ bản')"`
	Problem  string `json:"problem" jsonschema:"description=Đề bài ví dụ đầy đủ ngữ cảnh và giả thiết - toán bọc trong $"`
	Solution string `json:"solution" jsonschema:"description=Lời giải chi tiết từng bước - toán bọc trong $"`
}

type MCQExercise struct {
	Prompt        string   `json:"prompt" jsonschema:"description=Đề bài trắc nghiệm kiểm tra phản xạ và bản chất kiến thức học sinh cần nắm - công thức bọc trong $"`
	Options       []string `json:"options" jsonschema:"description=4 lựa chọn (VD: ['A. $1$'; 'B. $2$'; 'C. $0$'; 'D. $-1$'] hoặc công thức toán)"`
	Solution      string   `json:"solution" jsonschema:"description=Lời giải giải thích rõ ràng vì sao chọn phương án đó và loại trừ phương án sai - viết chứng minh trước khi chốt đáp án"`
	CorrectAnswer string   `json:"correct_answer" jsonschema:"enum=A,enum=B,enum=C,enum=D,description=Nhãn đáp án đúng sau khi đã giải ở solution"`
}

type ShortAnswerExercise struct {
	Prompt      string `json:"prompt" jsonschema:"description=Đề bài yêu cầu tính một giá trị số cụ thể (giá trị biểu thức; đạo hàm; tích phân; độ dài; góc; tỉ số; tham số m; giá trị lớn nhất/nhỏ nhất...)"`
	Solution    string `json:"solution" jsonschema:"description=Lời giải tự luận chi tiết tính toán từng bước trước khi chốt con số kết quả"`
	FinalNumber string `json:"final_number" jsonschema:"description=Con số kết quả cuối cùng rút ra từ lời giải để điền vào ô trả lời (VD: '4.41'; '60'; '1.5')"`
}

type DrillExercise struct {
	Title    string `json:"title" jsonschema:"description=Tiêu đề bài tập: 'Bài 1 (Chuẩn mẫu)', 'Bài 2 (Tương tự 100%)', 'Bài 3 (Tương tự củng cố)', 'Bài 4 (Biến thể nhẹ)', 'Bài 5 (Biến thể củng cố)', 'Bài 6 (Luyện phản xạ)',required"`
	Level    string `json:"level" jsonschema:"enum=MauChuan,enum=TuongTu100,enum=BienTheNhe,enum=CungCo,description=Bậc rèn luyện: MauChuan, TuongTu100, BienTheNhe, CungCo,required"`
	Prompt   string `json:"prompt" jsonschema:"description=Đề bài tự luận bám sát lý thuyết và ví dụ mẫu, cùng thuật toán biến đổi, không nâng cao xa rời lý thuyết - toán kẹp trong $,required"`
	Solution string `json:"solution" jsonschema:"description=Lời giải chi tiết từng bước chuẩn mực sư phạm - toán kẹp trong $,required"`
}

type WorkerResult struct {
	TopicID               string `json:"topic_id"`
	Title                 string `json:"title"`
	PedagogicalScratchpad string `json:"pedagogical_scratchpad" jsonschema:"description=BÀN NHÁP SƯ PHẠM VÀ TOÁN: BẮT BUỘC nháp số liệu và kiểm tra nghiệm các bài toán tự luận và trả lời ngắn để đảm bảo bài toán có nghiệm và giải được trước khi ra đề bài"`

	TheoryPoints          []string              `json:"theory_points" jsonschema:"description=2-3 ý lý thuyết cốt lõi - toán kẹp trong $"`
	CalloutTip            string                `json:"callout_tip" jsonschema:"description=Mẹo nhớ siêu tốc hoặc khẩu quyết - toán kẹp trong $"`
	ClozeFormula          string                `json:"cloze_formula" jsonschema:"description=1 câu công thức có chỗ trống '...' để điền - toán kẹp trong $"`
	ShortAnswers          []ShortAnswerExercise `json:"short_answers" jsonschema:"description=2 đến 3 câu hỏi trả lời ngắn tính ra số cụ thể"`
	Examples              []ExampleItem         `json:"examples" jsonschema:"description=Từ 3 đến 5 ví dụ mẫu điển hình giải chi tiết, BẮT BUỘC bao quát đầy đủ mọi công thức và ý lý thuyết cốt lõi của dạng toán,required"`
	Drills                []DrillExercise       `json:"drills" jsonschema:"description=Từ 4 đến 6 bài tập tự luyện tương tự và biến thể nhẹ bám sát lý thuyết, luyện bước làm và phản xạ lặp đi lặp lại,required"`
}

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

type RefinedTopicsResponse struct {
	Topics []Topic `json:"topics" jsonschema:"description=Danh sách toàn bộ các dạng toán sau khi đã khử trùng lặp và sắp xếp theo tiến trình sư phạm từ Dễ đến Khó,required"`
}

// ==========================================
// 4. LOGGING & ARTIFACT PERSISTENCE
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
