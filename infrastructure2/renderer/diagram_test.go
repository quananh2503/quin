package renderer

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// Nhúng nguyên vẹn chuỗi JSON Đề thi Học kì I của bạn
const examLessonJSON = `{
  "id": "badbcd2c-a40a-46db-b9e8-784cd7688012",
  "title": "Đề kiểm tra cuối học kì I – Toán 12 (Đáp án & Lời giải chi tiết)",
  "overview": "Chuyên đề tổng hợp kiến thức và phương pháp giải các dạng bài tập trong Đề kiểm tra cuối học kì I môn Toán 12. Bài học bao gồm 3 phần lý thuyết trọng tâm: Khảo sát hàm số & đồ thị, Vectơ và hệ tọa độ trong không gian, cùng các đặc trưng đo xu thế trung tâm và độ tán sắc cho mẫu số liệu ghép nhóm.",
  "sections": [
    {
      "SectionTitle": "Khảo sát và vẽ đồ thị hàm số",
      "DetailedContent": "### 1. Tính đơn điệu của hàm số\n- Hàm số $y = f(x)$ đồng biến trên khoảng $K$ khi và chỉ khi $f'(x) \\ge 0, \\forall x \\in K$ (dấu bằng xảy ra tại hữu hạn điểm).\n- Hàm số $y = f(x)$ nghịch biến trên khoảng $K$ khi và chỉ khi $f'(x) \\le 0, \\forall x \\in K$.\n\n### 2. Cực trị của hàm số\n- Giá trị cực đại $y_{CĐ} = f(x_{CĐ})$ tại điểm cực đại $x_{CĐ}$.\n- Giá trị cực tiểu $y_{CT} = f(x_{CT})$ tại điểm cực tiểu $x_{CT}$.\n\n### 3. Đường tiệm cận của đồ thị hàm số\n- **Tiệm cận đứng:** Đường thẳng $x = x_0$ là tiệm cận đứng nếu $\\lim_{x \\to x_0^+} f(x) = \\pm\\infty$ hoặc $\\lim_{x \\to x_0^-} f(x) = \\pm\\infty$.\n- **Tiệm cận xiên:** Đường thẳng $y = ax + b$ ($a \\ne 0$) là tiệm cận xiên nếu $\\lim_{x \\to \\pm\\infty} [f(x) - (ax + b)] = 0$. Trong đó:\n$$a = \\lim_{x \\to \\pm\\infty} \\frac{f(x)}{x}, \\quad b = \\lim_{x \\to \\pm\\infty} [f(x) - ax]$$",
      "KeyTakeaway": "Nắm vững mối liên hệ giữa dấu của đạo hàm $f'(x)$ với khoảng đồng biến, nghịch biến và các điểm cực trị; kỹ năng tìm tiệm cận đứng, tiệm cận xiên từ công thức hàm số phân thức.",
      "TeacherExamples": [
        {
          "ExampleNum": 1,
          "Problem": "Cho hàm số $y = \\frac{2x^2 - 3x + 5}{x - 1}$. Tìm phương trình đường tiệm cận xiên của đồ thị hàm số.",
          "TeacherSolution": "Ta biến đổi dạng phân thức:\n$$y = \\frac{2x(x - 1) - x + 5}{x - 1} = 2x - 1 + \\frac{4}{x - 1}$$\nVì $\\lim_{x \\to \\pm\\infty} \\frac{4}{x - 1} = 0$ nên đường thẳng $y = 2x - 1$ là đường tiệm cận xiên của đồ thị hàm số."
        }
      ]
    },
    {
      "SectionTitle": "Vectơ và tọa độ trong không gian",
      "DetailedContent": "### 1. Phép toán vectơ trong không gian\n- Quy tắc hình hộp: Với hình hộp $ABCD.A'B'C'D'$, ta có $\\vec{AB} + \\vec{AD} + \\vec{AA'} = \\vec{AC'}$.\n- Tích vô hướng của hai vectơ: $\\vec{u} \\cdot \\vec{v} = |\\vec{u}| \\cdot |\\vec{v}| \\cdot \\cos(\\vec{u}, \\vec{v})$.\n\n### 2. Tọa độ của vectơ và điểm\n- Trong hệ tọa độ $Oxyz$, nếu $\\vec{u} = x\\vec{i} + y\\vec{j} + z\\vec{k}$ thì $\\vec{u} = (x; y; z)$.\n- Tích vô hướng bằng tọa độ: $\\vec{u} \\cdot \\vec{v} = x_1 x_2 + y_1 y_2 + z_1 z_2$.\n- Tọa độ trung điểm $M$ của đoạn thẳng $AB$: $M\\left(\\frac{x_A+x_B}{2}; \\frac{y_A+y_B}{2}; \\frac{z_A+z_B}{2}\\right)$.",
      "KeyTakeaway": "Nắm chắc các quy tắc cộng vectơ trong hình hộp, tính chất tích vô hướng và biểu thức tọa độ tương ứng."
    }
  ],
  "exercises": [
    {
      "type": "multiple-choice",
      "prompt": "Cho hàm số $y = f(x)$ có bảng biến thiên như sau:\nHàm số đã cho nghịch biến trên khoảng nào sau đây?",
      "options": [
        { "label": "A", "content": "$(-1;2)$" },
        { "label": "B", "content": "$(-1;+\\infty)$" },
        { "label": "C", "content": "$(-4;2)$" },
        { "label": "D", "content": "$(2;+\\infty)$" }
      ],
      "diagram": {
        "type": "SVG",
        "content": "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 500 180\" width=\"100%\" height=\"180\"><rect width=\"500\" height=\"180\" fill=\"#ffffff\"/><line x1=\"10\" y1=\"10\" x2=\"490\" y2=\"10\" stroke=\"#000\" stroke-width=\"1.5\"/><line x1=\"10\" y1=\"50\" x2=\"490\" y2=\"50\" stroke=\"#000\" stroke-width=\"1.5\"/><line x1=\"10\" y1=\"90\" x2=\"490\" y2=\"90\" stroke=\"#000\" stroke-width=\"1.5\"/><line x1=\"10\" y1=\"170\" x2=\"490\" y2=\"170\" stroke=\"#000\" stroke-width=\"1.5\"/><line x1=\"10\" y1=\"10\" x2=\"10\" y2=\"170\" stroke=\"#000\" stroke-width=\"1.5\"/><line x1=\"60\" y1=\"10\" x2=\"60\" y2=\"170\" stroke=\"#000\" stroke-width=\"1.5\"/><line x1=\"490\" y1=\"10\" x2=\"490\" y2=\"170\" stroke=\"#000\" stroke-width=\"1.5\"/><text x=\"32\" y=\"35\" font-family=\"sans-serif\" font-size=\"14\" text-anchor=\"middle\">x</text><text x=\"32\" y=\"75\" font-family=\"sans-serif\" font-size=\"14\" text-anchor=\"middle\">y'</text><text x=\"32\" y=\"135\" font-family=\"sans-serif\" font-size=\"14\" text-anchor=\"middle\">y</text><text x=\"80\" y=\"35\" font-family=\"sans-serif\" font-size=\"14\">-&infin;</text><text x=\"170\" y=\"35\" font-family=\"sans-serif\" font-size=\"14\">-4</text><text x=\"260\" y=\"35\" font-family=\"sans-serif\" font-size=\"14\">-1</text><text x=\"350\" y=\"35\" font-family=\"sans-serif\" font-size=\"14\">2</text><text x=\"440\" y=\"35\" font-family=\"sans-serif\" font-size=\"14\">+&infin;</text><text x=\"125\" y=\"75\" font-family=\"sans-serif\" font-size=\"16\" text-anchor=\"middle\">+</text><text x=\"170\" y=\"75\" font-family=\"sans-serif\" font-size=\"14\" text-anchor=\"middle\">0</text><text x=\"215\" y=\"75\" font-family=\"sans-serif\" font-size=\"16\" text-anchor=\"middle\">-</text><line x1=\"260\" y1=\"50\" x2=\"260\" y2=\"170\" stroke=\"#000\" stroke-width=\"1\"/><text x=\"305\" y=\"75\" font-family=\"sans-serif\" font-size=\"16\" text-anchor=\"middle\">-</text><text x=\"350\" y=\"75\" font-family=\"sans-serif\" font-size=\"14\" text-anchor=\"middle\">0</text><text x=\"395\" y=\"75\" font-family=\"sans-serif\" font-size=\"16\" text-anchor=\"middle\">+</text><text x=\"80\" y=\"160\" font-family=\"sans-serif\" font-size=\"12\">-&infin;</text><text x=\"165\" y=\"105\" font-family=\"sans-serif\" font-size=\"12\">-11</text><text x=\"245\" y=\"160\" font-family=\"sans-serif\" font-size=\"12\">-&infin;</text><text x=\"265\" y=\"105\" font-family=\"sans-serif\" font-size=\"12\">+&infin;</text><text x=\"350\" y=\"160\" font-family=\"sans-serif\" font-size=\"12\">1</text><text x=\"440\" y=\"105\" font-family=\"sans-serif\" font-size=\"12\">+&infin;</text><line x1=\"95\" y1=\"150\" x2=\"155\" y2=\"110\" stroke=\"#000\" stroke-width=\"1.2\" fill=\"none\"/><line x1=\"180\" y1=\"110\" x2=\"240\" y2=\"150\" stroke=\"#000\" stroke-width=\"1.2\" fill=\"none\"/><line x1=\"280\" y1=\"110\" x2=\"340\" y2=\"150\" stroke=\"#000\" stroke-width=\"1.2\" fill=\"none\"/><line x1=\"360\" y1=\"150\" x2=\"430\" y2=\"110\" stroke=\"#000\" stroke-width=\"1.2\" fill=\"none\"/></svg>"
      }
    },
    {
      "type": "multiple-choice",
      "prompt": "Cho đồ thị hàm số $y = f(x)$ như hình vẽ. Khẳng định nào sau đây là đúng?",
      "options": [
        { "label": "A", "content": "Hàm số đồng biến trên khoảng $(1;4)$." },
        { "label": "B", "content": "Hàm số đồng biến trên khoảng $(-3;2)$." },
        { "label": "C", "content": "Hàm số đồng biến trên khoảng $(-3;3)$." },
        { "label": "D", "content": "Hàm số đồng biến trên khoảng $(0;2)$." }
      ],
      "diagram": {
        "type": "SVG",
        "content": "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 300 220\" width=\"100%\" height=\"200\"><line x1=\"30\" y1=\"180\" x2=\"270\" y2=\"180\" stroke=\"#000\" stroke-width=\"1.5\"/><line x1=\"110\" y1=\"10\" x2=\"110\" y2=\"210\" stroke=\"#000\" stroke-width=\"1.5\"/><text x=\"265\" y=\"175\" font-family=\"sans-serif\" font-size=\"12\">x</text><text x=\"115\" y=\"20\" font-family=\"sans-serif\" font-size=\"12\">y</text><text x=\"100\" y=\"192\" font-family=\"sans-serif\" font-size=\"12\">O</text><text x=\"60\" y=\"195\" font-family=\"sans-serif\" font-size=\"12\">-3</text><text x=\"90\" y=\"195\" font-family=\"sans-serif\" font-size=\"12\">-1</text><text x=\"150\" y=\"195\" font-family=\"sans-serif\" font-size=\"12\">2</text><text x=\"180\" y=\"195\" font-family=\"sans-serif\" font-size=\"12\">3</text><text x=\"115\" y=\"145\" font-family=\"sans-serif\" font-size=\"12\">1</text><text x=\"100\" y=\"75\" font-family=\"sans-serif\" font-size=\"12\">4</text><path d=\"M 50,20 C 70,180 90,140 110,140 C 130,140 140,70 160,70 C 180,70 190,190 210,210\" stroke=\"#b22222\" stroke-width=\"2\" fill=\"none\"/><line x1=\"160\" y1=\"70\" x2=\"160\" y2=\"180\" stroke=\"#888\" stroke-dasharray=\"3,3\"/><line x1=\"160\" y1=\"70\" x2=\"110\" y2=\"70\" stroke=\"#888\" stroke-dasharray=\"3,3\"/></svg>"
      }
    },
    {
      "type": "multiple-choice",
      "prompt": "Cho hình hộp chữ nhật $ABCD.A'B'C'D'$. Khẳng định nào dưới đây là đúng?",
      "options": [
        { "label": "A", "content": "$\\vec{AB} = \\vec{D'C'}$" },
        { "label": "B", "content": "$\\vec{AB} = \\vec{BC}$" },
        { "label": "C", "content": "$\\vec{AB} = \\vec{AC'}$" },
        { "label": "D", "content": "$\\vec{AB} = \\vec{A'C'}$" }
      ],
      "diagram": {
        "type": "SVG",
        "content": "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 250 160\" width=\"100%\" height=\"150\"><line x1=\"30\" y1=\"80\" x2=\"90\" y2=\"30\" stroke=\"#000\" stroke-width=\"1.2\"/><line x1=\"90\" y1=\"30\" x2=\"210\" y2=\"30\" stroke=\"#000\" stroke-width=\"1.2\"/><line x1=\"30\" y1=\"80\" x2=\"150\" y2=\"80\" stroke=\"#000\" stroke-width=\"1.2\"/><line x1=\"150\" y1=\"80\" x2=\"210\" y2=\"30\" stroke=\"#000\" stroke-width=\"1.2\"/><line x1=\"30\" y1=\"80\" x2=\"30\" y2=\"130\" stroke=\"#000\" stroke-width=\"1.2\"/><line x1=\"150\" y1=\"80\" x2=\"150\" y2=\"130\" stroke=\"#000\" stroke-width=\"1.2\"/><line x1=\"210\" y1=\"30\" x2=\"210\" y2=\"80\" stroke=\"#000\" stroke-width=\"1.2\"/><line x1=\"30\" y1=\"130\" x2=\"150\" y2=\"130\" stroke=\"#000\" stroke-width=\"1.2\"/><line x1=\"150\" y1=\"130\" x2=\"210\" y2=\"80\" stroke=\"#000\" stroke-width=\"1.2\"/><line x1=\"90\" y1=\"30\" x2=\"90\" y2=\"80\" stroke=\"#000\" stroke-dasharray=\"3,3\" stroke-width=\"1\"/><line x1=\"30\" y1=\"130\" x2=\"90\" y2=\"80\" stroke=\"#000\" stroke-dasharray=\"3,3\" stroke-width=\"1\"/><line x1=\"90\" y1=\"80\" x2=\"210\" y2=\"80\" stroke=\"#000\" stroke-dasharray=\"3,3\" stroke-width=\"1\"/><text x=\"18\" y=\"85\" font-family=\"sans-serif\" font-size=\"12\">A</text><text x=\"145\" y=\"95\" font-family=\"sans-serif\" font-size=\"12\">B</text><text x=\"215\" y=\"30\" font-family=\"sans-serif\" font-size=\"12\">C</text><text x=\"85\" y=\"25\" font-family=\"sans-serif\" font-size=\"12\">D</text><text x=\"15\" y=\"135\" font-family=\"sans-serif\" font-size=\"12\">A'</text><text x=\"135\" y=\"145\" font-family=\"sans-serif\" font-size=\"12\">B'</text><text x=\"215\" y=\"85\" font-family=\"sans-serif\" font-size=\"12\">C'</text><text x=\"75\" y=\"90\" font-family=\"sans-serif\" font-size=\"12\">D'</text></svg>"
      }
    }
  ]
}`

type ExamData struct {
	Title    string `json:"title"`
	Overview string `json:"overview"`
	Sections []struct {
		SectionTitle    string `json:"SectionTitle"`
		DetailedContent string `json:"DetailedContent"`
		KeyTakeaway     string `json:"KeyTakeaway"`
		TeacherExamples []struct {
			ExampleNum      int    `json:"ExampleNum"`
			Problem         string `json:"Problem"`
			TeacherSolution string `json:"TeacherSolution"`
		} `json:"TeacherExamples"`
	} `json:"sections"`
	Exercises []struct {
		Type    string `json:"type"`
		Prompt  string `json:"prompt"`
		Options []struct {
			Label   string `json:"label"`
			Content string `json:"content"`
		} `json:"options"`
		Diagram struct {
			Type    string `json:"type"`
			Content string `json:"content"`
		} `json:"diagram"`
	} `json:"exercises"`
}

func TestRenderExamLessonFull(t *testing.T) {
	var data ExamData
	if err := json.Unmarshal([]byte(examLessonJSON), &data); err != nil {
		t.Fatalf("Lỗi giải mã JSON đề thi: %v", err)
	}

	renderer := NewLocalRenderer()
	ctx := context.Background()

	// =========================================================================
	// 1. TEST RENDER LÝ THUYẾT: KHẢO SÁT HÀM SỐ (Chứa \lim, \pm\infty, phân số)
	// =========================================================================
	sec1 := data.Sections[0]
	sec1Content := fmt.Sprintf("%s\n\n%s\n\nGhi nhớ: %s", data.Overview, sec1.DetailedContent, sec1.KeyTakeaway)
	if len(sec1.TeacherExamples) > 0 {
		eg := sec1.TeacherExamples[0]
		sec1Content += fmt.Sprintf("\n\nVí dụ %d: %s\nLời giải:\n%s", eg.ExampleNum, eg.Problem, eg.TeacherSolution)
	}

	sec1Bytes, err := renderer.RenderCard(ctx, "I. KHẢO SÁT VÀ VẼ ĐỒ THỊ HÀM SỐ", sec1Content, "")
	if err != nil {
		t.Fatalf("❌ LỖI RENDER LÝ THUYẾT 1: %v", err)
	}
	_ = os.WriteFile(filepath.Join(".", "test_exam_sec1_calculus.png"), sec1Bytes, 0644)
	t.Logf("🎉 1. ĐÃ XUẤT ẢNH LÝ THUYẾT 1: test_exam_sec1_calculus.png")

	// =========================================================================
	// 2. TEST RENDER CÂU 1: CÓ BẢNG BIẾN THIÊN (SVG)
	// =========================================================================
	ex1 := data.Exercises[0]
	var ex1Body strings.Builder
	ex1Body.WriteString(ex1.Prompt + "\n\n")
	for _, opt := range ex1.Options {
		ex1Body.WriteString(fmt.Sprintf("%s. %s\n", opt.Label, opt.Content))
	}

	ex1Bytes, err := renderer.RenderCard(ctx, "CÂU 1 (BẢNG BIẾN THIÊN)", ex1Body.String(), ex1.Diagram.Content)
	if err != nil {
		t.Fatalf("❌ LỖI RENDER CÂU 1 (BẢNG BIẾN THIÊN): %v", err)
	}
	_ = os.WriteFile(filepath.Join(".", "test_exam_ex1_bbt.png"), ex1Bytes, 0644)
	t.Logf("🎉 2. ĐÃ XUẤT ẢNH CÂU 1 (BẢNG BIẾN THIÊN SVG): test_exam_ex1_bbt.png")

	// =========================================================================
	// 3. TEST RENDER CÂU 2: CÓ ĐỒ THỊ HÀM SỐ (SVG)
	// =========================================================================
	ex2 := data.Exercises[1]
	var ex2Body strings.Builder
	ex2Body.WriteString(ex2.Prompt + "\n\n")
	for _, opt := range ex2.Options {
		ex2Body.WriteString(fmt.Sprintf("%s. %s\n", opt.Label, opt.Content))
	}

	ex2Bytes, err := renderer.RenderCard(ctx, "CÂU 2 (ĐỒ THỊ HÀM SỐ)", ex2Body.String(), ex2.Diagram.Content)
	if err != nil {
		t.Fatalf("❌ LỖI RENDER CÂU 2 (ĐỒ THỊ HÀM SỐ): %v", err)
	}
	_ = os.WriteFile(filepath.Join(".", "test_exam_ex2_graph.png"), ex2Bytes, 0644)
	t.Logf("🎉 3. ĐÃ XUẤT ẢNH CÂU 2 (ĐỒ THỊ SVG): test_exam_ex2_graph.png")

	// =========================================================================
	// 4. TEST RENDER CÂU 6: HÌNH HỘP CHỮ NHẬT 3D (SVG NÉT ĐỨT NÉT LIỀN)
	// =========================================================================
	ex6 := data.Exercises[2]
	var ex6Body strings.Builder
	ex6Body.WriteString(ex6.Prompt + "\n\n")
	for _, opt := range ex6.Options {
		ex6Body.WriteString(fmt.Sprintf("%s. %s\n", opt.Label, opt.Content))
	}

	ex6Bytes, err := renderer.RenderCard(ctx, "CÂU 6 (HÌNH HỘP CHỮ NHẬT 3D)", ex6Body.String(), ex6.Diagram.Content)
	if err != nil {
		t.Fatalf("❌ LỖI RENDER CÂU 6 (HÌNH HỘP 3D): %v", err)
	}
	_ = os.WriteFile(filepath.Join(".", "test_exam_ex6_box3d.png"), ex6Bytes, 0644)
	t.Logf("🎉 4. ĐÃ XUẤT ẢNH CÂU 6 (HÌNH HỘP 3D SVG): test_exam_ex6_box3d.png")
}
