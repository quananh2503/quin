package database

import (
	"context"
	"encoding/json"
	"strings"
	"uuid"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/domain2/assignment"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/domain2/mistake"
)

type ReadStore struct{ Store *SQLite }

func (r ReadStore) studentView(ctx context.Context, id uuid.UUID) (application2.StudentView, error) {
	value, err := (Students{Store: r.Store}).GetByID(ctx, id)
	if err != nil {
		return application2.StudentView{}, err
	}
	view := application2.StudentView{ID: value.ID(), Name: value.Name(), Class: value.Class(), CycleStartDay: value.CycleStartDay(), CreatedAt: value.CreatedAt()}
	_ = r.Store.DB.QueryRowContext(ctx, `SELECT meeting_code,space_name FROM external_student_links WHERE student_id=? AND provider='google_meet_space' LIMIT 1`, id.String()).Scan(&view.MeetingCode, &view.SpaceName)
	return view, nil
}

func (r ReadStore) ListStudentChoices(ctx context.Context) ([]application2.StudentView, error) {
	rows, err := r.Store.DB.QueryContext(ctx, `SELECT id FROM students ORDER BY name COLLATE NOCASE`)
	if err != nil {
		return nil, err
	}
	var ids []uuid.UUID
	for rows.Next() {
		var raw string
		if err := rows.Scan(&raw); err != nil {
			rows.Close()
			return nil, err
		}
		id, err := parseID(raw)
		if err != nil {
			rows.Close()
			return nil, err
		}
		ids = append(ids, id)
	}
	err = rows.Err()
	rows.Close()
	if err != nil {
		return nil, err
	}
	result := make([]application2.StudentView, 0, len(ids))
	for _, id := range ids {
		view, err := r.studentView(ctx, id)
		if err != nil {
			return nil, err
		}
		result = append(result, view)
	}
	return result, nil
}

func (r ReadStore) Dashboard(ctx context.Context, filter application2.StudentFilter) (application2.DashboardView, error) {
	students, err := r.ListStudentChoices(ctx)
	if err != nil {
		return application2.DashboardView{}, err
	}
	result := application2.DashboardView{Students: make([]application2.StudentSummary, 0, len(students))}
	for _, stu := range students {
		if filter.SearchName != nil && !strings.Contains(strings.ToLower(stu.Name), strings.ToLower(strings.TrimSpace(*filter.SearchName))) {
			continue
		}
		meetings, err := r.meetings(ctx, stu.ID, application2.MeetingFilter{FromDate: filter.FromDate, ToDate: filter.ToDate, MinDurationMinutes: filter.MinDurationMinutes})
		if err != nil {
			return application2.DashboardView{}, err
		}
		summary := application2.StudentSummary{StudentView: stu, TotalSessions: len(meetings)}
		for _, meeting := range meetings {
			summary.TotalDurationMinutes += int(meeting.EndedAt.Sub(meeting.StartedAt).Minutes())
		}
		result.Students = append(result.Students, summary)
		result.TotalSessions += summary.TotalSessions
		result.TotalDurationMinutes += summary.TotalDurationMinutes
	}
	result.TotalStudents = len(result.Students)
	return result, nil
}

func (r ReadStore) StudentDetail(ctx context.Context, id uuid.UUID, filter application2.MeetingFilter) (application2.StudentDetailView, error) {
	stu, err := r.studentView(ctx, id)
	if err != nil {
		return application2.StudentDetailView{}, err
	}
	meetings, err := r.meetings(ctx, id, filter)
	if err != nil {
		return application2.StudentDetailView{}, err
	}
	result := application2.StudentDetailView{Student: stu, Meetings: meetings, TotalSessions: len(meetings)}
	for _, meeting := range meetings {
		result.TotalDurationMinutes += int(meeting.EndedAt.Sub(meeting.StartedAt).Minutes())
	}
	return result, nil
}

func (r ReadStore) meetings(ctx context.Context, studentID uuid.UUID, filter application2.MeetingFilter) ([]application2.MeetingView, error) {
	rows, err := r.Store.DB.QueryContext(ctx, `SELECT id,start_at,end_at,attendance_json FROM class_sessions WHERE student_id=? ORDER BY start_at DESC`, studentID.String())
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	result := make([]application2.MeetingView, 0)
	for rows.Next() {
		var idRaw, startRaw, endRaw, attendanceRaw string
		if err := rows.Scan(&idRaw, &startRaw, &endRaw, &attendanceRaw); err != nil {
			return nil, err
		}
		id, err := parseID(idRaw)
		if err != nil {
			return nil, err
		}
		start, err := parseTime(startRaw)
		if err != nil {
			return nil, err
		}
		end, err := parseTime(endRaw)
		if err != nil {
			return nil, err
		}
		if !filter.FromDate.IsZero() && start.Before(filter.FromDate) {
			continue
		}
		if !filter.ToDate.IsZero() && start.After(filter.ToDate) {
			continue
		}
		if int(end.Sub(start).Minutes()) < filter.MinDurationMinutes {
			continue
		}
		var records []attendanceRecord
		if err := json.Unmarshal([]byte(attendanceRaw), &records); err != nil {
			return nil, err
		}
		meeting := application2.MeetingView{ID: id, StartedAt: start, EndedAt: end, Participants: make([]application2.ParticipantView, 0, len(records))}
		for _, record := range records {
			meeting.Participants = append(meeting.Participants, application2.ParticipantView{Name: record.Name, FirstJoinedAt: record.JoinedAt, LastLeftAt: record.LeftAt, Duration: record.Minutes})
		}
		result = append(result, meeting)
	}
	return result, rows.Err()
}

func (r ReadStore) ListDrafts(ctx context.Context) ([]application2.DraftView, error) {
	rows, err := r.Store.DB.QueryContext(ctx, `SELECT id FROM lesson_drafts ORDER BY created_at DESC`)
	if err != nil {
		return nil, err
	}
	var ids []uuid.UUID
	for rows.Next() {
		var raw string
		if err := rows.Scan(&raw); err != nil {
			rows.Close()
			return nil, err
		}
		id, err := parseID(raw)
		if err != nil {
			rows.Close()
			return nil, err
		}
		ids = append(ids, id)
	}
	err = rows.Err()
	rows.Close()
	if err != nil {
		return nil, err
	}
	result := make([]application2.DraftView, 0, len(ids))
	for _, id := range ids {
		view, err := r.GetDraft(ctx, id)
		if err != nil {
			return nil, err
		}
		result = append(result, view)
	}
	return result, nil
}

func (r ReadStore) GetDraft(ctx context.Context, id uuid.UUID) (application2.DraftView, error) {
	draft, err := (Drafts{Store: r.Store}).GetByID(ctx, id)
	if err != nil {
		return application2.DraftView{}, err
	}
	view := application2.DraftView{ID: draft.ID(), Title: draft.Title().String(), Model: draft.Model(), CustomPrompt: draft.Prompt(), Status: string(draft.Status()), SourceType: string(draft.Material().Type()), CreatedAt: draft.CreatedAt(), UpdatedAt: draft.UpdatedAt(), LessonData: application2.LessonToView(draft.Lesson())}
	if value := draft.ErrorString(); value != nil {
		view.ErrorMessage = *value
	}
	if source, ok := draft.Material().(lesson.YouTubeMaterial); ok {
		view.SourceURL = source.SourceURL()
	}
	return view, nil
}

func (r ReadStore) ListAssignments(ctx context.Context) ([]application2.AssignmentSummary, error) {
	rows, err := r.Store.DB.QueryContext(ctx, `SELECT id FROM assignments ORDER BY assigned_at DESC`)
	if err != nil {
		return nil, err
	}
	var ids []uuid.UUID
	for rows.Next() {
		var raw string
		if err := rows.Scan(&raw); err != nil {
			rows.Close()
			return nil, err
		}
		id, err := parseID(raw)
		if err != nil {
			rows.Close()
			return nil, err
		}
		ids = append(ids, id)
	}
	err = rows.Err()
	rows.Close()
	if err != nil {
		return nil, err
	}
	result := make([]application2.AssignmentSummary, 0, len(ids))
	for _, id := range ids {
		detail, err := r.GetAssignment(ctx, id)
		if err != nil {
			return nil, err
		}
		summary := application2.AssignmentSummary{AssignmentID: detail.AssignmentID, StudentID: detail.StudentID, StudentName: detail.StudentName, Title: detail.Title, Status: detail.Status, AssignedAt: detail.AssignedAt, StudentPageWebURL: detail.StudentPageWebURL, TeacherPageWebURL: detail.TeacherPageWebURL, TotalCount: len(detail.Items)}
		for _, item := range detail.Items {
			if item.IsEvaluated {
				summary.GradedCount++
				if item.Outcome == string(assignment.EvaluationCorrect) {
					summary.CorrectCount++
				}
			}
		}
		result = append(result, summary)
	}
	return result, nil
}

func (r ReadStore) GetAssignment(ctx context.Context, id uuid.UUID) (application2.AssignmentDetailView, error) {
	a, err := (Assignments{Store: r.Store}).GetByID(ctx, id)
	if err != nil {
		return application2.AssignmentDetailView{}, err
	}
	studentView, err := r.studentView(ctx, a.StudentID())
	if err != nil {
		return application2.AssignmentDetailView{}, err
	}
	view := application2.AssignmentDetailView{AssignmentID: a.ID(), StudentID: a.StudentID(), StudentName: studentView.Name, Title: a.Title(), Status: string(a.Status()), AssignedAt: a.AssignedAt(), Items: make([]application2.AssignmentItemView, 0, len(a.Items()))}
	switch purpose := a.Purpose().(type) {
	case assignment.AssignmentPurposeNormal:
		view.Purpose = "normal"
	case assignment.AssignmentPurposeRemediation:
		view.Purpose = "remediation"
		id := purpose.MistakeID()
		view.OriginMistakeID = &id
	}
	links := OneNoteLinks{Store: r.Store}
	if link, ok, err := links.GetPage(ctx, id, "student"); err != nil {
		return application2.AssignmentDetailView{}, err
	} else if ok {
		view.StudentPageWebURL = link.PageURL
	}
	if link, ok, err := links.GetPage(ctx, id, "teacher"); err != nil {
		return application2.AssignmentDetailView{}, err
	} else if ok {
		view.TeacherPageWebURL = link.PageURL
	}
	for _, item := range a.Items() {
		view.Items = append(view.Items, application2.ItemToView(item))
	}
	return view, nil
}

func (r ReadStore) ListMistakeGroups(ctx context.Context) ([]application2.StudentMistakeGroup, error) {
	rows, err := r.Store.DB.QueryContext(ctx, `SELECT DISTINCT student_id FROM mistakes ORDER BY student_id`)
	if err != nil {
		return nil, err
	}
	var ids []uuid.UUID
	for rows.Next() {
		var raw string
		if err := rows.Scan(&raw); err != nil {
			rows.Close()
			return nil, err
		}
		id, err := parseID(raw)
		if err != nil {
			rows.Close()
			return nil, err
		}
		ids = append(ids, id)
	}
	err = rows.Err()
	rows.Close()
	if err != nil {
		return nil, err
	}
	sources, err := r.assignmentItemSources(ctx)
	if err != nil {
		return nil, err
	}
	groups := make([]application2.StudentMistakeGroup, 0, len(ids))
	for _, id := range ids {
		stu, err := r.studentView(ctx, id)
		if err != nil {
			return nil, err
		}
		graph, err := (Graphs{Store: r.Store}).GetByStudentID(ctx, id)
		if err != nil {
			return nil, err
		}
		group := application2.StudentMistakeGroup{StudentID: id, StudentName: stu.Name, Mistakes: make([]application2.MistakeNodeView, 0)}
		for _, root := range graph.Roots() {
			group.Mistakes = append(group.Mistakes, nodeView(root, sources))
		}
		if len(group.Mistakes) > 0 {
			groups = append(groups, group)
		}
	}
	return groups, nil
}

func nodeView(node *mistake.Mistake, sources map[uuid.UUID]uuid.UUID) application2.MistakeNodeView {
	view := application2.MistakeNodeView{ID: node.ID(), Topic: node.Topic(), Reason: node.Reason(), Status: string(node.Status()), CreatedAt: node.CreatedAt(), ResolvedAt: node.ResolvedAt(), SourceItemID: node.AssignmentItemID(), Children: make([]application2.MistakeNodeView, 0, len(node.Children()))}
	if assignmentID, ok := sources[node.AssignmentItemID()]; ok {
		view.SourceAssignmentID = &assignmentID
	}
	for _, child := range node.Children() {
		view.Children = append(view.Children, nodeView(child, sources))
	}
	return view
}

func (r ReadStore) assignmentItemSources(ctx context.Context) (map[uuid.UUID]uuid.UUID, error) {
	rows, err := r.Store.DB.QueryContext(ctx, `SELECT id,items_json FROM assignments`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	result := make(map[uuid.UUID]uuid.UUID)
	for rows.Next() {
		var idRaw, itemsRaw string
		if err := rows.Scan(&idRaw, &itemsRaw); err != nil {
			return nil, err
		}
		id, err := parseID(idRaw)
		if err != nil {
			return nil, err
		}
		var items []struct {
			ID uuid.UUID `json:"id"`
		}
		if err := json.Unmarshal([]byte(itemsRaw), &items); err != nil {
			return nil, err
		}
		for _, item := range items {
			result[item.ID] = id
		}
	}
	return result, rows.Err()
}

// func (r ReadStore) GetDocument(ctx context.Context, id uuid.UUID) (application2.DocumentView, error) {
// 	doc, err := (Documents{Store: r.Store}).GetByID(ctx, id)
// 	if err != nil {
// 		return application2.DocumentView{}, err
// 	}
// 	view := application2.DocumentView{ID: doc.ID(), FileName: doc.OriginalFileName(), Status: string(doc.Status()), PageCount: doc.TotalPages(), PreviewURLs: append([]string(nil), doc.PagePreviewURLs()...)}
// 	if doc.ErrorReason() != nil {
// 		view.ErrorReason = doc.ErrorReason().Error()
// 	}
// 	return view, nil
// }

func (r ReadStore) ListDocuments(ctx context.Context) ([]application2.Document, error) {
	rows, err := r.Store.DB.QueryContext(ctx, `SELECT id,file_name,storage_path,page_count,created_at FROM documents ORDER BY created_at DESC`)
	if err != nil {
		return nil, err
	}
	var result []application2.Document
	for rows.Next() {
		doc := application2.Document{}
		if err := rows.Scan(&doc.ID, &doc.FileName, &doc.FilePath, &doc.PageCount, &doc.CreatedAt); err != nil {
			rows.Close()
			return nil, err
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

// var _ application2.ReadRepository = ReadStore{}
