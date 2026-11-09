package pipeline

import (
	"regexp"
	"strings"
)

var (
	// Bắt MỌI dấu backslash đơn (\) đứng trước từ khóa LaTeX (từ 2 chữ cái trở lên)
	unescapedLatexGenericRegex = regexp.MustCompile(`(^|[^\\])\\([a-zA-Z]{2,})`)

	// Xử lý bảo vệ các lệnh LaTeX 1 chữ cái nếu có đứng trước ngoặc nhọn (như \d{x}, \b{x})
	singleCharCmdRegex = regexp.MustCompile(`(^|[^\\])\\([a-zA-Z])\{`)

	// Chuẩn hóa \overline{AB} hoặc \overrightarrow{AB} về \vec{AB}
	normalizeVecRegex = regexp.MustCompile(`\\\\(?:overline|overrightarrow)\{([A-Z][']?[A-Z][']?)\}`)
)

// SanitizeRawJSONLaTeX làm sạch markdown fence và bảo vệ các lệnh LaTeX không bị Go JSON parser nuốt thành mã điều khiển.
func SanitizeRawJSONLaTeX(raw string) string {
	raw = strings.TrimSpace(raw)
	if strings.HasPrefix(raw, "```") {
		if idx := strings.Index(raw, "\n"); idx != -1 {
			raw = raw[idx+1:]
		}
		if idx := strings.LastIndex(raw, "```"); idx != -1 {
			raw = raw[:idx]
		}
		raw = strings.TrimSpace(raw)
	}

	// Trích xuất chính xác khối JSON nằm giữa cặp ngoặc { ... } hoặc [ ... ]
	startBrace := strings.Index(raw, "{")
	startBracket := strings.Index(raw, "[")
	if startBrace != -1 && (startBracket == -1 || startBrace < startBracket) {
		endBrace := strings.LastIndex(raw, "}")
		if endBrace > startBrace {
			raw = raw[startBrace : endBrace+1]
		}
	} else if startBracket != -1 {
		endBracket := strings.LastIndex(raw, "]")
		if endBracket > startBracket {
			raw = raw[startBracket : endBracket+1]
		}
	}

	// Chạy 2 lần liên tiếp để xử lý cả trường hợp 2 lệnh sát nhau
	escaped := unescapedLatexGenericRegex.ReplaceAllString(raw, `$1\\$2`)
	escaped = unescapedLatexGenericRegex.ReplaceAllString(escaped, `$1\\$2`)

	escaped = singleCharCmdRegex.ReplaceAllString(escaped, `$1\\$2{`)
	escaped = normalizeVecRegex.ReplaceAllString(escaped, `\\vec{$1}`)

	// Khắc phục lỗi JSON nuốt mất backslash thành mã điều khiển ASCII
	escaped = strings.ReplaceAll(escaped, "\x0Dightarrow", `\\rightarrow`)
	escaped = strings.ReplaceAll(escaped, "\x0Aeq ", `\\neq `)
	escaped = strings.ReplaceAll(escaped, "\x0Aeq", `\\neq `)
	escaped = strings.ReplaceAll(escaped, "\x0Deftrightarrow", `\\Leftrightarrow`)
	escaped = strings.ReplaceAll(escaped, "\x0DRightarrow", `\\Rightarrow`)

	return escaped
}

// RepairTruncatedJSON tự động đóng ngoặc theo cơ chế Stack để hoàn chỉnh chuỗi JSON bị ngắt cụt do chạm trần token.
func RepairTruncatedJSON(raw string) string {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return "{}"
	}

	inString := false
	var escaped bool

	for i := 0; i < len(raw); i++ {
		c := raw[i]
		if c == '\\' && inString {
			escaped = !escaped
			continue
		}
		if c == '"' && !escaped {
			inString = !inString
		}
		escaped = false
	}

	if inString {
		raw += `"`
	}

	var stack []rune
	inString = false
	escaped = false

	for _, r := range raw {
		if r == '\\' && inString {
			escaped = !escaped
			continue
		}
		if r == '"' && !escaped {
			inString = !inString
		}
		if !inString {
			if r == '{' || r == '[' {
				stack = append(stack, r)
			} else if r == '}' {
				if len(stack) > 0 && stack[len(stack)-1] == '{' {
					stack = stack[:len(stack)-1]
				}
			} else if r == ']' {
				if len(stack) > 0 && stack[len(stack)-1] == '[' {
					stack = stack[:len(stack)-1]
				}
			}
		}
		escaped = false
	}

	var closer strings.Builder
	for i := len(stack) - 1; i >= 0; i-- {
		if stack[i] == '{' {
			closer.WriteString("}")
		} else if stack[i] == '[' {
			closer.WriteString("]")
		}
	}

	return raw + closer.String()
}
