package gemini

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
)

// =============================================================================
// STAGE 1.5: PLAN REVIEWER STAGE (THẨM ĐỊNH VÀ TINH CHỈNH DANH MỤC DẠNG TOÁN)
// =============================================================================

// DefaultPlanReviewerStage thực thi kiểm tra và tinh chỉnh LessonPlan qua PlanAuditor & LLM
type DefaultPlanReviewerStage struct {
	llm       LLMProvider
	auditor   PlanAuditor
	modelName string
}

var _ PlanReviewerStage = (*DefaultPlanReviewerStage)(nil)

// NewDefaultPlanReviewerStage khởi tạo reviewer stage
func NewDefaultPlanReviewerStage(llm LLMProvider, auditor PlanAuditor, modelName string) *DefaultPlanReviewerStage {
	return &DefaultPlanReviewerStage{
		llm:       llm,
		auditor:   auditor,
		modelName: modelName,
	}
}

// Review thẩm định và bổ sung, tách dạng nếu auditor phát hiện thiếu sót
func (r *DefaultPlanReviewerStage) Review(ctx context.Context, plan *LessonPlan, docs []DocumentInput) (*LessonPlan, error) {
	if plan == nil || r.auditor == nil {
		return plan, nil
	}

	report := r.auditor.Audit(plan)
	if !report.NeedsRefinement {
		return plan, nil
	}

	if r.llm == nil {
		LogPhase("REVIEWER", "Auditor phát hiện cần tinh chỉnh nhưng LLMProvider nil. Giữ nguyên plan.")
		return plan, nil
	}

	prompt := fmt.Sprintf(`BẠN LÀ: Chuyên gia Sư phạm Toán học THPT và Thiết kế Giáo án chuẩn GDPT 2018.

KẾT QUẢ KIỂM ĐỊNH GIÁO ÁN PHÁT HIỆN CÁC VẤN ĐỀ SAU:
- Các câu hỏi chưa được phân dạng: %v
- Các dạng toán bị gom gộp quá tải (> 10 câu): %s
- Các dạng toán bị trùng lặp tiêu đề: %s

NHIỆM VỤ:
1. Phân tích các câu hỏi chưa được phân dạng và dạng bị quá tải để tạo thêm các Dạng toán mới (additional_topics).
2. Tách nhỏ dạng bị quá tải thành các dạng đơn mục tiêu (TargetOutput cụ thể, tối đa 8-10 câu).
3. Đảm bảo mọi câu hỏi bị sót đều được phân vào dạng toán phù hợp.
4. Trả về đúng JSON theo schema DeltaTopicResponse.`,
		report.UnassignedIDs,
		summarizeTopics(report.OverloadedTopics),
		summarizeTopics(report.RedundantTopics),
	)

	req := LLMRequest{
		ModelName:       r.modelName,
		UserPrompt:      prompt,
		Documents:       docs,
		Temperature:     0.2,
		MaxOutputTokens: 8192,
		JSONSchema:      GetDeltaPlannerSchemaBytes(),
	}

	resp, err := r.llm.GenerateJSON(ctx, req)
	if err != nil {
		LogPhase("REVIEWER", "Cảnh báo: LLM GenerateJSON thất bại (%v). Graceful fallback: giữ nguyên plan.", err)
		return plan, nil
	}

	cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.RawJSON))
	var delta DeltaTopicResponse
	if err := json.Unmarshal([]byte(cleanJSON), &delta); err != nil {
		repaired := RepairTruncatedJSON(cleanJSON)
		if errRep := json.Unmarshal([]byte(repaired), &delta); errRep != nil {
			LogPhase("REVIEWER", "Cảnh báo: Unmarshal DeltaTopicResponse thất bại (%v). Graceful fallback: giữ nguyên plan.", errRep)
			return plan, nil
		}
	}

	// Loại bỏ các dạng cũ bị quá tải hoặc trùng lặp
	discarded := make(map[string]bool)
	for _, t := range report.OverloadedTopics {
		discarded[t.TopicID] = true
	}
	for _, t := range report.RedundantTopics {
		discarded[t.TopicID] = true
	}

	var finalTopics []Topic
	for _, t := range plan.Topics {
		if !discarded[t.TopicID] {
			finalTopics = append(finalTopics, t)
		}
	}

	// Bổ sung các additional topics từ delta
	finalTopics = append(finalTopics, delta.AdditionalTopics...)

	// Đánh số lại TopicID theo thứ tự dang_1..dang_N
	for i := range finalTopics {
		finalTopics[i].TopicID = fmt.Sprintf("dang_%d", i+1)
	}

	refinedPlan := *plan
	refinedPlan.Topics = finalTopics
	return &refinedPlan, nil
}

func summarizeTopics(topics []Topic) string {
	if len(topics) == 0 {
		return "Không có"
	}
	var items []string
	for _, t := range topics {
		items = append(items, fmt.Sprintf("[%s] %s (%d câu)", t.TopicID, t.Title, len(t.AssignedQuestionIDs)))
	}
	return strings.Join(items, ", ")
}
