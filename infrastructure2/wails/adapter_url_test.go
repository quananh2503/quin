package wails

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"golang.org/x/sys/windows"
)

func TestApp_OpenExternalURL_EmptyURL(t *testing.T) {
	app := &App{}

	err := app.OpenExternalURL("")
	assert.Error(t, err)

	err = app.OpenExternalURL("   \t\n  ")
	assert.Error(t, err)
}

func TestApp_OpenExternalURL_InvalidScheme(t *testing.T) {
	app := &App{}

	err := app.OpenExternalURL("javascript:alert(1)")
	assert.Error(t, err)

	err = app.OpenExternalURL("file:///C:/secret.txt")
	assert.Error(t, err)
}

func TestApp_OpenExternalURL_OneDriveURLWithSpecialChars(t *testing.T) {
	// Mock shellExecuteFn để không mở cửa sổ browser thật khi test
	var calledWithURL string
	origFn := shellExecuteFn
	defer func() { shellExecuteFn = origFn }()

	shellExecuteFn = func(hwnd windows.Handle, verb, file, args, dir *uint16, showCmd int32) error {
		calledWithURL = windows.UTF16PtrToString(file)
		return nil
	}

	app := &App{}

	oneNoteURL := "https://onedrive.live.com/redir.aspx?cid=1c22e0b2ff1dbe1b&page=edit&resid=1C22E0B2FF1DBE1B!s7a91e01a42d646029b79b0eb2f1c59cc&parId=1C22E0B2FF1DBE1B!104&wd=target%28t3.one%7Cfe881e43-4d42-4863-bb73-af06892cff1f%2FB%C3%A0i%204%20Ph%C6%B0%C6%A1ng%20tr%C3%ACnh%20l%C6%B0%E1%BB%A3ng%20gi%C3%A1c%20c%C6%A1%20b%E1%BA%A3n%7C44258742-5ed2-4f5b-a9ad-456033671ceb%2F%29"

	err := app.OpenExternalURL(oneNoteURL)
	require.NoError(t, err, "URL OneDrive chứa dấu '!' và '()' không được bị Wails chặn lỗi shell metacharacters")
	assert.Equal(t, oneNoteURL, calledWithURL)
}

