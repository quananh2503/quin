package driver_test

import (
	"context"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strings"
	"sync/atomic"
	"testing"
	"time"

	"go.uber.org/goleak"

	"meet-attendance-clean/infrastructure2/AI/internal/driver"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

func newTestHTTPClient(t *testing.T) *http.Client {
	t.Helper()
	tr := &http.Transport{}
	t.Cleanup(func() {
		tr.CloseIdleConnections()
	})
	return &http.Client{
		Timeout:   5 * time.Second,
		Transport: tr,
	}
}

func TestKeyPool_RotationCooldownAutoDisable(t *testing.T) {
	defer goleak.VerifyNone(t)

	if _, err := driver.NewKeyPool(nil, time.Second); err == nil {
		t.Fatal("expected error when key list is empty")
	}

	pool, err := driver.NewKeyPool([]string{"k1", "k2"}, 150*time.Millisecond)
	if err != nil {
		t.Fatalf("NewKeyPool failed: %v", err)
	}

	got1, err := pool.Acquire()
	if err != nil || got1 != "k1" {
		t.Fatalf("Acquire 1 = (%q, %v), want (k1, nil)", got1, err)
	}
	got2, err := pool.Acquire()
	if err != nil || got2 != "k2" {
		t.Fatalf("Acquire 2 = (%q, %v), want (k2, nil)", got2, err)
	}

	// Put k1 in transient cooldown; Acquire should skip k1 and return k2
	pool.ReportFailure("k1", false)
	got3, err := pool.Acquire()
	if err != nil || got3 != "k2" {
		t.Fatalf("Acquire during k1 cooldown = (%q, %v), want (k2, nil)", got3, err)
	}

	// Report success resets fail count on k2
	pool.ReportSuccess("k2")

	// Wait for k1 cooldown to expire, then permanently disable both
	time.Sleep(180 * time.Millisecond)
	got4, err := pool.Acquire()
	if err != nil || got4 != "k1" {
		t.Fatalf("Acquire after cooldown = (%q, %v), want (k1, nil)", got4, err)
	}

	pool.ReportFailure("k1", true)
	pool.ReportFailure("k2", true)
	if _, errNone := pool.Acquire(); errNone == nil {
		t.Fatal("expected error when all keys are disabled")
	}
}

func TestClient_PostChat_HappyPathAndGoldenSeam(t *testing.T) {
	defer goleak.VerifyNone(t)

	fixtureBytes, err := os.ReadFile(filepath.Join("..", "process", "testdata", "fixtures", "chat_response_think.json"))
	if err != nil {
		t.Fatalf("read golden fixture failed: %v", err)
	}

	var gotAuth string
	var gotBody raw.ChatRequest
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		gotAuth = r.Header.Get("Authorization")
		body, _ := io.ReadAll(r.Body)
		_ = json.Unmarshal(body, &gotBody)
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write(fixtureBytes)
	}))
	defer ts.Close()

	cli, err := driver.NewClient(raw.ClientConfig{
		APIKeys:    []string{"sk-golden-key"},
		BaseURL:    ts.URL,
		Timeout:    5 * time.Second,
		MaxRetries: 2,
		Cooldown:   50 * time.Millisecond,
	})
	if err != nil {
		t.Fatalf("NewClient failed: %v", err)
	}
	cli.WithHTTPClient(newTestHTTPClient(t))

	req := raw.ChatRequest{
		Model: "deepseek-flash",
		Messages: []raw.ChatMessage{
			{
				Role: "user",
				Content: []raw.ContentPart{
					{Type: "image_url", ImageURL: &raw.ImageURL{URL: "data:image/jpeg;base64,/9j/4AAQ"}},
					{Type: "text", Text: "Harvest items"},
				},
			},
		},
	}

	resp, rawBytes, err := cli.PostChat(context.Background(), req)
	if err != nil {
		t.Fatalf("PostChat failed: %v", err)
	}
	if gotAuth != "Bearer sk-golden-key" {
		t.Errorf("Authorization = %q, want Bearer sk-golden-key", gotAuth)
	}
	if gotBody.Model != "deepseek-flash" {
		t.Errorf("request model = %q, want deepseek-flash", gotBody.Model)
	}
	if len(resp.Choices) != 1 || resp.Usage == nil || resp.Usage.PromptCacheHitTokens != 960 {
		t.Errorf("unexpected parsed ChatResponse: %+v", resp)
	}
	if len(rawBytes) == 0 {
		t.Error("rawBytes must not be empty")
	}
}

func TestClient_PostChat_TransientRetryAndPermanentFastFail(t *testing.T) {
	defer goleak.VerifyNone(t)

	t.Run("Transient429And503_RetriesAndRotatesKey", func(t *testing.T) {
		var attempts atomic.Int32
		var seenKeys []string
		ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			seenKeys = append(seenKeys, r.Header.Get("Authorization"))
			n := attempts.Add(1)
			switch n {
			case 1:
				http.Error(w, "rate limited", http.StatusTooManyRequests)
			case 2:
				http.Error(w, "upstream unavailable", http.StatusServiceUnavailable)
			default:
				w.Header().Set("Content-Type", "application/json")
				_, _ = w.Write([]byte(`{"id":"ok","choices":[{"index":0,"message":{"role":"assistant","content":"{\"ok\":true}"},"finish_reason":"stop"}]}`))
			}
		}))
		defer ts.Close()

		cli, err := driver.NewClient(raw.ClientConfig{
			APIKeys:    []string{"key-1", "key-2"},
			BaseURL:    ts.URL,
			Timeout:    5 * time.Second,
			MaxRetries: 4,
			Cooldown:   10 * time.Millisecond,
		})
		if err != nil {
			t.Fatalf("NewClient failed: %v", err)
		}
		cli.WithHTTPClient(newTestHTTPClient(t))

		resp, _, err := cli.PostChat(context.Background(), raw.ChatRequest{
			Model:    "deepseek-flash",
			Messages: []raw.ChatMessage{{Role: "user", Content: "ping"}},
		})
		if err != nil {
			t.Fatalf("expected retry success, got: %v", err)
		}
		if len(resp.Choices) != 1 || attempts.Load() != 3 {
			t.Fatalf("attempts = %d, choices = %d", attempts.Load(), len(resp.Choices))
		}
		if len(seenKeys) < 2 || seenKeys[0] == seenKeys[1] {
			t.Errorf("expected key rotation after 429, seenKeys=%v", seenKeys)
		}
	})

	t.Run("Permanent401_FastFailWithoutRetry", func(t *testing.T) {
		var attempts atomic.Int32
		ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			attempts.Add(1)
			http.Error(w, `{"error":{"message":"invalid key"}}`, http.StatusUnauthorized)
		}))
		defer ts.Close()

		cli, err := driver.NewClient(raw.ClientConfig{
			APIKeys:    []string{"bad-key"},
			BaseURL:    ts.URL,
			MaxRetries: 3,
		})
		if err != nil {
			t.Fatalf("NewClient failed: %v", err)
		}
		cli.WithHTTPClient(newTestHTTPClient(t))

		_, _, errPost := cli.PostChat(context.Background(), raw.ChatRequest{
			Model:    "deepseek-flash",
			Messages: []raw.ChatMessage{{Role: "user", Content: "ping"}},
		})
		if errPost == nil {
			t.Fatal("expected error for 401 Unauthorized")
		}
		if attempts.Load() != 1 {
			t.Errorf("401 must fast-fail without retry, got %d attempts", attempts.Load())
		}
	})
}

func TestClient_ContextCancellationAndTimeout(t *testing.T) {
	defer goleak.VerifyNone(t)

	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		select {
		case <-time.After(400 * time.Millisecond):
			w.WriteHeader(http.StatusOK)
		case <-r.Context().Done():
		}
	}))
	defer ts.Close()

	cli, err := driver.NewClient(raw.ClientConfig{
		APIKeys:    []string{"sk-test"},
		BaseURL:    ts.URL,
		MaxRetries: 2,
	})
	if err != nil {
		t.Fatalf("NewClient failed: %v", err)
	}
	cli.WithHTTPClient(newTestHTTPClient(t))

	t.Run("WithCancel", func(t *testing.T) {
		ctx, cancel := context.WithCancel(context.Background())
		cancel()
		_, _, errCall := cli.PostChat(ctx, raw.ChatRequest{Model: "deepseek-flash", Messages: []raw.ChatMessage{{Role: "user", Content: "hi"}}})
		if !errors.Is(errCall, context.Canceled) {
			t.Fatalf("expected context.Canceled, got: %v", errCall)
		}
	})

	t.Run("WithTimeout", func(t *testing.T) {
		ctx, cancel := context.WithTimeout(context.Background(), 40*time.Millisecond)
		defer cancel()
		_, _, errCall := cli.PostChat(ctx, raw.ChatRequest{Model: "deepseek-flash", Messages: []raw.ChatMessage{{Role: "user", Content: "hi"}}})
		if !errors.Is(errCall, context.DeadlineExceeded) {
			t.Fatalf("expected context.DeadlineExceeded, got: %v", errCall)
		}
	})
}

func TestClient_CallParallel_RaceAndPartialFailure(t *testing.T) {
	defer goleak.VerifyNone(t)

	var count atomic.Int32
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		body, _ := io.ReadAll(r.Body)
		if strings.Contains(string(body), "FAIL_TOPIC") {
			http.Error(w, "bad request", http.StatusBadRequest)
			return
		}
		count.Add(1)
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(`{"id":"p","choices":[{"index":0,"message":{"role":"assistant","content":"ok"},"finish_reason":"stop"}]}`))
	}))
	defer ts.Close()

	cli, err := driver.NewClient(raw.ClientConfig{
		APIKeys:    []string{"sk-1", "sk-2"},
		BaseURL:    ts.URL,
		MaxRetries: 1,
	})
	if err != nil {
		t.Fatalf("NewClient failed: %v", err)
	}
	cli.WithHTTPClient(newTestHTTPClient(t))

	reqs := []raw.ChatRequest{
		{Model: "deepseek-flash", Messages: []raw.ChatMessage{{Role: "user", Content: "T1"}}},
		{Model: "deepseek-flash", Messages: []raw.ChatMessage{{Role: "user", Content: "T2"}}},
		{Model: "deepseek-flash", Messages: []raw.ChatMessage{{Role: "user", Content: "T3"}}},
	}
	results, err := cli.CallParallel(context.Background(), reqs, 2)
	if err != nil {
		t.Fatalf("CallParallel failed: %v", err)
	}
	if len(results) != 3 || count.Load() != 3 {
		t.Fatalf("results=%d count=%d, want 3", len(results), count.Load())
	}

	reqsWithFail := make([]raw.ChatRequest, 0, len(reqs)+1)
	reqsWithFail = append(reqsWithFail, reqs...)
	reqsWithFail = append(reqsWithFail, raw.ChatRequest{
		Model:    "deepseek-flash",
		Messages: []raw.ChatMessage{{Role: "user", Content: "FAIL_TOPIC"}},
	})
	if _, errFail := cli.CallParallel(context.Background(), reqsWithFail, 2); errFail == nil {
		t.Fatal("expected error when one parallel worker fails")
	}
}

func TestMediaRunner_And_TypstRunner(t *testing.T) {
	defer goleak.VerifyNone(t)

	tmpDir := t.TempDir()
	pdfPath := filepath.Join(tmpDir, "lesson.pdf")
	if err := os.WriteFile(pdfPath, []byte("%PDF-1.4 dummy"), 0o644); err != nil {
		t.Fatalf("write dummy pdf: %v", err)
	}

	runner := driver.NewMediaRunner(func(ctx context.Context, data []byte, fileType string, fileName string) ([][]byte, error) {
		return [][]byte{{0xFF, 0xD8, 0xFF, 0xD9}}, nil
	})

	docs, err := runner.MaterializeDocuments(context.Background(), []raw.MaterialSpec{
		{Kind: raw.MaterialPDF, ID: "DOC_PDF_1", Name: "lesson.pdf", FilePath: pdfPath},
		{Kind: raw.MaterialYouTube, ID: "DOC_YT_1", Name: "YouTube", URL: "https://youtu.be/abc"},
		{Kind: raw.MaterialMistake, ID: "DOC_MISTAKE", Name: "mistake.txt", Text: "Lỗi tính góc"},
	})
	if err != nil {
		t.Fatalf("MaterializeDocuments failed: %v", err)
	}
	if len(docs) != 3 || len(docs[0].Parts) == 0 || len(docs[1].Parts) == 0 || docs[2].Parts[0].Text != "Lỗi tính góc" {
		t.Errorf("unexpected materialized docs: %+v", docs)
	}

	if _, errMissing := runner.MaterializeDocuments(context.Background(), []raw.MaterialSpec{
		{Kind: raw.MaterialPDF, ID: "BAD", FilePath: filepath.Join(tmpDir, "missing.pdf")},
	}); errMissing == nil {
		t.Fatal("expected error for missing PDF file")
	}

	outDir := filepath.Join(tmpDir, "out")
	tr := driver.NewTypstRunner(outDir, 4).WithSelectedTopics([]string{"T1"})
	if err := tr.WriteArtifact("raw_data/plan_output.json", []byte(`{"ok":true}`)); err != nil {
		t.Fatalf("WriteArtifact failed: %v", err)
	}
	if _, errStat := os.Stat(filepath.Join(outDir, "raw_data", "plan_output.json")); errStat != nil {
		t.Errorf("artifact not written: %v", errStat)
	}

	// Fake executable typst script to verify CompileTypst happy path & error stderr capture
	fakeTypst := filepath.Join(tmpDir, "fake-typst.sh")
	script := "#!/bin/sh\nif grep -q 'BROKEN' \"$4\"; then echo 'test.typ:2:1: error: broken' >&2; exit 1; fi\ntouch \"$5\"\n"
	if err := os.WriteFile(fakeTypst, []byte(script), 0o755); err != nil {
		t.Fatalf("write fake typst: %v", err)
	}
	tr.WithTypstCLI(fakeTypst)

	if _, errOK := tr.CompileTypst(context.Background(), "raw_data/ok.typ", "ok.pdf", "#text[OK]", true); errOK != nil {
		t.Fatalf("CompileTypst ok failed: %v", errOK)
	}
	stderr, errBroken := tr.CompileTypst(context.Background(), "raw_data/bad.typ", "bad.pdf", "BROKEN", false)
	if errBroken == nil || !strings.Contains(stderr, "test.typ:2:1") {
		t.Errorf("expected error and stderr from fake typst, got stderr=%q err=%v", stderr, errBroken)
	}
}
