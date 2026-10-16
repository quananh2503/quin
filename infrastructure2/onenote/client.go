package onenote

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"strings"

	goauth2 "golang.org/x/oauth2"
	"golang.org/x/oauth2/microsoft"

	"meet-attendance-clean/infrastructure2/database"
	htmlRenderer "meet-attendance-clean/infrastructure2/html"
	"meet-attendance-clean/infrastructure2/oauth2"
)

const (
	graphBase = "https://graph.microsoft.com/v1.0"
	notesBase = graphBase + "/me/onenote"
)

type Client struct {
	*oauth2.Manager // Kế thừa: IsConnected, Exchange, GetHTTPClient, Disconnect
	links           database.OneNoteLinks
	assignments     database.Assignments
	htmlRenderer    *htmlRenderer.Renderer // Giữ 1 renderer duy nhất này
}

func New(
	clientID, clientSecret, redirectURL, tokenPath string,
	links database.OneNoteLinks,
	assignments database.Assignments,
	htmlRenderer *htmlRenderer.Renderer, // Nhận htmlRenderer từ bên ngoài vào
) *Client {
	cfg := &goauth2.Config{
		ClientID:     clientID,
		ClientSecret: clientSecret,
		RedirectURL:  redirectURL,
		Endpoint:     microsoft.AzureADEndpoint("common"),
		Scopes: []string{
			"offline_access",
			"Notes.ReadWrite",
			"User.Read",
		},
	}

	return &Client{
		Manager:      oauth2.NewManager(cfg, tokenPath),
		links:        links,
		assignments:  assignments,
		htmlRenderer: htmlRenderer, // Gán vào struct Client
	}
}

// AuthorizationURL thêm tuỳ chọn select_account để người dùng chọn tài khoản Microsoft mong muốn
func (c *Client) AuthorizationURL(state string) string {
	return c.Manager.AuthURL(state, goauth2.SetAuthURLParam("prompt", "select_account"))
}

// GetAccountID lấy User ID của tài khoản Microsoft hiện tại
func (c *Client) GetAccountID(ctx context.Context) (string, error) {
	client, err := c.GetHTTPClient(ctx)
	if err != nil {
		return "", err
	}

	var response struct {
		ID string `json:"id"`
	}
	if err := getJSON(ctx, client, graphBase+"/me?$select=id", &response); err != nil {
		return "", err
	}
	if response.ID == "" {
		return "", errors.New("Microsoft Graph không trả account ID")
	}
	return response.ID, nil
}

func getJSON(ctx context.Context, client *http.Client, endpoint string, result any) error {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
	if err != nil {
		return err
	}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		body, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
		return fmt.Errorf("Microsoft Graph GET %s (%d): %s", endpoint, resp.StatusCode, strings.TrimSpace(string(body)))
	}
	return json.NewDecoder(resp.Body).Decode(result)
}

func post(ctx context.Context, client *http.Client, endpoint, contentType string, body io.Reader, result any) error {
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, endpoint, body)
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", contentType)

	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		data, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
		return fmt.Errorf("Microsoft Graph POST %s (%d): %s", endpoint, resp.StatusCode, strings.TrimSpace(string(data)))
	}
	return json.NewDecoder(resp.Body).Decode(result)
}
