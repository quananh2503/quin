package gemini

// =============================================================================
// SLOT REGISTRY: ĐỘNG CƠ Ô NHỚ CON TRỎ THAY THẾ CHO @ANCHOR CHUỖI
// =============================================================================

// TextSlot là một ô nhớ đại diện cho một trường văn bản chứa công thức toán trong bộ nhớ RAM.
// Giữ con trỏ trực tiếp (*string) tới trường dữ liệu thật trong WorkerResult.
type TextSlot struct {
	ID      string  `json:"id"`      // Mã định danh ô nhớ (VD: "dang_1.drill.0.prompt")
	Context string  `json:"context"` // Ngữ cảnh sư phạm (để hướng dẫn AI sửa đúng trọng tâm)
	Value   *string `json:"-"`        // Con trỏ TRỰC TIẾP đến biến string trong WorkerResult
}

// SlotRegistry quản lý danh bạ các ô nhớ trong toàn bộ bài học.
// Cho phép cập nhật dữ liệu với độ phức tạp O(1) mà không cần switch-case hay duyệt mảng lồng nhau.
type SlotRegistry interface {
	// Register đăng ký một ô nhớ mới với con trỏ trực tiếp
	Register(id, context string, ptr *string)
	// Get lấy ô nhớ theo ID
	Get(id string) (TextSlot, bool)
	// All trả về toàn bộ ô nhớ
	All() []TextSlot
	// Update cập nhật giá trị mới trực tiếp vào ô nhớ RAM (*slot.Value = newValue)
	Update(id string, newValue string) bool
	// Size trả về tổng số ô nhớ đang quản lý
	Size() int
}

// InMemorySlotRegistry lưu trữ danh bạ ô nhớ trong RAM bằng Go map thuần túy
type InMemorySlotRegistry struct {
	slots map[string]TextSlot
}

// NewInMemorySlotRegistry khởi tạo một SlotRegistry rỗng
func NewInMemorySlotRegistry() *InMemorySlotRegistry {
	return &InMemorySlotRegistry{
		slots: make(map[string]TextSlot),
	}
}

// Register: Đăng ký một ô nhớ mới vào danh bạ kèm theo con trỏ trực tiếp tới biến RAM.
// - id: Mã định danh duy nhất (VD: "dang_1.drill.0.prompt")
// - context: Mô tả bối cảnh ngắn của trường dữ liệu (VD: "Bài tập 1 - Đề bài")
// - ptr: Con trỏ trực tiếp tới chuỗi string trong WorkerResult
func (r *InMemorySlotRegistry) Register(id, context string, ptr *string) {
	if ptr == nil {
		return
	}
	r.slots[id] = TextSlot{
		ID:      id,
		Context: context,
		Value:   ptr,
	}
}

// Get: Truy xuất TextSlot theo ID.
// - Trả về: (TextSlot, true) nếu tìm thấy, hoặc (empty, false) nếu không tồn tại.
func (r *InMemorySlotRegistry) Get(id string) (TextSlot, bool) {
	s, ok := r.slots[id]
	return s, ok
}

// All: Trả về danh sách toàn bộ các ô nhớ đang quản lý.
// Phục vụ cho MathValidator quét toàn bộ bài học trong bước Pre-Audit.
func (r *InMemorySlotRegistry) All() []TextSlot {
	list := make([]TextSlot, 0, len(r.slots))
	for _, s := range r.slots {
		list = append(list, s)
	}
	return list
}

// Update: Cập nhật giá trị mới trực tiếp vào biến bộ nhớ RAM thông qua con trỏ.
// Thao tác thực thi trong O(1), không cần switch-case hay duyệt mảng.
// - id: Mã ô nhớ cần sửa
// - newValue: Nội dung chuỗi mới đã được sửa cú pháp toán
// - Trả về: true nếu cập nhật thành công, false nếu không tìm thấy slot.
func (r *InMemorySlotRegistry) Update(id string, newValue string) bool {
	slot, ok := r.slots[id]
	if !ok || slot.Value == nil {
		return false
	}
	*slot.Value = newValue
	return true
}

// Size: Trả về tổng số ô nhớ đang được quản lý trong bài học.
func (r *InMemorySlotRegistry) Size() int {
	return len(r.slots)
}
