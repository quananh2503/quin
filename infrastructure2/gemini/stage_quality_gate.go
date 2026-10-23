package gemini

import (
	"context"
	"fmt"
	"os"
	"time"
)

// =============================================================================
// QUALITY GATE: THẨM ĐỊNH TOÁN, BIÊN DỊCH VÀ VÒNG LẶP SELF-HEALING QUA SOURCEMAP
// =============================================================================

// QualityGateStage: Thẩm định toán học, biên dịch và tự phục hồi
type QualityGateStage interface {
	VerifyAndCompile(ctx context.Context, plan *LessonPlan, workers []WorkerResult, outDir string) (*PipelineOutput, error)
}

// DefaultQualityGateStage thực thi Giai đoạn 3 & 4
type DefaultQualityGateStage struct {
	assembler DocumentAssembler
	compiler  TypstCompiler
	repairer  BatchRepairer
	validator MathValidator
}

// NewDefaultQualityGateStage khởi tạo QualityGateStage
func NewDefaultQualityGateStage(
	assembler DocumentAssembler,
	compiler TypstCompiler,
	repairer BatchRepairer,
	validator MathValidator,
) *DefaultQualityGateStage {
	return &DefaultQualityGateStage{
		assembler: assembler,
		compiler:  compiler,
		repairer:  repairer,
		validator: validator,
	}
}

// VerifyAndCompile: Thẩm định toán học, biên dịch và tự phục hồi (Self-Healing Loop).
func (q *DefaultQualityGateStage) VerifyAndCompile(
	ctx context.Context,
	plan *LessonPlan,
	workers []WorkerResult,
	outDir string,
) (*PipelineOutput, error) {
	start := time.Now()

	// 1. Lắp ráp ban đầu để tạo SlotRegistry
	asmResult, err := q.assembler.Assemble(plan, workers)
	if err != nil {
		return nil, fmt.Errorf("lắp ráp tài liệu ban đầu lỗi: %w", err)
	}

	// 2. PRE-AUDIT: Quét bộ nhớ RAM để tìm các trường bị hỏng trước khi biên dịch
	if q.validator != nil && q.repairer != nil {
		preIssues := q.validator.AuditRegistry(asmResult.Registry)
		if len(preIssues) > 0 {
			fixedMap, errRepair := q.repairer.RepairIssues(ctx, preIssues)
			if errRepair == nil && len(fixedMap) > 0 {
				for slotID, fixedContent := range fixedMap {
					asmResult.Registry.Update(slotID, fixedContent)
				}
				asmResult, _ = q.assembler.Assemble(plan, workers)
			}
		}
	}

	// 3. VÒNG LẶP BIÊN DỊCH VÀ TỰ PHỤC HỒI (SELF-HEALING LOOP)
	maxRetries := 6
	var lastCompilerErr error
	var teacherPDF string
	var studentPDF string

	for attempt := 1; attempt <= maxRetries; attempt++ {
		gvOpts := CompileOptions{
			IsTeacher:  true,
			OutPDFPath: fmt.Sprintf("%s/GIAO_AN_GIAO_VIEN.pdf", outDir),
		}
		resGV, errGV := q.compiler.Compile(ctx, asmResult.Markup, gvOpts)
		if errGV == nil && resGV != nil && resGV.Success {
			teacherPDF = resGV.PDFPath
			break
		}

		lastCompilerErr = errGV
		fmt.Printf("⚠️ [QualityGate Lần %d/%d] Typst biên dịch lỗi: %v\n", attempt, maxRetries, errGV)
		if resGV != nil && resGV.RawStderr != "" {
			fmt.Printf("📋 Typst stderr:\n%s\n", resGV.RawStderr)
		}
		_ = os.WriteFile(fmt.Sprintf("%s/failed_attempt_%d.typ", outDir, attempt), []byte(asmResult.Markup), 0644)

		if q.repairer != nil {
			// Thu thập toàn bộ lỗi trên file qua ScanAllTypstErrors (Line Isolation Scanner)
			diags := ScanAllTypstErrors(ctx, q.compiler, asmResult.Markup, gvOpts)
			if len(diags) == 0 && resGV != nil {
				if resGV.RawStderr != "" {
					diags = ParseTypstDiagnostics(resGV.RawStderr)
				}
				if len(diags) == 0 && len(resGV.ErrorLines) > 0 {
					for _, l := range resGV.ErrorLines {
						diags = append(diags, TypstDiagnostic{LineNumber: l, ErrorReason: "Lỗi phân tích cú pháp LaTeX qua MiTeX"})
					}
				}
			}

			var compilerIssues []ValidationIssue
			seenSlots := make(map[string]bool)

			for _, diag := range diags {
				slotID, ok := asmResult.SourceMap.GetSlotIDByLine(diag.LineNumber)
				if !ok {
					slotID, ok = asmResult.SourceMap.FindNearestSlotID(diag.LineNumber)
				}
				if ok && !seenSlots[slotID] {
					seenSlots[slotID] = true
					if slot, found := asmResult.Registry.Get(slotID); found && slot.Value != nil {
						reason := diag.ErrorReason
						if reason == "" {
							reason = "Lỗi phân tích cú pháp LaTeX qua MiTeX"
						}
						compilerIssues = append(compilerIssues, ValidationIssue{
							SlotID:        slotID,
							Reason:        reason,
							Content:       *slot.Value,
							Context:       slot.Context,
							BrokenSnippet: diag.BrokenSnippet,
						})
					}
				}
			}

			if len(compilerIssues) > 0 {
				fmt.Printf("🔧 Đang gửi 1 batch duy nhất gồm %d vị trí lỗi đến BatchRepairer...\n", len(compilerIssues))
				fixedMap, errRep := q.repairer.RepairIssues(ctx, compilerIssues)
				if errRep != nil {
					fmt.Printf("⚠️ [QualityGate] Gọi BatchRepairer thất bại (%v), chờ 5s trước khi thử lại...\n", errRep)
					time.Sleep(5 * time.Second)
					continue
				}
				if len(fixedMap) > 0 {
					anyUpdated := false
					for slotID, fixedContent := range fixedMap {
						if slot, found := asmResult.Registry.Get(slotID); found && slot.Value != nil {
							if *slot.Value != fixedContent {
								asmResult.Registry.Update(slotID, fixedContent)
								anyUpdated = true
								fmt.Printf("🔧 [QualityGate] Đã vá ô nhớ %s\n", slotID)
							}
						}
					}
					if anyUpdated {
						asmResult, _ = q.assembler.Assemble(plan, workers)
						continue
					}
					fmt.Println("⚠️ [QualityGate] Nội dung sau sửa không đổi, chờ 5s trước khi thử lại...")
					time.Sleep(5 * time.Second)
					continue
				}
			}
		}
		break
	}

	if teacherPDF == "" {
		return nil, fmt.Errorf("biên dịch Typst thất bại sau %d lần thử: %v", maxRetries, lastCompilerErr)
	}

	hsOpts := CompileOptions{
		IsTeacher:  false,
		OutPDFPath: fmt.Sprintf("%s/PHIEU_BAI_TAP_HOC_SINH.pdf", outDir),
	}
	resHS, errHS := q.compiler.Compile(ctx, asmResult.Markup, hsOpts)
	if errHS == nil && resHS != nil && resHS.Success {
		studentPDF = resHS.PDFPath
	}

	return &PipelineOutput{
		Plan:           plan,
		Workers:        workers,
		TypstMarkup:    asmResult.Markup,
		TeacherPDFPath: teacherPDF,
		StudentPDFPath: studentPDF,
		Duration:       time.Since(start),
	}, nil
}
