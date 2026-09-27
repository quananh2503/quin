package onenote

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	stdhtml "html"
	"io"
	"mime"
	"mime/multipart"
	"net/http"
	"net/url"
	"strings"
	"uuid"

	"meet-attendance-clean/domain2/assignment"
	exercise "meet-attendance-clean/domain2/excercise"
	legacyink "meet-attendance-clean/infrastructure/onenote"

	xhtml "golang.org/x/net/html"
)

func (c *Client) FetchStudentSubmission(ctx context.Context, assignmentID uuid.UUID) ([]byte, []assignment.Answer, error) {
	link, err := c.links.MustGetPage(ctx, assignmentID, "student")
	if err != nil {
		return nil, nil, err
	}
	a, err := c.assignments.GetByID(ctx, assignmentID)
	if err != nil {
		return nil, nil, err
	}
	client, err := c.GetHTTPClient(ctx)
	if err != nil {
		return nil, nil, err
	}
	accountID, err := c.GetAccountID(ctx)
	if err != nil {
		return nil, nil, err
	}
	if accountID != link.AccountID {
		return nil, nil, errors.New("assignment thuộc tài khoản Microsoft khác")
	}
	content, ink, err := fetchPageAndInk(ctx, client, link.PageID)
	if err != nil {
		return nil, nil, err
	}
	var pageInk []byte
	if len(ink) > 0 {
		pageInk, err = legacyink.RenderInkMLToJPEG(ink)
		if err != nil {
			return nil, nil, fmt.Errorf("chuyển nét bút trang thành ảnh: %w", err)
		}
	}
	answers := make([]assignment.Answer, 0, len(a.Items()))
	for _, item := range a.Items() {
		prefix := "exercise-" + item.ID().String()
		answerHTML, _ := elementInner(content, prefix+"-answer-content")
		text, images, err := parseAnswerHTML(ctx, client, answerHTML)
		if err != nil {
			return nil, nil, fmt.Errorf("đọc bài làm item %s: %w", item.ID(), err)
		}
		if regionHTML, found := elementInner(content, prefix+"-region"); found {
			_, regionImages, err := parseAnswerHTML(ctx, client, regionHTML)
			if err == nil {
				for _, image := range regionImages {
					if !containsImage(images, image) {
						images = append(images, image)
					}
				}
			}
		}
		switch ex := item.Exercise().(type) {
		case exercise.MultipleChoiceExercise:
			choiceHTML, _ := elementInner(content, prefix+"-choice")
			selected := selectedOptions(choiceHTML)
			var selection string
			if len(selected) == 1 {
				selection = selected[0]
			}
			answer, err := assignment.NewMCQAnswer(item.ID(), selection, text, images)
			if err != nil {
				return nil, nil, err
			}
			answers = append(answers, answer)
		case exercise.EssayExercise:
			parts := make([]string, 0, len(ex.Parts()))
			for _, part := range ex.Parts() {
				parts = append(parts, part.Label())
			}
			answer, err := assignment.NewEssayAnswer(item.ID(), text, images, parts)
			if err != nil {
				return nil, nil, err
			}
			answers = append(answers, answer)
		default:
			return nil, nil, fmt.Errorf("loại bài tập chưa hỗ trợ: %T", item.Exercise())
		}
	}
	return pageInk, answers, nil
}

func fetchPageAndInk(ctx context.Context, client *http.Client, pageID string) (string, []byte, error) {
	endpoint := fmt.Sprintf("%s/pages/%s/content?includeIDs=true&includeInkML=true", notesBase, url.PathEscape(pageID))
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
	if err != nil {
		return "", nil, err
	}
	req.Header.Set("Accept", "multipart/form-data, application/inkml+xml, text/html, application/xhtml+xml")
	resp, err := client.Do(req)
	if err != nil {
		return "", nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		data, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
		return "", nil, fmt.Errorf("đọc trang OneNote (%d): %s", resp.StatusCode, data)
	}
	mediaType, params, err := mime.ParseMediaType(resp.Header.Get("Content-Type"))
	if err == nil && strings.HasPrefix(strings.ToLower(mediaType), "multipart/") {
		reader := multipart.NewReader(resp.Body, params["boundary"])
		var htmlContent string
		var ink []byte
		for {
			part, err := reader.NextPart()
			if errors.Is(err, io.EOF) {
				break
			}
			if err != nil {
				return "", nil, err
			}
			partType, _, _ := mime.ParseMediaType(part.Header.Get("Content-Type"))
			data, err := io.ReadAll(io.LimitReader(part, 30<<20))
			part.Close()
			if err != nil {
				return "", nil, err
			}
			if strings.EqualFold(part.FormName(), "presentation") || strings.Contains(partType, "html") {
				htmlContent = string(data)
			} else if strings.EqualFold(part.FormName(), "inkml") || strings.Contains(partType, "inkml") {
				ink = data
			}
		}
		if htmlContent == "" {
			return "", nil, errors.New("OneNote không trả HTML trang học sinh")
		}
		return htmlContent, ink, nil
	}
	data, err := io.ReadAll(io.LimitReader(resp.Body, 30<<20))
	return string(data), nil, err
}

func elementInner(raw, target string) (string, bool) {
	doc, err := xhtml.Parse(strings.NewReader(raw))
	if err != nil {
		return "", false
	}
	node := findByAttribute(doc, "data-id", target)
	if node == nil {
		node = findByAttribute(doc, "id", target)
	}
	if node == nil {
		return "", false
	}
	var out strings.Builder
	for child := node.FirstChild; child != nil; child = child.NextSibling {
		_ = xhtml.Render(&out, child)
	}
	return out.String(), true
}

func findByAttribute(root *xhtml.Node, key, value string) *xhtml.Node {
	if root.Type == xhtml.ElementNode {
		for _, a := range root.Attr {
			if a.Key == key && a.Val == value {
				return root
			}
		}
	}
	for child := root.FirstChild; child != nil; child = child.NextSibling {
		if found := findByAttribute(child, key, value); found != nil {
			return found
		}
	}
	return nil
}

func parseAnswerHTML(ctx context.Context, client *http.Client, raw string) (string, [][]byte, error) {
	doc, err := xhtml.Parse(strings.NewReader("<html><body>" + raw + "</body></html>"))
	if err != nil {
		return "", nil, err
	}
	var texts, imageURLs []string
	var walk func(*xhtml.Node)
	walk = func(node *xhtml.Node) {
		if node.Type == xhtml.TextNode {
			text := strings.TrimSpace(stdhtml.UnescapeString(node.Data))
			if text != "" && !strings.HasPrefix(text, "✍️ Bài làm (Gõ chữ") {
				texts = append(texts, text)
			}
		}
		if node.Type == xhtml.ElementNode && node.Data == "img" {
			var src string
			for _, attr := range node.Attr {
				if attr.Key == "src" {
					src = attr.Val
				}
				if attr.Key == "data-fullres-src" && attr.Val != "" {
					src = attr.Val
					break
				}
			}
			if src != "" {
				imageURLs = append(imageURLs, src)
			}
		}
		for child := node.FirstChild; child != nil; child = child.NextSibling {
			walk(child)
		}
	}
	walk(doc)
	images := make([][]byte, 0, len(imageURLs))
	for _, imageURL := range imageURLs {
		image, err := fetchImage(ctx, client, imageURL)
		if err != nil {
			return "", nil, err
		}
		images = append(images, image)
	}
	return strings.Join(texts, " "), images, nil
}

func fetchImage(ctx context.Context, client *http.Client, raw string) ([]byte, error) {
	parsed, err := url.Parse(strings.TrimSpace(raw))
	if err != nil || parsed.Scheme != "https" {
		return nil, errors.New("URL ảnh OneNote không hợp lệ")
	}
	request, err := http.NewRequestWithContext(ctx, http.MethodGet, parsed.String(), nil)
	if err != nil {
		return nil, err
	}
	// OAuth tokens are only sent to Microsoft Graph. External pasted images use a plain client.
	if parsed.Hostname() != "graph.microsoft.com" {
		client = http.DefaultClient
	}
	response, err := client.Do(request)
	if err != nil {
		return nil, err
	}
	defer response.Body.Close()
	if response.StatusCode < 200 || response.StatusCode >= 300 {
		return nil, fmt.Errorf("không tải được ảnh bài làm (%d)", response.StatusCode)
	}
	return io.ReadAll(io.LimitReader(response.Body, 10<<20))
}

func selectedOptions(raw string) []string {
	doc, err := xhtml.Parse(strings.NewReader("<html><body>" + raw + "</body></html>"))
	if err != nil {
		return nil
	}
	var result []string
	var walk func(*xhtml.Node)
	walk = func(node *xhtml.Node) {
		if node.Type == xhtml.ElementNode {
			var id, tag string
			for _, attr := range node.Attr {
				if attr.Key == "data-id" {
					id = attr.Val
				}
				if attr.Key == "data-tag" {
					tag = strings.ToLower(attr.Val)
				}
			}
			if strings.HasPrefix(tag, "to-do:completed") {
				if pos := strings.LastIndex(id, "-option-"); pos >= 0 {
					result = append(result, strings.TrimSpace(id[pos+len("-option-"):]))
				}
			}
		}
		for child := node.FirstChild; child != nil; child = child.NextSibling {
			walk(child)
		}
	}
	walk(doc)
	return result
}

func containsImage(existing [][]byte, candidate []byte) bool {
	for _, image := range existing {
		if bytes.Equal(image, candidate) {
			return true
		}
	}
	return false
}
