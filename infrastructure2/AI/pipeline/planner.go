package pipeline

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"strings"

	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/AI/deepseek"
)

// DefaultPlanner triển khai Planner interface (Stage 1).
// Thực hiện quy trình 2 bước con độc lập:
//   - Bước 1A: Harvester bóc tách VÉT CẠN 100% câu hỏi/hoạt động/ví dụ từ tài liệu thành DocumentInventory.
//   - Bước 1B: Curriculum Planner gom nhóm sư phạm từ bản kiểm kê thành LessonPlan hoàn chỉnh.
type DefaultPlanner struct {
	provider  ai.Provider
	model     string
	harvester Harvester
}

// NewPlanner khởi tạo DefaultPlanner.
func NewPlanner(provider ai.Provider, model string) *DefaultPlanner {
	if model == "" {
		model = "deepseek-flash"
	}
	return &DefaultPlanner{
		provider:  provider,
		model:     model,
		harvester: NewHarvester(provider, model),
	}
}

// WithHarvester gán Harvester tùy chỉnh (dùng cho testing/mocking).
func (p *DefaultPlanner) WithHarvester(h Harvester) *DefaultPlanner {
	if h != nil {
		p.harvester = h
	}
	return p
}

// Plan thực thi trọn vẹn quy trình phân tích bài giảng 2 bước (1A Harvester -> 1B Curriculum Planner).
func (p *DefaultPlanner) Plan(ctx context.Context, docs []ai.Document, userPrompt string) (*LessonPlan, *ai.Response, error) {
	if p.provider == nil {
		return nil, nil, fmt.Errorf("chưa cấu hình AI Provider cho Planner")
	}
	if len(docs) == 0 {
		return nil, nil, fmt.Errorf("danh sách tài liệu đầu vào không được để trống")
	}

	// 1. Bước 1A: Harvester quét ảnh tài liệu để lập bản kiểm kê vét cạn DocumentInventory
	inventory, harvestResp, errHarvest := p.harvester.Harvest(ctx, docs)
	if errHarvest != nil {
		return nil, harvestResp, fmt.Errorf("bước 1A (Harvester) thất bại: %w", errHarvest)
	}

	// 2. Bước 1B: Curriculum Planner gom nhóm sư phạm thuần túy qua text inventory (không cần truyền lại ảnh)
	plan, planResp, errPlan := p.PlanFromInventory(ctx, inventory, userPrompt)
	if errPlan != nil {
		return plan, planResp, fmt.Errorf("bước 1B (Curriculum Planner) thất bại: %w", errPlan)
	}

	return plan, planResp, nil
}

// PlanFromInventory (Bước 1B) nhận bản kiểm kê DocumentInventory và nhóm thành các dạng toán chuyên sâu.
// Bước này chỉ xử lý văn bản, tốc độ cực nhanh và tiết kiệm tối đa token.
func (p *DefaultPlanner) PlanFromInventory(ctx context.Context, inventory *DocumentInventory, userPrompt string) (*LessonPlan, *ai.Response, error) {
	if p.provider == nil {
		return nil, nil, fmt.Errorf("chưa cấu hình AI Provider cho Planner")
	}
	if inventory == nil || len(inventory.Items) == 0 {
		return nil, nil, fmt.Errorf("bản kiểm kê DocumentInventory không được để trống")
	}

	var invBuilder strings.Builder
	for _, item := range inventory.Items {
		solTag := ""
		if item.HasSolution {
			solTag = "[Có lời giải]"
		}
		invBuilder.WriteString(fmt.Sprintf("- ID: %s | Nguồn: %s - %s | Loại: %s %s\n  Mô tả: %s\n",
			item.ID, item.SourceName, item.SourceLabel, item.ItemType, solTag, item.Snippet))
	}

	schemaBytes := GetPlannerSchemaBytes()
	systemPrompt := fmt.Sprintf("Bạn là Chuyên gia Sư phạm Toán học THPT và Thiết kế Giáo án theo Chương trình GDPT 2018.\n"+
		"[BẮT BUỘC ĐỊNH DẠNG JSON]: Bạn PHẢI trả về một JSON Object hợp lệ (không kèm thẻ markdown ngoài lề) tuân thủ đúng cấu trúc JSON Schema sau:\n%s",
		string(schemaBytes))

	prompt := fmt.Sprintf(`Dưới đây là BẢN KIỂM KÊ VÉT CẠN gồm %d câu hỏi / bài tập / hoạt động đã được bóc tách từ các tài liệu học tập:

%s

NHIỆM VỤ: Dựa trên bản kiểm kê 100%% ở trên, hãy nhóm chúng lại thành các DẠNG TOÁN CHUYÊN SÂU (Topics) trong kế hoạch bài giảng.

QUY TẮC PHÂN RÃ SƯ PHẠM DÀNH CHO HỌC SINH (ĐẶC BIỆT LƯU TÂM HỌC SINH MẤT GỐC/YẾU):
1. NGUYÊN TẮC ĐƠN KỸ NĂNG (ATOMIC SKILL):
   - Học sinh yếu cần học theo từng bước nhỏ. Mỗi dạng toán phải tập trung vào một kỹ năng cốt lõi (từ nhận biết cơ bản, hoạt động khám phá, ví dụ mẫu rồi mới nâng dần lên bài tập luyện tập và vận dụng).
   - Tuyệt đối không gom nhiều công thức hoặc phương pháp giải khác nhau vào cùng một dạng.
2. TÁCH DẠNG MÔ HÌNH HÓA THỰC TIỄN:
   - Các bài toán mô hình hóa thực tế (cân bằng lực vật lý, chuyển động trong không gian, khoảng cách/đo đạc đời sống) BẮT BUỘC TÁCH THÀNH DẠNG RIÊNG BIỆT.
3. CHỐNG GOM GỘP QUÁ TẢI (ANTI-LUMPING):
   - Mỗi dạng toán chỉ nên phân bổ số lượng bài tập vừa phải (tối đa 12 câu tiêu biểu). Nếu có quá nhiều câu (như chứng minh đẳng thức hay tính góc), BẮT BUỘC PHẢI PHÂN RÃ thành các tiểu dạng chuyên sâu hơn.
4. QUY TẮC BẢO TOÀN VÉT CẠN (CHECKSUM):
   - Toàn bộ các mã item ID trong bản kiểm kê BẮT BUỘC phải được phân bổ vào trường "assigned_question_ids" của các dạng toán phù hợp. Không được bỏ sót bất kỳ item ID nào.

Yêu cầu riêng của giáo viên: %s`, len(inventory.Items), invBuilder.String(), strings.TrimSpace(userPrompt))

	maxTokens := 64000
	if envMax := os.Getenv("DEEPSEEK_MAX_TOKENS"); envMax != "" {
		if val, err := strconv.Atoi(envMax); err == nil && val > 0 {
			maxTokens = val
		}
	} else if strings.Contains(p.model, "chat") {
		maxTokens = 8192
	}

	cfg := &deepseek.Config{
		Temperature:    0.2,
		MaxTokens:      maxTokens,
		ResponseFormat: &deepseek.ResponseFormatConfig{Type: "json_object"},
	}

	req := ai.Request{
		Model:        p.model,
		SystemPrompt: systemPrompt,
		UserPrompt:   prompt,
		Documents:    nil, // Chỉ gửi văn bản thuần, không cần gửi lại ảnh tài liệu!
		Config:       cfg,
	}

	resp, errGen := p.provider.Generate(ctx, req)
	if errGen != nil {
		return nil, nil, fmt.Errorf("lỗi gọi AI Curriculum Planner: %w", errGen)
	}

	cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.Content))
	var plan LessonPlan
	if errUnmarshal := json.Unmarshal([]byte(cleanJSON), &plan); errUnmarshal != nil {
		repaired := RepairTruncatedJSON(cleanJSON)
		if errRep := json.Unmarshal([]byte(repaired), &plan); errRep != nil {
			return nil, resp, fmt.Errorf("unmarshal LessonPlan thất bại: %w (Raw Content: %s)", errRep, cleanJSON)
		}
	}

	if len(plan.Topics) == 0 {
		return &plan, resp, fmt.Errorf("AI trả về kế hoạch nhưng không có dạng toán nào (Topics rỗng)")
	}

	// Đính kèm bản kiểm kê gốc vào LessonPlan để lưu giữ dấu vết kiểm tra
	plan.Inventory = *inventory

	return &plan, resp, nil
}
