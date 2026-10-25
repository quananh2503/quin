package onenote

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"uuid"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/infrastructure2/database"
)

type graphEntry struct {
	ID          string `json:"id"`
	DisplayName string `json:"displayName"`
}
type graphList struct {
	Value    []graphEntry `json:"value"`
	NextLink string       `json:"@odata.nextLink"`
}

func listAll(ctx context.Context, client *http.Client, endpoint string) ([]graphEntry, error) {
	var all []graphEntry
	for endpoint != "" {
		var page graphList
		if err := getJSON(ctx, client, endpoint, &page); err != nil {
			return nil, err
		}
		all = append(all, page.Value...)
		endpoint = page.NextLink
	}
	return all, nil
}

func notebookName(studentName, audience string) string {
	base := strings.TrimSpace(studentName)
	base = strings.NewReplacer("_", "-", " ", "-", "/", "-", "\\", "-").Replace(base)
	base = strings.Trim(base, "- ")
	if base == "" {
		base = "Hoc-sinh"
	}
	return base + "-" + audience
}

// NotebookInfo đại diện cho thông tin một cuốn sổ tay Microsoft OneNote từ Microsoft Graph API.
type NotebookInfo struct {
	ID          string `json:"id"`
	DisplayName string `json:"displayName"`
}

// DefaultNotebookName trả về tên sổ tay mặc định theo quy ước nếu học sinh chưa từng liên kết sổ tay nào.
// Ví dụ: "Nguyen Van A" + "HS" -> "Nguyen-Van-A-HS".
func DefaultNotebookName(studentName, audience string) string {
	return notebookName(studentName, audience)
}

// ListNotebooks truy vấn danh sách tất cả các sổ tay OneNote của tài khoản hiện tại qua Microsoft Graph API.
// Trả về danh sách NotebookInfo hoặc lỗi nếu không kết nối được hoặc Graph API trả mã lỗi.
func (c *Client) ListNotebooks(ctx context.Context) ([]NotebookInfo, error) {
	client, err := c.GetHTTPClient(ctx)
	if err != nil {
		return nil, fmt.Errorf("không thể lấy HTTP client: %w", err)
	}
	entries, err := listAll(ctx, client, notesBase+"/notebooks?$select=id,displayName")
	if err != nil {
		return nil, fmt.Errorf("lấy danh sách notebook từ Microsoft Graph thất bại: %w", err)
	}
	result := make([]NotebookInfo, len(entries))
	for i, entry := range entries {
		result[i] = NotebookInfo{ID: entry.ID, DisplayName: entry.DisplayName}
	}
	return result, nil
}

// GetStudentNotebookBinding lấy thông tin liên kết sổ tay của học sinh từ CSDL SQLite theo studentID và audience (mặc định "HS" nếu rỗng).
// Trả về (binding, true, nil) nếu đã liên kết, hoặc (empty, false, nil) nếu chưa liên kết.
func (c *Client) GetStudentNotebookBinding(ctx context.Context, studentID uuid.UUID, audience string) (database.NotebookBinding, bool, error) {
	if audience == "" {
		audience = "HS"
	}
	return c.links.GetNotebookByStudent(ctx, studentID, audience)
}

// BindStudentNotebook lưu hoặc cập nhật liên kết giữa học sinh và một cuốn sổ tay OneNote vào CSDL SQLite.
// Invariants:
// - studentID không được nil.
// - notebookID và notebookName không được để trống.
// - audience mặc định là "HS" nếu để rỗng.
// - Tài khoản OneNote hiện tại phải lấy được qua GetAccountID.
func (c *Client) BindStudentNotebook(ctx context.Context, studentID uuid.UUID, audience, notebookID, notebookName string) error {
	if studentID == uuid.Nil() {
		return errors.New("studentID không được nil")
	}
	if notebookID == "" {
		return errors.New("notebookID không được để trống")
	}
	if strings.TrimSpace(notebookName) == "" {
		return errors.New("notebookName không được để trống")
	}
	if audience == "" {
		audience = "HS"
	}
	accountID, err := c.GetAccountID(ctx)
	if err != nil {
		return fmt.Errorf("không thể lấy account ID: %w", err)
	}
	binding := database.NotebookBinding{
		StudentID: studentID,
		Audience:  audience,
		AccountID: accountID,
		ID:        notebookID,
		Name:      strings.TrimSpace(notebookName),
	}
	if err := c.links.SaveNotebook(ctx, binding); err != nil {
		return fmt.Errorf("lưu liên kết sổ tay thất bại: %w", err)
	}
	return nil
}

// SectionInfo đại diện cho thông tin một chương (section) trong cuốn sổ tay OneNote.
type SectionInfo struct {
	ID          string `json:"id"`
	DisplayName string `json:"displayName"`
}

// ListSections truy vấn danh sách tất cả các chương (sections) trong một cuốn sổ tay OneNote từ Microsoft Graph API.
// Invariants:
// - notebookID không được để trống.
func (c *Client) ListSections(ctx context.Context, notebookID string) ([]SectionInfo, error) {
	trimmedID := strings.TrimSpace(notebookID)
	if trimmedID == "" {
		return nil, errors.New("notebookID không được để trống")
	}
	client, err := c.GetHTTPClient(ctx)
	if err != nil {
		return nil, fmt.Errorf("không thể lấy http client: %w", err)
	}
	entries, err := c.listSections(ctx, client, trimmedID)
	if err != nil {
		return nil, fmt.Errorf("truy vấn danh sách sections thất bại: %w", err)
	}
	res := make([]SectionInfo, 0, len(entries))
	for _, e := range entries {
		res = append(res, SectionInfo{
			ID:          e.ID,
			DisplayName: e.DisplayName,
		})
	}
	return res, nil
}

// GetStudentLastChapter lấy tên chương được chọn gần đây nhất của học sinh từ CSDL SQLite theo studentID và audience (mặc định "HS" nếu rỗng).
func (c *Client) GetStudentLastChapter(ctx context.Context, studentID uuid.UUID, audience string) (string, bool, error) {
	if audience == "" {
		audience = "HS"
	}
	return c.links.GetLastChapter(ctx, studentID, audience)
}

// SaveStudentLastChapter lưu tên chương được chọn gần đây nhất của học sinh vào CSDL SQLite.
// Invariants:
// - studentID không được nil.
// - chapterName không được để trống.
// - audience mặc định là "HS" nếu rỗng.
func (c *Client) SaveStudentLastChapter(ctx context.Context, studentID uuid.UUID, audience, chapterName string) error {
	if studentID == uuid.Nil() {
		return errors.New("studentID không được nil")
	}
	trimmedCh := strings.TrimSpace(chapterName)
	if trimmedCh == "" {
		return errors.New("chapterName không được để trống")
	}
	if audience == "" {
		audience = "HS"
	}
	return c.links.SaveLastChapter(ctx, studentID, audience, trimmedCh)
}

func (c *Client) PrepareStudent(ctx context.Context, studentID uuid.UUID, studentName string) (application2.PublishingTargets, error) {
	client, err := c.GetHTTPClient(ctx)
	if err != nil {
		return application2.PublishingTargets{}, err
	}
	accountID, err := c.GetAccountID(ctx)
	if err != nil {
		return application2.PublishingTargets{}, err
	}
	hs, err := c.ensureNotebook(ctx, client, accountID, studentID, studentName, "HS")
	if err != nil {
		return application2.PublishingTargets{}, err
	}
	gv, err := c.ensureNotebook(ctx, client, accountID, studentID, studentName, "GV")
	if err != nil {
		return application2.PublishingTargets{}, err
	}
	hsSections, err := c.listSections(ctx, client, hs.ID)
	if err != nil {
		return application2.PublishingTargets{}, err
	}
	gvSections, err := c.listSections(ctx, client, gv.ID)
	if err != nil {
		return application2.PublishingTargets{}, err
	}
	result := application2.PublishingTargets{Student: application2.PublishingNotebook{Name: hs.Name}, Teacher: application2.PublishingNotebook{Name: gv.Name}}
	for _, sec := range hsSections {
		result.Student.Sections = append(result.Student.Sections, sec.DisplayName)
	}
	for _, sec := range gvSections {
		result.Teacher.Sections = append(result.Teacher.Sections, sec.DisplayName)
	}
	return result, nil
}

func (c *Client) ensureNotebook(ctx context.Context, client *http.Client, accountID string, studentID uuid.UUID, studentName, audience string) (database.NotebookBinding, error) {
	if saved, ok, err := c.links.GetNotebook(ctx, studentID, audience, accountID); err != nil {
		return database.NotebookBinding{}, err
	} else if ok {
		return saved, nil
	}
	name := notebookName(studentName, audience)
	list, err := listAll(ctx, client, notesBase+"/notebooks?$select=id,displayName")
	if err != nil {
		return database.NotebookBinding{}, err
	}
	var id string
	for _, found := range list {
		if strings.EqualFold(strings.TrimSpace(found.DisplayName), name) {
			if id != "" {
				return database.NotebookBinding{}, fmt.Errorf("nhiều notebook trùng tên %q; cần liên kết thủ công", name)
			}
			id = found.ID
		}
	}
	if id == "" {
		data, err := json.Marshal(map[string]string{"displayName": name})
		if err != nil {
			return database.NotebookBinding{}, err
		}
		var created graphEntry
		if err := post(ctx, client, notesBase+"/notebooks", "application/json", bytes.NewReader(data), &created); err != nil {
			return database.NotebookBinding{}, err
		}
		id = created.ID
	}
	if id == "" {
		return database.NotebookBinding{}, errors.New("OneNote không trả notebook ID")
	}
	binding := database.NotebookBinding{StudentID: studentID, Audience: audience, AccountID: accountID, ID: id, Name: name}
	if err := c.links.SaveNotebook(ctx, binding); err != nil {
		return database.NotebookBinding{}, fmt.Errorf("đã tìm/tạo notebook nhưng lưu liên kết thất bại: %w", err)
	}
	return binding, nil
}

func (c *Client) listSections(ctx context.Context, client *http.Client, notebookID string) ([]graphEntry, error) {
	endpoint := fmt.Sprintf("%s/notebooks/%s/sections?$select=id,displayName", notesBase, url.PathEscape(notebookID))
	return listAll(ctx, client, endpoint)
}

func (c *Client) ensureSection(ctx context.Context, client *http.Client, notebookID, name string) (string, error) {
	name = strings.TrimSpace(name)
	if name == "" {
		return "", errors.New("tên chương không được để trống")
	}
	list, err := c.listSections(ctx, client, notebookID)
	if err != nil {
		return "", err
	}
	for _, found := range list {
		if strings.EqualFold(strings.TrimSpace(found.DisplayName), name) {
			return found.ID, nil
		}
	}
	data, err := json.Marshal(map[string]string{"displayName": name})
	if err != nil {
		return "", err
	}
	endpoint := fmt.Sprintf("%s/notebooks/%s/sections", notesBase, url.PathEscape(notebookID))
	var created graphEntry
	if err := post(ctx, client, endpoint, "application/json", bytes.NewReader(data), &created); err != nil {
		return "", err
	}
	if created.ID == "" {
		return "", errors.New("OneNote không trả section ID")
	}
	return created.ID, nil
}
