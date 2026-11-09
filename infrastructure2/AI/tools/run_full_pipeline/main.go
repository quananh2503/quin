package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"

	"meet-attendance-clean/domain2/document"
	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/AI/deepseek"
	"meet-attendance-clean/infrastructure2/AI/pipeline"
	"meet-attendance-clean/infrastructure2/media"
)

func main() {
	ctx := context.Background()

	fmt.Println("==================================================================")
	fmt.Println("🚀 QUIN CURRICULUM PIPELINE - TEST RUNNER (VIA ORCHESTRATOR.GO)")
	fmt.Println("==================================================================")

	// 1. Phân tích tham số dòng lệnh
	var outDirFlag string
	var modelFlag string
	var workersFlag int
	var topicsFilterFlag string

	flag.StringVar(&outDirFlag, "output", "", "Thư mục lưu kết quả xuất bản (mặc định lưu tại <input_folder>/output)")
	flag.StringVar(&modelFlag, "model", "deepseek-flash", "Tên model AI thực thi (mặc định deepseek-flash)")
	flag.IntVar(&workersFlag, "workers", 30, "Số lượng worker biên soạn song song Stage 2 (mặc định 30)")
	flag.StringVar(&topicsFilterFlag, "topics", "", "Danh sách mã dạng toán cần biên soạn (vd: T1,T2). Để trống sẽ biên soạn tất cả")
	flag.Parse()

	// 2. Xác định API Key
	apiKey := strings.TrimSpace(os.Getenv("DEEPSEEK_API_KEY"))
	if apiKey == "" {
		apiKey = "sk-05b5e7c6b375480e96cf71e1cc4d7107"
	}
	maskedKey := apiKey
	if len(apiKey) > 10 {
		maskedKey = apiKey[:6] + "..." + apiKey[len(apiKey)-4:]
	}
	fmt.Printf("🔑 API Key: %s\n", maskedKey)
	fmt.Printf("🤖 Model AI: %s\n", modelFlag)
	fmt.Printf("⚡ Workers song song: %d workers\n", workersFlag)

	// 3. Quét các file và thư mục đầu vào từ args
	args := flag.Args()
	if len(args) == 0 {
		fmt.Println("\n❌ THIẾU THAM SỐ: Vui lòng cung cấp đường dẫn thư mục hoặc danh sách file tài liệu nguồn!")
		fmt.Println("\n👉 CÁCH SỬ DỤNG:")
		fmt.Println("   go run ./infrastructure2/AI/tools/run_full_pipeline <thư_mục_input>")
		fmt.Println("   go run ./infrastructure2/AI/tools/run_full_pipeline ./test_case_full/ --topics T1,T2")
		fmt.Println("   go run ./infrastructure2/AI/tools/run_full_pipeline ./test_case_full/ --workers 3")
		os.Exit(1)
	}

	var inputFiles []string
	var customPrompt string
	workDir := ""

	firstArg := args[0]
	if fi, errStat := os.Stat(firstArg); errStat == nil && fi.IsDir() {
		workDir = firstArg
		entries, errRead := os.ReadDir(workDir)
		if errRead != nil {
			log.Fatalf("❌ Đọc thư mục %s thất bại: %v", workDir, errRead)
		}
		for _, e := range entries {
			if e.IsDir() {
				continue
			}
			name := e.Name()
			ext := strings.ToLower(filepath.Ext(name))

			if strings.EqualFold(name, "prompt.txt") || strings.EqualFold(name, "user_prompt.txt") {
				pBytes, errP := os.ReadFile(filepath.Join(workDir, name))
				if errP == nil {
					customPrompt = strings.TrimSpace(string(pBytes))
				}
				continue
			}

			if ext == ".pdf" || ext == ".png" || ext == ".jpg" || ext == ".jpeg" || ext == ".docx" || ext == ".txt" {
				inputFiles = append(inputFiles, filepath.Join(workDir, name))
			}
		}
	} else {
		for _, f := range args {
			if fiF, errF := os.Stat(f); errF == nil && !fiF.IsDir() {
				ext := strings.ToLower(filepath.Ext(f))
				if ext == ".pdf" || ext == ".png" || ext == ".jpg" || ext == ".jpeg" || ext == ".docx" || ext == ".txt" {
					inputFiles = append(inputFiles, f)
				}
			}
		}
		if len(inputFiles) > 0 {
			workDir = filepath.Dir(inputFiles[0])
		}
	}

	if len(inputFiles) == 0 {
		log.Fatalf("❌ Không tìm thấy file tài liệu hợp lệ nào (.pdf, .docx, .png, .jpg) trong đầu vào!")
	}

	targetOutputDir := outDirFlag
	if targetOutputDir == "" {
		targetOutputDir = filepath.Join(workDir, "output")
	}

	fmt.Printf("📂 Thư mục tài liệu gốc:  %s\n", workDir)
	fmt.Printf("🎯 Thư mục xuất bản:      %s\n", targetOutputDir)

	if customPrompt != "" {
		fmt.Printf("📝 Chỉ dẫn giáo viên riêng (%d ký tự): %q\n", len(customPrompt), customPrompt)
	} else {
		customPrompt = "Dành cho học sinh trung bình yếu mất gốc, các bước giải chi tiết cầm tay chỉ việc, chia rõ từng bước ở cả phương pháp và lời giải mẫu để học sinh dễ hiểu, tích hợp phản xạ và mẹo bấm máy tính Casio nếu có."
		fmt.Printf("📝 Áp dụng chỉ dẫn mặc định: %s\n", customPrompt)
	}

	fmt.Printf("\n🔍 Tìm thấy %d tài liệu nguồn để nạp vào hệ thống:\n", len(inputFiles))
	for idx, f := range inputFiles {
		sizeMB := 0.0
		if fi, errStat := os.Stat(f); errStat == nil {
			sizeMB = float64(fi.Size()) / (1024 * 1024)
		}
		fmt.Printf("   [%d] %s (%.2f MB)\n", idx+1, filepath.Base(f), sizeMB)
	}

	// 4. Tiền xử lý tài liệu sang JPEG chuẩn
	fmt.Println("\n==================================================================")
	fmt.Println("🔄 [BƯỚC TIỀN XỬ LÝ] CHUẨN HOÁ TÀI LIỆU QUA MEDIA.CONVERTER...")
	fmt.Println("==================================================================")
	t0Pre := time.Now()
	mediaConv := media.NewConverter()
	var aiDocs []ai.Document

	for i, fPath := range inputFiles {
		fileName := filepath.Base(fPath)
		fmt.Printf("   [%d/%d] Đang xử lý '%s'...\n", i+1, len(inputFiles), fileName)
		tDoc := time.Now()

		fileBytes, errRead := os.ReadFile(fPath)
		if errRead != nil {
			log.Fatalf("❌ Đọc file %s thất bại: %v", fPath, errRead)
		}

		partsData, errConv := mediaConv.ConvertBytesToJPEGPages(ctx, fileBytes, document.FileTypeUnknown, fileName)
		if errConv != nil {
			log.Fatalf("❌ Chuyển đổi file %s sang JPEG thất bại: %v", fileName, errConv)
		}

		parts := make([]ai.Part, 0, len(partsData))
		for _, imgBytes := range partsData {
			parts = append(parts, ai.NewMediaPart("image/jpeg", imgBytes))
		}

		docID := fmt.Sprintf("DOC_%d", i+1)
		aiDocs = append(aiDocs, ai.NewDocument(docID, fileName, parts...))
		fmt.Printf("       ↳ Xong %d trang ảnh JPEG trong %v\n", len(partsData), time.Since(tDoc))
	}
	fmt.Printf("✅ Hoàn thành tiền xử lý trong %v\n", time.Since(t0Pre))

	// 5. Khởi tạo toàn bộ dependency injection cho Orchestrator
	dsProvider := deepseek.NewProvider(apiKey, modelFlag)
	planner := pipeline.NewPlanner(dsProvider, modelFlag)
	generator := pipeline.NewGenerator(dsProvider, modelFlag, workersFlag)
	repairer := pipeline.NewRepairer(dsProvider, modelFlag)
	assembler := pipeline.NewAssembler()

	orchestrator := pipeline.NewOrchestrator(
		nil,
		planner,
		generator,
		nil,
		repairer,
		assembler,
	)

	// Lọc danh sách dạng toán nếu có cờ --topics
	var selectedTopics []string
	if topicsFilterFlag != "" {
		for _, t := range strings.Split(topicsFilterFlag, ",") {
			trimmed := strings.TrimSpace(t)
			if trimmed != "" {
				selectedTopics = append(selectedTopics, trimmed)
			}
		}
		fmt.Printf("\n🎯 Bộ lọc --topics kích hoạt: %v\n", selectedTopics)
	}

	// 6. Đóng gói PipelineRequest và gọi trực tiếp Orchestrator.Execute()
	fmt.Println("\n==================================================================")
	fmt.Println("🚀 KÍCH HOẠT DEFAULTORCHESTRATOR.EXECUTE() (CORE SYSTEM PIPELINE)...")
	fmt.Println("==================================================================")
	startTime := time.Now()

	req := pipeline.PipelineRequest{
		Title:            "Biên soạn bài giảng toán",
		Documents:        aiDocs,
		UserPrompt:       customPrompt,
		OutputDir:        targetOutputDir,
		Workers:          workersFlag,
		SelectedTopicIDs: selectedTopics,
	}

	result, errExec := orchestrator.Execute(ctx, req)
	if errExec != nil {
		log.Fatalf("\n❌ ORCHESTRATOR.EXECUTE THẤT BẠI: %v", errExec)
	}
	elapsed := time.Since(startTime)

	// 7. Báo cáo kết quả tổng kết
	fmt.Println("\n==================================================================")
	fmt.Println("🎉 DEFAULTORCHESTRATOR.EXECUTE() HOÀN TẤT THÀNH CÔNG RỰC RỠ!")
	fmt.Println("==================================================================")
	fmt.Printf("⏱️  Tổng thời gian thực thi: %v\n", elapsed)
	if result.Plan != nil {
		fmt.Printf("📖 Tiêu đề bài giảng:      %s\n", result.Plan.LessonTitle)
		fmt.Printf("🎯 Số dạng toán biên soạn:  %d dạng\n", len(result.TopicsContent))
	}

	fmt.Println("\n📂 CẤU TRÚC KẾT QUẢ ĐÃ XUẤT RA (NGĂN NẮP & TÁCH BẠCH):")
	fmt.Printf("  📁 Thư mục xuất bản: %s\n", targetOutputDir)
	if result.TeacherPDFPath != "" {
		fmt.Printf("     ⭐ [1] %s (GIÁO ÁN GIÁO VIÊN ĐẦY ĐỦ LỜI GIẢI)\n", filepath.Base(result.TeacherPDFPath))
	}
	if result.StudentPDFPath != "" {
		fmt.Printf("     ⭐ [2] %s (PHIẾU BÀI TẬP HỌC SINH ĐỂ TRỐNG)\n", filepath.Base(result.StudentPDFPath))
	}
	fmt.Printf("     📁 [3] topics/     -> Chứa %d chuyên đề tờ rời riêng lẻ từng dạng\n", len(result.TopicsContent))
	fmt.Println("     📁 [4] raw_data/   -> Chứa toàn bộ file JSON và file Typst mã nguồn phụ trợ")
	fmt.Println("==================================================================")
}
