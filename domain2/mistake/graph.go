package mistake

import (
	"errors"
	"uuid"
)

// AGGREGATE ROOT: Toàn bộ hồ sơ lỗ hổng kiến thức của một học sinh
type MistakeGraph struct {
	studentID uuid.UUID
	roots     []*Mistake // Danh sách các lỗi gốc (Depth 0)
}

func NewMistakeGraph(studentID uuid.UUID) *MistakeGraph {
	return &MistakeGraph{
		studentID: studentID,
		roots:     make([]*Mistake, 0),
	}
}
func ReconstituteMistakeGraph(studentID uuid.UUID, roots []*Mistake) *MistakeGraph {
	return &MistakeGraph{studentID: studentID, roots: append([]*Mistake(nil), roots...)}
}

func (g *MistakeGraph) StudentID() uuid.UUID {
	return g.studentID
}
func (g *MistakeGraph) Roots() []*Mistake {
	copied := make([]*Mistake, len(g.roots))
	copy(copied, g.roots)
	return copied
}

// func (g *MistakeGraph) Roots() []*Mistake {

// }

// Hành vi 1: Thêm một lỗi mới vào cây
// Nếu parentID == nil -> Đây là lỗi gốc, gắn vào roots.
// Nếu parentID != nil -> Tìm nút cha trên cây, và nhét vào children của cha!
func (g *MistakeGraph) RegisterMistake(parentID *uuid.UUID, topic, reason string, assignmentItemID uuid.UUID) (*Mistake, error) {
	newNode := newMistake(topic, reason, assignmentItemID)

	// Trường hợp 1: Lỗi gốc (Tầng 0)
	if parentID == nil {
		g.roots = append(g.roots, newNode)
		return newNode, nil
	}

	// Trường hợp 2: Lỗi con đẻ ra từ lỗi cha
	parentNode := g.findNode(*parentID)
	if parentNode == nil {
		return nil, errors.New("không tìm thấy lỗi cha trong phả hệ tri thức của học sinh")
	}

	// Nhét trực tiếp vào mảng con của cha (Cấu trúc cây tự nhiên)
	parentNode.children = append(parentNode.children, newNode)
	return newNode, nil
}
func (g *MistakeGraph) StartRemediation(mistakeID uuid.UUID) error {
	node := g.findNode(mistakeID)
	if node == nil {
		return errors.New("lỗi không tồn tại trong hệ thống")
	}

	// Ủy quyền cho chính nút đó tự kiểm tra luật đệ quy CanStartRemediation()!
	return node.StartRemediation()

}

// Hành vi 2: Giải quyết một lỗi
func (g *MistakeGraph) Resolve(mistakeID uuid.UUID) error {
	node := g.findNode(mistakeID)
	if node == nil {
		return errors.New("lỗi không tồn tại trong hệ thống")
	}

	// Ủy quyền cho chính nút đó tự kiểm tra luật đệ quy CanResolve()!
	return node.Reslove()
}

// Hàm duyệt cây tìm kiếm một Node theo ID
func (g *MistakeGraph) findNode(id uuid.UUID) *Mistake {
	for _, root := range g.roots {
		if found := searchTree(root, id); found != nil {
			return found
		}
	}
	return nil
}

func searchTree(current *Mistake, id uuid.UUID) *Mistake {
	if current.id == id {
		return current
	}
	for _, child := range current.children {
		if found := searchTree(child, id); found != nil {
			return found
		}
	}
	return nil
}

// func (m *Mistake)
// Trong MistakeGraph:
// Lấy toàn bộ chuỗi phả hệ từ Gốc đến Ngọn của một lỗi cụ thể
// func (g *MistakeGraph) GetAncestryPath(targetMistakeID uuid.UUID) ([]*Mistake, error) {
// 	for _, root := range g.roots {
// 		var path []*Mistake
// 		if findPath(root, targetMistakeID, &path) {
// 			return path, nil
// 		}
// 	}
// 	return nil, errors.New("không tìm thấy lỗi sai trong phả hệ tri thức của học sinh")
// }

// Thuật toán đệ quy tìm đường đi trên cây
func findPath(current *Mistake, targetID uuid.UUID, path *[]*Mistake) bool {
	// 1. Thêm nút hiện tại vào chuỗi
	*path = append(*path, current)

	// 2. Nếu đã tới đích -> Thành công!
	if current.id == targetID {
		return true
	}

	// 3. Rẽ nhánh tìm tiếp ở các nút con
	for _, child := range current.children {
		if findPath(child, targetID, path) {
			return true
		}
	}

	// 4. Backtrack: Nếu nhánh này không dẫn tới đích thì gỡ ra
	*path = (*path)[:len(*path)-1]
	return false
}

type MistakePathItem struct {
	id     uuid.UUID
	topic  string
	reason string
	status MistakeStatus
}

func (m MistakePathItem) ID() uuid.UUID         { return m.id }
func (m MistakePathItem) Topic() string         { return m.topic }
func (m MistakePathItem) Reason() string        { return m.reason }
func (m MistakePathItem) Status() MistakeStatus { return m.status }
func (g *MistakeGraph) GetAncestryPath(
	targetID uuid.UUID,
) ([]MistakePathItem, error) {
	// tìm [] *Mistake bằng đệ quy như hiện tại

	path, err := g.getAncestryPathInternal(targetID)
	if err != nil {
		return nil, err
	}

	// Chuyển đổi [] *Mistake thành [] MistakePathItem
	result := make([]MistakePathItem, len(path))
	for i, node := range path {
		result[i] = MistakePathItem{
			id:     node.id,
			topic:  node.topic,
			reason: node.reason,
			status: node.status,
		}
	}

	return result, nil
}
func (g *MistakeGraph) getAncestryPathInternal(targetID uuid.UUID) ([]*Mistake, error) {
	for _, root := range g.roots {
		var path []*Mistake
		if findPath(root, targetID, &path) {
			return path, nil
		}
	}
	return nil, errors.New("không tìm thấy lỗi sai trong phả hệ tri thức của học sinh")
}
