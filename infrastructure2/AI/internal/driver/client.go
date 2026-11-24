package driver

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"strings"
	"sync"
	"time"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

const (
	defaultBaseURL    = "https://api.deepseek.com"
	defaultTimeout    = 180 * time.Second
	defaultMaxRetries = 3
)

// Client sends HTTP chat completion requests with retry, backoff, and key rotation.
type Client struct {
	httpClient *http.Client
	baseURL    string
	maxRetries int
	keyPool    *KeyPool
}

// NewClient creates a new HTTP Client configured with the given ClientConfig.
func NewClient(cfg raw.ClientConfig) (*Client, error) {
	pool, err := NewKeyPool(cfg.APIKeys, cfg.Cooldown)
	if err != nil {
		return nil, fmt.Errorf("create key pool: %w", err)
	}

	baseURL := strings.TrimRight(strings.TrimSpace(cfg.BaseURL), "/")
	if baseURL == "" {
		baseURL = defaultBaseURL
	}
	timeout := cfg.Timeout
	if timeout <= 0 {
		timeout = defaultTimeout
	}
	maxRetries := cfg.MaxRetries
	if maxRetries <= 0 {
		maxRetries = defaultMaxRetries
	}

	return &Client{
		httpClient: &http.Client{Timeout: timeout},
		baseURL:    baseURL,
		maxRetries: maxRetries,
		keyPool:    pool,
	}, nil
}

// WithHTTPClient sets a custom http.Client for transport customization or testing.
func (c *Client) WithHTTPClient(hc *http.Client) *Client {
	if hc != nil {
		c.httpClient = hc
	}
	return c
}

// PostChat executes a single chat completion HTTP call with retry on transient errors.
func (c *Client) PostChat(ctx context.Context, req raw.ChatRequest) (raw.ChatResponse, []byte, error) {
	if err := ctx.Err(); err != nil {
		return raw.ChatResponse{}, nil, fmt.Errorf("chat request context: %w", err)
	}
	payload, err := json.Marshal(req)
	if err != nil {
		return raw.ChatResponse{}, nil, fmt.Errorf("marshal chat request: %w", err)
	}

	endpoint := c.baseURL + "/chat/completions"
	var lastErr error
	for attempt := 1; attempt <= c.maxRetries; attempt++ {
		resp, body, retry, errAttempt := c.attemptChat(ctx, endpoint, payload, attempt)
		if errAttempt == nil {
			return resp, body, nil
		}
		lastErr = errAttempt
		if !retry || attempt >= c.maxRetries {
			return raw.ChatResponse{}, nil, lastErr
		}
		if errWait := waitBackoff(ctx, time.Duration(attempt)*25*time.Millisecond); errWait != nil {
			return raw.ChatResponse{}, nil, errWait
		}
	}
	return raw.ChatResponse{}, nil, lastErr
}

// CallParallel executes multiple chat completion requests concurrently using a worker pool.
func (c *Client) CallParallel(ctx context.Context, reqs []raw.ChatRequest, workers int) ([]raw.ChatCallResult, error) {
	if len(reqs) == 0 {
		return nil, nil
	}
	if workers <= 0 {
		workers = 1
	}
	if workers > len(reqs) {
		workers = len(reqs)
	}

	runCtx, cancel := context.WithCancel(ctx)
	defer cancel()

	jobs := make(chan int, len(reqs))
	for i := range reqs {
		jobs <- i
	}
	close(jobs)

	results := make([]raw.ChatCallResult, len(reqs))
	var (
		wg       sync.WaitGroup
		errOnce  sync.Once
		firstErr error
	)

	for range workers {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for idx := range jobs {
				if runCtx.Err() != nil {
					results[idx] = raw.ChatCallResult{Err: runCtx.Err()}
					continue
				}
				resp, rawBytes, errCall := c.PostChat(runCtx, reqs[idx])
				results[idx] = raw.ChatCallResult{
					Response: resp,
					Raw:      rawBytes,
					Err:      errCall,
				}
				if errCall != nil {
					errOnce.Do(func() {
						firstErr = errCall
						cancel()
					})
				}
			}
		}()
	}

	wg.Wait()
	if firstErr != nil {
		return results, firstErr
	}
	return results, nil
}

func (c *Client) attemptChat(
	ctx context.Context,
	endpoint string,
	payload []byte,
	attempt int,
) (resp raw.ChatResponse, rawBytes []byte, retry bool, err error) {
	if err := ctx.Err(); err != nil {
		return raw.ChatResponse{}, nil, false, fmt.Errorf("chat context cancelled: %w", err)
	}
	key, err := c.keyPool.Acquire()
	if err != nil {
		return raw.ChatResponse{}, nil, false, fmt.Errorf("acquire api key: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, http.MethodPost, endpoint, bytes.NewReader(payload))
	if err != nil {
		return raw.ChatResponse{}, nil, false, fmt.Errorf("create http request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")
	httpReq.Header.Set("Authorization", "Bearer "+key)

	res, errDo := c.httpClient.Do(httpReq)
	if errDo != nil {
		c.keyPool.ReportFailure(key, false)
		return raw.ChatResponse{}, nil, ctx.Err() == nil, fmt.Errorf("chat http attempt %d/%d: %w", attempt, c.maxRetries, errDo)
	}

	body, errRead := io.ReadAll(res.Body)
	errClose := res.Body.Close()
	if errRead != nil {
		c.keyPool.ReportFailure(key, false)
		return raw.ChatResponse{}, nil, true, fmt.Errorf("read chat response body: %w", errRead)
	}
	if errClose != nil {
		c.keyPool.ReportFailure(key, false)
		return raw.ChatResponse{}, nil, true, fmt.Errorf("close chat response body: %w", errClose)
	}

	if res.StatusCode == http.StatusOK {
		return c.decodeOKResponse(key, body)
	}
	if res.StatusCode == http.StatusTooManyRequests || res.StatusCode >= http.StatusInternalServerError {
		c.keyPool.ReportFailure(key, false)
		return raw.ChatResponse{}, nil, true, fmt.Errorf("provider HTTP %d: %s", res.StatusCode, string(body))
	}

	permanent := res.StatusCode == http.StatusUnauthorized || res.StatusCode == http.StatusForbidden
	c.keyPool.ReportFailure(key, permanent)
	return raw.ChatResponse{}, nil, false, fmt.Errorf("provider HTTP %d: %s", res.StatusCode, string(body))
}

func (c *Client) decodeOKResponse(key string, body []byte) (resp raw.ChatResponse, rawBytes []byte, retry bool, err error) {
	var chatResp raw.ChatResponse
	if err := json.Unmarshal(body, &chatResp); err != nil {
		c.keyPool.ReportFailure(key, false)
		return raw.ChatResponse{}, nil, true, fmt.Errorf("unmarshal chat response: %w", err)
	}
	if chatResp.Error != nil && strings.TrimSpace(chatResp.Error.Message) != "" {
		c.keyPool.ReportFailure(key, false)
		return raw.ChatResponse{}, nil, false, errors.New(chatResp.Error.Message)
	}
	c.keyPool.ReportSuccess(key)
	return chatResp, body, false, nil
}

func waitBackoff(ctx context.Context, d time.Duration) error {
	timer := time.NewTimer(d)
	defer timer.Stop()
	select {
	case <-ctx.Done():
		return fmt.Errorf("wait retry backoff: %w", ctx.Err())
	case <-timer.C:
		return nil
	}
}
