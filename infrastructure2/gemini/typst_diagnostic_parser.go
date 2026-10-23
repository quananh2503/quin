package gemini

import (
	"context"
	"regexp"
	"strconv"
	"strings"
)

var (
	reTypFile   = regexp.MustCompile(`\.typ:(\d+)`)
	reLineCol   = regexp.MustCompile(`:(\d+):\d+`)
	reLineOnly  = regexp.MustCompile(`(?:at\s+line\s+|line\s+)(\d+)`)
	reAtTypPath = regexp.MustCompile(`\s+at\s+.*\.typ:\d+.*`)
	reMitexMath = regexp.MustCompile("mi\\(`([^`]+)`\\)|mi\\(\"([^\"]+)\"\\)|mi\\(([^)]+)\\)")
	reCodeLine  = regexp.MustCompile(`^\s*\d+\s*│\s*(.*)$`)
)

// ParseTypstDiagnostics lọc sạch warnings và bóc tách các lỗi trọng tâm từ Typst stderr.
func ParseTypstDiagnostics(stderr string) []TypstDiagnostic {
	var diags []TypstDiagnostic
	var currentBlock []string
	inError := false

	flushBlock := func() {
		if inError && len(currentBlock) > 0 {
			if diag, ok := parseSingleErrorBlock(currentBlock); ok {
				diags = append(diags, diag)
			}
		}
		currentBlock = nil
	}

	for _, rawLine := range strings.Split(stderr, "\n") {
		trimmed := strings.TrimSpace(rawLine)
		if strings.HasPrefix(trimmed, "error:") {
			flushBlock()
			inError = true
			currentBlock = append(currentBlock, rawLine)
		} else if strings.HasPrefix(trimmed, "warning:") {
			flushBlock()
			inError = false
		} else if inError {
			currentBlock = append(currentBlock, rawLine)
		}
	}
	flushBlock()
	return diags
}

// parseSingleErrorBlock trích xuất LineNumber, ErrorReason và BrokenSnippet từ 1 khối lỗi.
func parseSingleErrorBlock(block []string) (TypstDiagnostic, bool) {
	if len(block) == 0 {
		return TypstDiagnostic{}, false
	}
	header := block[0]
	idx := strings.LastIndex(header, "error:")
	reason := header
	if idx != -1 {
		reason = strings.TrimSpace(header[idx+len("error:"):])
	}
	reason = strings.TrimSpace(reAtTypPath.ReplaceAllString(reason, ""))

	var lineNum int
	for _, l := range block {
		if !strings.Contains(l, "@preview/") {
			if num := extractLineNum(l); num > 0 {
				lineNum = num
				break
			}
		}
	}
	if lineNum == 0 {
		for _, l := range block {
			if num := extractLineNum(l); num > 0 {
				lineNum = num
				break
			}
		}
	}

	var brokenSnippet string
	for _, l := range block {
		if m := reMitexMath.FindStringSubmatch(l); len(m) > 0 {
			for i := 1; i < len(m); i++ {
				if m[i] != "" {
					brokenSnippet = strings.TrimSpace(m[i])
					break
				}
			}
			if brokenSnippet != "" {
				break
			}
		}
	}
	if brokenSnippet == "" {
		for _, l := range block {
			if strings.Contains(l, "@preview/") || strings.Contains(l, "mitex-wasm") {
				continue
			}
			if m := reCodeLine.FindStringSubmatch(l); len(m) > 1 {
				brokenSnippet = strings.TrimSpace(m[1])
				break
			}
		}
	}

	return TypstDiagnostic{
		LineNumber:    lineNum,
		ErrorReason:   reason,
		BrokenSnippet: brokenSnippet,
	}, true
}

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

// ScanAllTypstErrors quét lặp tối đa 10 lần bằng cách comment cách ly các dòng lỗi để tìm toàn bộ lỗi trên file Typst.
func ScanAllTypstErrors(ctx context.Context, compiler TypstCompiler, markup string, opts CompileOptions) []TypstDiagnostic {
	if compiler == nil {
		return nil
	}
	var allDiags []TypstDiagnostic
	seenLines := make(map[int]bool)
	currentMarkup := markup

	for attempt := 0; attempt < 10; attempt++ {
		res, err := compiler.Compile(ctx, currentMarkup, opts)
		if err == nil && res != nil && res.Success {
			break
		}
		var diags []TypstDiagnostic
		if res != nil && res.RawStderr != "" {
			diags = ParseTypstDiagnostics(res.RawStderr)
		}
		if len(diags) == 0 && res != nil && len(res.ErrorLines) > 0 {
			for _, lineNum := range res.ErrorLines {
				diags = append(diags, TypstDiagnostic{
					LineNumber:  lineNum,
					ErrorReason: "Typst compiler syntax error",
				})
			}
		}
		if len(diags) == 0 {
			break
		}

		newDiagFound := false
		lines := strings.Split(currentMarkup, "\n")
		for _, d := range diags {
			if d.LineNumber > 0 && !seenLines[d.LineNumber] {
				seenLines[d.LineNumber] = true
				allDiags = append(allDiags, d)
				newDiagFound = true

				lineIdx := d.LineNumber - 1
				if lineIdx >= 0 && lineIdx < len(lines) {
					lines[lineIdx] = "// [ISOLATED] " + lines[lineIdx]
				}
			}
		}
		if !newDiagFound {
			break
		}
		currentMarkup = strings.Join(lines, "\n")
	}
	return allDiags
}
