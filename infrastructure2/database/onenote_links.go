package database

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"
	"time"
	"uuid"

	"meet-attendance-clean/infrastructure2/database/dbgen"
)

type NotebookBinding struct {
	StudentID uuid.UUID
	Audience  string
	AccountID string
	ID        string
	Name      string
}

type PageBinding struct {
	AssignmentID uuid.UUID
	Audience     string
	AccountID    string
	PageID       string
	PageURL      string
	NotebookID   string
	SectionID    string
}

type OneNoteLinks struct{ Store *SQLite }

// GetNotebook tìm kiếm thông tin liên kết sổ tay theo studentID, audience và accountID.
func (r OneNoteLinks) GetNotebook(ctx context.Context, studentID uuid.UUID, audience, accountID string) (NotebookBinding, bool, error) {
	var b NotebookBinding
	err := r.Store.DB.QueryRowContext(ctx, `SELECT notebook_id,notebook_name FROM notebook_bindings WHERE student_id=? AND audience=? AND account_id=?`, studentID.String(), audience, accountID).Scan(&b.ID, &b.Name)
	if errors.Is(err, sql.ErrNoRows) {
		return NotebookBinding{}, false, nil
	}
	if err != nil {
		return NotebookBinding{}, false, err
	}
	b.StudentID, b.Audience, b.AccountID = studentID, audience, accountID
	return b, true, nil
}

// GetNotebookByStudent tìm kiếm thông tin liên kết sổ tay của học sinh theo studentID và audience mà không cần chỉ định accountID.
// Trả về (binding, true, nil) nếu tìm thấy, (empty, false, nil) nếu chưa từng liên kết.
func (r OneNoteLinks) GetNotebookByStudent(ctx context.Context, studentID uuid.UUID, audience string) (NotebookBinding, bool, error) {
	row, err := dbgen.New(r.Store.DB).GetNotebookBindingByStudentAndAudience(ctx, dbgen.GetNotebookBindingByStudentAndAudienceParams{
		StudentID: studentID.String(),
		Audience:  audience,
	})
	if errors.Is(err, sql.ErrNoRows) {
		return NotebookBinding{}, false, nil
	}
	if err != nil {
		return NotebookBinding{}, false, fmt.Errorf("truy vấn liên kết sổ tay học sinh thất bại: %w", err)
	}
	return NotebookBinding{
		StudentID: studentID,
		Audience:  row.Audience,
		AccountID: row.AccountID,
		ID:        row.NotebookID,
		Name:      row.NotebookName,
	}, true, nil
}

// SaveNotebook lưu hoặc cập nhật liên kết sổ tay OneNote của học sinh vào SQLite.
func (r OneNoteLinks) SaveNotebook(ctx context.Context, b NotebookBinding) error {
	if b.StudentID == uuid.Nil() || b.Audience == "" || b.AccountID == "" || b.ID == "" {
		return errors.New("notebook binding thiếu thông tin")
	}
	_, err := r.Store.DB.ExecContext(ctx, `INSERT INTO notebook_bindings(student_id,audience,account_id,notebook_id,notebook_name) VALUES(?,?,?,?,?) ON CONFLICT(student_id,audience,account_id) DO UPDATE SET notebook_id=excluded.notebook_id,notebook_name=excluded.notebook_name`, b.StudentID.String(), b.Audience, b.AccountID, b.ID, b.Name)
	return err
}

func (r OneNoteLinks) GetPage(ctx context.Context, assignmentID uuid.UUID, audience string) (PageBinding, bool, error) {
	var b PageBinding
	err := r.Store.DB.QueryRowContext(ctx, `SELECT account_id,page_id,page_url,notebook_id,section_id FROM assignment_pages WHERE assignment_id=? AND audience=?`, assignmentID.String(), audience).Scan(&b.AccountID, &b.PageID, &b.PageURL, &b.NotebookID, &b.SectionID)
	if errors.Is(err, sql.ErrNoRows) {
		return PageBinding{}, false, nil
	}
	if err != nil {
		return PageBinding{}, false, err
	}
	b.AssignmentID, b.Audience = assignmentID, audience
	return b, true, nil
}

func (r OneNoteLinks) SavePage(ctx context.Context, b PageBinding) error {
	if b.AssignmentID == uuid.Nil() || b.Audience == "" || b.AccountID == "" || b.PageID == "" || b.NotebookID == "" || b.SectionID == "" {
		return errors.New("page binding thiếu thông tin")
	}
	_, err := r.Store.DB.ExecContext(ctx, `INSERT INTO assignment_pages(assignment_id,audience,account_id,page_id,page_url,notebook_id,section_id) VALUES(?,?,?,?,?,?,?) ON CONFLICT(assignment_id,audience) DO UPDATE SET page_id=excluded.page_id,page_url=excluded.page_url,notebook_id=excluded.notebook_id,section_id=excluded.section_id`, b.AssignmentID.String(), b.Audience, b.AccountID, b.PageID, b.PageURL, b.NotebookID, b.SectionID)
	return err
}

func (r OneNoteLinks) MustGetPage(ctx context.Context, assignmentID uuid.UUID, audience string) (PageBinding, error) {
	b, ok, err := r.GetPage(ctx, assignmentID, audience)
	if err != nil {
		return PageBinding{}, err
	}
	if !ok {
		return PageBinding{}, fmt.Errorf("assignment %s chưa được publish cho %s", assignmentID, audience)
	}
	return b, nil
}

// GetLastChapter lấy tên chương được chọn gần đây nhất của học sinh theo audience ("HS" hoặc "GV").
// Trả về (chapterName, true, nil) nếu tìm thấy, ("", false, nil) nếu chưa từng lưu.
func (r OneNoteLinks) GetLastChapter(ctx context.Context, studentID uuid.UUID, audience string) (string, bool, error) {
	row, err := dbgen.New(r.Store.DB).GetLastChapter(ctx, dbgen.GetLastChapterParams{
		StudentID: studentID.String(),
		Audience:  audience,
	})
	if errors.Is(err, sql.ErrNoRows) {
		return "", false, nil
	}
	if err != nil {
		return "", false, fmt.Errorf("lấy tên chương cuối cùng thất bại: %w", err)
	}
	return row.ChapterName, true, nil
}

// SaveLastChapter lưu hoặc cập nhật tên chương được chọn gần đây nhất của học sinh theo audience.
func (r OneNoteLinks) SaveLastChapter(ctx context.Context, studentID uuid.UUID, audience, chapterName string) error {
	if studentID == uuid.Nil() {
		return errors.New("studentID không được nil")
	}
	trimmedAud := strings.TrimSpace(audience)
	if trimmedAud == "" {
		return errors.New("audience không được để trống")
	}
	trimmedCh := strings.TrimSpace(chapterName)
	if trimmedCh == "" {
		return errors.New("chapterName không được để trống")
	}
	err := dbgen.New(r.Store.DB).UpsertLastChapter(ctx, dbgen.UpsertLastChapterParams{
		StudentID:   studentID.String(),
		Audience:    trimmedAud,
		ChapterName: trimmedCh,
		UpdatedAt:   timeText(time.Now().UTC()),
	})
	if err != nil {
		return fmt.Errorf("lưu tên chương cuối cùng thất bại: %w", err)
	}
	return nil
}
