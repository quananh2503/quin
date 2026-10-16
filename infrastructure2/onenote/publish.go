package onenote

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"net/textproto"
	"net/url"

	"meet-attendance-clean/domain2/assignment"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/database"
)

type pageResponse struct {
	ID    string `json:"id"`
	Links struct {
		OneNoteWebURL struct {
			Href string `json:"href"`
		} `json:"oneNoteWebUrl"`
	} `json:"links"`
}

// PublishAssignment tự động tạo Notebook/Section nếu chưa có và đẩy bài lên OneNote cho cả GV và HS
func (c *Client) PublishAssignment(
	ctx context.Context,
	a *assignment.Assignment,
	studentName string,
	content lesson.Lesson,
	studentChapterName, teacherChapterName, pageName string,
) error {
	if a == nil {
		return errors.New("assignment không được nil")
	}
	if c.htmlRenderer == nil {
		return errors.New("chưa cấu hình htmlRenderer cho OneNote client")
	}

	client, err := c.GetHTTPClient(ctx)
	if err != nil {
		return err
	}
	accountID, err := c.GetAccountID(ctx)
	if err != nil {
		return err
	}

	// Đảm bảo Notebook tồn tại
	gv, err := c.ensureNotebook(ctx, client, accountID, a.StudentID(), studentName, "GV")
	if err != nil {
		return fmt.Errorf("notebook giáo viên: %w", err)
	}
	hs, err := c.ensureNotebook(ctx, client, accountID, a.StudentID(), studentName, "HS")
	if err != nil {
		return fmt.Errorf("notebook học sinh: %w", err)
	}

	// 1. Tạo trang cho Giáo Viên (Có đáp án & lời giải)
	if err := c.publishOne(ctx, client, accountID, a, content, lesson.AudienceTeacher, gv, teacherChapterName, pageName); err != nil {
		return fmt.Errorf("trang giáo viên: %w", err)
	}

	// 2. Tạo trang cho Học Sinh (Có khung làm bài & khung feedback)
	if err := c.publishOne(ctx, client, accountID, a, content, lesson.AudienceStudent, hs, studentChapterName, pageName); err != nil {
		return fmt.Errorf("trang học sinh: %w", err)
	}

	return nil
}

func (c *Client) publishOne(
	ctx context.Context,
	client *http.Client,
	accountID string,
	a *assignment.Assignment,
	content lesson.Lesson,
	audience lesson.Audience,
	notebook database.NotebookBinding,
	sectionName, pageName string,
) error {
	// Kiểm tra xem trang đã được tạo trước đó chưa
	if existing, ok, err := c.links.GetPage(ctx, a.ID(), string(audience)); err != nil {
		return err
	} else if ok {
		if existing.AccountID != accountID {
			return errors.New("assignment đã được publish bằng tài khoản Microsoft khác")
		}
		return nil
	}

	sectionID, err := c.ensureSection(ctx, client, notebook.ID, sectionName)
	if err != nil {
		return err
	}

	// 1. Dùng c.htmlRenderer để render chuỗi HTML Presentation và mảng toàn bộ ảnh đính kèm
	htmlContent, images, err := c.htmlRenderer.Render(ctx, pageName, content, audience, a.Items())
	if err != nil {
		return fmt.Errorf("lỗi render nội dung OneNote: %w", err)
	}

	// 2. Đóng gói Body Multipart/Form-Data
	var body bytes.Buffer
	writer := multipart.NewWriter(&body)

	// PART 1: Khung sườn HTML Presentation (BẮT BUỘC name="Presentation")
	htmlHeader := make(textproto.MIMEHeader)
	htmlHeader.Set("Content-Disposition", `form-data; name="Presentation"`)
	htmlHeader.Set("Content-Type", "text/html; charset=utf-8")
	htmlPart, err := writer.CreatePart(htmlHeader)
	if err != nil {
		return err
	}
	if _, err := htmlPart.Write([]byte(htmlContent)); err != nil {
		return err
	}

	// PART 2...N: Toàn bộ ảnh đính kèm (Lý thuyết, Đề bài từng câu)
	for _, img := range images {
		imgHeader := make(textproto.MIMEHeader)
		imgHeader.Set("Content-Disposition", fmt.Sprintf(`form-data; name="%s"`, img.PartName))
		imgHeader.Set("Content-Type", img.MimeType)
		imgPart, err := writer.CreatePart(imgHeader)
		if err != nil {
			return err
		}
		if _, err := imgPart.Write(img.Data); err != nil {
			return err
		}
	}

	if err := writer.Close(); err != nil {
		return err
	}

	// 3. Gửi HTTP Request Multipart lên Microsoft Graph
	endpoint := fmt.Sprintf("%s/sections/%s/pages", notesBase, url.PathEscape(sectionID))
	var created pageResponse

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, endpoint, &body)
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", writer.FormDataContentType())

	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		errBody, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("OneNote API trả về lỗi HTTP %d: %s", resp.StatusCode, string(errBody))
	}

	if err := decodeJSON(resp.Body, &created); err != nil {
		return err
	}

	if created.ID == "" {
		return errors.New("OneNote không trả về ID trang")
	}

	// Lưu liên kết trang vào database
	binding := database.PageBinding{
		AssignmentID: a.ID(),
		Audience:     string(audience),
		AccountID:    accountID,
		PageID:       created.ID,
		PageURL:      created.Links.OneNoteWebURL.Href,
		NotebookID:   notebook.ID,
		SectionID:    sectionID,
	}

	return c.links.SavePage(ctx, binding)
}

func decodeJSON(r io.Reader, v any) error {
	if r == nil {
		return fmt.Errorf("response body rỗng (nil)")
	}
	if err := json.NewDecoder(r).Decode(v); err != nil {
		return fmt.Errorf("không thể giải mã JSON phản hồi từ OneNote: %w", err)
	}
	return nil
}
