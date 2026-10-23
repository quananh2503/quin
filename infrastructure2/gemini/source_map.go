package gemini

// =============================================================================
// SOURCE MAP: ÁNH XẠ DÒNG MÃ TYPST -> TEXT SLOT ID (O(1) ERROR LOCATION)
// =============================================================================

// SourceMap bản đồ ánh xạ từ số dòng trong mã nguồn Typst sang TextSlot tương ứng.
// Khi Typst báo lỗi ở dòng N, lập tức tìm được TextSlot bị hỏng chỉ trong O(1).
type SourceMap interface {
	// MapLine ánh xạ một dòng trong Typst tới slotID
	MapLine(lineNum int, slotID string)
	// GetSlotIDByLine lấy slotID tương ứng với số dòng
	GetSlotIDByLine(lineNum int) (string, bool)
	// FindNearestSlotID tìm slotID gần nhất phía trước dòng lineNum (xử lý khi Typst báo lệch dòng)
	FindNearestSlotID(lineNum int) (string, bool)
}

// InMemorySourceMap quản lý bảng ánh xạ dòng Typst -> SlotID
type InMemorySourceMap struct {
	lines map[int]string
}

// NewInMemorySourceMap khởi tạo SourceMap rỗng
func NewInMemorySourceMap() *InMemorySourceMap {
	return &InMemorySourceMap{
		lines: make(map[int]string),
	}
}

// MapLine: Ghi nhận ánh xạ dòng số lineNum trong file Typst tới slotID tương ứng.
// Được gọi bởi DocumentAssembler trong quá trình duyệt render template.
// - lineNum: Số dòng trong file Typst (bắt đầu từ 1)
// - slotID: Mã định danh TextSlot nằm tại dòng đó
func (m *InMemorySourceMap) MapLine(lineNum int, slotID string) {
	m.lines[lineNum] = slotID
}

// GetSlotIDByLine: Lấy chính xác slotID tương ứng với số dòng báo lỗi từ Typst compiler.
// - lineNum: Dòng báo lỗi trong stderr của Typst
// - Trả về: (slotID, true) nếu dòng này khớp trực tiếp với ô nhớ.
func (m *InMemorySourceMap) GetSlotIDByLine(lineNum int) (string, bool) {
	id, ok := m.lines[lineNum]
	return id, ok
}

// FindNearestSlotID: Tìm slotID gần nhất phía trước dòng lineNum.
// Giải quyết trường hợp Typst compiler báo lỗi lệch vài dòng do ngắt dòng hoặc khoảng trắng.
// - lineNum: Dòng báo lỗi từ Typst
// - Trả về: slotID gần nhất duyệt giật lùi từ lineNum về 1.
func (m *InMemorySourceMap) FindNearestSlotID(lineNum int) (string, bool) {
	for i := lineNum; i >= 1; i-- {
		if id, ok := m.lines[i]; ok {
			return id, true
		}
	}
	return "", false
}
