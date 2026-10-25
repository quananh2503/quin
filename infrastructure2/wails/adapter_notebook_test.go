package wails

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"uuid"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	goauth2 "golang.org/x/oauth2"

	"meet-attendance-clean/infrastructure2/database"
	"meet-attendance-clean/infrastructure2/onenote"
)

func TestV2GetStudentNotebook_Validation(t *testing.T) {
	app := &App{}

	// 1. student_id rỗng
	_, err := app.V2GetStudentNotebook(GetStudentNotebookRequest{StudentID: ""})
	assert.Error(t, err)

	// 2. student_id không hợp lệ
	_, err = app.V2GetStudentNotebook(GetStudentNotebookRequest{StudentID: "invalid-uuid"})
	assert.Error(t, err)
}

func TestV2BindStudentNotebook_Validation(t *testing.T) {
	app := &App{}
	validID := uuid.New().String()

	// 1. student_id rỗng
	err := app.V2BindStudentNotebook(BindStudentNotebookRequest{StudentID: "", NotebookID: "nb-1", NotebookName: "Sổ 1"})
	assert.Error(t, err)

	// 2. notebook_id rỗng
	err = app.V2BindStudentNotebook(BindStudentNotebookRequest{StudentID: validID, NotebookID: "", NotebookName: "Sổ 1"})
	assert.Error(t, err)

	// 3. notebook_name rỗng
	err = app.V2BindStudentNotebook(BindStudentNotebookRequest{StudentID: validID, NotebookID: "nb-1", NotebookName: "  "})
	assert.Error(t, err)
}

func TestV2SectionsAndLastChapter_Validation(t *testing.T) {
	app := &App{}
	validID := uuid.New().String()

	// 1. ListOneNoteSections rỗng notebook_id
	_, err := app.V2ListOneNoteSections(ListOneNoteSectionsRequest{NotebookID: ""})
	assert.Error(t, err)

	// 2. SaveLastChapter student_id rỗng
	err = app.V2SaveLastChapter(SaveLastChapterRequest{StudentID: "", ChapterName: "c1"})
	assert.Error(t, err)

	// 3. SaveLastChapter chapter_name rỗng
	err = app.V2SaveLastChapter(SaveLastChapterRequest{StudentID: validID, ChapterName: "  "})
	assert.Error(t, err)
}

func TestV2NotebookFlow_WithApp(t *testing.T) {
	// Giả lập Graph API cho cả User Account ID và List Notebooks
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if r.URL.Path == "/v1.0/me" {
			_ = json.NewEncoder(w).Encode(map[string]string{"id": "ms-user-test"})
			return
		}
		if r.URL.Path == "/v1.0/me/onenote/notebooks" {
			_ = json.NewEncoder(w).Encode(map[string]any{
				"value": []map[string]string{
					{"id": "nb-001", "displayName": "Sổ Toán Chuyên"},
					{"id": "nb-002", "displayName": "Sổ Hóa Học"},
				},
			})
			return
		}
		if strings.HasPrefix(r.URL.Path, "/v1.0/me/onenote/notebooks/") && strings.HasSuffix(r.URL.Path, "/sections") {
			_ = json.NewEncoder(w).Encode(map[string]any{
				"value": []map[string]string{
					{"id": "sec-001", "displayName": "Chương 1: Mở đầu"},
					{"id": "sec-002", "displayName": "Chương 2: Cơ bản"},
				},
			})
			return
		}
		http.NotFound(w, r)
	}))
	defer server.Close()

	store, err := database.Open(":memory:")
	require.NoError(t, err)
	defer store.Close()

	tokenPath := t.TempDir() + "/token.json"
	oneNoteClient := onenote.New(
		"client-id", "secret", "http://localhost/callback", tokenPath,
		database.OneNoteLinks{Store: store},
		database.Assignments{Store: store},
		nil,
	)

	app := &App{
		oneNoteClient: oneNoteClient,
	}

	transport := &mockRoundTripper{targetHost: server.Listener.Addr().String()}
	ctx := context.WithValue(context.Background(), goauth2.HTTPClient, &http.Client{Transport: transport})
	app.SetContext(ctx)

	studentUUID := uuid.New()
	studentID := studentUUID.String()

	// Tạo trước học sinh trong CSDL để thỏa mãn foreign key
	_, err = store.DB.ExecContext(ctx, `INSERT INTO students(id, name, class, cycle_start_day, created_at) VALUES(?, ?, ?, ?, ?)`,
		studentID, "Lê Tuấn Tú", "9A", 1, "2026-01-01T00:00:00Z")
	require.NoError(t, err)

	// 1. Kiểm tra khi chưa liên kết sổ tay
	nbView, err := app.V2GetStudentNotebook(GetStudentNotebookRequest{StudentID: studentID})
	require.NoError(t, err)
	assert.False(t, nbView.IsBound)
	assert.Empty(t, nbView.NotebookID)
	assert.NotEmpty(t, nbView.NotebookName)

	// 2. Lấy danh sách sổ tay OneNote từ Graph API
	list, err := app.V2ListOneNoteNotebooks()
	require.NoError(t, err)
	require.Len(t, list, 2)
	assert.Equal(t, "nb-001", list[0].ID)
	assert.Equal(t, "Sổ Toán Chuyên", list[0].DisplayName)

	// 3. Thực hiện liên kết sổ tay
	err = app.V2BindStudentNotebook(BindStudentNotebookRequest{
		StudentID:    studentID,
		NotebookID:   "nb-001",
		NotebookName: "Sổ Toán Chuyên",
	})
	require.NoError(t, err)

	// 4. Kiểm tra lại sau khi đã liên kết
	nbViewAfter, err := app.V2GetStudentNotebook(GetStudentNotebookRequest{StudentID: studentID})
	require.NoError(t, err)
	assert.True(t, nbViewAfter.IsBound)
	assert.Equal(t, "nb-001", nbViewAfter.NotebookID)
	assert.Equal(t, "Sổ Toán Chuyên", nbViewAfter.NotebookName)

	// 5. Kiểm tra và liên kết sổ tay Giáo Viên (Audience: "GV") độc lập với Học Sinh ("HS")
	gvViewBefore, err := app.V2GetStudentNotebook(GetStudentNotebookRequest{StudentID: studentID, Audience: "GV"})
	require.NoError(t, err)
	assert.False(t, gvViewBefore.IsBound)
	assert.Equal(t, "GV", gvViewBefore.Audience)

	err = app.V2BindStudentNotebook(BindStudentNotebookRequest{
		StudentID:    studentID,
		Audience:     "GV",
		NotebookID:   "nb-002",
		NotebookName: "Sổ Hóa Học - GV",
	})
	require.NoError(t, err)

	gvViewAfter, err := app.V2GetStudentNotebook(GetStudentNotebookRequest{StudentID: studentID, Audience: "GV"})
	require.NoError(t, err)
	assert.True(t, gvViewAfter.IsBound)
	assert.Equal(t, "nb-002", gvViewAfter.NotebookID)
	assert.Equal(t, "Sổ Hóa Học - GV", gvViewAfter.NotebookName)

	// Đảm bảo sổ HS vẫn giữ nguyên vẹn
	hsCheck, err := app.V2GetStudentNotebook(GetStudentNotebookRequest{StudentID: studentID, Audience: "HS"})
	require.NoError(t, err)
	assert.True(t, hsCheck.IsBound)
	assert.Equal(t, "nb-001", hsCheck.NotebookID)

	// 6. Test V2ListOneNoteSections (danh sách chương trong notebook)
	sections, err := app.V2ListOneNoteSections(ListOneNoteSectionsRequest{NotebookID: "nb-001"})
	require.NoError(t, err)
	require.Len(t, sections, 2)
	assert.Equal(t, "sec-001", sections[0].ID)
	assert.Equal(t, "Chương 1: Mở đầu", sections[0].DisplayName)

	// 7. Test V2SaveLastChapter và V2GetStudentNotebook tự động điền LastChapterName
	err = app.V2SaveLastChapter(SaveLastChapterRequest{
		StudentID:   studentID,
		Audience:    "HS",
		ChapterName: "c50",
	})
	require.NoError(t, err)

	hsViewWithChapter, err := app.V2GetStudentNotebook(GetStudentNotebookRequest{StudentID: studentID, Audience: "HS"})
	require.NoError(t, err)
	assert.Equal(t, "c50", hsViewWithChapter.LastChapterName)

	err = app.V2SaveLastChapter(SaveLastChapterRequest{
		StudentID:   studentID,
		Audience:    "GV",
		ChapterName: "c50-GV",
	})
	require.NoError(t, err)

	gvViewWithChapter, err := app.V2GetStudentNotebook(GetStudentNotebookRequest{StudentID: studentID, Audience: "GV"})
	require.NoError(t, err)
	assert.Equal(t, "c50-GV", gvViewWithChapter.LastChapterName)
}

type mockRoundTripper struct {
	targetHost string
}

func (m *mockRoundTripper) RoundTrip(req *http.Request) (*http.Response, error) {
	req.URL.Scheme = "http"
	req.URL.Host = m.targetHost
	return http.DefaultTransport.RoundTrip(req)
}
