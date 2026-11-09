package pipeline

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"meet-attendance-clean/infrastructure2/AI"
)

// DefaultOrchestrator triển khai Orchestrator interface (thay thế cho tonghop.go).
// Nhiệm vụ: Điều phối tuần tự toàn bộ vòng đời tạo bài học:
// 0. Preprocessor: Chuyển đổi domain2.document thành các trang JPEG & Text thô qua media.Converter
// 1. Planner (chia nhỏ dạng toán dựa trên tài liệu và userPrompt)
// 2. Verifier (kiểm tra có sót câu hỏi nào không theo userPrompt)
// 3. Generator (biên soạn nội dung từng dạng qua Worker Pool song song, bám sát userPrompt)
// 4. Repairer (kiểm tra và sửa lỗi cú pháp toán/định dạng)
// 5. Assembler (ghép lại thành Lesson Entity và tài liệu Typst)
type DefaultOrchestrator struct {
	preprocessor Preprocessor
	planner      Planner
	generator    Generator
	verifier     Verifier
	repairer     Repairer
	assembler    Assembler
}

// NewOrchestrator khởi tạo DefaultOrchestrator với đầy đủ các Stage dependency injection.
func NewOrchestrator(
	preprocessor Preprocessor,
	planner Planner,
	generator Generator,
	verifier Verifier,
	repairer Repairer,
	assembler Assembler,
) *DefaultOrchestrator {
	return &DefaultOrchestrator{
		preprocessor: preprocessor,
		planner:      planner,
		generator:    generator,
		verifier:     verifier,
		repairer:     repairer,
		assembler:    assembler,
	}
}

// Execute điều phối toàn bộ pipeline từ đầu đến cuối một cách chặt chẽ và ổn định.
func (o *DefaultOrchestrator) Execute(ctx context.Context, req PipelineRequest) (*PipelineResult, error) {
	start := time.Now()

	// 0. Tiền xử lý tài liệu nguồn nếu có
	if len(req.SourceDocs) > 0 && o.preprocessor != nil {
		docs, errPre := o.preprocessor.PreprocessBatch(ctx, req.SourceDocs)
		if errPre != nil {
			return nil, fmt.Errorf("tiền xử lý tài liệu nguồn thất bại: %w", errPre)
		}
		req.Documents = append(req.Documents, docs...)
	}

	if len(req.Documents) == 0 {
		return nil, fmt.Errorf("không có tài liệu đầu vào hợp lệ để thực thi pipeline")
	}

	// 1. Giai đoạn 1: Lập kế hoạch bài học (Planner)
	if o.planner == nil {
		return nil, fmt.Errorf("planner chưa được cấu hình")
	}
	plan, respPlan, errPlan := o.planner.Plan(ctx, req.Documents, req.UserPrompt)
	if errPlan != nil {
		return nil, fmt.Errorf("lập kế hoạch bài học thất bại: %w", errPlan)
	}

	// Ghi nhận token sử dụng nếu có
	var totalUsage ai.Usage
	if respPlan != nil && respPlan.Usage != nil {
		totalUsage = respPlan.Usage
	}

	// 2. Giai đoạn 2.5: Kiểm định kế hoạch (Verifier - nếu có)
	if o.verifier != nil {
		report, errVer := o.verifier.VerifyPlan(ctx, plan, req.Documents, req.UserPrompt)
		if errVer != nil {
			return nil, fmt.Errorf("kiểm định kế hoạch bài học thất bại: %w", errVer)
		}
		if report != nil && report.NeedsRefinement && len(report.UnassignedIDs) > 0 {
			// Ghi chú nếu cần mở rộng thêm dạng toán
		}
	}

	// Lọc danh sách dạng toán nếu có yêu cầu SelectedTopicIDs
	if len(req.SelectedTopicIDs) > 0 {
		filterMap := make(map[string]bool)
		for _, id := range req.SelectedTopicIDs {
			filterMap[strings.ToUpper(strings.TrimSpace(id))] = true
		}
		var filteredTopics []TopicPlan
		for _, tp := range plan.Topics {
			if filterMap[strings.ToUpper(tp.TopicID)] {
				filteredTopics = append(filteredTopics, tp)
			}
		}
		if len(filteredTopics) > 0 {
			plan.Topics = filteredTopics
		}
	}

	// 3. Giai đoạn 2: Biên soạn chi tiết các dạng toán qua Worker Pool song song (Generator)
	if o.generator == nil {
		return nil, fmt.Errorf("generator chưa được cấu hình")
	}
	workers := req.Workers
	if workers <= 0 {
		workers = 30
	}
	contents, errGen := o.generator.GenerateAll(ctx, plan, req.Documents, req.UserPrompt, workers)
	if errGen != nil {
		return nil, fmt.Errorf("biên soạn nội dung các dạng toán thất bại: %w", errGen)
	}

	// 4. Giai đoạn 3: Rà soát & Tự động sửa lỗi cú pháp (Repairer)
	if o.repairer != nil {
		for i := range contents {
			tasks := AuditTopicContent(&contents[i])
			if len(tasks) > 0 {
				repaired, errRep := o.repairer.RepairMath(ctx, tasks)
				if errRep == nil && len(repaired) > 0 {
					for _, task := range repaired {
						SetContextField(&contents[i], task.TargetID, task.FixedContent)
					}
				}
			}
		}
	}

	// 5. Giai đoạn 4 & 5: Dàn trang và xuất bản tài liệu Typst (Assembler)
	var teacherTypst, studentTypst string
	var teacherPDFPath, studentPDFPath string

	if o.assembler != nil {
		tTyp, sTyp, errAsm := o.assembler.AssembleToTypst(plan, contents)
		if errAsm != nil {
			return nil, fmt.Errorf("lắp ráp tài liệu Typst thất bại: %w", errAsm)
		}
		teacherTypst = tTyp
		studentTypst = sTyp
	}

	// 6. Lưu kết quả và biên dịch PDF nếu có thư mục OutputDir
	if req.OutputDir != "" {
		topicsDir := filepath.Join(req.OutputDir, "topics")
		rawDataDir := filepath.Join(req.OutputDir, "raw_data")

		if errMkdir := os.MkdirAll(req.OutputDir, 0755); errMkdir != nil {
			return nil, fmt.Errorf("tạo thư mục xuất %s thất bại: %w", req.OutputDir, errMkdir)
		}
		if errMkdirTopics := os.MkdirAll(topicsDir, 0755); errMkdirTopics != nil {
			return nil, fmt.Errorf("tạo thư mục topics %s thất bại: %w", topicsDir, errMkdirTopics)
		}
		if errMkdirRaw := os.MkdirAll(rawDataDir, 0755); errMkdirRaw != nil {
			return nil, fmt.Errorf("tạo thư mục raw_data %s thất bại: %w", rawDataDir, errMkdirRaw)
		}

		// Lưu Plan JSON vào raw_data
		planJSONBytes, errPlanJSON := json.MarshalIndent(plan, "", "  ")
		if errPlanJSON != nil {
			return nil, fmt.Errorf("serialize kế hoạch bài học thất bại: %w", errPlanJSON)
		}
		planPath := filepath.Join(rawDataDir, "plan_output.json")
		if errWritePlan := os.WriteFile(planPath, planJSONBytes, 0644); errWritePlan != nil {
			return nil, fmt.Errorf("ghi file %s thất bại: %w", planPath, errWritePlan)
		}

		// Lưu Contents JSON vào raw_data
		contentsJSONBytes, errContentJSON := json.MarshalIndent(contents, "", "  ")
		if errContentJSON != nil {
			return nil, fmt.Errorf("serialize nội dung bài học thất bại: %w", errContentJSON)
		}
		contentPath := filepath.Join(rawDataDir, "topics_content.json")
		if errWriteContent := os.WriteFile(contentPath, contentsJSONBytes, 0644); errWriteContent != nil {
			return nil, fmt.Errorf("ghi file %s thất bại: %w", contentPath, errWriteContent)
		}

		// Tìm Typst CLI
		typstPath, errLook := exec.LookPath("typst")
		if errLook != nil {
			homeDir, errHome := os.UserHomeDir()
			if errHome == nil {
				candidate := filepath.Join(homeDir, ".local", "bin", "typst")
				if _, errStat := os.Stat(candidate); errStat == nil {
					typstPath = candidate
				}
			}
		}

		// Lưu và biên dịch từng topic riêng biệt (nếu có repairer và typst)
		for idx := range contents {
			tID := contents[idx].TopicID
			topicJSONPath := filepath.Join(rawDataDir, fmt.Sprintf("topic_%s_content.json", tID))
			if tjBytes, errTJ := json.MarshalIndent(&contents[idx], "", "  "); errTJ == nil {
				if errWriteTJ := os.WriteFile(topicJSONPath, tjBytes, 0644); errWriteTJ != nil {
					// Ghi nhận lỗi nhưng không ngắt toàn tiến trình
				}
			}

			topicTypPath := filepath.Join(rawDataDir, fmt.Sprintf("topic_%s.typ", tID))
			topicTeacherPDF := filepath.Join(topicsDir, fmt.Sprintf("topic_%s_teacher.pdf", tID))
			topicStudentPDF := filepath.Join(topicsDir, fmt.Sprintf("topic_%s_student.pdf", tID))

			if defRep, ok := o.repairer.(*DefaultRepairer); ok && typstPath != "" {
				if errT := defRep.SelfHealCompile(ctx, &contents[idx], typstPath, topicTypPath, topicTeacherPDF, true, 3); errT != nil {
					// non-fatal
				}
				if errS := defRep.SelfHealCompile(ctx, &contents[idx], typstPath, topicTypPath, topicStudentPDF, false, 3); errS != nil {
					// non-fatal
				}
			}
		}

		// Lưu file Typst toàn bài học
		if teacherTypst != "" {
			typFile := filepath.Join(rawDataDir, "lesson.typ")
			if errWriteTyp := os.WriteFile(typFile, []byte(teacherTypst), 0644); errWriteTyp != nil {
				return nil, fmt.Errorf("ghi file Typst %s thất bại: %w", typFile, errWriteTyp)
			}

			if typstPath != "" {
				// Biên dịch Giáo viên PDF
				outTeacherPDF := filepath.Join(req.OutputDir, "GIAO_AN_GIAO_VIEN.pdf")
				cmdTeacher := exec.CommandContext(ctx, typstPath, "compile", "--input", "teacher=true", typFile, outTeacherPDF)
				if _, errComp := cmdTeacher.CombinedOutput(); errComp == nil {
					teacherPDFPath = outTeacherPDF
				}

				// Biên dịch Học sinh PDF
				outStudentPDF := filepath.Join(req.OutputDir, "PHIEU_BAI_TAP_HOC_SINH.pdf")
				cmdStudent := exec.CommandContext(ctx, typstPath, "compile", "--input", "teacher=false", typFile, outStudentPDF)
				if _, errComp := cmdStudent.CombinedOutput(); errComp == nil {
					studentPDFPath = outStudentPDF
				}
			}
		}
	}

	result := &PipelineResult{
		Plan:           plan,
		TopicsContent:  contents,
		TeacherTypst:   teacherTypst,
		StudentTypst:   studentTypst,
		TeacherPDFPath: teacherPDFPath,
		StudentPDFPath: studentPDFPath,
		TotalUsage:     totalUsage,
		Duration:       time.Since(start),
	}

	return result, nil
}
