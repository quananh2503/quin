package policy

import (
	"strings"
	"time"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

const (
	defaultModel               = "deepseek-chat"
	defaultWorkers             = 30
	defaultTimeout             = 180 * time.Second
	defaultMaxRetries          = 3
	defaultMultiKeyCooldown    = 100 * time.Millisecond
	maxSelfHealRepairAttempts  = 2
	minimumScaledImageDimBytes = 1
)

// BuildPipelineDefaults normalizes adapter configuration into driver ClientConfig and PipelineOptions.
func BuildPipelineDefaults(apiKeys []string, baseURL, model string, workers int) (raw.ClientConfig, raw.PipelineOptions) {
	cooldown := defaultMultiKeyCooldown
	if len(apiKeys) <= 1 {
		cooldown = 0
	}
	trimmedModel := strings.TrimSpace(model)
	if trimmedModel == "" {
		trimmedModel = defaultModel
	}
	if workers <= 0 {
		workers = defaultWorkers
	}
	return raw.ClientConfig{
			APIKeys:    apiKeys,
			BaseURL:    baseURL,
			Timeout:    defaultTimeout,
			MaxRetries: defaultMaxRetries,
			Cooldown:   cooldown,
		}, raw.PipelineOptions{
			Model:   trimmedModel,
			Workers: workers,
		}
}

// ClampWorkers bounds requested worker concurrency to [1, total] when total > 0, or 0 otherwise.
func ClampWorkers(workers, total int) int {
	if total <= 0 {
		return 0
	}
	if workers <= 0 {
		return 1
	}
	if workers > total {
		return total
	}
	return workers
}

// ClampImageDimensions computes proportional target dimensions bounded by maxDim for Vision input.
func ClampImageDimensions(width, height, maxDim int) (targetW, targetH int, shouldResize bool) {
	if width <= 0 || height <= 0 || maxDim <= 0 {
		return width, height, false
	}
	if width <= maxDim && height <= maxDim {
		return width, height, false
	}
	if width > height {
		targetW = maxDim
		targetH = int(float64(height) * float64(maxDim) / float64(width))
	} else {
		targetH = maxDim
		targetW = int(float64(width) * float64(maxDim) / float64(height))
	}
	if targetW < minimumScaledImageDimBytes {
		targetW = minimumScaledImageDimBytes
	}
	if targetH < minimumScaledImageDimBytes {
		targetH = minimumScaledImageDimBytes
	}
	return targetW, targetH, true
}

// PartitionSelfHealTasks splits compiler-error repair tasks between AI repair and deterministic fallback.
func PartitionSelfHealTasks(
	tasks []raw.RepairTask,
	attempts map[string]int,
) (toSendAI []raw.RepairTask, toFallback []raw.RepairTask) {
	for _, task := range tasks {
		count := 1
		if attempts != nil {
			attempts[task.TargetID]++
			count = attempts[task.TargetID]
		}
		if count >= maxSelfHealRepairAttempts {
			toFallback = append(toFallback, task)
		} else {
			toSendAI = append(toSendAI, task)
		}
	}
	return toSendAI, toFallback
}
