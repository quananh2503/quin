package mistake

import (
	"errors"
	"time"
	"uuid"
)

type NodeState struct {
	ID               uuid.UUID
	Topic            string
	Reason           string
	AssignmentItemID uuid.UUID
	CreatedAt        time.Time
	ResolvedAt       *time.Time
	Status           MistakeStatus
	Children         []NodeState
}

func (g *MistakeGraph) Roots() []NodeState {
	result := make([]NodeState, len(g.roots))
	for i, root := range g.roots {
		result[i] = root.state()
	}
	return result
}

func (m *Mistake) state() NodeState {
	state := NodeState{ID: m.id, Topic: m.topic, Reason: m.reason, AssignmentItemID: m.assignmentItemID, CreatedAt: m.createdAt, Status: m.status, Children: make([]NodeState, len(m.children))}
	if m.resolvedAt != nil {
		v := *m.resolvedAt
		state.ResolvedAt = &v
	}
	for i, child := range m.children {
		state.Children[i] = child.state()
	}
	return state
}

func ReconstituteGraph(id, studentID uuid.UUID, roots []NodeState) (*MistakeGraph, error) {
	if id == uuid.Nil() || studentID == uuid.Nil() {
		return nil, errors.New("mistake graph lưu trữ thiếu ID")
	}
	g := &MistakeGraph{id: id, studentID: studentID, roots: make([]*Mistake, 0, len(roots))}
	seen := make(map[uuid.UUID]bool)
	for _, state := range roots {
		root, err := reconstituteNode(state, seen)
		if err != nil {
			return nil, err
		}
		g.roots = append(g.roots, root)
	}
	return g, nil
}

func reconstituteNode(state NodeState, seen map[uuid.UUID]bool) (*Mistake, error) {
	if state.ID == uuid.Nil() || state.AssignmentItemID == uuid.Nil() || seen[state.ID] || state.CreatedAt.IsZero() {
		return nil, errors.New("mistake node lưu trữ không hợp lệ hoặc trùng ID")
	}
	if state.Status != MistakeStatusDetected && state.Status != MistakeStatusRemediating && state.Status != MistakeStatusResolved {
		return nil, errors.New("trạng thái mistake lưu trữ không hợp lệ")
	}
	seen[state.ID] = true
	m := &Mistake{id: state.ID, topic: state.Topic, reason: state.Reason, assignmentItemID: state.AssignmentItemID, createdAt: state.CreatedAt, status: state.Status, children: make([]*Mistake, 0, len(state.Children))}
	if state.ResolvedAt != nil {
		v := *state.ResolvedAt
		m.resolvedAt = &v
	}
	for _, childState := range state.Children {
		child, err := reconstituteNode(childState, seen)
		if err != nil {
			return nil, err
		}
		m.children = append(m.children, child)
	}
	return m, nil
}
