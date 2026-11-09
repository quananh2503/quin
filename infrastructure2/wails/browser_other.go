//go:build !windows

package wails

import (
	"context"
	"fmt"
	"log"
	"net/url"
	"os/exec"
	"runtime"
	"strings"

	"github.com/pkg/browser"
	wailsRuntime "github.com/wailsapp/wails/v2/pkg/runtime"
)

var execCommandFn = func(name string, args ...string) error {
	cmd := exec.Command(name, args...)
	if err := cmd.Start(); err != nil {
		return fmt.Errorf("khởi chạy %s thất bại: %w", name, err)
	}
	go func() {
		if waitErr := cmd.Wait(); waitErr != nil {
			log.Printf("tiến trình mở URL (%s) kết thúc: %v", name, waitErr)
		}
	}()
	return nil
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

	// Tránh bug của Wails runtime trên Linux/macOS
	// (Wails urlValidator chặn nhầm ký tự hợp lệ '!' và '()' trong URL OneDrive/OneNote)
	if runtime.GOOS == "darwin" {
		if errOpen := execCommandFn("open", rawURL); errOpen == nil {
			return nil
		}
	} else {
		// Linux & Unix-like OSes: thử tuần tự các command phổ biến
		providers := []struct {
			cmd  string
			args []string
		}{
			{cmd: "xdg-open", args: []string{rawURL}},
			{cmd: "gio", args: []string{"open", rawURL}},
			{cmd: "x-www-browser", args: []string{rawURL}},
			{cmd: "www-browser", args: []string{rawURL}},
		}

		for _, p := range providers {
			if _, lookErr := exec.LookPath(p.cmd); lookErr == nil {
				if errCmd := execCommandFn(p.cmd, p.args...); errCmd == nil {
					return nil
				}
			}
		}

		// Fallback sang pkg/browser
		if errPkg := browser.OpenURL(rawURL); errPkg == nil {
			return nil
		}
	}

	// Fallback cuối cùng sang Wails runtime nếu có context
	if ctx != nil {
		wailsRuntime.BrowserOpenURL(ctx, rawURL)
		return nil
	}

	return fmt.Errorf("không tìm thấy trình duyệt hệ thống phù hợp để mở URL")
}
