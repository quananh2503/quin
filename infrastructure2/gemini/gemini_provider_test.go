package gemini_test

import (
	"context"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"meet-attendance-clean/infrastructure2/gemini"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"google.golang.org/genai"
)

// Helper: Tải API keys khả dụng từ thư mục (đã loại bỏ key2 và key5 do bị khóa)
func loadIntegrationAPIKeys() []string {
	var keys []string
	keyFiles := []string{
		"key.txt", "key1.txt", "key2.txt", "key3.txt", "key4.txt", "key5.txt",
		filepath.Join("infrastructure2", "gemini", "key.txt"),
		filepath.Join("infrastructure2", "gemini", "key1.txt"),
		filepath.Join("infrastructure2", "gemini", "key2.txt"),
		filepath.Join("infrastructure2", "gemini", "key3.txt"),
		filepath.Join("infrastructure2", "gemini", "key4.txt"),
		filepath.Join("infrastructure2", "gemini", "key5.txt"),
	}
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
		keys = append(keys, envKey)
	}
	return keys
}

// -----------------------------------------------------------------------------
// TEST 1: KIỂM TRA TĨNH CẤU TRÚC SCHEMA - TUYỆT ĐỐI KHÔNG CÓ MẢNG LỒNG NHAU
// Đảm bảo không bị dính lỗi InvalidArgument do Gemma 4 không hỗ trợ nested array
// -----------------------------------------------------------------------------
func Test_GeminiSchemas_NoNestedArrays_StaticInspection(t *testing.T) {
	provider := gemini.NewGeminiLLMProvider(nil, gemini.ModelGemma4_31B)

	schemas := map[string]*genai.Schema{
		"PlannerSchema": provider.PlannerSchema(),
		"WorkerSchema":  provider.WorkerSchema(),
		"RepairSchema":  provider.RepairSchema(),
	}

	for name, sch := range schemas {
		t.Run(name, func(t *testing.T) {
			require.NotNil(t, sch, "Schema %s không được nil", name)
			assertNoNestedArrays(t, name, sch)
		})
	}
}

// assertNoNestedArrays đệ quy kiểm tra không có bất kỳ mảng lồng mảng nào
func assertNoNestedArrays(t *testing.T, path string, sch *genai.Schema) {
	if sch == nil {
		return
	}

	if sch.Type == genai.TypeArray {
		require.NotNil(t, sch.Items, "Trường mảng tại %s phải có Items định nghĩa kiểu phần tử", path)
		assert.NotEqual(t, genai.TypeArray, sch.Items.Type,
			"LỖI INVALID ARGUMENT CỦA GEMMA: Phát hiện mảng lồng nhau tại %s (Array chứa Array)!", path)
		assertNoNestedArrays(t, path+"[item]", sch.Items)
	}

	if sch.Type == genai.TypeObject && sch.Properties != nil {
		for propName, propSch := range sch.Properties {
			assertNoNestedArrays(t, path+"."+propName, propSch)
		}
	}
}

// -----------------------------------------------------------------------------
// TEST 2: GỬI PRE-FLIGHT TEST TRỰC TIẾP LÊN MODEL GEMMA 4 31B (gemma-4-31b-it)
// Kiểm tra Google API backend chấp nhận cả 3 Schemas mà không trả về 400 InvalidArgument
// -----------------------------------------------------------------------------
func Test_GeminiSchemas_LivePreFlightWithGemma31B(t *testing.T) {
	if os.Getenv("LIVE_GEMINI_TEST") == "" {
		t.Skip("Bỏ qua live integration test để tiết kiệm token (đặt LIVE_GEMINI_TEST=1 để chạy)")
	}
	keys := loadIntegrationAPIKeys()
	if len(keys) == 0 {
		t.Skip("Bỏ qua live integration test vì không tìm thấy API key nào trong key*.txt")
	}

	pool, err := gemini.NewKeyPool(context.Background(), keys)
	require.NoError(t, err)

	provider := gemini.NewGeminiLLMProvider(pool, gemini.ModelGemma4_31B)

	testCases := []struct {
		name       string
		schemaType string // "planner", "worker", "repair"
	}{
		{"Gemma31B_PlannerSchema", "planner"},
		{"Gemma31B_WorkerSchema", "worker"},
		{"Gemma31B_RepairSchema", "repair"},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
			defer cancel()

			req := gemini.LLMRequest{
				ModelName:       gemini.ModelGemma4_31B,
				UserPrompt:      "ping test schema",
				MaxOutputTokens: 10, // Tiết kiệm token tối đa, chỉ cần kiểm tra backend validate schema
				Temperature:     0.1,
			}

			// Chỉ định schema tương ứng
			switch tc.schemaType {
			case "planner":
				req.JSONSchema = provider.PlannerSchemaBytes()
			case "worker":
				req.JSONSchema = provider.WorkerSchemaBytes()
			case "repair":
				req.JSONSchema = provider.RepairSchemaBytes()
			}

			resp, err := provider.GenerateJSON(ctx, req)
			require.NoError(t, err, "Google Gemini API từ chối Schema với lỗi (nguy cơ InvalidArgument): %v", err)
			assert.NotNil(t, resp)
			assert.NotEmpty(t, resp.RawJSON)
			t.Logf("✅ Schema %s được Gemma 4 31B chấp nhận 100%%!", tc.name)
			time.Sleep(2 * time.Second)
		})
	}
}

// -----------------------------------------------------------------------------
// TEST 3: GỬI PRE-FLIGHT TEST TRỰC TIẾP LÊN MODEL GEMMA 4 26B (gemma-4-26b-a4b-it)
// -----------------------------------------------------------------------------
func Test_GeminiSchemas_LivePreFlightWithGemma26B(t *testing.T) {
	if os.Getenv("LIVE_GEMINI_TEST") == "" {
		t.Skip("Bỏ qua live integration test để tiết kiệm token (đặt LIVE_GEMINI_TEST=1 để chạy)")
	}
	keys := loadIntegrationAPIKeys()
	if len(keys) == 0 {
		t.Skip("Bỏ qua live integration test vì không tìm thấy API key")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	pool, err := gemini.NewKeyPool(ctx, keys)
	require.NoError(t, err)

	provider := gemini.NewGeminiLLMProvider(pool, gemini.ModelGemma4_26B_A4B)

	req := gemini.LLMRequest{
		ModelName:       gemini.ModelGemma4_26B_A4B,
		UserPrompt:      "ping test schema 26b",
		MaxOutputTokens: 10,
		Temperature:     0.1,
		JSONSchema:      provider.WorkerSchemaBytes(),
	}

	resp, err := provider.GenerateJSON(ctx, req)
	require.NoError(t, err, "Gemma 4 26B từ chối WorkerSchema: %v", err)
	assert.NotNil(t, resp)
	assert.NotEmpty(t, resp.RawJSON)
	t.Log("✅ WorkerSchema được Gemma 4 26B chấp thuận thành công!")
}

// -----------------------------------------------------------------------------
// TEST 4: TÍNH NĂNG TỰ ĐỘNG CHUYỂN KEY (FAILOVER ROUND-ROBIN) KHI CÓ KEY CHẾT
// -----------------------------------------------------------------------------
func Test_GeminiProvider_KeyPoolFailover_Integration(t *testing.T) {
	if os.Getenv("LIVE_GEMINI_TEST") == "" {
		t.Skip("Bỏ qua live integration test để tiết kiệm token (đặt LIVE_GEMINI_TEST=1 để chạy)")
	}
	keys := loadIntegrationAPIKeys()
	if len(keys) < 2 {
		t.Skip("Cần ít nhất 2 keys để kiểm tra failover")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	// Khởi tạo pool với key chết ở đầu để kiểm tra failover sang key sống (key1, key3, key4)
	failoverKeys := append([]string{"AIzaSyDeadKeyDummyForFailoverTesting1234"}, keys...)
	pool, err := gemini.NewKeyPool(ctx, failoverKeys)
	require.NoError(t, err)

	provider := gemini.NewGeminiLLMProvider(pool, gemini.ModelGemma4_31B)

	req := gemini.LLMRequest{
		ModelName:       gemini.ModelGemma4_31B,
		UserPrompt:      "Compute 1 + 1. Return single JSON: {\"result\": 2}",
		MaxOutputTokens: 128,
	}

	// Gọi request và đảm bảo dù vấp phải key lỗi 403, provider vẫn tự động fallback sang key sống
	resp, err := provider.GenerateJSON(ctx, req)
	require.NoError(t, err, "Failover thất bại, không tìm được key sống: %v", err)
	assert.NotNil(t, resp)
	assert.NotEmpty(t, resp.RawJSON)
	assert.Contains(t, strings.ToLower(resp.RawJSON), "2")
	t.Log("✅ KeyPool tự động vượt qua key chết và hoàn thành request!")
}

// -----------------------------------------------------------------------------
// TEST 5: MULTIMODAL INPUT (GỬI FILE PDF RAW BYTES + PROMPT)
// -----------------------------------------------------------------------------
func Test_GeminiProvider_MultimodalInput_Integration(t *testing.T) {
	if os.Getenv("LIVE_GEMINI_TEST") == "" {
		t.Skip("Bỏ qua live integration test để tiết kiệm token (đặt LIVE_GEMINI_TEST=1 để chạy)")
	}
	keys := loadIntegrationAPIKeys()
	if len(keys) == 0 {
		t.Skip("Bỏ qua test vì không có key")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	pool, err := gemini.NewKeyPool(ctx, keys)
	require.NoError(t, err)

	provider := gemini.NewGeminiLLMProvider(pool, gemini.ModelGemma4_31B)

	// Tạo tài liệu PDF giả lập hoặc đọc từ PDF mẫu có sẵn
	fakePDF := []byte("%PDF-1.4 mock content for multimodal input test")

	req := gemini.LLMRequest{
		ModelName:  gemini.ModelGemma4_31B,
		UserPrompt: "Tóm tắt tài liệu 1 câu",
		Documents: []gemini.DocumentInput{
			{
				DocID:    "DOC_TEST",
				FileName: "test.pdf",
				RawPDF:   fakePDF,
			},
		},
		MaxOutputTokens: 20,
	}

	resp, err := provider.GenerateJSON(ctx, req)
	require.NoError(t, err)
	assert.NotNil(t, resp)
	assert.NotEmpty(t, resp.RawJSON)
}
