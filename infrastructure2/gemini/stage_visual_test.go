package gemini_test

import (
	"context"
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"

	"github.com/stretchr/testify/assert"
)

func TestNoOpVisualStage_Enrich(t *testing.T) {
	stage := gemini.NewNoOpVisualStage()

	workers := []gemini.WorkerResult{
		{
			TopicID:      "dang_1",
			Title:        "Dạng 1",
			TheoryPoints: []string{"$a = b$"},
		},
	}

	result, err := stage.Enrich(context.Background(), nil, workers)
	assert.NoError(t, err)
	assert.Equal(t, workers, result)
}
