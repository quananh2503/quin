package gemini

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"golang.org/x/sync/errgroup"
)

// =============================================================================
// STAGE 2: AUTHORING STAGE (BIÊN SOẠN BÀI TẬP SONG SONG QUA WORKER POOL)
// =============================================================================

// AuthoringStage: Giai đoạn 2 - Biên soạn nội dung song song cho từng dạng bài tập
type AuthoringStage interface {
	Author(ctx context.Context, docs []DocumentInput, plan *LessonPlan) ([]WorkerResult, error)
}

// DefaultAuthoringStage thực thi Giai đoạn 2: Biên soạn nội dung song song
type DefaultAuthoringStage struct {
	llm         LLMProvider
	modelName   string
	concurrency int
}

// NewDefaultAuthoringStage khởi tạo AuthoringStage với số lượng worker đồng thời tùy chỉnh
func NewDefaultAuthoringStage(llm LLMProvider, modelName string, concurrency int) *DefaultAuthoringStage {
	if concurrency <= 0 {
		concurrency = 6
	}
	return &DefaultAuthoringStage{
		llm:         llm,
		modelName:   modelName,
		concurrency: concurrency,
	}
}

// Author: Điều phối luồng công việc song song biên soạn chi tiết từng dạng bài tập.
func (a *DefaultAuthoringStage) Author(ctx context.Context, docs []DocumentInput, plan *LessonPlan) ([]WorkerResult, error) {
	if plan == nil || len(plan.Topics) == 0 {
		return nil, fmt.Errorf("kế hoạch bài học rỗng")
	}

	results := make([]WorkerResult, len(plan.Topics))
	sem := make(chan struct{}, a.concurrency)
	var g errgroup.Group

	for idx := range plan.Topics {
		i := idx
		t := plan.Topics[i]

		g.Go(func() error {
			sem <- struct{}{}
			defer func() { <-sem }()

			// Kiểm tra context có bị cancel không
			select {
			case <-ctx.Done():
				return ctx.Err()
			default:
			}

			// Format prompt cho từng worker
			var variantBuilder strings.Builder
			for vIdx, vStr := range t.Variants {
				variantBuilder.WriteString(fmt.Sprintf("  - Biến thể %d: %s\n", vIdx+1, vStr))
			}

			wPrompt := fmt.Sprintf(`NHIỆM VỤ BIÊN SOẠN BÀI GIẢNG CHO 1 DẠNG TOÁN:
- CHỦ ĐỀ DẠNG TOÁN: "%s"
- MỨC ĐỘ: %s
- PHƯƠNG PHÁP GIẢI CỐT LÕI: "%s"
- DANH SÁCH CÁC BIẾN THỂ CẦN BAO PHỦ:
%s

TRIẾT LÝ SƯ PHẠM CỐT LÕI (BẮT BUỘC TUÂN THỦ NGHIÊM NGẶT):
1. LÝ THUYẾT LÀ KIM CHỈ NAM LÀM CHUẨN:
   - Toàn bộ ví dụ giải mẫu và bài tập tự luyện BẮT BUỘC phải bám sát trực tiếp vào các gạch đầu dòng lý thuyết ("theory_points"), công thức cốt lõi và mẹo nhớ ("callout_tip") của dạng này.
   - Bất kể dạng toán ở mức cơ bản hay vận dụng cao, TUYỆT ĐỐI KHÔNG ra đề bài đánh đố, gài bẫy xa rời phần lý thuyết cốt lõi đã nêu. Đề bài chỉ dùng đúng các công thức và bước biến đổi đã được định nghĩa trong lý thuyết của dạng.

2. NGUYÊN TẮC BAO QUÁT TOÀN BỘ CÔNG THỨC (100%% FORMULA COVERAGE):
   - Nếu phần lý thuyết có K công thức / tính chất, thì cả phần Ví dụ và phần Bài tập BẮT BUỘC phải bao quát đầy đủ cả K công thức / tính chất đó (mỗi công thức đều có ít nhất một bài áp dụng).

3. NGUYÊN TẮC RÈN LUYỆN ĐẲNG CẤU & LẶP LẠI PHẢN XẠ (ISOMORPHIC & REPETITIVE PRACTICE):
   - Học sinh cần luyện đi luyện lại cùng một bước làm, cùng một thuật toán, cùng một công thức biến đổi nhiều lần để tạo thành phản xạ cơ bắp và nhớ sâu vào tiềm thức.
   - Các bài tập tự luyện phải có tính tương tự cao với ví dụ mẫu, chỉ biến thể nhẹ có kiểm soát: đổi số liệu, đổi tên điểm/biến số, biến đổi đại số tương đương, hoặc đổi chiều câu hỏi xuôi - ngược đơn giản.

4. TÍNH NHẤT QUÁN GIỮA ĐỀ BÀI VÀ LỜI GIẢI:
   - Đề bài "prompt" hỏi điều gì thì Lời giải "solution" tập trung giải quyết chính xác và duy nhất bài toán đã nêu trong "prompt".
   - Mọi phép thử, nháp số liệu hay kiểm tra biểu thức đều thực hiện hoàn toàn trong "pedagogical_scratchpad".
   - Lời giải "solution" là bản trình bày sư phạm mẫu mực cuối cùng: đi thẳng vào các bước giải khẳng định, mạch lạc, súc tích từ giả thiết đến kết quả, không viết các ghi chú sửa đề hay nháp trong lời giải.

5. NGUYÊN TẮC BẢO TOÀN PHẠM VI KIẾN THỨC CỦA DẠNG:
   - Bài tập và ví dụ của dạng nào chỉ sử dụng đúng công cụ, công thức và phương pháp đã được định nghĩa trong lý thuyết của dạng đó.
   - Tuyệt đối không tự ý đưa vào các công cụ hay quy ước thuộc về các dạng bài/chuyên đề khác chưa được học để tránh làm rối tư duy của học sinh.

HƯỚNG DẪN TRÌNH BÀY CÔNG THỨC TOÁN LATEX TỔNG QUÁT:
- Toàn bộ công thức toán, biểu thức, biến số, tọa độ, ký hiệu hình học hoặc đại số BẮT BUỘC kẹp trong cặp dấu $.
- Sử dụng cú pháp LaTeX chuẩn xác cho mọi môn học: \frac{a}{b}, \sqrt{x}, \vec{u}, \sin, \cos, \lim, \int (nếu có).

CẤU TRÚC DỮ LIỆU BẮT BUỘC BIÊN SOẠN:
1. "pedagogical_scratchpad": BÀN NHÁP SƯ PHẠM VÀ TOÁN HỌC: BẮT BUỘC đặt bút giải thử biểu thức và kiểm tra tính toán trước. Đảm bảo bài toán rút gọn ra kết quả đẹp hoặc bài toán chứng minh đúng đắn 100%% TRƯỚC KHI viết vào "prompt".
2. "theory_points": Các gạch đầu dòng lý thuyết tối giản, cô đọng, tập trung chính xác vào công thức và phương pháp của dạng này - toán kẹp trong $.
3. "callout_tip": 1 mẹo nhớ nhanh, dấu hiệu nhận biết hoặc khẩu quyết thực chiến dễ thuộc.
4. "cloze_formula": 1 câu công thức cốt lõi có chỗ trống '...' để học sinh tự điền khuyết.
5. "short_answers": 2-3 câu hỏi tự luận ngắn tính ra một giá trị số cụ thể (kèm lời giải chi tiết và đáp số).
6. "examples" (VÍ DỤ MINH HỌA GIẢI MẪU CHI TIẾT - TỐI THIỂU 4 VÍ DỤ, TĂNG THEO LÝ THUYẾT):
   - TIÊN QUYẾT: Lấy lý thuyết làm kim chỉ nam, phủ trọn vẹn 100%% các công thức và tính chất trong "theory_points" (mỗi công thức/tính chất bắt buộc có ít nhất 1 ví dụ áp dụng trực tiếp).
   - Tối thiểu 4 ví dụ. Nếu phần lý thuyết có nhiều hơn 4 công thức hoặc nhiều biến thể quan trọng, số lượng ví dụ BẮT BUỘC PHẢI TĂNG LÊN tương ứng để không bỏ sót bất kỳ công thức nào.
   - Đi kèm các ví dụ biến thể nhẹ củng cố cách trình bày từng bước "cầm tay chỉ việc".
7. "drills" (BÀI TẬP TỰ LUYỆN TƯƠNG TỰ ĐỂ RÈN PHẢN XẠ - TỐI THIỂU 4 BÀI, TĂNG THEO LÝ THUYẾT):
   - Tối thiểu 4 bài tập tự luyện tương tự, tăng lên tương ứng nếu dạng có nhiều công thức/biến thể.
   - Bao quát toàn bộ các công thức đã nêu trong lý thuyết và ví dụ, sắp xếp theo mô thức lặp lại rèn luyện phản xạ cơ bắp:
     + Bài 1 (level: "MauChuan"): Áp dụng trực tiếp công thức/thuật toán của Ví dụ 1.
     + Bài 2 (level: "TuongTu100"): Tương tự 100%% với Bài 1, chỉ đổi số liệu để học sinh tự làm lại quen tay.
     + Bài 3 (level: "TuongTu100"): Tiếp tục bài tương tự cho công thức tiếp theo để học sinh tính toán thành thạo.
     + Bài 4 (level: "BienTheNhe"): Biến thể nhẹ (đổi chiều câu hỏi xuôi - ngược, đổi biến), giữ nguyên phương pháp.
     + Các bài tiếp theo (level: "BienTheNhe" hoặc "CungCo" - nếu có): Mở rộng củng cố tốc độ, độ chuẩn xác và phản xạ lặp lại.
   - Lời giải "solution": Từng bước mạch lạc, súc tích, đi thẳng vào các bước giải khẳng định.`,
				t.Title, t.Difficulty, t.CoreConcept, variantBuilder.String())

			req := LLMRequest{
				ModelName:       a.modelName,
				UserPrompt:      wPrompt,
				Documents:       docs,
				Temperature:     0.3,
				MaxOutputTokens: 8192,
				JSONSchema:      GetWorkerSchemaBytes(),
			}

			wStart := time.Now()
			fmt.Printf("[Worker %d/%d] 🚀 Bắt đầu soạn dạng: %s...\n", i+1, len(plan.Topics), t.Title)

			resp, err := a.llm.GenerateJSON(ctx, req)
			if err != nil {
				fmt.Printf("[Worker %d/%d] ❌ Lỗi gọi LLM (%s): %v\n", i+1, len(plan.Topics), t.Title, err)
				return fmt.Errorf("worker %s lỗi: %w", t.TopicID, err)
			}

			var wRes WorkerResult
			cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.RawJSON))
			if err := json.Unmarshal([]byte(cleanJSON), &wRes); err != nil {
				repaired := RepairTruncatedJSON(cleanJSON)
				if errRep := json.Unmarshal([]byte(repaired), &wRes); errRep != nil {
					fmt.Printf("[Worker %d/%d] ❌ Lỗi unmarshal JSON (%s): %v\n", i+1, len(plan.Topics), t.Title, errRep)
					return fmt.Errorf("worker %s unmarshal thất bại: %w", t.TopicID, errRep)
				}
			}

			wRes.TopicID = t.TopicID
			wRes.Title = t.Title
			results[i] = wRes

			fmt.Printf("[Worker %d/%d] ✅ Hoàn thành: %s (%v, %d Drills, %d Trả lời ngắn, %d Ví dụ)\n",
				i+1, len(plan.Topics), t.Title, time.Since(wStart).Round(time.Millisecond),
				len(wRes.Drills), len(wRes.ShortAnswers), len(wRes.Examples))
			return nil
		})
	}

	if err := g.Wait(); err != nil {
		return nil, err
	}

	return results, nil
}
