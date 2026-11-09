package database_test

import (
	"context"
	"testing"

	"meet-attendance-clean/infrastructure2/database"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestAPIKeys_SQLite(t *testing.T) {
	ctx := context.Background()
	store, err := database.Open(":memory:")
	require.NoError(t, err)
	defer func() {
		if closeErr := store.Close(); closeErr != nil {
			t.Logf("cảnh báo đóng store: %v", closeErr)
		}
	}()

	repo := database.APIKeys{Store: store}

	// 1. Khi chưa có key
	key, err := repo.GetKey(ctx, "gemini")
	require.NoError(t, err)
	assert.Empty(t, key)

	// 2. Lưu key cho Gemini
	err = repo.SetKey(ctx, "gemini", "AIzaSyTestGeminiKey123")
	require.NoError(t, err)

	// 3. Lấy lại key Gemini
	key, err = repo.GetKey(ctx, "gemini")
	require.NoError(t, err)
	assert.Equal(t, "AIzaSyTestGeminiKey123", key)

	// 4. Lưu key cho DeepSeek
	err = repo.SetKey(ctx, "deepseek", "sk-test-deepseek-key-456")
	require.NoError(t, err)

	keyDS, err := repo.GetKey(ctx, "deepseek")
	require.NoError(t, err)
	assert.Equal(t, "sk-test-deepseek-key-456", keyDS)

	// 5. Cập nhật key (Upsert)
	err = repo.SetKey(ctx, "deepseek", "sk-updated-key-789")
	require.NoError(t, err)

	keyUpdated, err := repo.GetKey(ctx, "deepseek")
	require.NoError(t, err)
	assert.Equal(t, "sk-updated-key-789", keyUpdated)

	// 6. GetAll
	allKeys, err := repo.GetAll(ctx)
	require.NoError(t, err)
	assert.Len(t, allKeys, 2)
	assert.Equal(t, "AIzaSyTestGeminiKey123", allKeys["gemini"])
	assert.Equal(t, "sk-updated-key-789", allKeys["deepseek"])

	// 7. Validation errors
	err = repo.SetKey(ctx, "", "some-key")
	assert.Error(t, err)

	_, err = repo.GetKey(ctx, "")
	assert.Error(t, err)
}
