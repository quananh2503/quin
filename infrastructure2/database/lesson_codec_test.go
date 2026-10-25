package database_test

import (
	"context"
	"testing"

	"meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/database"
	"meet-attendance-clean/infrastructure2/database/dbgen"
	"meet-attendance-clean/infrastructure2/database/mocks"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"
)

func makeContent(text string) sharekernel.Content {
	return sharekernel.NewContent(sharekernel.InlinePart{
		Type:  sharekernel.InlineText,
		Value: text,
	})
}

func makeMCQ(topic string, label string) sharekernel.Exercise {
	optA, _ := sharekernel.NewMCOption("A", makeContent("Đáp án A"))
	optB, _ := sharekernel.NewMCOption("B", makeContent("Đáp án B"))
	mcq, _ := sharekernel.NewMultipleChoiceExercise(
		topic,
		"Nhận biết",
		makeContent("Câu trắc nghiệm "+label),
		[]sharekernel.MCOption{optA, optB},
		"A",
		makeContent("Giải thích A"),
		sharekernel.NewDiagram(sharekernel.DiagramNone, ""),
	)
	return mcq
}

func makeEssay(topic string, label string) sharekernel.Exercise {
	part := sharekernel.NewEssayPart("a", makeContent("Câu hỏi a"), makeContent("Lời giải a"), makeContent("Barem a"))
	essay, _ := sharekernel.NewEssayExercise(
		topic,
		"Vận dụng",
		makeContent("Câu tự luận "+label),
		[]sharekernel.EssayPart{part},
		sharekernel.NewDiagram(sharekernel.DiagramNone, ""),
	)
	return essay
}

func TestLessonCodec_RoundTrip_WithMockery(t *testing.T) {
	// 1. Chuẩn bị Lesson Domain Entity hoàn chỉnh với Exercises nằm trong từng Topic
	ex1 := makeMCQ("Dạng 1", "1")
	ex2 := makeEssay("Dạng 1", "2")
	topic1, err := lesson.NewTopic(
		makeContent("Dạng 1: Khái niệm cơ bản"),
		[]lesson.Block{
			lesson.NewParagraphBlock(makeContent("Lý thuyết cơ bản")),
			lesson.NewFormulaBlock("E = mc^2"),
		},
		[]sharekernel.Exercise{ex1, ex2},
	)
	require.NoError(t, err)

	sec1, err := lesson.NewSection(makeContent("Phần I"), []lesson.Topic{topic1})
	require.NoError(t, err)

	ex3 := makeMCQ("Dạng 2", "3")
	topic2, err := lesson.NewTopic(
		makeContent("Dạng 2: Nâng cao"),
		[]lesson.Block{
			lesson.NewCalloutBlock(lesson.CalloutTip, makeContent("Mẹo"), makeContent("Ghi nhớ công thức")),
		},
		[]sharekernel.Exercise{ex3},
	)
	require.NoError(t, err)

	sec2, err := lesson.NewSection(makeContent("Phần II"), []lesson.Topic{topic2})
	require.NoError(t, err)

	mat, err := lesson.NewYouTubeMaterial("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
	require.NoError(t, err)

	originalLesson, err := lesson.NewLesson(
		makeContent("Chuyên đề Vật Lý Lượng Tử"),
		makeContent("Tổng quan về lượng tử ánh sáng"),
		[]lesson.Section{sec1, sec2},
		[]lesson.StudyMaterial{mat},
	)
	require.NoError(t, err)

	// 2. Kiểm chứng Encode & Decode
	encodedJSON, err := database.EncodeLessonToJSON(originalLesson)
	require.NoError(t, err)
	require.NotEmpty(t, encodedJSON)

	// 3. Giả lập tầng truy vấn cơ sở dữ liệu với MockQuerier (Mockery)
	mockQ := mocks.NewQuerier(t)
	lessonIDStr := originalLesson.ID().String()

	// Thiết lập mock kỳ vọng cho UpsertLesson và GetLessonByID
	mockQ.On("UpsertLesson", mock.Anything, mock.MatchedBy(func(params dbgen.UpsertLessonParams) bool {
		return params.ID == lessonIDStr && len(params.LessonJson) > 0
	})).Return(nil).Once()

	mockQ.On("GetLessonByID", mock.Anything, lessonIDStr).Return(string(encodedJSON), nil).Once()

	// Gọi mock giả lập lưu và lấy
	err = mockQ.UpsertLesson(context.Background(), dbgen.UpsertLessonParams{
		ID:         lessonIDStr,
		LessonJson: string(encodedJSON),
	})
	require.NoError(t, err)

	rawFromDB, err := mockQ.GetLessonByID(context.Background(), lessonIDStr)
	require.NoError(t, err)

	// 4. Giải mã dữ liệu lấy từ DB
	reconstructedLesson, err := database.DecodeLessonFromJSON([]byte(rawFromDB))
	require.NoError(t, err)
	require.NotNil(t, reconstructedLesson)

	// 5. Assert tính toàn vẹn 100% của Domain
	assert.Equal(t, originalLesson.ID(), reconstructedLesson.ID())
	assert.Equal(t, originalLesson.Title().String(), reconstructedLesson.Title().String())
	assert.Equal(t, originalLesson.Overview().String(), reconstructedLesson.Overview().String())
	assert.Len(t, reconstructedLesson.Sections(), 2)

	// Kiểm chứng các bài tập trong từng Topic
	sec1Topics := reconstructedLesson.Sections()[0].Topics()
	require.Len(t, sec1Topics, 1)
	assert.Len(t, sec1Topics[0].Blocks(), 2)
	assert.Len(t, sec1Topics[0].Exercises(), 2)

	sec2Topics := reconstructedLesson.Sections()[1].Topics()
	require.Len(t, sec2Topics, 1)
	assert.Len(t, sec2Topics[0].Blocks(), 1)
	assert.Len(t, sec2Topics[0].Exercises(), 1)

	// Kiểm chứng hàm Exercises() tổng hợp vẫn gom đủ 3 bài tập
	allExercises := reconstructedLesson.Exercises()
	require.Len(t, allExercises, 3)
	assert.Equal(t, "Câu trắc nghiệm 1", allExercises[0].Prompt().String())
	assert.Equal(t, "Câu tự luận 2", allExercises[1].Prompt().String())
	assert.Equal(t, "Câu trắc nghiệm 3", allExercises[2].Prompt().String())

	mockQ.AssertExpectations(t)
}

func TestLessonCodec_BackwardCompatibility(t *testing.T) {
	// Giả lập chuỗi JSON cũ trong SQLite (Bài tập nằm ở root `exercises`, trong `topics` rỗng)
	oldJSONRaw := `{
		"id": "11111111-1111-1111-1111-111111111111",
		"title": {"inline_parts": [{"type": "text", "value": "Bài học định dạng cũ"}]},
		"overview": {"inline_parts": [{"type": "text", "value": "Tổng quan cũ"}]},
		"sections": [
			{
				"title": {"inline_parts": [{"type": "text", "value": "Phần I cũ"}]},
				"topics": [
					{
						"title": {"inline_parts": [{"type": "text", "value": "Dạng 1 cũ"}]},
						"blocks": [
							{"type": "paragraph", "body": {"inline_parts": [{"type": "text", "value": "Lý thuyết cũ"}]}}
						]
					}
				]
			}
		],
		"exercises": [
			{
				"type": "multiple-choice",
				"topic": "Dạng cũ",
				"difficulty": "Nhận biết",
				"prompt": {"inline_parts": [{"type": "text", "value": "Câu hỏi root cũ"}]},
				"options": [
					{"label": "A", "content": {"inline_parts": [{"type": "text", "value": "Lựa chọn A"}]}},
					{"label": "B", "content": {"inline_parts": [{"type": "text", "value": "Lựa chọn B"}]}}
				],
				"answer": "A",
				"diagram": {"type": "", "content": ""}
			}
		],
		"materials": [
			{"type": "YOUTUBE", "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"}
		]
	}`

	reconstructed, err := database.DecodeLessonFromJSON([]byte(oldJSONRaw))
	require.NoError(t, err, "Hệ thống mới phải giải mã thành công bản ghi định dạng cũ")
	require.NotNil(t, reconstructed)

	assert.Equal(t, "Bài học định dạng cũ", reconstructed.Title().String())

	// Bài tập ở root cũ phải được tự động chuyển vào Topic đầu tiên
	assert.Len(t, reconstructed.Sections()[0].Topics()[0].Exercises(), 1)
	assert.Len(t, reconstructed.Exercises(), 1)
	assert.Equal(t, "Câu hỏi root cũ", reconstructed.Exercises()[0].Prompt().String())
}

func TestLessonCodec_PDFMaterial_FullAndSliced(t *testing.T) {
	// 1. Khởi tạo 2 loại tài liệu PDF: Full PDF (toàn phần) và Sliced PDF (cắt trang)
	fullPDF, err := lesson.NewFullPDFMaterial("C:/data/math12_full.pdf")
	require.NoError(t, err)

	slicedPDF, err := lesson.NewSlicedPDFMaterial("C:/data/workbook_sliced.pdf", []int{1, 2, 5})
	require.NoError(t, err)

	topic, err := lesson.NewTopic(makeContent("Chủ đề PDF"), nil, nil)
	require.NoError(t, err)

	sec, err := lesson.NewSection(makeContent("Phần I"), []lesson.Topic{topic})
	require.NoError(t, err)

	lsn, err := lesson.NewLesson(
		makeContent("Bài Giảng Hình Học Oxyz Từ PDF"),
		makeContent("Tổng quan Oxyz"),
		[]lesson.Section{sec},
		[]lesson.StudyMaterial{fullPDF, slicedPDF},
	)
	require.NoError(t, err)

	// 2. Encode sang JSON
	encoded, err := database.EncodeLessonToJSON(lsn)
	require.NoError(t, err)
	require.NotEmpty(t, encoded)

	// 3. Decode từ JSON - Không được vấp lỗi 'dữ liệu PDF rỗng'
	decoded, err := database.DecodeLessonFromJSON(encoded)
	require.NoError(t, err, "DecodeLessonFromJSON phải hỗ trợ cả Full PDF Material (pages rỗng/nil)")
	require.NotNil(t, decoded)

	// 4. Kiểm tra tính toàn vẹn của Materials
	mats := decoded.Materials()
	require.Len(t, mats, 2)

	// Full PDF
	mat0, ok0 := mats[0].(lesson.PDFMaterial)
	require.True(t, ok0)
	assert.Equal(t, "C:/data/math12_full.pdf", mat0.FilePath())
	assert.Empty(t, mat0.Pages(), "Full PDF phải có danh sách trang rỗng hoặc nil")

	// Sliced PDF
	mat1, ok1 := mats[1].(lesson.PDFMaterial)
	require.True(t, ok1)
	assert.Equal(t, "C:/data/workbook_sliced.pdf", mat1.FilePath())
	assert.Equal(t, []int{1, 2, 5}, mat1.Pages())
}

