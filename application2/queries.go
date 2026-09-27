package application2

import (
	"context"
	"strings"
	"uuid"

	"meet-attendance-clean/domain2/assignment"
	exercise "meet-attendance-clean/domain2/excercise"
	"meet-attendance-clean/domain2/lesson"
)

type ReadRepository interface {
	Dashboard(ctx context.Context, filter StudentFilter) (DashboardView, error)
	StudentDetail(ctx context.Context, id uuid.UUID, filter MeetingFilter) (StudentDetailView, error)
	ListDrafts(ctx context.Context) ([]DraftView, error)
	GetDraft(ctx context.Context, id uuid.UUID) (DraftView, error)
	ListAssignments(ctx context.Context) ([]AssignmentSummary, error)
	GetAssignment(ctx context.Context, id uuid.UUID) (AssignmentDetailView, error)
	ListMistakeGroups(ctx context.Context) ([]StudentMistakeGroup, error)
	ListStudentChoices(ctx context.Context) ([]StudentView, error)
	// GetDocument(ctx context.Context, id uuid.UUID) (DocumentView, error)
	// ListDocuments(ctx context.Context) ([]DocumentView, error)
}

type Queries struct{ repo ReadRepository }

func NewQueries(repo ReadRepository) *Queries { return &Queries{repo: repo} }
func (q *Queries) GetDashboard(ctx context.Context, filter StudentFilter) (DashboardView, error) {
	return q.repo.Dashboard(ctx, filter)
}
func (q *Queries) GetStudentDetail(ctx context.Context, id uuid.UUID, filter MeetingFilter) (StudentDetailView, error) {
	return q.repo.StudentDetail(ctx, id, filter)
}
func (q *Queries) ListLessonDrafts(ctx context.Context) ([]DraftView, error) {
	return q.repo.ListDrafts(ctx)
}
func (q *Queries) GetLessonDraft(ctx context.Context, id uuid.UUID) (DraftView, error) {
	return q.repo.GetDraft(ctx, id)
}
func (q *Queries) ListStudentChoices(ctx context.Context) ([]StudentView, error) {
	return q.repo.ListStudentChoices(ctx)
}

//	func (q *Queries) GetDocument(ctx context.Context, id uuid.UUID) (DocumentView, error) {
//		return q.repo.GetDocument(ctx, id)
//	}
//
//	func (q *Queries) ListDocuments(ctx context.Context) ([]DocumentView, error) {
//		return q.repo.ListDocuments(ctx)
//	}
func (q *Queries) GetAssignment(ctx context.Context, id uuid.UUID) (AssignmentDetailView, error) {
	return q.repo.GetAssignment(ctx, id)
}
func (q *Queries) ListMistakes(ctx context.Context) ([]StudentMistakeGroup, error) {
	return q.repo.ListMistakeGroups(ctx)
}
func (q *Queries) ListGradingPages(ctx context.Context, search string) ([]AssignmentSummary, error) {
	rows, err := q.repo.ListAssignments(ctx)
	if err != nil {
		return nil, err
	}
	needle := strings.ToLower(strings.TrimSpace(search))
	if needle == "" {
		return rows, nil
	}
	filtered := make([]AssignmentSummary, 0, len(rows))
	for _, row := range rows {
		if strings.Contains(strings.ToLower(row.Title+" "+row.StudentName), needle) {
			filtered = append(filtered, row)
		}
	}
	return filtered, nil
}

func LessonToView(value *lesson.Lesson) *LessonView {
	if value == nil {
		return nil
	}
	view := &LessonView{ID: value.ID(), Title: value.Title(), Overview: value.Overview(), Sections: make([]SectionView, 0), Exercises: make([]ExerciseView, 0)}
	for _, sec := range value.Sections() {
		v := SectionView{SectionTitle: sec.SectionTitle, TransitionIntro: sec.TransitionIntro, DetailedContent: sec.DetailedContent, KeyTakeaway: sec.KeyTakeaway, StudentClozeNotes: sec.StudentClozeNotes}
		for _, eg := range sec.TeacherExamples {
			v.TeacherExamples = append(v.TeacherExamples, TeacherExampleView{ExampleNum: eg.ExampleNum, Problem: eg.Problem, TeacherSolution: eg.TeacherSolution, StudentFriendlyExplanation: eg.StudentFriendlyExplanation, CommonMistake: eg.CommonMistake})
		}
		view.Sections = append(view.Sections, v)
	}
	for _, ex := range value.Exercises() {
		view.Exercises = append(view.Exercises, ExerciseToView(ex))
	}
	return view
}

func ExerciseToView(ex exercise.Exercise) ExerciseView {
	v := ExerciseView{Type: string(ex.Type()), Topic: ex.Topic(), Difficulty: ex.Difficulty(), Question: ex.Prompt()}
	switch typed := ex.(type) {
	case exercise.MultipleChoiceExercise:
		v.Answer, v.Explanation = typed.Answer(), typed.Solution()
		for _, opt := range typed.Options() {
			v.Options = append(v.Options, OptionView{Label: opt.Label(), Content: opt.Content()})
		}
	case exercise.EssayExercise:
		for _, part := range typed.Parts() {
			v.Parts = append(v.Parts, EssayPartView{Label: part.Label(), Question: part.Question(), Solution: part.Solution(), Rubric: part.Rubric()})
		}
		if len(v.Parts) > 0 {
			v.Answer = v.Parts[0].Solution
			v.Explanation = v.Parts[0].Rubric
		}
	}
	return v
}

func ItemToView(item assignment.AssignmentItem) AssignmentItemView {
	state := item.State()
	valid, reason := item.IsValid()
	v := AssignmentItemView{ID: item.ID(), Exercise: ExerciseToView(item.Exercise()), IsEvaluated: item.IsEvaluated(), IsValid: valid, InvalidReason: reason, OutputResult: item.OutputResult(), Comment: item.Comment()}
	if state.Evaluation != nil {
		v.Outcome = string(state.Evaluation.Outcome)
	}
	switch a := state.Answer.(type) {
	case assignment.MCQAnswer:
		v.Answer = &AnswerView{SelectedOption: a.SelectedOption(), Text: a.WorkingText(), HasImages: len(a.WorkingData()) > 0}
	case assignment.EssayAnswer:
		v.Answer = &AnswerView{Text: a.Text(), HasImages: len(a.Data()) > 0, TargetParts: a.TargetParts()}
	}
	for _, sub := range state.SubItems {
		v.SubItems = append(v.SubItems, EssayPartResultView{Label: sub.Label, Selected: sub.Selected, Correct: sub.Correct, Comment: sub.Comment})
	}
	return v
}
