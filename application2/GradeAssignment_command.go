package application2

import (
	"context"
	"errors"
	"fmt"

	"meet-attendance-clean/domain2/assignment"
	"meet-attendance-clean/domain2/mistake"
	"uuid"
)

type AssignmentRepo interface {
	GetByID(ctx context.Context, assignmentID uuid.UUID) (*assignment.Assignment, error)
	Save(ctx context.Context, a *assignment.Assignment) error
}

type MistakeGraphRepo interface {
	GetByStudentID(ctx context.Context, studentID uuid.UUID) (*mistake.MistakeGraph, error)
	Save(ctx context.Context, graph *mistake.MistakeGraph) error
}

type WorkSpaceGateway interface {
	FetchStudentSubmission(ctx context.Context, assignmentID uuid.UUID) ([]byte, []assignment.Answer, error)
	PatchFeedback(ctx context.Context, assignmentID uuid.UUID, items []assignment.AssignmentItem) error
}

type Grader interface {
	Evaluate(ctx context.Context, gradeItems []assignment.EvaluationRequest, pageInk []byte, prompt string, model string) ([]assignment.EvaluationResult, error)
}

type GradeAssignmentCommand struct {
	AssignmentID uuid.UUID
	ItemIDs      []uuid.UUID
	Prompt       string
	Model        string
}

type GradeAssignmentUsecase struct {
	assignmentRepo   AssignmentRepo
	mistakeGraphRepo MistakeGraphRepo
	workspaceGateway WorkSpaceGateway
	grader           Grader
}

func NewGradeAssignmentUsecase(assignmentRepo AssignmentRepo, mistakeGraphRepo MistakeGraphRepo, workspaceGateway WorkSpaceGateway, grader Grader) *GradeAssignmentUsecase {
	return &GradeAssignmentUsecase{
		assignmentRepo:   assignmentRepo,
		mistakeGraphRepo: mistakeGraphRepo,
		workspaceGateway: workspaceGateway,
		grader:           grader,
	}
}

func (u *GradeAssignmentUsecase) Grade(ctx context.Context, cmd GradeAssignmentCommand) error {
	a, err := u.assignmentRepo.GetByID(ctx, cmd.AssignmentID)
	if err != nil {
		return fmt.Errorf("không thể tìm thấy assignment: %w", err)
	}

	pageInk, answers, err := u.workspaceGateway.FetchStudentSubmission(ctx, a.ID())
	if err != nil {
		return fmt.Errorf("không thể lấy bài làm của học sinh: %w", err)
	}

	if err := a.AddAnswers(answers); err != nil {
		return fmt.Errorf("dữ liệu bài làm không hợp lệ: %w", err)
	}

	evalRequests := a.ListEvalReqs(cmd.ItemIDs)
	if len(evalRequests) == 0 {
		return errors.New("không có câu hỏi nào hợp lệ để chấm")
	}

	evaluations, err := u.grader.Evaluate(ctx, evalRequests, pageInk, cmd.Prompt, cmd.Model)
	if err != nil {
		return fmt.Errorf("không thể chấm bài bằng AI: %w", err)
	}

	detectedMistakes, err := a.ApplyEvalResults(evaluations)
	if err != nil {
		return fmt.Errorf("không thể áp dụng kết quả chấm: %w", err)
	}

	if err := u.handleMistakeGraph(ctx, a, detectedMistakes); err != nil {
		return err
	}

	if err := u.assignmentRepo.Save(ctx, a); err != nil {
		return fmt.Errorf("không thể lưu kết quả assignment: %w", err)
	}

	if err := u.workspaceGateway.PatchFeedback(ctx, a.ID(), a.Items()); err != nil {
		return fmt.Errorf("không thể đồng bộ feedback sang workspace: %w", err)
	}

	return nil
}

func (u *GradeAssignmentUsecase) handleMistakeGraph(ctx context.Context, a *assignment.Assignment, detectedMistakes []assignment.DetectedMistake) error {
	var remediationMistakeID *uuid.UUID

	switch purpose := a.Purpose().(type) {
	case assignment.AssignmentPurposeNormal:
	case assignment.AssignmentPurposeRemediation:
		id := purpose.MistakeID()
		remediationMistakeID = &id
	default:
		return errors.New("assignment purpose không hợp lệ")
	}

	shouldResolve := remediationMistakeID != nil && a.IsCorrect() && len(detectedMistakes) == 0

	if len(detectedMistakes) == 0 && !shouldResolve {
		return nil
	}

	graph, err := u.mistakeGraphRepo.GetByStudentID(ctx, a.StudentID())
	if err != nil {
		return fmt.Errorf("không thể lấy mistake graph của học sinh: %w", err)
	}

	for _, detectedMistake := range detectedMistakes {
		if _, err := graph.RegisterMistake(
			remediationMistakeID,
			detectedMistake.Topic(),
			detectedMistake.Reason(),
			detectedMistake.AssignmentItemID(),
		); err != nil {
			return fmt.Errorf("không thể đăng ký mistake mới: %w", err)
		}
	}

	if shouldResolve {
		if err := graph.Resolve(*remediationMistakeID); err != nil {
			return fmt.Errorf("không thể resolve mistake: %w", err)
		}
	}

	if err := u.mistakeGraphRepo.Save(ctx, graph); err != nil {
		return fmt.Errorf("không thể lưu mistake graph: %w", err)
	}

	return nil
}
