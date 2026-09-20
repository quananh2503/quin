package application2

import (
	"context"
	"errors"
	"uuid"
)

type UpdateInfoStudentCommand struct {
	StudentID     uuid.UUID
	Name          string
	StartCycleDay int
}
type UpdateInfoStudentUsecase struct {
	studentRepo StudentRepo
}

func NewUpdateInfoStudentUsecase(studentRepo StudentRepo) *UpdateInfoStudentUsecase {
	return &UpdateInfoStudentUsecase{
		studentRepo: studentRepo,
	}
}

func (u *UpdateInfoStudentUsecase) UpdateInfoStudent(ctx context.Context, cmd UpdateInfoStudentCommand) error {
	s, err := u.studentRepo.GetByID(ctx, cmd.StudentID)
	if err != nil {
		return err
	}
	if s == nil {
		return errors.New("học sinh không tồn tại")
	}
	err = s.UpdateInfo(cmd.Name, cmd.StartCycleDay)
	if err != nil {
		return err
	}
	return u.studentRepo.Save(ctx, *s)
}
