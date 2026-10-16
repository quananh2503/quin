package gemini

import (
	"context"
	"encoding/json"
	"fmt"
	"math/rand"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"time"

	"github.com/invopop/jsonschema"
	"golang.org/x/sync/errgroup"
	"google.golang.org/genai"
)

var (
	plannerSchema *genai.Schema
	workerSchema  *genai.Schema
	repairSchema  *genai.Schema
)

func init() {
	r := new(jsonschema.Reflector)
	r.ExpandedStruct = true
	r.DoNotReference = true

	// 1. Schema cho Planner
	pSch := r.Reflect(&LessonPlan{})
	pData, _ := json.Marshal(pSch)
	plannerSchema = &genai.Schema{}
	_ = json.Unmarshal(pData, plannerSchema)

	// 2. Schema cho Worker
	wSch := r.Reflect(&WorkerResult{})
	wData, _ := json.Marshal(wSch)
	workerSchema = &genai.Schema{}
	_ = json.Unmarshal(wData, workerSchema)

	// 3. Schema cho Batch Repair
	rSch := r.Reflect(&RepairBatchResponse{})
	rData, _ := json.Marshal(rSch)
	repairSchema = &genai.Schema{}
	_ = json.Unmarshal(rData, repairSchema)
}

// -----------------------------------------------------------------------------
// BỘ PARSER VÀ SANITIZER LATEX SANG MITEX
// -----------------------------------------------------------------------------
var (
	blockMathRegex  = regexp.MustCompile(`(?s)\$\$([^\$]+)\$\$`)
	inlineMathRegex = regexp.MustCompile(`\$([^\$]+)\$`)

	// Bắt các lệnh LaTeX trong chuỗi JSON thô chỉ có 1 dấu gạch chéo để escape thành 2 dấu
	unescapedLatexRegex = regexp.MustCompile(`(?m)(^|[^\\])\\((?:frac|vec|sqrt|neq|bar|to|cdot|perp|alpha|beta|gamma|leq|geq|approx|times|left|right|begin|end|text|mathbf)\b)`)
)

// SanitizeRawJSONLaTeX bảo vệ các lệnh LaTeX không bị Go JSON parser nuốt thành mã điều khiển
func SanitizeRawJSONLaTeX(raw string) string {
	return unescapedLatexRegex.ReplaceAllString(raw, `$1\\$2`)
}

func LaTeXToMiTeX(content string) string {
	content = strings.TrimSpace(content)
	if content == "" {
		return ""
	}

	// Vá nhanh nếu số lượng $ bị lẻ
	if strings.Count(content, "$")%2 != 0 {
		if strings.HasSuffix(content, ".") {
			content = strings.TrimSuffix(content, ".") + "$."
		} else {
			content = content + "$"
		}
	}

	// 1. Chuyển $$...$$ sang block mitex
	content = blockMathRegex.ReplaceAllStringFunc(content, func(m string) string {
		latex := strings.Trim(m, "$")
		return fmt.Sprintf("\n#align(center)[#mitex(`%s`)]\n", strings.TrimSpace(latex))
	})

	// 2. Chuyển $...$ sang inline mi(`...`)
	content = inlineMathRegex.ReplaceAllStringFunc(content, func(m string) string {
		latex := strings.Trim(m, "$")
		return fmt.Sprintf(" #mi(`%s`) ", strings.TrimSpace(latex))
	})

	// Escape các ký tự đặc biệt Typst nếu còn sót ngoài toán
	content = strings.ReplaceAll(content, "$", `\$`)
	return content
}

// -----------------------------------------------------------------------------
// AUDITOR: CHỈ BẮT LỖI HỎNG THỰC SỰ (ASCII RÁC, LỆCH $, LATEX TRẦN)
// -----------------------------------------------------------------------------
var leakedLatexCmdRegex = regexp.MustCompile(`\\(?:frac|vec|sqrt|neq|bar|to|cdot|perp|alpha|beta|leq|geq)\b`)

func AuditMathField(text string) (bool, string) {
	trimmed := strings.TrimSpace(text)
	if trimmed == "" {
		return true, ""
	}

	// 1. Bắt mã điều khiển ASCII rác (0x0C = Form Feed \f, 0x08 = Backspace \b, 0x0B = Vertical Tab \v)
	for _, r := range trimmed {
		if r == '\f' || r == '\b' || r == '\v' {
			return false, "Dính mã điều khiển ASCII rác do lỗi JSON escape"
		}
	}

	// 2. Bắt dấu $ bị lẻ
	if strings.Count(trimmed, "$")%2 != 0 {
		return false, "Số lượng dấu $ bị lẻ (chưa đóng công thức)"
	}

	// 3. Bắt lệnh LaTeX trần nằm ngoài cặp dấu $
	parts := strings.Split(trimmed, "$")
	for i := 0; i < len(parts); i += 2 {
		outside := parts[i]
		if leakedLatexCmdRegex.MatchString(outside) {
			return false, "Chứa lệnh LaTeX trần ngoài dấu $: " + outside
		}
	}

	return true, ""
}

// Helper: Nhận diện các mã lỗi tạm thời có thể retry được
func isTransientError(err error) bool {
	if err == nil {
		return false
	}
	msg := strings.ToLower(err.Error())
	return strings.Contains(msg, "429") ||
		strings.Contains(msg, "resource_exhausted") ||
		strings.Contains(msg, "503") ||
		strings.Contains(msg, "unavailable") ||
		strings.Contains(msg, "overloaded") ||
		strings.Contains(msg, "internal") ||
		strings.Contains(msg, "deadline_exceeded")
}

// generateWithRetry: Hàm bọc gọi Gemini có cơ chế Exponential Backoff + Jitter
func (c *Client) generateWithRetry(
	ctx context.Context,
	modelName string,
	contents []*genai.Content,
	config *genai.GenerateContentConfig,
	maxRetries int,
) (*genai.GenerateContentResponse, error) {
	baseDelay := 2 * time.Second

	for attempt := 0; attempt <= maxRetries; attempt++ {
		resp, err := c.client.Models.GenerateContent(ctx, modelName, contents, config)
		if err == nil {
			return resp, nil
		}

		// Nếu lỗi không phải lỗi quá tải/tạm thời hoặc đã hết số lần retry -> Trả lỗi luôn
		if !isTransientError(err) || attempt == maxRetries {
			return nil, err
		}

		// Tính thời gian chờ: 2s -> 4s -> 8s... kèm random jitter (0-800ms)
		backoff := baseDelay * time.Duration(1<<attempt)
		jitter := time.Duration(rand.Intn(800)) * time.Millisecond
		sleepTime := backoff + jitter

		LogPhase("RETRY", "\033[33m[Quá tải/429] Lần thử %d thất bại. Đang chờ %v trước khi thử lại... (Lỗi: %v)\033[0m",
			attempt+1, sleepTime, err)

		select {
		case <-time.After(sleepTime):
		case <-ctx.Done():
			return nil, ctx.Err()
		}
	}

	return nil, fmt.Errorf("đã thử %d lần nhưng vẫn thất bại", maxRetries)
}

// -----------------------------------------------------------------------------
// PHASE 1: MASTER PLANNER
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// PHASE 1: MASTER PLANNER (CHIỀU CHUỘNG FLASH-LITE VỚI DUAL-THINKING & SCRATCHPAD)
// -----------------------------------------------------------------------------
func (c *Client) ExecutePhase1_Planner(ctx context.Context, modelName string, pdfBytes []byte, customPrompt string) (*LessonPlan, error) {
	start := time.Now()
	LogPhase("PHASE 1", "Master Planner đang đọc toàn bộ PDF để phân tích Dạng toán...")

	prompt := fmt.Sprintf(`TÀI LIỆU CẦN PHÂN TÍCH: Toàn bộ file PDF giáo trình đính kèm.

BẠN LÀ: Chuyên gia Sư phạm hàng đầu về "Trị mất gốc" và Thiết kế Phiếu học tập Vi kỹ năng (Micro-skills Scaffolding).

ĐỐI TƯỢNG HỌC SINH:
- Học sinh có học lực YẾU, MẤT GỐC, tiếp thu chậm, rất dễ bị ngợp và sợ hãi nếu gặp nhiều công thức cùng lúc.
- Triết lý giảng dạy: "LÀM CHẬM, LÀM KỸ, CHẮC CHẮN SẼ HIỂU" - Học sinh cần luyện phản xạ cơ bắp/thao tác tay lặp đi lặp lại trên từng công thức đơn lẻ trước khi ghép nối.

NHIỆM VỤ CỐT LÕI:
Thiết lập BẢN ĐỒ DẠNG TOÁN VI KỸ NĂNG (Atomic Skill Map).
Bóc tách toàn bộ tài liệu thành các dạng bài tập SIÊU NHỎ, TUYỆT ĐỐI KHÔNG GỘP BÀI.

TIÊU CHÍ CHẺ DẠNG TOÁN CHO HỌC SINH YẾU (BẮT BUỘC TUÂN THỦ):
1. NGUYÊN TẮC "MỘT THAO TÁC NÃO" (SINGLE COGNITIVE LOAD):
   - Mỗi dạng toán chỉ được rèn luyện ĐÚNG 1 CÔNG THỨC hoặc 1 QUY TẮC DUY NHẤT.
   - Nếu một bài toán yêu cầu kết hợp từ 2 bước tư duy trở lên -> BẮT BUỘC TÁCH THÀNH 2 DẠNG RIÊNG BIỆT để học sinh luyện từng bước một.

2. CÁC VÍ DỤ VỀ CÁCH CHẺ NHỎ KỸ NĂNG (THAM KHẢO PHONG CÁCH CHẺ DẠNG):
   - THAY VÌ GỘP: "Khái niệm và các phép toán cộng trừ vectơ"
     -> PHẢI CHẺ THÀNH:
        * Dạng: Nhận diện vectơ bằng nhau, vectơ đối trên hình hộp/hình chóp (chỉ nhìn hình nhận diện chiều mũi tên).
        * Dạng: Rút gọn tổng vectơ bằng quy tắc 3 điểm nối đuôi (chỉ luyện bài tập điền chữ cái AB + BC = AC).
        * Dạng: Quy tắc trừ chung gốc và kỹ thuật đổi dấu trừ thành cộng lật ngược vectơ.
        * Dạng: Áp dụng quy tắc hình bình hành và quy tắc hình hộp (bài tập điền khuyết từng bước).
   - THAY VÌ GỘP: "Tọa độ vectơ trong không gian Oxyz"
     -> PHẢI CHẺ THÀNH:
        * Dạng: Tính tọa độ vectơ bằng quy tắc nhẩm "Ngọn trừ Gốc" (lắp ghép các con số).
        * Dạng: Tính tọa độ trung điểm và trọng tâm tam giác (cộng chia đôi, cộng chia ba).
        * Dạng: Tích vô hướng và góc giữa hai vectơ (tính từng bước hoành nhân hoành, tung nhân tung...).
        * Dạng: Ứng dụng thực tế đơn giản (Bài toán rada máy bay, chuyển động theo vectơ).

QUY TRÌNH 2 BƯỚC THỰC HIỆN:
1. BƯỚC 1 (NHÁP TẠI "pedagogical_scratchpad"):
   - Quét từng bài học trong sách, phân tích xem học sinh yếu hay vấp ở thao tác nào để bẻ nhỏ thành các vi kỹ năng.
   👉 [ĐIỂM CHẠM 1]: TÍNH TOÁN PHÂN ĐOẠN TRANG CẮT FILE LIÊN TỤC:
     * Nháp luôn khoảng trang cho từng dạng để gom cả lý thuyết VÀ toàn bộ bài tập luyện tập sau nó.
     * Tự nháp dãy số trang liên tục không lỗ hổng, ví dụ: "Dạng 1: [1 -> ...], Dạng 2: [... -> ...], ..., Dạng cuối: [... -> Trang cuối]".

2. BƯỚC 2 (XUẤT "topics"):
   - Xuất toàn bộ danh sách các dạng vi kỹ năng đã bóc tách. Số lượng dạng sẽ tự nhiên tăng lên (khoảng 7 đến 10 dạng) tùy theo độ dài kiến thức của chương mà không cần gán cứng con số.
   - Định vị start_page và end_page bao phủ liên tục 100%% các trang tài liệu.

YÊU CẦU ĐẶT Ở CUỐI:
- Đặt tên dạng toán thật gần gũi, mô tả rõ hành động thao tác (VD: "Lắp ghép tọa độ", "Quy tắc nối đuôi 3 điểm", "Nhẩm ngọn trừ gốc...").
- TUYỆT ĐỐI KHÔNG đặt tên dạng theo bài học lớn SGK như "Bài 6: Vectơ trong không gian" hay "Ôn tập chương".
- QUY TẮC PHỦ KÍN 100%% SỐ TRANG (NGUYÊN TẮC CẮT BÁNH MÌ LIÊN TỤC):
   - Dạng 1 BẮT BUỘC bắt đầu từ trang 1.
   - Số trang phải nối tiếp nhau liên tục: start_page của dạng sau phải liền kề với end_page của dạng trước (không được để trống bất kỳ trang bài tập nào ở giữa).
   - Dạng cuối cùng BẮT BUỘC phải kết thúc ở đúng trang cuối cùng của tài liệu . Các bài tập ôn tập cuối chương phải được gom vào dạng kỹ năng tương ứng gần nó nhất.
Yêu cầu riêng của giáo viên: %s`, strings.TrimSpace(customPrompt))

	parts := []*genai.Part{
		{InlineData: &genai.Blob{MIMEType: "application/pdf", Data: pdfBytes}},
		{Text: prompt},
	}

	config := &genai.GenerateContentConfig{
		ResponseMIMEType: "application/json",
		ResponseSchema:   plannerSchema,
		// ThinkingConfig:   &genai.ThinkingConfig{
		// 	// Đặt Medium kết hợp với trường pedagogical_scratchpad là điểm ngọt tối ưu nhất
		// 	// (Nếu muốn thử max suy luận, bạn có thể đổi thành genai.ThinkingLevelHigh)
		// 	// ThinkingLevel: genai.ThinkingLevelMedium,
		// },
	}

	resp, err := c.generateWithRetry(ctx, modelName, []*genai.Content{{Parts: parts}}, config, 4)
	if err != nil {
		return nil, fmt.Errorf("lỗi gọi Planner: %w", err)
	}

	LogPhase("PHASE 1", "Nhận phản hồi thành công (Thời gian: %v)", time.Since(start))
	LogTokenUsage("PHASE 1", resp.UsageMetadata)

	var plan LessonPlan
	cleanJSON := strings.TrimSpace(resp.Text())
	if err := json.Unmarshal([]byte(cleanJSON), &plan); err != nil {
		return nil, fmt.Errorf("unmarshal Planner thất bại: %w (Raw: %s)", err, cleanJSON)
	}

	_ = SaveArtifact("phase1_plan.json", plan)
	LogPhase("PHASE 1", "Đã lưu kế hoạch vào .artifacts/phase1_plan.json (%d dạng toán)", len(plan.Topics))

	// Log ra nội dung nháp để bạn kiểm tra trí tuệ của AI
	if plan.PedagogicalScratchpad != "" {
		LogPhase("PHASE 1", "🧠 Bản nháp tư duy sư phạm của AI:\n%s", plan.PedagogicalScratchpad)
	}

	return &plan, nil
}

// -----------------------------------------------------------------------------
// PHASE 2: PARALLEL WORKERS VỚI CƠ CHẾ SELF-VERIFICATION PROTOCOL
// -----------------------------------------------------------------------------
func (c *Client) ExecutePhase2_Workers(ctx context.Context, modelName string, pdfPath string, plan *LessonPlan) ([]WorkerResult, error) {
	start := time.Now()
	LogPhase("PHASE 2", "Khởi động Workers song song cho %d dạng toán...", len(plan.Topics))

	results := make([]WorkerResult, len(plan.Topics))
	var g errgroup.Group

	for idx, topic := range plan.Topics {
		i := idx
		t := topic
		g.Go(func() error {
			wStart := time.Now()

			startPage := t.StartPage
			endPage := t.EndPage
			if startPage <= 0 {
				startPage = 1
			}
			if endPage < startPage {
				endPage = startPage
			}

			LogPhase(fmt.Sprintf("WORKER-%d", i+1), "Cắt trang [%d -> %d] cho dạng: %s", startPage, endPage, t.Title)

			var pageNums []int
			for p := startPage; p <= endPage; p++ {
				pageNums = append(pageNums, p)
			}

			chunkBytes, err := c.pdf.ExtractPages(ctx, pdfPath, pageNums)
			if err != nil {
				return fmt.Errorf("cắt trang dạng %s lỗi: %w", t.TopicID, err)
			}
			wPrompt := fmt.Sprintf(`TÀI LIỆU ĐÍNH KÈM: %d trang PDF bài học (từ trang %d đến trang %d).

CHỦ ĐỀ DẠNG TOÁN: "%s"
THAO TÁC CỐT LÕI CẦN RÈN LUYỆN: "%s"

BẠN LÀ: Giáo viên chuyên dạy học sinh MẤT GỐC / HỌC LỰC YẾU.
TRIẾT LÝ DẠY HỌC: "LÀM CHẬM, LÀM KỸ, LẶP ĐI LẶP LẠI SẼ THÀNH PHẢN XẠ".

HƯỚNG DẪN BIÊN SOẠN THEO THỨ TỰ (BẮT BUỘC TUÂN THỦ):

1. "theory_points" & "callout_tip": 
   - Lý thuyết thật ngắn gọn. Khẩu quyết dễ nhớ - mẹo làm bài cho học sinh áp dụng, có thể là mẹo bấm máy tính casio (VD: "Nối đuôi bỏ chữ giữa", "Ngọn trừ gốc").

2. "mcqs" (KHỞI ĐỘNG NHẬN BIẾT - 2 CÂU):
   - Đưa trắc nghiệm lên đầu làm phần khởi động nhẹ nhàng.
   - MỨC ĐỘ: CỰC KỲ CƠ BẢN. Chỉ hỏi nhận diện công thức hoặc tính nhẩm 1 bước trực tiếp để học sinh kiểm tra xem mình đã hiểu mặt chữ lý thuyết chưa.

3. "examples" (VÍ DỤ MẪU):
   - 1 ví dụ giải mẫu chi tiết "cầm tay chỉ việc".

4. "drills" (BÀI TẬP THỰC HÀNH LẶP LẠI - RẤT QUAN TRỌNG):
   - TUYỆT ĐỐI KHÔNG ra 4 ý là 4 dạng toán khác nhau!
   - BẮT BUỘC 4 đến 5 ý con (a, b, c, d, e) phải CHẠY CHUNG ĐÚNG 1 KHUÔN MẪU THAO TÁC (chỉ đổi tên chữ cái hoặc đổi số liệu, hoặc dạng điền khuyết từng bước) để học sinh làm đi làm lại cho quen tay.
   * VÍ DỤ VỀ BÀI TẬP LẶP LẠI (THAM KHẢO):
     + Dạng nối đuôi: Ý a rút gọn $\vec{XY} + \vec{YZ}$; Ý b rút gọn $\vec{MN} + \vec{NP} + \vec{PQ}$; Ý c rút gọn $\vec{AB} + \vec{BC} + \vec{CD}$...
     + Dạng ngọn trừ gốc: Cho điểm $A, B, C, D$. Ý a tính $\vec{AB}$; Ý b tính $\vec{BC}$; Ý c tính $\vec{CD}$; Ý d tính $\vec{DA}$...
     + Dạng điền khuyết: Từng bước 1, 2, 3 điền vào chỗ trống để hoàn thành chứng minh.

CÁC RÀNG BUỘC CÚ PHÁP BẮT BUỘC:
1. MỌI biến số, tọa độ, điểm, công thức toán BẮT BUỘC bọc trong cặp dấu $ ... $.
2. VECTƠ: Bắt buộc dùng cú pháp chuẩn $\vec{AB}$, $\vec{a}$, $\vec{0}$. TUYỆT ĐỐI KHÔNG dùng \b hay \bar.
3. JSON ESCAPE: Mọi lệnh LaTeX phải có 2 dấu gạch chéo ngược: "\\vec{...}", "\\frac{1}{2}", "\\sqrt{...}".`,
				len(pageNums), startPage, endPage, t.Title, t.CoreConcept)

			parts := []*genai.Part{
				{InlineData: &genai.Blob{MIMEType: "application/pdf", Data: chunkBytes}},
				{Text: wPrompt},
			}

			config := &genai.GenerateContentConfig{
				ResponseMIMEType: "application/json",
				ResponseSchema:   workerSchema,
				// ThinkingConfig: &genai.ThinkingConfig{
				// 	ThinkingLevel: genai.ThinkingLevelLow,
				// },
			}

			resp, err := c.client.Models.GenerateContent(ctx, modelName, []*genai.Content{{Parts: parts}}, config)
			if err != nil {
				return fmt.Errorf("worker %s lỗi: %w", t.TopicID, err)
			}

			// Chống nuốt gạch chéo trước khi Unmarshal
			sanitizedJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.Text()))

			var wResult WorkerResult
			if err := json.Unmarshal([]byte(sanitizedJSON), &wResult); err != nil {
				return fmt.Errorf("worker %s unmarshal lỗi: %w", t.TopicID, err)
			}

			wResult.TopicID = t.TopicID
			wResult.Title = t.Title
			results[i] = wResult

			tokensOut := 0
			if resp.UsageMetadata != nil {
				tokensOut = int(resp.UsageMetadata.CandidatesTokenCount)
			}

			LogPhase(fmt.Sprintf("WORKER-%d", i+1), "Hoàn thành sau %v (Tokens: %d)", time.Since(wStart), tokensOut)
			_ = SaveArtifact(fmt.Sprintf("phase2_worker_%s.json", t.TopicID), wResult)
			return nil
		})
	}

	if err := g.Wait(); err != nil {
		return nil, err
	}

	LogPhase("PHASE 2", "Toàn bộ %d Workers đã hoàn tất! Tổng thời gian: %v", len(results), time.Since(start))
	_ = SaveArtifact("phase2_all_results.json", results)
	return results, nil
}

// -----------------------------------------------------------------------------
// PHASE 3: TYPST CODE BUILDER (CHUẨN FONT LINUX/WSL, KHÔNG WARNING)
// -----------------------------------------------------------------------------
func (c *Client) ExecutePhase3_BuildTypst(plan *LessonPlan, workers []WorkerResult) (string, error) {
	LogPhase("PHASE 3", "Bắt đầu lắp ghép JSON từ Workers sang Typst code...")

	var sb strings.Builder
	anchorCount := 0

	// Prelude: Import MiTeX 0.2.7
	sb.WriteString(`#import "@preview/mitex:0.2.7": mitex, mi` + "\n\n")
	sb.WriteString(`#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"` + "\n\n")
	sb.WriteString(`#set page(paper: "a4", margin: (x: 1.8cm, top: 1.6cm, bottom: 1.8cm))` + "\n")
	// Chuẩn hóa font Linux/WSL (tránh unknown font warning)
	sb.WriteString(`#set text(font: ("DejaVu Sans", "Liberation Sans"), size: 10pt, lang: "vi")` + "\n")
	sb.WriteString(`#set par(justify: true, leading: 0.72em)` + "\n\n")

	// Macros Card
	sb.WriteString(`#let card(title: none, body) = block(fill: rgb("#f8fafc"), stroke: 1pt + rgb("#cbd5e1"), radius: 6pt, inset: 10pt, width: 100%, [
  #if title != none [ #text(weight: "bold", size: 11.5pt, fill: rgb("#0f766e"))[#title] \ #v(2pt) ]
  #body
])` + "\n\n")

	// Header bài học
	sb.WriteString(fmt.Sprintf(`
#align(center)[
  #if IS_TEACHER [
    #text(size: 17pt, weight: "bold", fill: rgb("#1e3a8a"))[GIÁO ÁN GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)]
  ] else [
    #text(size: 17pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU BÀI TẬP HỌC SINH]
  ]
  \ #v(2pt)
  #text(size: 13pt, weight: "bold")[%s] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[%s]
]
#v(6pt)
`, plan.LessonTitle, plan.Overview))

	// Duyệt qua từng Dạng toán
	for idx, w := range workers {
		sb.WriteString(fmt.Sprintf("\n// ==================== DẠNG %d: %s ====================\n", idx+1, w.Title))
		sb.WriteString(fmt.Sprintf("#v(8pt)\n#text(size: 13pt, weight: \"bold\", fill: rgb(\"#1e3a8a\"))[Dạng %d. %s]\n#v(3pt)\n", idx+1, w.Title))

		// 1. Lý thuyết & Ghi nhớ
		sb.WriteString(`#card(title: "I. Lý thuyết & Ghi nhớ")[
`)
		for tIdx, p := range w.TheoryPoints {
			sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|theory|%d\n", w.TopicID, tIdx))
			sb.WriteString(fmt.Sprintf("  - %s\n", LaTeXToMiTeX(p)))
			anchorCount++
		}
		if strings.TrimSpace(w.CalloutTip) != "" {
			sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|callout\n", w.TopicID))
			sb.WriteString(fmt.Sprintf(`  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] %s
  ]`+"\n", LaTeXToMiTeX(w.CalloutTip)))
			anchorCount++
		}
		if strings.TrimSpace(w.ClozeFormula) != "" {
			sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|cloze\n", w.TopicID))
			sb.WriteString(fmt.Sprintf("\n  - *Công thức cốt lõi:* %s\n", LaTeXToMiTeX(w.ClozeFormula)))
			anchorCount++
		}
		sb.WriteString("]\n#v(4pt)\n")

		// 2. 👉 DỜI TRẮC NGHIỆM LÊN THÀNH "II. Khởi động nhanh"
		if len(w.MCQs) > 0 {
			sb.WriteString(`#card(title: "II. Khởi động nhanh (Nhận biết cơ bản)")[
`)
			for mIdx, mc := range w.MCQs {
				sb.WriteString("  #block(width: 100%, breakable: false)[\n")
				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|mcq|%d|prompt\n", w.TopicID, mIdx))
				sb.WriteString(fmt.Sprintf("    *Câu %d.* %s\n    #v(2pt)\n    #grid(columns: (1fr, 1fr), row-gutter: 4pt,\n", mIdx+1, LaTeXToMiTeX(mc.Prompt)))
				anchorCount++

				for oIdx, opt := range mc.Options {
					sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|mcq|%d|opt|%d\n", w.TopicID, mIdx, oIdx))
					sb.WriteString(fmt.Sprintf("      [%s],\n", LaTeXToMiTeX(opt)))
					anchorCount++
				}
				sb.WriteString("    )\n")

				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|mcq|%d|solution\n", w.TopicID, mIdx))
				sb.WriteString(fmt.Sprintf(`    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: %s] - %s
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
`, mc.CorrectAnswer, LaTeXToMiTeX(mc.Solution)))
				anchorCount++
			}
			sb.WriteString("]\n#v(4pt)\n")
		}

		// 3. Ví dụ minh họa
		if len(w.Examples) > 0 {
			sb.WriteString(`#card(title: "III. Ví dụ minh họa")[
`)
			for eIdx, ex := range w.Examples {
				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|example|%d|problem\n", w.TopicID, eIdx))
				sb.WriteString(fmt.Sprintf(`  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[%s:] %s
`, ex.Title, LaTeXToMiTeX(ex.Problem)))

				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|example|%d|solution\n", w.TopicID, eIdx))
				sb.WriteString(fmt.Sprintf(`    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] %s
    ] else [ \ #v(16pt) ]
  ]`+"\n", LaTeXToMiTeX(ex.Solution)))
				anchorCount += 2
			}
			sb.WriteString("]\n#v(4pt)\n")
		}

		// 4. 👉 BÀI TẬP THỰC HÀNH LẶP LẠI (DRILLS) Ở CUỐI PHIẾU
		if len(w.Drills) > 0 {
			sb.WriteString(`#card(title: "IV. Bài tập thực hành lặp lại (Rèn phản xạ cơ bắp)")[
`)
			for dIdx, dr := range w.Drills {
				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|drill|%d|prompt\n", w.TopicID, dIdx))
				sb.WriteString(fmt.Sprintf("  %s\n", LaTeXToMiTeX(dr.Prompt)))
				anchorCount++

				for _, part := range dr.Parts {
					sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|drill|%d|part|%s|question\n", w.TopicID, dIdx, part.Label))
					sb.WriteString(fmt.Sprintf("  - *%s)* %s\n", part.Label, LaTeXToMiTeX(part.Question)))

					sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|drill|%d|part|%s|solution\n", w.TopicID, dIdx, part.Label))
					sb.WriteString(fmt.Sprintf(`    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: %s (Barem: %s)] \
    ]`+"\n", LaTeXToMiTeX(part.Solution), LaTeXToMiTeX(part.Rubric)))
					anchorCount += 2
				}
				sb.WriteString(`    #if not IS_TEACHER [
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 45pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]` + "\n")
			}
			sb.WriteString("]\n#v(6pt)\n")
		}

	}

	typstMarkup := sb.String()
	_ = SaveArtifact("phase3_lesson.typ", typstMarkup)
	LogPhase("PHASE 3", "Đã chèn chuẩn hóa thành công %d điểm neo @ANCHOR vào mã Typst.", anchorCount)
	return typstMarkup, nil
}

// -----------------------------------------------------------------------------
// PHASE 4: VÒNG LẶP SELF-HEALING ĐA TẦNG (TỰ ĐỘNG SỬA TẤT CẢ LỖI CASCADE)
// -----------------------------------------------------------------------------
var typstErrorRegex = regexp.MustCompile(`(?m)(?:phase3_lesson\.typ):(\d+):(\d+)`)

func findNearestAnchor(lines []string, startLineIdx int) string {
	if startLineIdx >= len(lines) {
		startLineIdx = len(lines) - 1
	}
	for i := startLineIdx; i >= 0; i-- {
		trimmed := strings.TrimSpace(lines[i])
		if strings.HasPrefix(trimmed, "// @ANCHOR:") {
			return strings.TrimSpace(strings.TrimPrefix(trimmed, "// @ANCHOR:"))
		}
	}
	return ""
}

func compileTypst(ctx context.Context, typPath, pdfPath string, isTeacher bool) (string, error) {
	val := "false"
	if isTeacher {
		val = "true"
	}
	cmd := exec.CommandContext(ctx, "typst", "compile", "--input", "teacher="+val, typPath, pdfPath)
	out, err := cmd.CombinedOutput()
	return string(out), err
}

func collectAuditViolations(workers []WorkerResult) []RepairItemRequest {
	var items []RepairItemRequest

	check := func(anchorID, contextPrompt, text string) {
		if ok, _ := AuditMathField(text); !ok {
			items = append(items, RepairItemRequest{
				AnchorID:      anchorID,
				ContextPrompt: contextPrompt,
				BrokenContent: text,
			})
		}
	}

	for _, w := range workers {
		for idx, tp := range w.TheoryPoints {
			check(fmt.Sprintf("%s|theory|%d", w.TopicID, idx), "Lý thuyết trọng tâm", tp)
		}
		check(fmt.Sprintf("%s|callout", w.TopicID), "Mẹo giải nhanh", w.CalloutTip)
		check(fmt.Sprintf("%s|cloze", w.TopicID), "Công thức cốt lõi", w.ClozeFormula)

		for eIdx, ex := range w.Examples {
			check(fmt.Sprintf("%s|example|%d|problem", w.TopicID, eIdx), ex.Title+" Đề bài", ex.Problem)
			check(fmt.Sprintf("%s|example|%d|solution", w.TopicID, eIdx), ex.Title+" Lời giải", ex.Solution)
		}

		for dIdx, dr := range w.Drills {
			check(fmt.Sprintf("%s|drill|%d|prompt", w.TopicID, dIdx), "Đề bài Drill", dr.Prompt)
			for _, p := range dr.Parts {
				check(fmt.Sprintf("%s|drill|%d|part|%s|question", w.TopicID, dIdx, p.Label), "Drill "+p.Label+" Đề bài", p.Question)
				check(fmt.Sprintf("%s|drill|%d|part|%s|solution", w.TopicID, dIdx, p.Label), "Drill "+p.Label+" Lời giải", p.Solution)
			}
		}

		for mIdx, mc := range w.MCQs {
			check(fmt.Sprintf("%s|mcq|%d|prompt", w.TopicID, mIdx), fmt.Sprintf("MCQ %d Đề bài", mIdx+1), mc.Prompt)
			for oIdx, opt := range mc.Options {
				check(fmt.Sprintf("%s|mcq|%d|opt|%d", w.TopicID, mIdx, oIdx), fmt.Sprintf("MCQ %d Lựa chọn", mIdx+1), opt)
			}
			check(fmt.Sprintf("%s|mcq|%d|solution", w.TopicID, mIdx), fmt.Sprintf("MCQ %d Lời giải", mIdx+1), mc.Solution)
		}
	}

	return items
}

func (c *Client) ExecutePhase4_CompilePDF(ctx context.Context, repairModel string, plan *LessonPlan, workers []WorkerResult) (string, string, error) {
	LogPhase("PHASE 4", "Bắt đầu kiểm định và biên dịch Typst...")

	typPath := filepath.Join(ArtifactDir, "phase3_lesson.typ")
	gvPDFPath := filepath.Join(ArtifactDir, "GIAO_AN_GIAO_VIEN.pdf")
	hsPDFPath := filepath.Join(ArtifactDir, "PHIEU_BAI_TAP_HOC_SINH.pdf")

	// 1. PRE-AUDIT VI ĐIỂM: Quét bộ nhớ RAM để tìm các trường bị hỏng trước khi biên dịch
	preAuditItems := collectAuditViolations(workers)
	if len(preAuditItems) > 0 {
		LogPhase("PHASE 4", "\033[33m[PRE-AUDIT] Phát hiện %d trường dữ liệu bị hỏng. Kích hoạt Batch Repair...\033[0m", len(preAuditItems))
		LogPhase("PHASE 4", "================== [BẮT ĐẦU GOM BATCH (%d MỤC)] ==================", len(preAuditItems))
		for bIdx, item := range preAuditItems {
			LogPhase("PHASE 4", "[%02d] Anchor: %s\n     Ngữ cảnh: %s\n     \033[33mNội dung lỗi:\033[0m %s",
				bIdx+1, item.AnchorID, item.ContextPrompt, item.BrokenContent)
		}
		LogPhase("PHASE 4", "==================================================================")

		fixedBatch, errRepair := c.callBatchRepairAgent(ctx, repairModel, preAuditItems)
		if errRepair != nil {
			return "", "", fmt.Errorf("gọi Gemini Pre-Audit Repair thất bại: %w", errRepair)
		}

		LogPhase("PHASE 4", "================== [KẾT QUẢ GEMINI TRẢ VỀ (%d MỤC)] ==================", len(fixedBatch))
		for fIdx, item := range fixedBatch {
			origContent := "(không rõ)"
			for _, bi := range preAuditItems {
				if bi.AnchorID == item.AnchorID {
					origContent = bi.BrokenContent
					break
				}
			}
			LogPhase("PHASE 4", "[%02d] Anchor: %s\n     \033[31m[TRƯỚC]:\033[0m %s\n     \033[32m[SAU]:\033[0m   %s",
				fIdx+1, item.AnchorID, origContent, item.FixedContent)
		}
		LogPhase("PHASE 4", "======================================================================")

		applyFixedBatch(workers, fixedBatch)
		_ = SaveArtifact("phase2_all_results.json", workers)
	}

	// 2. VÒNG LẶP BIÊN DỊCH VÀ TỰ ĐỘNG SỬA LỖI (Tối đa 4 vòng lặp cascade)
	maxRetries := 4
	var finalOut string
	var finalErr error

	for attempt := 1; attempt <= maxRetries; attempt++ {
		// Lắp ráp mã Typst
		markup, err := c.ExecutePhase3_BuildTypst(plan, workers)
		if err != nil {
			return "", "", fmt.Errorf("lỗi khởi tạo Typst markup lần %d: %w", attempt, err)
		}
		if err := os.WriteFile(typPath, []byte(markup), 0644); err != nil {
			return "", "", fmt.Errorf("lỗi ghi file typst: %w", err)
		}

		// Biên dịch thử bản Giáo Viên
		outGV, errGV := compileTypst(ctx, typPath, gvPDFPath, true)
		finalOut = outGV
		finalErr = errGV

		if errGV == nil {
			if attempt > 1 {
				LogPhase("PHASE 4", "\033[32m✅ Tự động phục hồi thành công sau %d lần sửa! PDF Giáo Viên đã được biên dịch chuẩn.\033[0m", attempt-1)
			} else {
				LogPhase("PHASE 4", "✅ Bản thảo Giáo Viên biên dịch thành công ngay lần đầu: %s", gvPDFPath)
			}
			break
		}

		// Nếu có lỗi biên dịch từ Typst
		LogPhase("PHASE 4", "\033[31m[LỖI BIÊN DỊCH TYPST (Lần %d)] Phát hiện lỗi cú pháp! Bắt đầu dò tìm @ANCHOR...\033[0m", attempt)
		LogPhase("PHASE 4", "Typst stderr:\n%s", outGV)

		lines := strings.Split(markup, "\n")
		seenAnchors := make(map[string]bool)
		var compilerErrorItems []RepairItemRequest

		// Quét tất cả các dòng báo lỗi của Typst
		for _, m := range typstErrorRegex.FindAllStringSubmatch(outGV, -1) {
			errLine, _ := strconv.Atoi(m[1])
			anchorID := findNearestAnchor(lines, errLine-1)
			if anchorID != "" && !seenAnchors[anchorID] {
				seenAnchors[anchorID] = true
				if reqItem := extractRepairContext(workers, anchorID); reqItem != nil {
					compilerErrorItems = append(compilerErrorItems, *reqItem)
				}
			}
		}

		if len(compilerErrorItems) == 0 {
			return "", "", fmt.Errorf("biên dịch Typst thất bại và không trích xuất được Anchor nào: %w (Log: %s)", errGV, outGV)
		}

		// Gửi các câu bị lỗi cho Gemini sửa
		LogPhase("PHASE 4", "================== [SỬA LỖI BIÊN DỊCH LẦN %d (%d MỤC)] ==================", attempt, len(compilerErrorItems))
		for bIdx, item := range compilerErrorItems {
			LogPhase("PHASE 4", "[%02d] Anchor: %s\n     Ngữ cảnh: %s\n     \033[33mNội dung lỗi:\033[0m %s",
				bIdx+1, item.AnchorID, item.ContextPrompt, item.BrokenContent)
		}
		LogPhase("PHASE 4", "======================================================================")

		fixedBatch, errRepair := c.callBatchRepairAgent(ctx, repairModel, compilerErrorItems)
		if errRepair != nil {
			return "", "", fmt.Errorf("sửa lỗi Typst compiler thất bại ở lần %d: %w", attempt, errRepair)
		}

		LogPhase("PHASE 4", "================== [KẾT QUẢ SỬA LỖI BIÊN DỊCH (%d MỤC)] ==================", len(fixedBatch))
		for fIdx, item := range fixedBatch {
			origContent := "(không rõ)"
			for _, bi := range compilerErrorItems {
				if bi.AnchorID == item.AnchorID {
					origContent = bi.BrokenContent
					break
				}
			}
			LogPhase("PHASE 4", "[%02d] Anchor: %s\n     \033[31m[TRƯỚC]:\033[0m %s\n     \033[32m[SAU]:\033[0m   %s",
				fIdx+1, item.AnchorID, origContent, item.FixedContent)
		}
		LogPhase("PHASE 4", "==========================================================================")

		// Cập nhật lại vào RAM và lưu file JSON
		applyFixedBatch(workers, fixedBatch)
		_ = SaveArtifact("phase2_all_results.json", workers)
	}

	if finalErr != nil {
		return "", "", fmt.Errorf("biên dịch Typst thất bại sau %d lần tự sửa: %w (Log: %s)", maxRetries, finalErr, finalOut)
	}

	// 3. Biên dịch bản Học sinh
	outHS, errHS := compileTypst(ctx, typPath, hsPDFPath, false)
	if errHS != nil {
		return "", "", fmt.Errorf("lỗi compile PDF Học Sinh: %w (Log: %s)", errHS, outHS)
	}
	LogPhase("PHASE 4", "✅ Bản thảo Học Sinh biên dịch thành công: %s", hsPDFPath)

	return gvPDFPath, hsPDFPath, nil
}

// -----------------------------------------------------------------------------
// HELPER: EXTRACT VÀ APPLY VÀO RAM QUA ANCHOR CHÍNH XÁC
// -----------------------------------------------------------------------------
func extractRepairContext(workers []WorkerResult, anchorID string) *RepairItemRequest {
	parts := strings.Split(anchorID, "|")
	if len(parts) < 2 {
		return nil
	}
	topicID := parts[0]
	kind := parts[1]

	var targetWorker *WorkerResult
	for i := range workers {
		if workers[i].TopicID == topicID {
			targetWorker = &workers[i]
			break
		}
	}
	if targetWorker == nil {
		return nil
	}

	switch kind {
	case "theory":
		if len(parts) >= 3 {
			tIdx, _ := strconv.Atoi(parts[2])
			if tIdx < len(targetWorker.TheoryPoints) {
				return &RepairItemRequest{
					AnchorID:      anchorID,
					ContextPrompt: fmt.Sprintf("Lý thuyết trọng tâm số %d (%s)", tIdx+1, targetWorker.Title),
					BrokenContent: targetWorker.TheoryPoints[tIdx],
				}
			}
		}
	case "callout":
		return &RepairItemRequest{
			AnchorID:      anchorID,
			ContextPrompt: fmt.Sprintf("Mẹo giải nhanh (%s)", targetWorker.Title),
			BrokenContent: targetWorker.CalloutTip,
		}
	case "cloze":
		return &RepairItemRequest{
			AnchorID:      anchorID,
			ContextPrompt: fmt.Sprintf("Công thức cốt lõi (%s)", targetWorker.Title),
			BrokenContent: targetWorker.ClozeFormula,
		}
	case "example":
		if len(parts) >= 4 {
			eIdx, _ := strconv.Atoi(parts[2])
			field := parts[3]
			if eIdx < len(targetWorker.Examples) {
				if field == "problem" {
					return &RepairItemRequest{
						AnchorID:      anchorID,
						ContextPrompt: fmt.Sprintf("Đề bài Ví dụ %d: %s", eIdx+1, targetWorker.Examples[eIdx].Title),
						BrokenContent: targetWorker.Examples[eIdx].Problem,
					}
				} else if field == "solution" {
					return &RepairItemRequest{
						AnchorID:      anchorID,
						ContextPrompt: fmt.Sprintf("Lời giải Ví dụ %d: %s", eIdx+1, targetWorker.Examples[eIdx].Problem),
						BrokenContent: targetWorker.Examples[eIdx].Solution,
					}
				}
			}
		}
	case "drill":
		if len(parts) >= 4 && parts[3] == "prompt" {
			dIdx, _ := strconv.Atoi(parts[2])
			if dIdx < len(targetWorker.Drills) {
				return &RepairItemRequest{
					AnchorID:      anchorID,
					ContextPrompt: fmt.Sprintf("Đề bài tổng quát Drill %d (%s)", dIdx+1, targetWorker.Title),
					BrokenContent: targetWorker.Drills[dIdx].Prompt,
				}
			}
		} else if len(parts) >= 6 && parts[3] == "part" {
			dIdx, _ := strconv.Atoi(parts[2])
			label := parts[4]
			field := parts[5]
			if dIdx < len(targetWorker.Drills) {
				for _, p := range targetWorker.Drills[dIdx].Parts {
					if p.Label == label {
						if field == "question" {
							return &RepairItemRequest{
								AnchorID:      anchorID,
								ContextPrompt: fmt.Sprintf("Drill %d Ý (%s) - Câu hỏi", dIdx+1, label),
								BrokenContent: p.Question,
							}
						} else if field == "solution" {
							return &RepairItemRequest{
								AnchorID:      anchorID,
								ContextPrompt: fmt.Sprintf("Drill %d Ý (%s) - Lời giải", dIdx+1, label),
								BrokenContent: p.Solution,
							}
						}
					}
				}
			}
		}
	case "mcq":
		if len(parts) >= 4 {
			mIdx, _ := strconv.Atoi(parts[2])
			sub := parts[3]
			if mIdx < len(targetWorker.MCQs) {
				switch sub {
				case "prompt":
					return &RepairItemRequest{
						AnchorID:      anchorID,
						ContextPrompt: fmt.Sprintf("Trắc nghiệm Câu %d - Đề bài", mIdx+1),
						BrokenContent: targetWorker.MCQs[mIdx].Prompt,
					}
				case "opt":
					if len(parts) >= 5 {
						oIdx, _ := strconv.Atoi(parts[4])
						if oIdx < len(targetWorker.MCQs[mIdx].Options) {
							return &RepairItemRequest{
								AnchorID:      anchorID,
								ContextPrompt: fmt.Sprintf("Trắc nghiệm Câu %d - Lựa chọn số %d", mIdx+1, oIdx+1),
								BrokenContent: targetWorker.MCQs[mIdx].Options[oIdx],
							}
						}
					}
				case "solution":
					return &RepairItemRequest{
						AnchorID:      anchorID,
						ContextPrompt: fmt.Sprintf("Trắc nghiệm Câu %d - Lời giải chi tiết", mIdx+1),
						BrokenContent: targetWorker.MCQs[mIdx].Solution,
					}
				}
			}
		}
	}
	return nil
}

func applyFixedBatch(workers []WorkerResult, fixedItems []RepairedItemResponse) {
	for _, item := range fixedItems {
		parts := strings.Split(item.AnchorID, "|")
		if len(parts) < 2 {
			continue
		}
		topicID := parts[0]
		kind := parts[1]

		for i := range workers {
			if workers[i].TopicID == topicID {
				switch kind {
				case "theory":
					if len(parts) >= 3 {
						tIdx, _ := strconv.Atoi(parts[2])
						if tIdx < len(workers[i].TheoryPoints) {
							workers[i].TheoryPoints[tIdx] = item.FixedContent
						}
					}
				case "callout":
					workers[i].CalloutTip = item.FixedContent
				case "cloze":
					workers[i].ClozeFormula = item.FixedContent
				case "example":
					if len(parts) >= 4 {
						eIdx, _ := strconv.Atoi(parts[2])
						field := parts[3]
						if eIdx < len(workers[i].Examples) {
							if field == "problem" {
								workers[i].Examples[eIdx].Problem = item.FixedContent
							} else if field == "solution" {
								workers[i].Examples[eIdx].Solution = item.FixedContent
							}
						}
					}
				case "drill":
					if len(parts) >= 4 && parts[3] == "prompt" {
						dIdx, _ := strconv.Atoi(parts[2])
						if dIdx < len(workers[i].Drills) {
							workers[i].Drills[dIdx].Prompt = item.FixedContent
						}
					} else if len(parts) >= 6 && parts[3] == "part" {
						dIdx, _ := strconv.Atoi(parts[2])
						label := parts[4]
						field := parts[5]
						if dIdx < len(workers[i].Drills) {
							for pIdx := range workers[i].Drills[dIdx].Parts {
								if workers[i].Drills[dIdx].Parts[pIdx].Label == label {
									if field == "question" {
										workers[i].Drills[dIdx].Parts[pIdx].Question = item.FixedContent
									} else if field == "solution" {
										workers[i].Drills[dIdx].Parts[pIdx].Solution = item.FixedContent
									}
								}
							}
						}
					}
				case "mcq":
					if len(parts) >= 4 {
						mIdx, _ := strconv.Atoi(parts[2])
						sub := parts[3]
						if mIdx < len(workers[i].MCQs) {
							switch sub {
							case "prompt":
								workers[i].MCQs[mIdx].Prompt = item.FixedContent
							case "opt":
								if len(parts) >= 5 {
									oIdx, _ := strconv.Atoi(parts[4])
									if oIdx < len(workers[i].MCQs[mIdx].Options) {
										workers[i].MCQs[mIdx].Options[oIdx] = item.FixedContent
									}
								}
							case "solution":
								workers[i].MCQs[mIdx].Solution = item.FixedContent
							}
						}
					}
				}
				break
			}
		}
	}
}

func (c *Client) callBatchRepairAgent(ctx context.Context, modelName string, items []RepairItemRequest) ([]RepairedItemResponse, error) {
	reqData, _ := json.MarshalIndent(RepairBatchRequest{Items: items}, "", "  ")

	prompt := fmt.Sprintf(`Bạn là Chuyên gia Cú pháp Toán học LaTeX.
Dưới đây là danh sách các mục bị lỗi hiển thị công thức toán khi biên dịch sang Typst (thiếu $, sai lệnh như \b{...}, hoặc ngoặc \{ sai).

NHIỆM VỤ:
1. Phục hồi và sửa lại cú pháp trong "broken_content" thành cú pháp LaTeX chuẩn.
2. MỌI CÔNG THỨC TOÁN, VECTƠ, PHÂN SỐ, BIẾN SỐ BẮT BUỘC ĐƯỢC BỌC TRONG CẶP DẤU $...$.
3. KÝ HIỆU VECTƠ: Bắt buộc dùng \vec{...} (VD: $\vec{AB}$, $\vec{a}$, $\vec{b}$). TUYỆT ĐỐI KHÔNG dùng \b{...} hay \bar{...}.
4. ĐỐI VỚI DẤU PHẨY ĐỈNH (VD: AD', AA'): Dùng $\vec{AD}'$ hoặc $\vec{AD'}$, TUYỆT ĐỐI KHÔNG dùng \{AA}'.
5. Giữ nguyên vẹn toàn bộ câu chữ tiếng Việt tự nhiên và ngữ nghĩa ban đầu.

Danh sách cần sửa:
%s`, string(reqData))

	config := &genai.GenerateContentConfig{
		ResponseMIMEType: "application/json",
		ResponseSchema:   repairSchema,
	}

	startReq := time.Now()
	resp, err := c.client.Models.GenerateContent(ctx, modelName, []*genai.Content{{Parts: []*genai.Part{{Text: prompt}}}}, config)
	if err != nil {
		return nil, err
	}
	LogPhase("PHASE 4", "Gemini Repair Agent phản hồi sau %v", time.Since(startReq))

	rawText := strings.TrimSpace(resp.Text())
	var res RepairBatchResponse
	if err := json.Unmarshal([]byte(rawText), &res); err != nil {
		return nil, fmt.Errorf("unmarshal Repair Agent thất bại: %w (Raw: %s)", err, rawText)
	}
	return res.RepairedItems, nil
}
