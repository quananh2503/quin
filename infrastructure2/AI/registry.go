package ai

import (
	"fmt"
	"sync"
)

// Registry quản lý tập trung và phân giải các AI Provider theo tên định danh.
type Registry struct {
	mu        sync.RWMutex
	providers map[string]Provider
}

// NewRegistry khởi tạo Registry mới.
func NewRegistry() *Registry {
	return &Registry{
		providers: make(map[string]Provider),
	}
}

// Register đăng ký một Provider vào hệ thống.
func (r *Registry) Register(p Provider) {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.providers[p.Name()] = p
}

// Get tìm Provider theo tên.
func (r *Registry) Get(name string) (Provider, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	p, ok := r.providers[name]
	if !ok {
		return nil, fmt.Errorf("không tìm thấy AI provider với tên '%s'", name)
	}
	return p, nil
}

// List trả về danh sách các tên Provider đã đăng ký.
func (r *Registry) List() []string {
	r.mu.RLock()
	defer r.mu.RUnlock()
	names := make([]string, 0, len(r.providers))
	for name := range r.providers {
		names = append(names, name)
	}
	return names
}
