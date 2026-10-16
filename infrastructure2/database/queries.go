package database

import (
	"context"
	"encoding/json"
	"path/filepath"
	"strings"
	"uuid"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/infrastructure2/database/dbgen"

	// "meet-attendance-clean/database/dbgen"
	// "meet-attendance-clean/database/dbgen"
	// "meet-attendance-clean/database/dbgen"
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
	view := application2.StudentView{
		ID:            value.ID(),
		Name:          value.Name(),
		Class:         value.Class(),
		CycleStartDay: value.CycleStartDay(),
		CreatedAt:     value.CreatedAt(),
	}

	q := dbgen.New(r.Store.DB)
	if row, err := q.GetMeetLinkByStudentID(ctx, id.String()); err == nil {
		view.MeetingCode = row.MeetingCode
		view.SpaceName = row.SpaceName
	}
	return view, nil
}

func (r ReadStore) ListStudentChoices(ctx context.Context) ([]application2.StudentView, error) {
	q := dbgen.New(r.Store.DB)
	idsRaw, err := q.ListStudentIDs(ctx)
	if err != nil {
		return nil, err
	}

	result := make([]application2.StudentView, 0, len(idsRaw))
	for _, raw := range idsRaw {
		id, err := parseID(raw)
		if err != nil {
			return nil, err
		}
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
		meetings, err := r.meetings(ctx, stu.ID, application2.MeetingFilter{
			FromDate:           filter.FromDate,
			ToDate:             filter.ToDate,
			MinDurationMinutes: filter.MinDurationMinutes,
		})
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
	q := dbgen.New(r.Store.DB)
	rows, err := q.ListSessionsByStudentID(ctx, studentID.String())
	if err != nil {
		return nil, err
	}

	result := make([]application2.MeetingView, 0)
	for _, row := range rows {
		id, err := parseID(row.ID)
		if err != nil {
			return nil, err
		}
		start, err := parseTime(row.StartAt)
		if err != nil {
			return nil, err
		}
		end, err := parseTime(row.EndAt)
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
		if err := json.Unmarshal([]byte(row.AttendanceJson), &records); err != nil {
			return nil, err
		}
		meeting := application2.MeetingView{
			ID:           id,
			StartedAt:    start,
			EndedAt:      end,
			Participants: make([]application2.ParticipantView, 0, len(records)),
		}
		for _, record := range records {
			meeting.Participants = append(meeting.Participants, application2.ParticipantView{
				Name:          record.Name,
				FirstJoinedAt: record.JoinedAt,
				LastLeftAt:    record.LeftAt,
				Duration:      record.Minutes,
			})
		}
		result = append(result, meeting)
	}
	return result, nil
}

func (r ReadStore) ListDrafts(ctx context.Context) ([]application2.DraftView, error) {
	q := dbgen.New(r.Store.DB)
	idsRaw, err := q.ListDraftIDs(ctx)
	if err != nil {
		return nil, err
	}

	result := make([]application2.DraftView, 0, len(idsRaw))
	for _, raw := range idsRaw {
		id, err := parseID(raw)
		if err != nil {
			return nil, err
		}
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

	q := dbgen.New(r.Store.DB)

	// Chuyển đổi danh sách materials sang MaterialView
	materialsView := make([]application2.MaterialView, 0, len(draft.Materials()))
	for _, m := range draft.Materials() {
		switch v := m.(type) {
		case lesson.YouTubeMaterial:
			materialsView = append(materialsView, application2.MaterialView{
				Type: string(lesson.MaterialYouTube),
				URL:  v.SourceURL(),
			})

		case lesson.PDFMaterial:
			matView := application2.MaterialView{
				Type:        string(lesson.MaterialPDF),
				PDFFilePath: v.FilePath(),
				PDFFileName: filepath.Base(v.FilePath()),
				PDFPages:    v.Pages(),
			}

			// Truy vấn thêm metadata của file PDF từ bảng documents (nếu có)
			docRow, err := q.GetDocumentByStoragePath(ctx, v.FilePath())
			if err == nil {
				if docID, parseErr := parseID(docRow.ID); parseErr == nil {
					matView.PDFDocumentID = &docID
					matView.PDFFileName = docRow.FileName
					matView.PDFPageCount = int(docRow.PageCount)
				}
			}

			materialsView = append(materialsView, matView)

		case lesson.MistakeMaterial:
			mID := v.MistakeID()
			sID := v.StudentID()
			materialsView = append(materialsView, application2.MaterialView{
				Type:      string(lesson.MaterialMistake),
				MistakeID: &mID,
				StudentID: &sID,
				Topic:     v.Topic(),
				Reason:    v.Reason(),
			})
		}
	}

	view := application2.DraftView{
		ID:           draft.ID(),
		Title:        draft.Title().String(),
		Model:        draft.Model(),
		CustomPrompt: draft.Prompt(),
		Status:       string(draft.Status()),
		Materials:    materialsView,
		CreatedAt:    draft.CreatedAt(),
		UpdatedAt:    draft.UpdatedAt(),
		LessonData:   application2.LessonToView(draft.Lesson()),
	}

	if value := draft.ErrorString(); value != nil {
		view.ErrorMessage = *value
	}

	return view, nil
}

func (r ReadStore) ListAssignments(ctx context.Context) ([]application2.AssignmentSummary, error) {
	q := dbgen.New(r.Store.DB)
	idsRaw, err := q.ListAssignmentIDs(ctx)
	if err != nil {
		return nil, err
	}

	result := make([]application2.AssignmentSummary, 0, len(idsRaw))
	for _, raw := range idsRaw {
		id, err := parseID(raw)
		if err != nil {
			return nil, err
		}
		detail, err := r.GetAssignment(ctx, id)
		if err != nil {
			return nil, err
		}
		summary := application2.AssignmentSummary{
			AssignmentID:      detail.AssignmentID,
			StudentID:         detail.StudentID,
			StudentName:       detail.StudentName,
			Title:             detail.Title,
			Status:            detail.Status,
			AssignedAt:        detail.AssignedAt,
			StudentPageWebURL: detail.StudentPageWebURL,
			TeacherPageWebURL: detail.TeacherPageWebURL,
			TotalCount:        len(detail.Items),
		}
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
	view := application2.AssignmentDetailView{
		AssignmentID: a.ID(),
		StudentID:    a.StudentID(),
		StudentName:  studentView.Name,
		Title:        a.Title(),
		Status:       string(a.Status()),
		AssignedAt:   a.AssignedAt(),
		Items:        make([]application2.AssignmentItemView, 0, len(a.Items())),
	}
	switch purpose := a.Purpose().(type) {
	case assignment.AssignmentPurposeNormal:
		view.Purpose = "normal"
	case assignment.AssignmentPurposeRemediation:
		view.Purpose = "remediation"
		pID := purpose.MistakeID()
		view.OriginMistakeID = &pID
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
	q := dbgen.New(r.Store.DB)
	idsRaw, err := q.ListDistinctMistakeStudentIDs(ctx)
	if err != nil {
		return nil, err
	}

	sources, err := r.assignmentItemSources(ctx)
	if err != nil {
		return nil, err
	}

	groups := make([]application2.StudentMistakeGroup, 0, len(idsRaw))
	for _, raw := range idsRaw {
		id, err := parseID(raw)
		if err != nil {
			return nil, err
		}
		stu, err := r.studentView(ctx, id)
		if err != nil {
			return nil, err
		}
		graph, err := (Graphs{Store: r.Store}).GetByStudentID(ctx, id)
		if err != nil {
			return nil, err
		}
		group := application2.StudentMistakeGroup{
			StudentID:   id,
			StudentName: stu.Name,
			Mistakes:    make([]application2.MistakeNodeView, 0),
		}
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
	view := application2.MistakeNodeView{
		ID:           node.ID(),
		Topic:        node.Topic(),
		Reason:       node.Reason(),
		Status:       string(node.Status()),
		CreatedAt:    node.CreatedAt(),
		ResolvedAt:   node.ResolvedAt(),
		SourceItemID: node.AssignmentItemID(),
		Children:     make([]application2.MistakeNodeView, 0, len(node.Children())),
	}
	if assignmentID, ok := sources[node.AssignmentItemID()]; ok {
		view.SourceAssignmentID = &assignmentID
	}
	for _, child := range node.Children() {
		view.Children = append(view.Children, nodeView(child, sources))
	}
	return view
}

func (r ReadStore) assignmentItemSources(ctx context.Context) (map[uuid.UUID]uuid.UUID, error) {
	q := dbgen.New(r.Store.DB)
	rows, err := q.ListAssignmentItemSources(ctx)
	if err != nil {
		return nil, err
	}

	result := make(map[uuid.UUID]uuid.UUID)
	for _, row := range rows {
		id, err := parseID(row.ID)
		if err != nil {
			return nil, err
		}
		var items []struct {
			ID uuid.UUID `json:"id"`
		}
		if err := json.Unmarshal([]byte(row.ItemsJson), &items); err != nil {
			return nil, err
		}
		for _, item := range items {
			result[item.ID] = id
		}
	}
	return result, nil
}

func (r ReadStore) ListDocuments(ctx context.Context) ([]application2.Document, error) {
	return (Documents{Store: r.Store}).List(ctx)
}
