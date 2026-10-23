package gemini

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"time"
)

// =============================================================================
// PIPELINE ORCHESTRATOR: ĐIỀU PHỐI TOÀN BỘ VÒNG ĐỜI BÀI GIẢNG (STAGES 1 -> 4)
// =============================================================================

// LessonPipeline interface trung tâm điều phối toàn bộ luồng bài giảng
type LessonPipeline interface {
	Execute(ctx context.Context, req PipelineRequest) (*PipelineOutput, error)
}

// DefaultLessonPipeline điều phối tuần tự qua các stage
type DefaultLessonPipeline struct {
	planner  PlannerStage
	reviewer PlanReviewerStage // Stage 1.5: Thẩm định và tinh chỉnh dạng toán
	polisher PlanPolisherStage // Stage 1.75: Sắp xếp sư phạm (Flash Lite)
	author   AuthoringStage
	visual   VisualEnrichmentStage // Stage 2.5: Làm giàu hình ảnh (CeTZ/Crop)
	qg       QualityGateStage
}

// NewDefaultLessonPipeline khởi tạo pipeline hoàn chỉnh
func NewDefaultLessonPipeline(
	planner PlannerStage,
	author AuthoringStage,
	visual VisualEnrichmentStage,
	qg QualityGateStage,
) *DefaultLessonPipeline {
	if visual == nil {
		visual = NewNoOpVisualStage()
	}
	return &DefaultLessonPipeline{
		planner: planner,
		author:  author,
		visual:  visual,
		qg:      qg,
	}
}

// WithReviewer gắn thêm Stage 1.5 Reviewer vào pipeline
func (p *DefaultLessonPipeline) WithReviewer(reviewer PlanReviewerStage) *DefaultLessonPipeline {
	p.reviewer = reviewer
	return p
}

// WithPolisher gắn thêm Stage 1.75 Polisher vào pipeline
func (p *DefaultLessonPipeline) WithPolisher(polisher PlanPolisherStage) *DefaultLessonPipeline {
	p.polisher = polisher
	return p
}

// Execute: Điều phối toàn bộ luồng bài giảng qua các giai đoạn nối tiếp.
func (p *DefaultLessonPipeline) Execute(ctx context.Context, req PipelineRequest) (*PipelineOutput, error) {
	start := time.Now()

	if p.planner == nil || p.author == nil || p.qg == nil {
		return nil, fmt.Errorf("pipeline chưa được cấu hình đầy đủ các stage bắt buộc")
	}

	// Giai đoạn 1: Lập kế hoạch bài học
	fmt.Println("👉 [Stage 1: Planner] Đang phân tích tài liệu để lập kế hoạch bài giảng...")
	plan, err := p.planner.Plan(ctx, req.Documents, req.UserInstruction)
	if err != nil {
		return nil, fmt.Errorf("Stage 1 (Planner) thất bại: %w", err)
	}
	fmt.Printf("✅ [Stage 1: Planner] Hoàn tất! Phân chia được %d dạng toán.\n", len(plan.Topics))

	// Giai đoạn 1.5: Review và kiểm định độ bao phủ
	if p.reviewer != nil {
		fmt.Println("👉 [Stage 1.5: Reviewer] Đang kiểm định độ bao phủ và tinh chỉnh dạng toán...")
		refinedPlan, errRev := p.reviewer.Review(ctx, plan, req.Documents)
		if errRev == nil && refinedPlan != nil {
			plan = refinedPlan
		}
		fmt.Printf("✅ [Stage 1.5: Reviewer] Hoàn tất kiểm định! Danh mục chuẩn: %d dạng toán.\n", len(plan.Topics))
	}

	// Giai đoạn 1.75: Chuốt và sắp xếp dạng toán theo tiến trình sư phạm (Flash Lite)
	if p.polisher != nil {
		fmt.Println("👉 [Stage 1.75: Polisher] Đang sắp xếp dạng toán theo tiến trình sư phạm (Flash Lite)...")
		polishedPlan, errPol := p.polisher.Polish(ctx, plan)
		if errPol == nil && polishedPlan != nil {
			plan = polishedPlan
		}
		fmt.Printf("✅ [Stage 1.75: Polisher] Hoàn tất sắp xếp sư phạm: %d dạng toán.\n", len(plan.Topics))
	}
	_ = SaveArtifact("phase1_plan.json", plan)

	// Giai đoạn 2: Biên soạn bài tập song song
	fmt.Printf("👉 [Stage 2: Authoring] Đang khởi động Worker Pool biên soạn song song %d dạng toán...\n", len(plan.Topics))
	workers, err := p.author.Author(ctx, req.Documents, plan)
	if err != nil {
		return nil, fmt.Errorf("Stage 2 (Authoring) thất bại: %w", err)
	}
	fmt.Printf("✅ [Stage 2: Authoring] Hoàn tất biên soạn %d dạng toán!\n", len(workers))
	_ = SaveArtifact("phase2_all_results.json", workers)

	// Giai đoạn 2.5: Làm giàu hình ảnh nếu cần (CeTZ / Image Crop)
	if p.visual != nil {
		enriched, errVisual := p.visual.Enrich(ctx, plan, workers)
		if errVisual == nil && len(enriched) > 0 {
			workers = enriched
		}
	}

	// Giai đoạn 3 & 4: Thẩm định toán, biên dịch Typst và xuất PDF
	fmt.Println("👉 [Stage 3 & 4: Quality Gate] Đang lắp ráp Typst markup và biên dịch PDF...")
	output, err := p.qg.VerifyAndCompile(ctx, plan, workers, req.OutputDir)
	if err != nil {
		return nil, fmt.Errorf("Stage 3 & 4 (QualityGate) thất bại: %w", err)
	}
	fmt.Println("✅ [Stage 3 & 4: Quality Gate] Biên dịch thành công 2 bản PDF!")

	if output != nil {
		if output.Plan == nil {
			output.Plan = plan
		}
		if len(output.Workers) == 0 {
			output.Workers = workers
		}
		output.Duration = time.Since(start)
	}
	return output, nil
}

// NewStandardLessonPipeline: Khởi tạo toàn bộ Pipeline production chuẩn với Gemini KeyPool và Typst Compiler
func NewStandardLessonPipeline(ctx context.Context, apiKeys []string, modelName string) (*DefaultLessonPipeline, error) {
	if modelName == "" {
		modelName = ModelGemma4_31B
	}
	pool, err := NewKeyPool(ctx, apiKeys)
	if err != nil {
		return nil, fmt.Errorf("khởi tạo KeyPool thất bại: %w", err)
	}

	llm := NewGeminiLLMProvider(pool, modelName)
	compiler := NewCLITypstCompiler()

	planner := NewDefaultPlannerStage(llm, modelName)
	auditor := NewDefaultPlanAuditor()
	reviewer := NewDefaultPlanReviewerStage(llm, auditor, modelName)
	author := NewDefaultAuthoringStage(llm, modelName, 12) // Concurrency 12 tăng tốc độ biên soạn song song gấp 4 lần
	visual := NewNoOpVisualStage()

	assembler := NewDefaultDocumentAssembler()
	validator := NewDefaultMathValidator()
	repairModel := "gemini-3.5-flash-lite"
	repairLLM := NewGeminiLLMProvider(pool, repairModel)
	polisher := NewDefaultPlanPolisherStage(repairLLM, repairModel)
	repairer := NewDefaultBatchRepairer(repairLLM, repairModel)
	qualityGate := NewDefaultQualityGateStage(assembler, compiler, repairer, validator)

	pipeline := NewDefaultLessonPipeline(planner, author, visual, qualityGate)
	pipeline.WithReviewer(reviewer)
	pipeline.WithPolisher(polisher)
	return pipeline, nil
}

// NewDocumentInputFromPDF: Hàm tiện ích đọc file PDF từ đĩa thành DocumentInput
func NewDocumentInputFromPDF(docID, filePath, roleHint string) (DocumentInput, error) {
	data, err := os.ReadFile(filePath)
	if err != nil {
		return DocumentInput{}, fmt.Errorf("không thể đọc file PDF %q: %w", filePath, err)
	}
	return DocumentInput{
		DocID:    docID,
		FileName: filepath.Base(filePath),
		RoleHint: roleHint,
		RawPDF:   data,
	}, nil
}
