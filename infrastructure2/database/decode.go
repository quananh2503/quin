package database

import (
	"encoding/json"
	"errors"
	"fmt"
	"meet-attendance-clean/domain2/assignment"
	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/domain2/mistake"
	"uuid"
)

func decodeContent(r contentRecord) sharekernel.Content {
	p := make([]sharekernel.InlinePart, len(r.InlineParts))
	for i, v := range r.InlineParts {
		p[i] = sharekernel.InlinePart{Type: v.Type, Value: v.Value}
	}
	return sharekernel.NewContent(p...)
}
func decodeMaterial(r materialRecord) (lesson.StudyMaterial, error) {
	switch r.Type {
	case string(lesson.MaterialYouTube):
		if r.URL == nil {
			return nil, errors.New("youtube material thiếu URL")
		}
		return lesson.NewYouTubeMaterial(*r.URL)
	case string(lesson.MaterialPDF):
		if r.Path == nil {
			return nil, errors.New("pdf material thiếu path")
		}
		return lesson.NewSlicedPDFMaterial(*r.Path, r.Pages)
	case string(lesson.MaterialMistake):
		if r.MistakeID == nil || r.StudentID == nil {
			return nil, errors.New("mistake material thiếu ID")
		}
		return lesson.NewMistakeMaterial(*r.StudentID, *r.MistakeID, r.Topic, r.Reason, r.Context), nil
	default:
		return nil, fmt.Errorf("material không hỗ trợ: %q", r.Type)
	}
}
func decodeExercise(r exerciseRecord) (sharekernel.Exercise, error) {
	d := sharekernel.NewDiagram(sharekernel.DiagramType(r.Diagram.Type), r.Diagram.Content)
	switch r.Type {
	case string(sharekernel.ExerciseTypeMultipleChoice):
		o := make([]sharekernel.MCOption, 0, len(r.Options))
		for _, v := range r.Options {
			x, e := sharekernel.NewMCOption(v.Label, decodeContent(v.Content))
			if e != nil {
				return nil, e
			}
			o = append(o, x)
		}
		sol := sharekernel.Content{}
		if r.Solution != nil {
			sol = decodeContent(*r.Solution)
		}
		return sharekernel.NewMultipleChoiceExercise(r.Topic, r.Difficulty, decodeContent(r.Prompt), o, r.Answer, sol, d)
	case string(sharekernel.ExerciseTypeEssay):
		p := make([]sharekernel.EssayPart, 0, len(r.Parts))
		for _, v := range r.Parts {
			p = append(p, sharekernel.NewEssayPart(v.Label, decodeContent(v.Question), decodeContent(v.Solution), decodeContent(v.Rubric)))
		}
		return sharekernel.NewEssayExercise(r.Topic, r.Difficulty, decodeContent(r.Prompt), p, d)
	default:
		return nil, fmt.Errorf("exercise không hỗ trợ: %q", r.Type)
	}
}
func decodeBlock(r blockRecord) (lesson.Block, error) {
	c := func(v *contentRecord) (sharekernel.Content, error) {
		if v == nil {
			return sharekernel.Content{}, errors.New("block thiếu content")
		}
		return decodeContent(*v), nil
	}
	switch r.Type {
	case string(lesson.BlockParagraph):
		v, e := c(r.Body)
		return lesson.ReconstituteParagraphBlock(v), e
	case string(lesson.BlockList):
		if r.IsOrdered == nil {
			return nil, errors.New("list thiếu is_ordered")
		}
		a := make([]sharekernel.Content, len(r.Items))
		for i, v := range r.Items {
			a[i] = decodeContent(v)
		}
		return lesson.ReconstituteListBlock(*r.IsOrdered, a), nil
	case string(lesson.BlockFormula):
		return lesson.ReconstituteFormulaBlock(r.Math), nil
	case string(lesson.BlockExample):
		a, e := c(r.Title)
		if e != nil {
			return nil, e
		}
		b, e := c(r.Problem)
		if e != nil {
			return nil, e
		}
		d, e := c(r.Solution)
		if e != nil {
			return nil, e
		}
		f, e := c(r.Explanation)
		return lesson.ReconstituteExampleBlock(a, b, d, f), e
	case string(lesson.BlockImage):
		a, e := c(r.Caption)
		return lesson.ReconstituteImageBlock(r.SVG, a), e
	case string(lesson.BlockCallout):
		a, e := c(r.Title)
		if e != nil {
			return nil, e
		}
		b, e := c(r.CalloutBody)
		return lesson.ReconstituteCalloutBlock(lesson.CalloutKind(r.CalloutKind), a, b), e
	default:
		return nil, fmt.Errorf("block không hỗ trợ: %q", r.Type)
	}
}
func decodeLesson(raw []byte) (*lesson.Lesson, error) {
	var r lessonRecord
	if e := json.Unmarshal(raw, &r); e != nil {
		return nil, e
	}
	m, e := decodeMaterial(r.Material)
	if e != nil {
		return nil, e
	}
	xs := make([]sharekernel.Exercise, 0, len(r.Exercises))
	for _, x := range r.Exercises {
		v, e := decodeExercise(x)
		if e != nil {
			return nil, e
		}
		xs = append(xs, v)
	}
	ss := make([]lesson.Section, 0, len(r.Sections))
	for _, s := range r.Sections {
		ts := make([]lesson.Topic, 0, len(s.Topics))
		for _, t := range s.Topics {
			bs := make([]lesson.Block, 0, len(t.Blocks))
			for _, b := range t.Blocks {
				v, e := decodeBlock(b)
				if e != nil {
					return nil, e
				}
				bs = append(bs, v)
			}
			ts = append(ts, lesson.ReconstituteTopic(decodeContent(t.Title), bs))
		}
		ss = append(ss, lesson.ReconstituteSection(decodeContent(s.Title), ts))
	}
	return lesson.ReconstituteLesson(r.ID, decodeContent(r.Title), decodeContent(r.Overview), ss, xs, m)
}
func decodeItems(raw []byte) ([]assignment.AssignmentItem, error) {
	var rs []itemRecord
	if e := json.Unmarshal(raw, &rs); e != nil {
		return nil, e
	}
	out := make([]assignment.AssignmentItem, 0, len(rs))
	for _, r := range rs {
		x, e := decodeExercise(r.Exercise)
		if e != nil {
			return nil, e
		}
		var ev *assignment.ItemEvaluation
		if r.Evaluation != nil {
			ev = assignment.ReconstituteEvaluation(assignment.EvaluationOutcome(r.Evaluation.Outcome), r.Evaluation.Comment)
		}
		switch ex := x.(type) {
		case sharekernel.MultipleChoiceExercise:
			var a *assignment.MCQAnswer
			if r.Answer != nil {
				v, e := assignment.NewMCQAnswer(r.ID, r.Answer.SelectedOption, r.Answer.Text, r.Answer.Data)
				if e != nil {
					return nil, e
				}
				a = &v
			}
			out = append(out, assignment.ReconstituteMCQItem(r.ID, ex, a, ev))
		case sharekernel.EssayExercise:
			var a *assignment.EssayAnswer
			if r.Answer != nil {
				v, e := assignment.NewEssayAnswer(r.ID, r.Answer.Text, r.Answer.Data, r.Answer.TargetParts)
				if e != nil {
					return nil, e
				}
				a = &v
			}
			s := make([]assignment.EssaySubItem, len(r.SubItems))
			for i, v := range r.SubItems {
				s[i] = assignment.EssaySubItem{Label: v.Label, IsSelected: v.IsSelected, IsCorrect: v.IsCorrect, Comment: v.Comment}
			}
			out = append(out, assignment.ReconstituteEssayItem(r.ID, ex, a, s, ev))
		default:
			return nil, fmt.Errorf("exercise không hỗ trợ: %T", x)
		}
	}
	return out, nil
}
func decodeMistakeGraph(studentID uuid.UUID, rs []mistakeRecord) (*mistake.MistakeGraph, error) {
	nodes := map[uuid.UUID]*mistake.Mistake{}
	for _, r := range rs {
		nodes[r.ID] = mistake.ReconstituteMistake(r.ID, r.Topic, r.Reason, r.AssignmentItemID, mistake.MistakeStatus(r.Status), r.CreatedAt, r.ResolvedAt)
	}
	roots := []*mistake.Mistake{}
	for _, r := range rs {
		if r.ParentID == nil {
			roots = append(roots, nodes[r.ID])
			continue
		}
		p, ok := nodes[*r.ParentID]
		if !ok {
			return nil, fmt.Errorf("không tìm thấy parent %s", *r.ParentID)
		}
		p.AppendChild(nodes[r.ID])
	}
	return mistake.ReconstituteMistakeGraph(studentID, roots), nil
}
