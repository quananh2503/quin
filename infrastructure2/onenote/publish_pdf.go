package onenote

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"io"
	"log"
	"mime/multipart"
	"net/http"
	"net/textproto"
	"net/url"
	"strconv"
	"strings"
	"time"
	"uuid"

	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/database"
)

// PublishPDFPages đẩy 2 tài liệu PDF (Bản Giáo Viên và Bản Học Sinh) lên Sổ OneNote tương ứng.
// - Bản GV được in lên Notebook Giáo Viên (AudienceTeacher), vào mục teacherChapterName.
// - Bản HS được in lên Notebook Học Sinh (AudienceStudent), vào mục studentChapterName.
// Invariants:
// - studentID và lessonID không được nil.
// - len(teacherPDFData) > 0 và len(studentPDFData) > 0.
// - pageTitle, studentChapterName, teacherChapterName không được rỗng.
func (c *Client) PublishPDFPages(
	ctx context.Context,
	lessonID uuid.UUID,
	studentID uuid.UUID,
	studentName string,
	teacherPDFData []byte,
	studentPDFData []byte,
	studentChapterName string,
	teacherChapterName string,
	pageTitle string,
) error {
	if lessonID == uuid.Nil() {
		return errors.New("lessonID không được nil")
	}
	if studentID == uuid.Nil() {
		return errors.New("studentID không được nil")
	}
	if len(teacherPDFData) == 0 {
		return errors.New("teacherPDFData không được rỗng")
	}
	if len(studentPDFData) == 0 {
		return errors.New("studentPDFData không được rỗng")
	}
	if strings.TrimSpace(pageTitle) == "" {
		return errors.New("pageTitle không được để trống")
	}
	if strings.TrimSpace(teacherChapterName) == "" {
		return errors.New("teacherChapterName không được để trống")
	}
	if strings.TrimSpace(studentChapterName) == "" {
		return errors.New("studentChapterName không được để trống")
	}

	client, err := c.GetHTTPClient(ctx)
	if err != nil {
		return fmt.Errorf("không thể lấy HTTP client: %w", err)
	}
	accountID, err := c.GetAccountID(ctx)
	if err != nil {
		return fmt.Errorf("không thể lấy account ID: %w", err)
	}

	gv, err := c.ensureNotebook(ctx, client, accountID, studentID, studentName, "GV")
	if err != nil {
		return fmt.Errorf("notebook giáo viên: %w", err)
	}
	hs, err := c.ensureNotebook(ctx, client, accountID, studentID, studentName, "HS")
	if err != nil {
		return fmt.Errorf("notebook học sinh: %w", err)
	}

	if err := c.publishPDFOne(ctx, client, accountID, lessonID, teacherPDFData, "teacher.pdf", lesson.AudienceTeacher, gv, teacherChapterName, pageTitle); err != nil {
		return fmt.Errorf("trang giáo viên: %w", err)
	}

	if err := c.publishPDFOne(ctx, client, accountID, lessonID, studentPDFData, "student.pdf", lesson.AudienceStudent, hs, studentChapterName, pageTitle); err != nil {
		return fmt.Errorf("trang học sinh: %w", err)
	}

	return nil
}

// BuildPDFMultipartBody đóng gói HTML Presentation và file nhị phân PDF thành multipart/form-data
// theo chuẩn Microsoft OneNote Graph API để in trải dài PDF (printout).
func BuildPDFMultipartBody(pageTitle, pdfFileName string, pdfData []byte) (string, io.Reader, error) {
	if strings.TrimSpace(pdfFileName) == "" {
		pdfFileName = "document.pdf"
	}

	var body bytes.Buffer
	writer := multipart.NewWriter(&body)

	// Part 1: Presentation
	htmlHeader := make(textproto.MIMEHeader)
	htmlHeader.Set("Content-Disposition", `form-data; name="Presentation"`)
	htmlHeader.Set("Content-Type", "text/html; charset=utf-8")
	htmlPart, err := writer.CreatePart(htmlHeader)
	if err != nil {
		return "", nil, fmt.Errorf("không thể tạo multipart html part: %w", err)
	}

	htmlContent := fmt.Sprintf(`<!DOCTYPE html>
<html>
<head><title>%s</title></head>
<body>
  <img data-render-src="name:pdfAttachment" />
</body>
</html>`, pageTitle)

	if _, err := htmlPart.Write([]byte(htmlContent)); err != nil {
		return "", nil, fmt.Errorf("không thể ghi multipart html part: %w", err)
	}

	// Part 2: pdfAttachment
	pdfHeader := make(textproto.MIMEHeader)
	pdfHeader.Set("Content-Disposition", fmt.Sprintf(`form-data; name="pdfAttachment"; filename="%s"`, pdfFileName))
	pdfHeader.Set("Content-Type", "application/pdf")
	pdfPart, err := writer.CreatePart(pdfHeader)
	if err != nil {
		return "", nil, fmt.Errorf("không thể tạo multipart pdf part: %w", err)
	}

	if _, err := pdfPart.Write(pdfData); err != nil {
		return "", nil, fmt.Errorf("không thể ghi multipart pdf part: %w", err)
	}

	if err := writer.Close(); err != nil {
		return "", nil, fmt.Errorf("không thể close multipart writer: %w", err)
	}

	return writer.FormDataContentType(), &body, nil
}

// publishPDFOne thực hiện tạo trang OneNote với nội dung PDF Printout bằng Multipart Form-Data:
// - Part 1: "Presentation" (Content-Type: text/html; charset=utf-8) chứa:
//   <!DOCTYPE html><html><head><title>pageTitle</title></head><body><img data-render-src="name:pdfAttachment" style="width:100%" /></body></html>
// - Part 2: "pdfAttachment" (Content-Type: application/pdf) chứa binary bytes của file PDF.
// - POST tới: /me/onenote/sections/{sectionID}/pages
// - Lưu liên kết PageBinding vào database (c.links.SavePage).
func (c *Client) publishPDFOne(
	ctx context.Context,
	client *http.Client,
	accountID string,
	lessonID uuid.UUID,
	pdfData []byte,
	pdfFileName string,
	audience lesson.Audience,
	notebook database.NotebookBinding,
	sectionName, pageTitle string,
) (err error) {
	sectionID, err := c.ensureSection(ctx, client, notebook.ID, sectionName)
	if err != nil {
		return fmt.Errorf("không thể đảm bảo section %q: %w", sectionName, err)
	}

	contentType, bodyReader, err := BuildPDFMultipartBody(pageTitle, pdfFileName, pdfData)
	if err != nil {
		return fmt.Errorf("không thể đóng gói multipart body cho PDF: %w", err)
	}
	bodyPayload, err := io.ReadAll(bodyReader)
	if err != nil {
		return fmt.Errorf("không thể đọc dữ liệu multipart body cho PDF: %w", err)
	}

	endpoint := fmt.Sprintf("%s/sections/%s/pages", notesBase, url.PathEscape(sectionID))
	resp, err := doOneNotePostWithRetry(ctx, client, endpoint, contentType, bodyPayload)
	if err != nil {
		return err
	}
	defer func() {
		if closeErr := resp.Body.Close(); closeErr != nil && err == nil {
			err = fmt.Errorf("lỗi đóng response body: %w", closeErr)
		}
	}()

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		errBody, readErr := io.ReadAll(resp.Body)
		if readErr != nil {
			return fmt.Errorf("OneNote API trả về lỗi HTTP %d (không đọc được body: %w)", resp.StatusCode, readErr)
		}
		return fmt.Errorf("OneNote API trả về lỗi HTTP %d: %s", resp.StatusCode, string(errBody))
	}

	var created pageResponse
	if err := decodeJSON(resp.Body, &created); err != nil {
		return fmt.Errorf("không thể decode response từ OneNote: %w", err)
	}

	if created.ID == "" {
		return errors.New("OneNote không trả về ID trang")
	}

	binding := database.PageBinding{
		AssignmentID: lessonID,
		Audience:     string(audience),
		AccountID:    accountID,
		PageID:       created.ID,
		PageURL:      created.Links.OneNoteWebURL.Href,
		NotebookID:   notebook.ID,
		SectionID:    sectionID,
	}

	if err := c.links.SavePage(ctx, binding); err != nil {
		return fmt.Errorf("không thể lưu page binding vào database: %w", err)
	}

	return nil
}

// BuildPNGPagesMultipartBody đóng gói HTML Presentation và danh sách các trang ảnh PNG (300 DPI)
// thành multipart/form-data theo chuẩn Microsoft OneNote Graph API để hiển thị bài học với độ nét cao nhất.
func BuildPNGPagesMultipartBody(pageTitle string, pngPages [][]byte) (string, io.Reader, error) {
	if len(pngPages) == 0 {
		return "", nil, errors.New("danh sách trang PNG không được rỗng")
	}

	var body bytes.Buffer
	writer := multipart.NewWriter(&body)

	// Xây dựng các thẻ img tham chiếu tới từng part imageBlock
	var imgTags strings.Builder
	for i := range pngPages {
		imgTags.WriteString(fmt.Sprintf(`  <p><img src="name:imageBlock%d" width="800" /></p>`+"\n", i+1))
	}

	// Part 1: Presentation HTML
	htmlHeader := make(textproto.MIMEHeader)
	htmlHeader.Set("Content-Disposition", `form-data; name="Presentation"`)
	htmlHeader.Set("Content-Type", "text/html; charset=utf-8")
	htmlPart, err := writer.CreatePart(htmlHeader)
	if err != nil {
		return "", nil, fmt.Errorf("không thể tạo multipart html part: %w", err)
	}

	htmlContent := fmt.Sprintf(`<!DOCTYPE html>
<html>
<head><title>%s</title></head>
<body>
%s</body>
</html>`, pageTitle, imgTags.String())

	if _, err := htmlPart.Write([]byte(htmlContent)); err != nil {
		return "", nil, fmt.Errorf("không thể ghi multipart html part: %w", err)
	}

	// Part 2..N: Mỗi ảnh PNG là một imageBlock
	for i, pageBytes := range pngPages {
		blockName := fmt.Sprintf("imageBlock%d", i+1)
		imgHeader := make(textproto.MIMEHeader)
		imgHeader.Set("Content-Disposition", fmt.Sprintf(`form-data; name="%s"`, blockName))
		imgHeader.Set("Content-Type", "image/png")
		imgPart, err := writer.CreatePart(imgHeader)
		if err != nil {
			return "", nil, fmt.Errorf("không thể tạo multipart image part %s: %w", blockName, err)
		}

		if _, err := imgPart.Write(pageBytes); err != nil {
			return "", nil, fmt.Errorf("không thể ghi multipart image part %s: %w", blockName, err)
		}
	}

	if err := writer.Close(); err != nil {
		return "", nil, fmt.Errorf("không thể close multipart writer: %w", err)
	}

	return writer.FormDataContentType(), &body, nil
}

// PublishPNGPages đẩy các trang ảnh PNG chất lượng cao (300 DPI) của Giáo viên và Học sinh lên Microsoft OneNote.
// - Bản GV được in lên Notebook Giáo Viên (AudienceTeacher), vào mục teacherChapterName.
// - Bản HS được in lên Notebook Học Sinh (AudienceStudent), vào mục studentChapterName.
// - Các trang được liên kết với assignmentID trong bảng assignment_pages.
func (c *Client) PublishPNGPages(
	ctx context.Context,
	assignmentID uuid.UUID,
	studentID uuid.UUID,
	studentName string,
	teacherPNGPages [][]byte,
	studentPNGPages [][]byte,
	studentChapterName string,
	teacherChapterName string,
	pageTitle string,
) error {
	if assignmentID == uuid.Nil() {
		return errors.New("assignmentID không được nil")
	}
	if studentID == uuid.Nil() {
		return errors.New("studentID không được nil")
	}
	if len(teacherPNGPages) == 0 {
		return errors.New("teacherPNGPages không được rỗng")
	}
	if len(studentPNGPages) == 0 {
		return errors.New("studentPNGPages không được rỗng")
	}
	if strings.TrimSpace(pageTitle) == "" {
		return errors.New("pageTitle không được để trống")
	}
	if strings.TrimSpace(teacherChapterName) == "" {
		return errors.New("teacherChapterName không được để trống")
	}
	if strings.TrimSpace(studentChapterName) == "" {
		return errors.New("studentChapterName không được để trống")
	}

	client, err := c.GetHTTPClient(ctx)
	if err != nil {
		return fmt.Errorf("không thể lấy HTTP client: %w", err)
	}
	accountID, err := c.GetAccountID(ctx)
	if err != nil {
		return fmt.Errorf("không thể lấy account ID: %w", err)
	}

	gv, err := c.ensureNotebook(ctx, client, accountID, studentID, studentName, "GV")
	if err != nil {
		return fmt.Errorf("notebook giáo viên: %w", err)
	}
	hs, err := c.ensureNotebook(ctx, client, accountID, studentID, studentName, "HS")
	if err != nil {
		return fmt.Errorf("notebook học sinh: %w", err)
	}

	if err := c.publishPNGOne(ctx, client, accountID, assignmentID, teacherPNGPages, lesson.AudienceTeacher, gv, teacherChapterName, pageTitle); err != nil {
		return fmt.Errorf("trang giáo viên: %w", err)
	}

	if err := c.publishPNGOne(ctx, client, accountID, assignmentID, studentPNGPages, lesson.AudienceStudent, hs, studentChapterName, pageTitle); err != nil {
		return fmt.Errorf("trang học sinh: %w", err)
	}

	return nil
}

func (c *Client) publishPNGOne(
	ctx context.Context,
	client *http.Client,
	accountID string,
	assignmentID uuid.UUID,
	pngPages [][]byte,
	audience lesson.Audience,
	notebook database.NotebookBinding,
	sectionName, pageTitle string,
) (err error) {
	sectionID, err := c.ensureSection(ctx, client, notebook.ID, sectionName)
	if err != nil {
		return fmt.Errorf("không thể đảm bảo section %q: %w", sectionName, err)
	}

	contentType, bodyReader, err := BuildPNGPagesMultipartBody(pageTitle, pngPages)
	if err != nil {
		return fmt.Errorf("không thể đóng gói multipart body cho PNG: %w", err)
	}
	bodyPayload, err := io.ReadAll(bodyReader)
	if err != nil {
		return fmt.Errorf("không thể đọc dữ liệu multipart body cho PNG: %w", err)
	}

	endpoint := fmt.Sprintf("%s/sections/%s/pages", notesBase, url.PathEscape(sectionID))
	resp, err := doOneNotePostWithRetry(ctx, client, endpoint, contentType, bodyPayload)
	if err != nil {
		return err
	}
	defer func() {
		if closeErr := resp.Body.Close(); closeErr != nil && err == nil {
			err = fmt.Errorf("lỗi đóng response body: %w", closeErr)
		}
	}()

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		errBody, readErr := io.ReadAll(resp.Body)
		if readErr != nil {
			return fmt.Errorf("OneNote API trả về lỗi HTTP %d (không đọc được body: %w)", resp.StatusCode, readErr)
		}
		return fmt.Errorf("OneNote API trả về lỗi HTTP %d: %s", resp.StatusCode, string(errBody))
	}

	var created pageResponse
	if err := decodeJSON(resp.Body, &created); err != nil {
		return fmt.Errorf("không thể decode response từ OneNote: %w", err)
	}

	if created.ID == "" {
		return errors.New("OneNote không trả về ID trang")
	}

	binding := database.PageBinding{
		AssignmentID: assignmentID,
		Audience:     string(audience),
		AccountID:    accountID,
		PageID:       created.ID,
		PageURL:      created.Links.OneNoteWebURL.Href,
		NotebookID:   notebook.ID,
		SectionID:    sectionID,
	}

	if err := c.links.SavePage(ctx, binding); err != nil {
		return fmt.Errorf("không thể lưu page binding vào database: %w", err)
	}

	return nil
}

// doOneNotePostWithRetry thực hiện gửi POST request lên OneNote và tự động thử lại nếu gặp lỗi HTTP 429 (Rate Limiting).
func doOneNotePostWithRetry(
	ctx context.Context,
	client *http.Client,
	endpoint, contentType string,
	bodyPayload []byte,
) (*http.Response, error) {
	maxRetries := 3
	for attempt := 1; attempt <= maxRetries; attempt++ {
		req, err := http.NewRequestWithContext(ctx, http.MethodPost, endpoint, bytes.NewReader(bodyPayload))
		if err != nil {
			return nil, fmt.Errorf("không thể tạo request POST %s: %w", endpoint, err)
		}
		req.Header.Set("Content-Type", contentType)

		resp, err := client.Do(req)
		if err != nil {
			return nil, fmt.Errorf("lỗi khi gửi request tạo trang OneNote: %w", err)
		}

		// Nếu gặp HTTP 429 Too Many Requests và chưa hết số lần retry
		if resp.StatusCode == 429 && attempt < maxRetries {
			retryAfterHeader := resp.Header.Get("Retry-After")
			waitDuration := time.Duration(attempt*2) * time.Second
			if secs, parseErr := strconv.Atoi(strings.TrimSpace(retryAfterHeader)); parseErr == nil && secs > 0 {
				waitDuration = time.Duration(secs) * time.Second
			}
			if closeErr := resp.Body.Close(); closeErr != nil {
				log.Printf("cảnh báo đóng response body khi retry 429: %v", closeErr)
			}
			select {
			case <-time.After(waitDuration):
				continue
			case <-ctx.Done():
				return nil, ctx.Err()
			}
		}

		return resp, nil
	}
	return nil, errors.New("đã thử lại quá số lần cho phép khi gặp lỗi 429 từ OneNote")
}

