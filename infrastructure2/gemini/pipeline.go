package gemini

import (
	"context"
	"encoding/json"
	"fmt"
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
	plannerSchema      *genai.Schema
	deltaPlannerSchema *genai.Schema
	workerSchema       *genai.Schema
	repairSchema       *genai.Schema
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

	// 1b. Schema cho Delta Planner
	dpSch := r.Reflect(&DeltaTopicResponse{})
	dpData, _ := json.Marshal(dpSch)
	deltaPlannerSchema = &genai.Schema{}
	_ = json.Unmarshal(dpData, deltaPlannerSchema)

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

func WorkerSchema() *genai.Schema {
	return workerSchema
}

// -----------------------------------------------------------------------------
// BỘ PARSER VÀ SANITIZER LATEX SANG MITEX
// -----------------------------------------------------------------------------
var (
	blockMathRegex  = regexp.MustCompile(`(?s)\$\$([^\$]+)\$\$`)
	inlineMathRegex = regexp.MustCompile(`\$([^\$\r\n]+)\$`)

	// Bắt MỌI dấu backslash đơn (\) đứng trước từ khóa LaTeX (từ 2 chữ cái trở lên)
	// để không bao giờ bị trùng với \t, \b, \f, \n, \r đơn lẻ của JSON
	unescapedLatexGenericRegex = regexp.MustCompile(`(^|[^\\])\\([a-zA-Z]{2,})`)

	// Xử lý bảo vệ các lệnh LaTeX 1 chữ cái nếu có đứng trước ngoặc nhọn (như \d{x}, \b{x}) bằng cách escape dấu backslash
	singleCharCmdRegex = regexp.MustCompile(`(^|[^\\])\\([a-zA-Z])\{`)

	// Chuẩn hóa \overline{AB} hoặc \overrightarrow{AB} về \vec{AB} cho đồng nhất với MiTeX (chỉ áp dụng cho đoạn thẳng có hướng 2-3 chữ cái in hoa/phẩy)
	normalizeVecRegex = regexp.MustCompile(`\\\\(?:overline|overrightarrow)\{([A-Z][']?[A-Z][']?)\}`)

	// Khắc phục lỗi gõ nhầm backslash trước biến số đơn đứng trước lệnh LaTeX (như \a\sqrt{3} -> a\sqrt{3})
	typoVarBackslashRegex = regexp.MustCompile(`(^|[^\\])\\([a-zA-Z])\s*\\([a-zA-Z]{2,})`)

	// Khắc phục lỗi AI gõ backslash trước tên đỉnh hoặc tên đa giác (như \AOB -> AOB, \ABCD -> ABCD)
	uppercasePolyRegex = regexp.MustCompile(`\\([A-Z]{2,})\b`)

	// Khắc phục lỗi gõ nhầm backslash trước biến số đơn lẻ trong toán (như \F_1 -> F_1, \a \sqrt -> a \sqrt)
	singleLetterMathRegex = regexp.MustCompile(`(^|[^\\])\\([a-zA-Z])([^a-zA-Z{]|$)`)
)

// SanitizeRawJSONLaTeX bảo vệ các lệnh LaTeX không bị Go JSON parser nuốt thành mã điều khiển
func SanitizeRawJSONLaTeX(raw string) string {
	raw = strings.TrimSpace(raw)
	if strings.HasPrefix(raw, "```") {
		if idx := strings.Index(raw, "\n"); idx != -1 {
			raw = raw[idx+1:]
		}
		if idx := strings.LastIndex(raw, "```"); idx != -1 {
			raw = raw[:idx]
		}
		raw = strings.TrimSpace(raw)
	}

	// Trích xuất chính xác khối JSON nằm giữa cặp ngoặc { ... } hoặc [ ... ]
	startBrace := strings.Index(raw, "{")
	startBracket := strings.Index(raw, "[")
	if startBrace != -1 && (startBracket == -1 || startBrace < startBracket) {
		endBrace := strings.LastIndex(raw, "}")
		if endBrace > startBrace {
			raw = raw[startBrace : endBrace+1]
		}
	} else if startBracket != -1 {
		endBracket := strings.LastIndex(raw, "]")
		if endBracket > startBracket {
			raw = raw[startBracket : endBracket+1]
		}
	}

	// 1. Chạy 2 lần liên tiếp để xử lý cả trường hợp 2 lệnh sát nhau như \text\vec hoặc lồng nhau \text{\vec
	escaped := unescapedLatexGenericRegex.ReplaceAllString(raw, `$1\\$2`)
	escaped = unescapedLatexGenericRegex.ReplaceAllString(escaped, `$1\\$2`)

	// 2. Bảo vệ các lệnh LaTeX 1 chữ cái nếu có (như \d{x}, \b{x}) bằng cách escape thành \\$2{
	escaped = singleCharCmdRegex.ReplaceAllString(escaped, `$1\\$2{`)

	// 3. Tự động đổi \\overline{AB} và \\overrightarrow{AB} thành \\vec{AB} (chỉ khi là đoạn thẳng có hướng 2-3 chữ in hoa)
	escaped = normalizeVecRegex.ReplaceAllString(escaped, `\\vec{$1}`)

	// 4. Khắc phục lỗi JSON nuốt mất backslash thành mã điều khiển ASCII: \r\rightarrow -> \x0Dightarrow, \n\neq -> \x0Aeq
	escaped = strings.ReplaceAll(escaped, "\x0Dightarrow", `\\rightarrow`)
	escaped = strings.ReplaceAll(escaped, "\x0Aeq ", `\\neq `)
	escaped = strings.ReplaceAll(escaped, "\x0Aeq", `\\neq `)
	escaped = strings.ReplaceAll(escaped, "\x0Deftrightarrow", `\\Leftrightarrow`)
	escaped = strings.ReplaceAll(escaped, "\x0DRightarrow", `\\Rightarrow`)

	return escaped
}

// RepairTruncatedJSON tự động đóng ngoặc và hoàn chỉnh chuỗi JSON bị ngắt cụt do chạm trần token
func RepairTruncatedJSON(raw string) string {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return raw
	}

	inString := false
	var escaped bool

	for i := 0; i < len(raw); i++ {
		c := raw[i]
		if c == '\\' && inString {
			escaped = !escaped
			continue
		}
		if c == '"' && !escaped {
			inString = !inString
		}
		escaped = false
	}

	if inString {
		raw += `"`
	}

	var stack []rune
	inString = false
	escaped = false

	for _, r := range raw {
		if r == '\\' && inString {
			escaped = !escaped
			continue
		}
		if r == '"' && !escaped {
			inString = !inString
		}
		if !inString {
			if r == '{' || r == '[' {
				stack = append(stack, r)
			} else if r == '}' {
				if len(stack) > 0 && stack[len(stack)-1] == '{' {
					stack = stack[:len(stack)-1]
				}
			} else if r == ']' {
				if len(stack) > 0 && stack[len(stack)-1] == '[' {
					stack = stack[:len(stack)-1]
				}
			}
		}
		escaped = false
	}

	var closer strings.Builder
	for i := len(stack) - 1; i >= 0; i-- {
		if stack[i] == '{' {
			closer.WriteString("}")
		} else if stack[i] == '[' {
			closer.WriteString("]")
		}
	}

	return raw + closer.String()
}

func LaTeXToMiTeX(content string) string {
	content = strings.TrimSpace(content)
	if content == "" {
		return ""
	}

	// 1. Chuyển $$...$$ sang block mitex
	content = blockMathRegex.ReplaceAllStringFunc(content, func(m string) string {
		latex := strings.Trim(m, "$")
		return fmt.Sprintf("\n#align(center)[#mitex(`%s`)]\n", strings.TrimSpace(latex))
	})

	// 2. Vá nhanh từng dòng độc lập nếu số lượng $ trên dòng đó bị lẻ (đảm bảo $ không bao giờ tràn qua dòng mới)
	lines := strings.Split(content, "\n")
	for i, line := range lines {
		if strings.Count(line, "$")%2 != 0 {
			lines[i] = line + "$"
		}
	}
	content = strings.Join(lines, "\n")

	// 3. Chuyển $...$ nội dòng sang inline mi(`...`)
	content = inlineMathRegex.ReplaceAllStringFunc(content, func(m string) string {
		latex := strings.Trim(m, "$")
		latex = strings.TrimSpace(latex)
		if latex == "" {
			return ""
		}
		// Làm sạch triệt để dấu xuống dòng vô tình lọt vào chuỗi inline math
		latex = strings.ReplaceAll(latex, "\n", " ")

		return fmt.Sprintf(" #mi(`%s`) ", latex)
	})

	// Escape các ký tự đặc biệt Typst nếu còn sót ngoài toán
	content = strings.ReplaceAll(content, "$", `\$`)
	return content
}

// FormatFinalNumber chuẩn hóa con số kết quả cuối cùng (hỗ trợ cả số thuần và biểu thức toán/vectơ)
func FormatFinalNumber(fn string) string {
	fn = strings.TrimSpace(fn)
	if fn == "" {
		return ""
	}
	// Nếu chứa lệnh LaTeX (\sqrt, \vec, \frac...) hoặc toán tử mũ/chỉ số mà chưa bọc $, tự bọc $
	if !strings.Contains(fn, "$") && (strings.Contains(fn, `\`) || strings.Contains(fn, "^") || strings.Contains(fn, "_")) {
		fn = "$" + fn + "$"
	}
	return LaTeXToMiTeX(fn)
}

// -----------------------------------------------------------------------------
// AUDITOR: CHỈ BẮT LỖI HỎNG THỰC SỰ (ASCII RÁC, LỆCH $, LATEX TRẦN)
// -----------------------------------------------------------------------------
var leakedLatexCmdRegex = regexp.MustCompile(`\\(?:frac|forall|vec|overrightarrow|overline|widehat|sqrt|neq|nabla|bar|beta|begin|binom|to|times|text|tan|theta|triangle|right|rightarrow|rho|cdot|perp|alpha|gamma|delta|Delta|varphi|pi|omega|leq|geq|approx|left|end|mathbf|mathrm|mathbb|mathcal|cos|sin|cot|log|ln|lim|sum|int|infty|pm|mp|cap|cup|subset|supset|in|notin|emptyset|Rightarrow|Leftrightarrow|iff|implies|angle|parallel)\b`)

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

// Helper lấy KeyPool từ Client
func (c *Client) getPool(ctx context.Context) (*KeyPool, error) {
	if c.pool != nil && len(c.pool.slots) > 0 {
		return c.pool, nil
	}
	if c.client != nil {
		return &KeyPool{
			slots: []*KeySlot{
				{index: 1, client: c.client},
			},
			staggerDelay: 1800 * time.Millisecond,
		}, nil
	}
	return nil, fmt.Errorf("không có API client hoặc KeyPool nào")
}

// -----------------------------------------------------------------------------
// TẦNG 0: BUILD SHARED PDF PREFIX (IMPLICIT CACHE CHO GEMMA 4)
// -----------------------------------------------------------------------------

// BuildSharedPDFPrefixParts đóng gói cố định các file PDF ở đầu mảng Parts để kích hoạt Implicit Prefix Caching
func BuildSharedPDFPrefixParts(docs []PDFDocumentInput) []*genai.Part {
	var parts []*genai.Part
	// LƯU Ý QUAN TRỌNG CHO GEMMA 4:
	// Đặt toàn bộ các Blob PDF nối tiếp nhau ở ngay đầu mảng Parts (trước mọi Text)
	// để Vision/PDF Encoder của Gemma 4 tạo 1 khối KV-Cache liền mạch.
	for _, doc := range docs {
		parts = append(parts, &genai.Part{
			InlineData: &genai.Blob{
				MIMEType: "application/pdf",
				Data:     doc.Data,
			},
		})
	}

	// Sau khi kết thúc toàn bộ các Blob PDF mới thêm 1 Part Text định danh thứ tự tài liệu
	var manifest strings.Builder
	manifest.WriteString("DANH MỤC CÁC FILE PDF ĐÍNH KÈM THEO THỨ TỰ Ở TRÊN:\n")
	for idx, doc := range docs {
		manifest.WriteString(fmt.Sprintf("- Tài liệu thứ %d: Mã [%s] | Tên file: \"%s\" | Vai trò: %s\n",
			idx+1, doc.DocID, doc.FileName, doc.RoleHint))
	}
	parts = append(parts, &genai.Part{Text: manifest.String()})
	return parts
}

// -----------------------------------------------------------------------------
// PHASE 1: MASTER SYNTHESIZER & PLANNER (MULTI-PDF SYNTHESIS)
// -----------------------------------------------------------------------------

func (c *Client) ExecutePhase1_Planner(
	ctx context.Context,
	modelName string,
	docs []PDFDocumentInput,
	customPrompt string,
) (*LessonPlan, error) {
	start := time.Now()
	LogPhase("PHASE 1", "Master Planner đang đọc đồng thời %d file PDF để tổng hợp và phân dạng...", len(docs))

	pool, err := c.getPool(ctx)
	if err != nil {
		return nil, err
	}

	prefixParts := BuildSharedPDFPrefixParts(docs)

	prompt := fmt.Sprintf(`BẠN LÀ: Chuyên gia Sư phạm Toán học THPT và Thiết kế Giáo án theo Chương trình GDPT 2018.

NHIỆM VỤ: Phân tích %d tài liệu học tập đính kèm theo phương pháp BOTTOM-UP (Quét từ bài tập suy ra dạng) để lập danh sách ĐẦY ĐỦ TẤT CẢ CÁC DẠNG TOÁN chuyên sâu.

======================================================================
QUY TẮC SỐ 1: QUÉT HẠT MỊN THEO CỤM Ở "question_catalog" (KIỂM SOÁT TOKEN)
======================================================================
- Quét lần lượt từng phần của mọi file PDF: Lý thuyết/Ví dụ (VD1, VD2...), Trắc nghiệm 4 lựa chọn (C1, C2...), Trắc nghiệm Đúng/Sai (D1, D2...), Trả lời ngắn/Tự luận (E1, E2...).
- Trong "question_catalog", gom các câu có CÙNG MỤC TIÊU VÀ PHƯƠNG PHÁP vào từng cụm (mỗi cụm từ 3 đến 8 mã câu, ví dụ: ["C1", "C2", "C3", "C4", "C5"], ["D1", "D2", "D3", "D4"], ["E5", "E6", "E7", "E8"]).
- CẤM ghi dải gộp kiểu ["C1..C56"] hay ["E1..E24"] (phải liệt kê rõ từng mã câu trong mảng).
- Với câu hỏi Đúng/Sai, dùng mã câu gốc D1, D2, D3... TUYỆT ĐỐI KHÔNG chẻ nhỏ thành D1a, D1b, D1c, D1d vì làm tràn giới hạn token.
- Toàn bộ "question_catalog" nên nằm gọn trong khoảng 12 đến 16 cụm để dành đủ hơn 5.000 token cho "topics".

======================================================================
QUY TẮC SỐ 2: TIÊU CHÍ TÁCH DẠNG TOÁN CHUYÊN SÂU (ANTI-LUMPING RULES)
======================================================================
Hai câu hỏi BẮT BUỘC phải tách thành 2 DẠNG TOÁN ("topics") RIÊNG BIỆT nếu chúng khác nhau ở BẤT KỲ tiêu chí nào sau đây:
1. KHÁC ĐỐI TƯỢNG ĐÍCH ("target_output"):
   - Ví dụ: Cần tìm hai đại lượng hoặc giải quyết hai yêu cầu toán học khác nhau (như tính góc vs tính khoảng cách; tìm tập xác định vs tìm cực trị; chứng minh đẳng thức vs tìm tham số m...).
2. KHÁC MÔ HÌNH / PHƯƠNG PHÁP / CẤU HÌNH ĐẶC TRƯNG ("core_method"):
   - Ví dụ: Cùng một phép toán nhưng áp dụng trên cấu hình đặc biệt, dạng hàm số đặc thù hoặc có hệ thức giải nhanh riêng thì mỗi cấu hình/dạng thức đặc trưng PHẢI LÀ 1 DẠNG RIÊNG.
3. KHÁC BỐI CẢNH ỨNG DỤNG:
   - Các bài toán thực tế (Vật lý, Hóa học, Sinh học, Kinh tế) và các bài toán Cực trị / Tối ưu hóa (Max/Min) BẮT BUỘC phải tách thành các Dạng riêng biệt ở cuối bài.
4. GIỚI HẠN QUY MÔ MỖI DẠNG (CHỐNG GOM GỘP LƯỜI BIẾNG):
   - Mỗi Topic chỉ được chứa tối đa 8–10 mã câu hỏi trong "assigned_question_ids".
   - Nếu một nhóm có trên 10 câu hỏi, BẮT BUỘC chẻ nhỏ thành 2 dạng theo mức độ nhận thức (Cơ bản vs Vận dụng) hoặc theo cấu hình/dạng toán con.
5. BAO PHỦ VÉT CẠN CẢ CÂU HỎI ĐÚNG/SAI (D...) VÀ TRẢ LỜI NGẮN (E...):
   - Không được bỏ sót bất kỳ câu nào ở cuối file PDF. Mọi mã câu trong "question_catalog" đều phải xuất hiện trong "assigned_question_ids" của ít nhất 1 Topic.

Yêu cầu riêng của giáo viên: %s`, len(docs), strings.TrimSpace(customPrompt))

	// Ghép Prefix cố định + Prompt của Phase 1
	parts := append(append([]*genai.Part{}, prefixParts...), &genai.Part{Text: prompt})

	config := &genai.GenerateContentConfig{
		Temperature:      genai.Ptr[float32](0.2), // Nhiệt độ thấp để phân trang và gom nhóm chính xác
		MaxOutputTokens:  8192,
		ResponseMIMEType: "application/json",
		ResponseSchema:   plannerSchema,
		ThinkingConfig: &genai.ThinkingConfig{
			ThinkingLevel: genai.ThinkingLevelMinimal,
		},
	}

	resp, err := pool.GenerateContent(ctx, modelName, []*genai.Content{{Parts: parts}}, config, 4)
	if err != nil {
		return nil, fmt.Errorf("lỗi gọi Planner: %w", err)
	}

	LogPhase("PHASE 1", "Nhận phản hồi thành công (Thời gian: %v)", time.Since(start))
	LogTokenUsage("PHASE 1", resp.UsageMetadata)

	var plan LessonPlan
	cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.Text()))
	if err := json.Unmarshal([]byte(cleanJSON), &plan); err != nil {
		repaired := RepairTruncatedJSON(cleanJSON)
		if errRep := json.Unmarshal([]byte(repaired), &plan); errRep == nil && len(plan.Topics) > 0 {
			LogPhase("PHASE 1", "\033[32m  ↳ [JSON HEALER] Đã tự động cứu hộ chuỗi JSON của Planner thành công!\033[0m")
		} else {
			return nil, fmt.Errorf("unmarshal Planner thất bại: %w (Raw: %s)", err, cleanJSON)
		}
	}

	LogPhase("PHASE 1", "📋 Danh mục câu hỏi hạt mịn: %d mục catalog", len(plan.QuestionCatalog))
	_ = SaveArtifact("phase1_plan.json", plan)
	LogPhase("PHASE 1", "Đã lưu kế hoạch ban đầu vào %s/phase1_plan.json (%d dạng toán)", ArtifactDir, len(plan.Topics))

	// KIỂM ĐỊNH TẬP HỢP TỰ ĐỘNG BẰNG GO (DETERMINISTIC COVERAGE GATE)
	unassignedIDs, overloadedTopics := AuditPlanIssues(&plan)

	if len(unassignedIDs) > 0 || len(overloadedTopics) > 0 {
		LogPhase("PHASE 1", "\033[33m[COVERAGE GATE] Phát hiện %d mã câu chưa phân dạng và %d dạng bị gộp quá tải. Kích hoạt Delta-Planner...\033[0m",
			len(unassignedIDs), len(overloadedTopics))

		deltaTopics, errDelta := c.runDeltaPlanner(ctx, modelName, prefixParts, &plan, unassignedIDs, overloadedTopics)
		if errDelta != nil {
			LogPhase("PHASE 1", "\033[31m[CẢNH BÁO] Delta-Planner lỗi: %v (Tiếp tục với kế hoạch ban đầu)\033[0m", errDelta)
		} else if len(deltaTopics) > 0 {
			// Nếu có Topic bị quá tải đã được tách nhỏ, loại bỏ Topic gộp cũ và thay bằng các Topic chi tiết mới
			if len(overloadedTopics) > 0 {
				overloadedMap := make(map[string]bool)
				for _, ot := range overloadedTopics {
					overloadedMap[ot.TopicID] = true
				}
				var filtered []Topic
				for _, existing := range plan.Topics {
					if !overloadedMap[existing.TopicID] {
						filtered = append(filtered, existing)
					}
				}
				plan.Topics = filtered
			}

			// Nối các dạng toán mới bổ sung và đánh lại số thứ tự dang_1..dang_N
			plan.Topics = append(plan.Topics, deltaTopics...)
			for idx := range plan.Topics {
				plan.Topics[idx].TopicID = fmt.Sprintf("dang_%d", idx+1)
			}
			LogPhase("PHASE 1", "\033[32m✅ Delta-Planner đã bổ sung/tách thành công! Tổng số dạng toán hiện tại: %d dạng.\033[0m", len(plan.Topics))
			_ = SaveArtifact("phase1_plan.json", plan)
		}
	}

	return &plan, nil
}

var questionIDPattern = regexp.MustCompile(`(?i)^([A-Za-z]+)(\d+)([A-Za-z]?)$`)

// AuditPlanIssues kiểm tra toán học trên LessonPlan để tìm:
// 1. Các mã câu hỏi có trong Catalog hoặc bị thủng lỗ trong dãy số (VD: có E1, E24 nhưng thiếu E5..E19) chưa được gán vào Topic nào.
// 2. Các Topic bị "gom gộp lười biếng" (chứa > 12 câu hỏi trong 1 Topic).
func AuditPlanIssues(plan *LessonPlan) (unassignedIDs []string, overloadedTopics []Topic) {
	catalogSet := make(map[string]string) // questionID -> mô tả ngắn từ catalog
	prefixMaxNum := make(map[string]int)  // "C" -> 56, "D" -> 10, "E" -> 24

	for _, item := range plan.QuestionCatalog {
		for _, qid := range item.QuestionIDs {
			qid = strings.TrimSpace(strings.ToUpper(qid))
			if qid == "" {
				continue
			}
			catalogSet[qid] = fmt.Sprintf("[%s] %s (%s)", item.DocID, item.TargetOutput, item.CoreMethod)
			if m := questionIDPattern.FindStringSubmatch(qid); len(m) >= 3 {
				prefix := strings.ToUpper(m[1])
				num, _ := strconv.Atoi(m[2])
				if num > prefixMaxNum[prefix] && num <= 200 {
					prefixMaxNum[prefix] = num
				}
			}
		}
	}

	// Tập hợp tất cả các mã câu hỏi đã được phân vào các Topics
	assignedSet := make(map[string]bool)
	baseAssigned := make(map[string]bool) // Hỗ trợ cả khi gán D1 hoặc D1a
	for _, t := range plan.Topics {
		for _, qid := range t.AssignedQuestionIDs {
			qid = strings.TrimSpace(strings.ToUpper(qid))
			assignedSet[qid] = true
			if m := questionIDPattern.FindStringSubmatch(qid); len(m) >= 3 {
				prefix := strings.ToUpper(m[1])
				num, _ := strconv.Atoi(m[2])
				if num > prefixMaxNum[prefix] && num <= 200 {
					prefixMaxNum[prefix] = num
				}
				baseID := fmt.Sprintf("%s%d", prefix, num)
				baseAssigned[baseID] = true
			}
		}
		// Phát hiện Topic bị gom gộp lười biếng (ôm quá 12 câu hỏi)
		if len(t.AssignedQuestionIDs) > 12 {
			overloadedTopics = append(overloadedTopics, t)
		}
	}

	// 1. Kiểm tra các câu có trong QuestionCatalog nhưng quên đưa vào Topics
	seenMissing := make(map[string]bool)
	for qid, desc := range catalogSet {
		isCovered := assignedSet[qid]
		if !isCovered {
			if m := questionIDPattern.FindStringSubmatch(qid); len(m) >= 3 {
				baseID := fmt.Sprintf("%s%s", strings.ToUpper(m[1]), m[2])
				if baseAssigned[baseID] {
					isCovered = true
				}
			}
		}
		if !isCovered && !seenMissing[qid] {
			seenMissing[qid] = true
			unassignedIDs = append(unassignedIDs, fmt.Sprintf("%s (%s)", qid, desc))
		}
	}

	// 2. Phát hiện lỗ hổng dãy số tự nhiên (VD: thấy C1 và C56 nhưng thiếu C9, C13, E5..E19)
	for prefix, maxN := range prefixMaxNum {
		if maxN < 3 {
			continue
		}
		for n := 1; n <= maxN; n++ {
			candidateID := fmt.Sprintf("%s%d", prefix, n)
			if !assignedSet[candidateID] && !baseAssigned[candidateID] && !seenMissing[candidateID] {
				seenMissing[candidateID] = true
				unassignedIDs = append(unassignedIDs, candidateID)
			}
		}
	}

	return unassignedIDs, overloadedTopics
}

func (c *Client) runDeltaPlanner(
	ctx context.Context,
	modelName string,
	prefixParts []*genai.Part,
	currentPlan *LessonPlan,
	unassignedIDs []string,
	overloadedTopics []Topic,
) ([]Topic, error) {
	pool, err := c.getPool(ctx)
	if err != nil {
		return nil, err
	}

	var existingTitles []string
	for _, t := range currentPlan.Topics {
		existingTitles = append(existingTitles, fmt.Sprintf("- %s (Đích: %s)", t.Title, t.TargetOutput))
	}

	var overloadDesc []string
	for _, ot := range overloadedTopics {
		overloadDesc = append(overloadDesc, fmt.Sprintf("- Dạng '%s' đang ôm tới %d câu (%v) -> BẮT BUỘC tách nhỏ thành 2-3 dạng chuyên sâu riêng biệt!",
			ot.Title, len(ot.AssignedQuestionIDs), ot.AssignedQuestionIDs))
	}

	deltaPrompt := fmt.Sprintf(`KIỂM ĐỊNH ĐỘ BAO PHỦ PHÁT HIỆN BẠN ĐANG BỎ SÓT HOẶC GOM GỘP QUÁ TẢI CÁC CÂU HỎI SAU:

1. CÁC DẠNG ĐÃ CÓ:
%s

2. CÁC MÃ CÂU HỎI TRONG TÀI LIỆU ĐANG BỊ BỎ SÓT (CHƯA ĐƯỢC TẠO DẠNG TOÁN):
%v

3. CÁC DẠNG ĐANG BỊ GOM GỘP QUÁ TẢI (CẦN CHẺ NHỎ):
%s

NHIỆM VỤ:
- Hãy đọc kỹ nội dung các mã câu hỏi bị bỏ sót ở mục (2) và các câu trong mục (3) từ file PDF đính kèm.
- Tạo các Dạng toán ("additional_topics") chuyên sâu mới để bao phủ 100%%%% các câu hỏi này (Ví dụ: nếu các câu hỏi có đối tượng đích hoặc phương pháp giải khác nhau thì tạo dạng riêng biệt, không gộp chung vào dạng cơ bản).
- Mỗi dạng mới phải ghi rõ TargetOutput, CoreMethod, AssignedQuestionIDs, Variants và SourceRefs.`,
		strings.Join(existingTitles, "\n"),
		unassignedIDs,
		strings.Join(overloadDesc, "\n"),
	)

	parts := append(append([]*genai.Part{}, prefixParts...), &genai.Part{Text: deltaPrompt})
	config := &genai.GenerateContentConfig{
		Temperature:      genai.Ptr[float32](0.2),
		MaxOutputTokens:  8192,
		ResponseMIMEType: "application/json",
		ResponseSchema:   deltaPlannerSchema,
		ThinkingConfig: &genai.ThinkingConfig{
			ThinkingLevel: genai.ThinkingLevelMinimal,
		},
	}

	resp, err := pool.GenerateContent(ctx, modelName, []*genai.Content{{Parts: parts}}, config, 3)
	if err != nil {
		return nil, err
	}

	cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.Text()))
	var deltaRes DeltaTopicResponse
	if err := json.Unmarshal([]byte(cleanJSON), &deltaRes); err != nil {
		repaired := RepairTruncatedJSON(cleanJSON)
		if errRep := json.Unmarshal([]byte(repaired), &deltaRes); errRep == nil && len(deltaRes.AdditionalTopics) > 0 {
			LogPhase("PHASE 1", "\033[32m  ↳ [JSON HEALER] Đã tự động cứu hộ chuỗi JSON của Delta-Planner!\033[0m")
		} else {
			return nil, err
		}
	}
	return deltaRes.AdditionalTopics, nil
}

// -----------------------------------------------------------------------------
// PHASE 2: VIRTUAL-SLICE WORKERS (FULL-PDF IMPLICIT CACHE)
// -----------------------------------------------------------------------------

func (c *Client) ExecutePhase2_Workers(
	ctx context.Context,
	modelName string,
	docs []PDFDocumentInput,
	plan *LessonPlan,
) ([]WorkerResult, error) {
	start := time.Now()
	LogPhase("PHASE 2", "Khởi động %d Workers qua Pool API Keys (Chế độ Full-PDF Implicit Cache)...", len(plan.Topics))

	pool, err := c.getPool(ctx)
	if err != nil {
		return nil, err
	}

	// Tạo sẵn Prefix 1 lần duy nhất cho toàn bộ Workers
	prefixParts := BuildSharedPDFPrefixParts(docs)
	results := make([]WorkerResult, len(plan.Topics))
	var g errgroup.Group

	// Bounded Concurrency: Tăng gấp đôi số workers chạy đồng thời để hoàn tất siêu tốc
	maxWorkers := pool.ActiveCount() * 4
	if maxWorkers < 6 {
		maxWorkers = 6
	}
	sem := make(chan struct{}, maxWorkers)

	for idx, topic := range plan.Topics {
		i := idx
		t := topic
		g.Go(func() error {
			sem <- struct{}{}
			defer func() { <-sem }()

			// 1. Kiểm tra cache worker nếu đã hoàn thành hợp lệ trước đó (tiết kiệm token & tăng tốc)
			var cachedWorker WorkerResult
			if err := LoadArtifact(fmt.Sprintf("phase2_worker_%s.json", t.TopicID), &cachedWorker); err == nil && len(cachedWorker.Drills) >= 4 && len(cachedWorker.ShortAnswers) >= 2 && len(cachedWorker.Examples) >= 1 && cachedWorker.Title == t.Title {
				LogPhase(fmt.Sprintf("WORKER-%d", i+1), "\033[32m[CACHE HIT] Đã nạp dạng '%s' từ artifact có sẵn\033[0m", t.Title)
				results[i] = cachedWorker
				return nil
			}

			wStart := time.Now()

			// Format chỉ dẫn tham chiếu chéo từ các file PDF cho Worker này
			var refBuilder strings.Builder
			for _, ref := range t.SourceRefs {
				refBuilder.WriteString(fmt.Sprintf("  * %s\n", ref))
			}

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

VÙNG DỮ LIỆU THAM CHIẾU TỪ CÁC FILE PDF (CHỈ ĐỊNH CÁC VÍ DỤ VÀ CÂU HỎI TƯƠNG ỨNG):
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

5. PHẠM VI KIẾN THỨC CỦA DẠNG:
   - Với các dạng toán thuộc mạch Hình học thuần túy (trước khi học Hệ tọa độ Oxyz), các bài tập và ví dụ sử dụng quy tắc hình học không gian (quy tắc 3 điểm, hình bình hành, hình hộp, chèn điểm, định nghĩa tích vô hướng thuần túy), không đưa tọa độ số (x;y;z) vào đề bài.
   - Với các dạng toán ứng dụng thực tế không gian (Vật lý, Đời sống), ưu tiên các mô hình 3 chiều (hệ dây treo cân bằng trong không gian, phản lực chân bàn, tổng hợp lực không gian 3 chiều).

CẤU TRÚC DỮ LIỆU BẮT BUỘC BIÊN SOẠN:
1. "pedagogical_scratchpad": BÀN NHÁP SƯ PHẠM VÀ TOÁN HỌC: BẮT BUỘC đặt bút giải thử biểu thức và kiểm tra tính toán trước. Đảm bảo bài toán rút gọn ra kết quả đẹp hoặc bài toán chứng minh đúng đắn 100%% TRƯỚC KHI viết vào "prompt".
2. "theory_points": 2-3 gạch đầu dòng lý thuyết tối giản, cô đọng, tập trung chính xác vào công thức và phương pháp của dạng này - toán kẹp trong $.
3. "callout_tip": 1 mẹo nhớ nhanh, dấu hiệu nhận biết hoặc khẩu quyết thực chiến dễ thuộc.
4. "cloze_formula": 1 câu công thức cốt lõi có chỗ trống '...' để học sinh tự điền khuyết.
5. "short_answers": 2-3 câu hỏi tự luận ngắn tính ra một giá trị số cụ thể (kèm lời giải chi tiết và đáp số).
6. "examples" (TỪ 3 ĐẾN 5 VÍ DỤ MINH HỌA GIẢI MẪU CHI TIẾT):
   - Số lượng ví dụ linh động từ 3 đến 5 ví dụ tùy theo số lượng công thức trong lý thuyết.
   - TIÊN QUYẾT: Phủ trọn vẹn 100%% các công thức trong "theory_points" (mỗi công thức có ít nhất 1 ví dụ áp dụng trực tiếp).
   - Tiếp theo là các ví dụ biến thể nhẹ hoặc ví dụ củng cố cách trình bày từng bước "cầm tay chỉ việc".
7. "drills" (TỪ 4 ĐẾN 6 BÀI TẬP TỰ LUYỆN TƯƠNG TỰ ĐỂ RÈN LUYỆN):
   - Số lượng linh động từ 4 đến 6 bài tập tự luyện.
   - Bao quát toàn bộ các công thức đã học, sắp xếp theo mô thức lặp lại:
     + Bài 1 (level: "MauChuan"): Áp dụng trực tiếp công thức/thuật toán của Ví dụ 1.
     + Bài 2 (level: "TuongTu100"): Tương tự 100%% với Bài 1, chỉ đổi số liệu để học sinh tự làm quen tay.
     + Bài 3 (level: "TuongTu100"): Tiếp tục bài tương tự cho công thức thứ hai để học sinh bấm máy thành thạo.
     + Bài 4 (level: "BienTheNhe"): Biến thể nhẹ (đổi chiều câu hỏi xuôi - ngược, đổi biến), giữ nguyên phương pháp.
     + Bài 5 (level: "BienTheNhe" hoặc "CungCo" - nếu có): Biến thể nhẹ củng cố kỹ năng, bám sát lý thuyết.
     + Bài 6 (level: "CungCo" - nếu có): Luyện củng cố tốc độ và độ chuẩn xác.
   - Lời giải "solution": Từng bước mạch lạc, súc tích, đi thẳng vào các bước giải khẳng định.

CÁC RÀNG BUỘC CÚ PHÁP TOÁN BẮT BUỘC:
1. MỌI biến số, tọa độ, điểm, công thức toán BẮT BUỘC bọc trong cặp dấu $ ... $.
2. CÔNG THỨC TOÁN CHUẨN: Dùng cú pháp LaTeX chuẩn xác cho mọi môn học: \frac{a}{b}, \sqrt{x}, \vec{u}, \sin, \cos, \lim, \int (nếu có).
3. JSON ESCAPE: Mọi lệnh LaTeX trong chuỗi JSON phải có 2 dấu gạch chéo ngược: "\\frac{1}{2}", "\\sqrt{...}", "\\vec{...}".`,
				t.Title, t.Difficulty, t.CoreConcept, variantBuilder.String(), refBuilder.String())

			// Ghép cùng một bộ prefixParts ở đầu + wPrompt ở cuối -> Trúng Prefix Cache!
			parts := append(append([]*genai.Part{}, prefixParts...), &genai.Part{Text: wPrompt})

			config := &genai.GenerateContentConfig{
				Temperature:      genai.Ptr[float32](0.3),
				MaxOutputTokens:  8192,
				ResponseMIMEType: "application/json",
				ResponseSchema:   workerSchema,
				ThinkingConfig: &genai.ThinkingConfig{
					ThinkingLevel: genai.ThinkingLevelMinimal,
				},
			}

			// Gọi qua KeyPool (tự động điều phối qua các API Keys + Retry/Failover + Retry nếu JSON bị đứt đoạn)
			var wResult WorkerResult
			var lastErr error
			tokensOut := 0

			for attempt := 1; attempt <= 2; attempt++ {
				resp, err := pool.GenerateContent(ctx, modelName, []*genai.Content{{Parts: parts}}, config, 5)
				if err != nil {
					return fmt.Errorf("worker %s lỗi: %w", t.TopicID, err)
				}

				if resp.UsageMetadata != nil {
					tokensOut = int(resp.UsageMetadata.CandidatesTokenCount)
				}

				sanitizedJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.Text()))
				if err := json.Unmarshal([]byte(sanitizedJSON), &wResult); err != nil {
					// Thử tự động cứu hộ nếu JSON bị đứt đoạn cuối do token limit
					healedJSON := RepairTruncatedJSON(sanitizedJSON)
					if errHeal := json.Unmarshal([]byte(healedJSON), &wResult); errHeal == nil {
						LogPhase(fmt.Sprintf("WORKER-%d", i+1), "\033[32m  ↳ [JSON HEALER] Đã tự động cứu hộ và vá thành công chuỗi JSON bị ngắt cụt!\033[0m")
						lastErr = nil
						break
					}
					lastErr = fmt.Errorf("worker %s unmarshal lỗi: %w (Raw: %s)", t.TopicID, err, sanitizedJSON)
					LogPhase(fmt.Sprintf("WORKER-%d", i+1), "\033[33mCảnh báo: Parse JSON lỗi ở lần thử %d/2 (Tokens: %d), đang thử lại...\033[0m", attempt, tokensOut)
					continue
				}
				lastErr = nil
				break
			}
			if lastErr != nil {
				return lastErr
			}

			wResult.TopicID = t.TopicID
			wResult.Title = t.Title
			results[i] = wResult

			LogPhase(fmt.Sprintf("WORKER-%d", i+1), "Hoàn thành sau %v (Tokens Out: %d)", time.Since(wStart), tokensOut)
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

	// Prelude: Import MiTeX
	sb.WriteString(`#import "@preview/mitex:0.2.7": mitex, mi` + "\n\n")
	sb.WriteString(`#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"` + "\n\n")
	sb.WriteString(`#set page(paper: "a4", margin: (x: 1.8cm, top: 1.6cm, bottom: 1.8cm))` + "\n")
	// Chuẩn hóa font đa nền tảng Windows + Linux/WSL (tránh unknown font warning)
	sb.WriteString(`#set text(font: ("Arial", "Segoe UI", "DejaVu Sans", "Liberation Sans"), size: 10pt, lang: "vi")` + "\n")
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
`, LaTeXToMiTeX(plan.LessonTitle), LaTeXToMiTeX(plan.Overview)))

	// Duyệt qua từng Dạng toán
	for idx, w := range workers {
		sb.WriteString(fmt.Sprintf("\n// ==================== DẠNG %d: %s ====================\n", idx+1, w.Title))
		sb.WriteString(fmt.Sprintf("#v(8pt)\n#text(size: 13pt, weight: \"bold\", fill: rgb(\"#1e3a8a\"))[Dạng %d. %s]\n#v(3pt)\n", idx+1, LaTeXToMiTeX(w.Title)))

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

		// 2. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)
		if len(w.ShortAnswers) > 0 {
			sb.WriteString(`#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
`)
			for sIdx, sa := range w.ShortAnswers {
				sb.WriteString("  #block(width: 100%, breakable: false)[\n")
				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|short_answer|%d|prompt\n", w.TopicID, sIdx))
				sb.WriteString(fmt.Sprintf("    *Câu %d.* %s\n", sIdx+1, LaTeXToMiTeX(sa.Prompt)))
				anchorCount++

				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|short_answer|%d|final_number\n", w.TopicID, sIdx))
				sb.WriteString(fmt.Sprintf(`    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: %s]
`, FormatFinalNumber(sa.FinalNumber)))
				anchorCount++

				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|short_answer|%d|solution\n", w.TopicID, sIdx))
				sb.WriteString(fmt.Sprintf(`      \ #text(fill: rgb("#334155"))[Lời giải: %s]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
`, LaTeXToMiTeX(sa.Solution)))
				anchorCount++
			}
			sb.WriteString("]\n#v(4pt)\n")
		}

		// 3. Ví dụ minh họa giải mẫu
		if len(w.Examples) > 0 {
			sb.WriteString(`#card(title: "III. Ví dụ minh họa giải mẫu")[
`)
			for eIdx, ex := range w.Examples {
				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|example|%d|problem\n", w.TopicID, eIdx))
				sb.WriteString(fmt.Sprintf(`  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[%s:] %s
`, LaTeXToMiTeX(ex.Title), LaTeXToMiTeX(ex.Problem)))

				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|example|%d|solution\n", w.TopicID, eIdx))
				sb.WriteString(fmt.Sprintf(`    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] %s
    ] else [ \ #v(16pt) ]
  ]`+"\n", LaTeXToMiTeX(ex.Solution)))
				anchorCount += 2
			}
			sb.WriteString("]\n#v(4pt)\n")
		}

		// 4. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)
		if len(w.Drills) > 0 {
			sb.WriteString(`#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
`)
			for dIdx, dr := range w.Drills {
				titleStr := strings.TrimSpace(dr.Title)
				if titleStr == "" {
					titleStr = fmt.Sprintf("Bài %d", dIdx+1)
				}
				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|drill|%d|prompt\n", w.TopicID, dIdx))
				sb.WriteString(fmt.Sprintf("  *%s.* %s\n", LaTeXToMiTeX(titleStr), LaTeXToMiTeX(dr.Prompt)))
				anchorCount++

				sb.WriteString(fmt.Sprintf("// @ANCHOR:%s|drill|%d|solution\n", w.TopicID, dIdx))
				sb.WriteString(fmt.Sprintf(`    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: %s] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]`+"\n", LaTeXToMiTeX(dr.Solution)))
				anchorCount++
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
	cmd := exec.CommandContext(ctx, "typst", "compile", "--root", ".", "--input", "teacher="+val, typPath, pdfPath)
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
			check(fmt.Sprintf("%s|drill|%d|solution", w.TopicID, dIdx), "Lời giải Drill", dr.Solution)
		}

		for sIdx, sa := range w.ShortAnswers {
			check(fmt.Sprintf("%s|short_answer|%d|prompt", w.TopicID, sIdx), fmt.Sprintf("Trả lời ngắn %d Đề bài", sIdx+1), sa.Prompt)
			check(fmt.Sprintf("%s|short_answer|%d|final_number", w.TopicID, sIdx), fmt.Sprintf("Trả lời ngắn %d Đáp số", sIdx+1), sa.FinalNumber)
			check(fmt.Sprintf("%s|short_answer|%d|solution", w.TopicID, sIdx), fmt.Sprintf("Trả lời ngắn %d Lời giải", sIdx+1), sa.Solution)
		}
	}

	return items
}

func sanitizeAnchorContent(workers []WorkerResult, anchorID string) {
	req := extractRepairContext(workers, anchorID)
	if req == nil {
		return
	}
	fixed := req.BrokenContent
	// 1. Cân bằng dấu $
	count := strings.Count(fixed, "$")
	if count%2 != 0 {
		fixed += "$"
	}
	// 2. Escape ký tự # nếu đứng ngoài toán
	fixed = strings.ReplaceAll(fixed, "#", `\#`)
	// 3. Chuẩn hóa đoạn thẳng có hướng 2-3 chữ cái in hoa về \vec (giữ nguyên số phức liên hợp \overline{z}, số trung bình \overline{x})
	directedSegRegex := regexp.MustCompile(`\\(?:overline|overrightarrow)\{([A-Z][']?[A-Z][']?)\}`)
	fixed = directedSegRegex.ReplaceAllString(fixed, `\vec{$1}`)

	applyFixedBatch(workers, []RepairedItemResponse{{AnchorID: anchorID, FixedContent: fixed}})
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
	failedAttempts := make(map[string]int)

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
		LogPhase("PHASE 4", "\033[31m[LỖI BIÊN DỊCH TYPST (Lần %d)] Phát hiện lỗi cú pháp! Bắt đầu phân loại và xử lý...\033[0m", attempt)
		LogPhase("PHASE 4", "Typst stderr:\n%s", outGV)

		lines := strings.Split(markup, "\n")

		// NẾU LÀ LỖI CÚ PHÁP TOÁN: Quét tất cả các dòng báo lỗi của Typst để tìm @ANCHOR
		seenAnchors := make(map[string]bool)
		var compilerErrorItems []RepairItemRequest

		for _, m := range typstErrorRegex.FindAllStringSubmatch(outGV, -1) {
			errLine, _ := strconv.Atoi(m[1])
			anchorID := findNearestAnchor(lines, errLine-1)
			if anchorID != "" && !seenAnchors[anchorID] {
				seenAnchors[anchorID] = true
				if failedAttempts[anchorID] >= 2 {
					LogPhase("PHASE 4", "\033[33m[CIRCUIT BREAKER] Anchor %s bị kẹt lặp sửa đổi. Tự động áp dụng sanitize dự phòng...\033[0m", anchorID)
					sanitizeAnchorContent(workers, anchorID)
					continue
				}
				if reqItem := extractRepairContext(workers, anchorID); reqItem != nil {
					compilerErrorItems = append(compilerErrorItems, *reqItem)
				}
			}
		}

		if len(compilerErrorItems) == 0 {
			if len(seenAnchors) > 0 {
				// Các anchor bị lỗi đều đã được xử lý qua fallback sanitize
				continue
			}
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
					// CIRCUIT BREAKER 2: KIỂM TRA LŨY ĐẲNG (IDEMPOTENCY)
					if strings.TrimSpace(item.FixedContent) == strings.TrimSpace(origContent) {
						failedAttempts[item.AnchorID]++
						LogPhase("PHASE 4", "\033[33m  ↳ [CẢNH BÁO IDEMPOTENCY] Anchor %s: AI trả về kết quả không đổi (Lần %d)!\033[0m", item.AnchorID, failedAttempts[item.AnchorID])
						if failedAttempts[item.AnchorID] >= 2 {
							sanitizeAnchorContent(workers, item.AnchorID)
						}
					}
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
		if len(parts) >= 4 {
			dIdx, _ := strconv.Atoi(parts[2])
			sub := parts[3]
			if dIdx < len(targetWorker.Drills) {
				if sub == "prompt" {
					return &RepairItemRequest{
						AnchorID:      anchorID,
						ContextPrompt: fmt.Sprintf("Đề bài Drill %d (%s)", dIdx+1, targetWorker.Title),
						BrokenContent: targetWorker.Drills[dIdx].Prompt,
					}
				} else if sub == "solution" {
					return &RepairItemRequest{
						AnchorID:      anchorID,
						ContextPrompt: fmt.Sprintf("Lời giải Drill %d: %s", dIdx+1, targetWorker.Drills[dIdx].Prompt),
						BrokenContent: targetWorker.Drills[dIdx].Solution,
					}
				}
			}
		}
	case "short_answer":
		if len(parts) >= 4 {
			sIdx, _ := strconv.Atoi(parts[2])
			sub := parts[3]
			if sIdx < len(targetWorker.ShortAnswers) {
				switch sub {
				case "prompt":
					return &RepairItemRequest{
						AnchorID:      anchorID,
						ContextPrompt: fmt.Sprintf("Trả lời ngắn Câu %d - Đề bài", sIdx+1),
						BrokenContent: targetWorker.ShortAnswers[sIdx].Prompt,
					}
				case "final_number":
					return &RepairItemRequest{
						AnchorID:      anchorID,
						ContextPrompt: fmt.Sprintf("Trả lời ngắn Câu %d - Đáp số", sIdx+1),
						BrokenContent: targetWorker.ShortAnswers[sIdx].FinalNumber,
					}
				case "solution":
					return &RepairItemRequest{
						AnchorID:      anchorID,
						ContextPrompt: fmt.Sprintf("Trả lời ngắn Câu %d - Lời giải chi tiết", sIdx+1),
						BrokenContent: targetWorker.ShortAnswers[sIdx].Solution,
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
					if len(parts) >= 4 {
						dIdx, _ := strconv.Atoi(parts[2])
						sub := parts[3]
						if dIdx < len(workers[i].Drills) {
							if sub == "prompt" {
								workers[i].Drills[dIdx].Prompt = item.FixedContent
							} else if sub == "solution" {
								workers[i].Drills[dIdx].Solution = item.FixedContent
							}
						}
					}
				case "short_answer":
					if len(parts) >= 4 {
						sIdx, _ := strconv.Atoi(parts[2])
						sub := parts[3]
						if sIdx < len(workers[i].ShortAnswers) {
							switch sub {
							case "prompt":
								workers[i].ShortAnswers[sIdx].Prompt = item.FixedContent
							case "final_number":
								workers[i].ShortAnswers[sIdx].FinalNumber = item.FixedContent
							case "solution":
								workers[i].ShortAnswers[sIdx].Solution = item.FixedContent
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
	pool, err := c.getPool(ctx)
	if err != nil {
		return nil, err
	}

	reqData, _ := json.MarshalIndent(RepairBatchRequest{Items: items}, "", "  ")

	prompt := fmt.Sprintf(`Bạn là Chuyên gia Cú pháp Toán học LaTeX.
Dưới đây là danh sách các mục bị lỗi hiển thị công thức toán khi biên dịch sang Typst (thiếu $, sai lệnh như \b{...}, hoặc ngoặc \{ sai).

NHIỆM VỤ:
1. Phục hồi và sửa lại cú pháp trong "broken_content" thành cú pháp LaTeX chuẩn.
2. MỌI CÔNG THỨC TOÁN, VECTƠ, PHÂN SỐ, BIẾN SỐ BẮT BUỘC ĐƯỢC BỌC TRONG CẶP DẤU $...$.
3. KÝ HIỆU VECTƠ: Bắt buộc dùng \vec{...} (VD: $\vec{AB}$, $\vec{a}$, $\vec{b}$). TUYỆT ĐỐI KHÔNG dùng \overline{...}, \b{...} hay \bar{...}.
4. ĐỐI VỚI DẤU PHẨY ĐỈNH (VD: AD', AA'): Dùng $\vec{AD}'$ hoặc $\vec{AD'}$, TUYỆT ĐỐI KHÔNG dùng \{AA}'.
5. Giữ nguyên vẹn toàn bộ câu chữ tiếng Việt tự nhiên và ngữ nghĩa ban đầu.
6. CHỈ xuất kết quả dưới dạng JSON hợp lệ theo schema. TUYỆT ĐỐI KHÔNG viết thêm bất kỳ bình luận, ghi chú hay độc thoại phụ nào (như "Note:", "I will...").

Danh sách cần sửa:
%s`, string(reqData))

	config := &genai.GenerateContentConfig{
		Temperature:      genai.Ptr[float32](0.3),
		MaxOutputTokens:  8192,
		ResponseMIMEType: "application/json",
		ResponseSchema:   repairSchema,
	}

	startReq := time.Now()
	resp, err := pool.GenerateContent(ctx, modelName, []*genai.Content{{Parts: []*genai.Part{{Text: prompt}}}}, config, 4)
	if err != nil {
		return nil, err
	}
	LogPhase("PHASE 4", "Gemini Repair Agent phản hồi sau %v", time.Since(startReq))

	cleanJSON := SanitizeRawJSONLaTeX(strings.TrimSpace(resp.Text()))
	var res RepairBatchResponse
	if err := json.Unmarshal([]byte(cleanJSON), &res); err != nil {
		return nil, fmt.Errorf("unmarshal Repair Agent thất bại: %w (Raw: %s)", err, cleanJSON)
	}
	return res.RepairedItems, nil
}
