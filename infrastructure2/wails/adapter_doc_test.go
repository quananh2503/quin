package wails_test

import (
	"context"
	"encoding/base64"
	"os"
	"testing"
	"uuid"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/infrastructure2/wails"
)

type mockWailsDocRepo struct {
	docs map[uuid.UUID]*application2.Document
}

func newMockWailsDocRepo() *mockWailsDocRepo {
	return &mockWailsDocRepo{docs: make(map[uuid.UUID]*application2.Document)}
}

func (m *mockWailsDocRepo) Save(ctx context.Context, doc *application2.Document) error {
	m.docs[doc.ID] = doc
	return nil
}

func (m *mockWailsDocRepo) GetByID(ctx context.Context, id uuid.UUID) (*application2.Document, error) {
	doc, ok := m.docs[id]
	if !ok {
		return nil, os.ErrNotExist
	}
	return doc, nil
}

func (m *mockWailsDocRepo) List(ctx context.Context) ([]application2.Document, error) {
	var list []application2.Document
	for _, doc := range m.docs {
		list = append(list, *doc)
	}
	return list, nil
}

func TestV2SaveDocumentData(t *testing.T) {
	app := wails.NewApp(nil, nil)

	// Case 1: Services chưa khởi tạo
	_, err := app.V2SaveDocumentData("test.png", "aGVsbG8=")
	assert.Error(t, err)

	// Khởi tạo handler
	storageDir := t.TempDir()
	repo := newMockWailsDocRepo()
	uploadHandler, errNew := application2.NewUploadDocumentHandler(repo, storageDir)
	require.NoError(t, errNew)

	app.SetApplication2Services(&wails.Application2Services{
		UploadHandler: uploadHandler,
		DocRepo:       repo,
	})

	// Case 2: Dữ liệu base64 rỗng
	_, errEmpty := app.V2SaveDocumentData("test.png", "")
	assert.Error(t, errEmpty)

	// Case 3: Lưu thành công file ảnh PNG kèm prefix data URI
	pngData := []byte{0x89, 'P', 'N', 'G', '\r', '\n', 0x1A, '\n', 0x00}
	b64String := "data:image/png;base64," + base64.StdEncoding.EncodeToString(pngData)

	doc, errSave := app.V2SaveDocumentData("pasted_screenshot.png", b64String)
	require.NoError(t, errSave)
	assert.NotNil(t, doc)
	assert.Equal(t, "pasted_screenshot.png", doc.FileName)
	assert.Equal(t, 1, doc.PageCount)
	assert.FileExists(t, doc.FilePath)

	// Case 4: Tự suy luận đuôi file từ data URI khi fileName chưa có đuôi
	docInferred, errInferred := app.V2SaveDocumentData("my_photo", b64String)
	require.NoError(t, errInferred)
	assert.Equal(t, "my_photo.png", docInferred.FileName)

	// Case 5: Lỗi khi base64 không hợp lệ
	_, errInvalidB64 := app.V2SaveDocumentData("corrupted.png", "not-a-valid-base64!@#$")
	assert.Error(t, errInvalidB64)
}
