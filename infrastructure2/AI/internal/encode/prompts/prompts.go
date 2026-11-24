package prompts

import (
	"embed"
	"errors"
	"fmt"
	"strings"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

//go:embed assets/*
var promptAssets embed.FS

// HarvesterRequest builds the Phase 1A inventory harvesting LLMRequest.
func HarvesterRequest(docs []raw.Document, model string, maxTokens int) (raw.LLMRequest, error) {
	if len(docs) == 0 {
		return raw.LLMRequest{}, errors.New("documents must not be empty")
	}
	schema, err := readAsset("assets/inventory_schema.json")
	if err != nil {
		return raw.LLMRequest{}, err
	}
	sysTmpl, err := readAsset("assets/harvester_system.txt")
	if err != nil {
		return raw.LLMRequest{}, err
	}
	userTmpl, err := readAsset("assets/harvester_user.txt")
	if err != nil {
		return raw.LLMRequest{}, err
	}

	resolvedModel := resolveModel(model)
	cfg := buildConfig(resolvedModel, maxTokens, 0.1)
	return raw.LLMRequest{
		Model:        resolvedModel,
		SystemPrompt: fmt.Sprintf(sysTmpl, strings.TrimSpace(schema)),
		UserPrompt:   fmt.Sprintf(userTmpl, len(docs)),
		Documents:    docs,
		Config:       &cfg,
	}, nil
}

// PlannerRequest builds the Phase 1B curriculum planning LLMRequest from a DocumentInventory.
func PlannerRequest(inventory raw.DocumentInventory, userPrompt string, model string, maxTokens int) (raw.LLMRequest, error) {
	if len(inventory.Items) == 0 {
		return raw.LLMRequest{}, errors.New("inventory items must not be empty")
	}
	schema, err := readAsset("assets/planner_schema.json")
	if err != nil {
		return raw.LLMRequest{}, err
	}
	sysTmpl, err := readAsset("assets/planner_system.txt")
	if err != nil {
		return raw.LLMRequest{}, err
	}
	userTmpl, err := readAsset("assets/planner_user.txt")
	if err != nil {
		return raw.LLMRequest{}, err
	}

	var invBuilder strings.Builder
	for _, item := range inventory.Items {
		solTag := ""
		if item.HasSolution {
			solTag = "[Có lời giải]"
		}
		invBuilder.WriteString(fmt.Sprintf("- ID: %s | Nguồn: %s - %s | Loại: %s %s\n  Mô tả: %s\n",
			item.ID, item.SourceName, item.SourceLabel, item.ItemType, solTag, item.Snippet))
	}

	resolvedModel := resolveModel(model)
	cfg := buildConfig(resolvedModel, maxTokens, 0.2)
	return raw.LLMRequest{
		Model:        resolvedModel,
		SystemPrompt: fmt.Sprintf(sysTmpl, strings.TrimSpace(schema)),
		UserPrompt:   fmt.Sprintf(userTmpl, len(inventory.Items), invBuilder.String(), strings.TrimSpace(userPrompt)),
		Documents:    nil,
		Config:       &cfg,
	}, nil
}

// TopicRequest builds the Phase 2 topic authoring LLMRequest with assigned questions and prefix docs.
func TopicRequest(topic raw.TopicPlan, docs []raw.Document, inventory raw.DocumentInventory, userPrompt string, model string, maxTokens int) (raw.LLMRequest, error) {
	if strings.TrimSpace(topic.TopicID) == "" && strings.TrimSpace(topic.Title) == "" {
		return raw.LLMRequest{}, errors.New("topic_id and title must not both be empty")
	}
	sysPrompt, err := readAsset("assets/topic_system.txt")
	if err != nil {
		return raw.LLMRequest{}, err
	}
	userTmpl, err := readAsset("assets/topic_user.txt")
	if err != nil {
		return raw.LLMRequest{}, err
	}

	assignedDetails := formatAssignedQuestions(topic.AssignedQuestionIDs, inventory)
	variantsStr := strings.Join(topic.Variants, "; ")
	if strings.TrimSpace(variantsStr) == "" {
		variantsStr = "Tự phân tích các biến thể hợp lý"
	}

	fullUser := fmt.Sprintf(
		userTmpl,
		topic.TopicID,
		topic.Title,
		topic.Difficulty,
		topic.TargetOutput,
		topic.CoreConcept,
		variantsStr,
		assignedDetails,
		topic.TopicID,
		topic.Title,
		topic.Difficulty,
		strings.TrimSpace(userPrompt),
	)

	resolvedModel := resolveModel(model)
	cfg := buildConfig(resolvedModel, maxTokens, 0.2)
	return raw.LLMRequest{
		Model:        resolvedModel,
		SystemPrompt: sysPrompt,
		UserPrompt:   fullUser,
		Documents:    docs,
		Config:       &cfg,
	}, nil
}

// RepairMathRequest builds the Phase 3 math syntax repair LLMRequest for broken fields.
func RepairMathRequest(tasks []raw.RepairTask, model string) (raw.LLMRequest, error) {
	if len(tasks) == 0 {
		return raw.LLMRequest{}, errors.New("repair tasks must not be empty")
	}
	sysPrompt, err := readAsset("assets/repair_system.txt")
	if err != nil {
		return raw.LLMRequest{}, err
	}

	var sb strings.Builder
	sb.WriteString("DANH SÁCH CÁC MỤC BỊ LỖI CÚ PHÁP CẦN SỬA:\n\n")
	for idx, t := range tasks {
		sb.WriteString(fmt.Sprintf(
			"Mục %d:\n* Mã target_id (BẮT BUỘC giữ nguyên): %s\n* Ngữ cảnh: %s\n* Nguyên nhân lỗi: %s\n* Toàn văn cần sửa: %s\n\n",
			idx+1, t.TargetID, t.Context, t.ErrorReason, t.Content,
		))
	}

	resolvedModel := resolveModel(model)
	cfg := raw.GenerationConfig{
		Temperature:    0.1,
		MaxTokens:      8192,
		ResponseFormat: &raw.ResponseFormatConfig{Type: "json_object"},
	}
	return raw.LLMRequest{
		Model:        resolvedModel,
		SystemPrompt: sysPrompt,
		UserPrompt:   sb.String(),
		Config:       &cfg,
	}, nil
}

func readAsset(path string) (string, error) {
	b, err := promptAssets.ReadFile(path)
	if err != nil {
		return "", fmt.Errorf("read prompt asset %s: %w", path, err)
	}
	return string(b), nil
}

func resolveModel(model string) string {
	trimmed := strings.TrimSpace(model)
	if trimmed == "" {
		return "deepseek-chat"
	}
	return trimmed
}

func buildConfig(model string, maxTokens int, temperature float32) raw.GenerationConfig {
	if maxTokens <= 0 {
		if strings.Contains(strings.ToLower(model), "chat") {
			maxTokens = 8192
		} else {
			maxTokens = 64000
		}
	}
	return raw.GenerationConfig{
		Temperature:    temperature,
		MaxTokens:      maxTokens,
		ResponseFormat: &raw.ResponseFormatConfig{Type: "json_object"},
	}
}

func formatAssignedQuestions(assignedIDs []string, inventory raw.DocumentInventory) string {
	if len(assignedIDs) == 0 {
		return ""
	}
	itemMap := make(map[string]raw.InventoryItem, len(inventory.Items))
	for _, item := range inventory.Items {
		itemMap[item.ID] = item
	}

	var sb strings.Builder
	sb.WriteString(fmt.Sprintf("DANH SÁCH BÀI TẬP ĐƯỢC PHÂN BỔ CHO DẠNG NÀY (%d mục):\n", len(assignedIDs)))
	for _, qid := range assignedIDs {
		if item, found := itemMap[qid]; found {
			sol := ""
			if item.HasSolution {
				sol = "[Có lời giải mẫu]"
			}
			sb.WriteString(fmt.Sprintf("- [%s] %s (%s) %s\n  Tóm tắt đề: %s\n",
				item.ID, item.SourceLabel, item.ItemType, sol, item.Snippet))
		} else {
			sb.WriteString(fmt.Sprintf("- [%s]\n", qid))
		}
	}
	return sb.String()
}
