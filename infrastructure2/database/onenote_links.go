package database

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"uuid"
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

func (r OneNoteLinks) GetNotebook(ctx context.Context, studentID uuid.UUID, audience, accountID string) (NotebookBinding, bool, error) {
	var b NotebookBinding
	err := r.Store.DB.QueryRowContext(ctx, `SELECT notebook_id,notebook_name FROM v2_notebook_bindings WHERE student_id=? AND audience=? AND account_id=?`, studentID.String(), audience, accountID).Scan(&b.ID, &b.Name)
	if errors.Is(err, sql.ErrNoRows) {
		return NotebookBinding{}, false, nil
	}
	if err != nil {
		return NotebookBinding{}, false, err
	}
	b.StudentID, b.Audience, b.AccountID = studentID, audience, accountID
	return b, true, nil
}

func (r OneNoteLinks) SaveNotebook(ctx context.Context, b NotebookBinding) error {
	if b.StudentID == uuid.Nil() || b.Audience == "" || b.AccountID == "" || b.ID == "" {
		return errors.New("notebook binding thiếu thông tin")
	}
	_, err := r.Store.DB.ExecContext(ctx, `INSERT INTO v2_notebook_bindings(student_id,audience,account_id,notebook_id,notebook_name) VALUES(?,?,?,?,?) ON CONFLICT(student_id,audience,account_id) DO UPDATE SET notebook_id=excluded.notebook_id,notebook_name=excluded.notebook_name`, b.StudentID.String(), b.Audience, b.AccountID, b.ID, b.Name)
	return err
}

func (r OneNoteLinks) GetPage(ctx context.Context, assignmentID uuid.UUID, audience string) (PageBinding, bool, error) {
	var b PageBinding
	err := r.Store.DB.QueryRowContext(ctx, `SELECT account_id,page_id,page_url,notebook_id,section_id FROM v2_assignment_pages WHERE assignment_id=? AND audience=?`, assignmentID.String(), audience).Scan(&b.AccountID, &b.PageID, &b.PageURL, &b.NotebookID, &b.SectionID)
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
	_, err := r.Store.DB.ExecContext(ctx, `INSERT INTO v2_assignment_pages(assignment_id,audience,account_id,page_id,page_url,notebook_id,section_id) VALUES(?,?,?,?,?,?,?) ON CONFLICT(assignment_id,audience) DO UPDATE SET page_id=excluded.page_id,page_url=excluded.page_url,notebook_id=excluded.notebook_id,section_id=excluded.section_id`, b.AssignmentID.String(), b.Audience, b.AccountID, b.PageID, b.PageURL, b.NotebookID, b.SectionID)
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
