package gemini_test

import (
	"testing"

	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/gemini"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestToDomainLesson_Success(t *testing.T) {
	plan := &gemini.LessonPlan{
		LessonTitle: "Chuyên Đề Vectơ Không Gian Oxyz",
		Overview:    "Tổng hợp toàn bộ kiến thức và bài tập về hệ trục tọa độ Oxyz",
	}

	worker1 := gemini.WorkerResult{
		TopicID:      "DANG_1",
		Title:        "Dạng 1: Tọa độ điểm và vectơ",
		TheoryPoints: []string{"Tọa độ điểm M(x,y,z)", "Vectơ OM = xi + yj + zk"},
		CalloutTip:   "Quy tắc tam diện thuận Oxyz",
		ClozeFormula: "Độ dài vectơ: |u| = sqrt(x^2 + y^2 + z^2)",
		Examples: []gemini.ExampleItem{
			{Title: "Ví dụ 1", Problem: "Tìm tọa độ điểm M", Solution: "Tọa độ M là (1,2,3)"},
			{Title: "Ví dụ 2", Problem: "Tính khoảng cách OM", Solution: "OM = sqrt(14)"},
		},
		ShortAnswers: []gemini.ShortAnswerExercise{
			{Prompt: "Tính độ dài đoạn thẳng AB", Solution: "AB = sqrt(5)", FinalNumber: "2.24"},
		},
		Drills: []gemini.DrillExercise{
			{Title: "Bài 1", Prompt: "Cho A(1,0,0), B(0,2,0). Tìm trung điểm AB", Solution: "Trung điểm là (0.5, 1, 0)"},
			{Title: "Bài 2", Prompt: "Tính tọa độ trọng tâm tam giác ABC", Solution: "G = (1, 1, 1)"},
		},
	}

	worker2 := gemini.WorkerResult{
		TopicID:      "DANG_2",
		Title:        "Dạng 2: Tích có hướng của hai vectơ",
		TheoryPoints: []string{"Định nghĩa tích có hướng [u, v]", "Ứng dụng tính diện tích tam giác"},
		Examples: []gemini.ExampleItem{
			{Title: "Ví dụ 1", Problem: "Tính [u, v] với u=(1,2,3), v=(2,1,0)", Solution: "Tích có hướng là (-3, 6, -3)"},
		},
		Drills: []gemini.DrillExercise{
			{Title: "Bài 1", Prompt: "Tính diện tích tam giác ABC", Solution: "S = 1/2 |[AB, AC]| = 5"},
			{Title: "Bài 2", Prompt: "Xét tính đồng phẳng của 3 vectơ", Solution: "Đồng phẳng vì [u, v].w = 0"},
		},
	}

	workers := []gemini.WorkerResult{worker1, worker2}

	mat, err := lesson.NewYouTubeMaterial("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
	require.NoError(t, err)
	materials := []lesson.StudyMaterial{mat}

	mapper := gemini.NewDefaultPipelineLessonMapper()
	lsn, err := mapper.ToDomainLesson(plan, workers, materials)

	require.NoError(t, err)
	require.NotNil(t, lsn)

	// Kiểm tra các trường cấp Lesson
	assert.Equal(t, "Chuyên Đề Vectơ Không Gian Oxyz", lsn.Title().String())
	assert.Equal(t, "Tổng hợp toàn bộ kiến thức và bài tập về hệ trục tọa độ Oxyz", lsn.Overview().String())
	assert.NotEmpty(t, lsn.Sections())

	// Gom toàn bộ topics từ các sections
	var allTopics []lesson.Topic
	for _, sec := range lsn.Sections() {
		allTopics = append(allTopics, sec.Topics()...)
	}
	require.Len(t, allTopics, 2)

	// Kiểm tra Topic 1
	top1 := allTopics[0]
	assert.Equal(t, "Dạng 1: Tọa độ điểm và vectơ", top1.Title().String())
	assert.True(t, len(top1.Blocks()) >= 4, "Topic 1 phải chứa lý thuyết, mẹo, công thức và 2 ví dụ")
	assert.Len(t, top1.Exercises(), 3, "Topic 1 phải có 1 short answer + 2 drills = 3 exercises")

	// Kiểm tra Topic 2
	top2 := allTopics[1]
	assert.Equal(t, "Dạng 2: Tích có hướng của hai vectơ", top2.Title().String())
	assert.True(t, len(top2.Blocks()) >= 2, "Topic 2 phải chứa lý thuyết và ví dụ")
	assert.Len(t, top2.Exercises(), 2, "Topic 2 phải có 2 drills = 2 exercises")

	// Kiểm tra hàm tổng hợp lsn.Exercises()
	allExercises := lsn.Exercises()
	require.Len(t, allExercises, 5, "Tổng số bài tập toàn bài học phải là 5")
}

func TestToDomainLesson_ValidationErrors(t *testing.T) {
	mapper := gemini.NewDefaultPipelineLessonMapper()

	mat, _ := lesson.NewYouTubeMaterial("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
	validWorkers := []gemini.WorkerResult{{Title: "Dạng 1"}}

	t.Run("plan nil", func(t *testing.T) {
		_, err := mapper.ToDomainLesson(nil, validWorkers, []lesson.StudyMaterial{mat})
		assert.Error(t, err)
	})

	t.Run("plan title rỗng", func(t *testing.T) {
		_, err := mapper.ToDomainLesson(&gemini.LessonPlan{LessonTitle: ""}, validWorkers, []lesson.StudyMaterial{mat})
		assert.Error(t, err)
	})

	t.Run("workers rỗng", func(t *testing.T) {
		_, err := mapper.ToDomainLesson(&gemini.LessonPlan{LessonTitle: "Bài học"}, nil, []lesson.StudyMaterial{mat})
		assert.Error(t, err)
	})

	t.Run("materials rỗng", func(t *testing.T) {
		_, err := mapper.ToDomainLesson(&gemini.LessonPlan{LessonTitle: "Bài học"}, validWorkers, nil)
		assert.Error(t, err)
	})
}
