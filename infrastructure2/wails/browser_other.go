//go:build !windows

package wails

import (
	"context"
	"fmt"
	"net/url"
	"strings"

	"github.com/wailsapp/wails/v2/pkg/runtime"
)

func openSystemBrowser(ctx context.Context, rawURL string) error {
	u, err := url.Parse(rawURL)
	if err != nil {
		return fmt.Errorf("URL không hợp lệ: %w", err)
	}
	scheme := strings.ToLower(u.Scheme)
	if scheme != "http" && scheme != "https" {
		return fmt.Errorf("chỉ hỗ trợ giao thức http hoặc https, nhận được: %s", u.Scheme)
	}

	if ctx != nil {
		runtime.BrowserOpenURL(ctx, rawURL)
	}
	return nil
}
