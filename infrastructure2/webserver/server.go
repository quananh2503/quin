package webserver

import (
	"fmt"
	"io/fs"
	"net/http"
	"strings"
)

// SPAHandler phục vụ Single Page Application từ fs.FS.
// Nếu đường dẫn không tồn tại file tĩnh, nó sẽ trả về index.html để React Router xử lý.
type SPAHandler struct {
	fileSystem http.FileSystem
}

// NewSPAHandler tạo một SPAHandler từ fs.FS, tự động xử lý thư mục con frontend/dist nếu có
func NewSPAHandler(fileSys fs.FS) *SPAHandler {
	sub, err := fs.Sub(fileSys, "frontend/dist")
	if err == nil {
		// Thử mở index.html trong sub fs để kiểm tra tính hợp lệ
		if testFile, testErr := sub.Open("index.html"); testErr == nil {
			if closeErr := testFile.Close(); closeErr != nil {
				fmt.Printf("cảnh báo: đóng file test: %v\n", closeErr)
			}
			return &SPAHandler{fileSystem: http.FS(sub)}
		}
	}
	return &SPAHandler{fileSystem: http.FS(fileSys)}
}

// ServeHTTP phục vụ file tĩnh hoặc fallback về index.html cho client-side routing
func (h *SPAHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	path := strings.TrimPrefix(r.URL.Path, "/")
	if path == "" {
		path = "index.html"
	}

	f, err := h.fileSystem.Open(path)
	if err != nil {
		h.serveIndexHTML(w, r)
		return
	}
	defer func() {
		if closeErr := f.Close(); closeErr != nil {
			fmt.Printf("cảnh báo: đóng file tĩnh: %v\n", closeErr)
		}
	}()

	stat, statErr := f.Stat()
	if statErr != nil {
		http.Error(w, fmt.Sprintf("Lỗi đọc metadata file: %v", statErr), http.StatusInternalServerError)
		return
	}

	if stat.IsDir() {
		h.serveIndexHTML(w, r)
		return
	}

	http.ServeContent(w, r, stat.Name(), stat.ModTime(), f)
}

func (h *SPAHandler) serveIndexHTML(w http.ResponseWriter, r *http.Request) {
	indexFile, err := h.fileSystem.Open("index.html")
	if err != nil {
		http.Error(w, "index.html không tồn tại", http.StatusNotFound)
		return
	}
	defer func() {
		if closeErr := indexFile.Close(); closeErr != nil {
			fmt.Printf("cảnh báo: đóng index.html: %v\n", closeErr)
		}
	}()

	stat, statErr := indexFile.Stat()
	if statErr != nil {
		http.Error(w, fmt.Sprintf("Lỗi đọc thông tin index.html: %v", statErr), http.StatusInternalServerError)
		return
	}

	http.ServeContent(w, r, "index.html", stat.ModTime(), indexFile)
}

// SetupRoutes đăng ký các endpoint vào ServeMux
func SetupRoutes(mux *http.ServeMux, app any, assets fs.FS, pdfStreamHandler http.Handler) {
	bridge := NewBridgeHandler(app)
	mux.Handle("/api/wails/", bridge)

	if pdfStreamHandler != nil {
		mux.Handle("/pdf-stream", pdfStreamHandler)
	}

	type exportDownloader interface {
		ServeExportDownload(http.ResponseWriter, *http.Request)
	}
	if ed, ok := app.(exportDownloader); ok {
		mux.HandleFunc("/api/download/export", ed.ServeExportDownload)
	}

	if assets != nil {
		spa := NewSPAHandler(assets)
		mux.Handle("/", spa)
	}
}

// NewServer tạo một http.Server hoàn chỉnh
func NewServer(addr string, app any, assets fs.FS, pdfStreamHandler http.Handler) *http.Server {
	mux := http.NewServeMux()
	SetupRoutes(mux, app, assets, pdfStreamHandler)
	return &http.Server{
		Addr:    addr,
		Handler: mux,
	}
}
