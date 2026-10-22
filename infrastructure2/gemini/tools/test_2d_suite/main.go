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
// DECLARATIVE 2D GEOMETRY SCHEMA FOR GEMMA 4
// -----------------------------------------------------------------------------

type Exercise2DVisualSpec struct {
	QuestionID  string               `json:"question_id" jsonschema:"description=Mã câu hỏi (VD: 'Bài 1 (Lớp 8)', 'Bài 2 (Lớp 9)')"`
	Topic       string               `json:"topic" jsonschema:"description=Tóm tắt ngắn chủ đề (VD: 'Hình bình hành & Trung điểm', 'Tứ giác nội tiếp & Tiếp tuyến')"`
	Archetype   string               `json:"archetype" jsonschema:"enum=triangle,enum=parallelogram,enum=quadrilateral,enum=circle_triangle,enum=circle_quadrilateral,enum=circle_tangent,description=Khung hình: triangle (tam giác), parallelogram (hình bình hành), quadrilateral (tứ giác lồi), circle_triangle (tam giác nội tiếp đường tròn), circle_quadrilateral (tứ giác nội tiếp), circle_tangent (tiếp tuyến đường tròn)"`
	Labels      []string             `json:"labels" jsonschema:"description=Tên các điểm cơ sở của khung (VD: ['A', 'B', 'C'] hoặc ['A', 'B', 'C', 'D'] hoặc ['A', 'B', 'C', 'O'])"`
	Derived     []DerivedPoint2DSpec `json:"derived,omitempty" jsonschema:"description=Điểm phụ: trung điểm, hình chiếu vuông góc, giao điểm 2 đường, điểm đối xứng"`
	Lines       []Line2DSpec         `json:"lines,omitempty" jsonschema:"description=Các đoạn thẳng nối thêm giữa các điểm"`
	Circles     []Circle2DSpec       `json:"circles,omitempty" jsonschema:"description=Đường tròn vẽ thêm nếu có"`
	RightAngles [][]string           `json:"right_angles,omitempty" jsonschema:"description=Các góc vuông cần đánh dấu ký hiệu: [['B', 'A', 'C'], ['A', 'H', 'B']]"`
	Polygons    []Polygon2DSpec      `json:"polygons,omitempty" jsonschema:"description=Tứ giác hoặc tam giác cần tô màu nền nhạt"`
}

type DerivedPoint2DSpec struct {
	Name string   `json:"name" jsonschema:"description=Tên điểm phụ (VD: 'E', 'F', 'H', 'M', 'N', 'P', 'Q')"`
	Type string   `json:"type" jsonschema:"enum=midpoint,enum=project,enum=intersection,enum=symmetry,enum=ratio,description=midpoint (trung điểm), project (hình chiếu vuông góc), intersection (giao điểm 2 đường), symmetry (đối xứng tâm), ratio (chia tỉ số)"`
	Of   []string `json:"of" jsonschema:"description=Các điểm tạo nên: ['B', 'C'] cho midpoint; ['A', 'B', 'C'] cho project (hạ từ A xuống BC); ['A', 'C', 'B', 'E'] cho intersection (AC cắt BE); ['N', 'M'] cho symmetry (N đối xứng qua M)"`
	K    float64  `json:"k,omitempty" jsonschema:"description=Tỉ số k từ điểm đầu (0.5 cho midpoint, 0.33 cho 1/3)"`
}

type Line2DSpec struct {
	From  string `json:"from" jsonschema:"description=Điểm bắt đầu"`
	To    string `json:"to" jsonschema:"description=Điểm kết thúc"`
	Style string `json:"style,omitempty" jsonschema:"enum=solid,enum=dashed,description=solid hoặc dashed"`
	Color string `json:"color,omitempty" jsonschema:"description=Mã hex màu: '#2563eb' (xanh), '#dc2626' (đỏ), '#059669' (xanh lá)"`
}

type Circle2DSpec struct {
	Center  string   `json:"center,omitempty" jsonschema:"description=Tên điểm tâm đường tròn"`
	Radius  float64  `json:"radius,omitempty" jsonschema:"description=Bán kính"`
	Through []string `json:"through,omitempty" jsonschema:"description=Đi qua 3 điểm ['A', 'B', 'C'] hoặc đường kính qua 2 điểm ['B', 'C']"`
}

type Polygon2DSpec struct {
	Points []string `json:"points" jsonschema:"description=Các đỉnh tạo nên hình tô màu"`
	Fill   string   `json:"fill,omitempty" jsonschema:"description=Màu nền: '#93c5fd40' hoặc '#fde04740'"`
}

type Batch2DResponse struct {
	Items []Exercise2DVisualSpec `json:"items" jsonschema:"description=Danh sách đặc tả hình vẽ cho các bài tập 2D"`
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

type ProblemItem struct {
	ID   string
	Text string
}

func parseQuestionsFromTxt(filePath string) []ProblemItem {
	data, err := os.ReadFile(filePath)
	if err != nil {
		return nil
	}
	content := string(data)
	var items []ProblemItem

	// Tách theo BÀI 1, BÀI 2...
	rawBlocks := strings.Split(content, "---")
	for _, block := range rawBlocks {
		block = strings.TrimSpace(block)
		if !strings.Contains(block, "BÀI") {
			continue
		}
		rawLines := strings.Split(block, "\n")
		var validLines []string
		for _, rl := range rawLines {
			rl = strings.TrimSpace(rl)
			if rl != "" {
				validLines = append(validLines, rl)
			}
		}
		if len(validLines) == 0 {
			continue
		}
		id := strings.Trim(validLines[0], "#- :")
		text := strings.TrimSpace(strings.Join(validLines[1:], "\n"))
		if id != "" && text != "" {
			items = append(items, ProblemItem{ID: id, Text: text})
		}
	}
	return items
}

func main() {
	fmt.Println("=================================================================")
	fmt.Println("🚀 TEST THỰC TẾ: GEMMA 4 VẼ HÌNH PHẲNG 2D (5 BÀI LỚP 8 + 5 BÀI LỚP 9)")
	fmt.Println("=================================================================")

	ctx := context.Background()
	keys := loadAPIKeys()
	if len(keys) == 0 {
		fmt.Println("❌ LỖI: Không tìm thấy API Key")
		return
	}
	fmt.Printf("✅ Đã nạp %d API Keys vào KeyPool.\n", len(keys))

	pool, err := gemini.NewKeyPool(ctx, keys)
	if err != nil {
		fmt.Printf("❌ Lỗi khởi tạo KeyPool: %v\n", err)
		return
	}

	txtPath := "infrastructure2/gemini/.artifacts/extracted_2d_questions.txt"
	questions := parseQuestionsFromTxt(txtPath)
	fmt.Printf("📚 Đã nạp %d bài toán từ file: %s\n", len(questions), txtPath)

	// Chuẩn bị Schema
	reflector := new(jsonschema.Reflector)
	reflector.ExpandedStruct = true
	reflector.DoNotReference = true
	sch := reflector.Reflect(&Batch2DResponse{})
	schData, _ := json.Marshal(sch)
	genaiSchema := &genai.Schema{}
	_ = json.Unmarshal(schData, genaiSchema)

	systemPrompt := `Bạn là chuyên gia đồ họa hình học phẳng THCS/THPT chuyển đổi đề bài toán hình học 2D thành đặc tả hình vẽ chuẩn (VisualSpec).
YÊU CẦU QUAN TRỌNG:
- KHÔNG CẦN GIẢI TOÁN, CHỈ CẦN DUY NHẤT XÁC ĐỊNH HÌNH VẼ MINH HỌA CHO BÀI TOÁN.
- Với mỗi bài toán:
  + question_id: Giữ nguyên mã câu hỏi (VD: 'BÀI 1 (LỚP 8)', 'BÀI 2 (LỚP 9)').
  + topic: Tóm tắt ngắn chủ đề (VD: 'Hình bình hành & Trung điểm', 'Tứ giác nội tiếp & Tiếp tuyến').
  + archetype: Chọn 1 trong các khung:
      * 'triangle': Cho bài toán bắt đầu bằng tam giác ABC (nhọn, vuông, cân).
      * 'parallelogram': Cho bài toán bắt đầu bằng hình bình hành ABCD.
      * 'quadrilateral': Cho bài toán bắt đầu bằng tứ giác lồi ABCD.
      * 'circle_triangle': Cho bài toán tam giác ABC nội tiếp đường tròn (O).
      * 'circle_quadrilateral': Cho bài toán tứ giác ABCD nội tiếp đường tròn (O) đường kính AD hoặc dây cung.
      * 'circle_tangent': Cho bài toán đường tròn/nửa đường tròn có tiếp tuyến hoặc góc tiếp tuyến.
  + labels: Tên các điểm chính ban đầu theo đề bài.
  + derived: Các điểm phụ xuất hiện trong đề:
      * trung điểm: {name: 'M', type: 'midpoint', of: ['B', 'C']}
      * đối xứng tâm: {name: 'H', type: 'symmetry', of: ['N', 'M']} (N đối xứng qua M)
      * hình chiếu vuông góc / chân đường cao: {name: 'E', type: 'project', of: ['B', 'A', 'C']} (hình chiếu của B lên AC)
      * giao điểm 2 đường thẳng: {name: 'P', type: 'intersection', of: ['A', 'C', 'B', 'E']} (AC cắt BE tại P)
      * chia tỉ số: {name: 'D', type: 'ratio', of: ['A', 'B'], k: 0.33 hoặc 0.67}
  + lines: Các đoạn thẳng nối thêm giữa các điểm ({from: 'A', to: 'C', style: 'solid'|'dashed', color: '#2563eb'|'#dc2626'})
  + circles: Đường tròn phụ nếu đề nhắc đến ({through: ['A', 'B', 'C']} cho đường tròn ngoại tiếp, hoặc {through: ['B', 'C']} cho đường tròn đường kính BC).
  + right_angles: Ký hiệu góc vuông: [['B', 'A', 'C'], ['B', 'E', 'A']].
  + polygons: Mặt phẳng tứ giác/tam giác cần làm nổi bật nếu đề yêu cầu chứng minh hình học.`

	var userPromptBuilder strings.Builder
	userPromptBuilder.WriteString("HÃY XÁC ĐỊNH ĐẶC TẢ HÌNH VẼ 2D MINH HỌA CHO CÁC BÀI TOÁN HÌNH HỌC PHẲNG SAU:\n\n")
	for idx, q := range questions {
		userPromptBuilder.WriteString(fmt.Sprintf("%d. [%s]:\n%s\n\n", idx+1, q.ID, q.Text))
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

	cacheFile := "infrastructure2/gemini/.artifacts/gemma_2d_test_result.json"
	var batchResp Batch2DResponse

	if cachedData, err := os.ReadFile(cacheFile); err == nil && len(cachedData) > 0 {
		fmt.Printf("📦 Đã tìm thấy kết quả từ Gemma 4 trong cache (%s), đang nạp lại...\n", cacheFile)
		_ = json.Unmarshal(cachedData, &batchResp)
	}

	if len(batchResp.Items) == 0 {
		fmt.Printf("📡 Đang gửi %d bài toán 2D đến Model %s qua KeyPool...\n", len(questions), gemini.ModelGemma4_31B)
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

	fmt.Printf("✅ Parse JSON thành công! Gemma 4 đã sinh đặc tả 2D cho %d bài tập.\n", len(batchResp.Items))

	// DỊCH JSON -> MÃ NGUỒN TYPST
	fmt.Println("🎨 Đang dịch thông số Gemma 4 sang tài liệu Typst...")

	var typstDoc strings.Builder
	typstDoc.WriteString(`#set page(paper: "a4", margin: (x: 1.2cm, top: 1.2cm, bottom: 1.2cm))
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans"), size: 8.5pt, lang: "vi")
#import "../archetypes.typ": *

#align(center)[
  #text(size: 15pt, weight: "bold", fill: rgb("#1e3a8a"))[KẾT QUẢ GEMMA 4 VẼ HÌNH HỌC PHẲNG 2D (LỚP 8 & LỚP 9)]
  \ #v(2pt)
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Nguồn đề: Đề cương ôn tập Toán 8 & Chuyên đề Hình học Tuyển sinh 10 Toán 9]
]
#v(6pt)
`)

	for i, item := range batchResp.Items {
		var matchedQ *ProblemItem
		for _, q := range questions {
			if strings.Contains(q.ID, item.QuestionID) || strings.Contains(item.QuestionID, q.ID) {
				matchedQ = &q
				break
			}
		}

		probText := ""
		if matchedQ != nil {
			probText = matchedQ.Text
		}

		// Mỗi trang 2 hoặc 3 hình
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
`, item.QuestionID, item.Topic, formatProblemTextSafe(probText), renderGeo2DTypst(&item)))
	}

	typstPath := "infrastructure2/gemini/.artifacts/TEST_2D_GEOMETRY_OUTPUT.typ"
	pdfPath := "infrastructure2/gemini/.artifacts/TEST_2D_GEOMETRY_OUTPUT.pdf"

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
	pngPattern := "infrastructure2/gemini/.artifacts/test_2d_page_{p}.png"
	cmdPng := exec.Command("typst", "compile", "--root", ".", typstPath, pngPattern)
	cmdPng.Dir = "."
	_ = cmdPng.Run()

	fmt.Println("=================================================================")
	fmt.Println("🏆 HOÀN THÀNH TEST: TOÀN BỘ 10 BÀI TOÁN 2D ĐÃ ĐƯỢC GEMMA 4 VẼ HÌNH!")
	fmt.Println("=================================================================")
}

func renderGeo2DTypst(item *Exercise2DVisualSpec) string {
	archFunc := "geo-2d-triangle"
	switch item.Archetype {
	case "triangle":
		archFunc = "geo-2d-triangle"
	case "parallelogram":
		archFunc = "geo-2d-parallelogram"
	case "quadrilateral":
		archFunc = "geo-2d-quadrilateral"
	case "circle_triangle":
		archFunc = "geo-2d-circle-triangle"
	case "circle_quadrilateral":
		archFunc = "geo-2d-circle-quadrilateral"
	case "circle_tangent":
		archFunc = "geo-2d-circle-tangent"
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

	// Circles
	circlesStr := "()"
	if len(item.Circles) > 0 {
		var parts []string
		for _, c := range item.Circles {
			var thruQuoted []string
			for _, t := range c.Through {
				thruQuoted = append(thruQuoted, fmt.Sprintf("%q", t))
			}
			rVal := c.Radius
			if rVal == 0 {
				rVal = 2.0
			}
			parts = append(parts, fmt.Sprintf(`(center: %q, radius: %v, through: (%s))`, c.Center, rVal, strings.Join(thruQuoted, ", ")))
		}
		circlesStr = "(" + strings.Join(parts, ", ") + ",)"
	}

	// Right angles
	rightAnglesStr := "()"
	if len(item.RightAngles) > 0 {
		var parts []string
		for _, ra := range item.RightAngles {
			if len(ra) >= 3 {
				parts = append(parts, fmt.Sprintf(`(%q, %q, %q)`, ra[0], ra[1], ra[2]))
			}
		}
		rightAnglesStr = "(" + strings.Join(parts, ", ") + ",)"
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
				fillCol = "#93c5fd40"
			}
			parts = append(parts, fmt.Sprintf(`(pts: (%s), fill: rgb(%q))`, strings.Join(ptsQuoted, ", "), fillCol))
		}
		polygonsStr = "(" + strings.Join(parts, ", ") + ",)"
	}

	return fmt.Sprintf("#%s(labels: %s, derived: %s, lines: %s, circles: %s, right_angles: %s, polygons: %s)",
		archFunc, labelsStr, derivedStr, linesStr, circlesStr, rightAnglesStr, polygonsStr)
}

func formatProblemTextSafe(raw string) string {
	var lines []string
	for _, l := range strings.Split(raw, "\n") {
		l = strings.TrimSpace(l)
		if l == "" || strings.HasPrefix(l, "===") || strings.HasPrefix(l, "###") {
			continue
		}
		l = strings.ReplaceAll(l, `\vec{`, "vec(")
		l = strings.ReplaceAll(l, `\widehat{`, "hat(")
		l = strings.ReplaceAll(l, `\Delta`, "Delta")
		l = strings.ReplaceAll(l, `\perp`, "perp")
		l = strings.ReplaceAll(l, `\circ`, "°")
		l = strings.ReplaceAll(l, `\frac{`, "frac(")
		l = strings.ReplaceAll(l, `\sqrt{`, "sqrt(")
		l = strings.ReplaceAll(l, "$", "")
		l = strings.ReplaceAll(l, "**", "")
		l = strings.ReplaceAll(l, "*", "")
		l = strings.ReplaceAll(l, "#", "")
		l = strings.ReplaceAll(l, "[", "(")
		l = strings.ReplaceAll(l, "]", ")")
		l = strings.ReplaceAll(l, "{", "(")
		l = strings.ReplaceAll(l, "}", ")")
		l = strings.ReplaceAll(l, `\`, "")
		lines = append(lines, l)
	}
	return strings.Join(lines, " \\\n        ")
}
