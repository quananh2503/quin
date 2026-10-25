package gemini

import (
	"fmt"
	"strconv"
	"strings"
	"unicode"
)

// =============================================================================
// PLAN AUDITOR: KIỂM ĐỊNH ĐỘ BAO PHỦ VÀ BẤT THƯỜNG TRÊN LESSON PLAN
// =============================================================================

// Bảng số La Mã thông dụng trong các đề thi và tài liệu bài tập (từ I đến XXX)
var romanToInt = map[string]int{
	"I": 1, "II": 2, "III": 3, "IV": 4, "V": 5,
	"VI": 6, "VII": 7, "VIII": 8, "IX": 9, "X": 10,
	"XI": 11, "XII": 12, "XIII": 13, "XIV": 14, "XV": 15,
	"XVI": 16, "XVII": 17, "XVIII": 18, "XIX": 19, "XX": 20,
	"XXI": 21, "XXII": 22, "XXIII": 23, "XXIV": 24, "XXV": 25,
	"XXVI": 26, "XXVII": 27, "XXVIII": 28, "XXIX": 29, "XXX": 30,
}

// Danh sách tiền tố loại trừ không phải câu hỏi (trang sách, năm học, hình vẽ, v.v.)
var nonQuestionPrefixes = map[string]bool{
	"TRANG":   true,
	"PAGE":    true,
	"NAM":     true,
	"YEAR":    true,
	"THANG":   true,
	"MONTH":   true,
	"NGAY":    true,
	"DAY":     true,
	"LOP":     true,
	"GRADE":   true,
	"TAP":     true,
	"VOL":     true,
	"VOLUME":  true,
	"HINH":    true,
	"FIG":     true,
	"FIGURE":  true,
	"BANG":    true,
	"TABLE":   true,
	"CHUONG":  true,
	"CHAPTER": true,
	"TIET":    true,
	"PHUT":    true,
	"GIAY":    true,
}

// removeDiacritics: Chuyển tiếng Việt có dấu về dạng ASCII không dấu để nhận diện đồng nhất
func removeDiacritics(s string) string {
	var sb strings.Builder
	for _, r := range s {
		switch r {
		case 'à', 'á', 'ạ', 'ả', 'ã', 'â', 'ầ', 'ấ', 'ậ', 'ẩ', 'ẫ', 'ă', 'ằ', 'ắ', 'ặ', 'ẳ', 'ẵ':
			sb.WriteRune('a')
		case 'À', 'Á', 'Ạ', 'Ả', 'Ã', 'Â', 'Ầ', 'Ấ', 'Ậ', 'Ẩ', 'Ẫ', 'Ă', 'Ằ', 'Ắ', 'Ặ', 'Ẳ', 'Ẵ':
			sb.WriteRune('A')
		case 'è', 'é', 'ẹ', 'ẻ', 'ẽ', 'ê', 'ề', 'ế', 'ệ', 'ể', 'ễ':
			sb.WriteRune('e')
		case 'È', 'É', 'Ẹ', 'Ẻ', 'Ẽ', 'Ê', 'Ề', 'Ế', 'Ệ', 'Ể', 'Ễ':
			sb.WriteRune('E')
		case 'ì', 'í', 'ị', 'ỉ', 'ĩ':
			sb.WriteRune('i')
		case 'Ì', 'Í', 'Ị', 'Ỉ', 'Ĩ':
			sb.WriteRune('I')
		case 'ò', 'ó', 'ọ', 'ỏ', 'õ', 'ô', 'ồ', 'ố', 'ộ', 'ổ', 'ỗ', 'ơ', 'ờ', 'ớ', 'ợ', 'ở', 'ỡ':
			sb.WriteRune('o')
		case 'Ò', 'Ó', 'Ọ', 'Ỏ', 'Õ', 'Ô', 'Ồ', 'Ố', 'Ộ', 'Ổ', 'Ỗ', 'Ơ', 'Ờ', 'Ớ', 'Ợ', 'Ở', 'Ỡ':
			sb.WriteRune('O')
		case 'ù', 'ú', 'ụ', 'ủ', 'ũ', 'ư', 'ừ', 'ứ', 'ự', 'ử', 'ữ':
			sb.WriteRune('u')
		case 'Ù', 'Ú', 'Ụ', 'Ủ', 'Ũ', 'Ư', 'Ừ', 'Ứ', 'Ự', 'Ử', 'Ữ':
			sb.WriteRune('U')
		case 'ỳ', 'ý', 'ỵ', 'ỷ', 'ỹ':
			sb.WriteRune('y')
		case 'Ỳ', 'Ý', 'Ỵ', 'Ỷ', 'Ỹ':
			sb.WriteRune('Y')
		case 'đ':
			sb.WriteRune('d')
		case 'Đ':
			sb.WriteRune('D')
		default:
			sb.WriteRune(r)
		}
	}
	return sb.String()
}

type ParsedQID struct {
	Original   string
	Normalized string
	Prefix     string
	MainNum    int
	SubLetter  string // a, b, c, d, e, f, g, h...
}

// ParseQuestionID: Nhận diện và chuẩn hóa toàn diện mã câu hỏi:
// - Hỗ trợ Tiếng Việt có dấu, không dấu, khoảng trắng: "Câu 1", "Bài 2", "Ví dụ 3"
// - Hỗ trợ Viết tắt: "C1", "B2", "VD3", "TN4", "TL5", "DS6", "ĐS 7", "Đ/S 8"
// - Hỗ trợ Số La Mã: "Câu I", "Câu II", "Bài III", "VD IV", "Câu X"
// - Hỗ trợ Ý con đa cấp: "Câu 1a", "VD 1e..VD 1h", "D1a..D1d", "Câu 1 (a)", "Câu 1 ý a", "Câu I.a"
// - Hàng rào an toàn cho số thuần túy (loại bỏ năm 2024, số trang 150) và loại trừ tiêu đề phi câu hỏi
func ParseQuestionID(raw string) *ParsedQID {
	trimmed := strings.TrimSpace(raw)
	if trimmed == "" {
		return nil
	}

	trimmed = strings.Trim(trimmed, "()[]{}\"'")
	trimmed = strings.TrimRight(trimmed, ".:;,-")
	trimmed = strings.Trim(trimmed, "()[]{}\"'")

	ascii := removeDiacritics(trimmed)

	// Tách chuỗi thành các token dựa trên các ký tự phân cách thông dụng
	tokens := strings.FieldsFunc(ascii, func(r rune) bool {
		return r == ' ' || r == '.' || r == '_' || r == '-' || r == ':' || r == '/' || r == '\\' ||
			r == '(' || r == ')' || r == '[' || r == ']' || r == '{' || r == '}' || r == ',' || r == ';'
	})

	if len(tokens) == 0 {
		return nil
	}

	var rawPrefix string
	var mainNum int
	var subLetter string

	// Helper kiểm tra ý con (chấp nhận ký tự a..h)
	isSubLetter := func(s string) (string, bool) {
		if len(s) == 1 {
			lower := strings.ToLower(s)
			if lower[0] >= 'a' && lower[0] <= 'h' {
				return lower, true
			}
		}
		return "", false
	}

	// Helper bỏ qua các từ đệm tiếng Việt đứng trước ý con: "y" (ý), "phan" (phần), "muc" (mục)
	isFillerWord := func(s string) bool {
		lower := strings.ToLower(s)
		return lower == "y" || lower == "phan" || lower == "muc"
	}

	// 1. Phân tích cấu trúc từ các tokens
	n := len(tokens)

	// Trường hợp 1.1: Token cuối cùng là ý con đơn độc (VD: ["Câu", "1", "a"] hoặc ["Câu", "1", "ý", "a"] hoặc ["VD", "IV", "c"])
	if n >= 2 {
		if sub, ok := isSubLetter(tokens[n-1]); ok {
			numIdx := n - 2
			if numIdx >= 1 && isFillerWord(tokens[numIdx]) {
				numIdx--
			}
			if numIdx >= 0 {
				candNumStr := tokens[numIdx]
				if val, exists := romanToInt[strings.ToUpper(candNumStr)]; exists {
					mainNum = val
					subLetter = sub
					rawPrefix = strings.Join(tokens[:numIdx], "")
				} else if val, err := strconv.Atoi(candNumStr); err == nil {
					mainNum = val
					subLetter = sub
					rawPrefix = strings.Join(tokens[:numIdx], "")
				}
			}
		}
	}

	// Trường hợp 1.2: Token cuối cùng chứa số và ý con dính liền (VD: ["Câu", "1a"] hoặc ["VD", "IVa"])
	if mainNum == 0 && n >= 1 {
		lastToken := tokens[n-1]
		if len(lastToken) > 1 {
			lastChar := string(lastToken[len(lastToken)-1])
			if sub, ok := isSubLetter(lastChar); ok {
				stem := lastToken[:len(lastToken)-1]
				if val, exists := romanToInt[strings.ToUpper(stem)]; exists {
					mainNum = val
					subLetter = sub
					rawPrefix = strings.Join(tokens[:n-1], "")
				} else if val, err := strconv.Atoi(stem); err == nil {
					mainNum = val
					subLetter = sub
					rawPrefix = strings.Join(tokens[:n-1], "")
				}
			}
		}
	}

	// Trường hợp 1.3: Token cuối cùng chỉ là số nguyên vẹn (VD: ["Câu", "1"] hoặc ["VD", "IV"] hoặc ["1"])
	if mainNum == 0 && n >= 1 {
		lastToken := tokens[n-1]
		if val, exists := romanToInt[strings.ToUpper(lastToken)]; exists {
			mainNum = val
			rawPrefix = strings.Join(tokens[:n-1], "")
		} else if val, err := strconv.Atoi(lastToken); err == nil {
			mainNum = val
			rawPrefix = strings.Join(tokens[:n-1], "")
		}
	}

	// Trường hợp 1.4: Quét số Ả Rập trong chuỗi nếu tokenization chưa bắt được (fallback như "C1", "VD2", "D3a", "C12b")
	if mainNum == 0 {
		firstDigit := -1
		lastDigit := -1
		for i, r := range ascii {
			if unicode.IsDigit(r) {
				if firstDigit == -1 {
					firstDigit = i
				}
				lastDigit = i
			}
		}

		if firstDigit != -1 {
			numStr := ascii[firstDigit : lastDigit+1]
			if val, err := strconv.Atoi(numStr); err == nil {
				mainNum = val
				rawPrefix = ascii[:firstDigit]

				afterDigits := ascii[lastDigit+1:]
				subTokens := strings.FieldsFunc(afterDigits, func(r rune) bool {
					return r == ' ' || r == '.' || r == '_' || r == '-' || r == ':' || r == '/' ||
						r == '(' || r == ')' || r == '[' || r == ']' || r == '{' || r == '}'
				})
				for _, st := range subTokens {
					if sub, ok := isSubLetter(st); ok {
						subLetter = sub
						break
					}
				}
			}
		}
	}

	if mainNum == 0 {
		return nil
	}

	// Vệ sinh tiền tố: chuyển chữ hoa, loại bỏ mọi ký tự đặc biệt
	var cleanPrefixBuilder strings.Builder
	for _, r := range strings.ToUpper(rawPrefix) {
		if unicode.IsLetter(r) || unicode.IsDigit(r) {
			cleanPrefixBuilder.WriteRune(r)
		}
	}
	cleanPrefix := cleanPrefixBuilder.String()

	// 2. HÀNG RÀO AN TOÀN (SAFETY GUARDS)
	// 2.1 Loại bỏ các từ khóa không phải câu hỏi (Trang sách, Năm học, Hình vẽ, Bảng biểu...)
	if nonQuestionPrefixes[cleanPrefix] {
		return nil
	}

	// 2.2 Số thuần túy (không có tiền tố):
	// - Loại bỏ số âm (bắt đầu bằng dấu trừ trước số)
	if cleanPrefix == "" && (strings.HasPrefix(trimmed, "-") || strings.HasPrefix(trimmed, "–") || strings.HasPrefix(trimmed, "—")) {
		return nil
	}
	// - Phải nằm trong khoảng hợp lệ 1..100 (tránh nhầm số năm 2024, số trang 150)
	if cleanPrefix == "" && (mainNum <= 0 || mainNum > 100) {
		return nil
	}

	// 2.3 Câu có tiền tố nhưng số quá lớn (> 500) cũng loại bỏ
	if mainNum <= 0 || mainNum > 500 {
		return nil
	}

	// 3. Chuẩn hóa tiền tố (Standardize Prefix)
	var stdPrefix string
	switch {
	case strings.HasPrefix(cleanPrefix, "CAU") || cleanPrefix == "C" || cleanPrefix == "TN" || cleanPrefix == "TRACNGHIEM":
		stdPrefix = "C"
	case strings.HasPrefix(cleanPrefix, "VD") || strings.HasPrefix(cleanPrefix, "VIDU"):
		stdPrefix = "VD"
	case (strings.HasPrefix(cleanPrefix, "BAI") && !strings.HasPrefix(cleanPrefix, "BAIHOC")) || cleanPrefix == "B" || cleanPrefix == "BT" || cleanPrefix == "BAITAP" || cleanPrefix == "TL" || cleanPrefix == "TULUAN":
		stdPrefix = "B"
	case cleanPrefix == "DUNGSAI" || cleanPrefix == "DS" || cleanPrefix == "D":
		stdPrefix = "D"
	case cleanPrefix == "E" || cleanPrefix == "EX" || cleanPrefix == "EXERCISE":
		stdPrefix = "E"
	case cleanPrefix == "P" || cleanPrefix == "PROB" || cleanPrefix == "PROBLEM":
		stdPrefix = "P"
	case cleanPrefix == "" || cleanPrefix == "Q" || cleanPrefix == "QUESTION":
		stdPrefix = "Q" // Số thuần túy hoặc Question
	default:
		// Tiền tố lạ, không phải câu hỏi (VD: "TOANHOC", "NGUYENHAM", "CHUDE", "BAIHOC"...)
		return nil
	}

	normalized := fmt.Sprintf("%s%d%s", stdPrefix, mainNum, subLetter)

	return &ParsedQID{
		Original:   raw,
		Normalized: normalized,
		Prefix:     stdPrefix,
		MainNum:    mainNum,
		SubLetter:  subLetter,
	}
}

// DefaultPlanAuditor thực thi kiểm tra tính toàn vẹn của LessonPlan
type DefaultPlanAuditor struct{}

var _ PlanAuditor = (*DefaultPlanAuditor)(nil)

// NewDefaultPlanAuditor khởi tạo auditor mặc định
func NewDefaultPlanAuditor() *DefaultPlanAuditor {
	return &DefaultPlanAuditor{}
}

// Audit kiểm định danh mục câu hỏi, phát hiện câu bị bỏ sót, gộp quá tải hoặc trùng lặp
func (a *DefaultPlanAuditor) Audit(plan *LessonPlan) AuditReport {
	if plan == nil || (len(plan.Topics) == 0 && len(plan.QuestionCatalog) == 0) {
		return AuditReport{}
	}

	assignedSet := make(map[string]bool)
	for _, top := range plan.Topics {
		for _, qid := range top.AssignedQuestionIDs {
			trimmed := strings.TrimSpace(qid)
			if trimmed != "" {
				assignedSet[trimmed] = true
				if p := ParseQuestionID(trimmed); p != nil {
					assignedSet[p.Normalized] = true
				}
			}
		}
	}

	unassignedMap := make(map[string]bool)
	var unassignedIDs []string

	addUnassigned := func(id string) {
		trimmed := strings.TrimSpace(id)
		if trimmed == "" {
			return
		}
		p := ParseQuestionID(trimmed)
		if p == nil {
			return
		}
		normID := p.Normalized
		if !unassignedMap[normID] && !assignedSet[trimmed] && !assignedSet[normID] {
			unassignedMap[normID] = true
			unassignedIDs = append(unassignedIDs, trimmed)
		}
	}

	// 1. Kiểm tra câu hỏi trong QuestionCatalog chưa được gán vào bất kỳ Topic nào
	for _, cat := range plan.QuestionCatalog {
		for _, qid := range cat.QuestionIDs {
			trimmed := strings.TrimSpace(qid)
			if trimmed != "" {
				p := ParseQuestionID(trimmed)
				if p == nil {
					continue
				}
				normID := p.Normalized
				if !assignedSet[trimmed] && !assignedSet[normID] {
					addUnassigned(trimmed)
				}
			}
		}
	}

	// 2. Bóc tách tiền tố và kiểm tra lỗ hổng dãy số (cả câu chính và ý con)
	type numRange struct {
		min int
		max int
	}
	prefixRanges := make(map[string]*numRange)
	subLettersByQuestion := make(map[string]map[rune]bool)

	recordID := func(id string) {
		p := ParseQuestionID(id)
		if p == nil {
			return
		}

		nr, exists := prefixRanges[p.Prefix]
		if !exists {
			prefixRanges[p.Prefix] = &numRange{min: p.MainNum, max: p.MainNum}
		} else {
			if p.MainNum < nr.min {
				nr.min = p.MainNum
			}
			if p.MainNum > nr.max {
				nr.max = p.MainNum
			}
		}

		if p.SubLetter != "" {
			key := fmt.Sprintf("%s%d", p.Prefix, p.MainNum)
			if subLettersByQuestion[key] == nil {
				subLettersByQuestion[key] = make(map[rune]bool)
			}
			for _, r := range p.SubLetter {
				subLettersByQuestion[key][r] = true
			}
		}
	}

	for id := range assignedSet {
		recordID(id)
	}
	for _, cat := range plan.QuestionCatalog {
		for _, qid := range cat.QuestionIDs {
			recordID(strings.TrimSpace(qid))
		}
	}

	// 2.1 Quét lỗ hổng dãy số câu chính (VD: C1, C4 -> thiếu C2, C3)
	for prefix, nr := range prefixRanges {
		if nr.max-nr.min <= 200 && nr.max-nr.min > 0 {
			for i := nr.min; i <= nr.max; i++ {
				baseID := fmt.Sprintf("%s%d", prefix, i)
				key := baseID
				if len(subLettersByQuestion[key]) == 0 {
					if !assignedSet[baseID] {
						addUnassigned(baseID)
					}
				}
			}
		}
	}

	// 2.2 Quét lỗ hổng ý con (a, b, c, d, e...) cho từng câu hỏi (VD: VD1a, VD1d -> thiếu VD1b, VD1c)
	for key, subMap := range subLettersByQuestion {
		if len(subMap) > 1 {
			var minSub, maxSub rune = 'z', 'a'
			for r := range subMap {
				if r < minSub {
					minSub = r
				}
				if r > maxSub {
					maxSub = r
				}
			}
			if minSub < maxSub && maxSub-minSub <= 15 {
				for subR := minSub; subR <= maxSub; subR++ {
					subID := fmt.Sprintf("%s%c", key, subR)
					if !assignedSet[subID] {
						addUnassigned(subID)
					}
				}
			}
		}
	}

	// 3. Phát hiện Topic bị gom gộp quá tải (> 10 câu hỏi)
	var overloadedTopics []Topic
	for _, top := range plan.Topics {
		if len(top.AssignedQuestionIDs) > 10 {
			overloadedTopics = append(overloadedTopics, top)
		}
	}

	// 4. Phát hiện Topic bị trùng lặp tiêu đề
	var redundantTopics []Topic
	seenTitles := make(map[string]bool)
	for _, top := range plan.Topics {
		title := strings.TrimSpace(top.Title)
		if title == "" {
			continue
		}
		if seenTitles[title] {
			redundantTopics = append(redundantTopics, top)
		} else {
			seenTitles[title] = true
		}
	}

	needsRefinement := len(unassignedIDs) > 0 || len(overloadedTopics) > 0 || len(redundantTopics) > 0

	return AuditReport{
		UnassignedIDs:    unassignedIDs,
		OverloadedTopics: overloadedTopics,
		RedundantTopics:  redundantTopics,
		NeedsRefinement:  needsRefinement,
	}
}
