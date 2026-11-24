package porttest

import (
	"context"
	"testing"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/domain2/lesson"
	"uuid"
)

// VerifyLessonGeneratorContract verifies any application2.LessonGenerator implementation
// against both happy-path domain invariants and error-path contracts.
func VerifyLessonGeneratorContract(
	t *testing.T,
	makeGenerator func(t *testing.T) (application2.LessonGenerator, []lesson.StudyMaterial),
) {
	t.Helper()

	t.Run("HappyPath", func(t *testing.T) {
		gen, materials := makeGenerator(t)
		if gen == nil {
			t.Fatal("generator must not be nil")
		}
		if len(materials) == 0 {
			t.Fatal("test materials must not be empty")
		}

		lsn, err := gen.Generate(
			context.Background(),
			"Tích vô hướng của hai vectơ",
			materials,
			"deepseek-flash",
			"Biên soạn cho học sinh mất gốc",
		)
		if err != nil {
			t.Fatalf("Generate returned unexpected error: %v", err)
		}
		if lsn == nil {
			t.Fatal("returned Lesson must not be nil")
		}
		if lsn.ID() == uuid.Nil() {
			t.Error("Lesson ID must not be nil UUID")
		}
		if lsn.Title().IsEmpty() {
			t.Error("Lesson Title must not be empty")
		}
		sections := lsn.Sections()
		if len(sections) == 0 {
			t.Fatal("Lesson must contain at least one Section")
		}
		if len(sections[0].Topics()) == 0 {
			t.Fatal("First Section must contain at least one Topic")
		}
		if len(lsn.Materials()) != len(materials) {
			t.Errorf("Materials count = %d, want %d", len(lsn.Materials()), len(materials))
		}
	})

	t.Run("ErrorPath_EmptyMaterials", func(t *testing.T) {
		gen, _ := makeGenerator(t)
		if _, err := gen.Generate(context.Background(), "Tiêu đề", nil, "deepseek-flash", ""); err == nil {
			t.Fatal("expected error when materials is nil/empty, got nil")
		}
	})

	t.Run("ErrorPath_CancelledContext", func(t *testing.T) {
		gen, materials := makeGenerator(t)
		ctx, cancel := context.WithCancel(context.Background())
		cancel()

		if _, err := gen.Generate(ctx, "Tiêu đề", materials, "deepseek-flash", "prompt"); err == nil {
			t.Fatal("expected error when context is cancelled, got nil")
		}
	})
}
