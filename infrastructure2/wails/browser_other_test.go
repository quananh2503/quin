//go:build !windows

package wails

import (
	"errors"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestApp_OpenExternalURL_Other_OneDriveURLWithSpecialChars(t *testing.T) {
	var calledCmd string
	var calledArgs []string
	origFn := execCommandFn
	defer func() { execCommandFn = origFn }()

	execCommandFn = func(name string, args ...string) error {
		calledCmd = name
		calledArgs = args
		return nil
	}

	app := &App{}

	oneNoteURL := "https://onedrive.live.com/redir.aspx?cid=1c22e0b2ff1dbe1b&page=edit&resid=1C22E0B2FF1DBE1B!s7a91e01a42d646029b79b0eb2f1c59cc&parId=1C22E0B2FF1DBE1B!104&wd=target%28t3.one%7Cfe881e43-4d42-4863-bb73-af06892cff1f%2FB%C3%A0i%204%20Ph%C6%B0%C6%A1ng%20tr%C3%ACnh%20l%C6%B0%E1%BB%A3ng%20gi%C3%A1c%20c%C6%A1%20b%E1%BA%A3n%7C44258742-5ed2-4f5b-a9ad-456033671ceb%2F%29"

	err := app.OpenExternalURL(oneNoteURL)
	require.NoError(t, err, "URL OneDrive chứa dấu '!' và '()' phải mở thành công trên Linux/macOS mà không bị Wails chặn")
	assert.NotEmpty(t, calledCmd, "Lệnh mở trình duyệt phải được gọi")
	assert.Contains(t, calledArgs, oneNoteURL, "Đối số truyền cho trình duyệt phải chứa đúng URL")
}

func TestApp_OpenExternalURL_Other_FallbackOnError(t *testing.T) {
	callCount := 0
	origFn := execCommandFn
	defer func() { execCommandFn = origFn }()

	// Giả lập lệnh đầu tiên thất bại để kích hoạt fallback
	execCommandFn = func(name string, args ...string) error {
		callCount++
		if callCount == 1 {
			return errors.New("simulated first tool failure")
		}
		return nil
	}

	app := &App{}
	testURL := "https://example.com/test"

	err := app.OpenExternalURL(testURL)
	require.NoError(t, err)
}
