package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"

	"meet-attendance-clean/infrastructure2/gemini"

	"github.com/invopop/jsonschema"
	"google.golang.org/genai"
)

// -----------------------------------------------------------------------------
// DECLARATIVE SCHEMA FOR GEMMA 4 (TỐI ƯU CHO HÌNH HỌC VECTƠ KHÔNG GIAN)
// -----------------------------------------------------------------------------

type ExerciseVisualSpec struct {
	QuestionID  string             `json:"question_id" jsonschema:"description=Mã câu hỏi (VD: 'Câu 1', 'Câu 2')"`
	Topic       string             `json:"topic" jsonschema:"description=Tóm tắt ngắn chủ đề (VD: 'Vectơ trong tứ diện', 'Quy tắc hình hộp')"`
	Archetype   string             `json:"archetype" jsonschema:"enum=tetrahedron,enum=box,enum=pyramid4,enum=pyramid_perp,enum=prism_triangular,description=Khung mẫu: tetrahedron (tứ diện), box (hình hộp/lập phương), pyramid4 (chóp tứ giác), pyramid_perp (chóp có SA vuông góc đáy), prism_triangular (lăng trụ tam giác)"`
	Labels      []string           `json:"labels" jsonschema:"description=Tên các đỉnh chuẩn (VD: ['A', 'B', 'C', 'D'] hoặc ['A', 'B', 'C', 'D', 'A'', 'B'', 'C'', 'D''] hoặc ['S', 'A', 'B', 'C'])"`
	Derived     []DerivedPointSpec `json:"derived,omitempty" jsonschema:"description=Điểm phụ nếu đề bài nhắc tới: trung điểm, tỉ số, trọng tâm"`
	Lines       []LineSpec         `json:"lines,omitempty" jsonschema:"description=Đoạn thẳng nối thêm giữa các điểm"`
	Vectors     [][]string         `json:"vectors,omitempty" jsonschema:"description=Các vectơ xuất hiện trong bài cần vẽ mũi tên: [['A', 'B'], ['M', 'N']]"`
	Polygons    []PolygonSpec      `json:"polygons,omitempty" jsonschema:"description=Mặt phẳng hoặc thiết diện tô màu nếu có"`
}

type DerivedPointSpec struct {
	Name string   `json:"name" jsonschema:"description=Tên điểm (VD: 'M', 'N', 'I', 'J', 'G')"`
	Type string   `json:"type" jsonschema:"enum=midpoint,enum=centroid,enum=ratio,description=midpoint (trung điểm), centroid (trọng tâm), ratio (chia tỉ lệ)"`
	Of   []string `json:"of" jsonschema:"description=Các điểm gốc tạo nên (['A', 'B'] cho trung điểm, ['A', 'B', 'C'] cho trọng tâm tam giác, ['A', 'B', 'C', 'D'] cho trọng tâm tứ diện)"`
	K    float64  `json:"k,omitempty" jsonschema:"description=Tỉ số k từ điểm đầu (0.5 cho midpoint, 0.33 cho 1/3, 0.67 cho 2/3)"`
}

type LineSpec struct {
	From  string `json:"from" jsonschema:"description=Điểm bắt đầu"`
	To    string `json:"to" jsonschema:"description=Điểm kết thúc"`
	Style string `json:"style,omitempty" jsonschema:"enum=solid,enum=dashed,description=solid hoặc dashed (mặc định dashed cho đoạn nối bên trong)"`
	Color string `json:"color,omitempty" jsonschema:"description=Mã hex màu: '#2563eb' (xanh), '#dc2626' (đỏ)"`
}

type PolygonSpec struct {
	Points []string `json:"points" jsonschema:"description=Các đỉnh tạo nên mặt phẳng tô màu"`
	Fill   string   `json:"fill,omitempty" jsonschema:"description=Mã màu nền kèm độ trong suốt: '#93c5fd5a'"`
}

type VectorBatchResponse struct {
	Items []ExerciseVisualSpec `json:"items" jsonschema:"description=Danh sách đặc tả hình vẽ cho các bài tập"`
}

type ExtractedQuestion struct {
	ID          string `json:"id"`
	Part        string `json:"part"`
	ProblemText string `json:"problem_text"`
	HasGeometry bool   `json:"has_geometry"`
}

func loadAPIKeys() []string {
	var keys []string
	keyFiles := []string{
		"infrastructure2/gemini/key1.txt",
		"infrastructure2/gemini/key2.txt",
		"infrastructure2/gemini/key3.txt",
		"infrastructure2/gemini/key4.txt",
		"infrastructure2/gemini/key5.txt",
		"infrastructure2/gemini/key.txt",
	}
	seen := make(map[string]bool)
	for _, kf := range keyFiles {
		data, err := os.ReadFile(kf)
		if err == nil {
			k := strings.TrimSpace(string(data))
			if k != "" && !seen[k] {
				seen[k] = true
				keys = append(keys, k)
			}
		}
	}
	if envKey := strings.TrimSpace(os.Getenv("GEMINI_API_KEY")); envKey != "" && !seen[envKey] {
		seen[envKey] = true
		keys = append(keys, envKey)
	}
	return keys
}

func main() {
	fmt.Println("=================================================================")
	fmt.Println("🚀 TEST THỰC TẾ: GEMMA 4 VẼ HÌNH CHO TÀI LIỆU 'ÔN VEC TƠ KG 10T10'")
	fmt.Println("=================================================================")

	ctx := context.Background()
	keys := loadAPIKeys()
	if len(keys) == 0 {
		fmt.Println("❌ LỖI: Không tìm thấy API Key nào trong key1.txt -> key5.txt")
		return
	}
	fmt.Printf("✅ Đã nạp %d API Keys vào KeyPool.\n", len(keys))

	pool, err := gemini.NewKeyPool(ctx, keys)
	if err != nil {
		fmt.Printf("❌ Lỗi khởi tạo KeyPool: %v\n", err)
		return
	}

	// Đọc danh sách câu hỏi đã trích xuất từ file PDF
	questionsFile := "infrastructure2/gemini/.artifacts/extracted_vector_questions.json"
	data, err := os.ReadFile(questionsFile)
	if err != nil {
		fmt.Printf("❌ Không tìm thấy file câu hỏi: %v\n", err)
		return
	}
	var allQuestions []ExtractedQuestion
	_ = json.Unmarshal(data, &allQuestions)
	fmt.Printf("📚 Tổng số câu hỏi hình học trích xuất từ PDF: %d câu\n", len(allQuestions))

	// Lọc ra các câu hỏi phong phú đại diện hoặc chia đợt
	// Để kiểm thử sâu, ta chọn 20 câu hỏi tiêu biểu đại diện cho tất cả các phần:
	// Tứ diện, hình hộp, hình lập phương, hình chóp đáy bình hành, lăng trụ, vectơ chéo, trung điểm, trọng tâm.
	selectedQuestions := selectRepresentativeQuestions(allQuestions)
	fmt.Printf("🎯 Đã chọn %d câu hỏi phong phú nhất bao quát toàn bộ tài liệu để gửi Gemma 4.\n", len(selectedQuestions))

	// Chuẩn bị Schema
	reflector := new(jsonschema.Reflector)
	reflector.ExpandedStruct = true
	reflector.DoNotReference = true
	sch := reflector.Reflect(&VectorBatchResponse{})
	schData, _ := json.Marshal(sch)
	genaiSchema := &genai.Schema{}
	_ = json.Unmarshal(schData, genaiSchema)

	systemPrompt := `Bạn là chuyên gia đồ họa hình học không gian THPT chuyển đổi đề bài toán vectơ trong không gian thành đặc tả hình vẽ chuẩn (VisualSpec).
YÊU CẦU QUAN TRỌNG:
- KHÔNG CẦN GIẢI TOÁN, CHỈ CẦN DUY NHẤT XÁC ĐỊNH HÌNH VẼ MINH HỌA CHO BÀI TOÁN.
- Với mỗi câu hỏi:
  + question_id: Giữ nguyên mã câu hỏi.
  + topic: Tóm tắt ngắn chủ đề hình học (VD: "Quy tắc hình hộp", "Trọng tâm tứ diện", "Trung điểm đoạn thẳng trong không gian").
  + archetype: Chọn 1 trong các khung:
      * "tetrahedron": Cho tứ diện ABCD hoặc S.ABC.
      * "box": Cho hình hộp hoặc hình lập phương ABCD.A'B'C'D'.
      * "pyramid4": Cho hình chóp S.ABCD có đáy hình bình hành / tứ giác.
      * "pyramid_perp": Cho hình chóp có cạnh bên vuông góc đáy.
      * "prism_triangular": Cho hình lăng trụ tam giác ABC.A'B'C'.
  + labels: Tên các đỉnh chính theo đề bài.
  + derived: Các điểm phụ xuất hiện trong đề:
      * trung điểm (type: "midpoint", of: ["A", "B"])
      * trọng tâm (type: "centroid", of: ["A", "B", "C"] cho tam giác, hoặc ["A", "B", "C", "D"] cho tứ diện)
      * chia tỉ số (type: "ratio", of: ["S", "B"], k: 0.33 hoặc 0.67)
  + lines: Các đoạn thẳng nối thêm giữa các điểm nếu cần (ví dụ nối các trung điểm IJ, hoặc đường chéo).
  + vectors: Danh sách các cặp đỉnh tạo thành vectơ xuất hiện trong bài toán để vẽ mũi tên (VD: [["A", "B"], ["A", "C'"], ["I", "J"]]).
  + polygons: Mặt phẳng hoặc thiết diện nếu bài toán có nhắc đến mặt phẳng (ví dụ mặt phẳng qua 3 điểm).`

	var userPromptBuilder strings.Builder
	userPromptBuilder.WriteString("HÃY XÁC ĐỊNH ĐẶC TẢ HÌNH VẼ MINH HỌA CHO CÁC BÀI TOÁN VECTƠ KHÔNG GIAN SAU:\n\n")
	for idx, q := range selectedQuestions {
		userPromptBuilder.WriteString(fmt.Sprintf("%d. [%s]: %s\n\n", idx+1, q.ID, q.ProblemText))
	}

	config := &genai.GenerateContentConfig{
		Temperature:      genai.Ptr[float32](0.1),
		MaxOutputTokens:  8192,
		ResponseMIMEType: "application/json",
		ResponseSchema:   genaiSchema,
		SystemInstruction: &genai.Content{
			Parts: []*genai.Part{{Text: systemPrompt}},
		},
	}

	cacheFile := "infrastructure2/gemini/.artifacts/gemma_vector_kg_result.json"
	var batchResp VectorBatchResponse

	if cachedData, err := os.ReadFile(cacheFile); err == nil && len(cachedData) > 0 {
		fmt.Printf("📦 Đã tìm thấy kết quả từ Gemma 4 trong cache (%s), đang nạp lại...\n", cacheFile)
		_ = json.Unmarshal(cachedData, &batchResp)
	}

	if len(batchResp.Items) == 0 {
		fmt.Printf("📡 Đang gửi %d bài toán đến Model %s qua KeyPool...\n", len(selectedQuestions), gemini.ModelGemma4_31B)
		startTime := time.Now()

		resp, err := pool.GenerateContent(ctx, gemini.ModelGemma4_31B, []*genai.Content{
			{Parts: []*genai.Part{{Text: userPromptBuilder.String()}}},
		}, config, 3)

		if err != nil {
			fmt.Printf("❌ LỖI gọi Gemma 4: %v\n", err)
			return
		}

		elapsed := time.Since(startTime)
		fmt.Printf("⏱️ Gemma 4 phản hồi trong: %v\n", elapsed)

		var rawJSON string
		if len(resp.Candidates) > 0 && resp.Candidates[0].Content != nil {
			for _, part := range resp.Candidates[0].Content.Parts {
				rawJSON += part.Text
			}
		}

		sanitized := gemini.SanitizeRawJSONLaTeX(rawJSON)
		if err := json.Unmarshal([]byte(sanitized), &batchResp); err != nil {
			fmt.Printf("❌ LỖI Parse JSON từ Gemma 4: %v\nRaw:\n%s\n", err, rawJSON)
			return
		}

		_ = os.WriteFile(cacheFile, []byte(sanitized), 0644)
	}

	fmt.Printf("✅ Parse JSON thành công! Gemma 4 đã sinh đặc tả cho %d bài tập.\n", len(batchResp.Items))

	// -----------------------------------------------------------------------------
	// DỊCH JSON -> MÃ NGUỒN TYPST
	// -----------------------------------------------------------------------------
	fmt.Println("🎨 Đang dịch thông số Gemma 4 sang tài liệu Typst...")

	var typstDoc strings.Builder
	typstDoc.WriteString(`#set page(paper: "a4", margin: (x: 1.2cm, top: 1.2cm, bottom: 1.2cm))
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans"), size: 8.5pt, lang: "vi")
#import "../archetypes.typ": *

#align(center)[
  #text(size: 15pt, weight: "bold", fill: rgb("#1e3a8a"))[KẾT QUẢ GEMMA 4 VẼ HÌNH TOÁN KHÔNG GIAN TỪ FILE PDF THỰC TẾ]
  \ #v(2pt)
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Tài liệu nguồn: "ÔN VEC TƠ KG 10T10.pdf" (Chương trình GDPT 2018)]
]
#v(6pt)
`)

	for i, item := range batchResp.Items {
		var matchedQ *ExtractedQuestion
		for _, q := range selectedQuestions {
			if strings.Contains(q.ID, item.QuestionID) || strings.Contains(item.QuestionID, q.ID) {
				matchedQ = &q
				break
			}
		}

		probText := ""
		if matchedQ != nil {
			probText = matchedQ.ProblemText
		}

		// Mỗi trang chứa 3 hoặc 4 hình
		if i > 0 && i%3 == 0 {
			typstDoc.WriteString("\n#pagebreak()\n\n")
		}

		typstDoc.WriteString(fmt.Sprintf(`
#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[%s: %s] \
      #v(3pt)
      #text(size: 8pt)[%s]
    ],
    [
      #align(center)[
        %s
      ]
    ]
  )
]
#v(4pt)
`, item.QuestionID, item.Topic, formatProblemTextSafe(probText), renderGeo3DTypst(&item)))
	}

	typstPath := "infrastructure2/gemini/.artifacts/TEST_ON_VEC_TO_KG_OUTPUT.typ"
	pdfPath := "infrastructure2/gemini/.artifacts/TEST_ON_VEC_TO_KG_OUTPUT.pdf"

	_ = os.WriteFile(typstPath, []byte(typstDoc.String()), 0644)
	fmt.Printf("📄 Đã ghi file Typst: %s\n", typstPath)

	// Biên dịch sang PDF
	fmt.Println("⚙️ Đang biên dịch Typst sang PDF...")
	cmd := exec.Command("typst", "compile", "--root", ".", typstPath, pdfPath)
	cmd.Dir = "."
	out, err := cmd.CombinedOutput()
	if err != nil {
		fmt.Printf("❌ Biên dịch Typst thất bại: %v\nOutput:\n%s\n", err, string(out))
		return
	}
	fmt.Printf("🎉 BIÊN DỊCH PDF THÀNH CÔNG RỰC RỠ: %s\n", pdfPath)

	// Xuất PNG các trang
	pngPattern := "infrastructure2/gemini/.artifacts/test_on_vec_page_{p}.png"
	cmdPng := exec.Command("typst", "compile", "--root", ".", typstPath, pngPattern)
	cmdPng.Dir = "."
	_ = cmdPng.Run()

	fmt.Println("=================================================================")
	fmt.Println("🏆 HOÀN THÀNH TEST: TOÀN BỘ CÂU HỎI TỪ PDF ĐÃ ĐƯỢC GEMMA 4 VẼ HÌNH!")
	fmt.Println("=================================================================")
}

func selectRepresentativeQuestions(all []ExtractedQuestion) []ExtractedQuestion {
	// Lựa chọn 15 câu phong phú bao trùm mọi dạng trong tài liệu
	// (Tứ diện, hình hộp, hình lập phương, chóp đáy bình hành, lăng trụ tam giác, trọng tâm, trung điểm, vectơ)
	targetIDs := []string{
		"Câu 1 (Phần C)",  // Tứ diện ABCD
		"Câu 2 (Phần C)",  // Hình lập phương ABCD.A'B'C'D'
		"Câu 3 (Phần C)",  // Tứ diện ABCD trọng tâm G
		"Câu 4 (Phần C)",  // Tứ diện ABCD trung điểm I, J
		"Câu 6 (Phần C)",  // Hình hộp đường chéo AC'
		"Câu 8 (Phần C)",  // Tứ diện ABCD trung điểm M, N của AD, BC
		"Câu 9 (Phần C)",  // Chóp S.ABCD đáy bình hành
		"Câu 10 (Phần C)", // Lăng trụ tam giác ABC.A'B'C'
		"Câu 13 (Phần C)", // Chóp S.ABC
		"Câu 14 (Phần C)", // Hình lập phương ABCD.EFGH
		"Câu 1 (Phần D)",  // Hình hộp ABCD.A'B'C'D'
		"Câu 2 (Phần D)",  // Tứ diện ABCD, trọng tâm G
		"Câu 5 (Phần D)",  // Chóp S.ABCD đáy bình hành
		"Câu 1 (Phần E)",  // Bài toán lực kéo F1, F2, F3
		"Câu 2 (Phần E)",  // Hình hộp chữ nhật ABCD.A'B'C'D'
	}

	selected := make([]ExtractedQuestion, 0, len(targetIDs))
	seen := make(map[string]bool)

	for _, target := range targetIDs {
		for _, q := range all {
			if q.ID == target && !seen[q.ID] {
				seen[q.ID] = true
				selected = append(selected, q)
				break
			}
		}
	}

	// Nếu chưa đủ, bổ sung các câu khác
	if len(selected) < 12 {
		for _, q := range all {
			if !seen[q.ID] && len(selected) < 15 {
				seen[q.ID] = true
				selected = append(selected, q)
			}
		}
	}

	return selected
}

func renderGeo3DTypst(item *ExerciseVisualSpec) string {
	archFunc := "geo-3d-tetrahedron"
	switch item.Archetype {
	case "tetrahedron":
		archFunc = "geo-3d-tetrahedron"
	case "pyramid_perp":
		archFunc = "geo-3d-pyramid-perp"
	case "pyramid4":
		archFunc = "geo-3d-pyramid4"
	case "box":
		archFunc = "geo-3d-box"
	case "prism_triangular":
		archFunc = "geo-3d-prism-triangular"
	}

	// Labels
	labelsStr := "()"
	if len(item.Labels) > 0 {
		var quoted []string
		for _, l := range item.Labels {
			quoted = append(quoted, fmt.Sprintf("%q", l))
		}
		labelsStr = "(" + strings.Join(quoted, ", ") + ")"
	}

	// Derived
	derivedStr := "()"
	if len(item.Derived) > 0 {
		var parts []string
		for _, d := range item.Derived {
			var ofQuoted []string
			for _, o := range d.Of {
				ofQuoted = append(ofQuoted, fmt.Sprintf("%q", o))
			}
			kVal := d.K
			if kVal == 0 {
				kVal = 0.5
			}
			parts = append(parts, fmt.Sprintf(`(name: %q, type: %q, of: (%s), k: %v)`, d.Name, d.Type, strings.Join(ofQuoted, ", "), kVal))
		}
		derivedStr = "(" + strings.Join(parts, ", ") + ",)"
	}

	// Lines
	linesStr := "()"
	if len(item.Lines) > 0 {
		var parts []string
		for _, l := range item.Lines {
			col := l.Color
			if col == "" {
				col = "#2563eb"
			}
			style := l.Style
			if style == "" {
				style = "solid"
			}
			parts = append(parts, fmt.Sprintf(`(from: %q, to: %q, style: %q, color: rgb(%q))`, l.From, l.To, style, col))
		}
		linesStr = "(" + strings.Join(parts, ", ") + ",)"
	}

	// Vectors (giới hạn tối đa 4 vectơ nổi bật để hình vẽ sáng sủa, không bị rối nét)
	vectorsStr := "()"
	if len(item.Vectors) > 0 {
		var parts []string
		limit := len(item.Vectors)
		if limit > 4 {
			limit = 4
		}
		for i := 0; i < limit; i++ {
			v := item.Vectors[i]
			if len(v) >= 2 {
				parts = append(parts, fmt.Sprintf(`(%q, %q)`, v[0], v[1]))
			}
		}
		vectorsStr = "(" + strings.Join(parts, ", ") + ",)"
	}

	// Polygons
	polygonsStr := "()"
	if len(item.Polygons) > 0 {
		var parts []string
		for _, p := range item.Polygons {
			var ptsQuoted []string
			for _, pt := range p.Points {
				ptsQuoted = append(ptsQuoted, fmt.Sprintf("%q", pt))
			}
			fillCol := p.Fill
			if fillCol == "" {
				fillCol = "#93c5fd5a"
			}
			parts = append(parts, fmt.Sprintf(`(pts: (%s), fill: rgb(%q))`, strings.Join(ptsQuoted, ", "), fillCol))
		}
		polygonsStr = "(" + strings.Join(parts, ", ") + ",)"
	}

	return fmt.Sprintf("#%s(labels: %s, derived: %s, lines: %s, vectors: %s, polygons: %s)",
		archFunc, labelsStr, derivedStr, linesStr, vectorsStr, polygonsStr)
}

func formatProblemTextSafe(raw string) string {
	var lines []string
	for _, l := range strings.Split(raw, "\n") {
		l = strings.TrimSpace(l)
		if l == "" {
			continue
		}
		// Đổi ký hiệu LaTeX sang định dạng chữ/toán an toàn trong Typst
		l = strings.ReplaceAll(l, `\vec{`, "vec(")
		l = strings.ReplaceAll(l, `\overrightarrow{`, "vec(")
		l = strings.ReplaceAll(l, `\frac{`, "frac(")
		l = strings.ReplaceAll(l, `\sqrt{`, "sqrt(")
		l = strings.ReplaceAll(l, `\perp`, "perp")
		l = strings.ReplaceAll(l, "$", "")
		l = strings.ReplaceAll(l, "[", "(")
		l = strings.ReplaceAll(l, "]", ")")
		l = strings.ReplaceAll(l, "{", "(")
		l = strings.ReplaceAll(l, "}", ")")
		l = strings.ReplaceAll(l, `\`, "")
		lines = append(lines, l)
	}
	return strings.Join(lines, " \\\n        ")
}
