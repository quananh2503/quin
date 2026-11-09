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

// DefaultHarvester triển khai Harvester interface (Bước 1A).
// Chịu trách nhiệm bóc tách VÉT CẠN toàn bộ các câu hỏi, bài tập, hoạt động từ tài liệu nguồn thành DocumentInventory.
type DefaultHarvester struct {
	provider ai.Provider
	model    string
}

// NewHarvester khởi tạo DefaultHarvester.
func NewHarvester(provider ai.Provider, model string) *DefaultHarvester {
	if model == "" {
		model = "deepseek-flash"
	}
	return &DefaultHarvester{
		provider: provider,
		model:    model,
	}
}

// Harvest quét toàn bộ tài liệu và bóc tách thành DocumentInventory.
func (h *DefaultHarvester) Harvest(ctx context.Context, docs []ai.Document) (*DocumentInventory, *ai.Response, error) {
	if h.provider == nil {
		return nil, nil, fmt.Errorf("chưa cấu hình AI Provider cho Harvester")
	}
	if len(docs) == 0 {
		return nil, nil, fmt.Errorf("danh sách tài liệu đầu vào không được để trống")
	}

	schemaBytes := GetInventorySchemaBytes()
	systemPrompt := fmt.Sprintf("Bạn là Chuyên gia Bóc tách Dữ liệu và Kiểm kê Tài liệu Toán học THPT theo Chương trình GDPT 2018.\n"+
		"[BẮT BUỘC ĐỊNH DẠNG JSON]: Bạn PHẢI trả về một JSON Object hợp lệ (không kèm markdown ngoài lề) tuân thủ đúng cấu trúc JSON Schema sau:\n%s",
		string(schemaBytes))

	prompt := fmt.Sprintf(`NHIỆM VỤ: Quét toàn bộ %d tài liệu học tập đính kèm và lập bản kiểm kê VÉT CẠN 100%% TẤT CẢ các câu hỏi, bài tập, hoạt động, ví dụ...

QUY TẮC BẮT BUỘC ĐỂ KHÔNG BỎ SÓT NỘI DUNG (KHÔNG ĐƯỢC TỰ Ý CẮT BỚT):
1. VÉT CẠN TOÀN DIỆN (COMPREHENSIVE HARVESTING):
   - Với Sách giáo khoa (SGK): BẮT BUỘC bóc tách từng Hoạt động (HĐ), Luyện tập (LT), Vận dụng (VĐ), Ví dụ (VD), và Bài tập cuối bài (BT). TUYỆT ĐỐI KHÔNG tự ý bỏ qua các câu HĐ, LT, VĐ với lý do là lý thuyết minh họa trên lớp.
   - Với Đề thi / Trắc nghiệm: Bóc tách từng câu Trắc nghiệm 4 lựa chọn, Trắc nghiệm Đúng/Sai, Trả lời ngắn, Tự luận. CẤM viết tắt dạng dải C1..C50, BẮT BUỘC liệt kê từng câu độc lập.
   - Với Bài toán thực tế đời sống: Bắt buộc bóc tách chi tiết các bài toán mô hình hóa thực tiễn (vật lý, cân bằng lực, chuyển động, đo đạc không gian...).

2. QUY ƯỚC ĐẶT MÃ ID CHUẨN XÁC ĐỂ TRÁNH TRÙNG LẶP (ANTI-COLLISION):
   Mỗi mục bài tập/câu hỏi BẮT BUỘC có một trường "id" duy nhất theo định dạng:
   [Mã_Tài_Liệu]_[Tên_Bài_Hoặc_Phần]_[Mã_Câu]
   Ví dụ cụ thể:
   - Tài liệu SGK Bài 1: DOC1_B1_HD1, DOC1_B1_VD1, DOC1_B1_LT1, DOC1_B1_VD1, DOC1_B1_BT1, DOC1_B1_BT2...
   - Tài liệu SGK Bài 2: DOC1_B2_HD1, DOC1_B2_VD1, DOC1_B2_BT1, DOC1_B2_BT2...
   - Tài liệu SGK Ôn tập chương: DOC1_OnTap1, DOC1_OnTap2...
   - Tài liệu Đề kiểm tra/Trắc nghiệm: DOC3_C1, DOC3_C2, DOC3_DS1, DOC3_TLN1...

3. TRƯỜNG "snippet":
   Mô tả vắn tắt 1-2 câu nội dung của bài toán (yêu cầu tìm gì, dạng toán gì, hình học gì) để bước sau có thể phân loại sư phạm chính xác.`, len(docs))

	maxTokens := 64000
	if envMax := os.Getenv("DEEPSEEK_MAX_TOKENS"); envMax != "" {
		if val, err := strconv.Atoi(envMax); err == nil && val > 0 {
			maxTokens = val
		}
	} else if strings.Contains(h.model, "chat") {
		maxTokens = 8192
	}

	cfg := &deepseek.Config{
		Temperature:    0.1,
		MaxTokens:      maxTokens,
		ResponseFormat: &deepseek.ResponseFormatConfig{Type: "json_object"},
	}

	req := ai.Request{
		Model:        h.model,
		SystemPrompt: systemPrompt,
		UserPrompt:   prompt,
		Documents:    docs,
		Config:       cfg,
	}

	resp, errGen := h.provider.Generate(ctx, req)
	if errGen != nil {
		return nil, nil, fmt.Errorf("lỗi gọi AI Harvester: %w", errGen)
	}

	cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.Content))
	var inventory DocumentInventory
	if errUnmarshal := json.Unmarshal([]byte(cleanJSON), &inventory); errUnmarshal != nil {
		repaired := RepairTruncatedJSON(cleanJSON)
		if errRep := json.Unmarshal([]byte(repaired), &inventory); errRep != nil {
			return nil, resp, fmt.Errorf("unmarshal DocumentInventory thất bại: %w (Raw: %s)", errRep, cleanJSON)
		}
	}

	if len(inventory.Items) == 0 {
		return &inventory, resp, fmt.Errorf("AI Harvester trả về danh sách kiểm kê rỗng (0 items)")
	}

	inventory.TotalItems = len(inventory.Items)
	return &inventory, resp, nil
}
