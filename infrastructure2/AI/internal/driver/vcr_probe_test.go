package driver_test

import (
	"bytes"
	"context"
	"flag"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"go.uber.org/goleak"
	"gopkg.in/dnaeon/go-vcr.v4/pkg/cassette"
	"gopkg.in/dnaeon/go-vcr.v4/pkg/recorder"

	"meet-attendance-clean/infrastructure2/AI/internal/driver"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

var updateVCRFixture = flag.Bool("update-fixture", false, "write captured VCR response bytes to ../process/testdata/fixtures/")

func newScrubAuthHook() recorder.HookFunc {
	return func(i *cassette.Interaction) error {
		delete(i.Request.Headers, "Authorization")
		return nil
	}
}

// TestVCR_RecordAndReplay_LoopbackDemo minh họa đầy đủ 2 pha của go-vcr v4:
// 1. Pha RECORD: Gọi HTTP thật qua go-vcr, tự động xóa header Authorization trước khi lưu YAML cassette.
// 2. Pha REPLAY: Đóng server hoàn toàn (100% offline, không có API key thật), phát lại từ cassette YAML.
func TestVCR_RecordAndReplay_LoopbackDemo(t *testing.T) {
	defer goleak.VerifyNone(t)

	cassettePath := filepath.Join("testdata", "cassettes", "deepseek_loopback")
	cassetteFile := cassettePath + ".yaml"

	// --- PHA 1: RECORD (chỉ chạy để tạo cassette YAML mẫu lần đầu) ---
	var serverHits int
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		serverHits++
		if r.Header.Get("Authorization") != "Bearer sk-super-secret-live-key" {
			http.Error(w, "unauthorized", http.StatusUnauthorized)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("X-DS-Trace-ID", "trace-vcr-demo-001")
		_, _ = w.Write([]byte(`{
			"id": "chatcmpl-vcr-001",
			"choices": [{
				"index": 0,
				"message": {
					"role": "assistant",
					"content": "{\"total_items\":1,\"items\":[{\"id\":\"DOC1_B1_HD1\",\"source_name\":\"SGK\",\"source_label\":\"HĐ 1\",\"item_type\":\"hoat_dong\",\"snippet\":\"Vectơ trong không gian\"}]}"
				},
				"finish_reason": "stop"
			}],
			"usage": {
				"prompt_tokens": 120,
				"completion_tokens": 45,
				"total_tokens": 165,
				"prompt_cache_hit_tokens": 64,
				"prompt_cache_miss_tokens": 56
			}
		}`))
	}))

	rec, err := recorder.New(
		cassettePath,
		recorder.WithMode(recorder.ModeRecordOnly),
		recorder.WithHook(newScrubAuthHook(), recorder.BeforeSaveHook),
		recorder.WithMatcher(cassette.NewDefaultMatcher(cassette.WithIgnoreAuthorization())),
		recorder.WithRealTransport(ts.Client().Transport),
	)
	if err != nil {
		ts.Close()
		t.Fatalf("create record VCR: %v", err)
	}

	cliRecord, err := driver.NewClient(raw.ClientConfig{
		APIKeys:    []string{"sk-super-secret-live-key"},
		BaseURL:    ts.URL,
		Timeout:    5 * time.Second,
		MaxRetries: 1,
	})
	if err != nil {
		_ = rec.Stop()
		ts.Close()
		t.Fatalf("NewClient record: %v", err)
	}
	cliRecord.WithHTTPClient(rec.GetDefaultClient())

	req := raw.ChatRequest{
		Model:    "deepseek-chat",
		Messages: []raw.ChatMessage{{Role: "user", Content: "Ping VCR record"}},
	}
	recResp, recRaw, err := cliRecord.PostChat(context.Background(), req)
	if err != nil {
		_ = rec.Stop()
		ts.Close()
		t.Fatalf("PostChat record failed: %v", err)
	}
	if err := rec.Stop(); err != nil {
		ts.Close()
		t.Fatalf("stop record VCR: %v", err)
	}
	// ĐÓNG SERVER VẬT LÝ — từ điểm này trở đi mọi kết nối mạng tới ts.URL đều chết!
	ts.Close()

	if serverHits != 1 {
		t.Fatalf("expected 1 real HTTP hit during record, got %d", serverHits)
	}

	// Xác minh secret scrubbing: API key thật TUYỆT ĐỐI KHÔNG tồn tại trong file YAML cassette!
	yamlBytes, err := os.ReadFile(cassetteFile)
	if err != nil {
		t.Fatalf("read saved cassette %s: %v", cassetteFile, err)
	}
	if strings.Contains(string(yamlBytes), "sk-super-secret-live-key") {
		t.Fatalf("SECURITY LEAK: secret API key was saved into %s", cassetteFile)
	}

	// --- PHA 2: REPLAY 100% OFFLINE (server đã tắt, truyền API key giả khác hẳn) ---
	replay, err := recorder.New(
		cassettePath,
		recorder.WithMode(recorder.ModeReplayOnly),
		recorder.WithMatcher(cassette.NewDefaultMatcher(cassette.WithIgnoreAuthorization())),
	)
	if err != nil {
		t.Fatalf("create replay VCR: %v", err)
	}
	defer func() {
		if errStop := replay.Stop(); errStop != nil {
			t.Errorf("stop replay VCR: %v", errStop)
		}
	}()

	cliReplay, err := driver.NewClient(raw.ClientConfig{
		APIKeys:    []string{"offline-dummy-key-never-sent"},
		BaseURL:    ts.URL,
		Timeout:    5 * time.Second,
		MaxRetries: 1,
	})
	if err != nil {
		t.Fatalf("NewClient replay: %v", err)
	}
	cliReplay.WithHTTPClient(replay.GetDefaultClient())

	repResp, repRaw, err := cliReplay.PostChat(context.Background(), req)
	if err != nil {
		t.Fatalf("PostChat offline replay failed: %v", err)
	}
	if repResp.ID != recResp.ID || !bytes.Equal(repRaw, recRaw) {
		t.Fatalf("replayed response differs from recorded response: got ID=%q want ID=%q", repResp.ID, recResp.ID)
	}
	if repResp.Usage == nil || repResp.Usage.PromptCacheHitTokens != 64 {
		t.Fatalf("unexpected replayed usage: %+v", repResp.Usage)
	}
}

// TestVCR_RealDeepSeek_Probe dùng để bạn tự quay cassette thật từ https://api.deepseek.com:
//   - Quay lần đầu (tốn ~30 tokens, tự xóa Authorization header):
//     VCR_MODE=record DEEPSEEK_API_KEY="sk-..." go test -v -run TestVCR_RealDeepSeek_Probe ./infrastructure2/AI/internal/driver/... -update-fixture
//   - Chạy phát lại offline mãi mãi về sau (không cần DEEPSEEK_API_KEY):
//     go test -v -run TestVCR_RealDeepSeek_Probe ./infrastructure2/AI/internal/driver/...
func TestVCR_RealDeepSeek_Probe(t *testing.T) {
	defer goleak.VerifyNone(t)

	cassettePath := filepath.Join("testdata", "cassettes", "deepseek_real_chat")
	cassetteFile := cassettePath + ".yaml"

	mode := recorder.ModeReplayOnly
	apiKey := "offline-replay-key"
	if strings.EqualFold(os.Getenv("VCR_MODE"), "record") {
		apiKey = strings.TrimSpace(os.Getenv("DEEPSEEK_API_KEY"))
		if apiKey == "" {
			t.Fatal("VCR_MODE=record yêu cầu thiết lập biến môi trường DEEPSEEK_API_KEY")
		}
		mode = recorder.ModeRecordOnly
	} else if _, err := os.Stat(cassetteFile); os.IsNotExist(err) {
		t.Skip("chưa có cassette thật testdata/cassettes/deepseek_real_chat.yaml; chạy với VCR_MODE=record DEEPSEEK_API_KEY=... để quay lần đầu")
	}

	baseURL := strings.TrimSpace(os.Getenv("DEEPSEEK_BASE_URL"))
	if baseURL == "" {
		baseURL = "https://api.deepseek.com"
	}

	tr := &http.Transport{}
	t.Cleanup(tr.CloseIdleConnections)

	rec, err := recorder.New(
		cassettePath,
		recorder.WithMode(mode),
		recorder.WithHook(newScrubAuthHook(), recorder.BeforeSaveHook),
		recorder.WithMatcher(cassette.NewDefaultMatcher(cassette.WithIgnoreAuthorization())),
		recorder.WithRealTransport(tr),
	)
	if err != nil {
		t.Fatalf("init go-vcr recorder: %v", err)
	}
	defer func() {
		if errStop := rec.Stop(); errStop != nil {
			t.Errorf("stop go-vcr recorder: %v", errStop)
		}
	}()

	cli, err := driver.NewClient(raw.ClientConfig{
		APIKeys:    []string{apiKey},
		BaseURL:    baseURL,
		Timeout:    30 * time.Second,
		MaxRetries: 2,
	})
	if err != nil {
		t.Fatalf("NewClient: %v", err)
	}
	cli.WithHTTPClient(rec.GetDefaultClient())

	resp, rawBytes, err := cli.PostChat(context.Background(), raw.ChatRequest{
		Model: "deepseek-chat",
		Messages: []raw.ChatMessage{
			{Role: "system", Content: "Return a minimal valid JSON object with key ok=true."},
			{Role: "user", Content: "Respond with {\"ok\":true}."},
		},
		Temperature:    0,
		MaxTokens:      64,
		ResponseFormat: &raw.ResponseFormatConfig{Type: "json_object"},
	})
	if err != nil {
		t.Fatalf("PostChat failed: %v", err)
	}
	if len(resp.Choices) == 0 {
		t.Fatalf("expected >= 1 choice, got 0 (raw=%s)", string(rawBytes))
	}

	if *updateVCRFixture {
		fixtureDst := filepath.Join("..", "process", "testdata", "fixtures", "deepseek_vcr_captured.json")
		if errWrite := os.WriteFile(fixtureDst, rawBytes, 0o644); errWrite != nil {
			t.Fatalf("write Golden Seam fixture %s: %v", fixtureDst, errWrite)
		}
		t.Logf("Updated Golden Seam fixture: %s (%d bytes)", fixtureDst, len(rawBytes))
	}
}
