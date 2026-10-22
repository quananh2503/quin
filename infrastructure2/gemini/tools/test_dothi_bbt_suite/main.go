package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"

	"google.golang.org/genai"
	"meet-attendance-clean/infrastructure2/gemini"
)

// Cấu trúc JSON nhận từ Gemma 4
type CurveSpec struct {
	Expression string    `json:"expression"`
	Domain     []float64 `json:"domain"`
	Color      string    `json:"color"`
	Style      string    `json:"style"`
}

type AsymptoteSpec struct {
	Type       string    `json:"type"` // "vertical", "horizontal", "oblique"
	At         float64   `json:"at"`
	Expression string    `json:"expression"`
	Domain     []float64 `json:"domain"`
	Color      string    `json:"color"`
	Style      string    `json:"style"`
}

type SpecialPointSpec struct {
	X     float64 `json:"x"`
	Y     float64 `json:"y"`
	Label string  `json:"label"`
}

type GraphItemSpec struct {
	ID            string             `json:"id"`
	Topic         string             `json:"topic"`
	FnType        string             `json:"fn_type"`
	XRange        []float64          `json:"x_range"`
	YRange        []float64          `json:"y_range"`
	XStep         float64            `json:"x_step"`
	YStep         float64            `json:"y_step"`
	Curves        []CurveSpec        `json:"curves"`
	Asymptotes    []AsymptoteSpec    `json:"asymptotes"`
	SpecialPoints []SpecialPointSpec `json:"special_points"`
}

type YRowCell struct {
	Pos       string  `json:"pos"` // "top", "bottom", "bottom_top"
	Val       string  `json:"val"`
	DoubleBar bool    `json:"double_bar"`
	Left      string  `json:"left"`
	Right     string  `json:"right"`
}

type TableItemSpec struct {
	ID          string     `json:"id"`
	Topic       string     `json:"topic"`
	Variable    string     `json:"variable"`
	Domain      []string   `json:"domain"`
	YPrimeSigns []string   `json:"y_prime_signs"`
	YRows       []YRowCell `json:"y_rows"`
}

type BatchDothiBBTSpec struct {
	Graphs []GraphItemSpec `json:"graphs"`
	Tables []TableItemSpec `json:"tables"`
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
	fmt.Println("🚀 TEST THỰC TẾ: GEMMA 4 VẼ ĐỒ THỊ Oxy & BẢNG BIẾN THIÊN (BBT)")
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

	txtPath := "infrastructure2/gemini/.artifacts/extracted_dothi_bbt.txt"
	contentBytes, err := os.ReadFile(txtPath)
	if err != nil {
		fmt.Printf("❌ Lỗi đọc file extracted_dothi_bbt.txt: %v\n", err)
		return
	}
	rawContent := string(contentBytes)

	cacheFile := "infrastructure2/gemini/.artifacts/gemma_dothi_bbt_result.json"
	var batchResp BatchDothiBBTSpec

	cachedData, err := os.ReadFile(cacheFile)
	if err == nil && len(cachedData) > 50 {
		fmt.Printf("📦 Đã tìm thấy kết quả từ Gemma 4 trong cache (%s), đang nạp lại...\n", cacheFile)
		_ = json.Unmarshal(cachedData, &batchResp)
	}

	if len(batchResp.Graphs) == 0 || len(batchResp.Tables) == 0 {
		fmt.Println("🤖 Đang gửi đề bài cho Gemma 4 (gemma-4-31b-it) để phân tích & sinh thông số...")

		prompt := fmt.Sprintf(`Bạn là Kỹ sư Trưởng kiêm Chuyên gia Toán học Giải tích THPT (GDPT 2018).
Dưới đây là 5 bài toán Đồ thị tiêu biểu và 3 bài toán Bảng biến thiên (BBT) trích xuất từ tài liệu đề thi THPT:

%s

---
NHIỆM VỤ CỦA BẠN:
Hãy phân tích từng bài và trả về MỘT OBJECT JSON DUY NHẤT theo schema sau (KHÔNG giải thích thêm, KHÔNG markdown thừa ngoài khối json):

{
  "graphs": [
    {
      "id": "ĐỒ THỊ 1",
      "topic": "Hàm số bậc 3 (a < 0)",
      "fn_type": "cubic",
      "x_range": [-3.5, 4.5],
      "y_range": [-2.0, 5.5],
      "x_step": 1.0,
      "y_step": 1.0,
      "curves": [
        {
          "expression": "x => -0.222 * calc.pow(x, 3) + 0.333 * calc.pow(x, 2) + 1.333 * x + 1.778",
          "domain": [-2.2, 3.8],
          "color": "#2563eb",
          "style": "solid"
        }
      ],
      "asymptotes": [],
      "special_points": [
        {"x": -1.0, "y": 1.0, "label": "(-1; 1)"},
        {"x": 2.0, "y": 4.0, "label": "(2; 4)"},
        {"x": 3.0, "y": 0.0, "label": "(3; 0)"}
      ]
    }
    // ... ĐỒ THỊ 2, 3, 4, 5
  ],
  "tables": [
    {
      "id": "BBT 1",
      "topic": "Hàm phân thức bậc 2/1 có tiệm cận đứng",
      "variable": "x",
      "domain": ["-oo", "-4", "-1", "2", "+oo"],
      "y_prime_signs": ["+", "0", "-", "||", "-", "0", "+"],
      "y_rows": [
        {"pos": "bottom", "val": "-oo"},
        {"pos": "top", "val": "-11"},
        {"pos": "bottom_top", "double_bar": true, "left": "-oo", "right": "+oo"},
        {"pos": "bottom", "val": "1"},
        {"pos": "top", "val": "+oo"}
      ]
    }
    // ... BBT 2, 3
  ]
}

LƯU Ý QUAN TRỌNG:
1. ĐỒ THỊ 1: Hàm bậc 3 có a < 0, cực tiểu (-1; 1), cực đại (2; 4), cắt Ox tại (3; 0). Biểu thức Typst tính qua calc.pow(x, 3), calc.pow(x, 2).
2. ĐỒ THỊ 2: Hàm bậc 3 y = x^3 - 3x^2 + 1, cực đại (0; 1), cực tiểu (2; -3). Expression: "x => calc.pow(x, 3) - 3 * calc.pow(x, 2) + 1", domain: [-1.2, 3.2].
3. ĐỒ THỊ 3: Hàm phân thức y = (x^2 - 2x + 3)/(x - 1). Chia làm 2 nhánh: domain 1: [-2.5, 0.8], domain 2: [1.2, 4.5]. Tiệm cận đứng x = 1 (type: "vertical", at: 1), tiệm cận xiên y = x - 1 (type: "oblique", expression: "x => x - 1", domain: [-3, 5]).
4. ĐỒ THỊ 4: Hàm phân thức y = (x^2 - 3x + 3)/(x - 2) (hoặc tương đương). Tiệm cận đứng x = 2, tiệm cận xiên y = x - 1, cực đại (1; -1), cực tiểu (3; 3).
5. ĐỒ THỊ 5: So sánh 2 đồ thị: đường cong Gauss y = calc.exp(-calc.pow(x, 2)/2) và Parabol y = 1 - calc.pow(x, 2)/2. Cùng chung đỉnh (0; 1).
6. BBT 1: Điểm gián đoạn tại x = -1 có double_bar: true (left: "-oo", right: "+oo").
7. BBT 2: Hàm bậc 4 trùng phương 3 cực trị x = -1, 0, 1. y_prime_signs: ["-", "0", "+", "0", "-", "0", "+"]. y_rows: cực tiểu -3, cực đại 0, cực tiểu -3.
8. BBT 3: Hàm phân thức y = (2x-1)/(x-3). Tiệm cận đứng x = 3, tiệm cận ngang y = 2. y_prime_signs: ["-", "||", "-"]. y_rows: giảm từ 2 xuống -oo, double_bar tại 3, giảm từ +oo xuống 2.
`, rawContent)

		config := &genai.GenerateContentConfig{
			Temperature: &[]float32{0.1}[0],
			SystemInstruction: &genai.Content{
				Parts: []*genai.Part{{Text: "Bạn là Kỹ sư Trưởng chuyên gia đồ họa Toán THPT. Trả về đúng JSON theo định dạng yêu cầu."}},
			},
		}

		startTime := time.Now()
		resp, err := pool.GenerateContent(ctx, gemini.ModelGemma4_31B, []*genai.Content{
			{Parts: []*genai.Part{{Text: prompt}}},
		}, config, 5)

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
			fmt.Printf("❌ Lỗi parse JSON từ Gemma 4: %v\nPhản hồi thô:\n%s\n", err, rawJSON)
			return
		}

		_ = os.WriteFile(cacheFile, []byte(sanitized), 0644)
	}

	fmt.Printf("✅ Parse JSON thành công! Gemma 4 đã sinh đặc tả cho %d Đồ thị và %d Bảng biến thiên.\n",
		len(batchResp.Graphs), len(batchResp.Tables))

	// TẠO TÀI LIỆU TYPST
	fmt.Println("🎨 Đang dịch thông số sang tài liệu Typst...")

	var typstDoc strings.Builder
	typstDoc.WriteString(`#set page(paper: "a4", margin: (x: 1.2cm, top: 1.2cm, bottom: 1.2cm))
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans"), size: 8.5pt, lang: "vi")
#import "@preview/cetz:0.3.3" as cetz-v3
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/vartable:0.2.4": tabvar

#align(center)[
  #text(size: 15pt, weight: "bold", fill: rgb("#1e3a8a"))[KẾT QUẢ GEMMA 4 VẼ ĐỒ THỊ HÀM SỐ & BẢNG BIẾN THIÊN]
  \ #v(2pt)
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Nguồn đề: Tài liệu Chuyên đề Đồ thị & Bảng biến thiên THPT (testdothibbt.pdf)]
]
#v(6pt)

#align(center)[
  #text(size: 12pt, weight: "bold", fill: rgb("#0f766e"))[PHẦN 1: 5 ĐỒ THỊ TIÊU BIỂU (BẬC 3, BẬC 4, PHÂN THỨC TIỆM CẬN XIÊN, ĐƯỜNG CONG GAUSS)]
]
#v(4pt)
`)

	for i, g := range batchResp.Graphs {
		if i == 2 || i == 4 {
			typstDoc.WriteString("\n#pagebreak()\n\n")
		}

		plotCode := renderGraphTypst(&g)

		typstDoc.WriteString(fmt.Sprintf(`
#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%%)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 12pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[%s: %s] \
      #v(4pt)
      #text(size: 8.5pt)[
        - *Dạng hàm số:* %s \
        - *Miền hiển thị:* $x in [%.1f; %.1f]$, $y in [%.1f; %.1f]$ \
        - *Đường tiệm cận:* %s \
        - *Điểm đặc biệt (Cực trị / Giao điểm):* \
        %s
      ]
    ],
    [
      #align(center)[
        %s
      ]
    ]
  )
]
#v(6pt)
`, g.ID, g.Topic, g.FnType,
			g.XRange[0], g.XRange[1], g.YRange[0], g.YRange[1],
			formatAsymptotesSummary(&g),
			formatPointsSummary(&g),
			plotCode))
	}

	typstDoc.WriteString(`
#pagebreak()
#align(center)[
  #text(size: 12pt, weight: "bold", fill: rgb("#0f766e"))[PHẦN 2: 3 BẢNG BIẾN THIÊN TIÊU BIỂU (GIÁN ĐOẠN TIỆM CẬN, TRÙNG PHƯƠNG, HÀM PHÂN THỨC ĐƠN ĐIỆU)]
]
#v(6pt)
`)

	for _, t := range batchResp.Tables {
		tabvarCode := renderTableTypst(&t)

		typstDoc.WriteString(fmt.Sprintf(`
#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 6pt, radius: 4pt, width: 100%%)[
  #text(weight: "bold", size: 9.5pt, fill: rgb("#0f766e"))[%s: %s] \
  #v(2pt)
  #align(center)[
    %s
  ]
]
#v(4pt)
`, t.ID, t.Topic, tabvarCode))
	}

	typstPath := "infrastructure2/gemini/.artifacts/TEST_DOTHI_BBT_OUTPUT.typ"
	pdfPath := "infrastructure2/gemini/.artifacts/TEST_DOTHI_BBT_OUTPUT.pdf"

	_ = os.WriteFile(typstPath, []byte(typstDoc.String()), 0644)
	fmt.Printf("📄 Đã ghi file Typst: %s\n", typstPath)

	// Biên dịch PDF
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
	pngPattern := "infrastructure2/gemini/.artifacts/test_dothi_bbt_page_{p}.png"
	cmdPng := exec.Command("typst", "compile", "--root", ".", typstPath, pngPattern)
	cmdPng.Dir = "."
	_ = cmdPng.Run()

	fmt.Println("=================================================================")
	fmt.Println("🏆 HOÀN THÀNH TEST: TOÀN BỘ 5 ĐỒ THỊ & 3 BẢNG BIẾN THIÊN ĐÃ ĐƯỢC XUẤT BẢN!")
	fmt.Println("=================================================================")
}

func formatAsymptotesSummary(g *GraphItemSpec) string {
	if len(g.Asymptotes) == 0 {
		return "Không có"
	}
	var res []string
	for _, as := range g.Asymptotes {
		if as.Type == "vertical" {
			res = append(res, fmt.Sprintf("Đứng $x = %v$", as.At))
		} else if as.Type == "horizontal" {
			res = append(res, fmt.Sprintf("Ngang $y = %v$", as.At))
		} else if as.Type == "oblique" {
			res = append(res, "Xiên")
		}
	}
	return strings.Join(res, ", ")
}

func formatPointsSummary(g *GraphItemSpec) string {
	if len(g.SpecialPoints) == 0 {
		return "        (Không đánh dấu)"
	}
	var res []string
	for _, pt := range g.SpecialPoints {
		res = append(res, fmt.Sprintf("        + Tọa độ $(%.1f; %.1f)$: %s", pt.X, pt.Y, pt.Label))
	}
	return strings.Join(res, "\n")
}

func renderGraphTypst(g *GraphItemSpec) string {
	xMin := -3.0
	xMax := 4.0
	if len(g.XRange) >= 2 {
		xMin = g.XRange[0]
		xMax = g.XRange[1]
	}
	yMin := -4.0
	yMax := 5.0
	if len(g.YRange) >= 2 {
		yMin = g.YRange[0]
		yMax = g.YRange[1]
	}
	xStep := g.XStep
	if xStep <= 0 {
		xStep = 1.0
	}
	yStep := g.YStep
	if yStep <= 0 {
		yStep = 1.0
	}

	var plotAdds []string

	// Curves
	for _, c := range g.Curves {
		dMin := xMin + 0.2
		dMax := xMax - 0.2
		if len(c.Domain) >= 2 {
			dMin = c.Domain[0]
			dMax = c.Domain[1]
		}
		col := c.Color
		if col == "" {
			col = "#2563eb"
		}
		plotAdds = append(plotAdds, fmt.Sprintf(`plot.add(domain: (%.2f, %.2f), %s, style: (stroke: 1.2pt + rgb(%q)))`,
			dMin, dMax, c.Expression, col))
	}

	// Asymptotes
	for _, as := range g.Asymptotes {
		col := as.Color
		if col == "" {
			col = "#dc2626"
		}
		if as.Type == "vertical" {
			plotAdds = append(plotAdds, fmt.Sprintf(`plot.add-vline(%v, min: %.1f, max: %.1f, style: (stroke: (dash: "dashed", paint: rgb(%q))))`,
				as.At, yMin, yMax, col))
		} else if as.Type == "horizontal" {
			plotAdds = append(plotAdds, fmt.Sprintf(`plot.add-hline(%v, min: %.1f, max: %.1f, style: (stroke: (dash: "dashed", paint: rgb(%q))))`,
				as.At, xMin, xMax, col))
		} else if as.Type == "oblique" && as.Expression != "" {
			dMin := xMin
			dMax := xMax
			if len(as.Domain) >= 2 {
				dMin = as.Domain[0]
				dMax = as.Domain[1]
			}
			plotAdds = append(plotAdds, fmt.Sprintf(`plot.add(domain: (%.2f, %.2f), %s, style: (stroke: (dash: "dashed", paint: rgb(%q))))`,
				dMin, dMax, as.Expression, col))
		}
	}

	// Special points
	if len(g.SpecialPoints) > 0 {
		var ptCoords []string
		for _, p := range g.SpecialPoints {
			ptCoords = append(ptCoords, fmt.Sprintf("(%.2f, %.2f)", p.X, p.Y))
		}
		plotAdds = append(plotAdds, fmt.Sprintf(`plot.add((%s,), style: (stroke: none), mark: "o", mark-size: 0.12)`,
			strings.Join(ptCoords, ", ")))
	}

	body := strings.Join(plotAdds, "\n        ")

	return fmt.Sprintf(`#cetz-v3.canvas({
      import cetz-v3.draw: *
      plot.plot(
        size: (5.2, 3.6),
        axis-style: "school-book",
        x-tick-step: %.1f, y-tick-step: %.1f,
        x-label: $x$, y-label: $y$,
        x-min: %.1f, x-max: %.1f, y-min: %.1f, y-max: %.1f,
        {
        %s
        }
      )
    })`, xStep, yStep, xMin, xMax, yMin, yMax, body)
}

func renderTableTypst(t *TableItemSpec) string {
	// Domain
	var domainParts []string
	for _, d := range t.Domain {
		if strings.HasPrefix(d, "$") {
			domainParts = append(domainParts, d)
		} else {
			domainParts = append(domainParts, "$"+d+"$")
		}
	}
	domainStr := "(" + strings.Join(domainParts, ", ") + ")"

	// Signs row
	// Thuật toán xây dựng contents cho y_prime
	// e.g. domain: -oo, -4, -1, 2, +oo (4 khoảng)
	// signs: ["+", "0", "-", "||", "-", "0", "+"] -> ($+$, ("0", $-$), ("||", $-$), ("0", $+$))
	var primeRowParts []string
	if len(t.YPrimeSigns) > 0 {
		firstSign := t.YPrimeSigns[0]
		primeRowParts = append(primeRowParts, "$"+firstSign+"$")

		for i := 1; i < len(t.YPrimeSigns)-1; i += 2 {
			boundaryMark := t.YPrimeSigns[i]
			nextSign := t.YPrimeSigns[i+1]
			primeRowParts = append(primeRowParts, fmt.Sprintf(`(%q, $%s$)`, boundaryMark, nextSign))
		}
	}
	primeRowStr := "(" + strings.Join(primeRowParts, ", ") + ")"

	// Y row
	var yRowParts []string
	for _, yr := range t.YRows {
		if yr.DoubleBar {
			leftVal := yr.Left
			if leftVal == "" {
				leftVal = "-oo"
			}
			rightVal := yr.Right
			if rightVal == "" {
				rightVal = "+oo"
			}
			yRowParts = append(yRowParts, fmt.Sprintf(`(bottom, top, "||", $%s$, $%s$)`, leftVal, rightVal))
		} else {
			pos := yr.Pos
			if pos == "" {
				pos = "bottom"
			}
			val := yr.Val
			if val == "" {
				val = "0"
			}
			yRowParts = append(yRowParts, fmt.Sprintf(`(%s, $%s$)`, pos, val))
		}
	}
	yRowStr := "(\n        " + strings.Join(yRowParts, ",\n        ") + ",\n      )"

	return fmt.Sprintf(`#tabvar(
    variable: $%s$,
    label: (
      ([$y'$], "s"),
      ([$y$], "v"),
    ),
    domain: %s,
    nocadre: true,
    line-style: (stroke: none),
    arrow-mark: (end: ">"),
    arrow-style: (stroke: 0.8pt + black),
    table-style: (stroke: 0.6pt + black),
    contents: (
      %s,
      %s
    ),
  )`, t.Variable, domainStr, primeRowStr, yRowStr)
}
