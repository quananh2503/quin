package gemini_test

import (
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"
)

func Test_InMemorySourceMap_MappingAndLookup(t *testing.T) {
	sm := gemini.NewInMemorySourceMap()

	// Đăng ký các dòng Typst tương ứng với các slotID
	sm.MapLine(10, "dang_1.theory.0")
	sm.MapLine(15, "dang_1.sa.0.prompt")
	sm.MapLine(22, "dang_1.drill.1.solution")

	// 1. Kiểm tra tra cứu chính xác theo dòng
	id, ok := sm.GetSlotIDByLine(15)
	if !ok || id != "dang_1.sa.0.prompt" {
		t.Errorf("GetSlotIDByLine(15) = (%q, %v), kỳ vọng ('dang_1.sa.0.prompt', true)", id, ok)
	}

	// 2. Dòng không có ánh xạ trực tiếp
	_, ok = sm.GetSlotIDByLine(16)
	if ok {
		t.Errorf("GetSlotIDByLine(16) kỳ vọng false vì dòng 16 là dòng trống/closing tag")
	}

	// 3. Kiểm tra FindNearestSlotID khi Typst báo lỗi lệch dòng (ví dụ báo lỗi ở dòng 18 do ngắt dòng)
	nearestID, found := sm.FindNearestSlotID(18)
	if !found || nearestID != "dang_1.sa.0.prompt" {
		t.Errorf("FindNearestSlotID(18) = (%q, %v), kỳ vọng ('dang_1.sa.0.prompt', true)", nearestID, found)
	}

	// 4. Quét trước dòng đầu tiên (dòng 5 < 10)
	_, foundBefore := sm.FindNearestSlotID(5)
	if foundBefore {
		t.Errorf("FindNearestSlotID(5) không được tìm thấy vì trước dòng 10 chưa có slot nào")
	}

	t.Log("✅ SourceMap: Ánh xạ dòng và tìm kiếm ngược khi lệch dòng hoạt động chuẩn xác!")
}
