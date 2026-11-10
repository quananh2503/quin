package webserver_test

import (
	"net/http"
	"net/http/httptest"
	"testing"
	"testing/fstest"

	"meet-attendance-clean/infrastructure2/webserver"
)

func TestSetupRoutes_Integration(t *testing.T) {
	app := &MockApp{}
	mockFS := fstest.MapFS{
		"frontend/dist/index.html": &fstest.MapFile{Data: []byte("<html>Mock UI</html>")},
		"frontend/dist/app.js":     &fstest.MapFile{Data: []byte("console.log('hi');")},
	}

	pdfHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/pdf")
		if _, err := w.Write([]byte("%PDF-1.4 mock")); err != nil {
			t.Errorf("Lỗi ghi PDF: %v", err)
		}
	})

	server := webserver.NewServer(":8080", app, mockFS, pdfHandler)
	mux := server.Handler

	// 1. Kiểm tra Route API
	reqAPI := httptest.NewRequest(http.MethodPost, "/api/wails/DoAction", nil)
	recAPI := httptest.NewRecorder()
	mux.ServeHTTP(recAPI, reqAPI)
	if recAPI.Code != http.StatusOK {
		t.Fatalf("API Route /api/wails/ thất bại: %d", recAPI.Code)
	}

	// 2. Kiểm tra Route PDF Stream
	reqPDF := httptest.NewRequest(http.MethodGet, "/pdf-stream", nil)
	recPDF := httptest.NewRecorder()
	mux.ServeHTTP(recPDF, reqPDF)
	if recPDF.Code != http.StatusOK {
		t.Fatalf("PDF Route /pdf-stream thất bại: %d", recPDF.Code)
	}
	if recPDF.Header().Get("Content-Type") != "application/pdf" {
		t.Fatalf("Kỳ vọng Content-Type application/pdf, nhận: %s", recPDF.Header().Get("Content-Type"))
	}

	// 3. Kiểm tra Route Static File
	reqStatic := httptest.NewRequest(http.MethodGet, "/app.js", nil)
	recStatic := httptest.NewRecorder()
	mux.ServeHTTP(recStatic, reqStatic)
	if recStatic.Code != http.StatusOK {
		t.Fatalf("Static Route /app.js thất bại: %d", recStatic.Code)
	}

	// 4. Kiểm tra Route SPA Fallback (trang không tồn tại trả về index.html)
	reqSPA := httptest.NewRequest(http.MethodGet, "/lessons/detail/123", nil)
	recSPA := httptest.NewRecorder()
	mux.ServeHTTP(recSPA, reqSPA)
	if recSPA.Code != http.StatusOK {
		t.Fatalf("SPA Fallback Route thất bại: %d", recSPA.Code)
	}
	if recSPA.Body.String() != "<html>Mock UI</html>" {
		t.Fatalf("Kỳ vọng body '<html>Mock UI</html>', nhận: %q", recSPA.Body.String())
	}
}
