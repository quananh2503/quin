package database_test

import (
	"context"
	"testing"
	"time"
	"uuid"

	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/database"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestDraft_GetSummaryByID_And_ListDrafts(t *testing.T) {
	ctx := context.Background()
	store, err := database.Open(":memory:")
	require.NoError(t, err)
	defer func() {
		if closeErr := store.Close(); closeErr != nil {
			t.Logf("cảnh báo đóng store: %v", closeErr)
		}
	}()

	draftRepo := database.Drafts{Store: store}
	readStore := database.ReadStore{Store: store}

	// 1. Tạo một lesson hoàn chỉnh
	lsnTitle := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Bài học kiểm thử"})
	lsnOverview := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Tổng quan bài học"})
	topicTitle := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Dạng 1: Kiểm thử"})
	testTopic, err := lesson.NewTopic(topicTitle, nil, nil)
	require.NoError(t, err)
	secTitle := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Phần I"})
	testSection, err := lesson.NewSection(secTitle, []lesson.Topic{testTopic})
	require.NoError(t, err)
	ytMat, err := lesson.NewYouTubeMaterial("https://www.youtube.com/watch?v=test1234567")
	require.NoError(t, err)

	lsn, err := lesson.NewLesson(lsnTitle, lsnOverview, []lesson.Section{testSection}, []lesson.StudyMaterial{ytMat})
	require.NoError(t, err)

	// 2. Tạo một draft chứa lesson trên
	draftID := uuid.New()
	draftTitle := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Bản nháp bài giảng 1"})
	now := time.Now().UTC()

	draft, err := lesson.ReconstituteLessonDraft(
		draftID, draftTitle, "deepseek-flash", "Yêu cầu prompt",
		lesson.LessonDraftCompleted,
		[]lesson.StudyMaterial{ytMat},
		now, &now, nil, lsn,
	)
	require.NoError(t, err)

	err = draftRepo.Save(ctx, draft)
	require.NoError(t, err)

	// 3. Kiểm tra GetByID nạp đầy đủ cả Lesson
	fullDraft, err := draftRepo.GetByID(ctx, draftID)
	require.NoError(t, err)
	assert.NotNil(t, fullDraft.Lesson())
	assert.Equal(t, "Bài học kiểm thử", fullDraft.Lesson().Title().String())

	// 4. Kiểm tra GetSummaryByID bỏ qua việc decode Lesson để tối ưu tốc độ
	summaryDraft, err := draftRepo.GetSummaryByID(ctx, draftID)
	require.NoError(t, err)
	assert.Equal(t, draftID, summaryDraft.ID())
	assert.Equal(t, "Bản nháp bài giảng 1", summaryDraft.Title().String())
	assert.Nil(t, summaryDraft.Lesson())

	// 5. Kiểm tra ReadStore.ListDrafts trả về danh sách nhẹ (LessonData == nil)
	draftList, err := readStore.ListDrafts(ctx)
	require.NoError(t, err)
	require.Len(t, draftList, 1)
	assert.Equal(t, draftID, draftList[0].ID)
	assert.Equal(t, "Bản nháp bài giảng 1", draftList[0].Title)
	assert.Nil(t, draftList[0].LessonData, "ListDrafts không được nạp LessonData để chống giật lag UI")

	// 6. Kiểm tra ReadStore.GetDraft vẫn nạp đầy đủ LessonData khi xem chi tiết
	draftDetail, err := readStore.GetDraft(ctx, draftID)
	require.NoError(t, err)
	assert.Equal(t, draftID, draftDetail.ID)
	assert.NotNil(t, draftDetail.LessonData, "GetDraft bắt buộc phải nạp đầy đủ LessonData")
	assert.Equal(t, "Bài học kiểm thử", draftDetail.LessonData.Title)
}
