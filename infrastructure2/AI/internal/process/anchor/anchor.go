package anchor

import (
	"regexp"
	"strconv"
	"strings"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

var (
	reTypFile  = regexp.MustCompile(`\.typ:(\d+)`)
	reLineCol  = regexp.MustCompile(`:(\d+):\d+`)
	reLineOnly = regexp.MustCompile(`(?:at\s+line\s+|line\s+)(\d+)`)
)

// ExtractContextField retrieves the field value addressed by targetID inside TopicContent.
func ExtractContextField(tc raw.TopicContent, targetID string) string {
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
		return extractVariantField(tc.Variants, parts)
	case "ans":
		return extractAnswerField(tc.AnswerKey, parts)
	}
	return ""
}

// SetContextField returns a copy of TopicContent with the field addressed by targetID updated to fixedContent.
func SetContextField(tc raw.TopicContent, targetID string, fixedContent string) raw.TopicContent {
	parts := strings.Split(targetID, "|")
	if len(parts) < 2 {
		return tc
	}

	switch parts[1] {
	case "theory":
		if len(parts) >= 3 {
			if idx, err := strconv.Atoi(parts[2]); err == nil && idx >= 0 && idx < len(tc.TheoryPoints) {
				copied := append([]string(nil), tc.TheoryPoints...)
				copied[idx] = fixedContent
				tc.TheoryPoints = copied
			}
		}
	case "cloze":
		tc.ClozeFormula = fixedContent
	case "callout":
		tc.CalloutTip = fixedContent
	case "v":
		tc.Variants = setVariantField(tc.Variants, parts, fixedContent)
	case "ans":
		tc.AnswerKey = setAnswerField(tc.AnswerKey, parts, fixedContent)
	}
	return tc
}

// ExtractCompilerErrorAnchors maps Typst compiler stderr line numbers to @ANCHOR RepairTasks.
func ExtractCompilerErrorAnchors(markup string, compilerStderr string, tc raw.TopicContent) []raw.RepairTask {
	lines := strings.Split(markup, "\n")
	seen := make(map[string]bool)
	var tasks []raw.RepairTask

	for _, line := range strings.Split(compilerStderr, "\n") {
		lineNum := extractLineNum(line)
		if lineNum <= 0 {
			continue
		}
		anchorID := FindNearestAnchor(lines, lineNum)
		if anchorID == "" || seen[anchorID] {
			continue
		}
		seen[anchorID] = true
		content := ExtractContextField(tc, anchorID)
		tasks = append(tasks, raw.RepairTask{
			TargetID:      anchorID,
			ErrorReason:   "Lỗi biên dịch Typst",
			BrokenSnippet: content,
			Context:       anchorID,
			Content:       content,
		})
	}
	return tasks
}

// FindNearestAnchor scans backwards from errLine (1-based) to find the closest // @ANCHOR: tag.
func FindNearestAnchor(lines []string, errLine int) string {
	if errLine <= 0 || len(lines) == 0 {
		return ""
	}
	startIdx := errLine - 1
	if startIdx >= len(lines) {
		startIdx = len(lines) - 1
	}
	for i := startIdx; i >= 0; i-- {
		trimmed := strings.TrimSpace(lines[i])
		if strings.HasPrefix(trimmed, "// @ANCHOR:") {
			return strings.TrimSpace(strings.TrimPrefix(trimmed, "// @ANCHOR:"))
		}
	}
	return ""
}

func extractLineNum(line string) int {
	for _, re := range []*regexp.Regexp{reTypFile, reLineCol, reLineOnly} {
		if m := re.FindStringSubmatch(line); len(m) > 1 {
			if n, err := strconv.Atoi(m[1]); err == nil && n > 0 {
				return n
			}
		}
	}
	return 0
}

func extractVariantField(variants []raw.VariantGuide, parts []string) string {
	if len(parts) < 4 {
		return ""
	}
	vIdx, errV := strconv.Atoi(parts[2])
	if errV != nil || vIdx < 0 || vIdx >= len(variants) {
		return ""
	}
	v := variants[vIdx]
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
			if dIdx, errD := strconv.Atoi(parts[4]); errD == nil && dIdx >= 0 && dIdx < len(v.Drills) {
				if parts[5] == "prompt" {
					return v.Drills[dIdx].Prompt
				}
				if parts[5] == "sol" {
					return v.Drills[dIdx].Solution
				}
			}
		}
	}
	return ""
}

func extractAnswerField(answers []raw.AnswerItem, parts []string) string {
	if len(parts) < 4 {
		return ""
	}
	aIdx, errA := strconv.Atoi(parts[2])
	if errA != nil || aIdx < 0 || aIdx >= len(answers) {
		return ""
	}
	switch parts[3] {
	case "guide":
		return answers[aIdx].ShortGuide
	case "final":
		return answers[aIdx].FinalAnswer
	}
	return ""
}

func setVariantField(variants []raw.VariantGuide, parts []string, fixedContent string) []raw.VariantGuide {
	if len(parts) < 4 {
		return variants
	}
	vIdx, errV := strconv.Atoi(parts[2])
	if errV != nil || vIdx < 0 || vIdx >= len(variants) {
		return variants
	}

	copied := append([]raw.VariantGuide(nil), variants...)
	v := &copied[vIdx]
	switch parts[3] {
	case "rec":
		v.Recognition = fixedContent
	case "step":
		if len(parts) >= 5 {
			if sIdx, errS := strconv.Atoi(parts[4]); errS == nil && sIdx >= 0 && sIdx < len(v.ActionSteps) {
				steps := append([]string(nil), v.ActionSteps...)
				steps[sIdx] = fixedContent
				v.ActionSteps = steps
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
			if dIdx, errD := strconv.Atoi(parts[4]); errD == nil && dIdx >= 0 && dIdx < len(v.Drills) {
				drills := append([]raw.DrillExercise(nil), v.Drills...)
				if parts[5] == "prompt" {
					drills[dIdx].Prompt = fixedContent
				} else if parts[5] == "sol" {
					drills[dIdx].Solution = fixedContent
				}
				v.Drills = drills
			}
		}
	}
	return copied
}

func setAnswerField(answers []raw.AnswerItem, parts []string, fixedContent string) []raw.AnswerItem {
	if len(parts) < 4 {
		return answers
	}
	aIdx, errA := strconv.Atoi(parts[2])
	if errA != nil || aIdx < 0 || aIdx >= len(answers) {
		return answers
	}
	copied := append([]raw.AnswerItem(nil), answers...)
	switch parts[3] {
	case "guide":
		copied[aIdx].ShortGuide = fixedContent
	case "final":
		copied[aIdx].FinalAnswer = fixedContent
	}
	return copied
}
