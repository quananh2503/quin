package webserver_test

import (
	"bytes"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"meet-attendance-clean/infrastructure2/webserver"
)

type MockApp struct{}

type SampleRequest struct {
	Name string `json:"name"`
	Age  int    `json:"age"`
}

type SampleResponse struct {
	Greeting string `json:"greeting"`
}

func (m *MockApp) Greet(req SampleRequest) (SampleResponse, error) {
	if req.Name == "" {
		return SampleResponse{}, errors.New("tên không được để trống")
	}
	return SampleResponse{Greeting: "Xin chào " + req.Name}, nil
}

func (m *MockApp) DoAction() error {
	return nil
}

func (m *MockApp) FailAction() error {
	return errors.New("hành động thất bại")
}

func TestBridgeHandler_Success(t *testing.T) {
	app := &MockApp{}
	handler := webserver.NewBridgeHandler(app)

	reqBody, err := json.Marshal([]any{SampleRequest{Name: "Nam", Age: 25}})
	if err != nil {
		t.Fatalf("Lỗi tạo json request: %v", err)
	}

	req := httptest.NewRequest(http.MethodPost, "/api/wails/Greet", bytes.NewReader(reqBody))
	rec := httptest.NewRecorder()

	handler.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Fatalf("Kỳ vọng status 200, nhận: %d - body: %s", rec.Code, rec.Body.String())
	}

	var res SampleResponse
	if err := json.NewDecoder(rec.Body).Decode(&res); err != nil {
		t.Fatalf("Lỗi giải mã response: %v", err)
	}

	if res.Greeting != "Xin chào Nam" {
		t.Fatalf("Kỳ vọng 'Xin chào Nam', nhận: %q", res.Greeting)
	}
}

func TestBridgeHandler_ErrorOnlySuccess(t *testing.T) {
	app := &MockApp{}
	handler := webserver.NewBridgeHandler(app)

	req := httptest.NewRequest(http.MethodPost, "/api/wails/DoAction", bytes.NewReader([]byte("[]")))
	rec := httptest.NewRecorder()

	handler.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Fatalf("Kỳ vọng status 200, nhận: %d", rec.Code)
	}
}

func TestBridgeHandler_MethodFailure(t *testing.T) {
	app := &MockApp{}
	handler := webserver.NewBridgeHandler(app)

	req := httptest.NewRequest(http.MethodPost, "/api/wails/FailAction", bytes.NewReader([]byte("[]")))
	rec := httptest.NewRecorder()

	handler.ServeHTTP(rec, req)

	if rec.Code != http.StatusInternalServerError {
		t.Fatalf("Kỳ vọng status 500, nhận: %d", rec.Code)
	}
}

func TestBridgeHandler_MethodNotFound(t *testing.T) {
	app := &MockApp{}
	handler := webserver.NewBridgeHandler(app)

	req := httptest.NewRequest(http.MethodPost, "/api/wails/NonExistent", bytes.NewReader([]byte("[]")))
	rec := httptest.NewRecorder()

	handler.ServeHTTP(rec, req)

	if rec.Code != http.StatusNotFound {
		t.Fatalf("Kỳ vọng status 404, nhận: %d", rec.Code)
	}
}

func TestBridgeHandler_MethodNotAllowed(t *testing.T) {
	app := &MockApp{}
	handler := webserver.NewBridgeHandler(app)

	req := httptest.NewRequest(http.MethodGet, "/api/wails/Greet", nil)
	rec := httptest.NewRecorder()

	handler.ServeHTTP(rec, req)

	if rec.Code != http.StatusMethodNotAllowed {
		t.Fatalf("Kỳ vọng status 405, nhận: %d", rec.Code)
	}
}

func TestBridgeHandler_CORS(t *testing.T) {
	app := &MockApp{}
	handler := webserver.NewBridgeHandler(app)

	req := httptest.NewRequest(http.MethodOptions, "/api/wails/Greet", nil)
	rec := httptest.NewRecorder()

	handler.ServeHTTP(rec, req)

	if rec.Code != http.StatusNoContent {
		t.Fatalf("Kỳ vọng status 204 cho OPTIONS, nhận: %d", rec.Code)
	}
}
