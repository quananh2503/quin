package wails

import (
	"context"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"meet-attendance-clean/domain2/assignment"
	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	"uuid"
)

func TestResolveLessonPDFPaths_CustomPaths(t *testing.T) {
	tCustom := "custom/teacher.pdf"
	sCustom := "custom/student.pdf"

	tResolved, sResolved := ResolveLessonPDFPaths(tCustom, sCustom)
	assert.Equal(t, tCustom, tResolved)
	assert.Equal(t, sCustom, sResolved)
}

func TestResolveLessonPDFPaths_DefaultFallback(t *testing.T) {
	// Giả lập thư mục output chứa 2 file chuẩn
	outDir := filepath.Join(".artifacts", "full_pipeline_output")
	require.NoError(t, os.MkdirAll(outDir, 0755))

	teacherFile := filepath.Join(outDir, "GIAO_AN_GIAO_VIEN.pdf")
	studentFile := filepath.Join(outDir, "PHIEU_BAI_TAP_HOC_SINH.pdf")

	// Tạo file rỗng tạm nếu chưa có để test
	if _, err := os.Stat(teacherFile); os.IsNotExist(err) {
		require.NoError(t, os.WriteFile(teacherFile, []byte("%PDF-test"), 0644))
		defer func() {
			if rmErr := os.Remove(teacherFile); rmErr != nil {
				t.Logf("cleanup teacher file: %v", rmErr)
			}
		}()
	}
	if _, err := os.Stat(studentFile); os.IsNotExist(err) {
		require.NoError(t, os.WriteFile(studentFile, []byte("%PDF-test"), 0644))
		defer func() {
			if rmErr := os.Remove(studentFile); rmErr != nil {
				t.Logf("cleanup student file: %v", rmErr)
			}
		}()
	}

	tResolved, sResolved := ResolveLessonPDFPaths("", "")
	assert.Equal(t, teacherFile, tResolved, "Phải ưu tiên tìm GIAO_AN_GIAO_VIEN.pdf")
	assert.Equal(t, studentFile, sResolved, "Phải ưu tiên tìm PHIEU_BAI_TAP_HOC_SINH.pdf")
}

func TestRenderLessonPDFBytes_Success(t *testing.T) {
	title := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Bài Học Thử Nghiệm"})
	overview := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Tổng quan bài học"})

	pBlock := lesson.NewParagraphBlock(sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Nội dung lý thuyết"}))
	blocks := []lesson.Block{pBlock}

	top, err := lesson.NewTopic(sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Dạng 1. Kiến thức cơ bản"}), blocks, nil)
	require.NoError(t, err)

	sec, err := lesson.NewSection(sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Phần 1"}), []lesson.Topic{top})
	require.NoError(t, err)

	mat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=mock")
	require.NoError(t, err)

	lsn, err := lesson.NewLesson(title, overview, []lesson.Section{sec}, []lesson.StudyMaterial{mat})
	require.NoError(t, err)

	// Test render cho Giáo viên
	teacherBytes, err := RenderLessonPDFBytes(context.Background(), lsn, true)
	require.NoError(t, err)
	assert.NotEmpty(t, teacherBytes)
	assert.True(t, strings.HasPrefix(string(teacherBytes), "%PDF-"), "File đầu ra phải là định dạng PDF")

	// Test render cho Học sinh
	studentBytes, err := RenderLessonPDFBytes(context.Background(), lsn, false)
	require.NoError(t, err)
	assert.NotEmpty(t, studentBytes)
	assert.True(t, strings.HasPrefix(string(studentBytes), "%PDF-"), "File đầu ra phải là định dạng PDF")
}

func TestRenderLessonPDFBytes_NilLesson(t *testing.T) {
	_, err := RenderLessonPDFBytes(context.Background(), nil, true)
	require.Error(t, err)
}

type mockAssignmentRepo struct {
	saved *assignment.Assignment
}

func (m *mockAssignmentRepo) Save(ctx context.Context, a *assignment.Assignment) error {
	m.saved = a
	return nil
}

func (m *mockAssignmentRepo) GetByID(ctx context.Context, id uuid.UUID) (*assignment.Assignment, error) {
	return nil, nil
}

type mockLessonRepo struct {
	lsn *lesson.Lesson
}

func (m *mockLessonRepo) GetByID(ctx context.Context, id uuid.UUID) (*lesson.Lesson, error) {
	return m.lsn, nil
}

func TestV2PublishPDFLesson_SavesAssignment(t *testing.T) {
	title := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Bài Mẫu"})
	overview := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Tổng quan"})

	optA, err := sharekernel.NewMCOption("A", sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "1"}))
	require.NoError(t, err)
	optB, err := sharekernel.NewMCOption("B", sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "2"}))
	require.NoError(t, err)

	mcq, err := sharekernel.NewMultipleChoiceExercise(
		"Dạng 1",
		"Nhận biết",
		sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "1+1=?"}),
		[]sharekernel.MCOption{optA, optB},
		"A",
		sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "1+1=2"}),
		sharekernel.Diagram{},
	)
	require.NoError(t, err)

	top, err := lesson.NewTopic(sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Dạng 1"}), nil, []sharekernel.Exercise{mcq})
	require.NoError(t, err)

	sec, err := lesson.NewSection(sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Phần 1"}), []lesson.Topic{top})
	require.NoError(t, err)

	mat, err := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=mock")
	require.NoError(t, err)

	lsn, err := lesson.NewLesson(title, overview, []lesson.Section{sec}, []lesson.StudyMaterial{mat})
	require.NoError(t, err)

	mockAssign := &mockAssignmentRepo{}
	mockLesson := &mockLessonRepo{lsn: lsn}

	app := &App{
		application2: &Application2Services{
			Lessons:     mockLesson,
			Assignments: mockAssign,
		},
	}

	studentID := uuid.New()
	req := PublishPDFLessonRequest{
		LessonID:           lsn.ID().String(),
		StudentID:          studentID.String(),
		PageName:           "Bài Tập Về Nhà",
		StudentChapterName: "Chương 1",
		TeacherChapterName: "Chương 1",
	}

	err = app.V2PublishPDFLesson(req)
	require.NoError(t, err)

	require.NotNil(t, mockAssign.saved, "V2PublishPDFLesson phải lưu assignment vào AssignmentRepo")
	assert.Equal(t, studentID, mockAssign.saved.StudentID())
	assert.Equal(t, "Bài Tập Về Nhà", mockAssign.saved.Title())
	assert.Equal(t, 1, len(mockAssign.saved.Items()), "Assignment phải gom đúng số lượng bài tập từ Lesson")
}
