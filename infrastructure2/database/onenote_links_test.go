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
