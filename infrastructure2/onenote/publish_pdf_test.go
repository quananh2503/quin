package onenote

import (
	"context"
	"io"
	"mime"
	"mime/multipart"
	"strings"
	"testing"
	"uuid"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestPublishPDF_ValidationErrors(t *testing.T) {
	client := &Client{}
	ctx := context.Background()

	validLessonID := uuid.New()
	validStudentID := uuid.New()
	validPDF := []byte("%PDF-1.4 mock content")

	t.Run("lessonID nil", func(t *testing.T) {
		err := client.PublishPDFPages(ctx, uuid.Nil(), validStudentID, "Nguyen Van A", validPDF, validPDF, "Chuong 1", "Chuong 1", "Bai 1")
		assert.Error(t, err)
	})

	t.Run("studentID nil", func(t *testing.T) {
		err := client.PublishPDFPages(ctx, validLessonID, uuid.Nil(), "Nguyen Van A", validPDF, validPDF, "Chuong 1", "Chuong 1", "Bai 1")
		assert.Error(t, err)
	})

	t.Run("teacherPDF rỗng", func(t *testing.T) {
		err := client.PublishPDFPages(ctx, validLessonID, validStudentID, "Nguyen Van A", nil, validPDF, "Chuong 1", "Chuong 1", "Bai 1")
		assert.Error(t, err)
	})

	t.Run("studentPDF rỗng", func(t *testing.T) {
		err := client.PublishPDFPages(ctx, validLessonID, validStudentID, "Nguyen Van A", validPDF, []byte{}, "Chuong 1", "Chuong 1", "Bai 1")
		assert.Error(t, err)
	})

	t.Run("pageTitle rỗng", func(t *testing.T) {
		err := client.PublishPDFPages(ctx, validLessonID, validStudentID, "Nguyen Van A", validPDF, validPDF, "Chuong 1", "Chuong 1", "")
		assert.Error(t, err)
	})
}

func TestBuildPDFMultipartBody_Structure(t *testing.T) {
	pageTitle := "Bài Giảng Vectơ Không Gian Oxyz"
	pdfFileName := "teacher_lesson.pdf"
	mockPDFData := []byte("%PDF-1.4 fake pdf binary data 123456")

	contentType, bodyReader, err := BuildPDFMultipartBody(pageTitle, pdfFileName, mockPDFData)
	require.NoError(t, err)
	require.NotEmpty(t, contentType)
	require.NotNil(t, bodyReader)

	// Phân tích multipart data nhận được
	mediaType, params, err := mime.ParseMediaType(contentType)
	require.NoError(t, err)
	assert.Equal(t, "multipart/form-data", mediaType)
	boundary := params["boundary"]
	require.NotEmpty(t, boundary)

	mr := multipart.NewReader(bodyReader, boundary)

	// PART 1: Presentation
	part1, err := mr.NextPart()
	require.NoError(t, err)
	assert.Equal(t, "Presentation", part1.FormName())
	assert.True(t, strings.HasPrefix(part1.Header.Get("Content-Type"), "text/html"))
	htmlBytes, err := io.ReadAll(part1)
	require.NoError(t, err)
	htmlContent := string(htmlBytes)
	assert.Contains(t, htmlContent, pageTitle, "HTML phải chứa tiêu đề trang")
	assert.Contains(t, htmlContent, `data-render-src="name:pdfAttachment"`, "HTML phải chứa data-render-src theo chuẩn OneNote printout")

	// PART 2: pdfAttachment
	part2, err := mr.NextPart()
	require.NoError(t, err)
	assert.Equal(t, "pdfAttachment", part2.FormName())
	assert.Equal(t, "application/pdf", part2.Header.Get("Content-Type"))
	pdfBytes, err := io.ReadAll(part2)
	require.NoError(t, err)
	assert.Equal(t, mockPDFData, pdfBytes, "Dữ liệu nhị phân PDF phải nguyên vẹn")

	// Không còn part nào khác
	_, err = mr.NextPart()
	assert.Equal(t, io.EOF, err)
}

func TestBuildPNGPagesMultipartBody_Structure(t *testing.T) {
	pageTitle := "Bài Giảng Độ Phân Giải Cao 300 DPI"
	mockPage1 := []byte{0x89, 'P', 'N', 'G', '\r', '\n', 0x1a, '\n', 0x01, 0x02}
	mockPage2 := []byte{0x89, 'P', 'N', 'G', '\r', '\n', 0x1a, '\n', 0x03, 0x04}
	pngPages := [][]byte{mockPage1, mockPage2}

	contentType, bodyReader, err := BuildPNGPagesMultipartBody(pageTitle, pngPages)
	require.NoError(t, err)
	require.NotEmpty(t, contentType)
	require.NotNil(t, bodyReader)

	mediaType, params, err := mime.ParseMediaType(contentType)
	require.NoError(t, err)
	assert.Equal(t, "multipart/form-data", mediaType)
	boundary := params["boundary"]
	require.NotEmpty(t, boundary)

	mr := multipart.NewReader(bodyReader, boundary)

	// PART 1: Presentation HTML
	part1, err := mr.NextPart()
	require.NoError(t, err)
	assert.Equal(t, "Presentation", part1.FormName())
	assert.True(t, strings.HasPrefix(part1.Header.Get("Content-Type"), "text/html"))
	htmlBytes, err := io.ReadAll(part1)
	require.NoError(t, err)
	htmlContent := string(htmlBytes)
	assert.Contains(t, htmlContent, pageTitle)
	assert.Contains(t, htmlContent, `src="name:imageBlock1"`)
	assert.Contains(t, htmlContent, `src="name:imageBlock2"`)
	assert.Contains(t, htmlContent, `width="800"`)

	// PART 2: imageBlock1
	p2, err := mr.NextPart()
	require.NoError(t, err)
	assert.Equal(t, "imageBlock1", p2.FormName())
	assert.Equal(t, "image/png", p2.Header.Get("Content-Type"))
	data1, err := io.ReadAll(p2)
	require.NoError(t, err)
	assert.Equal(t, mockPage1, data1)

	// PART 3: imageBlock2
	p3, err := mr.NextPart()
	require.NoError(t, err)
	assert.Equal(t, "imageBlock2", p3.FormName())
	assert.Equal(t, "image/png", p3.Header.Get("Content-Type"))
	data2, err := io.ReadAll(p3)
	require.NoError(t, err)
	assert.Equal(t, mockPage2, data2)

	// Không còn part nào khác
	_, err = mr.NextPart()
	assert.Equal(t, io.EOF, err)
}

func TestPublishPNGPages_ValidationErrors(t *testing.T) {
	client := &Client{}
	ctx := context.Background()

	validAssignmentID := uuid.New()
	validStudentID := uuid.New()
	validPage := [][]byte{[]byte("fake-png-1")}

	t.Run("assignmentID nil", func(t *testing.T) {
		err := client.PublishPNGPages(ctx, uuid.Nil(), validStudentID, "Nguyen Van A", validPage, validPage, "Chuong 1", "Chuong 1", "Bai 1")
		assert.Error(t, err)
	})

	t.Run("studentID nil", func(t *testing.T) {
		err := client.PublishPNGPages(ctx, validAssignmentID, uuid.Nil(), "Nguyen Van A", validPage, validPage, "Chuong 1", "Chuong 1", "Bai 1")
		assert.Error(t, err)
	})

	t.Run("teacherPages rỗng", func(t *testing.T) {
		err := client.PublishPNGPages(ctx, validAssignmentID, validStudentID, "Nguyen Van A", nil, validPage, "Chuong 1", "Chuong 1", "Bai 1")
		assert.Error(t, err)
	})

	t.Run("studentPages rỗng", func(t *testing.T) {
		err := client.PublishPNGPages(ctx, validAssignmentID, validStudentID, "Nguyen Van A", validPage, [][]byte{}, "Chuong 1", "Chuong 1", "Bai 1")
		assert.Error(t, err)
	})

	t.Run("pageTitle rỗng", func(t *testing.T) {
		err := client.PublishPNGPages(ctx, validAssignmentID, validStudentID, "Nguyen Van A", validPage, validPage, "Chuong 1", "Chuong 1", "")
		assert.Error(t, err)
	})

	t.Run("teacherChapterName rỗng", func(t *testing.T) {
		err := client.PublishPNGPages(ctx, validAssignmentID, validStudentID, "Nguyen Van A", validPage, validPage, "Chuong 1", "", "Bai 1")
		assert.Error(t, err)
	})

	t.Run("studentChapterName rỗng", func(t *testing.T) {
		err := client.PublishPNGPages(ctx, validAssignmentID, validStudentID, "Nguyen Van A", validPage, validPage, "", "Chuong 1", "Bai 1")
		assert.Error(t, err)
	})

	t.Run("pngPages rỗng trong build multipart", func(t *testing.T) {
		_, _, err := BuildPNGPagesMultipartBody("Title", nil)
		assert.Error(t, err)
	})
}

