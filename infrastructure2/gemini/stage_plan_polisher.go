package gemini

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
)

// =============================================================================
// STAGE 1.75: PLAN POLISHER STAGE (CHUỐT LẠI, KHỬ TRÙNG LẶP VÀ SẮP XẾP SƯ PHẠM)
// =============================================================================

// DefaultPlanPolisherStage tái cấu trúc sư phạm toàn diện trên danh mục dạng toán
type DefaultPlanPolisherStage struct {
	llm       LLMProvider
	modelName string
}

var _ PlanPolisherStage = (*DefaultPlanPolisherStage)(nil)

// NewDefaultPlanPolisherStage khởi tạo polisher stage
func NewDefaultPlanPolisherStage(llm LLMProvider, modelName string) *DefaultPlanPolisherStage {
	if modelName == "" {
		modelName = "gemini-3.5-flash-lite"
	}
	return &DefaultPlanPolisherStage{
		llm:       llm,
		modelName: modelName,
	}
}

// Polish: Tái cấu trúc, khử trùng lặp và sắp xếp lại toàn bộ dạng toán theo tiến trình sư phạm
func (p *DefaultPlanPolisherStage) Polish(ctx context.Context, plan *LessonPlan) (*LessonPlan, error) {
	if plan == nil || len(plan.Topics) == 0 {
		return plan, nil
	}
	if p.llm == nil {
		LogPhase("POLISHER", "LLMProvider nil. Giữ nguyên danh mục dạng toán.")
		return plan, nil
	}

	var topicsBuilder strings.Builder
	for idx, t := range plan.Topics {
		topicsBuilder.WriteString(fmt.Sprintf("%d. [%s] %s\n   - Mức độ: %s | Mục tiêu: %s\n   - Phương pháp cốt lõi: %s\n   - Mã câu hỏi: %v\n",
			idx+1, t.TopicID, t.Title, t.Difficulty, t.TargetOutput, t.CoreConcept, t.AssignedQuestionIDs))
		if len(t.Variants) > 0 {
			topicsBuilder.WriteString(fmt.Sprintf("   - Biến thể: %s\n", strings.Join(t.Variants, "; ")))
		}
	}

	prompt := fmt.Sprintf(`BẠN LÀ: Tổng chủ biên Sư phạm Chương trình Giáo dục Phổ thông.

NHIỆM VỤ: Thẩm định, khử trùng lặp và TÁI CẤU TRÚC lại toàn bộ Danh mục Dạng toán thành một tiến trình bài giảng liền mạch, khoa học theo THUẬT TOÁN SẮP XẾP 2 TẦNG SƯ PHẠM (2-TIER PEDAGOGICAL SORTING).

DỮ LIỆU ĐẦU VÀO:
- Tiêu đề bài học: "%s"
- Tổng quan: "%s"
- Danh mục các dạng toán hiện tại (%d dạng):
%s

THUẬT TOÁN SẮP XẾP 2 TẦNG BẮT BUỘC (DOMAIN-AGNOSTIC & ANTI-ZIGZAG):
Quy tắc sắp xếp theo thứ tự từ điển với 2 khóa ưu tiên (Lexicographical 2-Tier Order):

1. KHÓA 1 (PRIMARY KEY - MẠCH CÔNG CỤ & TIỀN ĐỀ TRI THỨC):
   Toàn bộ các dạng toán phải được phân vào 3 tầng mạch công cụ theo thứ tự trước sau:
   - TẦNG A (NỀN TẢNG NỘI TẠI & TRỰC QUAN THUẦN TÚY - BẮT BUỘC ĐỨNG ĐẦU):
     Các dạng toán về định nghĩa, tính chất bản chất, quan sát trực quan, phép toán nội tại của đối tượng mà CHƯA cần gắn vào hệ quy chiếu ngoại vi hay công cụ giải tích/tọa độ.
   - TẦNG B (ĐẠI SỐ HÓA, HỆ QUY CHIẾU & GIẢI TÍCH - TIẾP THEO):
     Các dạng toán chuyển hóa đối tượng sang hệ tọa độ, biểu diễn giải tích, mô hình phương trình/hệ phương trình hoặc các quy tắc thuật toán tính toán cụ thể.
   - TẦNG C (MÔ HÌNH HÓA THỰC TẾ & TỔNG HỢP LIÊN MÔN - BẮT BUỘC ĐỨNG CUỐI):
     Các bài toán vận dụng kiến thức đã học vào thực tiễn đời sống, mô hình hóa thế giới thực hoặc bài toán liên môn.

2. KHÓA 2 (SECONDARY KEY - BẬC THANG NHẬN THỨC NỘI BỘ TRONG TỪNG TẦNG):
   Bên trong cùng một Tầng (A, B hoặc C), các dạng toán BẮT BUỘC được xếp theo mức độ tư duy tăng dần:
   - Nhận diện / Cơ bản -> Quy tắc tính toán chuẩn mực -> Biến đổi / Kỹ năng chuyên sâu.

3. NGUYÊN TẮC BẮT BUỘC KHỬ ZIGZAG (ANTI-PEDAGOGICAL-ZIGZAG):
   - TUYỆT ĐỐI KHÔNG xếp đan xen giữa Tầng A và Tầng B (ví dụ: đang học công cụ trực quan Tầng A thì không được nhảy sang công cụ tọa độ Tầng B rồi lại giật ngược về Tầng A).
   - Học sinh phải học trọn vẹn mạch công cụ bản chất trước khi sang mạch công cụ đại số hóa.

4. KHỬ TRÙNG LẶP & GOM NHÓM ĐỒNG NHẤT:
   - Nếu có 2 hay nhiều dạng có cùng mục tiêu hoặc cùng phương pháp giải cốt lõi, BẮT BUỘC gom lại thành 1 dạng duy nhất và đưa các khía cạnh nhỏ vào danh sách "variants". Tuyệt đối không để trùng lặp tiêu đề.
   - Giữ nguyên vẹn toàn bộ mã câu hỏi ("assigned_question_ids").
   - Đánh số lại "topic_id" liên tục: "dang_1", "dang_2", ..., "dang_N".

Xuất kết quả dưới dạng JSON hợp lệ theo schema với mảng "topics".`,
		plan.LessonTitle, plan.Overview, len(plan.Topics), topicsBuilder.String())

	req := LLMRequest{
		ModelName:       p.modelName,
		UserPrompt:      prompt,
		Temperature:     0.2,
		MaxOutputTokens: 8192,
		JSONSchema:      GetRefinedTopicsSchemaBytes(),
	}

	resp, err := p.llm.GenerateJSON(ctx, req)
	if err != nil {
		LogPhase("POLISHER", "Cảnh báo: LLM GenerateJSON thất bại (%v). Graceful fallback: giữ nguyên plan.", err)
		return plan, nil
	}

	cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.RawJSON))
	var result RefinedTopicsResponse
	if err := json.Unmarshal([]byte(cleanJSON), &result); err != nil {
		repaired := RepairTruncatedJSON(cleanJSON)
		if errRep := json.Unmarshal([]byte(repaired), &result); errRep != nil {
			LogPhase("POLISHER", "Cảnh báo: Unmarshal RefinedTopicsResponse thất bại (%v). Graceful fallback: giữ nguyên plan.", errRep)
			return plan, nil
		}
	}

	if len(result.Topics) == 0 {
		return plan, nil
	}

	// Đảm bảo topic_id luôn được chuẩn hóa dang_1..dang_N
	for i := range result.Topics {
		result.Topics[i].TopicID = fmt.Sprintf("dang_%d", i+1)
	}

	refinedPlan := *plan
	refinedPlan.Topics = result.Topics
	return &refinedPlan, nil
}
