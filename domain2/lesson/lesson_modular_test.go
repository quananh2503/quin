package lesson_test

import (
	"testing"
	"uuid"

	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// Helper tạo Content nhanh
func makeContent(text string) sharekernel.Content {
	return sharekernel.NewContent(sharekernel.InlinePart{
		Type:  sharekernel.InlineText,
		Value: text,
	})
}

// Helper tạo MCQ Exercise
func makeMCQ(topic string, label string) sharekernel.Exercise {
	opts := []sharekernel.MCOption{}
	optA, _ := sharekernel.NewMCOption("A", makeContent("Đáp án A"))
	optB, _ := sharekernel.NewMCOption("B", makeContent("Đáp án B"))
	opts = append(opts, optA, optB)

	mcq, _ := sharekernel.NewMultipleChoiceExercise(
		topic,
		"Nhận biết",
		makeContent("Câu hỏi "+label),
		opts,
		"A",
		makeContent("Lời giải chi tiết"),
		sharekernel.NewDiagram(sharekernel.DiagramNone, ""),
	)
	return mcq
}

// Helper tạo Essay Exercise
func makeEssay(topic string, label string) sharekernel.Exercise {
	parts := []sharekernel.EssayPart{
		sharekernel.NewEssayPart("a", makeContent("Ý a"), makeContent("Giải a"), makeContent("Rubric a")),
	}
	essay, _ := sharekernel.NewEssayExercise(
		topic,
		"Vận dụng",
		makeContent("Bài tập tự luận "+label),
		parts,
		sharekernel.NewDiagram(sharekernel.DiagramNone, ""),
	)
	return essay
}

func TestTopic_CreationAndImmutability(t *testing.T) {
	t.Run("Khởi tạo Topic đầy đủ blocks và exercises", func(t *testing.T) {
		title := makeContent("Dạng 1: Tích vô hướng")
		blocks := []lesson.Block{
			lesson.NewParagraphBlock(makeContent("Lý thuyết trọng tâm")),
			lesson.NewFormulaBlock("a . b = |a||b| cos(a,b)"),
		}
		exercises := []sharekernel.Exercise{
			makeMCQ("Tích vô hướng", "MCQ 1"),
			makeEssay("Tích vô hướng", "Essay 1"),
		}

		topic, err := lesson.NewTopic(title, blocks, exercises)
		require.NoError(t, err)
		assert.Equal(t, "Dạng 1: Tích vô hướng", topic.Title().String())
		assert.Len(t, topic.Blocks(), 2)
		assert.Len(t, topic.Exercises(), 2)

		// Kiểm tra Defensive Copy của blocks
		blocks[0] = lesson.NewParagraphBlock(makeContent("Đã bị sửa từ bên ngoài"))
		assert.Equal(t, "Lý thuyết trọng tâm", topic.Blocks()[0].(lesson.ParagraphBlock).Body().String())

		// Kiểm tra Defensive Copy của exercises
		exercises[0] = makeMCQ("Đã sửa", "MCQ Sửa")
		assert.Equal(t, "Tích vô hướng", topic.Exercises()[0].Topic())
	})

	t.Run("Fallback tiêu đề khi title rỗng", func(t *testing.T) {
		emptyTitle := sharekernel.NewContent()
		topic, err := lesson.NewTopic(emptyTitle, nil, nil)
		require.NoError(t, err)
		assert.Equal(t, "Không có tiêu đề", topic.Title().String())
		assert.Empty(t, topic.Blocks())
		assert.Empty(t, topic.Exercises())
	})

	t.Run("ReconstituteTopic khôi phục đúng dữ liệu", func(t *testing.T) {
		title := makeContent("Dạng phục hồi")
		blocks := []lesson.Block{lesson.NewFormulaBlock("x^2 + y^2 = 1")}
		exercises := []sharekernel.Exercise{makeMCQ("Đường tròn", "1")}

		topic := lesson.ReconstituteTopic(title, blocks, exercises)
		assert.Equal(t, "Dạng phục hồi", topic.Title().String())
		assert.Len(t, topic.Blocks(), 1)
		assert.Len(t, topic.Exercises(), 1)
	})
}

func TestLesson_ExercisesAggregation(t *testing.T) {
	t.Run("Lesson gom đủ và đúng thứ tự tất cả exercises từ các Topic trong Section", func(t *testing.T) {
		ex1 := makeMCQ("Dạng 1", "Câu 1")
		ex2 := makeEssay("Dạng 1", "Câu 2")
		topic1, err := lesson.NewTopic(makeContent("Dạng 1"), nil, []sharekernel.Exercise{ex1, ex2})
		require.NoError(t, err)

		sec1, err := lesson.NewSection(makeContent("Phần I"), []lesson.Topic{topic1})
		require.NoError(t, err)

		ex3 := makeMCQ("Dạng 2", "Câu 3")
		topic2, err := lesson.NewTopic(makeContent("Dạng 2"), nil, []sharekernel.Exercise{ex3})
		require.NoError(t, err)

		ex4 := makeEssay("Dạng 3", "Câu 4")
		ex5 := makeMCQ("Dạng 3", "Câu 5")
		topic3, err := lesson.NewTopic(makeContent("Dạng 3"), nil, []sharekernel.Exercise{ex4, ex5})
		require.NoError(t, err)

		sec2, err := lesson.NewSection(makeContent("Phần II"), []lesson.Topic{topic2, topic3})
		require.NoError(t, err)

		mat, err := lesson.NewYouTubeMaterial("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
		require.NoError(t, err)

		lsn, err := lesson.NewLesson(
			makeContent("Bài Giảng Hình Học Không Gian"),
			makeContent("Tổng quan về vectơ"),
			[]lesson.Section{sec1, sec2},
			[]lesson.StudyMaterial{mat},
		)
		require.NoError(t, err)
		require.NotNil(t, lsn)

		// KIỂM CHỨNG TẬP TRUNG: Lesson.Exercises() phải gom đúng 5 bài tập theo thứ tự
		allEx := lsn.Exercises()
		require.Len(t, allEx, 5)
		assert.Equal(t, "Câu hỏi Câu 1", allEx[0].Prompt().String())
		assert.Equal(t, "Bài tập tự luận Câu 2", allEx[1].Prompt().String())
		assert.Equal(t, "Câu hỏi Câu 3", allEx[2].Prompt().String())
		assert.Equal(t, "Bài tập tự luận Câu 4", allEx[3].Prompt().String())
		assert.Equal(t, "Câu hỏi Câu 5", allEx[4].Prompt().String())
	})
}

func TestLesson_Invariants(t *testing.T) {
	mat, err := lesson.NewYouTubeMaterial("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
	require.NoError(t, err)

	topic, err := lesson.NewTopic(makeContent("Dạng 1"), nil, nil)
	require.NoError(t, err)
	sec, err := lesson.NewSection(makeContent("Phần 1"), []lesson.Topic{topic})
	require.NoError(t, err)

	t.Run("Lỗi khi sections rỗng", func(t *testing.T) {
		lsn, err := lesson.NewLesson(
			makeContent("Tiêu đề"),
			makeContent("Tổng quan"),
			nil,
			[]lesson.StudyMaterial{mat},
		)
		assert.Nil(t, lsn)
		assert.ErrorIs(t, err, lesson.ErrSectionEmpty)
	})

	t.Run("Lỗi khi materials rỗng hoặc nil", func(t *testing.T) {
		lsn, err := lesson.NewLesson(
			makeContent("Tiêu đề"),
			makeContent("Tổng quan"),
			[]lesson.Section{sec},
			nil,
		)
		assert.Nil(t, lsn)
		assert.ErrorIs(t, err, lesson.ErrMaterialsEmpty)

		lsn2, err2 := lesson.NewLesson(
			makeContent("Tiêu đề"),
			makeContent("Tổng quan"),
			[]lesson.Section{sec},
			[]lesson.StudyMaterial{},
		)
		assert.Nil(t, lsn2)
		assert.ErrorIs(t, err2, lesson.ErrMaterialsEmpty)
	})

	t.Run("Tiêu đề rỗng được tự động đặt mặc định", func(t *testing.T) {
		lsn, err := lesson.NewLesson(
			sharekernel.NewContent(),
			makeContent("Tổng quan"),
			[]lesson.Section{sec},
			[]lesson.StudyMaterial{mat},
		)
		require.NoError(t, err)
		assert.Equal(t, "Không có tiêu đề", lsn.Title().String())
	})

	t.Run("ReconstituteLesson kiểm tra Invariants", func(t *testing.T) {
		// uuid.Nil() phải lỗi
		_, errNilID := lesson.ReconstituteLesson(
			uuid.Nil(),
			makeContent("Tiêu đề"),
			makeContent("Tổng quan"),
			[]lesson.Section{sec},
			[]lesson.StudyMaterial{mat},
		)
		assert.Error(t, errNilID)

		// Thành công khi dữ liệu hợp lệ
		validID := uuid.New()
		reconstructed, errValid := lesson.ReconstituteLesson(
			validID,
			makeContent("Tiêu đề"),
			makeContent("Tổng quan"),
			[]lesson.Section{sec},
			[]lesson.StudyMaterial{mat},
		)
		require.NoError(t, errValid)
		assert.Equal(t, validID, reconstructed.ID())
	})
}
