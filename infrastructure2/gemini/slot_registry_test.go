package gemini_test

import (
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"
)

func Test_InMemorySlotRegistry_RegisterAndDirectPointerUpdate(t *testing.T) {
	registry := gemini.NewInMemorySlotRegistry()

	// Giả lập một struct chứa dữ liệu thật trong RAM
	type FakeExercise struct {
		Prompt   string
		Solution string
	}
	exercise := FakeExercise{
		Prompt:   "Tính tích vô hướng $\\vec{a} \\cdot \\vec{b}$",
		Solution: "Ta có $\\vec{a} \\cdot \\vec{b} = 10$",
	}

	// Đăng ký ô nhớ trỏ trực tiếp vào trường Prompt và Solution
	registry.Register("ex1.prompt", "Đề bài câu 1", &exercise.Prompt)
	registry.Register("ex1.solution", "Lời giải câu 1", &exercise.Solution)

	if registry.Size() != 2 {
		t.Fatalf("Kỳ vọng size = 2 nhưng có %d", registry.Size())
	}

	// Kiểm tra truy xuất
	slot, found := registry.Get("ex1.prompt")
	if !found {
		t.Fatalf("Không tìm thấy slot ex1.prompt")
	}
	if *slot.Value != exercise.Prompt {
		t.Errorf("Giá trị slot không khớp: kỳ vọng %q, được %q", exercise.Prompt, *slot.Value)
	}

	// KIỂM TRA ĐẶC TÍNH CỐT LÕI: Cập nhật qua slot.Update() phải thay đổi TRỰC TIẾP biến exercise trong RAM!
	newPrompt := "Tính tích vô hướng đã sửa: $\\vec{u} \\cdot \\vec{v} = 5$"
	updated := registry.Update("ex1.prompt", newPrompt)
	if !updated {
		t.Fatalf("Cập nhật slot thất bại")
	}

	// Biến exercise.Prompt PHẢI tự động đổi giá trị mà KHÔNG cần gán lại!
	if exercise.Prompt != newPrompt {
		t.Fatalf("LỖI CON TRỎ: Biến gốc trong RAM không đổi! Kỳ vọng %q, thực tế %q", newPrompt, exercise.Prompt)
	}

	t.Log("✅ SlotRegistry: Cập nhật O(1) qua con trỏ bộ nhớ RAM hoạt động hoàn hảo!")
}

func Test_InMemorySlotRegistry_EdgeCases(t *testing.T) {
	registry := gemini.NewInMemorySlotRegistry()

	// Đăng ký con trỏ nil
	registry.Register("nil.slot", "Bối cảnh rỗng", nil)
	if registry.Size() != 0 {
		t.Errorf("Không được phép đăng ký con trỏ nil")
	}

	// Lấy slot không tồn tại
	_, found := registry.Get("non_existent")
	if found {
		t.Errorf("Kỳ vọng không tìm thấy slot non_existent")
	}

	// Cập nhật slot không tồn tại
	if registry.Update("non_existent", "value") {
		t.Errorf("Update slot không tồn tại phải trả về false")
	}

	// Test All()
	val1 := "A"
	val2 := "B"
	registry.Register("s1", "C1", &val1)
	registry.Register("s2", "C2", &val2)

	all := registry.All()
	if len(all) != 2 {
		t.Errorf("Kỳ vọng All() trả về 2 slots nhưng có %d", len(all))
	}
}
