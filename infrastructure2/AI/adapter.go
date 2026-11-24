package ai

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/AI/internal/decode"
	"meet-attendance-clean/infrastructure2/AI/internal/driver"
	"meet-attendance-clean/infrastructure2/AI/internal/encode"
	"meet-attendance-clean/infrastructure2/AI/internal/encode/prompts"
	"meet-attendance-clean/infrastructure2/AI/internal/process"
	"meet-attendance-clean/infrastructure2/AI/internal/process/anchor"
	"meet-attendance-clean/infrastructure2/AI/internal/process/mathaudit"
	"meet-attendance-clean/infrastructure2/AI/internal/process/topic"
	"meet-attendance-clean/infrastructure2/AI/internal/process/typst"
	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

// LessonGenerator coordinates the multi-phase AI lesson generation pipeline
// and implements application2.LessonGenerator.
type LessonGenerator struct {
	client *driver.Client
	media  *driver.MediaRunner
	runner *driver.TypstRunner
	model  string
}

// NewLessonGenerator constructs a LessonGenerator with API key pool, base URL, model, concurrency, and media converter callback.
func NewLessonGenerator(
	apiKeys []string,
	baseURL string,
	model string,
	workers int,
	convertMedia func(ctx context.Context, data []byte, fileType string, fileName string) ([][]byte, error),
) (*LessonGenerator, error) {
	cooldown := 100 * time.Millisecond
	if len(apiKeys) <= 1 {
		cooldown = 0
	}
	client, err := driver.NewClient(raw.ClientConfig{
		APIKeys:    apiKeys,
		BaseURL:    baseURL,
		Timeout:    180 * time.Second,
		MaxRetries: 3,
		Cooldown:   cooldown,
	})
	if err != nil {
		return nil, fmt.Errorf("init driver client: %w", err)
	}
	if strings.TrimSpace(model) == "" {
		model = "deepseek-chat"
	}
	if workers <= 0 {
		workers = 30
	}
	return &LessonGenerator{
		client: client,
		media:  driver.NewMediaRunner(convertMedia),
		runner: driver.NewTypstRunner("", workers),
		model:  strings.TrimSpace(model),
	}, nil
}

// WithOutputDir sets an optional directory where JSON/Typst/PDF artifacts are persisted.
func (g *LessonGenerator) WithOutputDir(dir string) *LessonGenerator {
	if g.runner != nil {
		g.runner.WithOutputDir(dir)
	}
	return g
}

// WithSelectedTopics restricts Phase 2 generation to the specified TopicIDs.
func (g *LessonGenerator) WithSelectedTopics(ids []string) *LessonGenerator {
	if g.runner != nil {
		g.runner.WithSelectedTopics(ids)
	}
	return g
}

// WithTypstCLI configures a custom Typst executable path.
func (g *LessonGenerator) WithTypstCLI(cli string) *LessonGenerator {
	if g.runner != nil {
		g.runner.WithTypstCLI(cli)
	}
	return g
}

// Generate runs the full Phase 0 -> Phase 1A -> Phase 1B -> Phase 1.5 -> Phase 2 -> Phase 3 -> Phase 4/5 pipeline.
func (g *LessonGenerator) Generate(
	ctx context.Context,
	title string,
	materials []lesson.StudyMaterial,
	model string,
	prompt string,
) (*lesson.Lesson, error) {
	if err := ctx.Err(); err != nil {
		return nil, fmt.Errorf("generate context: %w", err)
	}
	activeModel := g.resolveModel(model)
	docs, err := g.materializeDocs(ctx, materials)
	if err != nil {
		return nil, err
	}
	inv, err := g.runHarvester(ctx, docs, activeModel)
	if err != nil {
		return nil, err
	}
	plan, err := g.runPlanner(ctx, inv, prompt, activeModel)
	if err != nil {
		return nil, err
	}
	_ = topic.VerifyPlan(plan, prompt)
	plan = topic.FilterTopics(plan, g.runner.SelectedTopicIDs())
	contents, err := g.generateTopics(ctx, plan, docs, prompt, activeModel)
	if err != nil {
		return nil, err
	}
	contents = g.repairTopics(ctx, contents, activeModel)
	if g.runner.OutputDir() != "" {
		contents = g.selfHealTopics(ctx, contents, activeModel)
	}
	_ = topic.VerifyContent(contents, plan)
	if err := g.assembleAndPersist(ctx, plan, contents); err != nil {
		return nil, err
	}
	return decode.AssembleToLesson(plan, contents, materials)
}

func (g *LessonGenerator) resolveModel(model string) string {
	if trimmed := strings.TrimSpace(model); trimmed != "" {
		return trimmed
	}
	return g.model
}

func (g *LessonGenerator) materializeDocs(ctx context.Context, materials []lesson.StudyMaterial) ([]raw.Document, error) {
	specs, err := encode.MaterialsToSpecs(materials)
	if err != nil {
		return nil, fmt.Errorf("encode materials: %w", err)
	}
	docs, err := g.media.MaterializeDocuments(ctx, specs)
	if err != nil {
		return nil, fmt.Errorf("materialize documents: %w", err)
	}
	return docs, nil
}

func (g *LessonGenerator) runHarvester(ctx context.Context, docs []raw.Document, model string) (raw.DocumentInventory, error) {
	hReq, err := prompts.HarvesterRequest(docs, model, 0)
	if err != nil {
		return raw.DocumentInventory{}, fmt.Errorf("build harvester request: %w", err)
	}
	llmResp, err := g.callSingleLLM(ctx, hReq)
	if err != nil {
		return raw.DocumentInventory{}, fmt.Errorf("phase 1A harvester: %w", err)
	}
	inv, err := process.ParseInventory(llmResp.Content)
	if err != nil {
		return raw.DocumentInventory{}, fmt.Errorf("parse inventory: %w", err)
	}
	return inv, nil
}

func (g *LessonGenerator) runPlanner(ctx context.Context, inv raw.DocumentInventory, userPrompt, model string) (raw.LessonPlan, error) {
	pReq, err := prompts.PlannerRequest(inv, userPrompt, model, 0)
	if err != nil {
		return raw.LessonPlan{}, fmt.Errorf("build planner request: %w", err)
	}
	llmResp, err := g.callSingleLLM(ctx, pReq)
	if err != nil {
		return raw.LessonPlan{}, fmt.Errorf("phase 1B planner: %w", err)
	}
	plan, err := process.ParseLessonPlan(llmResp.Content, inv)
	if err != nil {
		return raw.LessonPlan{}, fmt.Errorf("parse lesson plan: %w", err)
	}
	return plan, nil
}

func (g *LessonGenerator) generateTopics(ctx context.Context, plan raw.LessonPlan, docs []raw.Document, userPrompt, model string) ([]raw.TopicContent, error) {
	chatReqs := make([]raw.ChatRequest, 0, len(plan.Topics))
	for i := range plan.Topics {
		tp := &plan.Topics[i]
		tReq, err := prompts.TopicRequest(*tp, docs, plan.Inventory, userPrompt, model, 0)
		if err != nil {
			return nil, fmt.Errorf("build topic request %s: %w", tp.TopicID, err)
		}
		chatReq, err := encode.ChatRequest(tReq)
		if err != nil {
			return nil, fmt.Errorf("encode topic request %s: %w", tp.TopicID, err)
		}
		chatReqs = append(chatReqs, chatReq)
	}
	results, err := g.client.CallParallel(ctx, chatReqs, g.runner.Workers())
	if err != nil {
		return nil, fmt.Errorf("phase 2 parallel generation: %w", err)
	}
	contents := make([]raw.TopicContent, len(results))
	for i, res := range results {
		llmResp, errExt := process.ExtractLLMResponse(res.Response, res.Raw, model)
		if errExt != nil {
			return nil, fmt.Errorf("extract topic %s: %w", plan.Topics[i].TopicID, errExt)
		}
		repairedJSON := process.RepairTruncatedJSON(process.SanitizeRawJSONLaTeX(llmResp.Content))
		tc, errParse := topic.ParseTopicContent(repairedJSON, plan.Topics[i])
		if errParse != nil {
			return nil, fmt.Errorf("parse topic %s: %w", plan.Topics[i].TopicID, errParse)
		}
		contents[i] = tc
	}
	return contents, nil
}

func (g *LessonGenerator) repairTopics(ctx context.Context, contents []raw.TopicContent, model string) []raw.TopicContent {
	for i := range contents {
		tasks := mathaudit.AuditTopicContent(contents[i])
		if len(tasks) == 0 {
			continue
		}
		repairedTasks := g.repairMathTasks(ctx, tasks, model)
		for _, task := range repairedTasks {
			contents[i] = anchor.SetContextField(contents[i], task.TargetID, task.FixedContent)
		}
	}
	return contents
}

func (g *LessonGenerator) repairMathTasks(ctx context.Context, tasks []raw.RepairTask, model string) []raw.RepairTask {
	rReq, err := prompts.RepairMathRequest(tasks, model)
	if err != nil {
		return mathaudit.ParseRepairBatch("", tasks)
	}
	llmResp, err := g.callSingleLLM(ctx, rReq)
	if err != nil {
		return mathaudit.ParseRepairBatch("", tasks)
	}
	cleanJSON := process.SanitizeRawJSONLaTeX(llmResp.Content)
	return mathaudit.ParseRepairBatch(cleanJSON, tasks)
}

func (g *LessonGenerator) assembleAndPersist(ctx context.Context, plan raw.LessonPlan, contents []raw.TopicContent) error {
	teacherTypst, _, err := typst.AssembleToTypst(plan, contents)
	if err != nil {
		return fmt.Errorf("assemble typst: %w", err)
	}
	if strings.TrimSpace(g.runner.OutputDir()) == "" {
		return nil
	}
	if planBytes, errJSON := json.MarshalIndent(plan, "", "  "); errJSON == nil {
		if errW := g.runner.WriteArtifact("raw_data/plan_output.json", planBytes); errW != nil {
			return errW
		}
	}
	if contBytes, errJSON := json.MarshalIndent(contents, "", "  "); errJSON == nil {
		if errW := g.runner.WriteArtifact("raw_data/topics_content.json", contBytes); errW != nil {
			return errW
		}
	}
	if errW := g.runner.WriteArtifact("raw_data/lesson.typ", []byte(teacherTypst)); errW != nil {
		return errW
	}
	g.tryCompilePDF(ctx, "raw_data/lesson.typ", "GIAO_AN_GIAO_VIEN.pdf", teacherTypst, true)
	g.tryCompilePDF(ctx, "raw_data/lesson.typ", "PHIEU_BAI_TAP_HOC_SINH.pdf", teacherTypst, false)
	return nil
}

func (g *LessonGenerator) tryCompilePDF(ctx context.Context, typRel, pdfRel, content string, isTeacher bool) {
	if _, err := g.runner.CompileTypst(ctx, typRel, pdfRel, content, isTeacher); err != nil {
		return
	}
}

func (g *LessonGenerator) selfHealTopics(ctx context.Context, contents []raw.TopicContent, model string) []raw.TopicContent {
	for i := range contents {
		tID := contents[i].TopicID
		if tcBytes, err := json.MarshalIndent(contents[i], "", "  "); err == nil {
			if errW := g.runner.WriteArtifact(fmt.Sprintf("raw_data/topic_%s_content.json", tID), tcBytes); errW != nil {
				return contents
			}
		}
		contents[i] = g.selfHealCompile(ctx, contents[i], fmt.Sprintf("raw_data/topic_%s.typ", tID), fmt.Sprintf("topics/topic_%s_teacher.pdf", tID), true, model)
		contents[i] = g.selfHealCompile(ctx, contents[i], fmt.Sprintf("raw_data/topic_%s.typ", tID), fmt.Sprintf("topics/topic_%s_student.pdf", tID), false, model)
	}
	return contents
}

func (g *LessonGenerator) selfHealCompile(ctx context.Context, tc raw.TopicContent, typRel, pdfRel string, isTeacher bool, model string) raw.TopicContent {
	failedAttempts := make(map[string]int)
	for range 3 {
		markup := typst.RenderTopicTypst(tc)
		stderr, err := g.runner.CompileTypst(ctx, typRel, pdfRel, markup, isTeacher)
		if err == nil || strings.TrimSpace(stderr) == "" {
			return tc
		}
		errTasks := anchor.ExtractCompilerErrorAnchors(markup, stderr, tc)
		if len(errTasks) == 0 {
			return tc
		}
		tc = g.applySelfHealTasks(ctx, tc, errTasks, failedAttempts, model)
	}
	return tc
}

func (g *LessonGenerator) applySelfHealTasks(
	ctx context.Context,
	tc raw.TopicContent,
	errTasks []raw.RepairTask,
	failedAttempts map[string]int,
	model string,
) raw.TopicContent {
	var toSendAI []raw.RepairTask
	for _, task := range errTasks {
		failedAttempts[task.TargetID]++
		if failedAttempts[task.TargetID] >= 2 {
			tc = anchor.SetContextField(tc, task.TargetID, mathaudit.FallbackSanitizeLaTeX(task.Content))
		} else {
			toSendAI = append(toSendAI, task)
		}
	}
	if len(toSendAI) > 0 {
		for _, task := range g.repairMathTasks(ctx, toSendAI, model) {
			tc = anchor.SetContextField(tc, task.TargetID, task.FixedContent)
		}
	}
	return tc
}

func (g *LessonGenerator) callSingleLLM(ctx context.Context, req raw.LLMRequest) (raw.LLMResponse, error) {
	chatReq, err := encode.ChatRequest(req)
	if err != nil {
		return raw.LLMResponse{}, err
	}
	chatResp, rawBytes, err := g.client.PostChat(ctx, chatReq)
	if err != nil {
		return raw.LLMResponse{}, err
	}
	return process.ExtractLLMResponse(chatResp, rawBytes, chatReq.Model)
}
