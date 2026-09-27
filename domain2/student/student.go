package student

import (
	"errors"
	"fmt"
	"strings"
	"time"
	"uuid"
)

type Student struct {
	id    uuid.UUID
	name  string
	class string

	cycleStartDay int
	createdAt     time.Time
}

func (s *Student) ID() uuid.UUID {
	return s.id
}
func (s *Student) Name() string {
	return s.name
}
func (s *Student) Class() string {
	return s.class
}

func (s *Student) CycleStartDay() int {
	return s.cycleStartDay
}
func (s *Student) CreatedAt() time.Time {
	return s.createdAt
}
func (s *Student) UpdateInfo(name string, cycleStartDay int) error {
	name = strings.TrimSpace(name)
	if name == "" {
		return errors.New("tên học sinh không được để trống")
	}
	if cycleStartDay < 1 || cycleStartDay > 31 {
		return errors.New("ngày chu kỳ học phí phải từ ngày 1 đến ngày 31")
	}
	s.name = name
	s.cycleStartDay = cycleStartDay
	return nil
}
func (s *Student) StudentID() uuid.UUID {
	return s.id
}
func NewStudent(name, class string, cycleStartDay int) (*Student, error) {
	name = strings.TrimSpace(name)
	if name == "" {
		return nil, errors.New("tên học sinh không được để trống")
	}

	class = strings.TrimSpace(class)
	if class == "" {
		return nil, errors.New("lớp học không được để trống")
	}

	if cycleStartDay < 1 || cycleStartDay > 31 {
		return nil, errors.New("ngày chu kỳ học phí phải từ ngày 1 đến ngày 31")
	}

	return &Student{
		id:            uuid.New(),
		name:          name,
		class:         class,
		cycleStartDay: cycleStartDay,
		createdAt:     time.Now().UTC(),
	}, nil
}
func NewStudentFromDiscoveredClass(name string) (*Student, error) {
	name = strings.TrimSpace(name)
	if name == "" {
		name = "Học sinh mới"
	}

	// 👉 ĐÂY LÀ QUY TẮC NGHIỆP VỤ: Đặt tên mặc định và chu kỳ học phí
	defaultStudentName := fmt.Sprintf("%s", name)
	defaultCycleDay := 1 // Ngày 1 đầu tháng tính học phí

	return &Student{
		id:            uuid.New(),
		name:          defaultStudentName,
		class:         name,
		cycleStartDay: defaultCycleDay,
		createdAt:     time.Now().UTC(),
	}, nil
}
