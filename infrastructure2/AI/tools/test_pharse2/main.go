package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"meet-attendance-clean/domain2/document"
	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/AI/deepseek"
	"meet-attendance-clean/infrastructure2/AI/pipeline"
	"meet-attendance-clean/infrastructure2/media"
)

func resolveTypstCLI() string {
	customPath := "/home/quanan/.local/bin/typst"
	if _, err := os.Stat(customPath); err == nil {
		return customPath
	}
	if p, err := exec.LookPath("typst"); err == nil {
		return p
	}
	return "typst"
}

func main() {
	ctx := context.Background()

	fmt.Println("==================================================================")
	fmt.Println("🚀 RUNNER KIỂM THỬ STAGE 2 (TOPIC AUTHORING - TYPST & MITEX)")
	fmt.Println("==================================================================")

	// 1. Kiểm tra API Key
	apiKey := strings.TrimSpace(os.Getenv("DEEPSEEK_API_KEY"))
	if apiKey == "" {
		fmt.Println("❌ THIẾU BIẾN MÔI TRƯỜNG: DEEPSEEK_API_KEY")
		fmt.Println("👉 Vui lòng export API Key trước khi chạy:")
		fmt.Println("   export DEEPSEEK_API_KEY=\"sk-your-deepseek-api-key\"")
		fmt.Println("   go run ./infrastructure2/AI/tools/test_pharse2 case1 T1")
		os.Exit(1)
	}

	modelName := strings.TrimSpace(os.Getenv("DEEPSEEK_MODEL"))
	if modelName == "" {
		modelName = "deepseek-flash"
	}

	maskedKey := apiKey
	if len(apiKey) > 10 {
		maskedKey = apiKey[:6] + "..." + apiKey[len(apiKey)-4:]
	}
	fmt.Printf("🔑 API Key: %s\n", maskedKey)
	fmt.Printf("🤖 Model AI: %s\n", modelName)

	// 2. Xác định thư mục case và mã dạng toán (TopicID)
	caseFolder := "case1"
	targetTopicID := "T1"

	if len(os.Args) > 1 && strings.TrimSpace(os.Args[1]) != "" {
		caseFolder = strings.TrimSpace(os.Args[1])
	}
	if len(os.Args) > 2 && strings.TrimSpace(os.Args[2]) != "" {
		targetTopicID = strings.TrimSpace(os.Args[2])
	}

	targetDir := caseFolder
	if !filepath.IsAbs(targetDir) && !strings.Contains(targetDir, "test_pharse1") && !strings.Contains(targetDir, "test_pharse2") {
		targetDir = filepath.Join("infrastructure2", "AI", "tools", "test_pharse1", caseFolder)
	}

	fmt.Printf("📂 Thư mục kiểm thử: %s\n", targetDir)
	fmt.Printf("🎯 Dạng toán mục tiêu: %s\n\n", targetTopicID)

	// 3. Đọc plan_output.json từ Stage 1
	planFile := filepath.Join(targetDir, "plan_output.json")
	planBytes, errReadPlan := os.ReadFile(planFile)
	if errReadPlan != nil {
		log.Fatalf("❌ Không tìm thấy plan_output.json trong %s: %v\n👉 Hãy chạy Stage 1 trước: go run ./infrastructure2/AI/tools/test_pharse1 %s",
			targetDir, errReadPlan, caseFolder)
	}

	var plan pipeline.LessonPlan
	if errParsePlan := json.Unmarshal(planBytes, &plan); errParsePlan != nil {
		log.Fatalf("❌ Unmarshal plan_output.json thất bại: %v", errParsePlan)
	}

	var targetTopic *pipeline.TopicPlan
	for i := range plan.Topics {
		if strings.EqualFold(plan.Topics[i].TopicID, targetTopicID) {
			targetTopic = &plan.Topics[i]
			break
		}
	}

	if targetTopic == nil {
		fmt.Printf("❌ Không tìm thấy dạng toán '%s' trong kế hoạch bài giảng.\n", targetTopicID)
		fmt.Println("📋 Danh sách các dạng toán hiện có:")
		for _, tp := range plan.Topics {
			fmt.Printf("   - [%s] %s (%s) [%d câu hỏi]\n", tp.TopicID, tp.Title, tp.Difficulty, len(tp.AssignedQuestionIDs))
		}
		os.Exit(1)
	}

	fmt.Printf("📖 Dạng toán được chọn: [%s] %s (%s)\n", targetTopic.TopicID, targetTopic.Title, targetTopic.Difficulty)
	fmt.Printf("   ↳ Mục tiêu: %s\n", targetTopic.TargetOutput)
	fmt.Printf("   ↳ Phương pháp: %s\n", targetTopic.CoreConcept)
	fmt.Printf("   ↳ Số câu hỏi phân bổ: %d mục\n\n", len(targetTopic.AssignedQuestionIDs))

	// 4. Quét tài liệu gốc
	entries, errReadDir := os.ReadDir(targetDir)
	if errReadDir != nil {
		log.Fatalf("❌ Đọc thư mục %s thất bại: %v", targetDir, errReadDir)
	}

	var docFiles []string
	var customPrompt string

	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}
		name := entry.Name()
		ext := strings.ToLower(filepath.Ext(name))

		if strings.EqualFold(name, "prompt.txt") || strings.EqualFold(name, "user_prompt.txt") {
			promptPath := filepath.Join(targetDir, name)
			if pBytes, errP := os.ReadFile(promptPath); errP == nil {
				customPrompt = string(pBytes)
				fmt.Printf("📝 Đã tìm thấy chỉ dẫn giáo viên riêng từ %s (%d ký tự)\n", name, len(customPrompt))
			}
			continue
		}

		if strings.HasPrefix(name, "topic_") {
			continue
		}

		if ext == ".pdf" || ext == ".png" || ext == ".jpg" || ext == ".jpeg" || ext == ".docx" {
			docFiles = append(docFiles, filepath.Join(targetDir, name))
		}
	}

	if len(docFiles) == 0 {
		log.Fatalf("❌ Không tìm thấy file tài liệu nào (.pdf, .png, .jpg, .docx) trong %s", targetDir)
	}

	fmt.Printf("🔍 Tìm thấy %d file tài liệu nguồn để nạp Prefix Caching:\n", len(docFiles))
	for i, f := range docFiles {
		sizeMB := 0.0
		if fi, errStat := os.Stat(f); errStat == nil {
			sizeMB = float64(fi.Size()) / (1024 * 1024)
		}
		fmt.Printf("   [%d] %s (%.2f MB)\n", i+1, filepath.Base(f), sizeMB)
	}
	fmt.Println()

	mediaConv := media.NewConverter()
	var aiDocs []ai.Document

	for i, filePath := range docFiles {
		fileName := filepath.Base(filePath)
		fmt.Printf("🔄 [%d/%d] Đang xử lý '%s' qua media.Converter...\n", i+1, len(docFiles), fileName)
		t0 := time.Now()

		docBytes, errRead := os.ReadFile(filePath)
		if errRead != nil {
			log.Fatalf("❌ Đọc file %s thất bại: %v", filePath, errRead)
		}

		partsData, errConv := mediaConv.ConvertBytesToJPEGPages(ctx, docBytes, document.FileTypeUnknown, fileName)
		if errConv != nil {
			log.Fatalf("❌ Chuyển đổi file %s sang JPEG thất bại: %v", fileName, errConv)
		}

		fmt.Printf("   ↳ Thành công: %d trang ảnh JPEG trong %v\n", len(partsData), time.Since(t0))

		parts := make([]ai.Part, 0, len(partsData))
		for _, imgBytes := range partsData {
			parts = append(parts, ai.NewMediaPart("image/jpeg", imgBytes))
		}

		docID := fmt.Sprintf("DOC_%d", i+1)
		aiDocs = append(aiDocs, ai.NewDocument(docID, fileName, parts...))
	}

	repairOnly := false
	for _, arg := range os.Args {
		if arg == "--repair-only" || arg == "--heal" {
			repairOnly = true
		}
	}

	outJSONFile := filepath.Join(targetDir, fmt.Sprintf("topic_%s_content.json", targetTopic.TopicID))
	outTypFile := filepath.Join(targetDir, fmt.Sprintf("topic_%s.typ", targetTopic.TopicID))

	var topicContent *pipeline.TopicContent
	var resp *ai.Response
	var errGen error

	dsProvider := deepseek.NewProvider(apiKey, modelName)

	if repairOnly {
		fmt.Printf("⏩ CHẾ ĐỘ REPAIR-ONLY: Đọc trực tiếp cấu trúc JSON từ %s\n", outJSONFile)
		cBytes, errReadJSON := os.ReadFile(outJSONFile)
		if errReadJSON != nil {
			log.Fatalf("❌ Không thể đọc %s: %v", outJSONFile, errReadJSON)
		}
		topicContent = &pipeline.TopicContent{}
		if errParseJSON := json.Unmarshal(cBytes, topicContent); errParseJSON != nil {
			log.Fatalf("❌ Unmarshal %s thất bại: %v", outJSONFile, errParseJSON)
		}
	} else {
		// 5. Khởi tạo Provider & Generator
		generator := pipeline.NewGenerator(dsProvider, modelName, 30)

		fmt.Printf("\n⚡ ĐANG GỬI YÊU CẦU BIÊN SOẠN DẠNG %s TỚI DEEPSEEK (JSON SCHEMA & TYPST)...\n", targetTopic.TopicID)
		startTime := time.Now()
		topicContent, resp, errGen = generator.GenerateTopicJSON(ctx, *targetTopic, aiDocs, &plan, customPrompt)
		elapsed := time.Since(startTime)

		// 6. Thống kê token
		if resp != nil && resp.Usage != nil {
			dsUsage, errParseUsage := deepseek.ParseUsage(resp.Usage.Raw())
			if errParseUsage == nil && dsUsage != nil {
				hitRate := 0.0
				if dsUsage.PromptTokens > 0 {
					hitRate = float64(dsUsage.PromptCacheHitTokens) * 100.0 / float64(dsUsage.PromptTokens)
				}
				fmt.Println("\n==================================================================")
				fmt.Println("📊 THỐNG KÊ CHI TIẾT TOKEN & PROMPT CACHING:")
				fmt.Println("==================================================================")
				fmt.Printf("  📥 Input Tokens (Prompt):        %d\n", dsUsage.PromptTokens)
				fmt.Printf("  📤 Output Tokens (Completion):   %d\n", dsUsage.CompletionTokens)
				fmt.Printf("  🎯 Cache Hit Tokens (Đọc Cache): %d (%.2f%%)\n", dsUsage.PromptCacheHitTokens, hitRate)
				fmt.Printf("  💨 Cache Miss Tokens (Nạp mới):  %d\n", dsUsage.PromptCacheMissTokens)
				fmt.Printf("  💰 Tổng Tokens tiêu thụ:          %d\n", dsUsage.TotalTokens())
				fmt.Printf("  ⏱️  Thời gian xử lý:              %v\n", elapsed)
				fmt.Println("==================================================================")
			}
		}

		if errGen != nil {
			fmt.Printf("\n❌ BIÊN SOẠN DẠNG %s THẤT BẠI: %v\n", targetTopic.TopicID, errGen)
			os.Exit(1)
		}

		// Lưu file JSON thô ban đầu
		jsonBytes, errJSON := json.MarshalIndent(topicContent, "", "  ")
		if errJSON == nil {
			if errWriteJSON := os.WriteFile(outJSONFile, jsonBytes, 0644); errWriteJSON != nil {
				log.Printf("⚠️ Ghi file JSON %s thất bại: %v", outJSONFile, errWriteJSON)
			} else {
				fmt.Printf("\n💾 Đã lưu cấu trúc dữ liệu JSON vào: %s\n", outJSONFile)
			}
		}
	}

	// 7. Khởi tạo Repairer phục vụ Phase 3 & Phase 4
	repairer := pipeline.NewRepairer(dsProvider, modelName)

	// ==================================================================
	// GIAI ĐOẠN 3 (PHASE 3): PRE-AUDIT TOÁN HỌC TRƯỚC KHI BIÊN DỊCH
	// ==================================================================
	fmt.Println("\n==================================================================")
	fmt.Println("🔍 [GIAI ĐOẠN 3] PRE-AUDIT KIỂM TRA CÚ PHÁP TOÁN TRƯỚC KHI BIÊN DỊCH")
	fmt.Println("==================================================================")
	auditTasks := pipeline.AuditTopicContent(topicContent)
	if len(auditTasks) > 0 {
		fmt.Printf("⚠️ Phát hiện %d vị trí lỗi cú pháp toán học / ký tự rác / thiếu $: Đang tự động sửa...\n", len(auditTasks))
		for idx, task := range auditTasks {
			fmt.Printf("   [%d] Anchor: %s | Lỗi: %s | Trích đoạn: %q\n", idx+1, task.TargetID, task.ErrorReason, task.BrokenSnippet)
		}

		repaired, errRep := repairer.RepairMath(ctx, auditTasks)
		if errRep != nil {
			fmt.Printf("⚠️ RepairMath gặp lỗi (%v) -> tiếp tục với fallback\n", errRep)
		} else {
			for _, task := range repaired {
				pipeline.SetContextField(topicContent, task.TargetID, task.FixedContent)
				fmt.Printf("   ✅ Đã sửa [%s] -> %s\n", task.TargetID, task.FixedContent)
			}
		}
	} else {
		fmt.Println("✅ Pre-Audit 100% sạch: Không phát hiện lỗi cú pháp toán học hay ký tự rác.")
	}

	// Lắp ráp lại Typst Markup sau khi kiểm toán
	topicContent.TypstContent = pipeline.RenderTopicTypst(topicContent)
	if errTyp := os.WriteFile(outTypFile, []byte(topicContent.TypstContent), 0644); errTyp == nil {
		fmt.Printf("📄 Đã cập nhật mã nguồn Typst vào: %s\n", outTypFile)
	} else {
		log.Printf("⚠️ Ghi file Typst %s thất bại: %v", outTypFile, errTyp)
	}

	// ==================================================================
	// GIAI ĐOẠN 4 (PHASE 4): VÒNG LẶP BIÊN DỊCH & TỰ PHỤC HỒI (SELF-HEALING)
	// ==================================================================
	fmt.Println("\n==================================================================")
	fmt.Println("🔨 [GIAI ĐOẠN 4] VÒNG LẶP BIÊN DỊCH & TỰ PHỤC HỒI (SELF-HEALING COMPILE)")
	fmt.Println("==================================================================")
	typstCLI := resolveTypstCLI()
	teacherPDF := filepath.Join(targetDir, fmt.Sprintf("topic_%s_teacher.pdf", targetTopic.TopicID))
	studentPDF := filepath.Join(targetDir, fmt.Sprintf("topic_%s_student.pdf", targetTopic.TopicID))

	// Biên dịch bản Giáo viên
	t0Teacher := time.Now()
	errTeacher := repairer.SelfHealCompile(ctx, topicContent, typstCLI, outTypFile, teacherPDF, true, 3)
	if errTeacher != nil {
		fmt.Printf("❌ Biên dịch bản Giáo viên thất bại: %v\n", errTeacher)
	} else {
		fmt.Printf("   ✅ Bản Giáo viên (Teacher PDF): %s (trong %v)\n", teacherPDF, time.Since(t0Teacher))
	}

	// Biên dịch bản Học sinh
	t0Student := time.Now()
	errStudent := repairer.SelfHealCompile(ctx, topicContent, typstCLI, outTypFile, studentPDF, false, 3)
	if errStudent != nil {
		fmt.Printf("❌ Biên dịch bản Học sinh thất bại: %v\n", errStudent)
	} else {
		fmt.Printf("   ✅ Bản Học sinh (Student PDF):   %s (trong %v)\n", studentPDF, time.Since(t0Student))
	}

	// Tóm tắt kết quả
	fmt.Println("\n==================================================================")
	fmt.Printf("🎉 TỔNG KẾT DẠNG TOÁN [%s]: %s\n", topicContent.TopicID, topicContent.Title)
	fmt.Println("==================================================================")
	fmt.Printf("  🔹 Số ý lý thuyết cốt lõi: %d ý\n", len(topicContent.TheoryPoints))
	fmt.Printf("  🔹 Số biến thể bài toán:   %d biến thể\n", len(topicContent.Variants))
	for vIdx, v := range topicContent.Variants {
		fmt.Printf("     [%d] %s (%s) - %d bước hành động, %d bài tập\n",
			vIdx+1, v.VariantID, v.VariantName, len(v.ActionSteps), len(v.Drills))
	}
	fmt.Printf("  🔹 Bảng tra cứu đáp án:    %d mục\n", len(topicContent.AnswerKey))
	fmt.Println("==================================================================")
}
