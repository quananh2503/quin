package application2

import (
	"context"
	"errors"
	"fmt"
	"meet-attendance-clean/domain2/assignment"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/domain2/student"
	"uuid"
)

// ==========================================================
// 1. PORTS (INTERFACES CỦA TẦNG APPLICATION)
// ==========================================================

// WorkspacePublisherGateway: Cổng giao tiếp duy nhất ra bên ngoài (OneNote / Google Docs)
// Chú ý: Chỉ nhận các khái niệm thuần túy: StudentID (UUID), Lesson (Content), ChapterName, PageName.
type WorkspacePublisherGateway interface {
	PublishAssignment(
		ctx context.Context,
		a *assignment.Assignment,
		studentName string,
		lsn lesson.Lesson,
		studentChapterName string,
		teacherChapterName string,
		pageName string,
	) error
}
type StudentRepo interface {
	GetByID(ctx context.Context, id uuid.UUID) (*student.Student, error)
	Save(ctx context.Context, stu *student.Student) error
}

type LessonRepo interface {
	GetByID(ctx context.Context, id uuid.UUID) (*lesson.Lesson, error)
}

// ==========================================================
// 2. COMMAND (DTO ĐẦU VÀO)
// ==========================================================

type AssignNormalLessonCommand struct {
	LessonID           uuid.UUID
	StudentID          uuid.UUID
	PageName           string
	StudentChapterName string
	TeacherChapterName string
}

type AssignRemediationLessonCommand struct {
	LessonID           uuid.UUID
	PageName           string
	StudentChapterName string
	TeacherChapterName string
}

// ==========================================================
// 3. USECASE (ĐIỀU PHỐI TUYẾN TÍNH - KHÔNG RÒ RỈ HẠ TẦNG)
// ==========================================================

type AssignLessonUsecase struct {
	studentRepo      StudentRepo
	lessonRepo       LessonRepo
	assignmentRepo   AssignmentRepo
	mistakeGraphRepo GraphMistakeRepo
	publisher        WorkspacePublisherGateway
}

func NewAssignLessonUsecase(
	studentRepo StudentRepo,
	lessonRepo LessonRepo,
	assignmentRepo AssignmentRepo,
	mistakeGraphRepo GraphMistakeRepo,
	publisher WorkspacePublisherGateway,
) *AssignLessonUsecase {

	return &AssignLessonUsecase{
		studentRepo:      studentRepo,
		lessonRepo:       lessonRepo,
		assignmentRepo:   assignmentRepo,
		mistakeGraphRepo: mistakeGraphRepo,
		publisher:        publisher,
	}
}
func (u *AssignLessonUsecase) AssignNormal(
	ctx context.Context,
	cmd AssignNormalLessonCommand,
) error {

	stu, err := u.studentRepo.GetByID(ctx, cmd.StudentID)
	if err != nil {
		return fmt.Errorf("không tìm thấy học sinh: %w", err)
	}

	lsn, err := u.lessonRepo.GetByID(ctx, cmd.LessonID)
	if err != nil {
		return fmt.Errorf("không tìm thấy lesson: %w", err)
	}

	a, err := assignment.NewNormalAssignmentFromLesson(
		stu.ID(),
		cmd.PageName,
		*lsn,
	)
	if err != nil {
		return fmt.Errorf("không thể tạo assignment: %w", err)
	}

	if err := u.publish(
		ctx,
		stu,
		lsn,
		a,
		cmd.StudentChapterName,
		cmd.TeacherChapterName,
		cmd.PageName,
	); err != nil {
		return err
	}

	return nil
}
func (u *AssignLessonUsecase) AssignRemediation(
	ctx context.Context,
	cmd AssignRemediationLessonCommand,
) error {

	lsn, err := u.lessonRepo.GetByID(ctx, cmd.LessonID)
	if err != nil {
		return fmt.Errorf("không tìm thấy lesson: %w", err)
	}

	material, ok := lsn.Material().(lesson.MistakeMaterial)
	if !ok {
		return errors.New("lesson không được tạo từ mistake")
	}

	studentID := material.StudentID()
	mistakeID := material.MistakeID()

	stu, err := u.studentRepo.GetByID(ctx, studentID)
	if err != nil {
		return fmt.Errorf("không tìm thấy học sinh: %w", err)
	}

	a, err := assignment.NewRemediationAssignmentFromLesson(
		studentID,
		mistakeID,
		cmd.PageName,
		*lsn,
	)
	if err != nil {
		return fmt.Errorf("không thể tạo remediation assignment: %w", err)
	}

	if err := u.publish(
		ctx,
		stu,
		lsn,
		a,
		cmd.StudentChapterName,
		cmd.TeacherChapterName,
		cmd.PageName,
	); err != nil {
		return err
	}

	graph, err := u.mistakeGraphRepo.GetByStudentID(ctx, studentID)
	if err != nil {
		return fmt.Errorf("không thể lấy mistake graph: %w", err)
	}

	if err := graph.StartRemediation(mistakeID); err != nil {
		return fmt.Errorf("không thể bắt đầu remediation: %w", err)
	}

	if err := u.mistakeGraphRepo.Save(ctx, graph); err != nil {
		return fmt.Errorf("không thể lưu mistake graph: %w", err)
	}

	return nil
}
func (u *AssignLessonUsecase) publish(
	ctx context.Context,
	stu *student.Student,
	lsn *lesson.Lesson,
	a *assignment.Assignment,
	studentChapterName string,
	teacherChapterName string,
	pageName string,
) error {

	if err := u.publisher.PublishAssignment(
		ctx,
		a,
		stu.Name(),
		*lsn,
		studentChapterName,
		teacherChapterName,
		pageName,
	); err != nil {
		return fmt.Errorf(
			"không thể publish assignment: %w",
			err,
		)
	}

	if err := u.assignmentRepo.Save(ctx, a); err != nil {
		return fmt.Errorf(
			"không thể lưu assignment: %w",
			err,
		)
	}

	return nil
}
