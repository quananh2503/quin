package pipeline_test

import (
	"context"
	"errors"
	"testing"

	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/AI/pipeline"
)

type mockGenerator struct {
	calledWithModel string
	lessonToReturn  *lesson.Lesson
	errToReturn     error
}

func (m *mockGenerator) Generate(ctx context.Context, title string, material []lesson.StudyMaterial, model string, prompt string) (*lesson.Lesson, error) {
	m.calledWithModel = model
	return m.lessonToReturn, m.errToReturn
}

func createDummyLesson(t *testing.T, title string) *lesson.Lesson {
	t.Helper()
	mat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
	if err != nil {
		t.Fatalf("tạo material thất bại: %v", err)
	}
	tTitle := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Topic 1"})
	top, err := lesson.NewTopic(tTitle, nil, nil)
	if err != nil {
		t.Fatalf("tạo topic thất bại: %v", err)
	}
	sec, err := lesson.NewSection(tTitle, []lesson.Topic{top})
	if err != nil {
		t.Fatalf("tạo section thất bại: %v", err)
	}
	lTitle := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: title})
	lsn, err := lesson.NewLesson(lTitle, lTitle, []lesson.Section{sec}, []lesson.StudyMaterial{mat})
	if err != nil {
		t.Fatalf("tạo lesson thất bại: %v", err)
	}
	return lsn
}

func TestDualLessonGenerator_Routing(t *testing.T) {
	geminiLesson := createDummyLesson(t, "Bài Gemini")
	deepseekLesson := createDummyLesson(t, "Bài DeepSeek")

	mockGemini := &mockGenerator{lessonToReturn: geminiLesson}
	mockDeepSeek := &mockGenerator{lessonToReturn: deepseekLesson}

	router := pipeline.NewDualLessonGenerator(mockGemini, mockDeepSeek)

	ctx := context.Background()
	mat, errMat := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
	if errMat != nil {
		t.Fatalf("tạo material thất bại: %v", errMat)
	}
	materials := []lesson.StudyMaterial{mat}

	// 1. Kiểm tra định tuyến DeepSeek
	resDS, errDS := router.Generate(ctx, "Toán 12", materials, "deepseek-flash", "Prompt")
	if errDS != nil {
		t.Fatalf("Kỳ vọng thành công nhưng gặp lỗi: %v", errDS)
	}
	if resDS.Title().String() != "Bài DeepSeek" {
		t.Errorf("Kỳ vọng nhận bài từ DeepSeek, nhưng nhận: %s", resDS.Title().String())
	}
	if mockDeepSeek.calledWithModel != "deepseek-flash" {
		t.Errorf("DeepSeek model không khớp: %s", mockDeepSeek.calledWithModel)
	}

	// 2. Kiểm tra định tuyến Gemini
	resGem, errGem := router.Generate(ctx, "Toán 12", materials, "gemini-3.8-flash", "Prompt")
	if errGem != nil {
		t.Fatalf("Kỳ vọng thành công nhưng gặp lỗi: %v", errGem)
	}
	if resGem.Title().String() != "Bài Gemini" {
		t.Errorf("Kỳ vọng nhận bài từ Gemini, nhưng nhận: %s", resGem.Title().String())
	}
	if mockGemini.calledWithModel != "gemini-3.8-flash" {
		t.Errorf("Gemini model không khớp: %s", mockGemini.calledWithModel)
	}

	// 3. Mặc định khi model rỗng -> định tuyến về Gemini
	resDef, errDef := router.Generate(ctx, "Toán 12", materials, "", "Prompt")
	if errDef != nil {
		t.Fatalf("Kỳ vọng thành công nhưng gặp lỗi: %v", errDef)
	}
	if resDef.Title().String() != "Bài Gemini" {
		t.Errorf("Kỳ vọng nhận bài từ Gemini khi model rỗng, nhưng nhận: %s", resDef.Title().String())
	}
}

func TestDualLessonGenerator_UnconfiguredErrors(t *testing.T) {
	ctx := context.Background()
	mat, errMat := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
	if errMat != nil {
		t.Fatalf("tạo material thất bại: %v", errMat)
	}
	materials := []lesson.StudyMaterial{mat}

	// Thiếu DeepSeek
	routerNoDS := pipeline.NewDualLessonGenerator(&mockGenerator{}, nil)
	_, err := routerNoDS.Generate(ctx, "Toán 12", materials, "deepseek-flash", "")
	if err == nil {
		t.Fatal("Kỳ vọng lỗi khi chưa cấu hình DeepSeek generator")
	}

	// Thiếu Gemini
	routerNoGem := pipeline.NewDualLessonGenerator(nil, &mockGenerator{})
	_, err = routerNoGem.Generate(ctx, "Toán 12", materials, "gemini-3.8-flash", "")
	if err == nil {
		t.Fatal("Kỳ vọng lỗi khi chưa cấu hình Gemini generator")
	}
}

func TestDualLessonGenerator_ErrorPropagation(t *testing.T) {
	expectedErr := errors.New("ai provider failed")
	mockGemini := &mockGenerator{errToReturn: expectedErr}
	mockDeepSeek := &mockGenerator{errToReturn: expectedErr}

	router := pipeline.NewDualLessonGenerator(mockGemini, mockDeepSeek)
	ctx := context.Background()
	mat, errMat := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
	if errMat != nil {
		t.Fatalf("tạo material thất bại: %v", errMat)
	}
	materials := []lesson.StudyMaterial{mat}

	_, errDS := router.Generate(ctx, "Toán 12", materials, "deepseek-flash", "")
	if !errors.Is(errDS, expectedErr) {
		t.Errorf("Kỳ vọng lỗi %v, nhận: %v", expectedErr, errDS)
	}

	_, errGem := router.Generate(ctx, "Toán 12", materials, "gemini-3.8-flash", "")
	if !errors.Is(errGem, expectedErr) {
		t.Errorf("Kỳ vọng lỗi %v, nhận: %v", expectedErr, errGem)
	}
}
