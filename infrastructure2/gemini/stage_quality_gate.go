package gemini

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"
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
				if reAsm, errAsm := q.assembler.Assemble(plan, workers); errAsm == nil {
					asmResult = reAsm
				} else {
					fmt.Printf("⚠️ [QualityGate Pre-Audit] Lắp ráp lại thất bại: %v\n", errAsm)
				}
			}
		}
	}

	// 3. VÒNG LẶP BIÊN DỊCH VÀ TỰ PHỤC HỒI (SELF-HEALING LOOP)
	maxRetries := 6
	var lastCompilerErr error
	var teacherPDF string
	var studentPDF string
	var compilerIssues []ValidationIssue
	slotFailureCount := make(map[string]int)

	for attempt := 1; attempt <= maxRetries; attempt++ {
		gvOpts := CompileOptions{
			IsTeacher:  true,
			OutPDFPath: filepath.Join(outDir, "GIAO_AN_GIAO_VIEN.pdf"),
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
		failedPath := filepath.Join(outDir, fmt.Sprintf("failed_attempt_%d.typ", attempt))
		if wErr := os.WriteFile(failedPath, []byte(asmResult.Markup), 0644); wErr != nil {
			fmt.Printf("⚠️ [QualityGate] Không thể ghi file lỗi %s: %v\n", failedPath, wErr)
		}

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

			compilerIssues = nil
			seenSlots := make(map[string]bool)

			for _, diag := range diags {
				slotID, ok := asmResult.SourceMap.GetSlotIDByLine(diag.LineNumber)
				if !ok {
					slotID, ok = asmResult.SourceMap.FindNearestSlotID(diag.LineNumber)
				}
				if ok && !seenSlots[slotID] {
					seenSlots[slotID] = true
					slotFailureCount[slotID]++
					if slot, found := asmResult.Registry.Get(slotID); found && slot.Value != nil {
						reason := diag.ErrorReason
						if reason == "" {
							reason = "Lỗi phân tích cú pháp LaTeX qua MiTeX"
						}
						if slotFailureCount[slotID] > 1 {
							reason += fmt.Sprintf(" (LƯU Ý LẶP LẠI %d LẦN: Hãy kiểm tra các lệnh LaTeX viết dính chữ cái như \\ncos thành n \\cos, hoặc viết sai tên lệnh)", slotFailureCount[slotID])
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
						if reAsm, errAsm := q.assembler.Assemble(plan, workers); errAsm == nil {
							asmResult = reAsm
							continue
						} else {
							fmt.Printf("⚠️ [QualityGate] Lắp ráp lại thất bại: %v\n", errAsm)
						}
					}

					// Lưới an toàn PlainText Fallback:
					// Nếu nội dung sau sửa không đổi (hoặc ở vòng thử attempt >= 3) mà số lượng lỗi nhỏ (<= 3),
					// tự động chuyển các vị trí lỗi này sang PlainText an toàn để đảm bảo xuất bản PDF thành công.
					if len(compilerIssues) <= 3 {
						fmt.Printf("🛡️ [QualityGate SafetyNet] Phát hiện %d vị trí lỗi nhỏ (<= 3), tự động chuyển sang PlainText an toàn...\n", len(compilerIssues))
						for _, issue := range compilerIssues {
							safeContent := ConvertToSafePlainText(issue.Content)
							asmResult.Registry.Update(issue.SlotID, safeContent)
							fmt.Printf("🛡️ [QualityGate SafetyNet] Đã chuyển vị trí %s sang PlainText an toàn\n", issue.SlotID)
						}
						if reAsm, errAsm := q.assembler.Assemble(plan, workers); errAsm == nil {
							asmResult = reAsm
							resRetry, errRetry := q.compiler.Compile(ctx, asmResult.Markup, gvOpts)
							if errRetry == nil && resRetry != nil && resRetry.Success {
								teacherPDF = resRetry.PDFPath
								fmt.Println("✅ [QualityGate SafetyNet] Biên dịch Giáo viên thành công nhờ PlainText Fallback!")
								break
							}
						}
					}

					fmt.Println("⚠️ [QualityGate] Nội dung sau sửa không đổi, chờ 5s trước khi thử lại...")
					time.Sleep(5 * time.Second)
					continue
				}
			}
		}
		break
	}

	if teacherPDF == "" && len(compilerIssues) > 0 && len(compilerIssues) <= 3 {
		fmt.Printf("🛡️ [QualityGate SafetyNet Cuối] Đang chuyển đổi %d vị trí lỗi nhỏ còn lại sang PlainText an toàn...\n", len(compilerIssues))
		for _, issue := range compilerIssues {
			safeContent := ConvertToSafePlainText(issue.Content)
			asmResult.Registry.Update(issue.SlotID, safeContent)
		}
		if reAsm, errAsm := q.assembler.Assemble(plan, workers); errAsm == nil {
			asmResult = reAsm
			gvOpts := CompileOptions{
				IsTeacher:  true,
				OutPDFPath: filepath.Join(outDir, "GIAO_AN_GIAO_VIEN.pdf"),
			}
			resFinal, errFinal := q.compiler.Compile(ctx, asmResult.Markup, gvOpts)
			if errFinal == nil && resFinal != nil && resFinal.Success {
				teacherPDF = resFinal.PDFPath
				fmt.Println("✅ [QualityGate SafetyNet] Biên dịch Giáo viên thành công ở bước an toàn cuối cùng!")
			}
		}
	}

	if teacherPDF == "" {
		return nil, fmt.Errorf("biên dịch Typst thất bại sau %d lần thử: %v", maxRetries, lastCompilerErr)
	}

	hsOpts := CompileOptions{
		IsTeacher:  false,
		OutPDFPath: filepath.Join(outDir, "PHIEU_BAI_TAP_HOC_SINH.pdf"),
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

// ConvertToSafePlainText chuyển đổi nội dung công thức toán bị lỗi cú pháp sang dạng văn bản thuần an toàn
// để Typst biên dịch trực tiếp mà không bị crash qua plugin MiTeX.
func ConvertToSafePlainText(content string) string {
	res := content
	// 1. Vá lỗi dính chữ thường gặp
	res = strings.ReplaceAll(res, `\ncos`, `n cos`)
	res = strings.ReplaceAll(res, `\nsin`, `n sin`)
	res = strings.ReplaceAll(res, `\ntan`, `n tan`)
	res = strings.ReplaceAll(res, `\cos`, `cos`)
	res = strings.ReplaceAll(res, `\sin`, `sin`)
	res = strings.ReplaceAll(res, `\tan`, `tan`)
	res = strings.ReplaceAll(res, `\alpha`, `α`)
	res = strings.ReplaceAll(res, `\beta`, `β`)
	res = strings.ReplaceAll(res, `\gamma`, `γ`)
	res = strings.ReplaceAll(res, `\theta`, `θ`)
	res = strings.ReplaceAll(res, `\sqrt`, `sqrt`)
	res = strings.ReplaceAll(res, `\vec`, ``)
	res = strings.ReplaceAll(res, `\cdot`, `·`)
	res = strings.ReplaceAll(res, `\times`, `×`)
	res = strings.ReplaceAll(res, `\frac`, ``)
	// 2. Tháo bỏ dấu $ để không bị MiTeX parse
	res = strings.ReplaceAll(res, "$", "")
	// 3. Escape ký tự Typst đặc biệt ngoài toán: #, _
	var sb strings.Builder
	runes := []rune(res)
	for i := 0; i < len(runes); i++ {
		r := runes[i]
		if r == '#' && (i == 0 || runes[i-1] != '\\') {
			sb.WriteString(`\#`)
			continue
		}
		if r == '_' && (i == 0 || runes[i-1] != '\\') {
			sb.WriteString(`\_`)
			continue
		}
		sb.WriteRune(r)
	}
	return sb.String()
}
