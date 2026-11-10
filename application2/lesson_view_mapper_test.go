package application2_test

import (
	"testing"

	"uuid"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/domain2/lesson"
)

func TestLessonViewToLesson(t *testing.T) {
	t.Run("nil view returns error", func(t *testing.T) {
		_, err := application2.LessonViewToLesson(nil, nil)
		if err == nil {
			t.Fatal("kỳ vọng trả về lỗi khi LessonView là nil")
		}
	})

	t.Run("valid view converts to lesson domain aggregate", func(t *testing.T) {
		lessonID := uuid.New()
		view := &application2.LessonView{
			ID:       lessonID,
			Title:    "Bài học kiểm thử Tích vô hướng",
			Overview: "Tổng quan bài học",
			Sections: []application2.SectionView{
				{
					Title: "Phần 1: Khái niệm",
					Topics: []application2.TopicView{
						{
							Title: "Dạng 1: Định nghĩa",
							Blocks: []application2.BlockView{
								{
									Type: string(lesson.BlockParagraph),
									Body: "Định nghĩa tích vô hướng...",
								},
								{
									Type: string(lesson.BlockFormula),
									Math: "$vec(a) . vec(b) = |vec(a)| |vec(b)| cos(vec(a), vec(b))$",
								},
								{
									Type:    string(lesson.BlockList),
									Ordered: true,
									Items:   []string{"Bước 1", "Bước 2"},
								},
								{
									Type:        string(lesson.BlockCallout),
									CalloutKind: "tip",
									Title:       "Mẹo nhớ",
									Body:        "Lưu ý góc giữa hai vectơ",
								},
							},
							Exercises: []application2.ExerciseView{
								{
									Type:       "multiple-choice",
									Topic:      "Dạng 1",
									Difficulty: "Nhận biết",
									Question:   "Góc 90 độ thì tích vô hướng bằng mấy?",
									Options: []application2.OptionView{
										{Label: "A", Content: "0"},
										{Label: "B", Content: "1"},
									},
									Answer:      "A",
									Explanation: "Vì cos(90) = 0",
								},
								{
									Type:       "essay",
									Topic:      "Dạng 1",
									Difficulty: "Vận dụng",
									Question:   "Tính tích vô hướng trong tam giác đều cạnh a",
									Parts: []application2.EssayPartView{
										{
											Label:    "a",
											Question: "Tính góc",
											Solution: "Góc = 60 độ",
											Rubric:   "0.5 điểm",
										},
									},
								},
							},
						},
					},
				},
			},
		}

		defaultMat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=sample123")
		if err != nil {
			t.Fatalf("NewYouTubeMaterial: %v", err)
		}
		mat := []lesson.StudyMaterial{defaultMat}

		lsn, err := application2.LessonViewToLesson(view, mat)
		if err != nil {
			t.Fatalf("LessonViewToLesson thất bại: %v", err)
		}

		if lsn.ID() != lessonID {
			t.Errorf("kỳ vọng ID %v, thực tế %v", lessonID, lsn.ID())
		}
		if lsn.Title().String() != "Bài học kiểm thử Tích vô hướng" {
			t.Errorf("kỳ vọng Title %q, thực tế %q", "Bài học kiểm thử Tích vô hướng", lsn.Title().String())
		}
		if len(lsn.Sections()) != 1 {
			t.Fatalf("kỳ vọng 1 section, thực tế %d", len(lsn.Sections()))
		}
		if len(lsn.Sections()[0].Topics()) != 1 {
			t.Fatalf("kỳ vọng 1 topic, thực tế %d", len(lsn.Sections()[0].Topics()))
		}
		topic := lsn.Sections()[0].Topics()[0]
		if len(topic.Blocks()) != 4 {
			t.Errorf("kỳ vọng 4 blocks, thực tế %d", len(topic.Blocks()))
		}
		if len(topic.Exercises()) != 2 {
			t.Errorf("kỳ vọng 2 exercises, thực tế %d", len(topic.Exercises()))
		}
	})

	t.Run("empty sections fallback correctly", func(t *testing.T) {
		view := &application2.LessonView{
			Title: "Bài học trống",
		}
		lsn, err := application2.LessonViewToLesson(view, nil)
		if err != nil {
			t.Fatalf("kỳ vọng fallback thành công, lỗi: %v", err)
		}
		if len(lsn.Sections()) == 0 {
			t.Fatal("kỳ vọng có ít nhất 1 section mặc định")
		}
		if len(lsn.Materials()) == 0 {
			t.Fatal("kỳ vọng có ít nhất 1 material mặc định")
		}
	})
}
