package application2

import (
	"context"
	"strings"
	"uuid"

	"meet-attendance-clean/domain2/assignment"
	kernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
)

type ReadRepository interface {
	Dashboard(context.Context, StudentFilter) (DashboardView, error)
	StudentDetail(context.Context, uuid.UUID, MeetingFilter) (StudentDetailView, error)
	ListDrafts(context.Context) ([]DraftView, error)
	GetDraft(context.Context, uuid.UUID) (DraftView, error)
	ListAssignments(context.Context) ([]AssignmentSummary, error)
	GetAssignment(context.Context, uuid.UUID) (AssignmentDetailView, error)
	ListMistakeGroups(context.Context) ([]StudentMistakeGroup, error)
	ListStudentChoices(context.Context) ([]StudentView, error)
}
type Queries struct{ repo ReadRepository }

func NewQueries(repo ReadRepository) *Queries { return &Queries{repo} }
func (q *Queries) GetDashboard(c context.Context, f StudentFilter) (DashboardView, error) {
	return q.repo.Dashboard(c, f)
}
func (q *Queries) GetStudentDetail(c context.Context, id uuid.UUID, f MeetingFilter) (StudentDetailView, error) {
	return q.repo.StudentDetail(c, id, f)
}
func (q *Queries) ListLessonDrafts(c context.Context) ([]DraftView, error) {
	return q.repo.ListDrafts(c)
}
func (q *Queries) GetLessonDraft(c context.Context, id uuid.UUID) (DraftView, error) {
	return q.repo.GetDraft(c, id)
}
func (q *Queries) ListStudentChoices(c context.Context) ([]StudentView, error) {
	return q.repo.ListStudentChoices(c)
}
func (q *Queries) GetAssignment(c context.Context, id uuid.UUID) (AssignmentDetailView, error) {
	return q.repo.GetAssignment(c, id)
}
func (q *Queries) ListMistakes(c context.Context) ([]StudentMistakeGroup, error) {
	return q.repo.ListMistakeGroups(c)
}
func (q *Queries) ListGradingPages(c context.Context, search string) ([]AssignmentSummary, error) {
	rows, e := q.repo.ListAssignments(c)
	if e != nil {
		return nil, e
	}
	n := strings.ToLower(strings.TrimSpace(search))
	if n == "" {
		return rows, nil
	}
	out := make([]AssignmentSummary, 0, len(rows))
	for _, r := range rows {
		if strings.Contains(strings.ToLower(r.Title+" "+r.StudentName), n) {
			out = append(out, r)
		}
	}
	return out, nil
}

func LessonToView(v *lesson.Lesson) *LessonView {
	if v == nil {
		return nil
	}
	out := &LessonView{ID: v.ID(), Title: v.Title().String(), Overview: v.Overview().String(), Sections: make([]SectionView, 0, len(v.Sections())), Exercises: make([]ExerciseView, 0, len(v.Exercises()))}
	for _, s := range v.Sections() {
		topics := make([]TopicView, 0, len(s.Topics()))
		for _, t := range s.Topics() {
			blocks := make([]BlockView, 0, len(t.Blocks()))
			for _, b := range t.Blocks() {
				blocks = append(blocks, blockToView(b))
			}
			topics = append(topics, TopicView{Title: t.Title().String(), Blocks: blocks})
		}
		out.Sections = append(out.Sections, SectionView{Title: s.Title().String(), Topics: topics})
	}
	for _, e := range v.Exercises() {
		out.Exercises = append(out.Exercises, ExerciseToView(e))
	}
	return out
}
func blockToView(b lesson.Block) BlockView {
	out := BlockView{Type: string(b.BlockType())}
	switch x := b.(type) {
	case lesson.ParagraphBlock:
		out.Body = x.Body().String()
	case lesson.ListBlock:
		out.Ordered = x.IsOrdered()
		for _, i := range x.Items() {
			out.Items = append(out.Items, i.String())
		}
	case lesson.FormulaBlock:
		out.Math = x.Math()
	case lesson.ExampleBlock:
		out.Title = x.Title().String()
		out.Problem = x.Problem().String()
		out.Solution = x.Solution().String()
		out.Explanation = x.Explanation().String()
	case lesson.ImageBlock:
		out.SVG = x.SVG()
		out.Caption = x.Caption().String()
	case lesson.ClozeBlock:
		out.Body = x.Instruction().String()
		for _, i := range x.Items() {
			parts := make([]ClozePartView, 0, len(i.Parts))
			for _, p := range i.Parts {
				parts = append(parts, ClozePartView{Type: string(p.Type), Value: p.Value})
			}
			out.ClozeItems = append(out.ClozeItems, parts)
		}
	case lesson.CalloutBlock:
		out.CalloutKind = string(x.Kind())
		out.Title = x.Title().String()
		out.Body = x.Body().String()
	}
	return out
}
func ExerciseToView(ex kernel.Exercise) ExerciseView {
	d := ex.Diagram()
	v := ExerciseView{Type: string(ex.Type()), Topic: ex.Topic(), Difficulty: ex.Difficulty(), Question: ex.Prompt().String(), DiagramType: string(d.Type()), DiagramContent: d.Content()}
	switch x := ex.(type) {
	case kernel.MultipleChoiceExercise:
		v.Answer = x.Answer()
		v.Explanation = x.Solution().String()
		for _, o := range x.Options() {
			v.Options = append(v.Options, OptionView{Label: o.Label(), Content: o.Content().String()})
		}
	case kernel.EssayExercise:
		for _, p := range x.Parts() {
			v.Parts = append(v.Parts, EssayPartView{Label: p.Label(), Question: p.Question().String(), Solution: p.Solution().String(), Rubric: p.Rubric().String()})
		}
	}
	return v
}
func ItemToView(item assignment.AssignmentItem) AssignmentItemView {
	ok, reason := item.IsValid()
	v := AssignmentItemView{ID: item.ID(), Exercise: ExerciseToView(item.Exercise()), IsEvaluated: item.IsEvaluated(), IsValid: ok, InvalidReason: reason, OutputResult: item.OutputResult(), Comment: item.Comment(), SubItems: make([]EssayPartResultView, 0)}
	switch x := item.Inner().(type) {
	case *assignment.MCQAssignmentItem:
		if a := x.Answer(); a != nil {
			v.Answer = &AnswerView{SelectedOption: a.SelectedOption(), Text: a.WorkingText(), HasImages: len(a.WorkingData()) > 0}
		}
		if e := x.Evaluation(); e != nil {
			v.Outcome = string(e.Outcome())
		}
	case *assignment.EssayAssigmentItem:
		if a := x.Answer(); a != nil {
			v.Answer = &AnswerView{Text: a.Text(), HasImages: len(a.Data()) > 0, TargetParts: a.TargetParts()}
		}
		if e := x.Evaluation(); e != nil {
			v.Outcome = string(e.Outcome())
		}
		for _, s := range x.SubItems() {
			v.SubItems = append(v.SubItems, EssayPartResultView{Label: s.Label(), Selected: s.IsSelected(), Correct: s.IsCorrect(), Comment: s.Comment()})
		}
	}
	return v
}
