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
// với chiến lược dự phòng mô hình phân cấp (Cascading Model Fallback Strategy).
//
// Cơ chế vận hành:
//   - Mô hình chính (PrimaryModel, mặc định: "gemini-3.5-flash"): Ưu tiên chạy đầu tiên
//     với khả năng phân tích ranh giới sư phạm hạt mịn, tự động xoay tua qua các API Key
//     trong KeyPool khi gặp 429/503.
//   - Danh sách mô hình dự phòng (FallbackModels, ví dụ: "gemma-4-31b-it", "gemma-4-26b-a4b-it"):
//     Nếu mô hình chính bị quá tải trên toàn bộ các Key, hệ thống tự động chuyển tiếp
//     yêu cầu sang mô hình dự phòng mà không làm gián đoạn pipeline.
//   - Graceful Fallback: Nếu toàn bộ chuỗi mô hình đều không thể phục vụ, hệ thống giữ
//     nguyên kế hoạch gốc ban đầu để đảm bảo an toàn cho bài giảng.
type DefaultPlanPolisherStage struct {
	llm            LLMProvider
	primaryModel   string
	fallbackModels []string
}

var _ PlanPolisherStage = (*DefaultPlanPolisherStage)(nil)

// NewDefaultPlanPolisherStage khởi tạo một PolisherStage với mô hình chính.
func NewDefaultPlanPolisherStage(llm LLMProvider, primaryModel string) *DefaultPlanPolisherStage {
	if primaryModel == "" {
		primaryModel = "gemini-3.5-flash"
	}
	return &DefaultPlanPolisherStage{
		llm:          llm,
		primaryModel: primaryModel,
	}
}

// WithFallback cấu hình chuỗi mô hình dự phòng theo thứ tự ưu tiên (Fluent API).
func (p *DefaultPlanPolisherStage) WithFallback(models ...string) *DefaultPlanPolisherStage {
	p.fallbackModels = append(p.fallbackModels, models...)
	return p
}

// PrimaryModel trả về tên định danh mô hình ưu tiên số 1 của Polisher.
func (p *DefaultPlanPolisherStage) PrimaryModel() string {
	return p.primaryModel
}

// FallbackModels trả về danh sách các mô hình dự phòng theo thứ tự ưu tiên.
func (p *DefaultPlanPolisherStage) FallbackModels() []string {
	return p.fallbackModels
}

// CandidateModels trả về toàn bộ danh sách mô hình ứng viên (PrimaryModel + FallbackModels).
func (p *DefaultPlanPolisherStage) CandidateModels() []string {
	return append([]string{p.primaryModel}, p.fallbackModels...)
}

// BuildPolisherPrompt xây dựng câu lệnh prompt sư phạm chuẩn Domain-Agnostic cho mô hình AI.
func BuildPolisherPrompt(plan *LessonPlan) string {
	if plan == nil {
		return ""
	}
	var topicsBuilder strings.Builder
	for idx, t := range plan.Topics {
		topicsBuilder.WriteString(fmt.Sprintf("%d. [%s] %s\n   - Mức độ: %s | Mục tiêu: %s\n   - Phương pháp cốt lõi: %s\n   - Mã câu hỏi: %v\n",
			idx+1, t.TopicID, t.Title, t.Difficulty, t.TargetOutput, t.CoreConcept, t.AssignedQuestionIDs))
		if len(t.Variants) > 0 {
			topicsBuilder.WriteString(fmt.Sprintf("   - Biến thể: %s\n", strings.Join(t.Variants, "; ")))
		}
	}

	return fmt.Sprintf(`BẠN LÀ: Tổng chủ biên Chuyên môn Sư phạm và Chuyên gia Thiết kế Tiến trình Nhận thức (Instructional Designer).

NHIỆM VỤ: Thẩm định, loại bỏ sự phân mảnh vụn vặt và TÁI CẤU TRÚC lại toàn bộ Danh mục Dạng toán thành một tiến trình bài giảng liền mạch, khoa học theo THUẬT TOÁN SẮP XẾP SƯ PHẠM ĐA TẦNG.
MỤC TIÊU CỐT LÕI: BẢO TOÀN ĐỘ MỊN SƯ PHẠM, KHÔNG NÉN TÓM TẮT BÀI HỌC, và đảm bảo MỖI DẠNG TOÁN TẬP TRUNG CHÍNH XÁC VÀO MỘT ĐƠN VỊ KỸ NĂNG CỐT LÕI (Single-Skill Focus).

DỮ LIỆU ĐẦU VÀO:
- Tiêu đề bài học: "%s"
- Tổng quan bài học: "%s"
- Danh mục các dạng toán hiện tại (%d dạng):
%s

=============================================================================
TRIẾT LÝ SƯ PHẠM: LẤY LÝ THUYẾT VÀ ĐƠN VỊ KỸ NĂNG LÀM KIM CHỈ NAM
=============================================================================
1. ĐỊNH NGHĨA "ĐƠN VỊ KỸ NĂNG CỐT LÕI" (ATOMIC SKILL):
   - Một dạng toán chuẩn mực là dạng toán mà học sinh có thể dùng CÙNG MỘT CÔNG CỤ / CÔNG THỨC LÝ THUYẾT và CÙNG MỘT QUY TRÌNH TƯ DUY để giải quyết toàn bộ các bài tập trong dạng đó.
   - BÀI TEST RANH GIỚI KỸ NĂNG (Skill Boundary Test): 
     Nếu hai nhóm bài tập đòi hỏi hai công thức lý thuyết hoàn toàn khác nhau, hoặc hai thuật toán giải khác nhau -> BẮT BUỘC PHẢI LÀ HAI DẠNG TOÁN ĐỘC LẬP. 
     (Lý do: Để học sinh luyện tập lặp đi lặp lại trên cùng một công thức nhằm khắc sâu phản xạ cơ bắp, không bị phân tâm bởi nhiều công thức trộn lẫn).

2. QUY TẮC PHÂN BIỆT RÕ RÀNG: KHI NÀO ĐƯỢC GOM VÀ KHI NÀO CẤM GỘP
   
   ✅ KHI NÀO ĐƯỢC PHÉP GOM NHÓM (Chỉ gom khi TRÙNG LẶP CÔNG CỤ):
   - Hai hoặc nhiều dạng ban đầu thực chất áp dụng CÙNG MỘT CÔNG THỨC TOÁN HỌC CỐT LÕI và CÙNG MỘT PHƯƠNG PHÁP GIẢI, chỉ khác nhau ở đối tượng áp dụng phụ hoặc câu từ diễn đạt.
   - [Ví dụ tư duy]: Dạng "Tính khoảng cách từ điểm A" và dạng "Tính khoảng cách từ điểm B": bản chất đều dùng chung 1 công thức khoảng cách -> GOM LẠI thành 1 dạng duy nhất và đưa các tình huống vào danh sách "variants". Toàn bộ mã câu hỏi ("assigned_question_ids") được gộp chung lại.

   ❌ KHI NÀO TUYỆT ĐỐI CẤM GỘP (BẮT BUỘC TÁCH RIÊNG ĐỂ GIỮ ĐỘ MỊN):
   - CẤM gộp các bài toán khác nhau về BẬC THANG NHẬN THỨC: Tuyệt đối không gộp dạng [Nhận biết định tính / Đọc hiểu khái niệm] vào chung với dạng [Vận dụng tính toán / Biến đổi đại số nhiều bước].
   - CẤM gộp các bài toán khác nhau về BẢN CHẤT CÔNG CỤ TOÁN HỌC: Tuyệt đối không gộp dạng sử dụng [Quan sát trực quan / Tính chất nội tại ban đầu] vào chung với dạng sử dụng [Hệ quy chiếu ngoại vi / Công cụ giải tích / Thuật toán tính toán nâng cao].
   - CẤM gộp các bài toán [Nội tại toán học thuần túy] vào chung với bài toán [Ứng dụng thực tế đời sống / Mô hình hóa liên môn].
   - [Ví dụ tư duy]: Giống như việc "Nhận biết một đồ vật bằng mắt" và "Cân đo tính toán khối lượng đồ vật": đây là hai năng lực khác nhau, bắt buộc phải là 2 dạng bài riêng biệt.

3. CO GIÃN TỰ NHIÊN THEO DUNG LƯỢNG TÀI LIỆU (KHÔNG ÉP SỐ LƯỢNG CỐ ĐỊNH):
   - Tuyệt đối KHÔNG cố tình nén số lượng dạng toán xuống một con số nhỏ tùy tiện. 
   - Số lượng dạng toán phải phản ánh trung thực mức độ phong phú của tài liệu: Tài liệu càng nhiều công thức và phân môn độc lập, danh mục dạng toán càng phải nở rộng tương ứng để phủ kín 100%% lý thuyết.

=============================================================================
TIẾN TRÌNH SẮP XẾP SƯ PHẠM BẮT BUỘC (COGNITIVE FLOW & ANTI-ZIGZAG)
=============================================================================
Sắp xếp lại toàn bộ các dạng toán sau khi đã phân định ranh giới theo 2 tầng khóa ưu tiên:

1. KHÓA 1 (TIẾN TRÌNH CÔNG CỤ & TIỀN ĐỀ TRI THỨC):
   - NHÓM ĐẦU TIÊN (NỀN TẢNG NỘI TẠI & TRỰC QUAN): Các dạng bài làm quen khái niệm, định nghĩa, tính chất bản chất của đối tượng.
   - NHÓM TIẾP THEO (CÔNG CỤ TÍNH TOÁN & HỆ THỐNG HÓA): Các dạng bài đưa đối tượng vào quy tắc tính toán, công thức giải tích, thuật toán hoặc hệ quy chiếu.
   - NHÓM CUỐI CÙNG (MÔ HÌNH HÓA & ỨNG DỤNG THỰC TẾ): Các bài toán đưa kiến thức toán học vào mô hình thế giới thực hoặc bài toán liên môn.

2. KHÓA 2 (BẬC THANG NHẬN THỨC NỘI BỘ TRONG TỪNG NHÓM CÔNG CỤ):
   Trong cùng một nhóm công cụ, luôn xếp từ mức độ thấp đến cao:
   Nhận biết / Cơ bản -> Vận dụng tính toán tiêu chuẩn -> Biến đổi nâng cao / Tổng hợp.

3. BẢO TOÀN CÂU HỎI VÀ ĐÁNH SỐ:
   - Giữ nguyên vẹn 100%% các mã câu hỏi ("assigned_question_ids").
   - Đánh số lại "topic_id" liên tục theo tiến trình: "dang_1", "dang_2", ..., "dang_N".

Xuất kết quả dưới dạng JSON hợp lệ theo schema với mảng "topics".`,
		plan.LessonTitle, plan.Overview, len(plan.Topics), topicsBuilder.String())
}

// Polish: Tái cấu trúc, khử trùng lặp và sắp xếp lại toàn bộ dạng toán theo tiến trình sư phạm
// với chiến lược dự phòng phân cấp (Cascading Model Fallback):
//  1. Duyệt qua CandidateModels() = [PrimaryModel, FallbackModels...]
//  2. Thử mô hình hiện tại với JSON Schema.
//  3. Nếu thành công và parse JSON hợp lệ: trả về LessonPlan đã được chuẩn hóa.
//  4. Nếu gặp lỗi gọi API hoặc lỗi JSON không thể phục hồi: ghi log cảnh báo và chuyển giao sang mô hình kế tiếp.
//  5. Nếu toàn bộ chuỗi đều thất bại: graceful fallback trả về plan ban đầu.
func (p *DefaultPlanPolisherStage) Polish(ctx context.Context, plan *LessonPlan) (*LessonPlan, error) {
	if plan == nil || len(plan.Topics) == 0 {
		return plan, nil
	}
	if p.llm == nil {
		LogPhase("POLISHER", "LLMProvider nil. Giữ nguyên danh mục dạng toán.")
		return plan, nil
	}

	prompt := BuildPolisherPrompt(plan)
	candidateModels := p.CandidateModels()

	var lastErr error
	for attemptIdx, model := range candidateModels {
		if ctx.Err() != nil {
			return nil, ctx.Err()
		}

		if attemptIdx > 0 {
			LogPhase("POLISHER", "\033[33m[Phase 1.75 Fallback] Mô hình trước gặp sự cố (%v). Đang tự động chuyển giao sang: %s...\033[0m",
				lastErr, model)
		}

		req := LLMRequest{
			ModelName:       model,
			UserPrompt:      prompt,
			Temperature:     0.2,
			MaxOutputTokens: 8192,
			JSONSchema:      GetRefinedTopicsSchemaBytes(),
		}

		resp, err := p.llm.GenerateJSON(ctx, req)
		if err != nil {
			lastErr = err
			continue
		}

		cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.RawJSON))
		var result RefinedTopicsResponse
		if err := json.Unmarshal([]byte(cleanJSON), &result); err != nil {
			repaired := RepairTruncatedJSON(cleanJSON)
			if errRep := json.Unmarshal([]byte(repaired), &result); errRep != nil {
				lastErr = fmt.Errorf("unmarshal JSON thất bại (%w)", errRep)
				continue
			}
		}

		if len(result.Topics) == 0 {
			lastErr = fmt.Errorf("kết quả trả về rỗng topics")
			continue
		}

		// Đảm bảo topic_id luôn được chuẩn hóa dang_1..dang_N
		for i := range result.Topics {
			result.Topics[i].TopicID = fmt.Sprintf("dang_%d", i+1)
		}

		if attemptIdx > 0 {
			LogPhase("POLISHER", "\033[32m[Phase 1.75 Fallback Thành Công] Mô hình dự phòng %s đã hoàn tất sắp xếp sư phạm: %d dạng toán.\033[0m",
				model, len(result.Topics))
		}

		refinedPlan := *plan
		refinedPlan.Topics = result.Topics
		return &refinedPlan, nil
	}

	LogPhase("POLISHER", "Cảnh báo: Toàn bộ candidate models (%v) đều thất bại (%v). Graceful fallback: giữ nguyên plan.",
		candidateModels, lastErr)
	return plan, nil
}
