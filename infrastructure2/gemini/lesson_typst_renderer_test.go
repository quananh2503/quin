package gemini

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
)

func TestDefaultLessonTypstRenderer_Render_Success(t *testing.T) {
	// 1. Tạo dữ liệu Domain Lesson mẫu hoàn chỉnh
	title := textToContent("HÌNH HỌC KHÔNG GIAN OXYZ")
	overview := textToContent("Chuyên đề hệ trục tọa độ và các phép toán vectơ")

	// Các blocks lý thuyết và ví dụ mẫu
	pBlock := lesson.NewParagraphBlock(textToContent("Vectơ trong không gian được xác định bởi bộ ba số $(x, y, z)$."))
	callout := lesson.NewCalloutBlock(lesson.CalloutTip, textToContent("Mẹo giải nhanh"), textToContent("Nhớ công thức độ dài vectơ: $\\sqrt{x^2+y^2+z^2}$"))
	formula := lesson.NewFormulaBlock("$\\vec{u} \\cdot \\vec{v} = x_1 x_2 + y_1 y_2 + z_1 z_2$")
	exBlock := lesson.NewExampleBlock(
		textToContent("Ví dụ 1 - Tính độ dài vectơ"),
		textToContent("Cho điểm $A(1, 2, 3)$ và $B(4, 6, 3)$. Tính độ dài vectơ $\\vec{AB}$."),
		textToContent("Ta có $\\vec{AB} = (3, 4, 0) \\implies |\\vec{AB}| = \\sqrt{3^2 + 4^2 + 0^2} = 5$."),
		textToContent(""),
	)
	blocks := []lesson.Block{pBlock, callout, formula, exBlock}

	// Bài tập: Gom chung bài tự luận và trắc nghiệm
	part := sharekernel.NewEssayPart(
		"a",
		textToContent("Tính tích vô hướng của hai vectơ $\\vec{u}=(1, 2, 3)$ và $\\vec{v}=(4, -1, 2)$."),
		textToContent("Ta có $\\vec{u} \\cdot \\vec{v} = 1(4) + 2(-1) + 3(2) = 4 - 2 + 6 = 8$."),
		textToContent("8"),
	)
	diag := sharekernel.NewDiagram(sharekernel.DiagramNone, "")
	essayEx, err := sharekernel.NewEssayExercise(
		"Dạng 1: Tọa độ vectơ và tích vô hướng",
		"Thông hiểu",
		textToContent("Tính tích vô hướng của hai vectơ $\\vec{u}=(1, 2, 3)$ và $\\vec{v}=(4, -1, 2)$."),
		[]sharekernel.EssayPart{part},
		diag,
	)
	require.NoError(t, err)

	optA, errA := sharekernel.NewMCOption("A", textToContent("$5$"))
	require.NoError(t, errA)
	optB, errB := sharekernel.NewMCOption("B", textToContent("$\\sqrt{5}$"))
	require.NoError(t, errB)
	optC, errC := sharekernel.NewMCOption("C", textToContent("$2$"))
	require.NoError(t, errC)
	optD, errD := sharekernel.NewMCOption("D", textToContent("$3$"))
	require.NoError(t, errD)

	mcqEx, err := sharekernel.NewMultipleChoiceExercise(
		"Dạng 1: Tọa độ vectơ và tích vô hướng",
		"Nhận biết",
		textToContent("Cho vectơ $\\vec{a}=(1, 0, 2)$. Độ dài của vectơ $\\vec{a}$ bằng:"),
		[]sharekernel.MCOption{optA, optB, optC, optD},
		"B",
		textToContent("Độ dài vectơ $\\vec{a}$ là $|\\vec{a}| = \\sqrt{1^2 + 0^2 + 2^2} = \\sqrt{5}$. Chọn B."),
		diag,
	)
	require.NoError(t, err)

	exercises := []sharekernel.Exercise{essayEx, mcqEx}

	topic, err := lesson.NewTopic(textToContent("Dạng 1: Tọa độ vectơ và tích vô hướng"), blocks, exercises)
	require.NoError(t, err)

	section, err := lesson.NewSection(textToContent("Nội Dung Bài Giảng"), []lesson.Topic{topic})
	require.NoError(t, err)

	mat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=mock")
	require.NoError(t, err)

	lsn, err := lesson.NewLesson(title, overview, []lesson.Section{section}, []lesson.StudyMaterial{mat})
	require.NoError(t, err)

	// 2. Gọi Renderer
	renderer := NewDefaultLessonTypstRenderer()
	typstCode, err := renderer.Render(lsn)
	require.NoError(t, err)
	require.NotEmpty(t, typstCode)

	// 3. Kiểm tra các thành phần định dạng và giao diện
	assert.Contains(t, typstCode, `@preview/mitex:0.2.7`)
	assert.Contains(t, typstCode, `IS_TEACHER`)
	assert.Contains(t, typstCode, `GIÁO ÁN GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)`)
	assert.Contains(t, typstCode, `PHIẾU BÀI TẬP HỌC SINH`)
	assert.Contains(t, typstCode, `HÌNH HỌC KHÔNG GIAN OXYZ`)
	assert.Contains(t, typstCode, `Dạng 1: Tọa độ vectơ và tích vô hướng`)
	assert.Contains(t, typstCode, `I. Lý thuyết & Ghi nhớ`)
	assert.Contains(t, typstCode, `Mẹo giải nhanh`)
	assert.Contains(t, typstCode, `Ví dụ minh họa giải mẫu`)
	assert.Contains(t, typstCode, `Bài tập rèn luyện`)
	assert.Contains(t, typstCode, `Bài làm`)

	// 4. Biên dịch thử bằng Typst CLI thực tế để đảm bảo không lỗi cú pháp
	compiler := NewCLITypstCompiler()
	tmpDir := t.TempDir()
	outPDF := filepath.Join(tmpDir, "teacher_rendered.pdf")

	res, err := compiler.Compile(context.Background(), typstCode, CompileOptions{
		OutPDFPath: outPDF,
		Inputs: map[string]string{
			"teacher": "true",
		},
	})
	require.NoError(t, err, "Biên dịch Typst sang PDF cho Giáo viên phải thành công")
	require.NotNil(t, res)
	assert.FileExists(t, outPDF)

	info, statErr := os.Stat(outPDF)
	require.NoError(t, statErr)
	assert.Greater(t, info.Size(), int64(1024), "File PDF phải có kích thước hợp lệ (> 1KB)")
}

func TestDefaultLessonTypstRenderer_NilLesson(t *testing.T) {
	renderer := NewDefaultLessonTypstRenderer()
	_, err := renderer.Render(nil)
	require.Error(t, err)
	assert.True(t, strings.Contains(err.Error(), "nil") || strings.Contains(err.Error(), "rỗng"))
}

func TestRenderLessonPNGPages_Success(t *testing.T) {
	title := textToContent("HÌNH HỌC PHẲNG")
	overview := textToContent("Tứ giác nội tiếp")

	pBlock := lesson.NewParagraphBlock(textToContent("Tứ giác có tổng hai góc đối bằng 180 độ là tứ giác nội tiếp."))
	formula := lesson.NewFormulaBlock("$\\angle A + \\angle C = 180^\\circ$")
	blocks := []lesson.Block{pBlock, formula}

	top, err := lesson.NewTopic(textToContent("Dạng 1: Chứng minh tứ giác nội tiếp"), blocks, nil)
	require.NoError(t, err)

	sec, err := lesson.NewSection(textToContent("Phần 1"), []lesson.Topic{top})
	require.NoError(t, err)

	mat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=mock")
	require.NoError(t, err)

	lsn, err := lesson.NewLesson(title, overview, []lesson.Section{sec}, []lesson.StudyMaterial{mat})
	require.NoError(t, err)

	pages, err := RenderLessonPNGPages(context.Background(), lsn, true, 300)
	require.NoError(t, err)
	require.NotEmpty(t, pages, "Phải xuất ra ít nhất 1 trang PNG")

	for i, page := range pages {
		assert.Greater(t, len(page), 1000, "Mỗi trang PNG phải có kích thước hợp lệ")
		// Kiểm tra magic bytes của PNG: \x89PNG\r\n\x1a\n
		assert.Equal(t, []byte{0x89, 'P', 'N', 'G', '\r', '\n', 0x1a, '\n'}, page[:8], fmt.Sprintf("Trang %d phải là file PNG chuẩn", i+1))
	}
}

func TestRenderLessonPNGPages_NilLesson(t *testing.T) {
	_, err := RenderLessonPNGPages(context.Background(), nil, true, 300)
	require.Error(t, err)
}
