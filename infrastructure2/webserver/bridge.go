package webserver

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"reflect"
	"strings"
)

// BridgeHandler ánh xạ động các HTTP POST request dạng /api/wails/{method} tới method tương ứng trên App
type BridgeHandler struct {
	target reflect.Value
}

// NewBridgeHandler tạo mới một BridgeHandler bọc quanh đối tượng app (thường là *wails.App)
func NewBridgeHandler(app any) *BridgeHandler {
	return &BridgeHandler{
		target: reflect.ValueOf(app),
	}
}

// ServeHTTP thực thi việc bóc tách JSON và invoke method qua reflection
func (h *BridgeHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusNoContent)
		return
	}

	if r.Method != http.MethodPost {
		http.Error(w, "Chỉ chấp nhận phương thức POST", http.StatusMethodNotAllowed)
		return
	}

	// Lấy tên method từ URL path: /api/wails/{methodName}
	path := strings.TrimPrefix(r.URL.Path, "/api/wails/")
	methodName := strings.TrimSpace(path)
	if methodName == "" {
		http.Error(w, "Thiếu tên phương thức trong URL", http.StatusBadRequest)
		return
	}

	method := h.target.MethodByName(methodName)
	if !method.IsValid() {
		http.Error(w, fmt.Sprintf("Không tìm thấy phương thức: %s", methodName), http.StatusNotFound)
		return
	}

	mType := method.Type()
	numIn := mType.NumIn()

	// Đọc body dạng JSON mảng [arg0, arg1, ...]
	bodyBytes, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("Lỗi đọc body: %v", err), http.StatusBadRequest)
		return
	}

	var rawArgs []json.RawMessage
	if len(bodyBytes) > 0 {
		if uErr := json.Unmarshal(bodyBytes, &rawArgs); uErr != nil {
			http.Error(w, fmt.Sprintf("Body phải là JSON mảng các tham số: %v", uErr), http.StatusBadRequest)
			return
		}
	}

	if len(rawArgs) < numIn {
		http.Error(w, fmt.Sprintf("Phương thức %s yêu cầu %d tham số, chỉ nhận được %d", methodName, numIn, len(rawArgs)), http.StatusBadRequest)
		return
	}

	inValues := make([]reflect.Value, numIn)
	for i := 0; i < numIn; i++ {
		paramType := mType.In(i)
		argPtr := reflect.New(paramType)
		if uErr := json.Unmarshal(rawArgs[i], argPtr.Interface()); uErr != nil {
			http.Error(w, fmt.Sprintf("Lỗi giải mã tham số %d (%s): %v", i, paramType.String(), uErr), http.StatusBadRequest)
			return
		}
		inValues[i] = argPtr.Elem()
	}

	outValues := method.Call(inValues)

	// Xử lý return values
	// Trường hợp 1: Phương thức chỉ trả về error
	if len(outValues) == 1 && outValues[0].Type().Implements(reflect.TypeOf((*error)(nil)).Elem()) {
		if !outValues[0].IsNil() {
			errVal := outValues[0].Interface().(error)
			http.Error(w, errVal.Error(), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		if encErr := json.NewEncoder(w).Encode(map[string]bool{"success": true}); encErr != nil {
			http.Error(w, fmt.Sprintf("Lỗi mã hóa JSON: %v", encErr), http.StatusInternalServerError)
		}
		return
	}

	// Trường hợp 2: Phương thức trả về (Result, error)
	if len(outValues) == 2 {
		if !outValues[1].IsNil() {
			errVal := outValues[1].Interface().(error)
			http.Error(w, errVal.Error(), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		if encErr := json.NewEncoder(w).Encode(outValues[0].Interface()); encErr != nil {
			http.Error(w, fmt.Sprintf("Lỗi mã hóa JSON phản hồi: %v", encErr), http.StatusInternalServerError)
		}
		return
	}

	// Trường hợp 3: Không có kết quả trả về hoặc kiểu khác
	w.Header().Set("Content-Type", "application/json")
	if encErr := json.NewEncoder(w).Encode(map[string]bool{"success": true}); encErr != nil {
		http.Error(w, fmt.Sprintf("Lỗi mã hóa JSON: %v", encErr), http.StatusInternalServerError)
	}
}
