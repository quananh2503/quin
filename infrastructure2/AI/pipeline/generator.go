package pipeline

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"

	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/AI/deepseek"
)

// DefaultGenerator triển khai Generator interface (Stage 2 Authoring).
// Nhiệm vụ: Biên soạn nội dung bài giảng chi tiết cho từng dạng toán theo phong cách
// sư phạm thực chiến dành riêng cho học sinh mất gốc (Variant-Centric Architecture),
// xuất ra JSON Schema chuẩn mực và chuyển đổi tự động sang Typst + MiTeX.
type DefaultGenerator struct {
	provider   ai.Provider
	model      string
	maxWorkers int
}

// NewGenerator khởi tạo DefaultGenerator.
func NewGenerator(provider ai.Provider, model string, maxWorkers int) *DefaultGenerator {
	if model == "" {
		model = "deepseek-flash"
	}
	if maxWorkers <= 0 {
		maxWorkers = 30
	}
	return &DefaultGenerator{
		provider:   provider,
		model:      model,
		maxWorkers: maxWorkers,
	}
}

// GenerateTopicJSON biên soạn 1 dạng toán và trả về *TopicContent cùng *ai.Response.
func (g *DefaultGenerator) GenerateTopicJSON(ctx context.Context, topic TopicPlan, docs []ai.Document, globalPlan *LessonPlan, userPrompt string) (*TopicContent, *ai.Response, error) {
	if g.provider == nil {
		return nil, nil, fmt.Errorf("chưa cấu hình AI Provider cho Generator")
	}

	// 1. Thu thập danh sách bài tập được phân bổ cho dạng này từ Inventory (nếu có)
	var assignedDetails strings.Builder
	if globalPlan != nil && len(globalPlan.Inventory.Items) > 0 {
		itemMap := make(map[string]InventoryItem, len(globalPlan.Inventory.Items))
		for _, item := range globalPlan.Inventory.Items {
			itemMap[item.ID] = item
		}

		assignedDetails.WriteString(fmt.Sprintf("DANH SÁCH BÀI TẬP ĐƯỢC PHÂN BỔ CHO DẠNG NÀY (%d mục):\n", len(topic.AssignedQuestionIDs)))
		for _, qid := range topic.AssignedQuestionIDs {
			if item, found := itemMap[qid]; found {
				sol := ""
				if item.HasSolution {
					sol = "[Có lời giải mẫu]"
				}
				assignedDetails.WriteString(fmt.Sprintf("- [%s] %s (%s) %s\n  Tóm tắt đề: %s\n",
					item.ID, item.SourceLabel, item.ItemType, sol, item.Snippet))
			} else {
				assignedDetails.WriteString(fmt.Sprintf("- [%s]\n", qid))
			}
		}
	} else if len(topic.AssignedQuestionIDs) > 0 {
		assignedDetails.WriteString("DANH SÁCH MÃ BÀI TẬP PHÂN BỔ: " + strings.Join(topic.AssignedQuestionIDs, ", ") + "\n")
	}

	systemPrompt := `BẠN LÀ: Chuyên gia Thiết kế Giáo án Toán THPT (Chương trình GDPT 2018), chuyên gia sư phạm thực chiến dành riêng cho HỌC SINH MẤT GỐC / HỌC SINH YẾU.

[BẮT BUỘC ĐỊNH DẠNG ĐẦU RA]:
- Bạn PHẢI trả về DUY NHẤT một chuỗi JSON hợp lệ theo đúng cấu trúc TopicContent được yêu cầu.
- TUYỆT ĐỐI KHÔNG xuất mã LaTeX trần, KHÔNG bọc mã trong thẻ code block markdown (không dùng ` + "```" + `json hay ` + "```" + `). Bắt đầu ngay từ ký tự '{' đầu tiên.
- TOÀN BỘ công thức toán học, biểu thức, ký hiệu hình học hoặc đại số BẮT BUỘC kẹp trong cặp dấu $...$ (sử dụng cú pháp LaTeX chuẩn xác như \frac{a}{b}, \sqrt{x}, \vec{u}, \overrightarrow{AB}, \int, v.v.).

[NGUYÊN TẮC SƯ PHẠM DÀNH CHO HỌC SINH MẤT GỐC]:
1. Học sinh mất gốc KHÔNG CÓ khả năng tự phân tích sâu, suy luận trừu tượng hay biến đổi bắc cầu phức tạp.
2. Các em cần một "BỘ KHUNG HÀNH ĐỘNG TUẦN TỰ (action_steps)" mang tính chất THUẬT TOÁN CẦM TAY CHỈ VIỆC: Đọc đề -> Nhận diện dấu hiệu -> Ráp quy trình/Bấm máy -> Ra kết quả.
3. TUYỆT ĐỐI KHÔNG tách rời "Các bước giải" và "Mẹo" thành hai mục riêng biệt. MẸO PHẢI ĐƯỢC NHÚNG TRỰC TIẾP LÀM MỘT PHẦN CỦA BƯỚC GIẢI.

[QUY TẮC BẮT BUỘC: ĐẶT TÊN BIẾN THỂ ("variant_name")]:
- Mỗi phần tử trong mảng "variants" BẮT BUỘC PHẢI CÓ TÊN GỌI RÕ RÀNG VÀ ĐẦY ĐỦ trong trường "variant_name".
- "variant_name" PHẢI LÀ MỘT TIÊU ĐỀ SƯ PHẠM CỤ THỂ, nêu bật phương pháp giải hoặc dạng bài toán (Ví dụ: "Xác định điểm thỏa mãn đẳng thức vectơ", "Tính độ dài vectơ tổng bằng quy tắc hình bình hành", "Phân tích vectơ qua hai vectơ không cùng phương").
- Bạn BẮT BUỘC phải bám sát danh sách "Các biến thể dự kiến" đã nêu ở đề bài để điền tên tương ứng cho từng biến thể (V1, V2,...).
- TUYỆT ĐỐI NGHIÊM CẤM: Không được để trống (""), không được đặt tên chung chung vô nghĩa như "Biến thể 1", "Dạng 1", "V1".

[BỘ KHUNG HÀNH ĐỘNG TUẦN TỰ - "action_steps"]:
- Bạn HOÀN TOÀN TỰ DO QUYẾT ĐỊNH SỐ LƯỢNG BƯỚC cho mỗi biến thể:
  + Có bài chỉ cần 2 bước cực ngắn (ví dụ: xác định nhanh hệ số -> bấm máy tính/áp dụng khẩu quyết là ra luôn).
  + Có bài cần 3, 4 hoặc 5 bước tuần tự chia nhỏ để học sinh yếu làm từng chút một mà không bị ngợp.
  + TUYỆT ĐỐI KHÔNG gò bó mọi bài phải có số bước giống nhau. Số lượng bước hoàn toàn do bạn quyết định sao cho tự nhiên và dễ hiểu nhất đối với học sinh mất gốc.
- TIÊU CHÍ BẮT BUỘC TRONG TỪNG BƯỚC:
  + Mỗi bước là một "chỉ dẫn hành động thực tế" (học sinh đọc là biết tay phải viết gì ra nháp, mắt phải nhìn vào đâu, hoặc tay phải bấm phím nào).
  + MẸO VÀ THAO TÁC PHẢI ĐƯỢC NHÚNG TRỰC TIẾP VÀO TRONG BƯỚC:
    * Nếu bài toán giải được hoặc thử được bằng máy tính cầm tay (Casio fx-580VNX, fx-880BTG...): Hãy ƯU TIÊN biến các bước thành quy trình bấm máy cụ thể (chỉ rõ từng phím bấm, cách nhập số liệu, cách đọc màn hình để khoanh đáp án).
    * Nếu bài toán là biến đổi công thức/suy luận/hình học: Hãy chia nhỏ thành các bước biến đổi nhẹ nhàng, nhúng thẳng khẩu quyết nhớ nhanh hoặc mẹo loại trừ phương án sai (loại trừ bẫy dấu, bẫy đơn vị, thử giá trị đặc biệt...).

[QUY TẮC BẮT BUỘC VỀ LỜI GIẢI MẪU ("example.solution") DÀNH CHO HỌC SINH YẾU]:
- Lời giải mẫu là TẤM GƯƠNG PHẢN CHIẾU 1-1 của "action_steps" ở trên:
  + Khi học sinh yếu đọc công thức/phương pháp, các em nhìn thấy "action_steps" có N bước (Bước 1, Bước 2,... Bước N) thì trong LỜI GIẢI MẪU ("solution"), bạn BẮT BUỘC PHẢI TRÌNH BÀY ĐÚNG N BƯỚC TƯƠNG ỨNG ĐÓ.
  + MỖI BƯỚC TRONG LỜI GIẢI MẪU BẮT BUỘC BẮT ĐẦU BẰNG TIỀN TỐ: "Bước 1:", "Bước 2:", ... "Bước N:".
  + BẮT BUỘC XUỐNG DÒNG (dùng ký tự \n trong chuỗi JSON) giữa các bước để giao diện và phiếu in tách bạch trực quan từng bước, không viết dính chùm.
  + NỘI DUNG TỪNG BƯỚC LỜI GIẢI MẪU: Áp dụng cụ thể và chuẩn xác hành động của bước tương ứng trong "action_steps" vào bài toán:
    * Bước 1: [Thực hiện hành động của Bước 1 áp dụng trực tiếp lên dữ kiện đề bài]
    * Bước 2: [Thực hiện hành động của Bước 2 áp dụng trực tiếp lên dữ kiện đề bài (tính toán, biến đổi hoặc thao tác Casio cụ thể)]
    * Bước N (bước cuối): [Thực hiện hành động của Bước N và kết luận rõ ràng đáp số/kết quả cần tìm]
  + TUYỆT ĐỐI NGHIÊM CẤM: Không bao giờ viết lời giải mẫu thành một đoạn văn xuôi liên tục không chia bước. Học sinh yếu mất gốc cần nhìn đối chiếu trực tiếp: nhìn Bước 1 ở khung công thức phía trên -> thấy ngay Bước 1 ở bài mẫu phía dưới để hiểu cách làm và tự tin làm theo!

[QUY TẮC ĐẲNG CẤU CHO BÀI TẬP RÈN LUYỆN ("drills")]:
- Bài tập rèn luyện tương tự ("drills"): Các bài tập PHẢI CÙNG THUẬT TOÁN BIẾN ĐỔI / CÙNG QUY TRÌNH BẤM MÁY với ví dụ mẫu, chỉ thay đổi số liệu hoặc biến số để học sinh yếu làm đi làm lại quen tay tạo thành phản xạ cơ bắp.
- Lời giải bài tập drill ("solution"): KHÔNG CẦN chia bước, chỉ cần giải ngắn gọn 1-2 dòng tóm tắt phép tính và kết quả để giáo viên nắm ý và tiết kiệm token.`

	prompt := fmt.Sprintf(`NHIỆM VỤ: Biên soạn tài liệu học tập hoàn chỉnh cho Dạng toán:
👉 [%s] %s (Mức độ: %s)
- Mục tiêu cần đạt: %s
- Cốt lõi phương pháp: %s
- Các biến thể dự kiến: %s

%s

YÊU CẦU CẤU TRÚC JSON ĐẦU RA (TopicContent):
{
  "topic_id": "%s",
  "title": "%s",
  "difficulty": "%s",
  "theory_points": [
    "2-3 gạch đầu dòng lý thuyết nền tảng cốt lõi, tối giản, trực diện, không chứng minh hàn lâm (toán bọc trong $...$)"
  ],
  "cloze_formula": "1 câu công thức then chốt có chỗ trống '...' để học sinh tự điền khuyết ($...$)",
  "callout_tip": "Khẩu quyết ghi nhớ cốt lõi chung của dạng (nếu có)",
  "variants": [
    {
      "variant_id": "V1",
      "variant_name": "BẮT BUỘC ĐIỀN: Tên gọi cụ thể mô tả phương pháp giải (bám sát Các biến thể dự kiến, ví dụ: 'Xác định điểm thỏa mãn đẳng thức vectơ')",
      "recognition": "Dấu hiệu nhận diện đặc trưng (nhìn phát biết ngay kiểu bài này)",
      "action_steps": [
        "Hành động bước 1...",
        "Hành động bước 2 (nhúng thẳng mẹo bấm máy hoặc khẩu quyết biến đổi)..."
      ],
      "quick_tip": "Câu chốt mẹo phản xạ siêu tốc hoặc mẹo loại trừ 5 giây",
      "example": {
        "title": "Ví dụ minh họa cho biến thể (trích nguồn SGK/Hoạt động)",
        "problem": "Đề bài đầy đủ dữ kiện ($...$)",
        "solution": "BẮT BUỘC chia rõ từng bước tương ứng 1-1 với action_steps (xuống dòng giữa các bước):\nBước 1: [Thực hiện Bước 1 áp dụng vào bài này]...\nBước 2: [Thực hiện Bước 2 áp dụng vào bài này]...\nBước 3: [Thực hiện Bước 3 và kết luận]... (TUYỆT ĐỐI KHÔNG viết dồn thành một đoạn văn)"
      },
      "drills": [
        {
          "title": "Bài 1.1",
          "level": "TuongTu100",
          "prompt": "Đề bài đẳng cấu chỉ đổi số liệu ($...$)",
          "solution": "Lời giải ngắn gọn 1-2 dòng cho giáo viên ($...$)",
          "answer": "Đáp án hoặc kết quả số"
        }
      ]
    }
  ],
  "answer_key": [
    {
      "drill_id": "Bài 1.1",
      "short_guide": "Tóm tắt bước làm chính",
      "final_answer": "Đáp số cuối cùng"
    }
  ]
}

Yêu cầu riêng của giáo viên: %s`,
		topic.TopicID, topic.Title, topic.Difficulty,
		topic.TargetOutput, topic.CoreConcept,
		strings.Join(topic.Variants, "; "),
		assignedDetails.String(),
		topic.TopicID, topic.Title, topic.Difficulty,
		strings.TrimSpace(userPrompt))

	maxTokens := 64000
	if envMax := os.Getenv("DEEPSEEK_MAX_TOKENS"); envMax != "" {
		if val, err := strconv.Atoi(envMax); err == nil && val > 0 {
			maxTokens = val
		}
	} else if strings.Contains(g.model, "chat") {
		maxTokens = 8192
	}

	cfg := &deepseek.Config{
		Temperature:    0.2,
		MaxTokens:      maxTokens,
		ResponseFormat: &deepseek.ResponseFormatConfig{Type: "json_object"},
	}

	req := ai.Request{
		Model:        g.model,
		SystemPrompt: systemPrompt,
		UserPrompt:   prompt,
		Documents:    docs, // 86 trang ảnh ở Prefix để hưởng trọn 99%+ Prompt Caching!
		Config:       cfg,
	}

	resp, errGen := g.provider.Generate(ctx, req)
	if errGen != nil {
		return nil, nil, fmt.Errorf("lỗi gọi AI Generator cho dạng %s: %w", topic.TopicID, errGen)
	}

	cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.Content))
	var tc TopicContent
	if errUnmarshal := json.Unmarshal([]byte(cleanJSON), &tc); errUnmarshal != nil {
		repaired := RepairTruncatedJSON(cleanJSON)
		if errRep := json.Unmarshal([]byte(repaired), &tc); errRep != nil {
			return nil, resp, fmt.Errorf("unmarshal TopicContent thất bại: %w (Raw Content: %s)", errRep, cleanJSON)
		}
	}

	if tc.TopicID == "" {
		tc.TopicID = topic.TopicID
	}
	if tc.Title == "" {
		tc.Title = topic.Title
	}
	if tc.Difficulty == "" {
		tc.Difficulty = topic.Difficulty
	}

	// Đảm bảo tên biến thể luôn đầy đủ (fallback vào topic.Variants nếu AI trả về rỗng)
	for vIdx := range tc.Variants {
		if strings.TrimSpace(tc.Variants[vIdx].VariantName) == "" {
			if vIdx < len(topic.Variants) && strings.TrimSpace(topic.Variants[vIdx]) != "" {
				tc.Variants[vIdx].VariantName = strings.TrimSpace(topic.Variants[vIdx])
			} else {
				tc.Variants[vIdx].VariantName = fmt.Sprintf("Biến thể %d", vIdx+1)
			}
		}
	}

	// Tự động render mã Typst hoàn chỉnh
	tc.TypstContent = RenderTopicTypst(&tc)

	return &tc, resp, nil
}

// GenerateTopic biên soạn nội dung chi tiết cho một dạng toán theo userPrompt và trả về TopicContent.
func (g *DefaultGenerator) GenerateTopic(ctx context.Context, topic TopicPlan, docs []ai.Document, globalPlan *LessonPlan, userPrompt string) (*TopicContent, error) {
	tc, _, err := g.GenerateTopicJSON(ctx, topic, docs, globalPlan, userPrompt)
	return tc, err
}

// GenerateTopicLaTeX duy trì tính tương thích ngược cho các bộ test hoặc công cụ gọi cũ.
func (g *DefaultGenerator) GenerateTopicLaTeX(ctx context.Context, topic TopicPlan, docs []ai.Document, globalPlan *LessonPlan, userPrompt string) (string, *ai.Response, error) {
	tc, resp, err := g.GenerateTopicJSON(ctx, topic, docs, globalPlan, userPrompt)
	if err != nil {
		return "", resp, err
	}
	return tc.TypstContent, resp, nil
}

// GenerateAll điều phối worker pool chạy song song để sinh nội dung cho tất cả các dạng toán trong kế hoạch.
func (g *DefaultGenerator) GenerateAll(ctx context.Context, plan *LessonPlan, docs []ai.Document, userPrompt string, maxWorkers int) ([]TopicContent, error) {
	if plan == nil || len(plan.Topics) == 0 {
		return nil, fmt.Errorf("kế hoạch bài học (LessonPlan) rỗng")
	}

	if maxWorkers <= 0 {
		maxWorkers = g.maxWorkers
	}
	if maxWorkers > len(plan.Topics) {
		maxWorkers = len(plan.Topics)
	}

	results := make([]TopicContent, len(plan.Topics))
	errs := make([]error, len(plan.Topics))

	topicChan := make(chan int, len(plan.Topics))
	for i := range plan.Topics {
		topicChan <- i
	}
	close(topicChan)

	var wg sync.WaitGroup
	for w := 0; w < maxWorkers; w++ {
		workerID := w + 1
		wg.Add(1)
		go func() {
			defer wg.Done()
			for idx := range topicChan {
				select {
				case <-ctx.Done():
					errs[idx] = ctx.Err()
					return
				default:
					topic := plan.Topics[idx]
					t0 := time.Now()
					fmt.Printf("[Worker %d] 🚀 Bắt đầu biên soạn [%s]: %s (%s)...\n",
						workerID, topic.TopicID, topic.Title, topic.Difficulty)

					tc, err := g.GenerateTopic(ctx, topic, docs, plan, userPrompt)
					if err != nil {
						errs[idx] = fmt.Errorf("sinh dạng %s thất bại: %w", topic.TopicID, err)
						fmt.Printf("[Worker %d] ❌ Lỗi dạng [%s]: %v\n", workerID, topic.TopicID, err)
					} else if tc != nil {
						results[idx] = *tc
						fmt.Printf("[Worker %d] ✅ Hoàn thành [%s]: %s (%d biến thể, trong %v)\n",
							workerID, topic.TopicID, topic.Title, len(tc.Variants), time.Since(t0))
					}
				}
			}
		}()
	}

	wg.Wait()

	for _, err := range errs {
		if err != nil {
			return results, err
		}
	}

	return results, nil
}
