package application2

import (
	"context"
	"errors"
	"uuid"
)

type PublishingNotebook struct {
	Name     string   `json:"name"`
	Sections []string `json:"sections"`
}

type PublishingTargets struct {
	Student PublishingNotebook `json:"student"`
	Teacher PublishingNotebook `json:"teacher"`
}

type PublishingPreparationGateway interface {
	PrepareStudent(ctx context.Context, studentID uuid.UUID, studentName string) (PublishingTargets, error)
}

// PreparePublishingTargets may create the two notebooks and persist their bindings.
type PreparePublishingTargetsUsecase struct {
	students StudentRepo
	gateway  PublishingPreparationGateway
}

func NewPreparePublishingTargetsUsecase(students StudentRepo, gateway PublishingPreparationGateway) *PreparePublishingTargetsUsecase {
	return &PreparePublishingTargetsUsecase{students: students, gateway: gateway}
}

func (u *PreparePublishingTargetsUsecase) Prepare(ctx context.Context, studentID uuid.UUID) (PublishingTargets, error) {
	if studentID == uuid.Nil() {
		return PublishingTargets{}, errors.New("student ID không hợp lệ")
	}
	student, err := u.students.GetByID(ctx, studentID)
	if err != nil {
		return PublishingTargets{}, err
	}
	return u.gateway.PrepareStudent(ctx, student.ID(), student.Name())
}
