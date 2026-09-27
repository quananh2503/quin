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
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/domain2/mistake"
	"meet-attendance-clean/domain2/student"
)

type Students struct{ Store *SQLite }
type Sessions struct{ Store *SQLite }
type Drafts struct{ Store *SQLite }
type Lessons struct{ Store *SQLite }
type Assignments struct{ Store *SQLite }
type Graphs struct{ Store *SQLite }
type Documents struct{ Store *SQLite }

func (r Drafts) RecoverInterrupted(ctx context.Context) error {
	_, err := r.Store.DB.ExecContext(ctx, `UPDATE v2_lesson_drafts SET status='failed',updated_at=?,error_text=? WHERE status='processing'`, timeText(time.Now().UTC()), "tác vụ bị gián đoạn khi ứng dụng dừng")
	return err
}

func (r Students) GetByID(ctx context.Context, id uuid.UUID) (*student.Student, error) {
	var name, class, created string
	var cycle int
	err := r.Store.DB.QueryRowContext(ctx, `SELECT name,class,cycle_start_day,created_at FROM v2_students WHERE id=?`, id.String()).Scan(&name, &class, &cycle, &created)
	if err != nil {
		return nil, missing(err, "student")
	}
	createdAt, err := parseTime(created)
	if err != nil {
		return nil, err
	}
	return student.ReconstituteStudent(id, name, class, cycle, createdAt)
}

func (r Students) Save(ctx context.Context, value *student.Student) error {
	if value == nil {
		return errors.New("student không được nil")
	}
	_, err := r.Store.DB.ExecContext(ctx, `INSERT INTO v2_students(id,name,class,cycle_start_day,created_at) VALUES(?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET name=excluded.name,class=excluded.class,cycle_start_day=excluded.cycle_start_day`, value.ID().String(), value.Name(), value.Class(), value.CycleStartDay(), timeText(value.CreatedAt()))
	return err
}

func (r Students) SaveBatch(ctx context.Context, values []*student.Student) error {
	tx, err := r.Store.DB.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()
	for _, value := range values {
		if value == nil {
			return errors.New("student batch chứa nil")
		}
		if _, err := tx.ExecContext(ctx, `INSERT INTO v2_students(id,name,class,cycle_start_day,created_at) VALUES(?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET name=excluded.name,class=excluded.class,cycle_start_day=excluded.cycle_start_day`, value.ID().String(), value.Name(), value.Class(), value.CycleStartDay(), timeText(value.CreatedAt())); err != nil {
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
	for _, session := range values {
		records := make([]attendanceRecord, 0, len(session.Attendance()))
		for _, a := range session.Attendance() {
			records = append(records, attendanceRecord{Name: a.StudentName(), JoinedAt: a.FirstJoinedAt(), LeftAt: a.LastLeaveAt(), Minutes: a.DurationMin()})
		}
		encoded, err := json.Marshal(records)
		if err != nil {
			return err
		}
		if _, err := tx.ExecContext(ctx, `INSERT INTO v2_class_sessions(id,student_id,start_at,end_at,attendance_json) VALUES(?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET attendance_json=excluded.attendance_json`, session.ID().String(), session.StudentID().String(), timeText(session.StartTime()), timeText(session.EndTime()), string(encoded)); err != nil {
			return err
		}
	}
	return tx.Commit()
}

func (r Drafts) Save(ctx context.Context, value *lesson.LessonDraft) error {
	if value == nil {
		return errors.New("lesson draft không được nil")
	}
	material, err := encodeMaterial(value.Material())
	if err != nil {
		return err
	}
	materialJSON, err := json.Marshal(material)
	if err != nil {
		return err
	}
	var lessonJSON any
	if value.Lesson() != nil {
		encoded, err := encodeLesson(value.Lesson())
		if err != nil {
			return err
		}
		lessonJSON = string(encoded)
	}
	var errorText any
	if value.ErrorString() != nil {
		errorText = *value.ErrorString()
	}
	tx, err := r.Store.DB.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()
	_, err = tx.ExecContext(ctx, `INSERT INTO v2_lesson_drafts(id,title,model,prompt,status,material_json,lesson_json,created_at,updated_at,error_text) VALUES(?,?,?,?,?,?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET title=excluded.title,model=excluded.model,prompt=excluded.prompt,status=excluded.status,material_json=excluded.material_json,lesson_json=excluded.lesson_json,updated_at=excluded.updated_at,error_text=excluded.error_text`, value.ID().String(), value.Title(), value.Model(), value.Prompt(), string(value.Status()), string(materialJSON), lessonJSON, timeText(value.CreatedAt()), nullableTime(value.UpdatedAt()), errorText)
	if err != nil {
		return err
	}
	if lessonJSON != nil {
		if _, err := tx.ExecContext(ctx, `INSERT INTO v2_lessons(id,draft_id,lesson_json) VALUES(?,?,?) ON CONFLICT(id) DO UPDATE SET lesson_json=excluded.lesson_json`, value.Lesson().ID().String(), value.ID().String(), lessonJSON); err != nil {
			return err
		}
	}
	return tx.Commit()
}

func (r Drafts) GetByID(ctx context.Context, id uuid.UUID) (*lesson.LessonDraft, error) {
	var title, model, prompt, status, materialJSON, created string
	var lessonJSON, updated, errorText sql.NullString
	err := r.Store.DB.QueryRowContext(ctx, `SELECT title,model,prompt,status,material_json,lesson_json,created_at,updated_at,error_text FROM v2_lesson_drafts WHERE id=?`, id.String()).Scan(&title, &model, &prompt, &status, &materialJSON, &lessonJSON, &created, &updated, &errorText)
	if err != nil {
		return nil, missing(err, "lesson draft")
	}
	var materialData materialRecord
	if err := json.Unmarshal([]byte(materialJSON), &materialData); err != nil {
		return nil, err
	}
	material, err := decodeMaterial(materialData)
	if err != nil {
		return nil, err
	}
	createdAt, err := parseTime(created)
	if err != nil {
		return nil, err
	}
	var updatedAt *time.Time
	if updated.Valid {
		v, err := parseTime(updated.String)
		if err != nil {
			return nil, err
		}
		updatedAt = &v
	}
	var cause *string
	if errorText.Valid {
		cause = &errorText.String
	}
	var content *lesson.Lesson
	if lessonJSON.Valid {
		content, err = decodeLesson([]byte(lessonJSON.String))
		if err != nil {
			return nil, fmt.Errorf("đọc nội dung lesson draft: %w", err)
		}
	}
	return lesson.ReconstituteLessonDraft(id, title, model, prompt, lesson.LessonDraftStatus(status), material, createdAt, updatedAt, cause, content)
}

func (r Lessons) GetByID(ctx context.Context, id uuid.UUID) (*lesson.Lesson, error) {
	var raw string
	err := r.Store.DB.QueryRowContext(ctx, `SELECT lesson_json FROM v2_lessons WHERE id=?`, id.String()).Scan(&raw)
	if err != nil {
		return nil, missing(err, "lesson")
	}
	return decodeLesson([]byte(raw))
}

func (r Assignments) Save(ctx context.Context, value *assignment.Assignment) error {
	if value == nil {
		return errors.New("assignment không được nil")
	}
	items, err := encodeItems(value.Items())
	if err != nil {
		return err
	}
	var purpose string
	var mistakeID any
	switch v := value.Purpose().(type) {
	case assignment.AssignmentPurposeNormal:
		purpose = "normal"
	case assignment.AssignmentPurposeRemediation:
		purpose, mistakeID = "remediation", v.MistakeID().String()
	default:
		return errors.New("assignment purpose không hợp lệ")
	}
	_, err = r.Store.DB.ExecContext(ctx, `INSERT INTO v2_assignments(id,student_id,title,purpose,origin_mistake_id,status,assigned_at,items_json) VALUES(?,?,?,?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET title=excluded.title,purpose=excluded.purpose,origin_mistake_id=excluded.origin_mistake_id,status=excluded.status,items_json=excluded.items_json`, value.ID().String(), value.StudentID().String(), value.Title(), purpose, mistakeID, string(value.Status()), timeText(value.AssignedAt()), string(items))
	return err
}

func (r Assignments) GetByID(ctx context.Context, id uuid.UUID) (*assignment.Assignment, error) {
	var studentRaw, title, purposeRaw, statusRaw, assignedRaw, itemsRaw string
	var mistakeRaw sql.NullString
	err := r.Store.DB.QueryRowContext(ctx, `SELECT student_id,title,purpose,origin_mistake_id,status,assigned_at,items_json FROM v2_assignments WHERE id=?`, id.String()).Scan(&studentRaw, &title, &purposeRaw, &mistakeRaw, &statusRaw, &assignedRaw, &itemsRaw)
	if err != nil {
		return nil, missing(err, "assignment")
	}
	studentID, err := parseID(studentRaw)
	if err != nil {
		return nil, err
	}
	assignedAt, err := parseTime(assignedRaw)
	if err != nil {
		return nil, err
	}
	items, err := decodeItems([]byte(itemsRaw))
	if err != nil {
		return nil, fmt.Errorf("đọc assignment items: %w", err)
	}
	var purpose assignment.AssignmentPurpose
	switch purposeRaw {
	case "normal":
		purpose = assignment.AssignmentPurposeNormal{}
	case "remediation":
		if !mistakeRaw.Valid {
			return nil, errors.New("remediation assignment thiếu mistake ID")
		}
		mistakeID, err := parseID(mistakeRaw.String)
		if err != nil {
			return nil, err
		}
		purpose, err = assignment.NewRemediationPurpose(mistakeID)
		if err != nil {
			return nil, err
		}
	default:
		return nil, errors.New("assignment purpose lưu trữ không hợp lệ")
	}
	return assignment.ReconstituteAssignment(id, studentID, title, purpose, assignment.AssignmentStatus(statusRaw), assignedAt, items)
}

func (r Graphs) Save(ctx context.Context, value *mistake.MistakeGraph) error {
	if value == nil {
		return errors.New("mistake graph không được nil")
	}
	encoded, err := json.Marshal(value.Roots())
	if err != nil {
		return err
	}
	_, err = r.Store.DB.ExecContext(ctx, `INSERT INTO v2_mistake_graphs(student_id,graph_id,roots_json) VALUES(?,?,?) ON CONFLICT(student_id) DO UPDATE SET roots_json=excluded.roots_json`, value.StudentID().String(), value.ID().String(), string(encoded))
	return err
}

func (r Graphs) GetByStudentID(ctx context.Context, studentID uuid.UUID) (*mistake.MistakeGraph, error) {
	var idRaw, rootsRaw string
	err := r.Store.DB.QueryRowContext(ctx, `SELECT graph_id,roots_json FROM v2_mistake_graphs WHERE student_id=?`, studentID.String()).Scan(&idRaw, &rootsRaw)
	if errors.Is(err, sql.ErrNoRows) {
		return mistake.NewMistakeGraph(studentID), nil
	}
	if err != nil {
		return nil, err
	}
	id, err := parseID(idRaw)
	if err != nil {
		return nil, err
	}
	var roots []mistake.NodeState
	if err := json.Unmarshal([]byte(rootsRaw), &roots); err != nil {
		return nil, err
	}
	return mistake.ReconstituteGraph(id, studentID, roots)
}

func (r Documents) Save(ctx context.Context, value *application2.Document) error {
	if value == nil {
		return errors.New("document không được nil")
	}

	_, err := r.Store.DB.ExecContext(ctx,
		`INSERT INTO v2_documents(id,file_name,storage_path,page_count,created_at) 
		VALUES(?,?,?,?,?)`, value.ID.String(), value.FileName, value.FilePath, value.PageCount, timeText(value.CreatedAt))
	return err
}

func (r Documents) GetByID(ctx context.Context, id uuid.UUID) (*application2.Document, error) {
	var fileName, storagePath, createdRaw string
	var count int
	err := r.Store.DB.QueryRowContext(ctx, `SELECT file_name,storage_path,page_count,created_at FROM v2_documents WHERE id=?`, id.String()).Scan(&fileName, &storagePath, &count, &createdRaw)
	if err != nil {
		return nil, missing(err, "document")
	}
	createdAt, err := parseTime(createdRaw)
	if err != nil {
		return nil, err
	}
	return &application2.Document{
		ID:        id,
		FileName:  fileName,
		FilePath:  storagePath,
		PageCount: count,
		CreatedAt: createdAt,
	}, nil
}

func (r Documents) List(ctx context.Context) ([]application2.Document, error) {
	rows, err := r.Store.DB.QueryContext(ctx, `SELECT id,file_name,storage_path,page_count,created_at FROM v2_documents ORDER BY created_at DESC`)
	if err != nil {
		return nil, err
	}
	var result []application2.Document
	for rows.Next() {
		var idStr, fileName, storagePath, createdRaw string
		var count int
		if err := rows.Scan(&idStr, &fileName, &storagePath, &count, &createdRaw); err != nil {
			return nil, err
		}
		docID, err := parseID(idStr)
		if err != nil {
			return nil, err
		}
		createdAt, err := parseTime(createdRaw)
		if err != nil {
			return nil, err
		}
		doc := application2.Document{
			ID:        docID,
			FileName:  fileName,
			FilePath:  storagePath,
			PageCount: count,
			CreatedAt: createdAt,
		}
		result = append(result, doc)

	}
	if err := rows.Err(); err != nil {
		rows.Close()
		return nil, err
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	return result, nil
}
