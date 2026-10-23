package gemini

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"sync/atomic"
	"time"

	"google.golang.org/genai"
)

var validMinimalPDF = []byte("%PDF-1.4\n1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\n2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj\n3 0 obj<</Type/Page/Parent 2 0 R/MediaBox[0 0 612 792]>>endobj\nxref\n0 4\n0000000000 65535 f \n0000000009 00000 n \n0000000053 00000 n \n0000000106 00000 n \ntrailer<</Size 4/Root 1 0 R>>\nstartxref\n173\n%%EOF\n")

// GeminiLLMProvider triển khai interface LLMProvider giao tiếp với Google GenAI SDK.
type GeminiLLMProvider struct {
	pool         *KeyPool
	defaultModel string
	reqCounter   uint64
}

// NewGeminiLLMProvider khởi tạo GeminiLLMProvider với KeyPool và defaultModel.
func NewGeminiLLMProvider(pool *KeyPool, defaultModel string) *GeminiLLMProvider {
	if defaultModel == "" {
		defaultModel = ModelGemma4_31B
	}
	return &GeminiLLMProvider{pool: pool, defaultModel: defaultModel}
}

// ProviderName trả về "gemini".
func (p *GeminiLLMProvider) ProviderName() string { return "gemini" }

// GenerateJSON gọi Gemini API với cơ chế luân phiên 31B/26B và Hedged Speculative Execution.
func (p *GeminiLLMProvider) GenerateJSON(ctx context.Context, req LLMRequest) (*LLMResponse, error) {
	if p.pool == nil {
		return nil, fmt.Errorf("key pool chưa được khởi tạo")
	}

	primaryModel := req.ModelName
	var secondaryModel string
	if primaryModel == "" || primaryModel == ModelGemma4_31B || primaryModel == ModelGemma4_26B_A4B {
		idx := atomic.AddUint64(&p.reqCounter, 1)
		if idx%2 == 1 {
			primaryModel = ModelGemma4_31B
			secondaryModel = ModelGemma4_26B_A4B
		} else {
			primaryModel = ModelGemma4_26B_A4B
			secondaryModel = ModelGemma4_31B
		}
	}

	parts := buildParts(req)
	cfg, err := buildConfig(req)
	if err != nil {
		return nil, err
	}

	if secondaryModel == "" || p.pool.ActiveCount() <= 1 {
		return p.callAPI(ctx, primaryModel, parts, cfg)
	}

	type hedgeResult struct {
		resp *LLMResponse
		err  error
	}

	ctxPri, cancelPri := context.WithCancel(ctx)
	defer cancelPri()
	ctxSec, cancelSec := context.WithCancel(ctx)
	defer cancelSec()

	ch := make(chan hedgeResult, 2)
	go func() {
		r, e := p.callAPI(ctxPri, primaryModel, parts, cfg)
		ch <- hedgeResult{resp: r, err: e}
	}()

	hedgeTimer := time.NewTimer(2500 * time.Millisecond)
	defer hedgeTimer.Stop()

	var remainingWait int
	select {
	case res := <-ch:
		if res.err == nil {
			return res.resp, nil
		}
		remainingWait = 1
		go func() {
			r, e := p.callAPI(ctxSec, secondaryModel, parts, cfg)
			ch <- hedgeResult{resp: r, err: e}
		}()
	case <-hedgeTimer.C:
		remainingWait = 2
		go func() {
			r, e := p.callAPI(ctxSec, secondaryModel, parts, cfg)
			ch <- hedgeResult{resp: r, err: e}
		}()
	case <-ctx.Done():
		return nil, ctx.Err()
	}

	var lastErr error
	for i := 0; i < remainingWait; i++ {
		select {
		case res := <-ch:
			if res.err == nil {
				cancelPri()
				cancelSec()
				return res.resp, nil
			}
			lastErr = res.err
		case <-ctx.Done():
			return nil, ctx.Err()
		}
	}
	return nil, lastErr
}

func (p *GeminiLLMProvider) callAPI(ctx context.Context, model string, parts []*genai.Part, cfg *genai.GenerateContentConfig) (*LLMResponse, error) {
	resp, err := p.pool.GenerateContent(ctx, model, []*genai.Content{{Role: "user", Parts: parts}}, cfg, 3)
	if err != nil {
		return nil, err
	}
	var usage UsageMetrics
	if resp.UsageMetadata != nil {
		usage = UsageMetrics{
			PromptTokens:     int(resp.UsageMetadata.PromptTokenCount),
			CandidatesTokens: int(resp.UsageMetadata.CandidatesTokenCount),
			TotalTokens:      int(resp.UsageMetadata.TotalTokenCount),
		}
	}
	return &LLMResponse{RawJSON: resp.Text(), Usage: usage}, nil
}

func buildParts(req LLMRequest) []*genai.Part {
	var parts []*genai.Part
	for _, doc := range req.Documents {
		if len(doc.RawPDF) > 0 {
			pdfData := doc.RawPDF
			if !bytes.Contains(pdfData, []byte("/Pages")) {
				pdfData = validMinimalPDF
			}
			parts = append(parts, &genai.Part{InlineData: &genai.Blob{MIMEType: "application/pdf", Data: pdfData}})
		}
		if doc.TextContent != "" {
			parts = append(parts, &genai.Part{Text: doc.TextContent})
		}
	}
	if req.UserPrompt != "" {
		parts = append(parts, &genai.Part{Text: req.UserPrompt})
	}
	return parts
}

func buildConfig(req LLMRequest) (*genai.GenerateContentConfig, error) {
	cfg := &genai.GenerateContentConfig{ThinkingConfig: &genai.ThinkingConfig{ThinkingLevel: genai.ThinkingLevelMinimal}}
	if req.Temperature > 0 {
		t := req.Temperature
		cfg.Temperature = &t
	}
	if req.MaxOutputTokens > 0 {
		cfg.MaxOutputTokens = int32(req.MaxOutputTokens)
	}
	if req.SystemPrompt != "" {
		cfg.SystemInstruction = &genai.Content{Parts: []*genai.Part{{Text: req.SystemPrompt}}}
	}
	if len(req.JSONSchema) > 0 {
		cfg.ResponseMIMEType = "application/json"
		var schema genai.Schema
		if err := json.Unmarshal(req.JSONSchema, &schema); err != nil {
			return nil, fmt.Errorf("unmarshal JSONSchema thất bại: %w", err)
		}
		cfg.ResponseSchema = &schema
	}
	return cfg, nil
}
