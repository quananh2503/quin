package gemini

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
)

// =============================================================================
// BATCH REPAIRER: TỰ ĐỘNG SỬA CÚ PHÁP CÔNG THỨC TOÁN QUA AI HOẶC REGEX
// =============================================================================

// BatchRepairer interface tự động sửa lỗi cú pháp công thức toán theo lô
type BatchRepairer interface {
	RepairIssues(ctx context.Context, issues []ValidationIssue) (map[string]string, error)
}

// DefaultBatchRepairer thực thi sửa lỗi cú pháp công thức toán học
type DefaultBatchRepairer struct {
	llm       LLMProvider
	modelName string
}

// NewDefaultBatchRepairer khởi tạo BatchRepairer
func NewDefaultBatchRepairer(llm LLMProvider, modelName string) *DefaultBatchRepairer {
	return &DefaultBatchRepairer{
		llm:       llm,
		modelName: modelName,
	}
}

// RepairIssues: Gửi danh sách các trường công thức bị lỗi lên AI để sửa lại cú pháp chuẩn LaTeX.
func (r *DefaultBatchRepairer) RepairIssues(ctx context.Context, issues []ValidationIssue) (map[string]string, error) {
	if len(issues) == 0 {
		return make(map[string]string), nil
	}

	resultMap := make(map[string]string)

	// Nếu không có LLM (chạy offline fallback regex)
	if r.llm == nil {
		for _, issue := range issues {
			fixed := FallbackSanitizeLaTeX(issue.Content)
			resultMap[issue.SlotID] = fixed
		}
		return resultMap, nil
	}

	var itemsBuilder strings.Builder
	for idx, issue := range issues {
		snippet := issue.BrokenSnippet
		if snippet == "" {
			snippet = "(không có snippet cụ thể)"
		}
		reason := issue.Reason
		if reason == "" {
			reason = "Lỗi cú pháp toán hoặc thiếu $"
		}
		itemsBuilder.WriteString(fmt.Sprintf("Mục %d:\n* Vị trí: %s - %s\n* Nguyên nhân lỗi: %s\n* Đoạn gây lỗi: %s\n* Toàn văn cần sửa: %s\n\n",
			idx+1, issue.SlotID, issue.Context, reason, snippet, issue.Content))
	}

	prompt := fmt.Sprintf(`Bạn là Chuyên gia Cú pháp Toán học LaTeX.
Tài liệu sử dụng bộ phân tích cú pháp MiTeX để kết xuất công thức LaTeX.
Dưới đây là danh sách các mục bị lỗi cú pháp công thức toán LaTeX (như gõ nhầm tên lệnh, thiếu dấu ngoặc, hoặc công thức chưa kẹp dấu $).
Dựa vào nguyên nhân lỗi (do MiTeX báo) và đoạn gây lỗi cụ thể để phục hồi lại công thức LaTeX chuẩn.

NHIỆM VỤ:
1. Dựa vào nguyên nhân lỗi và đoạn gây lỗi, sửa lại cú pháp thành công thức LaTeX chuẩn.
2. MỌI CÔNG THỨC TOÁN, VECTƠ, PHÂN SỐ, BIẾN SỐ BẮT BUỘC ĐƯỢC BỌC TRONG CẶP DẤU $...$.
3. KÝ HIỆU VECTƠ: Dùng lệnh chuẩn \vec{...} (Ví dụ mẫu: $\vec{AB}$, $\vec{a}$, $\vec{b}$, $\vec{u}$). Tránh dùng các biến thể như \overline, \b, \bar, \vecc, \textvec.
4. Giữ nguyên vẹn toàn bộ câu chữ tiếng Việt tự nhiên và ngữ nghĩa toán học ban đầu.
5. CHỈ xuất kết quả dưới dạng JSON hợp lệ theo schema với mảng "repaired_items" gồm "anchor_id" và "fixed_content".

Danh sách cần sửa:
%s`, itemsBuilder.String())

	llmReq := LLMRequest{
		ModelName:       r.modelName,
		UserPrompt:      prompt,
		Temperature:     0.3,
		MaxOutputTokens: 8192,
		JSONSchema:      GetRepairSchemaBytes(),
	}

	fmt.Printf("🤖 [BatchRepairer] Đang gửi %d vị trí lỗi đến LLM...\n", len(issues))
	resp, err := r.llm.GenerateJSON(ctx, llmReq)
	if err != nil {
		fmt.Printf("⚠️ [BatchRepairer] Gọi LLM lỗi (%v) -> kích hoạt FallbackSanitizeLaTeX\n", err)
		for _, issue := range issues {
			resultMap[issue.SlotID] = FallbackSanitizeLaTeX(issue.Content)
		}
		return resultMap, nil
	}

	var batchResp RepairBatchResponse
	cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.RawJSON))
	if err := json.Unmarshal([]byte(cleanJSON), &batchResp); err != nil {
		fmt.Printf("⚠️ [BatchRepairer] Unmarshal lỗi (%v) -> kích hoạt FallbackSanitizeLaTeX\n", err)
		for _, issue := range issues {
			resultMap[issue.SlotID] = FallbackSanitizeLaTeX(issue.Content)
		}
		return resultMap, nil
	}

	fmt.Printf("✅ [BatchRepairer] LLM đã sửa %d mục\n", len(batchResp.RepairedItems))
	for _, item := range batchResp.RepairedItems {
		resultMap[item.AnchorID] = item.FixedContent
	}
	for _, issue := range issues {
		if _, ok := resultMap[issue.SlotID]; !ok {
			resultMap[issue.SlotID] = FallbackSanitizeLaTeX(issue.Content)
		}
	}

	return resultMap, nil
}

// FallbackSanitizeLaTeX tự động vá lỗi toán học cơ bản bằng deterministic regex mà không cần AI
func FallbackSanitizeLaTeX(content string) string {
	fixed := content
	// 1. Chuẩn hóa ký hiệu vectơ: \b{...}, \bar{...}, \overline{...}, \vecvec{...}, \vecc{...}, \textvec{...}, \br{...} -> \vec{...}
	fixed = strings.ReplaceAll(fixed, `\vecvec{`, `\vec{`)
	fixed = strings.ReplaceAll(fixed, `\vec{\vec{`, `\vec{`)
	fixed = strings.ReplaceAll(fixed, `\vecc{`, `\vec{`)
	fixed = strings.ReplaceAll(fixed, `\textvec{`, `\vec{`)
	fixed = strings.ReplaceAll(fixed, `\br{`, `\vec{`)
	fixed = strings.ReplaceAll(fixed, `\b{`, `\vec{`)
	fixed = strings.ReplaceAll(fixed, `\bar{`, `\vec{`)
	fixed = strings.ReplaceAll(fixed, `\overline{`, `\vec{`)

	// 2. Escape ký tự # và ký tự _ nếu chúng đứng ngoài khối công thức $...$
	var sb strings.Builder
	inMath := false
	runes := []rune(fixed)
	for i := 0; i < len(runes); i++ {
		r := runes[i]
		if r == '$' {
			inMath = !inMath
			sb.WriteRune(r)
			continue
		}
		if !inMath {
			if r == '#' && (i == 0 || runes[i-1] != '\\') {
				sb.WriteString(`\#`)
				continue
			}
			if r == '_' && (i == 0 || runes[i-1] != '\\') {
				sb.WriteString(`\_`)
				continue
			}
		}
		sb.WriteRune(r)
	}
	fixed = sb.String()

	// 3. Cân bằng cặp dấu $ nếu số lượng bị lẻ
	if strings.Count(fixed, "$")%2 != 0 {
		fixed += "$"
	}
	return fixed
}
