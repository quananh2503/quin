package onenote

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	stdhtml "html"
	"io"
	"net/http"
	"net/url"
	"strings"
	"uuid"

	"meet-attendance-clean/domain2/assignment"

	xhtml "golang.org/x/net/html"
)

func (c *Client) PatchFeedback(ctx context.Context, assignmentID uuid.UUID, items []assignment.AssignmentItem) error {
	link, err := c.links.MustGetPage(ctx, assignmentID, "student")
	if err != nil {
		return err
	}
	client, err := c.GetHTTPClient(ctx)
	if err != nil {
		return err
	}
	accountID, err := c.GetAccountID(ctx)
	if err != nil {
		return err
	}
	if accountID != link.AccountID {
		return errors.New("assignment thuộc tài khoản Microsoft khác")
	}
	pageHTML, _, err := fetchPageAndInk(ctx, client, link.PageID)
	if err != nil {
		return err
	}
	commands := make([]map[string]string, 0, len(items))
	for _, item := range items {
		if !item.IsEvaluated() && strings.TrimSpace(item.Comment()) == "" {
			continue
		}
		marker := "exercise-" + item.ID().String() + "-feedback"
		target := generatedID(pageHTML, marker)
		if target == "" {
			return fmt.Errorf("không tìm thấy ô feedback OneNote cho item %s", item.ID())
		}
		commands = append(commands, map[string]string{"target": target, "action": "replace", "content": renderFeedback(item)})
	}
	if len(commands) == 0 {
		return nil
	}
	encoded, err := json.Marshal(commands)
	if err != nil {
		return err
	}
	endpoint := fmt.Sprintf("%s/pages/%s/content", notesBase, url.PathEscape(link.PageID))
	request, err := http.NewRequestWithContext(ctx, http.MethodPatch, endpoint, bytes.NewReader(encoded))
	if err != nil {
		return err
	}
	request.Header.Set("Content-Type", "application/json")
	response, err := client.Do(request)
	if err != nil {
		return err
	}
	defer response.Body.Close()
	if response.StatusCode < 200 || response.StatusCode >= 300 {
		body, _ := io.ReadAll(io.LimitReader(response.Body, 4096))
		return fmt.Errorf("OneNote PATCH feedback (%d): %s", response.StatusCode, body)
	}
	return nil
}

func generatedID(raw, marker string) string {
	doc, err := xhtml.Parse(strings.NewReader(raw))
	if err != nil {
		return ""
	}
	if node := findByAttribute(doc, "data-id", marker); node != nil {
		for _, attr := range node.Attr {
			if attr.Key == "id" {
				return attr.Val
			}
		}
	}
	return ""
}

func renderFeedback(item assignment.AssignmentItem) string {
	status, color := item.OutputResult(), "#b45309"
	if item.IsEvaluated() {
		if item.IsCorrect() {
			color = "#15803d"
		} else {
			color = "#b91c1c"
		}
	}
	key := "exercise-" + item.ID().String() + "-feedback"
	comment := strings.TrimSpace(item.Comment())
	if comment == "" {
		comment = status
	}
	return fmt.Sprintf(`<div data-id="%s" style="width:246px; background:#f8fafc; border:1px solid #e2e8f0; border-left:4px solid %s; padding:6pt 8pt; word-wrap:break-word;"><p style="margin:0 0 2pt; font-weight:bold; color:%s;">%s</p><div style="font-size:9pt; line-height:1.25;">%s</div></div>`, key, color, color, stdhtml.EscapeString(status), stdhtml.EscapeString(comment))
}
