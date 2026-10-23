package gemini

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
)

// =============================================================================
// STAGE 1: PLANNER STAGE (PHÂN TÍCH ĐA TÀI LIỆU & PHÂN DẠNG HẠT MỊN)
// =============================================================================

// PlannerStage: Giai đoạn 1 - Phân tích tài liệu PDF/Text và chia dạng bài tập hạt mịn
type PlannerStage interface {
	Plan(ctx context.Context, docs []DocumentInput, customPrompt string) (*LessonPlan, error)
}

// DefaultPlannerStage thực thi Giai đoạn 1: Lập kế hoạch bài học
type DefaultPlannerStage struct {
	llm       LLMProvider
	modelName string
}

// NewDefaultPlannerStage khởi tạo PlannerStage với LLMProvider bất kỳ (Gemini hoặc DeepSeek)
func NewDefaultPlannerStage(llm LLMProvider, modelName string) *DefaultPlannerStage {
	return &DefaultPlannerStage{
		llm:       llm,
		modelName: modelName,
	}
}

// Plan: Phân tích các tài liệu học tập đầu vào và sinh ra LessonPlan có cấu trúc.
func (p *DefaultPlannerStage) Plan(ctx context.Context, docs []DocumentInput, customPrompt string) (*LessonPlan, error) {
	if p.llm == nil {
		return nil, fmt.Errorf("chưa cấu hình LLMProvider cho PlannerStage")
	}

	prompt := fmt.Sprintf(`BẠN LÀ: Chuyên gia Sư phạm Toán học THPT và Thiết kế Giáo án theo Chương trình GDPT 2018.

NHIỆM VỤ: Phân tích %d tài liệu học tập đính kèm theo phương pháp BOTTOM-UP để lập danh mục ĐẦY ĐỦ TẤT CẢ CÁC DẠNG TOÁN chuyên sâu.

QUY TẮC BẮT BUỘC ĐỂ KHÔNG BỎ SÓT DẠNG TOÁN:
1. QUÉT HẠT MỊN TỪ BÀI TẬP VÀO "question_catalog":
   - Quét lần lượt: Ví dụ (VD1..), Trắc nghiệm (C1..), Đúng/Sai (D1..), Trả lời ngắn/Tự luận (E1..).
   - Gom các câu cùng mục tiêu vào từng cụm (3-8 câu/cụm). CẤM viết tắt dải kiểu C1..C56.
2. TIÊU CHÍ TÁCH DẠNG CHUYÊN SÂU (ANTI-LUMPING RULES):
   - KHÁC ĐÍCH ĐẾN ("target_output") HOẶC KHÁC PHƯƠNG PHÁP ("core_method") BẮT BUỘC PHẢI TÁCH DẠNG RIÊNG:
     + Khác công cụ/định lý lý thuyết cốt lõi hoặc khác quy trình tư duy giải quyết BẮT BUỘC TÁCH DẠNG RIÊNG.
     + Các bài toán vận dụng thực tế đời sống hoặc liên môn (mô hình hóa thực tiễn) BẮT BUỘC TÁCH THÀNH DẠNG RIÊNG.
   - CHỐNG GOM GỘP QUÁ TẢI (ĐƠN KỸ NĂNG - ATOMIC SKILL):
     + Mỗi dạng toán phải tập trung vào đúng một kỹ năng cốt lõi. Không dồn nhiều công thức độc lập vào cùng một dạng.
   - BAO PHỦ VÉT CẠN: Toàn bộ câu hỏi trong tài liệu đều phải xuất hiện trong assigned_question_ids.

Yêu cầu riêng của giáo viên: %s`, len(docs), strings.TrimSpace(customPrompt))

	req := LLMRequest{
		ModelName:       p.modelName,
		UserPrompt:      prompt,
		Documents:       docs,
		Temperature:     0.2,
		MaxOutputTokens: 8192,
		JSONSchema:      GetPlannerSchemaBytes(),
	}

	resp, err := p.llm.GenerateJSON(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("lỗi gọi LLM Planner: %w", err)
	}

	cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.RawJSON))
	var plan LessonPlan
	if err := json.Unmarshal([]byte(cleanJSON), &plan); err != nil {
		repaired := RepairTruncatedJSON(cleanJSON)
		if errRep := json.Unmarshal([]byte(repaired), &plan); errRep != nil {
			return nil, fmt.Errorf("unmarshal LessonPlan thất bại: %w (Raw: %s)", errRep, cleanJSON)
		}
	}
	return &plan, nil
}
