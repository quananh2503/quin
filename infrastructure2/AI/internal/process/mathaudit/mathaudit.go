package mathaudit

import (
	"encoding/json"
	"fmt"
	"regexp"
	"strings"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

var leakedLatexCmdRegex = regexp.MustCompile(`\\(?:frac|forall|vec|overrightarrow|overline|widehat|sqrt|neq|nabla|bar|beta|begin|binom|to|times|text|tan|theta|triangle|right|rightarrow|rho|cdot|perp|alpha|gamma|delta|Delta|varphi|pi|omega|leq|geq|approx|left|end|mathbf|mathrm|mathbb|mathcal|cos|sin|cot|log|ln|lim|sum|int|infty|pm|mp|cap|cup|subset|supset|in|notin|emptyset|Rightarrow|Leftrightarrow|iff|implies|angle|parallel)\b`)

// AuditMathField checks a text field for ASCII control garbage, odd '$' delimiters, or unenclosed LaTeX commands.
func AuditMathField(text string) (ok bool, reason string) {
	trimmed := strings.TrimSpace(text)
	if trimmed == "" {
		return true, ""
	}

	for _, r := range trimmed {
		if r == '\f' || r == '\b' || r == '\v' {
			return false, "Dính mã điều khiển ASCII rác do lỗi JSON escape"
		}
	}

	if strings.Count(trimmed, "$")%2 != 0 {
		return false, "Số lượng dấu $ bị lẻ (chưa đóng công thức)"
	}

	parts := strings.Split(trimmed, "$")
	for i := 0; i < len(parts); i += 2 {
		if leakedLatexCmdRegex.MatchString(parts[i]) {
			return false, "Chứa lệnh LaTeX trần ngoài dấu $: " + parts[i]
		}
	}
	return true, ""
}

// AuditTopicContent scans all pedagogical fields of a TopicContent and returns RepairTasks for broken math fields.
func AuditTopicContent(tc raw.TopicContent) []raw.RepairTask {
	var tasks []raw.RepairTask

	for idx, tp := range tc.TheoryPoints {
		tasks = appendIfBroken(tasks, fmt.Sprintf("%s|theory|%d", tc.TopicID, idx), "Lý thuyết nền tảng", tp)
	}
	if tc.ClozeFormula != "" {
		tasks = appendIfBroken(tasks, fmt.Sprintf("%s|cloze", tc.TopicID), "Công thức then chốt", tc.ClozeFormula)
	}
	if tc.CalloutTip != "" {
		tasks = appendIfBroken(tasks, fmt.Sprintf("%s|callout", tc.TopicID), "Khẩu quyết cốt lõi", tc.CalloutTip)
	}

	for vIdx := range tc.Variants {
		tasks = auditVariant(tasks, tc.TopicID, vIdx, &tc.Variants[vIdx])
	}

	for aIdx, ans := range tc.AnswerKey {
		tasks = appendIfBroken(tasks, fmt.Sprintf("%s|ans|%d|guide", tc.TopicID, aIdx), "Bảng đáp án (hướng dẫn)", ans.ShortGuide)
		tasks = appendIfBroken(tasks, fmt.Sprintf("%s|ans|%d|final", tc.TopicID, aIdx), "Bảng đáp án (kết quả)", ans.FinalAnswer)
	}
	return tasks
}

// FallbackSanitizeLaTeX applies deterministic regex normalization and delimiter balancing without LLM calls.
func FallbackSanitizeLaTeX(content string) string {
	fixed := normalizeVectorCommands(content)
	fixed = escapeNonMathSpecials(fixed)
	if strings.Count(fixed, "$")%2 != 0 {
		fixed += "$"
	}
	return fixed
}

// ParseRepairBatch merges repaired JSON items onto tasks, falling back to FallbackSanitizeLaTeX when missing.
func ParseRepairBatch(sanitizedJSON string, tasks []raw.RepairTask) []raw.RepairTask {
	out := make([]raw.RepairTask, len(tasks))
	copy(out, tasks)

	var batch raw.RepairBatchOutput
	fixedMap := make(map[string]string)
	if err := json.Unmarshal([]byte(strings.TrimSpace(sanitizedJSON)), &batch); err == nil {
		for _, item := range batch.RepairedItems {
			fixedMap[item.TargetID] = item.FixedContent
		}
	}

	for i := range out {
		if fixed, ok := fixedMap[out[i].TargetID]; ok && strings.TrimSpace(fixed) != "" {
			out[i].FixedContent = fixed
		} else {
			out[i].FixedContent = FallbackSanitizeLaTeX(out[i].Content)
		}
	}
	return out
}

func appendIfBroken(tasks []raw.RepairTask, anchorID, contextDesc, text string) []raw.RepairTask {
	if ok, reason := AuditMathField(text); !ok {
		tasks = append(tasks, raw.RepairTask{
			TargetID:      anchorID,
			ErrorReason:   reason,
			BrokenSnippet: text,
			Context:       contextDesc,
			Content:       text,
		})
	}
	return tasks
}

func auditVariant(tasks []raw.RepairTask, topicID string, vIdx int, v *raw.VariantGuide) []raw.RepairTask {
	tasks = appendIfBroken(tasks, fmt.Sprintf("%s|v|%d|rec", topicID, vIdx), fmt.Sprintf("Nhận diện %s", v.VariantID), v.Recognition)
	for sIdx, step := range v.ActionSteps {
		tasks = appendIfBroken(tasks, fmt.Sprintf("%s|v|%d|step|%d", topicID, vIdx, sIdx), fmt.Sprintf("Bước làm %s", v.VariantID), step)
	}
	if v.QuickTip != "" {
		tasks = appendIfBroken(tasks, fmt.Sprintf("%s|v|%d|tip", topicID, vIdx), fmt.Sprintf("QuickTip %s", v.VariantID), v.QuickTip)
	}
	if v.Example.Problem != "" {
		tasks = appendIfBroken(tasks, fmt.Sprintf("%s|v|%d|ex_prob", topicID, vIdx), fmt.Sprintf("Đề ví dụ %s", v.VariantID), v.Example.Problem)
	}
	if v.Example.Solution != "" {
		tasks = appendIfBroken(tasks, fmt.Sprintf("%s|v|%d|ex_sol", topicID, vIdx), fmt.Sprintf("Lời giải ví dụ %s", v.VariantID), v.Example.Solution)
	}
	for dIdx, dr := range v.Drills {
		tasks = appendIfBroken(tasks, fmt.Sprintf("%s|v|%d|drill|%d|prompt", topicID, vIdx, dIdx), fmt.Sprintf("Đề bài tập %s.%d", v.VariantID, dIdx+1), dr.Prompt)
		tasks = appendIfBroken(tasks, fmt.Sprintf("%s|v|%d|drill|%d|sol", topicID, vIdx, dIdx), fmt.Sprintf("Lời giải bài tập %s.%d", v.VariantID, dIdx+1), dr.Solution)
	}
	return tasks
}

func normalizeVectorCommands(content string) string {
	fixed := content
	for _, old := range []string{`\vecvec{`, `\vec{\vec{`, `\vecc{`, `\textvec{`, `\br{`, `\b{`, `\bar{`, `\overline{`} {
		fixed = strings.ReplaceAll(fixed, old, `\vec{`)
	}
	return fixed
}

func escapeNonMathSpecials(fixed string) string {
	var sb strings.Builder
	inMath := false
	runes := []rune(fixed)
	for i, r := range runes {
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
	return sb.String()
}
