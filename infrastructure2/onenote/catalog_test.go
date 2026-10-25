package onenote_test

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"uuid"

	"meet-attendance-clean/infrastructure2/database"
	"meet-attendance-clean/infrastructure2/onenote"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	goauth2 "golang.org/x/oauth2"
)

func TestDefaultNotebookName(t *testing.T) {
	tests := []struct {
		studentName string
		audience    string
		expected    string
	}{
		{"Nguyễn Văn A", "HS", "Nguyễn-Văn-A-HS"},
		{"Trần / Thị \\ B", "GV", "Trần---Thị---B-GV"},
		{"", "HS", "Hoc-sinh-HS"},
		{"  Lê Văn C  ", "HS", "Lê-Văn-C-HS"},
	}

	for _, tc := range tests {
		actual := onenote.DefaultNotebookName(tc.studentName, tc.audience)
		assert.Equal(t, tc.expected, actual)
	}
}

func TestListNotebooks_Success(t *testing.T) {
	// Giả lập Microsoft Graph API trả về danh sách notebooks
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "/v1.0/me/onenote/notebooks", r.URL.Path)
		assert.Equal(t, "id,displayName", r.URL.Query().Get("$select"))
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]any{
			"value": []map[string]string{
				{"id": "nb-001", "displayName": "Sổ Tay Toán 9"},
				{"id": "nb-002", "displayName": "Sổ Tay Vật Lý 9"},
			},
		})
	}))
	defer server.Close()

	// Khởi tạo Client với mock transport chuyển hướng tới test server
	tokenPath := t.TempDir() + "/token.json"
	store, err := database.Open(":memory:")
	require.NoError(t, err)
	defer store.Close()

	client := onenote.New(
		"client-id", "secret", "http://localhost/callback", tokenPath,
		database.OneNoteLinks{Store: store},
		database.Assignments{Store: store},
		nil,
	)

	// Inject custom HTTP client trỏ vào mock server
	transport := &mockRoundTripper{
		targetHost: server.Listener.Addr().String(),
	}
	ctx := context.WithValue(context.Background(), goauth2.HTTPClient, &http.Client{Transport: transport})

	notebooks, err := client.ListNotebooks(ctx)
	require.NoError(t, err)
	require.Len(t, notebooks, 2)
	assert.Equal(t, "nb-001", notebooks[0].ID)
	assert.Equal(t, "Sổ Tay Toán 9", notebooks[0].DisplayName)
	assert.Equal(t, "nb-002", notebooks[1].ID)
	assert.Equal(t, "Sổ Tay Vật Lý 9", notebooks[1].DisplayName)
}

func TestBindStudentNotebook_Validation(t *testing.T) {
	tokenPath := t.TempDir() + "/token.json"
	store, err := database.Open(":memory:")
	require.NoError(t, err)
	defer store.Close()

	client := onenote.New(
		"client-id", "secret", "http://localhost/callback", tokenPath,
		database.OneNoteLinks{Store: store},
		database.Assignments{Store: store},
		nil,
	)

	ctx := context.Background()
	studentID := uuid.New()

	// 1. studentID nil
	err = client.BindStudentNotebook(ctx, uuid.Nil(), "HS", "nb-1", "Sổ 1")
	assert.Error(t, err)

	// 2. notebookID rỗng
	err = client.BindStudentNotebook(ctx, studentID, "HS", "", "Sổ 1")
	assert.Error(t, err)

	// 3. notebookName rỗng
	err = client.BindStudentNotebook(ctx, studentID, "HS", "nb-1", "   ")
	assert.Error(t, err)
}

func TestGetAndBindStudentNotebook_Flow(t *testing.T) {
	// Giả lập Graph API cho GetAccountID (/v1.0/me)
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]string{
			"id": "ms-user-999",
		})
	}))
	defer server.Close()

	tokenPath := t.TempDir() + "/token.json"
	store, err := database.Open(":memory:")
	require.NoError(t, err)
	defer store.Close()

	links := database.OneNoteLinks{Store: store}
	client := onenote.New(
		"client-id", "secret", "http://localhost/callback", tokenPath,
		links,
		database.Assignments{Store: store},
		nil,
	)

	transport := &mockRoundTripper{
		targetHost: server.Listener.Addr().String(),
	}
	ctx := context.WithValue(context.Background(), goauth2.HTTPClient, &http.Client{Transport: transport})
	studentID := uuid.New()

	// Tạo trước student để thỏa mãn FK
	_, err = store.DB.ExecContext(ctx, `INSERT INTO students(id, name, class, cycle_start_day, created_at) VALUES(?, ?, ?, ?, ?)`,
		studentID.String(), "Học sinh Test", "9A", 1, "2026-01-01T00:00:00Z")
	require.NoError(t, err)

	// 1. Khi chưa liên kết
	binding, found, err := client.GetStudentNotebookBinding(ctx, studentID, "HS")
	require.NoError(t, err)
	assert.False(t, found)
	assert.Empty(t, binding.ID)

	// 2. Liên kết sổ tay
	err = client.BindStudentNotebook(ctx, studentID, "HS", "nb-custom-123", "Sổ Tay Riêng")
	require.NoError(t, err)

	// 3. Lấy lại sau khi liên kết
	binding, found, err = client.GetStudentNotebookBinding(ctx, studentID, "HS")
	require.NoError(t, err)
	assert.True(t, found)
	assert.Equal(t, "nb-custom-123", binding.ID)
	assert.Equal(t, "Sổ Tay Riêng", binding.Name)
}

func TestListSections_Success(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "/v1.0/me/onenote/notebooks/nb-123/sections", r.URL.Path)
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]any{
			"value": []map[string]string{
				{"id": "sec-01", "displayName": "Chương 1: Khởi Động"},
				{"id": "sec-02", "displayName": "Chương 2: Hình Học"},
			},
		})
	}))
	defer server.Close()

	tokenPath := t.TempDir() + "/token.json"
	store, err := database.Open(":memory:")
	require.NoError(t, err)
	defer store.Close()

	client := onenote.New(
		"client-id", "secret", "http://localhost/callback", tokenPath,
		database.OneNoteLinks{Store: store},
		database.Assignments{Store: store},
		nil,
	)

	transport := &mockRoundTripper{targetHost: server.Listener.Addr().String()}
	ctx := context.WithValue(context.Background(), goauth2.HTTPClient, &http.Client{Transport: transport})

	sections, err := client.ListSections(ctx, "nb-123")
	require.NoError(t, err)
	require.Len(t, sections, 2)
	assert.Equal(t, "sec-01", sections[0].ID)
	assert.Equal(t, "Chương 1: Khởi Động", sections[0].DisplayName)

	// Validation
	_, err = client.ListSections(ctx, "")
	assert.Error(t, err)
}

func TestStudentLastChapter_Flow(t *testing.T) {
	store, err := database.Open(":memory:")
	require.NoError(t, err)
	defer store.Close()

	client := onenote.New(
		"client-id", "secret", "http://localhost/callback", t.TempDir()+"/token.json",
		database.OneNoteLinks{Store: store},
		database.Assignments{Store: store},
		nil,
	)

	ctx := context.Background()
	studentID := uuid.New()

	// Tạo học sinh để thỏa mãn foreign key
	_, err = store.DB.ExecContext(ctx, `INSERT INTO students(id, name, class, cycle_start_day, created_at) VALUES(?, ?, ?, ?, ?)`,
		studentID.String(), "Học Sinh 1", "9A", 1, "2026-01-01T00:00:00Z")
	require.NoError(t, err)

	// Chưa lưu
	ch, found, err := client.GetStudentLastChapter(ctx, studentID, "HS")
	require.NoError(t, err)
	assert.False(t, found)
	assert.Empty(t, ch)

	// Lưu HS
	err = client.SaveStudentLastChapter(ctx, studentID, "HS", "c50")
	require.NoError(t, err)
	ch, found, err = client.GetStudentLastChapter(ctx, studentID, "HS")
	require.NoError(t, err)
	assert.True(t, found)
	assert.Equal(t, "c50", ch)

	// Lưu GV
	err = client.SaveStudentLastChapter(ctx, studentID, "GV", "c50-GV")
	require.NoError(t, err)
	chGV, found, err := client.GetStudentLastChapter(ctx, studentID, "GV")
	require.NoError(t, err)
	assert.True(t, found)
	assert.Equal(t, "c50-GV", chGV)

	// Validation
	assert.Error(t, client.SaveStudentLastChapter(ctx, uuid.Nil(), "HS", "c50"))
	assert.Error(t, client.SaveStudentLastChapter(ctx, studentID, "HS", "  "))
}

// mockRoundTripper chuyển hướng mọi request tới targetHost của test server
type mockRoundTripper struct {
	targetHost string
}

func (m *mockRoundTripper) RoundTrip(req *http.Request) (*http.Response, error) {
	req.URL.Scheme = "http"
	req.URL.Host = m.targetHost
	return http.DefaultTransport.RoundTrip(req)
}
