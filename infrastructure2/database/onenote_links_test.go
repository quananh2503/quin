package database_test

import (
	"context"
	"testing"
	"uuid"

	"meet-attendance-clean/infrastructure2/database"
	"meet-attendance-clean/infrastructure2/database/dbgen"
	"meet-attendance-clean/infrastructure2/database/mocks"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestOneNoteLinks_NotebookBinding_SQLite(t *testing.T) {
	ctx := context.Background()
	store, err := database.Open(":memory:")
	require.NoError(t, err)
	defer store.Close()

	links := database.OneNoteLinks{Store: store}
	studentID := uuid.New()

	// 0. Tạo học sinh trong DB để thỏa mãn foreign key
	_, err = store.DB.ExecContext(ctx, `INSERT INTO students(id, name, class, cycle_start_day, created_at) VALUES(?, ?, ?, ?, ?)`,
		studentID.String(), "Nguyễn Văn Nam", "9A", 1, "2026-01-01T00:00:00Z")
	require.NoError(t, err)

	// 1. Kiểm tra khi chưa có liên kết nào được lưu
	binding, found, err := links.GetNotebookByStudent(ctx, studentID, "HS")
	require.NoError(t, err)
	assert.False(t, found)
	assert.Empty(t, binding.ID)

	// 2. Lưu liên kết sổ tay mới
	b1 := database.NotebookBinding{
		StudentID: studentID,
		Audience:  "HS",
		AccountID: "ms-account-001",
		ID:        "nb-onenote-123",
		Name:      "Vở Toán 9 - Nam",
	}
	err = links.SaveNotebook(ctx, b1)
	require.NoError(t, err)

	// 3. Lấy lại qua GetNotebook (chỉ định accountID)
	savedByAccount, found, err := links.GetNotebook(ctx, studentID, "HS", "ms-account-001")
	require.NoError(t, err)
	assert.True(t, found)
	assert.Equal(t, "nb-onenote-123", savedByAccount.ID)
	assert.Equal(t, "Vở Toán 9 - Nam", savedByAccount.Name)
	assert.Equal(t, "ms-account-001", savedByAccount.AccountID)

	// 4. Lấy lại qua GetNotebookByStudent (không cần accountID)
	savedByStudent, found, err := links.GetNotebookByStudent(ctx, studentID, "HS")
	require.NoError(t, err)
	assert.True(t, found)
	assert.Equal(t, "nb-onenote-123", savedByStudent.ID)
	assert.Equal(t, "Vở Toán 9 - Nam", savedByStudent.Name)
	assert.Equal(t, "ms-account-001", savedByStudent.AccountID)

	// 5. Cập nhật liên kết sang sổ tay khác (Upsert)
	b2 := database.NotebookBinding{
		StudentID: studentID,
		Audience:  "HS",
		AccountID: "ms-account-001",
		ID:        "nb-onenote-456",
		Name:      "Vở Hình Học 9 - Nam Mới",
	}
	err = links.SaveNotebook(ctx, b2)
	require.NoError(t, err)

	updated, found, err := links.GetNotebookByStudent(ctx, studentID, "HS")
	require.NoError(t, err)
	assert.True(t, found)
	assert.Equal(t, "nb-onenote-456", updated.ID)
	assert.Equal(t, "Vở Hình Học 9 - Nam Mới", updated.Name)

	// 6. Kiểm tra các điều kiện validation lỗi
	assert.Error(t, links.SaveNotebook(ctx, database.NotebookBinding{StudentID: uuid.Nil(), Audience: "HS", AccountID: "acc", ID: "1"}))
	assert.Error(t, links.SaveNotebook(ctx, database.NotebookBinding{StudentID: studentID, Audience: "", AccountID: "acc", ID: "1"}))
	assert.Error(t, links.SaveNotebook(ctx, database.NotebookBinding{StudentID: studentID, Audience: "HS", AccountID: "", ID: "1"}))
	assert.Error(t, links.SaveNotebook(ctx, database.NotebookBinding{StudentID: studentID, Audience: "HS", AccountID: "acc", ID: ""}))

	// 7. Kiểm tra Last Chapter (chương được chọn cuối cùng) cho cả HS và GV
	ch, found, err := links.GetLastChapter(ctx, studentID, "HS")
	require.NoError(t, err)
	assert.False(t, found)
	assert.Empty(t, ch)

	err = links.SaveLastChapter(ctx, studentID, "HS", "Chương 1: Hình học")
	require.NoError(t, err)

	ch, found, err = links.GetLastChapter(ctx, studentID, "HS")
	require.NoError(t, err)
	assert.True(t, found)
	assert.Equal(t, "Chương 1: Hình học", ch)

	err = links.SaveLastChapter(ctx, studentID, "GV", "Chương 1: Giáo án")
	require.NoError(t, err)

	chGV, found, err := links.GetLastChapter(ctx, studentID, "GV")
	require.NoError(t, err)
	assert.True(t, found)
	assert.Equal(t, "Chương 1: Giáo án", chGV)

	// Cập nhật chương mới (Upsert)
	err = links.SaveLastChapter(ctx, studentID, "HS", "Chương 2: Đại số")
	require.NoError(t, err)
	chUpdated, found, err := links.GetLastChapter(ctx, studentID, "HS")
	require.NoError(t, err)
	assert.True(t, found)
	assert.Equal(t, "Chương 2: Đại số", chUpdated)

	// Validation
	assert.Error(t, links.SaveLastChapter(ctx, uuid.Nil(), "HS", "Chương 1"))
	assert.Error(t, links.SaveLastChapter(ctx, studentID, "", "Chương 1"))
	assert.Error(t, links.SaveLastChapter(ctx, studentID, "HS", "  "))
}

func TestOneNoteLinks_SqlcQuerier_WithMockery(t *testing.T) {
	ctx := context.Background()
	mockQ := mocks.NewQuerier(t)

	studentID := uuid.New().String()
	audience := "HS"
	accountID := "account-abc"

	expectedRow := dbgen.NotebookBinding{
		StudentID:    studentID,
		Audience:     audience,
		AccountID:    accountID,
		NotebookID:   "nb-mock-789",
		NotebookName: "Mock Notebook",
	}

	mockQ.On("GetNotebookBindingByStudentAndAudience", ctx, dbgen.GetNotebookBindingByStudentAndAudienceParams{
		StudentID: studentID,
		Audience:  audience,
	}).Return(expectedRow, nil).Once()

	res, err := mockQ.GetNotebookBindingByStudentAndAudience(ctx, dbgen.GetNotebookBindingByStudentAndAudienceParams{
		StudentID: studentID,
		Audience:  audience,
	})
	require.NoError(t, err)
	assert.Equal(t, "nb-mock-789", res.NotebookID)
	assert.Equal(t, "Mock Notebook", res.NotebookName)

	mockQ.On("UpsertNotebookBinding", ctx, dbgen.UpsertNotebookBindingParams{
		StudentID:    studentID,
		Audience:     audience,
		AccountID:    accountID,
		NotebookID:   "nb-mock-789",
		NotebookName: "Mock Notebook",
	}).Return(nil).Once()

	err = mockQ.UpsertNotebookBinding(ctx, dbgen.UpsertNotebookBindingParams{
		StudentID:    studentID,
		Audience:     audience,
		AccountID:    accountID,
		NotebookID:   "nb-mock-789",
		NotebookName: "Mock Notebook",
	})
	require.NoError(t, err)

	// Mock GetLastChapter & UpsertLastChapter
	mockQ.On("GetLastChapter", ctx, dbgen.GetLastChapterParams{
		StudentID: studentID,
		Audience:  audience,
	}).Return(dbgen.StudentLastChapter{
		StudentID:   studentID,
		Audience:    audience,
		ChapterName: "Chương Mock 1",
		UpdatedAt:   "2026-01-01T00:00:00Z",
	}, nil).Once()

	lastChRow, err := mockQ.GetLastChapter(ctx, dbgen.GetLastChapterParams{
		StudentID: studentID,
		Audience:  audience,
	})
	require.NoError(t, err)
	assert.Equal(t, "Chương Mock 1", lastChRow.ChapterName)

	mockQ.On("UpsertLastChapter", ctx, dbgen.UpsertLastChapterParams{
		StudentID:   studentID,
		Audience:    audience,
		ChapterName: "Chương Mock 2",
		UpdatedAt:   "2026-01-01T00:00:00Z",
	}).Return(nil).Once()

	err = mockQ.UpsertLastChapter(ctx, dbgen.UpsertLastChapterParams{
		StudentID:   studentID,
		Audience:    audience,
		ChapterName: "Chương Mock 2",
		UpdatedAt:   "2026-01-01T00:00:00Z",
	})
	require.NoError(t, err)
}

func TestOneNoteLinks_NormalizeLegacyURLOnGetPage(t *testing.T) {
	ctx := context.Background()
	store, err := database.Open(":memory:")
	require.NoError(t, err)
	defer func() {
		if cErr := store.Close(); cErr != nil {
			t.Logf("error closing store: %v", cErr)
		}
	}()

	studentID := uuid.New()
	assignmentID := uuid.New()

	// 1. Tạo student và assignment trong DB
	_, err = store.DB.ExecContext(ctx, `INSERT INTO students(id, name, class, cycle_start_day, created_at) VALUES(?, ?, ?, ?, ?)`,
		studentID.String(), "Học sinh A", "10A", 1, "2026-01-01T00:00:00Z")
	require.NoError(t, err)

	_, err = store.DB.ExecContext(ctx, `INSERT INTO assignments(id, student_id, title, purpose, status, assigned_at, items_json) VALUES(?, ?, ?, ?, ?, ?, ?)`,
		assignmentID.String(), studentID.String(), "Bài 1", "normal", "ASSIGNED", "2026-01-01T00:00:00Z", "[]")
	require.NoError(t, err)

	links := database.OneNoteLinks{Store: store}

	// 2. Chèn trực tiếp một link cũ dạng redir.aspx vào bảng assignment_pages
	legacyURL := "https://onedrive.live.com/redir.aspx?cid=1c22e0b2ff1dbe1b&page=edit&resid=1C22E0B2FF1DBE1B!sfcbc70e0842e4c9e9a1224633fe5f29b&parId=1C22E0B2FF1DBE1B!104&wd=target%28c2.one%7Ca74af308-1da7-4d3a-9d81-1bae26baf729%2F%C3%94n%20t%E1%BA%ADp%20ki%E1%BA%BFn%20th%E1%BB%A9c%20gi%E1%BB%AFa%20h%E1%BB%8Dc%20k%E1%BB%B3%20I%20-%20To%C3%A1n%20%7Ce642a3b0-a45e-44b5-9284-d7beb8642d49%2F%29"
	_, err = store.DB.ExecContext(ctx, `INSERT INTO assignment_pages(assignment_id, audience, account_id, page_id, page_url, notebook_id, section_id) VALUES(?, ?, ?, ?, ?, ?, ?)`,
		assignmentID.String(), "student", "ms-acc", "page-1", legacyURL, "nb-1", "sec-1")
	require.NoError(t, err)

	// 3. GetPage phải tự động chuyển thành Doc.aspx chuẩn
	page, ok, err := links.GetPage(ctx, assignmentID, "student")
	require.NoError(t, err)
	assert.True(t, ok)

	expectedURL := "https://onedrive.live.com/personal/1c22e0b2ff1dbe1b/_layouts/15/Doc.aspx?sourcedoc={fcbc70e0-842e-4c9e-9a12-24633fe5f29b}&action=edit&wd=target%28c2.one%7Ca74af308-1da7-4d3a-9d81-1bae26baf729%2F%C3%94n%20t%E1%BA%ADp%20ki%E1%BA%BFn%20th%E1%BB%A9c%20gi%E1%BB%AFa%20h%E1%BB%8Dc%20k%E1%BB%B3%20I%20-%20To%C3%A1n%20%7Ce642a3b0-a45e-44b5-9284-d7beb8642d49%2F%29&wdorigin=NavigationUrl"
	assert.Equal(t, expectedURL, page.PageURL)
}
