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
