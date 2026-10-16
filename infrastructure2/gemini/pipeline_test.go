package gemini_test

import (
	"context"
	_ "embed"
	"os"
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"
)

// Đọc tự động file key.txt ngay trong thư mục
//
//go:embed key.txt
var rawGeminiKey string

// Khai báo đường dẫn 3 file PDF thực tế của bạn
const (
	// File 1: Sách giáo khoa & Bài giải chi tiết toàn chương (File chính)
	MainTextbookPDF = "HH12-KNTT- C2-GHEP FULL GIAI.pdf"

	// File 2: Bộ đề trắc nghiệm ôn tập bổ trợ
	ReviewExercisePDF = "ÔN VEC TƠ KG 10T10.pdf"

	// File 3: File cấu trúc mẫu chuẩn bạn muốn bắt chước
	SampleFormatPDF = "dsd.pdf"
)

// Cấu hình Model sử dụng (Nếu 2.5 chưa bật thì dùng 1.5)
const (
	PlannerModel = "gemma-4-31b-it" // hoặc "gemini-1.5-flash"
	WorkerModel  = "gemma-4-31b-it" // hoặc "gemini-1.5-flash-lite"
)

// Mock PDFProcessor đơn giản để test cắt trang
type mockPDFProcessor struct{}

func (m *mockPDFProcessor) ExtractPages(ctx context.Context, filePath string, pages []int) ([]byte, error) {
	// Khi chạy test, tạm thời đọc file để gửi cho Worker
	return os.ReadFile(filePath)
}

func (m *mockPDFProcessor) PageCount(ctx context.Context, filePath string) (int, error) {
	return 20, nil
}

func setupClient(t *testing.T) *gemini.Client {
	apiKey := strings.TrimSpace(rawGeminiKey)
	if apiKey == "" {
		apiKey = strings.TrimSpace(os.Getenv("GEMINI_API_KEY"))
	}
	if apiKey == "" {
		t.Fatalf("❌ Chưa có API Key! Hãy paste API Key vào file key.txt")
	}

	client, err := gemini.New(context.Background(), apiKey, &mockPDFProcessor{})
	if err != nil {
		t.Fatalf("Khởi tạo Gemini Client thất bại: %v", err)
	}
	return client
}

// -----------------------------------------------------------------------------
// TEST 1: CHỈ TEST MASTER PLANNER (Quét sách chính & lập dàn ý dạng toán)
// -----------------------------------------------------------------------------
func Test_Phase1_Planner(t *testing.T) {
	client := setupClient(t)
	ctx := context.Background()

	// Đọc file sách chính
	pdfBytes, err := os.ReadFile(MainTextbookPDF)
	if err != nil {
		t.Fatalf("Không tìm thấy file %s: %v", MainTextbookPDF, err)
	}

	prompt := "Phân tích chương này thành các dạng toán từ nhận biết đến vận dụng cao. Chỉ rõ số trang của từng dạng."
	plan, err := client.ExecutePhase1_Planner(ctx, PlannerModel, pdfBytes, prompt)
	if err != nil {
		t.Fatalf("Phase 1 thất bại: %v", err)
	}

	if len(plan.Topics) == 0 {
		t.Errorf("Planner không sinh ra dạng toán nào")
	}

	t.Logf("🎉 Phase 1 Thành công! Sinh được %d dạng toán:", len(plan.Topics))
	for i, top := range plan.Topics {
		t.Logf("  [%d] %s (Trang %d -> %d)", i+1, top.Title, top.StartPage, top.EndPage)
	}
}

// -----------------------------------------------------------------------------
// TEST 2: TEST CÁC WORKER (Đọc file plan đã lưu từ Phase 1 để tiết kiệm token)
// -----------------------------------------------------------------------------
func Test_Phase2_Workers(t *testing.T) {
	client := setupClient(t)
	ctx := context.Background()

	var plan gemini.LessonPlan
	if err := gemini.LoadArtifact("phase1_plan.json", &plan); err != nil {
		t.Fatalf("Chưa có artifact phase1_plan.json. Hãy chạy Test_Phase1_Planner trước! Lỗi: %v", err)
	}

	results, err := client.ExecutePhase2_Workers(ctx, WorkerModel, MainTextbookPDF, &plan)
	if err != nil {
		t.Fatalf("Phase 2 thất bại: %v", err)
	}

	t.Logf("🎉 Phase 2 Thành công! Toàn bộ %d Workers đã sinh xong bài tập chi tiết.", len(results))
}

// -----------------------------------------------------------------------------
// TEST 3: TEST GHÉP TYPST & XUẤT 2 FILE PDF (0 TỐN TOKEN, CHẠY TRONG 0.3 GIÂY)
// -----------------------------------------------------------------------------
func Test_Phase3_And_4_TypstOnly(t *testing.T) {
	client := setupClient(t)
	ctx := context.Background()

	var plan gemini.LessonPlan
	var workers []gemini.WorkerResult

	if err := gemini.LoadArtifact("phase1_plan.json", &plan); err != nil {
		t.Fatalf("Thiếu phase1_plan.json: %v", err)
	}
	if err := gemini.LoadArtifact("phase2_all_results.json", &workers); err != nil {
		t.Fatalf("Thiếu phase2_all_results.json: %v", err)
	}

	// Gọi thẳng hàm Phase 4 có cơ chế tự động sửa lỗi (Self-Healing)
	gv, hs, err := client.ExecutePhase4_CompilePDF(ctx, WorkerModel, &plan, workers)
	if err != nil {
		t.Fatalf("Phase 4 thất bại: %v", err)
	}

	t.Logf("🎉 BIÊN DỊCH XUẤT SẮC!\n- Bản Giáo viên: %s\n- Bản Học sinh: %s", gv, hs)
}
