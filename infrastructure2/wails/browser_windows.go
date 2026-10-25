//go:build windows

package wails

import (
	"context"
	"fmt"
	"net/url"
	"strings"

	"github.com/wailsapp/wails/v2/pkg/runtime"
	"golang.org/x/sys/windows"
)

var shellExecuteFn = func(hwnd windows.Handle, verb, file, args, dir *uint16, showCmd int32) error {
	return windows.ShellExecute(hwnd, verb, file, args, dir, showCmd)
}

func openSystemBrowser(ctx context.Context, rawURL string) error {
	u, err := url.Parse(rawURL)
	if err != nil {
		return fmt.Errorf("URL không hợp lệ: %w", err)
	}
	scheme := strings.ToLower(u.Scheme)
	if scheme != "http" && scheme != "https" {
		return fmt.Errorf("chỉ hỗ trợ giao thức http hoặc https, nhận được: %s", u.Scheme)
	}

	verbPtr, err := windows.UTF16PtrFromString("open")
	if err != nil {
		return fmt.Errorf("UTF16PtrFromString verb: %w", err)
	}
	filePtr, err := windows.UTF16PtrFromString(rawURL)
	if err != nil {
		return fmt.Errorf("UTF16PtrFromString url: %w", err)
	}

	// Sử dụng ShellExecute trực tiếp trên Windows để tránh bug của Wails runtime
	// (Wails urlValidator chặn nhầm ký tự '!' và '()' hợp lệ trong URL OneDrive/OneNote)
	err = shellExecuteFn(0, verbPtr, filePtr, nil, nil, windows.SW_SHOWNORMAL)
	if err != nil {
		if ctx != nil {
			runtime.BrowserOpenURL(ctx, rawURL)
		}
		return fmt.Errorf("ShellExecute lỗi: %w", err)
	}
	return nil
}
