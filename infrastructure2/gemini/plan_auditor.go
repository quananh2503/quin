package gemini

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

// =============================================================================
// PLAN AUDITOR: KIỂM ĐỊNH ĐỘ BAO PHỦ VÀ BẤT THƯỜNG TRÊN LESSON PLAN
// =============================================================================

var questionSeqRegex = regexp.MustCompile(`^([a-zA-Z]+)(\d+)$`)

// DefaultPlanAuditor thực thi kiểm tra tính toàn vẹn của LessonPlan
type DefaultPlanAuditor struct{}

var _ PlanAuditor = (*DefaultPlanAuditor)(nil)

// NewDefaultPlanAuditor khởi tạo auditor mặc định
func NewDefaultPlanAuditor() *DefaultPlanAuditor {
	return &DefaultPlanAuditor{}
}

// Audit kiểm định danh mục câu hỏi, phát hiện câu bị bỏ sót, gộp quá tải hoặc trùng lặp
func (a *DefaultPlanAuditor) Audit(plan *LessonPlan) AuditReport {
	if plan == nil || (len(plan.Topics) == 0 && len(plan.QuestionCatalog) == 0) {
		return AuditReport{}
	}

	assignedSet := make(map[string]bool)
	for _, top := range plan.Topics {
		for _, qid := range top.AssignedQuestionIDs {
			trimmed := strings.TrimSpace(qid)
			if trimmed != "" {
				assignedSet[trimmed] = true
			}
		}
	}

	unassignedMap := make(map[string]bool)
	var unassignedIDs []string

	addUnassigned := func(id string) {
		if !unassignedMap[id] && !assignedSet[id] {
			unassignedMap[id] = true
			unassignedIDs = append(unassignedIDs, id)
		}
	}

	// 1. Kiểm tra câu hỏi trong QuestionCatalog chưa được gán vào bất kỳ Topic nào
	for _, cat := range plan.QuestionCatalog {
		for _, qid := range cat.QuestionIDs {
			trimmed := strings.TrimSpace(qid)
			if trimmed != "" && !assignedSet[trimmed] {
				addUnassigned(trimmed)
			}
		}
	}

	// 2. Bóc tách tiền tố số tự nhiên để phát hiện lỗ hổng dãy số (VD: C1, C4 -> thiếu C2, C3)
	type numRange struct {
		min int
		max int
	}
	prefixRanges := make(map[string]*numRange)

	recordID := func(id string) {
		matches := questionSeqRegex.FindStringSubmatch(id)
		if len(matches) == 3 {
			prefix := matches[1]
			num, err := strconv.Atoi(matches[2])
			if err != nil {
				return
			}
			nr, exists := prefixRanges[prefix]
			if !exists {
				prefixRanges[prefix] = &numRange{min: num, max: num}
			} else {
				if num < nr.min {
					nr.min = num
				}
				if num > nr.max {
					nr.max = num
				}
			}
		}
	}

	for id := range assignedSet {
		recordID(id)
	}
	for _, cat := range plan.QuestionCatalog {
		for _, qid := range cat.QuestionIDs {
			recordID(strings.TrimSpace(qid))
		}
	}

	for prefix, nr := range prefixRanges {
		if nr.max-nr.min <= 200 {
			for i := nr.min; i <= nr.max; i++ {
				id := fmt.Sprintf("%s%d", prefix, i)
				if !assignedSet[id] {
					addUnassigned(id)
				}
			}
		}
	}

	// 3. Phát hiện Topic bị gom gộp quá tải (> 10 câu hỏi)
	var overloadedTopics []Topic
	for _, top := range plan.Topics {
		if len(top.AssignedQuestionIDs) > 10 {
			overloadedTopics = append(overloadedTopics, top)
		}
	}

	// 4. Phát hiện Topic bị trùng lặp tiêu đề
	var redundantTopics []Topic
	seenTitles := make(map[string]bool)
	for _, top := range plan.Topics {
		title := strings.TrimSpace(top.Title)
		if title == "" {
			continue
		}
		if seenTitles[title] {
			redundantTopics = append(redundantTopics, top)
		} else {
			seenTitles[title] = true
		}
	}

	needsRefinement := len(unassignedIDs) > 0 || len(overloadedTopics) > 0 || len(redundantTopics) > 0

	return AuditReport{
		UnassignedIDs:    unassignedIDs,
		OverloadedTopics: overloadedTopics,
		RedundantTopics:  redundantTopics,
		NeedsRefinement:  needsRefinement,
	}
}
