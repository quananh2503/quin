package gemini_test

import (
	"context"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"meet-attendance-clean/infrastructure2/gemini"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// ensureTypstCLI checks if typst executable is available in PATH
func ensureTypstCLI(t *testing.T) {
	_, err := exec.LookPath("typst")
	if err != nil {
		t.Skip("Bỏ qua Integration Test vì máy chưa cài đặt Typst CLI trong PATH")
	}
}

// -----------------------------------------------------------------------------
// TEST 1: Biên dịch bộ ký tự Toán THPT & Tiếng Việt Unicode (Happy Path)
// -----------------------------------------------------------------------------
func Test_CLITypstCompiler_MathAndVietnamese_Integration(t *testing.T) {
	ensureTypstCLI(t)
	compiler := gemini.NewCLITypstCompiler()

	tempDir := t.TempDir()
	outPDF := filepath.Join(tempDir, "toan_vietnam.pdf")

	markup := `#set page(paper: "a4", margin: (x: 1.5cm, y: 1.5cm))
#set text(font: ("Linux Libertine", "Arial"), size: 11pt, lang: "vi")

= CHUYÊN ĐỀ HÌNH HỌC KHÔNG GIAN OXYZ & TOÁN THPT

Đoạn văn bản kiểm tra tiếng Việt có dấu:
"Cho tứ diện $S.A B C$ có đáy là tam giác vuông tại $B$. Đường chéo hình hộp chữ nhật."

Các công thức toán học phổ biến:
- Phân số và căn bậc hai: $f(x) = (x^2 + 2x - 1) / sqrt(3x + 5)$
- Vectơ không gian: $arrow(u) = (1, -2, 3)$ và $arrow(A B) + arrow(B C) = arrow(A C)$
- Hệ phương trình và ký tự Hy Lạp: $alpha, beta, gamma, Delta, pi$
- Tích phân xác định: $integral_0^1 (2x + 1) dif x = 2$
`

	opts := gemini.CompileOptions{
		IsTeacher:  true,
		OutPDFPath: outPDF,
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	res, err := compiler.Compile(ctx, markup, opts)
	require.NoError(t, err)
	require.NotNil(t, res)
	assert.True(t, res.Success, "Biên dịch toán và tiếng Việt phải thành công")
	assert.Equal(t, outPDF, res.PDFPath)

	info, errStat := os.Stat(outPDF)
	require.NoError(t, errStat, "File PDF phải tồn tại trên đĩa")
	assert.Greater(t, info.Size(), int64(0), "Dung lượng PDF phải lớn hơn 0 bytes")
}

// -----------------------------------------------------------------------------
// TEST 2: Ký tự rủi ro & Thoát chuỗi trong Typst (Escape Stress Test)
// -----------------------------------------------------------------------------
func Test_CLITypstCompiler_EscapeAndSpecialCharacters_Integration(t *testing.T) {
	ensureTypstCLI(t)
	compiler := gemini.NewCLITypstCompiler()

	tempDir := t.TempDir()
	outPDF := filepath.Join(tempDir, "special_chars.pdf")

	// Kiểm tra các ký tự dễ va chạm cú pháp Typst: \#, \*, \_, \@, \\
	markup := `#set text(lang: "vi")
[BÀI TẬP VỀ NHÀ]
- Ký tự thăng đã thoát: \#123 và mã định danh \#ID_001
- Dấu gạch dưới trong văn bản: bai\_tap\_1 và bien\_so\_x
- Dấu hoa thị đã thoát: \*Không phải in đậm\*
- Ký tự toán chứa chỉ số: $x_1 + x_2 = -b / a$
- Dấu ngoặc nhọn trong toán: $A = {x in RR | x > 0}$
`

	opts := gemini.CompileOptions{
		IsTeacher:  false,
		OutPDFPath: outPDF,
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	res, err := compiler.Compile(ctx, markup, opts)
	require.NoError(t, err)
	require.NotNil(t, res)
	assert.True(t, res.Success, "Biên dịch ký tự đặc biệt đã thoát phải thành công")

	info, errStat := os.Stat(outPDF)
	require.NoError(t, errStat)
	assert.Greater(t, info.Size(), int64(0))
}

// -----------------------------------------------------------------------------
// TEST 3: Bắt lỗi cú pháp & Trích xuất chính xác dòng lỗi (Error Line Extraction)
// -----------------------------------------------------------------------------
func Test_CLITypstCompiler_ErrorLineExtraction_Integration(t *testing.T) {
	ensureTypstCLI(t)
	compiler := gemini.NewCLITypstCompiler()

	tempDir := t.TempDir()
	outPDF := filepath.Join(tempDir, "broken.pdf")

	// Cố tình tạo lỗi mở ngoặc $ mà không đóng ở dòng 9
	lines := []string{
		`#set page(paper: "a4")`,                    // line 1
		`#set text(size: 11pt)`,                     // line 2
		`= BÀI TẬP CÓ LỖI CÚ PHÁP ĐỂ TEST`,          // line 3
		``,                                           // line 4
		`Dòng 5 bình thường.`,                       // line 5
		`Dòng 6 bình thường.`,                       // line 6
		`Dòng 7 bình thường.`,                       // line 7
		`Dòng 8 bình thường.`,                       // line 8
		`Dòng 9 lỗi cú pháp: $x + y thiếu đóng đô la`, // line 9: LỖI CỐ TÌNH
		`Dòng 10 bình thường.`,                      // line 10
	}
	markup := strings.Join(lines, "\n")

	opts := gemini.CompileOptions{
		IsTeacher:  true,
		OutPDFPath: outPDF,
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	res, err := compiler.Compile(ctx, markup, opts)
	// Typst trả lỗi -> CompileResult.Success phải là false, err không nil
	assert.Error(t, err, "Kỳ vọng compiler báo lỗi")
	require.NotNil(t, res, "Kết quả trả về không được nil dù lỗi")
	assert.False(t, res.Success, "Success phải là false khi có lỗi cú pháp")
	assert.NotEmpty(t, res.RawStderr, "RawStderr phải chứa thông báo lỗi từ typst")

	// SỐNG CÒN CHO VÒNG LẶP SỬA LỖI: ErrorLines phải chứa dòng 9
	require.NotEmpty(t, res.ErrorLines, "ErrorLines phải được trích xuất từ stderr")
	assert.Contains(t, res.ErrorLines, 9, "ErrorLines phải trích xuất chính xác dòng số 9")
}

// -----------------------------------------------------------------------------
// TEST 4: Chế độ phân quyền Giáo viên vs Học sinh (--input teacher=true/false)
// -----------------------------------------------------------------------------
func Test_CLITypstCompiler_TeacherAndStudentSwitch_Integration(t *testing.T) {
	ensureTypstCLI(t)
	compiler := gemini.NewCLITypstCompiler()

	tempDir := t.TempDir()
	teacherPDF := filepath.Join(tempDir, "teacher.pdf")
	studentPDF := filepath.Join(tempDir, "student.pdf")

	markup := `#let is_teacher = sys.inputs.at("teacher", default: "false") == "true"

= PHIẾU HỌC TẬP

*Bài toán:* Tìm nghiệm của phương trình $x^2 - 4 = 0$.

#if is_teacher [
  #block(stroke: 1pt + green, inset: 8pt)[
    *LỜI GIẢI CHI TIẾT (BẢN GIÁO VIÊN):*
    Ta có $x^2 = 4 <=> x = 2$ hoặc $x = -2$.
  ]
] else [
  #v(50pt)
  #align(center)[(Học sinh làm bài vào khoảng trống này)]
  #v(50pt)
]
`

	ctx := context.Background()

	// 1. Biên dịch bản Giáo Viên (teacher = true)
	resGV, errGV := compiler.Compile(ctx, markup, gemini.CompileOptions{
		IsTeacher:  true,
		OutPDFPath: teacherPDF,
	})
	require.NoError(t, errGV)
	assert.True(t, resGV.Success)

	// 2. Biên dịch bản Học Sinh (teacher = false)
	resHS, errHS := compiler.Compile(ctx, markup, gemini.CompileOptions{
		IsTeacher:  false,
		OutPDFPath: studentPDF,
	})
	require.NoError(t, errHS)
	assert.True(t, resHS.Success)

	// Cả 2 file PDF phải tồn tại trên đĩa và dung lượng > 0
	infoGV, errStatGV := os.Stat(teacherPDF)
	require.NoError(t, errStatGV)
	infoHS, errStatHS := os.Stat(studentPDF)
	require.NoError(t, errStatHS)

	assert.Greater(t, infoGV.Size(), int64(0))
	assert.Greater(t, infoHS.Size(), int64(0))
}
