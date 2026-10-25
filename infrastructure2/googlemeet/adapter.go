package googlemeet

import (
	"context"
	"crypto/sha256"
	"errors"
	"fmt"
	"strings"
	"time"

	"uuid"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/domain2/student"
)

// Storage định nghĩa toàn bộ hành vi lưu trữ mà Google Meet Adapter cần
// Tuân thủ nguyên lý Inversion of Control: Bên gọi định nghĩa interface
type Storage interface {
	FindStudentIDBySpaceID(ctx context.Context, spaceID string) (uuid.UUID, bool, error)
	SaveSpaceLink(ctx context.Context, spaceID string, studentID uuid.UUID, meetingCode, spaceName string) error
	SaveStudent(ctx context.Context, s *student.Student) error
}

type Adapter struct {
	client *Client
	store  Storage
}

func NewAdapter(client *Client, store Storage) *Adapter {
	return &Adapter{
		client: client,
		store:  store,
	}
}

func (a *Adapter) SyncMeetings(ctx context.Context, from time.Time) (application2.MeetingSyncResult, error) {
	if a.client == nil || a.store == nil {
		return application2.MeetingSyncResult{}, errors.New("Google Meet adapter chưa được cấu hình đầy đủ")
	}

	meetings, err := a.client.FetchRawMeetings(ctx, from)
	if err != nil {
		return application2.MeetingSyncResult{}, err
	}

	result := application2.MeetingSyncResult{}
	knownStudents := make(map[string]uuid.UUID)

	for _, meeting := range meetings {
		// 1. Bỏ qua cuộc gọi rác (chưa kết thúc hoặc không có ai tham gia)
		if meeting.RecordID == "" || meeting.SpaceID == "" || meeting.EndedAt.IsZero() || len(meeting.Participants) == 0 {
			continue
		}

		// 2. Tìm hoặc tự động tạo học sinh (Đã tách thành hàm phụ gọn gàng!)
		studentID, newStudent, err := a.resolveStudentID(ctx, meeting, knownStudents)
		if err != nil {
			return application2.MeetingSyncResult{}, err
		}
		if newStudent != nil {
			result.NewStudents = append(result.NewStudents, newStudent)
		}

		// 3. Tạo buổi học với ID cố định (chống trùng lặp)
		sessionID := meetingUUID(meeting.RecordID)
		session, err := student.NewClassSessionWithID(sessionID, studentID, meeting.StartedAt, meeting.EndedAt)
		if err != nil {
			return application2.MeetingSyncResult{}, fmt.Errorf("tạo class session: %w", err)
		}

		// 4. Điểm danh từng học sinh/người tham gia
		for _, p := range meeting.Participants {
			if err := session.AddAttendance(p.DisplayName, p.FirstJoined, p.LastLeft, p.DurationMin); err != nil {
				return application2.MeetingSyncResult{}, fmt.Errorf("thêm điểm danh: %w", err)
			}
		}

		result.Sessions = append(result.Sessions, *session)
	}

	return result, nil
}

// Hàm phụ: Chỉ làm đúng 1 việc là tìm học sinh từ mã phòng Google Meet
func (a *Adapter) resolveStudentID(
	ctx context.Context,
	m rawMeeting,
	cache map[string]uuid.UUID,
) (uuid.UUID, *student.Student, error) {

	// BƯỚC 1: Đã biết trong RAM rồi thì lấy ra dùng luôn (siêu nhanh)
	if studentID, ok := cache[m.SpaceID]; ok {
		return studentID, nil, nil
	}

	// BƯỚC 2: Tìm trong DB xem phòng này đã gắn cho học sinh nào chưa
	studentID, found, err := a.store.FindStudentIDBySpaceID(ctx, m.SpaceID)
	if err != nil {
		return uuid.Nil(), nil, err
	}
	if found {
		cache[m.SpaceID] = studentID
		return studentID, nil, nil // Tìm thấy rồi thì xong việc, đi về!
	}

	// BƯỚC 3: Chưa từng có -> Tự tạo học sinh mới lấy tên theo tên phòng Meet
	name := strings.TrimSpace(m.SpaceName)
	if name == "" {
		name = m.SpaceID
	}
	newStudent, err := student.NewStudentFromDiscoveredClass(name)
	if err != nil {
		return uuid.Nil(), nil, err
	}

	// BƯỚC 4: Lưu học sinh mới vào DB TRƯỚC TIÊN để thỏa mãn Foreign Key constraint của bảng external_student_links
	if err := a.store.SaveStudent(ctx, newStudent); err != nil {
		return uuid.Nil(), nil, fmt.Errorf("lưu học sinh mới cho space link: %w", err)
	}

	// BƯỚC 5: Lưu vào danh bạ và lưu vào RAM Cache cho các lần sau
	err = a.store.SaveSpaceLink(ctx, m.SpaceID, newStudent.ID(), m.MeetingCode, m.SpaceName)
	if err != nil {
		return uuid.Nil(), nil, err
	}
	cache[m.SpaceID] = newStudent.ID()

	return newStudent.ID(), newStudent, nil
}
func meetingUUID(externalID string) uuid.UUID {
	sum := sha256.Sum256([]byte("google-meet-record:" + externalID))
	var id uuid.UUID
	copy(id[:], sum[:16])
	id[6] = (id[6] & 0x0f) | 0x80 // RFC 9562 version 8
	id[8] = (id[8] & 0x3f) | 0x80 // RFC 4122 variant
	return id
}
