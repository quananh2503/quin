package googlemeet

import (
	"context"
	"crypto/sha256"
	"database/sql"
	"fmt"
	"strings"
	"time"

	"uuid"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/domain2/student"
	"meet-attendance-clean/infrastructure2/database"
)

// Adapter cài đặt application2.MeetingProviderGateway
type Adapter struct {
	Client *Client
	Store  *database.SQLite
}

func NewAdapter(client *Client, store *database.SQLite) *Adapter {
	return &Adapter{
		Client: client,
		Store:  store,
	}
}

func (a *Adapter) SyncMeetings(ctx context.Context, from time.Time) (application2.MeetingSyncResult, error) {
	if a.Client == nil || a.Store == nil {
		return application2.MeetingSyncResult{}, fmt.Errorf("Google Meet adapter chưa được cấu hình đầy đủ")
	}

	meetings, err := a.Client.FetchRawMeetings(ctx, from)
	if err != nil {
		return application2.MeetingSyncResult{}, err
	}

	result := application2.MeetingSyncResult{}
	knownStudents := make(map[string]uuid.UUID) // spaceID -> studentID

	for _, meeting := range meetings {
		// Bỏ qua các buổi chưa kết thúc hoặc không có học viên tham gia
		if meeting.RecordID == "" || meeting.SpaceID == "" || meeting.EndedAt.IsZero() || len(meeting.Participants) == 0 {
			continue
		}

		studentID, ok := knownStudents[meeting.SpaceID]
		if !ok {
			var stored string
			query := `SELECT student_id FROM v2_external_student_links WHERE provider='google_meet_space' AND external_key=?`
			err := a.Store.DB.QueryRowContext(ctx, query, meeting.SpaceID).Scan(&stored)

			name := strings.TrimSpace(meeting.SpaceName)
			if name == "" {
				name = meeting.SpaceID
			}

			if err == nil {
				studentID, err = uuid.Parse(stored)
				if err != nil {
					return application2.MeetingSyncResult{}, err
				}

				// Kiểm tra nếu student bị xóa thì tái tạo lại, tránh foreign key mồ côi
				var exists int
				if err := a.Store.DB.QueryRowContext(ctx, `SELECT COUNT(1) FROM v2_students WHERE id=?`, studentID.String()).Scan(&exists); err != nil {
					return application2.MeetingSyncResult{}, err
				}
				if exists == 0 {
					created, createErr := student.NewStudentFromDiscoveredClass(name)
					if createErr != nil {
						return application2.MeetingSyncResult{}, createErr
					}
					studentID = created.ID()
					result.NewStudents = append(result.NewStudents, created)
				}
			} else if err == sql.ErrNoRows {
				created, createErr := student.NewStudentFromDiscoveredClass(name)
				if createErr != nil {
					return application2.MeetingSyncResult{}, createErr
				}
				studentID = created.ID()
				result.NewStudents = append(result.NewStudents, created)
			} else {
				return application2.MeetingSyncResult{}, err
			}

			knownStudents[meeting.SpaceID] = studentID
		}

		// Lưu / Cập nhật liên kết khóa ngoại external link
		upsertLinkQuery := `
			INSERT INTO v2_external_student_links (provider, external_key, student_id, meeting_code, space_name)
			VALUES ('google_meet_space', ?, ?, ?, ?)
			ON CONFLICT(provider, external_key) DO UPDATE SET
				meeting_code = excluded.meeting_code,
				space_name   = excluded.space_name
		`
		_, err = a.Store.DB.ExecContext(ctx, upsertLinkQuery, meeting.SpaceID, studentID.String(), meeting.MeetingCode, meeting.SpaceName)
		if err != nil {
			return application2.MeetingSyncResult{}, fmt.Errorf("lưu external link: %w", err)
		}

		// Sinh ID cố định chuẩn RFC 9562 v8 từ record ID của Google Meet
		stableID := meetingUUID(meeting.RecordID)
		session, err := student.NewClassSessionWithID(stableID, studentID, meeting.StartedAt, meeting.EndedAt)
		if err != nil {
			return application2.MeetingSyncResult{}, fmt.Errorf("tạo class session: %w", err)
		}

		for _, p := range meeting.Participants {
			if err := session.AddAttendance(p.DisplayName, p.FirstJoined, p.LastLeft, p.DurationMin); err != nil {
				return application2.MeetingSyncResult{}, fmt.Errorf("thêm điểm danh: %w", err)
			}
		}

		result.Sessions = append(result.Sessions, *session)
	}

	return result, nil
}

func meetingUUID(externalID string) uuid.UUID {
	sum := sha256.Sum256([]byte("google-meet-record:" + externalID))
	var id uuid.UUID
	copy(id[:], sum[:16])
	id[6] = (id[6] & 0x0f) | 0x80 // RFC 9562 version 8
	id[8] = (id[8] & 0x3f) | 0x80 // RFC 4122 variant
	return id
}
