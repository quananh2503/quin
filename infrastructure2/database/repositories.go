package database

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"time"
	"uuid"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/domain2/assignment"
	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/domain2/mistake"
	"meet-attendance-clean/domain2/student"
	"meet-attendance-clean/infrastructure2/database/dbgen"
)

type Students struct{ Store *SQLite }
type Sessions struct{ Store *SQLite }
type Drafts struct{ Store *SQLite }
type Lessons struct{ Store *SQLite }
type Assignments struct{ Store *SQLite }
type Graphs struct{ Store *SQLite }
type Documents struct{ Store *SQLite }

// Helper xử lý NullString cho sqlc
func toNullString(s *string) sql.NullString {
	if s == nil || *s == "" {
		return sql.NullString{}
	}
	return sql.NullString{String: *s, Valid: true}
}

// -----------------------------------------------------------------------------
// DRAFTS
// -----------------------------------------------------------------------------

func (r Drafts) RecoverInterrupted(ctx context.Context) error {
	q := dbgen.New(r.Store.DB)
	return q.RecoverInterruptedDrafts(ctx, dbgen.RecoverInterruptedDraftsParams{
		UpdatedAt: toNullString(ptrString(timeText(time.Now().UTC()))),
		ErrorText: toNullString(ptrString("tác vụ bị gián đoạn khi ứng dụng dừng")),
	})
}

func (r Drafts) Save(ctx context.Context, value *lesson.LessonDraft) error {
	if value == nil {
		return errors.New("lesson draft không được nil")
	}

	// 1. Tận dụng encodeLessonDraft có sẵn
	rec, err := encodeLessonDraft(value)
	if err != nil {
		return fmt.Errorf("encode lesson draft: %w", err)
	}

	titleJSON, err := json.Marshal(rec.Title)
	if err != nil {
		return err
	}
	materialsJSON, err := json.Marshal(rec.Materials)
	if err != nil {
		return err
	}

	var lessonJSONStr *string
	if rec.Lesson != nil {
		raw, err := json.Marshal(rec.Lesson)
		if err != nil {
			return err
		}
		s := string(raw)
		lessonJSONStr = &s
	}

	var updatedAtStr *string
	if rec.UpdatedAt != nil {
		s := timeText(*rec.UpdatedAt)
		updatedAtStr = &s
	}

	tx, err := r.Store.DB.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	q := dbgen.New(tx)

	// 2. Gọi sqlc với struct có tên trường rõ ràng
	err = q.UpsertDraft(ctx, dbgen.UpsertDraftParams{
		ID:           rec.Id.String(),
		Title:        string(titleJSON),
		Model:        rec.Model,
		Prompt:       rec.Prompt,
		Status:       rec.Status,
		MaterialJson: string(materialsJSON),
		LessonJson:   toNullString(lessonJSONStr),
		CreatedAt:    timeText(rec.CreatedAt),
		UpdatedAt:    toNullString(updatedAtStr),
		ErrorText:    toNullString(rec.ErrorString),
	})
	if err != nil {
		return err
	}

	if lessonJSONStr != nil && value.Lesson() != nil {
		err = q.UpsertLesson(ctx, dbgen.UpsertLessonParams{
			ID:         value.Lesson().ID().String(),
			DraftID:    value.ID().String(),
			LessonJson: *lessonJSONStr,
		})
		if err != nil {
			return err
		}
	}

	return tx.Commit()
}

func (r Drafts) GetByID(ctx context.Context, id uuid.UUID) (*lesson.LessonDraft, error) {
	q := dbgen.New(r.Store.DB)
	row, err := q.GetDraftByID(ctx, id.String())
	if err != nil {
		return nil, missing(err, "lesson draft")
	}

	// 1. Phục hồi Title
	var titleRec contentRecord
	var title sharekernel.Content
	if err := json.Unmarshal([]byte(row.Title), &titleRec); err == nil && len(titleRec.InlineParts) > 0 {
		title = decodeContent(titleRec)
	} else {
		title = sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: row.Title})
	}

	// 2. Phục hồi Material
	var materialsData []materialRecord
	if err := json.Unmarshal([]byte(row.MaterialJson), &materialsData); err != nil {
		return nil, fmt.Errorf("unmarshal material_json: %w", err)
	}
	materials := make([]lesson.StudyMaterial, 0, len(materialsData))
	for _, materialData := range materialsData {
		material, err := decodeMaterial(materialData)
		if err != nil {
			return nil, fmt.Errorf("decode material: %w", err)
		}
		materials = append(materials, material)
	}

	// 3. Phục hồi thời gian
	createdAt, err := parseTime(row.CreatedAt)
	if err != nil {
		return nil, err
	}
	var updatedAt *time.Time
	if row.UpdatedAt.Valid {
		v, err := parseTime(row.UpdatedAt.String)
		if err != nil {
			return nil, err
		}
		updatedAt = &v
	}

	var cause *string
	if row.ErrorText.Valid {
		cause = &row.ErrorText.String
	}

	var content *lesson.Lesson
	if row.LessonJson.Valid && len(row.LessonJson.String) > 0 {
		content, err = decodeLesson([]byte(row.LessonJson.String))
		if err != nil {
			return nil, fmt.Errorf("đọc nội dung lesson draft: %w", err)
		}
	}

	return lesson.ReconstituteLessonDraft(
		id, title, row.Model, row.Prompt,
		lesson.LessonDraftStatus(row.Status),
		materials, createdAt, updatedAt, cause, content,
	)
}

// -----------------------------------------------------------------------------
// STUDENTS & SESSIONS
// -----------------------------------------------------------------------------

func (r Students) GetByID(ctx context.Context, id uuid.UUID) (*student.Student, error) {
	q := dbgen.New(r.Store.DB)
	row, err := q.GetStudentByID(ctx, id.String())
	if err != nil {
		return nil, missing(err, "student")
	}
	createdAt, err := parseTime(row.CreatedAt)
	if err != nil {
		return nil, err
	}
	return student.ReconstituteStudent(id, row.Name, row.Class, int(row.CycleStartDay), createdAt)
}

func (r Students) Save(ctx context.Context, value *student.Student) error {
	if value == nil {
		return errors.New("student không được nil")
	}
	q := dbgen.New(r.Store.DB)
	return q.UpsertStudent(ctx, dbgen.UpsertStudentParams{
		ID:            value.ID().String(),
		Name:          value.Name(),
		Class:         value.Class(),
		CycleStartDay: int64(value.CycleStartDay()),
		CreatedAt:     timeText(value.CreatedAt()),
	})
}

func (r Students) SaveBatch(ctx context.Context, values []*student.Student) error {
	tx, err := r.Store.DB.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	q := dbgen.New(tx)
	for _, value := range values {
		if value == nil {
			return errors.New("student batch chứa nil")
		}
		err := q.UpsertStudent(ctx, dbgen.UpsertStudentParams{
			ID:            value.ID().String(),
			Name:          value.Name(),
			Class:         value.Class(),
			CycleStartDay: int64(value.CycleStartDay()),
			CreatedAt:     timeText(value.CreatedAt()),
		})
		if err != nil {
			return err
		}
	}
	return tx.Commit()
}

type attendanceRecord struct {
	Name     string    `json:"name"`
	JoinedAt time.Time `json:"joined_at"`
	LeftAt   time.Time `json:"left_at"`
	Minutes  int       `json:"minutes"`
}

func (r Sessions) SaveBatch(ctx context.Context, values []student.ClassSession) error {
	tx, err := r.Store.DB.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	q := dbgen.New(tx)
	for _, session := range values {
		records := make([]attendanceRecord, 0, len(session.Attendance()))
		for _, a := range session.Attendance() {
			records = append(records, attendanceRecord{
				Name:     a.StudentName(),
				JoinedAt: a.FirstJoinedAt(),
				LeftAt:   a.LastLeaveAt(),
				Minutes:  a.DurationMin(),
			})
		}
		encoded, err := json.Marshal(records)
		if err != nil {
			return err
		}

		err = q.UpsertClassSession(ctx, dbgen.UpsertClassSessionParams{
			ID:             session.ID().String(),
			StudentID:      session.StudentID().String(),
			StartAt:        timeText(session.StartTime()),
			EndAt:          timeText(session.EndTime()),
			AttendanceJson: string(encoded),
		})
		if err != nil {
			return err
		}
	}
	return tx.Commit()
}

// -----------------------------------------------------------------------------
// LESSONS
// -----------------------------------------------------------------------------

func (r Lessons) GetByID(ctx context.Context, id uuid.UUID) (*lesson.Lesson, error) {
	q := dbgen.New(r.Store.DB)
	raw, err := q.GetLessonByID(ctx, id.String())
	if err != nil {
		return nil, missing(err, "lesson")
	}
	return decodeLesson([]byte(raw))
}

// -----------------------------------------------------------------------------
// ASSIGNMENTS
// -----------------------------------------------------------------------------

func (r Assignments) Save(ctx context.Context, value *assignment.Assignment) error {
	if value == nil {
		return errors.New("assignment không được nil")
	}
	items, err := encodeItems(value.Items())
	if err != nil {
		return err
	}

	var purpose string
	var mistakeID sql.NullString
	switch v := value.Purpose().(type) {
	case assignment.AssignmentPurposeNormal:
		purpose = "normal"
	case assignment.AssignmentPurposeRemediation:
		purpose = "remediation"
		mistakeID = sql.NullString{String: v.MistakeID().String(), Valid: true}
	default:
		return errors.New("assignment purpose không hợp lệ")
	}

	q := dbgen.New(r.Store.DB)
	return q.UpsertAssignment(ctx, dbgen.UpsertAssignmentParams{
		ID:              value.ID().String(),
		StudentID:       value.StudentID().String(),
		Title:           value.Title(),
		Purpose:         purpose,
		OriginMistakeID: mistakeID,
		Status:          string(value.Status()),
		AssignedAt:      timeText(value.AssignedAt()),
		ItemsJson:       string(items),
	})
}

func (r Assignments) GetByID(ctx context.Context, id uuid.UUID) (*assignment.Assignment, error) {
	q := dbgen.New(r.Store.DB)
	row, err := q.GetAssignmentByID(ctx, id.String())
	if err != nil {
		return nil, missing(err, "assignment")
	}

	studentID, err := parseID(row.StudentID)
	if err != nil {
		return nil, err
	}
	assignedAt, err := parseTime(row.AssignedAt)
	if err != nil {
		return nil, err
	}
	items, err := decodeItems([]byte(row.ItemsJson))
	if err != nil {
		return nil, fmt.Errorf("đọc assignment items: %w", err)
	}

	var purpose assignment.AssignmentPurpose
	switch row.Purpose {
	case "normal":
		purpose = assignment.AssignmentPurposeNormal{}
	case "remediation":
		if !row.OriginMistakeID.Valid {
			return nil, errors.New("remediation assignment thiếu mistake ID")
		}
		mID, err := parseID(row.OriginMistakeID.String)
		if err != nil {
			return nil, err
		}
		purpose, err = assignment.NewRemediationPurpose(mID)
		if err != nil {
			return nil, err
		}
	default:
		return nil, errors.New("assignment purpose lưu trữ không hợp lệ")
	}

	return assignment.ReconstituteAssignment(id, studentID, row.Title, purpose, assignment.AssignmentStatus(row.Status), assignedAt, items)
}

// -----------------------------------------------------------------------------
// MISTAKE GRAPHS
// -----------------------------------------------------------------------------

func (r Graphs) Save(ctx context.Context, value *mistake.MistakeGraph) error {
	if value == nil {
		return errors.New("mistake graph không được nil")
	}
	records, err := encodeMistakeGraph(value)
	if err != nil {
		return err
	}

	tx, err := r.Store.DB.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	q := dbgen.New(tx)
	if err = q.DeleteMistakesByStudentID(ctx, value.StudentID().String()); err != nil {
		return err
	}

	for _, record := range records {
		var parentID sql.NullString
		if record.ParentID != nil {
			parentID = sql.NullString{String: record.ParentID.String(), Valid: true}
		}
		var resolvedAt sql.NullString
		if record.ResolvedAt != nil {
			resolvedAt = sql.NullString{String: timeText(*record.ResolvedAt), Valid: true}
		}

		err = q.InsertMistake(ctx, dbgen.InsertMistakeParams{
			ID:               record.ID.String(),
			StudentID:        record.StudentID.String(),
			ParentID:         parentID,
			Topic:            record.Topic,
			Reason:           record.Reason,
			AssignmentItemID: record.AssignmentItemID.String(),
			Status:           record.Status,
			CreatedAt:        timeText(record.CreatedAt),
			ResolvedAt:       resolvedAt,
		})
		if err != nil {
			return err
		}
	}

	return tx.Commit()
}

func (r Graphs) GetByStudentID(ctx context.Context, studentID uuid.UUID) (*mistake.MistakeGraph, error) {
	q := dbgen.New(r.Store.DB)
	rows, err := q.ListMistakesByStudentID(ctx, studentID.String())
	if err != nil {
		return nil, fmt.Errorf("truy vấn danh sách mistakes: %w", err)
	}

	if len(rows) == 0 {
		return mistake.NewMistakeGraph(studentID), nil
	}

	records := make([]mistakeRecord, 0, len(rows))
	for _, row := range rows {
		id, err := parseID(row.ID)
		if err != nil {
			return nil, err
		}
		itemID, err := parseID(row.AssignmentItemID)
		if err != nil {
			return nil, err
		}
		createdAt, err := parseTime(row.CreatedAt)
		if err != nil {
			return nil, err
		}

		var parentID *uuid.UUID
		if row.ParentID.Valid && row.ParentID.String != "" {
			pID, err := parseID(row.ParentID.String)
			if err != nil {
				return nil, err
			}
			parentID = &pID
		}

		var resolvedAt *time.Time
		if row.ResolvedAt.Valid && row.ResolvedAt.String != "" {
			resTime, err := parseTime(row.ResolvedAt.String)
			if err != nil {
				return nil, err
			}
			resolvedAt = &resTime
		}

		records = append(records, mistakeRecord{
			ID:               id,
			StudentID:        studentID,
			ParentID:         parentID,
			Topic:            row.Topic,
			Reason:           row.Reason,
			AssignmentItemID: itemID,
			Status:           row.Status,
			CreatedAt:        createdAt,
			ResolvedAt:       resolvedAt,
		})
	}

	return decodeMistakeGraph(studentID, records)
}

// -----------------------------------------------------------------------------
// DOCUMENTS
// -----------------------------------------------------------------------------

func (r Documents) Save(ctx context.Context, value *application2.Document) error {
	if value == nil {
		return errors.New("document không được nil")
	}
	q := dbgen.New(r.Store.DB)
	return q.InsertDocument(ctx, dbgen.InsertDocumentParams{
		ID:          value.ID.String(),
		FileName:    value.FileName,
		StoragePath: value.FilePath,
		PageCount:   int64(value.PageCount),
		CreatedAt:   timeText(value.CreatedAt),
	})
}

func (r Documents) GetByID(ctx context.Context, id uuid.UUID) (*application2.Document, error) {
	q := dbgen.New(r.Store.DB)
	row, err := q.GetDocumentByID(ctx, id.String())
	if err != nil {
		return nil, missing(err, "document")
	}
	createdAt, err := parseTime(row.CreatedAt)
	if err != nil {
		return nil, err
	}
	return &application2.Document{
		ID:        id,
		FileName:  row.FileName,
		FilePath:  row.StoragePath,
		PageCount: int(row.PageCount),
		CreatedAt: createdAt,
	}, nil
}

func (r Documents) List(ctx context.Context) ([]application2.Document, error) {
	q := dbgen.New(r.Store.DB)
	rows, err := q.ListDocuments(ctx)
	if err != nil {
		return nil, err
	}

	result := make([]application2.Document, 0, len(rows))
	for _, row := range rows {
		docID, err := parseID(row.ID)
		if err != nil {
			return nil, err
		}
		createdAt, err := parseTime(row.CreatedAt)
		if err != nil {
			return nil, err
		}
		result = append(result, application2.Document{
			ID:        docID,
			FileName:  row.FileName,
			FilePath:  row.StoragePath,
			PageCount: int(row.PageCount),
			CreatedAt: createdAt,
		})
	}
	return result, nil
}

// -----------------------------------------------------------------------------
// EXTERNAL LINKS
// -----------------------------------------------------------------------------

type ExternalLinks struct{ Store *SQLite }

func (r ExternalLinks) FindStudentIDBySpaceID(ctx context.Context, spaceID string) (uuid.UUID, bool, error) {
	q := dbgen.New(r.Store.DB)
	stored, err := q.FindStudentIDBySpaceID(ctx, spaceID)
	if errors.Is(err, sql.ErrNoRows) {
		return uuid.Nil(), false, nil
	}
	if err != nil {
		return uuid.Nil(), false, fmt.Errorf("truy vấn space link: %w", err)
	}

	studentID, err := uuid.Parse(stored)
	if err != nil {
		return uuid.Nil(), false, fmt.Errorf("parse student_id: %w", err)
	}
	return studentID, true, nil
}

func (r ExternalLinks) SaveSpaceLink(ctx context.Context, spaceID string, studentID uuid.UUID, meetingCode, spaceName string) error {
	q := dbgen.New(r.Store.DB)
	return q.SaveSpaceLink(ctx, dbgen.SaveSpaceLinkParams{
		ExternalKey: spaceID,
		StudentID:   studentID.String(),
		MeetingCode: meetingCode,
		SpaceName:   spaceName,
	})
}

func ptrString(s string) *string { return &s }
