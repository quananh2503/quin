package pipeline

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"strings"

	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/AI/deepseek"
)

var (
	leakedLatexCmdRegex = regexp.MustCompile(`\\(?:frac|forall|vec|overrightarrow|overline|widehat|sqrt|neq|nabla|bar|beta|begin|binom|to|times|text|tan|theta|triangle|right|rightarrow|rho|cdot|perp|alpha|gamma|delta|Delta|varphi|pi|omega|leq|geq|approx|left|end|mathbf|mathrm|mathbb|mathcal|cos|sin|cot|log|ln|lim|sum|int|infty|pm|mp|cap|cup|subset|supset|in|notin|emptyset|Rightarrow|Leftrightarrow|iff|implies|angle|parallel)\b`)
	reTypFile           = regexp.MustCompile(`\.typ:(\d+)`)
	reLineCol           = regexp.MustCompile(`:(\d+):\d+`)
	reLineOnly          = regexp.MustCompile(`(?:at\s+line\s+|line\s+)(\d+)`)
)

func extractLineNum(line string) int {
	if m := reTypFile.FindStringSubmatch(line); len(m) > 1 {
		if n, err := strconv.Atoi(m[1]); err == nil && n > 0 {
			return n
		}
	}
	if m := reLineCol.FindStringSubmatch(line); len(m) > 1 {
		if n, err := strconv.Atoi(m[1]); err == nil && n > 0 {
			return n
		}
	}
	if m := reLineOnly.FindStringSubmatch(line); len(m) > 1 {
		if n, err := strconv.Atoi(m[1]); err == nil && n > 0 {
			return n
		}
	}
	return 0
}

// AuditMathField kiểm tra tính hợp lệ của trường văn bản chứa công thức toán.
// Bắt lỗi: ASCII rác, dấu $ bị lẻ, hoặc lệnh LaTeX trần nằm ngoài dấu $.
func AuditMathField(text string) (bool, string) {
	trimmed := strings.TrimSpace(text)
	if trimmed == "" {
		return true, ""
	}

	// 1. Bắt mã điều khiển ASCII rác (0x0C = \f, 0x08 = \b, 0x0B = \v)
	for _, r := range trimmed {
		if r == '\f' || r == '\b' || r == '\v' {
			return false, "Dính mã điều khiển ASCII rác do lỗi JSON escape"
		}
	}

	// 2. Bắt dấu $ bị lẻ
	if strings.Count(trimmed, "$")%2 != 0 {
		return false, "Số lượng dấu $ bị lẻ (chưa đóng công thức)"
	}

	// 3. Bắt lệnh LaTeX trần nằm ngoài cặp dấu $
	parts := strings.Split(trimmed, "$")
	for i := 0; i < len(parts); i += 2 {
		outside := parts[i]
		if leakedLatexCmdRegex.MatchString(outside) {
			return false, "Chứa lệnh LaTeX trần ngoài dấu $: " + outside
		}
	}

	return true, ""
}

// FallbackSanitizeLaTeX tự động vá lỗi toán học cơ bản bằng deterministic regex mà không cần AI.
func FallbackSanitizeLaTeX(content string) string {
	fixed := content

	// 1. Chuẩn hóa ký hiệu vectơ
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

// AuditTopicContent quét toàn bộ các trường dữ liệu trong TopicContent để phát hiện các vị trí có lỗi cú pháp.
func AuditTopicContent(tc *TopicContent) []RepairTask {
	if tc == nil {
		return nil
	}

	var tasks []RepairTask

	check := func(anchorID, contextDesc, text string) {
		if ok, reason := AuditMathField(text); !ok {
			tasks = append(tasks, RepairTask{
				TargetID:      anchorID,
				ErrorReason:   reason,
				BrokenSnippet: text,
				Context:       contextDesc,
				Content:       text,
			})
		}
	}

	// 1. Kiểm tra TheoryPoints
	for idx, tp := range tc.TheoryPoints {
		check(fmt.Sprintf("%s|theory|%d", tc.TopicID, idx), "Lý thuyết nền tảng", tp)
	}
	if tc.ClozeFormula != "" {
		check(fmt.Sprintf("%s|cloze", tc.TopicID), "Công thức then chốt", tc.ClozeFormula)
	}
	if tc.CalloutTip != "" {
		check(fmt.Sprintf("%s|callout", tc.TopicID), "Khẩu quyết cốt lõi", tc.CalloutTip)
	}

	// 2. Kiểm tra Variants
	for vIdx, v := range tc.Variants {
		check(fmt.Sprintf("%s|v|%d|rec", tc.TopicID, vIdx), fmt.Sprintf("Nhận diện %s", v.VariantID), v.Recognition)
		for sIdx, step := range v.ActionSteps {
			check(fmt.Sprintf("%s|v|%d|step|%d", tc.TopicID, vIdx, sIdx), fmt.Sprintf("Bước làm %s", v.VariantID), step)
		}
		if v.QuickTip != "" {
			check(fmt.Sprintf("%s|v|%d|tip", tc.TopicID, vIdx), fmt.Sprintf("QuickTip %s", v.VariantID), v.QuickTip)
		}
		if v.Example.Problem != "" {
			check(fmt.Sprintf("%s|v|%d|ex_prob", tc.TopicID, vIdx), fmt.Sprintf("Đề ví dụ %s", v.VariantID), v.Example.Problem)
			check(fmt.Sprintf("%s|v|%d|ex_sol", tc.TopicID, vIdx), fmt.Sprintf("Lời giải ví dụ %s", v.VariantID), v.Example.Solution)
		}
		for dIdx, dr := range v.Drills {
			check(fmt.Sprintf("%s|v|%d|drill|%d|prompt", tc.TopicID, vIdx, dIdx), fmt.Sprintf("Đề bài tập %s.%d", v.VariantID, dIdx+1), dr.Prompt)
			check(fmt.Sprintf("%s|v|%d|drill|%d|sol", tc.TopicID, vIdx, dIdx), fmt.Sprintf("Lời giải bài tập %s.%d", v.VariantID, dIdx+1), dr.Solution)
		}
	}

	// 3. Kiểm tra AnswerKey
	for aIdx, ans := range tc.AnswerKey {
		check(fmt.Sprintf("%s|ans|%d|guide", tc.TopicID, aIdx), "Bảng đáp án (hướng dẫn)", ans.ShortGuide)
		check(fmt.Sprintf("%s|ans|%d|final", tc.TopicID, aIdx), "Bảng đáp án (kết quả)", ans.FinalAnswer)
	}

	return tasks
}

// ExtractContextField lấy nội dung chuỗi tương ứng với TargetID từ TopicContent.
func ExtractContextField(tc *TopicContent, targetID string) string {
	if tc == nil || targetID == "" {
		return ""
	}

	parts := strings.Split(targetID, "|")
	if len(parts) < 2 {
		return ""
	}

	switch parts[1] {
	case "theory":
		if len(parts) >= 3 {
			if idx, err := strconv.Atoi(parts[2]); err == nil && idx >= 0 && idx < len(tc.TheoryPoints) {
				return tc.TheoryPoints[idx]
			}
		}
	case "cloze":
		return tc.ClozeFormula
	case "callout":
		return tc.CalloutTip
	case "v":
		if len(parts) >= 4 {
			vIdx, errV := strconv.Atoi(parts[2])
			if errV != nil || vIdx < 0 || vIdx >= len(tc.Variants) {
				return ""
			}
			v := &tc.Variants[vIdx]
			switch parts[3] {
			case "rec":
				return v.Recognition
			case "step":
				if len(parts) >= 5 {
					if sIdx, errS := strconv.Atoi(parts[4]); errS == nil && sIdx >= 0 && sIdx < len(v.ActionSteps) {
						return v.ActionSteps[sIdx]
					}
				}
			case "tip":
				return v.QuickTip
			case "ex_prob":
				return v.Example.Problem
			case "ex_sol":
				return v.Example.Solution
			case "drill":
				if len(parts) >= 6 {
					dIdx, errD := strconv.Atoi(parts[4])
					if errD == nil && dIdx >= 0 && dIdx < len(v.Drills) {
						if parts[5] == "prompt" {
							return v.Drills[dIdx].Prompt
						} else if parts[5] == "sol" {
							return v.Drills[dIdx].Solution
						}
					}
				}
			}
		}
	}
	return ""
}

// SetContextField cập nhật nội dung đã sửa vào đúng vị trí trong TopicContent theo TargetID.
func SetContextField(tc *TopicContent, targetID string, fixedContent string) {
	if tc == nil || targetID == "" {
		return
	}

	parts := strings.Split(targetID, "|")
	if len(parts) < 2 {
		return
	}

	switch parts[1] {
	case "theory":
		if len(parts) >= 3 {
			if idx, err := strconv.Atoi(parts[2]); err == nil && idx >= 0 && idx < len(tc.TheoryPoints) {
				tc.TheoryPoints[idx] = fixedContent
			}
		}
	case "cloze":
		tc.ClozeFormula = fixedContent
	case "callout":
		tc.CalloutTip = fixedContent
	case "v":
		if len(parts) >= 4 {
			vIdx, errV := strconv.Atoi(parts[2])
			if errV != nil || vIdx < 0 || vIdx >= len(tc.Variants) {
				return
			}
			v := &tc.Variants[vIdx]
			switch parts[3] {
			case "rec":
				v.Recognition = fixedContent
			case "step":
				if len(parts) >= 5 {
					if sIdx, errS := strconv.Atoi(parts[4]); errS == nil && sIdx >= 0 && sIdx < len(v.ActionSteps) {
						v.ActionSteps[sIdx] = fixedContent
					}
				}
			case "tip":
				v.QuickTip = fixedContent
			case "ex_prob":
				v.Example.Problem = fixedContent
			case "ex_sol":
				v.Example.Solution = fixedContent
			case "drill":
				if len(parts) >= 6 {
					dIdx, errD := strconv.Atoi(parts[4])
					if errD == nil && dIdx >= 0 && dIdx < len(v.Drills) {
						if parts[5] == "prompt" {
							v.Drills[dIdx].Prompt = fixedContent
						} else if parts[5] == "sol" {
							v.Drills[dIdx].Solution = fixedContent
						}
					}
				}
			}
		}
	}
}

// ExtractCompilerErrorAnchors trích xuất các anchor ID từ stderr của trình biên dịch Typst.
func ExtractCompilerErrorAnchors(markup string, compilerStderr string, tc *TopicContent) []RepairTask {
	lines := strings.Split(markup, "\n")
	seen := make(map[string]bool)
	var tasks []RepairTask

	for _, l := range strings.Split(compilerStderr, "\n") {
		lineNum := extractLineNum(l)
		if lineNum > 0 {
			anchorID := FindNearestAnchor(lines, lineNum)
			if anchorID != "" && !seen[anchorID] {
				seen[anchorID] = true
				content := ExtractContextField(tc, anchorID)
				tasks = append(tasks, RepairTask{
					TargetID:      anchorID,
					ErrorReason:   "Lỗi biên dịch Typst",
					BrokenSnippet: content,
					Context:       anchorID,
					Content:       content,
				})
			}
		}
	}
	return tasks
}

// DefaultRepairer triển khai Repairer interface.
// Nhiệm vụ: Tự động phát hiện và gửi batch sửa các lỗi cú pháp toán LaTeX, dấu dollar không khớp hoặc lỗi Typst.
type DefaultRepairer struct {
	provider ai.Provider
	model    string
}

// NewRepairer khởi tạo DefaultRepairer.
func NewRepairer(provider ai.Provider, model string) *DefaultRepairer {
	if model == "" {
		model = "deepseek-flash"
	}
	return &DefaultRepairer{
		provider: provider,
		model:    model,
	}
}

type repairBatchOutput struct {
	RepairedItems []struct {
		TargetID     string `json:"target_id"`
		FixedContent string `json:"fixed_content"`
	} `json:"repaired_items"`
}

// RepairMath gửi batch các đoạn công thức bị lỗi cú pháp để AI sửa lại đúng định dạng chuẩn.
func (r *DefaultRepairer) RepairMath(ctx context.Context, tasks []RepairTask) ([]RepairTask, error) {
	if len(tasks) == 0 {
		return tasks, nil
	}

	// 1. Nếu không có provider, chạy chế độ fallback regex
	if r.provider == nil {
		for i := range tasks {
			tasks[i].FixedContent = FallbackSanitizeLaTeX(tasks[i].Content)
		}
		return tasks, nil
	}

	var sb strings.Builder
	sb.WriteString("DANH SÁCH CÁC MỤC BỊ LỖI CÚ PHÁP CẦN SỬA:\n\n")
	for idx, t := range tasks {
		sb.WriteString(fmt.Sprintf("Mục %d:\n* Mã target_id (BẮT BUỘC giữ nguyên): %s\n* Ngữ cảnh: %s\n* Nguyên nhân lỗi: %s\n* Toàn văn cần sửa: %s\n\n",
			idx+1, t.TargetID, t.Context, t.ErrorReason, t.Content))
	}

	systemPrompt := `Bạn là Chuyên gia Cú pháp Toán học LaTeX và Bộ phân tích Typst MiTeX.
NHIỆM VỤ: Sửa lại các đoạn văn bản bị lỗi cú pháp toán LaTeX (thiếu dấu $, dấu $ bị lẻ, dính ký tự rác, hoặc gõ nhầm lệnh).

QUY TẮC BẮT BUỘC:
1. MỌI CÔNG THỨC TOÁN, VECTƠ, BIỂN SỐ, PHÂN SỐ BẮT BUỘC BỌC TRONG CẶP DẤU $...$.
2. KÝ HIỆU VECTƠ: Dùng \vec{...} hoặc \overrightarrow{...} chuẩn.
3. GIỮ NGUYÊN VẸN toàn bộ câu chữ tiếng Việt tự nhiên và ngữ nghĩa toán học ban đầu.
4. Trả về JSON theo đúng định dạng:
{
  "repaired_items": [
    {
      "target_id": "mã giữ nguyên",
      "fixed_content": "nội dung đã sửa"
    }
  ]
}`

	cfg := &deepseek.Config{
		Temperature:    0.1,
		MaxTokens:      8192,
		ResponseFormat: &deepseek.ResponseFormatConfig{Type: "json_object"},
	}

	req := ai.Request{
		Model:        r.model,
		SystemPrompt: systemPrompt,
		UserPrompt:   sb.String(),
		Config:       cfg,
	}

	resp, errGen := r.provider.Generate(ctx, req)
	if errGen != nil {
		// Kích hoạt FallbackSanitizeLaTeX
		for i := range tasks {
			tasks[i].FixedContent = FallbackSanitizeLaTeX(tasks[i].Content)
		}
		return tasks, nil
	}

	var batchOut repairBatchOutput
	cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.Content))
	if errUnmarshal := json.Unmarshal([]byte(cleanJSON), &batchOut); errUnmarshal != nil {
		// Fallback
		for i := range tasks {
			tasks[i].FixedContent = FallbackSanitizeLaTeX(tasks[i].Content)
		}
		return tasks, nil
	}

	fixedMap := make(map[string]string)
	for _, item := range batchOut.RepairedItems {
		fixedMap[item.TargetID] = item.FixedContent
	}

	for i := range tasks {
		if fixed, found := fixedMap[tasks[i].TargetID]; found && strings.TrimSpace(fixed) != "" {
			tasks[i].FixedContent = fixed
		} else {
			tasks[i].FixedContent = FallbackSanitizeLaTeX(tasks[i].Content)
		}
	}

	return tasks, nil
}

// RepairSyntax sửa lỗi cú pháp tài liệu nói chung.
func (r *DefaultRepairer) RepairSyntax(ctx context.Context, rawContent string, syntaxErrors []string) (string, error) {
	return FallbackSanitizeLaTeX(rawContent), nil
}

// SelfHealCompile thực hiện toàn bộ vòng lặp tự động sửa lỗi và biên dịch Typst sang PDF.
// Vòng lặp: Pre-Audit -> Sửa lỗi -> Lắp ráp Typst -> Thử biên dịch -> Sửa lỗi compiler nếu có -> Hoàn tất.
func (r *DefaultRepairer) SelfHealCompile(ctx context.Context, tc *TopicContent, typstCLI, typPath, pdfPath string, isTeacher bool, maxRetries int) error {
	if tc == nil {
		return fmt.Errorf("topicContent rỗng")
	}
	if maxRetries <= 0 {
		maxRetries = 3
	}

	// 1. Pre-Audit trong bộ nhớ RAM
	preAuditTasks := AuditTopicContent(tc)
	if len(preAuditTasks) > 0 {
		repairedTasks, errRep := r.RepairMath(ctx, preAuditTasks)
		if errRep == nil && len(repairedTasks) > 0 {
			for _, task := range repairedTasks {
				SetContextField(tc, task.TargetID, task.FixedContent)
			}
		}
	}

	teacherFlag := "teacher=false"
	if isTeacher {
		teacherFlag = "teacher=true"
	}

	failedAttempts := make(map[string]int)

	// 2. Vòng lặp biên dịch và phục hồi (Self-Healing Loop)
	for attempt := 1; attempt <= maxRetries; attempt++ {
		typstMarkup := RenderTopicTypst(tc)
		tc.TypstContent = typstMarkup

		if errWrite := os.WriteFile(typPath, []byte(typstMarkup), 0644); errWrite != nil {
			return fmt.Errorf("ghi file Typst %s thất bại: %w", typPath, errWrite)
		}

		cmd := exec.CommandContext(ctx, typstCLI, "compile", "--input", teacherFlag, typPath, pdfPath)
		out, errCompile := cmd.CombinedOutput()
		if errCompile == nil {
			// Biên dịch thành công 100%!
			return nil
		}

		// Nếu có lỗi biên dịch từ Typst
		stderr := string(out)
		errorTasks := ExtractCompilerErrorAnchors(typstMarkup, stderr, tc)
		if len(errorTasks) == 0 {
			// Áp dụng fallback sanitize cho toàn bộ các trường
			for _, v := range tc.Variants {
				v.Recognition = FallbackSanitizeLaTeX(v.Recognition)
				for sIdx := range v.ActionSteps {
					v.ActionSteps[sIdx] = FallbackSanitizeLaTeX(v.ActionSteps[sIdx])
				}
			}
			continue
		}

		// Áp dụng Circuit Breaker: nếu 1 anchor bị lỗi liên tiếp 2 lần, dùng fallback regex
		var toSendAI []RepairTask
		for _, task := range errorTasks {
			failedAttempts[task.TargetID]++
			if failedAttempts[task.TargetID] >= 2 {
				SetContextField(tc, task.TargetID, FallbackSanitizeLaTeX(task.Content))
			} else {
				toSendAI = append(toSendAI, task)
			}
		}

		if len(toSendAI) > 0 {
			repairedTasks, errRep := r.RepairMath(ctx, toSendAI)
			if errRep == nil {
				for _, task := range repairedTasks {
					SetContextField(tc, task.TargetID, task.FixedContent)
				}
			}
		}
	}

	// Thử biên dịch lần cuối sau khi đã qua maxRetries
	typstMarkup := RenderTopicTypst(tc)
	tc.TypstContent = typstMarkup
	if errWrite := os.WriteFile(typPath, []byte(typstMarkup), 0644); errWrite != nil {
		return fmt.Errorf("ghi file Typst %s thất bại: %w", typPath, errWrite)
	}
	cmdFinal := exec.CommandContext(ctx, typstCLI, "compile", "--input", teacherFlag, typPath, pdfPath)
	if outFinal, errFinal := cmdFinal.CombinedOutput(); errFinal != nil {
		return fmt.Errorf("biên dịch Typst thất bại sau %d lần tự sửa: %w (Log: %s)", maxRetries, errFinal, string(outFinal))
	}

	return nil
}
