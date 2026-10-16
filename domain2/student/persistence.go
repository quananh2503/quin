package student

import (
	"errors"
	"strings"
	"time"
	"uuid"
)

// ReconstituteStudent restores an existing identity without running a creation workflow.
func ReconstituteStudent(id uuid.UUID, name, class string, cycleStartDay int, createdAt time.Time) (*Student, error) {
	if id == uuid.Nil() || strings.TrimSpace(name) == "" || strings.TrimSpace(class) == "" || cycleStartDay < 1 || cycleStartDay > 31 || createdAt.IsZero() {
		return nil, errors.New("dữ liệu học sinh lưu trữ không hợp lệ")
	}
	return &Student{id: id, name: name, class: class, cycleStartDay: cycleStartDay, createdAt: createdAt}, nil
}

func ReconstituteAttendanceRecord(name string, firstJoinedAt, lastLeaveAt time.Time, durationMin int) (AttendanceRecord, error) {
	if strings.TrimSpace(name) == "" || firstJoinedAt.IsZero() || lastLeaveAt.Before(firstJoinedAt) || durationMin < 0 {
		return AttendanceRecord{}, errors.New("dữ liệu điểm danh lưu trữ không hợp lệ")
	}
	return newAttendanceRecord(name, firstJoinedAt, lastLeaveAt, durationMin), nil
}
