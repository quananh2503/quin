package application2_test

import (
	"context"
	"os"
	"path/filepath"
	"testing"
	"uuid"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"meet-attendance-clean/application2"
)

type mockDocRepo struct {
	savedDocs map[uuid.UUID]*application2.Document
}

func newMockDocRepo() *mockDocRepo {
	return &mockDocRepo{
		savedDocs: make(map[uuid.UUID]*application2.Document),
	}
}

func (m *mockDocRepo) Save(ctx context.Context, doc *application2.Document) error {
	m.savedDocs[doc.ID] = doc
	return nil
}

func (m *mockDocRepo) GetByID(ctx context.Context, id uuid.UUID) (*application2.Document, error) {
	doc, ok := m.savedDocs[id]
	if !ok {
		return nil, os.ErrNotExist
	}
	return doc, nil
}

func (m *mockDocRepo) List(ctx context.Context) ([]application2.Document, error) {
	list := make([]application2.Document, 0, len(m.savedDocs))
	for _, doc := range m.savedDocs {
		list = append(list, *doc)
	}
	return list, nil
}

func TestUploadDocumentHandler_Upload(t *testing.T) {
	ctx := context.Background()
	storageDir := t.TempDir()
	repo := newMockDocRepo()

	handler, err := application2.NewUploadDocumentHandler(repo, storageDir)
	require.NoError(t, err)

	// Test 1: Upload file ảnh PNG từ đĩa
	tempImg := filepath.Join(t.TempDir(), "diagram.png")
	errWrite := os.WriteFile(tempImg, []byte{0x89, 'P', 'N', 'G', '\r', '\n', 0x1A, '\n'}, 0644)
	require.NoError(t, errWrite)

	doc, errUpload := handler.Upload(ctx, application2.UploadCommand{SourceFilePath: tempImg})
	require.NoError(t, errUpload)
	assert.NotNil(t, doc)
	assert.Equal(t, "diagram.png", doc.FileName)
	assert.Equal(t, 1, doc.PageCount)
	assert.FileExists(t, doc.FilePath)

	// Test 2: Upload file định dạng không hỗ trợ
	badFile := filepath.Join(t.TempDir(), "script.exe")
	errWriteBad := os.WriteFile(badFile, []byte("bad binary"), 0644)
	require.NoError(t, errWriteBad)

	_, errBad := handler.Upload(ctx, application2.UploadCommand{SourceFilePath: badFile})
	assert.Error(t, errBad)

	// Test 3: Đường dẫn rỗng
	_, errEmpty := handler.Upload(ctx, application2.UploadCommand{SourceFilePath: ""})
	assert.Error(t, errEmpty)
}

func TestUploadDocumentHandler_UploadBytes(t *testing.T) {
	ctx := context.Background()
	storageDir := t.TempDir()
	repo := newMockDocRepo()

	handler, err := application2.NewUploadDocumentHandler(repo, storageDir)
	require.NoError(t, err)

	// Test 1: Upload byte ảnh JPEG
	jpegBytes := []byte{0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10}
	doc, errBytes := handler.UploadBytes(ctx, application2.UploadBytesCommand{
		FileName: "math_problem.jpg",
		Data:     jpegBytes,
	})
	require.NoError(t, errBytes)
	assert.NotNil(t, doc)
	assert.Equal(t, "math_problem.jpg", doc.FileName)
	assert.Equal(t, 1, doc.PageCount)
	assert.FileExists(t, doc.FilePath)

	// Test 2: Upload byte file Word DOCX
	docxBytes := []byte("PK\x03\x04test docx content")
	docDocx, errDocx := handler.UploadBytes(ctx, application2.UploadBytesCommand{
		FileName: "lesson_plan.docx",
		Data:     docxBytes,
	})
	require.NoError(t, errDocx)
	assert.NotNil(t, docDocx)
	assert.Equal(t, "lesson_plan.docx", docDocx.FileName)
	assert.Equal(t, 1, docDocx.PageCount)

	// Test 3: Dữ liệu rỗng
	_, errEmptyData := handler.UploadBytes(ctx, application2.UploadBytesCommand{
		FileName: "empty.pdf",
		Data:     nil,
	})
	assert.Error(t, errEmptyData)
}
