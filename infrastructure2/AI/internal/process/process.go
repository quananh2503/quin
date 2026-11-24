package process

import (
	"encoding/json"
	"errors"
	"fmt"
	"regexp"
	"strings"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

var (
	thinkTagRegex              = regexp.MustCompile(`(?s)<think>.*?</think>`)
	unescapedLatexGenericRegex = regexp.MustCompile(`(^|[^\\])\\([a-zA-Z]{2,})`)
	singleCharCmdRegex         = regexp.MustCompile(`(^|[^\\])\\([a-zA-Z])\{`)
	normalizeVecRegex          = regexp.MustCompile(`\\\\(?:overline|overrightarrow)\{([A-Z]'?[A-Z]'?)\}`)
)

// ExtractLLMResponse extracts normalized content, reasoning, and usage from ChatResponse.
func ExtractLLMResponse(chatResp raw.ChatResponse, rawBytes []byte, model string) (raw.LLMResponse, error) {
	if len(chatResp.Choices) == 0 {
		return raw.LLMResponse{}, errors.New("LLM response contains no choices")
	}

	choice := chatResp.Choices[0]
	rawContent := choice.Message.Content
	if strings.TrimSpace(rawContent) == "" && strings.TrimSpace(choice.Message.ReasoningContent) != "" {
		rawContent = choice.Message.ReasoningContent
	}

	stripped := thinkTagRegex.ReplaceAllString(rawContent, "")
	if strings.TrimSpace(stripped) != "" {
		rawContent = stripped
	}

	var usage raw.Usage
	if chatResp.Usage != nil {
		usage = *chatResp.Usage
		if usageBytes, err := json.Marshal(chatResp.Usage); err == nil {
			usage.RawJSON = string(usageBytes)
		}
	}

	return raw.LLMResponse{
		Content:          strings.TrimSpace(rawContent),
		ReasoningContent: choice.Message.ReasoningContent,
		Model:            model,
		Raw:              string(rawBytes),
		FinishReason:     choice.FinishReason,
		Usage:            usage,
	}, nil
}

// SanitizeRawJSONLaTeX strips markdown fences, extracts JSON, escapes LaTeX, and fixes ASCII control sequences.
func SanitizeRawJSONLaTeX(input string) string {
	cleaned := stripMarkdownFence(strings.TrimSpace(input))
	cleaned = extractJSONBlock(cleaned)

	escaped := unescapedLatexGenericRegex.ReplaceAllString(cleaned, `$1\\$2`)
	escaped = unescapedLatexGenericRegex.ReplaceAllString(escaped, `$1\\$2`)
	escaped = singleCharCmdRegex.ReplaceAllString(escaped, `$1\\$2{`)
	escaped = normalizeVecRegex.ReplaceAllString(escaped, `\\vec{$1}`)

	escaped = strings.ReplaceAll(escaped, "\x0Dightarrow", `\\rightarrow`)
	escaped = strings.ReplaceAll(escaped, "\x0Aeq ", `\\neq `)
	escaped = strings.ReplaceAll(escaped, "\x0Aeq", `\\neq `)
	escaped = strings.ReplaceAll(escaped, "\x0Deftrightarrow", `\\Leftrightarrow`)
	escaped = strings.ReplaceAll(escaped, "\x0DRightarrow", `\\Rightarrow`)
	return escaped
}

// RepairTruncatedJSON closes unclosed quotes, arrays, and objects using stack tracking.
func RepairTruncatedJSON(input string) string {
	trimmed := strings.TrimSpace(input)
	if trimmed == "" {
		return "{}"
	}

	if hasUnclosedString(trimmed) {
		trimmed += `"`
	}

	stack := collectOpenBrackets(trimmed)
	var closer strings.Builder
	for i := len(stack) - 1; i >= 0; i-- {
		if stack[i] == '{' {
			closer.WriteByte('}')
		} else if stack[i] == '[' {
			closer.WriteByte(']')
		}
	}
	return trimmed + closer.String()
}

// ParseInventory sanitizes, repairs if truncated, and parses a DocumentInventory JSON response.
func ParseInventory(content string) (raw.DocumentInventory, error) {
	cleanJSON := SanitizeRawJSONLaTeX(content)
	var inv raw.DocumentInventory
	if err := json.Unmarshal([]byte(cleanJSON), &inv); err != nil {
		repaired := RepairTruncatedJSON(cleanJSON)
		if errRep := json.Unmarshal([]byte(repaired), &inv); errRep != nil {
			return raw.DocumentInventory{}, fmt.Errorf("unmarshal DocumentInventory: %w", errRep)
		}
	}
	if len(inv.Items) == 0 {
		return raw.DocumentInventory{}, errors.New("DocumentInventory contains no items")
	}
	if inv.TotalItems == 0 {
		inv.TotalItems = len(inv.Items)
	}
	return inv, nil
}

// ParseLessonPlan sanitizes, repairs if truncated, and parses a LessonPlan JSON response.
func ParseLessonPlan(content string, inventory raw.DocumentInventory) (raw.LessonPlan, error) {
	cleanJSON := SanitizeRawJSONLaTeX(content)
	var plan raw.LessonPlan
	if err := json.Unmarshal([]byte(cleanJSON), &plan); err != nil {
		repaired := RepairTruncatedJSON(cleanJSON)
		if errRep := json.Unmarshal([]byte(repaired), &plan); errRep != nil {
			return raw.LessonPlan{}, fmt.Errorf("unmarshal LessonPlan: %w", errRep)
		}
	}
	if len(plan.Topics) == 0 {
		return raw.LessonPlan{}, errors.New("LessonPlan contains no topics")
	}
	if len(inventory.Items) > 0 {
		plan.Inventory = inventory
	}
	return plan, nil
}

func stripMarkdownFence(s string) string {
	if !strings.HasPrefix(s, "```") {
		return s
	}
	if idx := strings.Index(s, "\n"); idx != -1 {
		s = s[idx+1:]
	}
	if idx := strings.LastIndex(s, "```"); idx != -1 {
		s = s[:idx]
	}
	return strings.TrimSpace(s)
}

func extractJSONBlock(s string) string {
	startBrace := strings.Index(s, "{")
	startBracket := strings.Index(s, "[")
	if startBrace != -1 && (startBracket == -1 || startBrace < startBracket) {
		endBrace := strings.LastIndex(s, "}")
		if endBrace > startBrace {
			return s[startBrace : endBrace+1]
		}
	} else if startBracket != -1 {
		endBracket := strings.LastIndex(s, "]")
		if endBracket > startBracket {
			return s[startBracket : endBracket+1]
		}
	}
	return s
}

func hasUnclosedString(s string) bool {
	inString := false
	escaped := false
	for i := range len(s) {
		c := s[i]
		if c == '\\' && inString {
			escaped = !escaped
			continue
		}
		if c == '"' && !escaped {
			inString = !inString
		}
		escaped = false
	}
	return inString
}

func collectOpenBrackets(s string) []rune {
	var stack []rune
	inString := false
	escaped := false
	for _, r := range s {
		if r == '\\' && inString {
			escaped = !escaped
			continue
		}
		if r == '"' && !escaped {
			inString = !inString
		}
		if !inString {
			switch r {
			case '{', '[':
				stack = append(stack, r)
			case '}':
				if len(stack) > 0 && stack[len(stack)-1] == '{' {
					stack = stack[:len(stack)-1]
				}
			case ']':
				if len(stack) > 0 && stack[len(stack)-1] == '[' {
					stack = stack[:len(stack)-1]
				}
			}
		}
		escaped = false
	}
	return stack
}
