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
)

type Students struct{ Store *SQLite }
type Sessions struct{ Store *SQLite }
type Drafts struct{ Store *SQLite }
type Lessons struct{ Store *SQLite }
type Assignments struct{ Store *SQLite }
type Graphs struct{ Store *SQLite }
type Documents struct{ Store *SQLite }

func (r Drafts) RecoverInterrupted(ctx context.Context) error {
	_, err := r.Store.DB.ExecContext(ctx, `UPDATE lesson_drafts SET status='failed',updated_at=?,error_text=? WHERE status='processing'`, timeText(time.Now().UTC()), "tác vụ bị gián đoạn khi ứng dụng dừng")
	return err
}

func (r Students) GetByID(ctx context.Context, id uuid.UUID) (*student.Student, error) {
	var name, class, created string
	var cycle int
	err := r.Store.DB.QueryRowContext(ctx, `SELECT name,class,cycle_start_day,created_at FROM students WHERE id=?`, id.String()).Scan(&name, &class, &cycle, &created)
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
	_, err := r.Store.DB.ExecContext(ctx, `INSERT INTO students(id,name,class,cycle_start_day,created_at) VALUES(?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET name=excluded.name,class=excluded.class,cycle_start_day=excluded.cycle_start_day`, value.ID().String(), value.Name(), value.Class(), value.CycleStartDay(), timeText(value.CreatedAt()))
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
		if _, err := tx.ExecContext(ctx, `INSERT INTO students(id,name,class,cycle_start_day,created_at) VALUES(?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET name=excluded.name,class=excluded.class,cycle_start_day=excluded.cycle_start_day`, value.ID().String(), value.Name(), value.Class(), value.CycleStartDay(), timeText(value.CreatedAt())); err != nil {
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
		if _, err := tx.ExecContext(ctx, `INSERT INTO class_sessions(id,student_id,start_at,end_at,attendance_json) VALUES(?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET attendance_json=excluded.attendance_json`, session.ID().String(), session.StudentID().String(), timeText(session.StartTime()), timeText(session.EndTime()), string(encoded)); err != nil {
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
		raw, err := json.Marshal(encoded)
		if err != nil {
			return err
		}
		lessonJSON = string(raw)
	}
	titleJSON, err := json.Marshal(encodeContent(value.Title()))
	if err != nil {
		return err
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
	_, err = tx.ExecContext(ctx, `INSERT INTO lesson_drafts(id,title,model,prompt,status,material_json,lesson_json,created_at,updated_at,error_text) VALUES(?,?,?,?,?,?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET title=excluded.title,model=excluded.model,prompt=excluded.prompt,status=excluded.status,material_json=excluded.material_json,lesson_json=excluded.lesson_json,updated_at=excluded.updated_at,error_text=excluded.error_text`, value.ID().String(), string(titleJSON), value.Model(), value.Prompt(), string(value.Status()), string(materialJSON), lessonJSON, timeText(value.CreatedAt()), nullableTime(value.UpdatedAt()), errorText)
	if err != nil {
		return err
	}
	if lessonJSON != nil {
		if _, err := tx.ExecContext(ctx, `INSERT INTO lessons(id,draft_id,lesson_json) VALUES(?,?,?) ON CONFLICT(id) DO UPDATE SET lesson_json=excluded.lesson_json`, value.Lesson().ID().String(), value.ID().String(), lessonJSON); err != nil {
			return err
		}
	}
	return tx.Commit()
}

func (r Drafts) GetByID(ctx context.Context, id uuid.UUID) (*lesson.LessonDraft, error) {
	query := `
		SELECT title, model, prompt, status, material_json, lesson_json, created_at, updated_at, error_text 
		FROM lesson_drafts 
		WHERE id = ?
	`

	var titleRaw, model, prompt, status, materialJSON, created string
	var lessonJSON, updated, errorText sql.NullString

	err := r.Store.DB.QueryRowContext(ctx, query, id.String()).Scan(
		&titleRaw,
		&model,
		&prompt,
		&status,
		&materialJSON,
		&lessonJSON,
		&created,
		&updated,
		&errorText,
	)
	if err != nil {
		return nil, missing(err, "lesson draft")
	}

	// 1. Phục hồi Title thành sharekernel.Content (Tương thích cả JSON lẫn text thường)
	var titleRec contentRecord
	var title sharekernel.Content
	if err := json.Unmarshal([]byte(titleRaw), &titleRec); err == nil && len(titleRec.InlineParts) > 0 {
		title = decodeContent(titleRec)
	} else {
		title = sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: titleRaw})
	}

	// 2. Phục hồi Material
	var materialData materialRecord
	if err := json.Unmarshal([]byte(materialJSON), &materialData); err != nil {
		return nil, fmt.Errorf("unmarshal material_json: %w", err)
	}
	material, err := decodeMaterial(materialData)
	if err != nil {
		return nil, fmt.Errorf("decode material: %w", err)
	}

	// 3. Phục hồi thời gian
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

	// 4. Phục hồi Error text nếu có
	var cause *string
	if errorText.Valid {
		cause = &errorText.String
	}

	// 5. Phục hồi nội dung Lesson nếu đã tạo xong
	var content *lesson.Lesson
	if lessonJSON.Valid && len(lessonJSON.String) > 0 {
		content, err = decodeLesson([]byte(lessonJSON.String))
		if err != nil {
			return nil, fmt.Errorf("đọc nội dung lesson draft: %w", err)
		}
	}

	return lesson.ReconstituteLessonDraft(
		id,
		title,
		model,
		prompt,
		lesson.LessonDraftStatus(status),
		material,
		createdAt,
		updatedAt,
		cause,
		content,
	)
}
func (r Lessons) GetByID(ctx context.Context, id uuid.UUID) (*lesson.Lesson, error) {
	var raw string
	err := r.Store.DB.QueryRowContext(ctx, `SELECT lesson_json FROM lessons WHERE id=?`, id.String()).Scan(&raw)
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
	_, err = r.Store.DB.ExecContext(ctx, `INSERT INTO assignments(id,student_id,title,purpose,origin_mistake_id,status,assigned_at,items_json) VALUES(?,?,?,?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET title=excluded.title,purpose=excluded.purpose,origin_mistake_id=excluded.origin_mistake_id,status=excluded.status,items_json=excluded.items_json`, value.ID().String(), value.StudentID().String(), value.Title(), purpose, mistakeID, string(value.Status()), timeText(value.AssignedAt()), string(items))
	return err
}

func (r Assignments) GetByID(ctx context.Context, id uuid.UUID) (*assignment.Assignment, error) {
	var studentRaw, title, purposeRaw, statusRaw, assignedRaw, itemsRaw string
	var mistakeRaw sql.NullString
	err := r.Store.DB.QueryRowContext(ctx, `SELECT student_id,title,purpose,origin_mistake_id,status,assigned_at,items_json FROM assignments WHERE id=?`, id.String()).Scan(&studentRaw, &title, &purposeRaw, &mistakeRaw, &statusRaw, &assignedRaw, &itemsRaw)
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
	records, err := encodeMistakeGraph(value)
	if err != nil {
		return err
	}
	tx, err := r.Store.DB.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()
	if _, err = tx.ExecContext(ctx, `DELETE FROM mistakes WHERE student_id=?`, value.StudentID().String()); err != nil {
		return err
	}
	for _, record := range records {
		var parentID any
		if record.ParentID != nil {
			parentID = record.ParentID.String()
		}
		if _, err = tx.ExecContext(ctx, `INSERT INTO mistakes(id,student_id,parent_id,topic,reason,assignment_item_id,status,created_at,resolved_at) VALUES(?,?,?,?,?,?,?,?,?)`, record.ID.String(), record.StudentID.String(), parentID, record.Topic, record.Reason, record.AssignmentItemID.String(), record.Status, timeText(record.CreatedAt), nullableTime(record.ResolvedAt)); err != nil {
			return err
		}
	}
	return tx.Commit()
}

func (r Graphs) GetByStudentID(ctx context.Context, studentID uuid.UUID) (*mistake.MistakeGraph, error) {
	query := `
		SELECT id, parent_id, topic, reason, assignment_item_id, status, created_at, resolved_at 
		FROM mistakes 
		WHERE student_id = ? 
		ORDER BY created_at ASC
	`

	rows, err := r.Store.DB.QueryContext(ctx, query, studentID.String())
	if err != nil {
		return nil, fmt.Errorf("truy vấn danh sách mistakes: %w", err)
	}
	defer rows.Close()

	var records []mistakeRecord

	for rows.Next() {
		var (
			idStr, topic, reason, itemIDStr, status, createdStr string
			parentIDStr, resolvedStr                            sql.NullString
		)

		err := rows.Scan(
			&idStr,
			&parentIDStr,
			&topic,
			&reason,
			&itemIDStr,
			&status,
			&createdStr,
			&resolvedStr,
		)
		if err != nil {
			return nil, fmt.Errorf("scan dòng mistake: %w", err)
		}

		id, err := parseID(idStr)
		if err != nil {
			return nil, err
		}
		itemID, err := parseID(itemIDStr)
		if err != nil {
			return nil, err
		}
		createdAt, err := parseTime(createdStr)
		if err != nil {
			return nil, err
		}

		// Xử lý parent_id (có thể NULL nếu là nút gốc)
		var parentID *uuid.UUID
		if parentIDStr.Valid && parentIDStr.String != "" {
			pID, err := parseID(parentIDStr.String)
			if err != nil {
				return nil, err
			}
			parentID = &pID
		}

		// Xử lý resolved_at (có thể NULL nếu chưa giải quyết)
		var resolvedAt *time.Time
		if resolvedStr.Valid && resolvedStr.String != "" {
			resTime, err := parseTime(resolvedStr.String)
			if err != nil {
				return nil, err
			}
			resolvedAt = &resTime
		}

		records = append(records, mistakeRecord{
			ID:               id,
			StudentID:        studentID,
			ParentID:         parentID,
			Topic:            topic,
			Reason:           reason,
			AssignmentItemID: itemID,
			Status:           status,
			CreatedAt:        createdAt,
			ResolvedAt:       resolvedAt,
		})
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	// Nếu học sinh chưa từng có lỗi nào trong DB -> Khởi tạo một Graph mới tinh
	if len(records) == 0 {
		return mistake.NewMistakeGraph(studentID), nil
	}

	// Dựng lại cây từ danh sách dòng phẳng bằng thuật toán Map 2 lượt
	return decodeMistakeGraph(studentID, records)
}

func (r Documents) Save(ctx context.Context, value *application2.Document) error {
	if value == nil {
		return errors.New("document không được nil")
	}

	_, err := r.Store.DB.ExecContext(ctx,
		`INSERT INTO documents(id,file_name,storage_path,page_count,created_at) 
		VALUES(?,?,?,?,?)`, value.ID.String(), value.FileName, value.FilePath, value.PageCount, timeText(value.CreatedAt))
	return err
}

func (r Documents) GetByID(ctx context.Context, id uuid.UUID) (*application2.Document, error) {
	var fileName, storagePath, createdRaw string
	var count int
	err := r.Store.DB.QueryRowContext(ctx, `SELECT file_name,storage_path,page_count,created_at FROM documents WHERE id=?`, id.String()).Scan(&fileName, &storagePath, &count, &createdRaw)
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
	rows, err := r.Store.DB.QueryContext(ctx, `SELECT id,file_name,storage_path,page_count,created_at FROM documents ORDER BY created_at DESC`)
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
