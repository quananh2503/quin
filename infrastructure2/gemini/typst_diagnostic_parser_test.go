package gemini_test

import (
	"context"
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"
	"meet-attendance-clean/infrastructure2/gemini/mocks"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"
)

func TestParseTypstDiagnostics_MitexPluginError(t *testing.T) {
	rawStderr := `error: plugin errored with: error: unknown command: \vecc
   ┌─ @preview/mitex:0.2.7/mitex.typ:18:8
   │
18 │     str(mitex-wasm.convert_math(bytes(get-elem-text(it)), spec))
   │         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  while calling ` + "`mitex-convert`" + ` at @preview/mitex:0.2.7/mitex.typ:26:12
    mitex-convert(mode: "math", it)
  while calling ` + "`mimath`" + ` at \\?\E:\quin\quin\infrastructure2\gemini\.artifacts\full_pipeline_output\typst_1829612435.typ:88:110
    mi(` + "`\\vecc{AD} = \\vec{CD'}`" + `)

warning: unknown font family: dejavu sans
  ┌─ \\?\E:\quin\quin\infrastructure2\gemini\.artifacts\full_pipeline_output\typst_1829612435.typ:6:16
  │
6 │ #set text(font: ("Arial", "Segoe UI", "DejaVu Sans", "Liberation Sans"), size: 10pt, lang: "vi")
  │                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
`

	diags := gemini.ParseTypstDiagnostics(rawStderr)
	require.Len(t, diags, 1, "Phải lọc sạch warning và chỉ lấy đúng 1 lỗi trọng tâm")

	assert.Equal(t, 88, diags[0].LineNumber, "Phải trích xuất đúng dòng 88 trong file nguồn người dùng")
	assert.Contains(t, diags[0].ErrorReason, "unknown command: \\vecc", "Nguyên nhân phải súc tích, ngắn gọn")
	assert.Equal(t, "\\vecc{AD} = \\vec{CD'}", diags[0].BrokenSnippet, "Snippet phải lấy đúng đoạn công thức gây lỗi")
}

func TestParseTypstDiagnostics_StandardTypstSyntaxError(t *testing.T) {
	rawStderr := `error: unclosed delimiter
   ┌─ typst_test.typ:42:15
   │
42 │ $ x + y = [2 + 3 $
   │           ^
`

	diags := gemini.ParseTypstDiagnostics(rawStderr)
	require.Len(t, diags, 1)

	assert.Equal(t, 42, diags[0].LineNumber)
	assert.Equal(t, "unclosed delimiter", diags[0].ErrorReason)
}

func TestParseTypstDiagnostics_IgnoresWarningsOnly(t *testing.T) {
	rawStderr := `warning: unknown font family: dejavu sans
  ┌─ test.typ:6:16
  │
6 │ #set text(font: ("Arial", "Segoe UI", "DejaVu Sans"))
`

	diags := gemini.ParseTypstDiagnostics(rawStderr)
	assert.Empty(t, diags, "Log chỉ có warning thì không được tính là lỗi")
}

func TestScanAllTypstErrors_IsolationLoop(t *testing.T) {
	mockCompiler := mocks.NewTypstCompiler(t)

	// Lần 1: Lỗi dòng 2
	mockCompiler.On("Compile", mock.Anything, mock.MatchedBy(func(m string) bool {
		return m == "line 1\nline 2\nline 3\nline 4"
	}), mock.Anything).Return(&gemini.CompileResult{
		Success:    false,
		ErrorLines: []int{2},
		RawStderr:  "error: bad syntax at .typ:2:5",
	}, nil).Once()

	// Lần 2: Dòng 2 đã bị comment cách ly, phát hiện tiếp lỗi ở dòng 4
	mockCompiler.On("Compile", mock.Anything, mock.MatchedBy(func(m string) bool {
		return m == "line 1\n// [ISOLATED] line 2\nline 3\nline 4"
	}), mock.Anything).Return(&gemini.CompileResult{
		Success:    false,
		ErrorLines: []int{4},
		RawStderr:  "error: bad syntax at .typ:4:8",
	}, nil).Once()

	// Lần 3: Cả dòng 2 và dòng 4 đều đã bị cách ly, biên dịch thành công (hết lỗi)
	mockCompiler.On("Compile", mock.Anything, mock.MatchedBy(func(m string) bool {
		return m == "line 1\n// [ISOLATED] line 2\nline 3\n// [ISOLATED] line 4"
	}), mock.Anything).Return(&gemini.CompileResult{
		Success: true,
	}, nil).Once()

	markup := "line 1\nline 2\nline 3\nline 4"
	opts := gemini.CompileOptions{OutPDFPath: "dummy.pdf"}

	diags := gemini.ScanAllTypstErrors(context.Background(), mockCompiler, markup, opts)
	require.Len(t, diags, 2, "Vòng quét cách ly phải lôi ra đủ cả 2 lỗi trong 1 chu kỳ")
	assert.Equal(t, 2, diags[0].LineNumber)
	assert.Equal(t, 4, diags[1].LineNumber)

	mockCompiler.AssertExpectations(t)
}
