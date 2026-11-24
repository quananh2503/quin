package topic

import (
	"encoding/json"
	"errors"
	"fmt"
	"strings"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

const maxQuestionsPerTopic = 12

// ParseTopicContent parses sanitized or raw JSON into raw.TopicContent with planTopic fallbacks.
func ParseTopicContent(content string, planTopic raw.TopicPlan) (raw.TopicContent, error) {
	trimmed := strings.TrimSpace(content)
	if trimmed == "" {
		return raw.TopicContent{}, errors.New("topic content JSON must not be empty")
	}

	var tc raw.TopicContent
	if err := json.Unmarshal([]byte(trimmed), &tc); err != nil {
		repaired := repairJSONBrackets(trimmed)
		if errRep := json.Unmarshal([]byte(repaired), &tc); errRep != nil {
			return raw.TopicContent{}, fmt.Errorf("unmarshal TopicContent: %w", errRep)
		}
	}

	applyPlanFallbacks(&tc, planTopic)
	return tc, nil
}

// VerifyPlan checks plan coverage against inventory items, overloaded topics, and redundant topics.
func VerifyPlan(plan raw.LessonPlan, _ string) raw.AuditReport {
	var report raw.AuditReport
	assigned := make(map[string]bool)

	for i := range plan.Topics {
		tp := &plan.Topics[i]
		for _, qid := range tp.AssignedQuestionIDs {
			assigned[qid] = true
		}
		if len(tp.AssignedQuestionIDs) == 0 {
			report.RedundantTopics = append(report.RedundantTopics, *tp)
		}
		if len(tp.AssignedQuestionIDs) > maxQuestionsPerTopic {
			report.OverloadedTopics = append(report.OverloadedTopics, *tp)
		}
	}

	for _, item := range plan.Inventory.Items {
		if !assigned[item.ID] {
			report.UnassignedIDs = append(report.UnassignedIDs, item.ID)
		}
	}

	report.NeedsRefinement = len(report.UnassignedIDs) > 0 ||
		len(report.OverloadedTopics) > 0 ||
		len(report.RedundantTopics) > 0
	return report
}

// VerifyContent audits authored TopicContent entries for missing theory, variants, or drills.
func VerifyContent(contents []raw.TopicContent, plan raw.LessonPlan) raw.AuditReport {
	var report raw.AuditReport
	if len(contents) == 0 {
		report.NeedsRefinement = true
		return report
	}

	planMap := make(map[string]raw.TopicPlan, len(plan.Topics))
	for i := range plan.Topics {
		planMap[plan.Topics[i].TopicID] = plan.Topics[i]
	}

	for i := range contents {
		tc := &contents[i]
		if isIncompleteTopicContent(tc) {
			tp, ok := planMap[tc.TopicID]
			if !ok {
				tp = raw.TopicPlan{TopicID: tc.TopicID, Title: tc.Title}
			}
			report.RedundantTopics = append(report.RedundantTopics, tp)
			report.NeedsRefinement = true
		}
	}
	return report
}

// FilterTopics filters plan.Topics by selectedIDs (case-insensitive); returns unchanged plan if none match or selectedIDs is empty.
func FilterTopics(plan raw.LessonPlan, selectedIDs []string) raw.LessonPlan {
	if len(selectedIDs) == 0 {
		return plan
	}

	filterMap := make(map[string]bool, len(selectedIDs))
	for _, id := range selectedIDs {
		norm := strings.ToUpper(strings.TrimSpace(id))
		if norm != "" {
			filterMap[norm] = true
		}
	}
	if len(filterMap) == 0 {
		return plan
	}

	var filtered []raw.TopicPlan
	for i := range plan.Topics {
		tp := &plan.Topics[i]
		if filterMap[strings.ToUpper(strings.TrimSpace(tp.TopicID))] {
			filtered = append(filtered, *tp)
		}
	}
	if len(filtered) > 0 {
		plan.Topics = filtered
	}
	return plan
}

func applyPlanFallbacks(tc *raw.TopicContent, planTopic raw.TopicPlan) {
	if strings.TrimSpace(tc.TopicID) == "" {
		tc.TopicID = planTopic.TopicID
	}
	if strings.TrimSpace(tc.Title) == "" {
		tc.Title = planTopic.Title
	}
	if strings.TrimSpace(tc.Difficulty) == "" {
		tc.Difficulty = planTopic.Difficulty
	}
	for vIdx := range tc.Variants {
		if strings.TrimSpace(tc.Variants[vIdx].VariantName) != "" {
			continue
		}
		if vIdx < len(planTopic.Variants) && strings.TrimSpace(planTopic.Variants[vIdx]) != "" {
			tc.Variants[vIdx].VariantName = strings.TrimSpace(planTopic.Variants[vIdx])
		} else {
			tc.Variants[vIdx].VariantName = fmt.Sprintf("Biến thể %d", vIdx+1)
		}
	}
}

func isIncompleteTopicContent(tc *raw.TopicContent) bool {
	if len(tc.TheoryPoints) == 0 {
		return true
	}
	if len(tc.Variants) == 0 && len(tc.Examples) == 0 && len(tc.Drills) == 0 {
		return true
	}
	for i := range tc.Variants {
		if len(tc.Variants[i].Drills) == 0 && len(tc.Drills) == 0 {
			return true
		}
	}
	return false
}

func repairJSONBrackets(s string) string {
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
	if inString {
		s += `"`
	}

	var stack []rune
	inString = false
	escaped = false
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
	var closer strings.Builder
	for i := len(stack) - 1; i >= 0; i-- {
		if stack[i] == '{' {
			closer.WriteByte('}')
		} else if stack[i] == '[' {
			closer.WriteByte(']')
		}
	}
	return s + closer.String()
}
