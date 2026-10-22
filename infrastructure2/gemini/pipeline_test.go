package gemini_test

import (
	"context"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"

	"google.golang.org/genai"
)

// Cấu hình Model Gemma 4 trên Gemini API
const (
	PlannerModel = gemini.ModelGemma4_31B // gemma-4-31b-it: Dense 30.7B, IF 92.9%, Context 256K
	WorkerModel  = gemini.ModelGemma4_31B // gemma-4-31b-it: Dense 30.7B (đồng bộ toàn bộ pipeline)
	RepairModel  = gemini.ModelGemma4_31B // gemma-4-31b-it: Dense 30.7B
)

type mockPDFProcessor struct{}

func (m *mockPDFProcessor) ExtractPages(ctx context.Context, filePath string, pages []int) ([]byte, error) {
	return os.ReadFile(filePath)
}

func (m *mockPDFProcessor) PageCount(ctx context.Context, filePath string) (int, error) {
	return 20, nil
}

// Tự động quét và nạp toàn bộ 5 API Keys từ các file key1.txt -> key5.txt hoặc key.txt
func loadAPIKeys() []string {
	var keys []string
	keyFiles := []string{"key1.txt", "key2.txt", "key3.txt", "key4.txt", "key5.txt", "key.txt"}
	seen := make(map[string]bool)

	for _, kf := range keyFiles {
		data, err := os.ReadFile(kf)
		if err == nil {
			k := strings.TrimSpace(string(data))
			if k != "" && !seen[k] {
				seen[k] = true
				keys = append(keys, k)
			}
		}
	}

	if envKey := strings.TrimSpace(os.Getenv("GEMINI_API_KEY")); envKey != "" && !seen[envKey] {
		seen[envKey] = true
		keys = append(keys, envKey)
	}

	return keys
}

func setupClient(t *testing.T) *gemini.Client {
	keys := loadAPIKeys()
	if len(keys) == 0 {
		t.Fatalf("❌ Chưa có API Key! Hãy lưu API Key vào key1.txt -> key5.txt hoặc key.txt")
	}

	client, err := gemini.NewWithPool(context.Background(), keys, &mockPDFProcessor{})
	if err != nil {
		t.Fatalf("Khởi tạo Gemini Client với KeyPool thất bại: %v", err)
	}
	t.Logf("🔑 Khởi tạo thành công KeyPool với %d API Keys", client.KeyPool().Size())
	return client
}

// Nạp 3 file PDF thực tế
func loadTestPDFDocs(t *testing.T) []gemini.PDFDocumentInput {
	docSpecs := []struct {
		docID    string
		fileName string
		roleHint string
	}{
		{"DOC_1", "./pdfs/A. LY THUYET.pdf", "Tài liệu chính / SGK và bài giải chi tiết Chương II"},
		{"DOC_2", "./pdfs/ÔN VEC TƠ KG 10T10.pdf", "Ngân hàng câu hỏi trắc nghiệm và bài tập ôn tập bổ trợ"},
	}

	var docs []gemini.PDFDocumentInput
	for _, spec := range docSpecs {
		data, err := os.ReadFile(spec.fileName)
		if err != nil {
			t.Fatalf("Không thể đọc file PDF %s: %v", spec.fileName, err)
		}
		docs = append(docs, gemini.PDFDocumentInput{
			DocID:    spec.docID,
			FileName: spec.fileName,
			RoleHint: spec.roleHint,
			Data:     data,
		})
	}
	return docs
}

// =============================================================================
// UNIT TESTS: KIỂM TRA LOGIC OFFLINE (KHÔNG TỐN TOKEN)
// =============================================================================

func Test_SanitizeRawJSONLaTeX(t *testing.T) {
	// Kiểm tra tự động vá các lệnh LaTeX bị Go unmarshal nuốt thành ASCII escape
	input := `{"formula": "\frac{1}{2}", "vec": "\vec{AB}", "overline": "\overline{IJ}", "overrightarrow": "\overrightarrow{MN}", "text": "\text{thỏa mãn}", "beta": "\beta", "times": "\times", "integral": "\int f(x) \d{x}", "complex": "\overline{z} = a - bi", "mean": "\overline{x} = 5.2"}`
	sanitized := gemini.SanitizeRawJSONLaTeX(input)

	if !strings.Contains(sanitized, `\\frac`) {
		t.Errorf("SanitizeRawJSONLaTeX không escape \\frac: %s", sanitized)
	}
	if !strings.Contains(sanitized, `\\vec{IJ}`) {
		t.Errorf("SanitizeRawJSONLaTeX không chuẩn hóa \\overline{IJ} thành \\vec{IJ}: %s", sanitized)
	}
	if !strings.Contains(sanitized, `\\vec{MN}`) {
		t.Errorf("SanitizeRawJSONLaTeX không chuẩn hóa \\overrightarrow{MN} thành \\vec{MN}: %s", sanitized)
	}
	if !strings.Contains(sanitized, `\\text`) {
		t.Errorf("SanitizeRawJSONLaTeX không escape \\text: %s", sanitized)
	}
	// Kiểm tra tính phổ quát: Không biến số phức liên hợp (\overline{z}) hoặc số trung bình (\overline{x}) thành \vec!
	if strings.Contains(sanitized, `\vec{z}`) {
		t.Errorf("SanitizeRawJSONLaTeX làm sai bản chất số phức: biến \\overline{z} thành \\vec{z}: %s", sanitized)
	}
	if strings.Contains(sanitized, `\vec{x}`) {
		t.Errorf("SanitizeRawJSONLaTeX làm sai bản chất giải tích/thống kê: biến \\d{x} hoặc \\overline{x} thành \\vec{x}: %s", sanitized)
	}

	// Kiểm tra cắt markdown fence ```json ... ```
	fenced := "```json\n{\"key\": \"value\"}\n```"
	cleanFenced := gemini.SanitizeRawJSONLaTeX(fenced)
	if strings.Contains(cleanFenced, "```") {
		t.Errorf("SanitizeRawJSONLaTeX không cắt markdown fence: %s", cleanFenced)
	}
}

func Test_LaTeXToMiTeX(t *testing.T) {
	input := `Cho hình hộp $ABCD.A'B'C'D'$. Ta có $\vec{AB} + \vec{AD} = \vec{AC}$. Công thức: $$\vec{a} \cdot \vec{b} = |\vec{a}| |\vec{b}| \cos(\vec{a}, \vec{b})$$`
	output := gemini.LaTeXToMiTeX(input)

	if !strings.Contains(output, "#mi(`\\vec{AB} + \\vec{AD} = \\vec{AC}`)") {
		t.Errorf("LaTeXToMiTeX chuyển inline math sai: %s", output)
	}
	if !strings.Contains(output, "#align(center)[#mitex(`\\vec{a} \\cdot \\vec{b}") {
		t.Errorf("LaTeXToMiTeX chuyển block math sai: %s", output)
	}
}

func Test_FormatFinalNumber(t *testing.T) {
	testCases := []struct {
		name     string
		input    string
		contains string
		notHas   string
	}{
		{
			name:     "Số nguyên",
			input:    "0",
			contains: "0",
		},
		{
			name:     "Số thập phân",
			input:    "1.73",
			contains: "1.73",
		},
		{
			name:     "Ký hiệu đỉnh có dấu phẩy",
			input:    "A'B'",
			contains: "A'B'",
		},
		{
			name:     "Công thức vectơ đã bọc $ (trường hợp dang_4 gây lỗi cũ)",
			input:    `$\vec{AB} + \vec{CA} + \vec{AD}$`,
			contains: `#mi(`,
		},
		{
			name:     "LaTeX trần không có $ (a\\sqrt{3})",
			input:    `a\sqrt{3}`,
			contains: `#mi(`,
		},
		{
			name:     "Biểu thức mũ (a^2)",
			input:    `a^2`,
			contains: `#mi(`,
		},
		{
			name:     "Biểu thức phân số căn thức trần (a\\sqrt{2}/2)",
			input:    `a\sqrt{2}/2`,
			contains: `#mi(`,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			out := gemini.FormatFinalNumber(tc.input)
			if tc.contains != "" && !strings.Contains(out, tc.contains) {
				t.Errorf("FormatFinalNumber(%q) = %q, kỳ vọng chứa %q", tc.input, out, tc.contains)
			}
			if tc.notHas != "" && strings.Contains(out, tc.notHas) {
				t.Errorf("FormatFinalNumber(%q) = %q, không được chứa %q", tc.input, out, tc.notHas)
			}
		})
	}
}

func Test_AuditPlanIssues_DeterministicCoverageGate(t *testing.T) {
	testPlan := &gemini.LessonPlan{
		LessonTitle: "Bài kiểm tra độ phủ",
		QuestionCatalog: []gemini.CatalogItem{
			{DocID: "DOC_1", QuestionIDs: []string{"VD1", "VD2"}, TargetOutput: "Khái niệm", CoreMethod: "Định nghĩa"},
			{DocID: "DOC_2", QuestionIDs: []string{"C1", "C2"}, TargetOutput: "Đếm vectơ", CoreMethod: "Hình lập phương"},
			{DocID: "DOC_2", QuestionIDs: []string{"E1", "E2"}, TargetOutput: "Vật lý lực", CoreMethod: "Hợp lực"},
			{DocID: "DOC_2", QuestionIDs: []string{"E24"}, TargetOutput: "Vật lý góc", CoreMethod: "Tích vô hướng"},
		},
		Topics: []gemini.Topic{
			{
				TopicID:             "dang_1",
				Title:               "Khái niệm",
				AssignedQuestionIDs: []string{"VD1", "VD2", "C1", "C2"},
			},
			{
				TopicID:             "dang_2",
				Title:               "Vật lý lực",
				AssignedQuestionIDs: []string{"E1", "E2", "E24"},
			},
		},
	}

	unassigned, overloaded := gemini.AuditPlanIssues(testPlan)

	if len(overloaded) > 0 {
		t.Errorf("Kỳ vọng không có topic nào bị quá tải, nhưng nhận được: %d", len(overloaded))
	}

	// Dãy E có E1, E2 và E24 -> maxN = 24. Các câu E3..E23 phải được phát hiện là bị thủng lỗ!
	foundE14 := false
	foundE5 := false
	for _, id := range unassigned {
		if strings.Contains(id, "E14") {
			foundE14 = true
		}
		if strings.Contains(id, "E5") {
			foundE5 = true
		}
	}

	if !foundE14 || !foundE5 {
		t.Errorf("AuditPlanIssues không phát hiện được lỗ hổng dãy E (E5..E14): %v", unassigned)
	} else {
		t.Logf("✅ AuditPlanIssues phát hiện chính xác %d câu bị thủng lỗ trong dãy số: %v", len(unassigned), unassigned)
	}
}

func Test_OfflineTypstCompilation_WithRealArtifact(t *testing.T) {
	var plan gemini.LessonPlan
	var workers []gemini.WorkerResult

	if err := gemini.LoadArtifact("phase1_plan.json", &plan); err != nil {
		t.Fatalf("Không nạp được phase1_plan.json: %v", err)
	}
	if err := gemini.LoadArtifact("phase2_all_results.json", &workers); err != nil {
		t.Skipf("Bỏ qua kiểm thử vì chưa có phase2_all_results.json (chạy sau Phase 2): %v", err)
	}

	client, err := gemini.New(context.Background(), "test-key-offline", &mockPDFProcessor{})
	if err != nil {
		t.Fatalf("Khởi tạo client lỗi: %v", err)
	}

	typCode, err := client.ExecutePhase3_BuildTypst(&plan, workers)
	if err != nil {
		t.Fatalf("ExecutePhase3_BuildTypst lỗi: %v", err)
	}

	typPath := filepath.Join(gemini.ArtifactDir, "test_offline.typ")
	if err := os.WriteFile(typPath, []byte(typCode), 0644); err != nil {
		t.Fatalf("Lưu test_offline.typ lỗi: %v", err)
	}
	defer os.Remove(typPath)

	teacherPDF := filepath.Join(gemini.ArtifactDir, "test_teacher.pdf")
	studentPDF := filepath.Join(gemini.ArtifactDir, "test_student.pdf")
	defer os.Remove(teacherPDF)
	defer os.Remove(studentPDF)

	// Biên dịch Giáo viên
	cmdGV := exec.Command("typst", "compile", "--input", "teacher=true", typPath, teacherPDF)
	if out, err := cmdGV.CombinedOutput(); err != nil {
		t.Fatalf("Typst biên dịch bản Giáo Viên thất bại: %v\nOutput: %s", err, string(out))
	}
	t.Log("✅ Typst biên dịch Bản Giáo Viên thành công hoàn hảo!")

	// Biên dịch Học sinh
	cmdHS := exec.Command("typst", "compile", "--input", "teacher=false", typPath, studentPDF)
	if out, err := cmdHS.CombinedOutput(); err != nil {
		t.Fatalf("Typst biên dịch bản Học Sinh thất bại: %v\nOutput: %s", err, string(out))
	}
	t.Log("✅ Typst biên dịch Bản Học Sinh thành công hoàn hảo!")
}

func Test_AuditMathField(t *testing.T) {
	// 1. Bình thường
	ok, reason := gemini.AuditMathField("Cho tam giác $ABC$ có $\\vec{AB} = \\vec{a}$.")
	if !ok {
		t.Errorf("AuditMathField báo lỗi sai cho chuỗi hợp lệ: %s", reason)
	}

	// 2. Lệch dấu $
	ok, _ = gemini.AuditMathField("Cho tam giác $ABC có vectơ.")
	if ok {
		t.Errorf("AuditMathField không bắt được dấu $ bị lẻ")
	}

	// 3. LaTeX trần ngoài dấu $
	ok, _ = gemini.AuditMathField("Ta có \\vec{AB} là vectơ.")
	if ok {
		t.Errorf("AuditMathField không bắt được LaTeX trần ngoài dấu $")
	}

	// 4. Mã điều khiển ASCII rác
	ok, _ = gemini.AuditMathField("Có mã rác \f trong chuỗi")
	if ok {
		t.Errorf("AuditMathField không bắt được ký tự Form Feed rác")
	}
}

func Test_BuildSharedPDFPrefixParts(t *testing.T) {
	docs := []gemini.PDFDocumentInput{
		{DocID: "DOC_1", FileName: "doc1.pdf", RoleHint: "SGK", Data: []byte("pdf1_bytes")},
		{DocID: "DOC_2", FileName: "doc2.pdf", RoleHint: "Bài tập", Data: []byte("pdf2_bytes")},
	}

	parts := gemini.BuildSharedPDFPrefixParts(docs)

	// Phải có 2 parts blob đầu tiên + 1 part manifest cuối cùng = 3 parts
	if len(parts) != 3 {
		t.Fatalf("BuildSharedPDFPrefixParts trả về %d parts (kỳ vọng 3)", len(parts))
	}

	if parts[0].InlineData == nil || parts[0].InlineData.MIMEType != "application/pdf" {
		t.Errorf("Part 0 không phải là PDF Blob")
	}
	if parts[1].InlineData == nil || parts[1].InlineData.MIMEType != "application/pdf" {
		t.Errorf("Part 1 không phải là PDF Blob")
	}
	if parts[2].Text == "" || !strings.Contains(parts[2].Text, "DANH MỤC CÁC FILE PDF") {
		t.Errorf("Part 2 không phải là Manifest text")
	}
}

func Test_KeyPool_Initialization(t *testing.T) {
	keys := []string{"key_alpha", "key_beta", "key_gamma", "key_alpha"} // có duplicate
	pool, err := gemini.NewKeyPool(context.Background(), keys)
	if err != nil {
		t.Fatalf("NewKeyPool thất bại: %v", err)
	}

	if pool.Size() != 3 {
		t.Errorf("KeyPool phải loại bỏ duplicate, kỳ vọng 3 slots nhưng có %d", pool.Size())
	}
}

// Kiểm tra sức khỏe của từng Key riêng lẻ với request "hi" đơn giản
func Test_CheckEachKeyHealth(t *testing.T) {
	ctx := context.Background()
	keyFiles := []string{"key1.txt", "key2.txt", "key3.txt", "key4.txt", "key5.txt"}

	t.Log("==================================================================")
	t.Log("🔍 BẮT ĐẦU KIỂM TRA TỪNG API KEY (GỬI REQUEST 'hi'):")
	t.Log("==================================================================")

	for _, kf := range keyFiles {
		data, err := os.ReadFile(kf)
		if err != nil {
			t.Logf("❌ [%s]: Không tìm thấy file", kf)
			continue
		}
		rawKey := strings.TrimSpace(string(data))
		if rawKey == "" {
			t.Logf("❌ [%s]: File rỗng", kf)
			continue
		}

		keyPrefix := rawKey
		if len(keyPrefix) > 16 {
			keyPrefix = rawKey[:16] + "..."
		}

		cli, err := genai.NewClient(ctx, &genai.ClientConfig{
			APIKey:  rawKey,
			Backend: genai.BackendGeminiAPI,
		})
		if err != nil {
			t.Logf("❌ [%s] (%s): Khởi tạo Client thất bại: %v", kf, keyPrefix, err)
			continue
		}

		resp, err := cli.Models.GenerateContent(ctx, "gemma-4-26b-a4b-it", []*genai.Content{
			{Parts: []*genai.Part{{Text: "hi"}}},
		}, nil)

		if err != nil {
			errMsg := err.Error()
			if strings.Contains(errMsg, "403") || strings.Contains(errMsg, "PERMISSION_DENIED") {
				t.Logf("⛔ [%s] (%s): \033[31mBỊ KHÓA / PERMISSION DENIED (403)\033[0m: %v", kf, keyPrefix, err)
			} else if strings.Contains(errMsg, "429") || strings.Contains(errMsg, "RESOURCE_EXHAUSTED") {
				t.Logf("⚠️ [%s] (%s): \033[33mHẾT HẠN NGẠCH TẠM THỜI (429/TPM)\033[0m: %v", kf, keyPrefix, err)
			} else {
				t.Logf("❌ [%s] (%s): LỖI KHÁC: %v", kf, keyPrefix, err)
			}
		} else {
			text := strings.TrimSpace(resp.Text())
			if len(text) > 40 {
				text = text[:40] + "..."
			}
			t.Logf("✅ [%s] (%s): \033[32mHOẠT ĐỘNG TỐT (OK)\033[0m - Phản hồi: %q", kf, keyPrefix, text)
		}
	}
	t.Log("==================================================================")
}

// =============================================================================
// INTEGRATION TESTS: GỌI GEMMA 4 VỚI 3 FILE PDF & KEYPOOL (5 KEYS)
// =============================================================================

// TEST 1: PHASE 1 - MASTER SYNTHESIZER & PLANNER (MULTI-PDF SYNTHESIS)
func Test_Phase1_Planner(t *testing.T) {
	client := setupClient(t)
	ctx := context.Background()
	docs := loadTestPDFDocs(t)

	prompt := "Tập trung khai thác kịch bản kết hợp: Lấy mạch SGK làm khung lý thuyết, bổ sung bài tập trắc nghiệm và câu hỏi từ tài liệu ôn tập và tài liệu hướng dẫn."
	plan, err := client.ExecutePhase1_Planner(ctx, PlannerModel, docs, prompt)
	if err != nil {
		t.Fatalf("Phase 1 thất bại: %v", err)
	}

	if len(plan.Topics) == 0 {
		t.Fatalf("Planner không sinh ra dạng toán nào")
	}

	t.Logf("🎉 Phase 1 Thành công! Sinh được %d dạng toán vi kỹ năng:", len(plan.Topics))
	for i, top := range plan.Topics {
		t.Logf("  [%d] %s (Thao tác: %s)", i+1, top.Title, top.CoreConcept)
		for _, ref := range top.SourceRefs {
			t.Logf("       ↳ Nguồn: %s", ref)
		}
	}
}

// TEST 2: PHASE 2 - VIRTUAL-SLICE WORKERS QUA KEYPOOL 5 KEYS (KHÔNG CẮT PDF)
func Test_Phase2_Workers(t *testing.T) {
	client := setupClient(t)
	ctx := context.Background()
	docs := loadTestPDFDocs(t)

	var plan gemini.LessonPlan
	if err := gemini.LoadArtifact("phase1_plan.json", &plan); err != nil {
		t.Fatalf("Chưa có artifact phase1_plan.json. Hãy chạy Test_Phase1_Planner trước! Lỗi: %v", err)
	}

	results, err := client.ExecutePhase2_Workers(ctx, WorkerModel, docs, &plan)
	if err != nil {
		t.Fatalf("Phase 2 thất bại: %v", err)
	}

	t.Logf("🎉 Phase 2 Thành công! Toàn bộ %d Workers đã biên soạn xong bài tập chi tiết.", len(results))
	for i, res := range results {
		t.Logf("  [Dạng %d] %s: %d lý thuyết, %d ShortAnswers, %d ví dụ, %d Drills",
			i+1, res.Title, len(res.TheoryPoints), len(res.ShortAnswers), len(res.Examples), len(res.Drills))
	}
}

// TEST 3: PHASE 3 & 4 - BIÊN DỊCH TYPST VÀ XUẤT 2 FILE PDF
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

	gv, hs, err := client.ExecutePhase4_CompilePDF(ctx, RepairModel, &plan, workers)
	if err != nil {
		t.Fatalf("Phase 4 thất bại: %v", err)
	}

	t.Logf("🎉 BIÊN DỊCH XUẤT SẮC!\n- Bản Giáo viên: %s\n- Bản Học sinh: %s", gv, hs)
}

// TEST 4: TOÀN BỘ PIPELINE TỪ A ĐẾN Z
func Test_Full_Pipeline(t *testing.T) {
	client := setupClient(t)
	ctx := context.Background()
	docs := loadTestPDFDocs(t)

	// Phase 1: Planner
	t.Log("🚀 BẮT ĐẦU PHASE 1...")
	plan, err := client.ExecutePhase1_Planner(ctx, PlannerModel, docs, "Biên soạn giáo án và phiếu bài tập rèn tư duy toàn diện, bao phủ 100% các dạng toán trong tài liệu")
	if err != nil {
		t.Fatalf("Phase 1 thất bại: %v", err)
	}

	// Phase 2: Workers
	t.Log("🚀 BẮT ĐẦU PHASE 2...")
	workers, err := client.ExecutePhase2_Workers(ctx, WorkerModel, docs, plan)
	if err != nil {
		t.Fatalf("Phase 2 thất bại: %v", err)
	}

	// Phase 3 & 4: Typst & Self-Healing
	t.Log("🚀 BẮT ĐẦU PHASE 3 & 4...")
	gv, hs, err := client.ExecutePhase4_CompilePDF(ctx, RepairModel, plan, workers)
	if err != nil {
		t.Fatalf("Phase 4 thất bại: %v", err)
	}

	t.Logf("🎉 TOÀN BỘ PIPELINE ĐÃ HOÀN TẤT XUẤT SẮC!\n  [GV]: %s\n  [HS]: %s", gv, hs)
}

func Test_CheckAllSchemas(t *testing.T) {
	client := setupClient(t)
	ctx := context.Background()
	pool := client.KeyPool()

	t.Log("1. Testing WorkerSchema...")
	cfgWorker := &genai.GenerateContentConfig{
		MaxOutputTokens:  50,
		ResponseMIMEType: "application/json",
		ResponseSchema:   gemini.WorkerSchema(),
	}
	_, err := pool.GenerateContent(ctx, gemini.ModelGemma4_31B, []*genai.Content{
		{Parts: []*genai.Part{{Text: "ping"}}},
	}, cfgWorker, 1)
	if err != nil {
		t.Fatalf("❌ WorkerSchema lỗi: %v", err)
	}
	t.Log("✅ WorkerSchema OK!")
}
