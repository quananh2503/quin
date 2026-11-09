package main

import (
	"context"
	"encoding/json"
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
	fmt.Println("==================================================================")
	fmt.Println("🚀 RUNNER KIỂM THỬ STAGE 1 (PLANNER) THEO FOLDER TEST CASE")
	fmt.Println("==================================================================")

	// 1. Kiểm tra API Key
	apiKey := strings.TrimSpace(os.Getenv("DEEPSEEK_API_KEY"))
	if apiKey == "" {
		fmt.Println("❌ LỖI: Chưa tìm thấy biến môi trường DEEPSEEK_API_KEY!")
		fmt.Println("\n👉 Vui lòng chạy lệnh sau trong terminal trước khi chạy:")
		fmt.Println("   export DEEPSEEK_API_KEY=\"sk-your-deepseek-api-key\"")
		fmt.Println("   go run ./infrastructure2/AI/tools/test_pharse1")
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

	// 2. Xác định thư mục case cần test
	// Mặc định là case1, hoặc người dùng truyền tên case qua tham số: `go run ./infrastructure2/AI/tools/test_pharse1 case2`
	caseFolder := "case1"
	if len(os.Args) > 1 && strings.TrimSpace(os.Args[1]) != "" {
		caseFolder = strings.TrimSpace(os.Args[1])
	}

	targetDir := caseFolder
	if !filepath.IsAbs(targetDir) && !strings.Contains(targetDir, "test_pharse1") {
		targetDir = filepath.Join("infrastructure2", "AI", "tools", "test_pharse1", caseFolder)
	}

	if errMk := os.MkdirAll(targetDir, 0755); errMk != nil {
		log.Fatalf("❌ Không thể tạo/truy cập thư mục %s: %v", targetDir, errMk)
	}
	fmt.Printf("📂 Thư mục kiểm thử mục tiêu: %s\n\n", targetDir)

	// 3. Quét tất cả các file tài liệu trong thư mục case
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
		// Bỏ qua các file kết quả cũ
		if strings.HasPrefix(name, "plan_output") || strings.HasPrefix(name, "raw_") || strings.HasPrefix(name, ".") {
			continue
		}

		// Nếu có file prompt.txt hoặc user_prompt.txt, đọc làm chỉ dẫn riêng
		if name == "prompt.txt" || name == "user_prompt.txt" {
			promptBytes, errPrompt := os.ReadFile(filepath.Join(targetDir, name))
			if errPrompt == nil {
				customPrompt = strings.TrimSpace(string(promptBytes))
				fmt.Printf("📝 Đã tìm thấy chỉ dẫn tùy biến từ %s (%d ký tự)\n", name, len(customPrompt))
			}
			continue
		}

		// Nhận diện các định dạng tài liệu hợp lệ
		ext := strings.ToLower(filepath.Ext(name))
		switch ext {
		case ".pdf", ".docx", ".txt", ".png", ".jpg", ".jpeg", ".webp":
			docFiles = append(docFiles, filepath.Join(targetDir, name))
		}
	}

	if len(docFiles) == 0 {
		fmt.Printf("⚠️  THƯ MỤC RỖNG: Không tìm thấy file tài liệu nào trong '%s'!\n", targetDir)
		fmt.Println("👉 Hãy copy/thả file tài liệu của bạn (PDF, DOCX, ảnh, TXT) vào thư mục:")
		fmt.Printf("   %s\n", targetDir)
		fmt.Println("   Sau đó chạy lại lệnh:")
		fmt.Printf("   go run ./infrastructure2/AI/tools/test_pharse1 %s\n", caseFolder)
		os.Exit(0)
	}

	if customPrompt == "" {
		customPrompt = "Biên soạn theo chương trình GDPT 2018. Phân chia dạng toán chi tiết theo mục tiêu kiến thức và phương pháp giải, không bỏ sót bài tập."
	}

	fmt.Printf("🔍 Tìm thấy %d file tài liệu cần xử lý:\n", len(docFiles))
	for i, f := range docFiles {
		fi, errFi := os.Stat(f)
		sizeMB := 0.0
		if errFi == nil {
			sizeMB = float64(fi.Size()) / (1024 * 1024)
		}
		fmt.Printf("   [%d] %s (%.2f MB)\n", i+1, filepath.Base(f), sizeMB)
	}
	fmt.Println()

	// 4. Tiền xử lý: Dùng media.Converter chuyển toàn bộ file sang các trang JPEG
	ctx := context.Background()
	mediaConv := media.NewConverter()
	var aiDocs []ai.Document

	for i, filePath := range docFiles {
		fileName := filepath.Base(filePath)
		fmt.Printf("🔄 [%d/%d] Đang xử lý '%s' qua media.Converter...\n", i+1, len(docFiles), fileName)

		rawBytes, errRead := os.ReadFile(filePath)
		if errRead != nil {
			log.Fatalf("❌ Đọc file %s thất bại: %v", filePath, errRead)
		}

		t0 := time.Now()
		jpegPages, errConv := mediaConv.ConvertBytesToJPEGPages(ctx, rawBytes, document.FileTypeUnknown, fileName)
		if errConv != nil {
			log.Fatalf("❌ Chuyển đổi file %s sang JPEG thất bại: %v", fileName, errConv)
		}
		fmt.Printf("   ↳ Thành công: %d trang ảnh JPEG (1600px, 82%%) trong %v\n", len(jpegPages), time.Since(t0))

		var parts []ai.Part
		for _, pageBytes := range jpegPages {
			if len(pageBytes) > 0 {
				parts = append(parts, ai.NewMediaPart("image/jpeg", pageBytes))
			}
		}

		docID := fmt.Sprintf("DOC_%d", i+1)
		aiDocs = append(aiDocs, ai.NewDocument(docID, fileName, parts...))
	}

	// 5. Khởi tạo Harvester và Planner
	dsProvider := deepseek.NewProvider(apiKey, modelName)
	harvester := pipeline.NewHarvester(dsProvider, modelName)
	planner := pipeline.NewPlanner(dsProvider, modelName)

	// =========================================================================
	// 5.1. BƯỚC 1A: HARVESTER (BÓC TÁCH VÉT CẠN ẢNH TÀI LIỆU)
	// =========================================================================
	fmt.Println("\n🌾 [BƯỚC 1A] ĐANG BÓC TÁCH VÉT CẠN TÀI LIỆU QUA HARVESTER...")
	startHarvest := time.Now()
	inventory, respHarvest, errHarvest := harvester.Harvest(ctx, aiDocs)
	elapsedHarvest := time.Since(startHarvest)

	var usageHarvest *deepseek.Usage
	if respHarvest != nil {
		rawHarvestFile := filepath.Join(targetDir, "raw_harvest_response.json")
		saveFormattedJSON(rawHarvestFile, respHarvest.Raw)
		if respHarvest.Usage != nil {
			if u, errU := deepseek.ParseUsage(respHarvest.Usage.Raw()); errU == nil {
				usageHarvest = u
			}
		}
	}

	if errHarvest != nil {
		fmt.Printf("\n❌ BƯỚC 1A (HARVESTER) THẤT BẠI: %v\n", errHarvest)
		os.Exit(1)
	}

	invFile := filepath.Join(targetDir, "inventory.json")
	if invBytes, errInv := json.MarshalIndent(inventory, "", "  "); errInv == nil {
		if errSaveInv := os.WriteFile(invFile, invBytes, 0644); errSaveInv != nil {
			log.Printf("⚠️ Không thể ghi file inventory.json: %v", errSaveInv)
		}
	}
	fmt.Printf("   ↳ Thành công: Bóc tách được %d mục câu hỏi trong %v\n", inventory.TotalItems, elapsedHarvest)
	if usageHarvest != nil {
		hitRate := 0.0
		if usageHarvest.PromptTokens > 0 {
			hitRate = float64(usageHarvest.PromptCacheHitTokens) * 100.0 / float64(usageHarvest.PromptTokens)
		}
		fmt.Printf("   ↳ Token Bước 1A: Input %d (Cache Hit %.2f%%) | Output %d | Tổng %d\n",
			usageHarvest.PromptTokens, hitRate, usageHarvest.CompletionTokens, usageHarvest.TotalTokens())
	}

	// =========================================================================
	// 5.2. BƯỚC 1B: CURRICULUM PLANNER (PHÂN DẠNG SƯ PHẠM CHO HỌC SINH MẤT GỐC)
	// =========================================================================
	fmt.Println("\n🎯 [BƯỚC 1B] ĐANG THIẾT KẾ GIÁO ÁN PHÂN DẠNG CHO HỌC SINH MẤT GỐC...")
	startPlan := time.Now()
	plan, respPlan, errPlan := planner.PlanFromInventory(ctx, inventory, customPrompt)
	elapsedPlan := time.Since(startPlan)

	var usagePlan *deepseek.Usage
	if respPlan != nil {
		rawPlanFile := filepath.Join(targetDir, "raw_plan_response.json")
		saveFormattedJSON(rawPlanFile, respPlan.Raw)
		// Lưu thêm raw_response.json và raw_content.txt để tương thích ngược
		saveFormattedJSON(filepath.Join(targetDir, "raw_response.json"), respPlan.Raw)
		if errSaveContent := os.WriteFile(filepath.Join(targetDir, "raw_content.txt"), []byte(respPlan.Content), 0644); errSaveContent != nil {
			log.Printf("⚠️ Không thể ghi file raw_content.txt: %v", errSaveContent)
		}

		if respPlan.Usage != nil {
			if u, errU := deepseek.ParseUsage(respPlan.Usage.Raw()); errU == nil {
				usagePlan = u
			}
		}
	}

	if errPlan != nil {
		fmt.Printf("\n❌ BƯỚC 1B (PLANNER) THẤT BẠI: %v\n", errPlan)
		os.Exit(1)
	}

	// =========================================================================
	// 6. THỐNG KÊ CHI TIẾT TOKEN & PROMPT CACHING TOÀN BỘ PIPELINE
	// =========================================================================
	fmt.Println("\n==================================================================")
	fmt.Println("📊 TỔNG HỢP CHI TIẾT TOKEN & PROMPT CACHING (2 BƯỚC):")
	fmt.Println("==================================================================")
	if usageHarvest != nil {
		hitRateH := 0.0
		if usageHarvest.PromptTokens > 0 {
			hitRateH = float64(usageHarvest.PromptCacheHitTokens) * 100.0 / float64(usageHarvest.PromptTokens)
		}
		fmt.Printf("  🌾 BƯỚC 1A (Harvester - 86 trang ảnh JPEG):\n")
		fmt.Printf("     📥 Input Tokens (Prompt):        %d\n", usageHarvest.PromptTokens)
		fmt.Printf("     📤 Output Tokens (Completion):   %d\n", usageHarvest.CompletionTokens)
		fmt.Printf("     🎯 Cache Hit Tokens:             %d (%.2f%%)\n", usageHarvest.PromptCacheHitTokens, hitRateH)
		fmt.Printf("     💨 Cache Miss Tokens:            %d\n", usageHarvest.PromptCacheMissTokens)
		fmt.Printf("     💰 Subtotal Bước 1A:             %d tokens\n\n", usageHarvest.TotalTokens())
	}
	if usagePlan != nil {
		fmt.Printf("  🎯 BƯỚC 1B (Planner - Nhận Text Inventory 187 mục):\n")
		fmt.Printf("     📥 Input Tokens (Text Prompt):   %d\n", usagePlan.PromptTokens)
		fmt.Printf("     📤 Output Tokens (Completion):   %d\n", usagePlan.CompletionTokens)
		fmt.Printf("     💰 Subtotal Bước 1B:             %d tokens\n\n", usagePlan.TotalTokens())
	}
	totalAll := 0
	if usageHarvest != nil {
		totalAll += usageHarvest.TotalTokens()
	}
	if usagePlan != nil {
		totalAll += usagePlan.TotalTokens()
	}
	fmt.Printf("  ⭐ TỔNG CỘNG CẢ 2 BƯỚC:            %d TOKENS\n", totalAll)
	fmt.Printf("  ⏱️  Tổng thời gian chạy:            %v\n", elapsedHarvest+elapsedPlan)
	fmt.Println("==================================================================")

	// 7. Hiển thị kết quả thành công và lưu plan_output.json
	fmt.Println("\n==================================================================")
	fmt.Println("🎉 KẾT QUẢ PHÂN DẠNG TOÁN CỦA DEEPSEEK FLASH:")
	fmt.Println("==================================================================")
	fmt.Printf("📚 Tên bài giảng: %s\n", plan.LessonTitle)
	fmt.Printf("📝 Tổng quan: %s\n", plan.Overview)
	if plan.Inventory.TotalItems > 0 {
		fmt.Printf("🌾 Tổng số mục kiểm kê đã bóc tách (Bước 1A): %d mục\n", plan.Inventory.TotalItems)
	}
	fmt.Printf("🔢 Số lượng dạng toán tách được (Bước 1B): %d dạng\n\n", len(plan.Topics))

	assignedUnique := make(map[string]bool)
	for i, tp := range plan.Topics {
		fmt.Printf("  [%d] %s (%s)\n", i+1, tp.Title, tp.Difficulty)
		fmt.Printf("      ↳ Đích đến (Target): %s\n", tp.TargetOutput)
		fmt.Printf("      ↳ Cốt lõi (Method): %s\n", tp.CoreConcept)
		fmt.Printf("      ↳ Câu hỏi phân bổ (%d mục): %s\n", len(tp.AssignedQuestionIDs), strings.Join(tp.AssignedQuestionIDs, ", "))
		for _, qid := range tp.AssignedQuestionIDs {
			assignedUnique[qid] = true
		}
	}

	if plan.Inventory.TotalItems > 0 {
		coveragePct := float64(len(assignedUnique)) * 100.0 / float64(plan.Inventory.TotalItems)
		fmt.Println("\n------------------------------------------------------------------")
		fmt.Printf("🔍 [CHECKSUM KIỂM KÊ] Đã phân bổ: %d / %d mục (Độ bao phủ: %.1f%%)\n",
			len(assignedUnique), plan.Inventory.TotalItems, coveragePct)
		fmt.Println("------------------------------------------------------------------")
	}

	outJSONFile := filepath.Join(targetDir, "plan_output.json")
	planJSONBytes, errIndent := json.MarshalIndent(plan, "", "  ")
	if errIndent != nil {
		log.Printf("⚠️ Lỗi format JSON output: %v", errIndent)
	} else {
		if errSave := os.WriteFile(outJSONFile, planJSONBytes, 0644); errSave != nil {
			log.Printf("⚠️ Không thể ghi file kết quả %s: %v", outJSONFile, errSave)
		} else {
			fmt.Println("==================================================================")
			fmt.Printf("💾 Đã lưu toàn bộ Kế hoạch bài học (Bước 1B) vào: %s\n", outJSONFile)
			fmt.Printf("🌾 Đã lưu bản kiểm kê thô (Bước 1A) vào: %s\n", invFile)
			fmt.Println("==================================================================")
		}
	}
}

// saveFormattedJSON lưu chuỗi JSON đã định dạng đẹp (pretty print).
func saveFormattedJSON(path string, raw string) {
	if strings.TrimSpace(raw) == "" {
		return
	}
	var obj any
	var formatted []byte
	if err := json.Unmarshal([]byte(raw), &obj); err == nil {
		if b, errIndent := json.MarshalIndent(obj, "", "  "); errIndent == nil {
			formatted = b
		}
	}
	if len(formatted) == 0 {
		formatted = []byte(raw)
	}
	if errSave := os.WriteFile(path, formatted, 0644); errSave != nil {
		log.Printf("⚠️ Không thể ghi file %s: %v", path, errSave)
	}
}
