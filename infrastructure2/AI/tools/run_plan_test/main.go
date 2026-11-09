package main

import (
	"context"
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
	fmt.Println("🚀 KIỂM THỬ GIAI ĐOẠN 1 (STAGE 1: PLANNER) VỚI DEEPSEEK FLASH")
	fmt.Println("==================================================================")

	apiKey := strings.TrimSpace(os.Getenv("DEEPSEEK_API_KEY"))
	if apiKey == "" {
		fmt.Println("❌ LỖI: Chưa tìm thấy biến môi trường DEEPSEEK_API_KEY!")
		fmt.Println("\n👉 Vui lòng chạy lệnh sau trong terminal trước khi chạy:")
		fmt.Println("   export DEEPSEEK_API_KEY=\"sk-your-deepseek-api-key\"")
		fmt.Println("   go run ./infrastructure2/AI/tools/run_plan_test")
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

	// Chọn file tài liệu mẫu để test
	samplePDF := filepath.Join("infrastructure2", "gemini", "tom-tat_nup8.pdf")
	if len(os.Args) > 1 && strings.TrimSpace(os.Args[1]) != "" {
		samplePDF = os.Args[1]
	}

	pdfBytes, errRead := os.ReadFile(samplePDF)
	if errRead != nil {
		log.Fatalf("❌ Đọc file PDF mẫu thất bại (%s): %v", samplePDF, errRead)
	}
	fmt.Printf("📂 Tài liệu kiểm thử: %s (%.2f MB)\n", filepath.Base(samplePDF), float64(len(pdfBytes))/(1024*1024))

	// 1. Tiền xử lý tài liệu sang các trang ảnh JPEG qua media.Converter
	ctx := context.Background()
	mediaConv := media.NewConverter()
	fmt.Println("🔄 Đang chuyển đổi tài liệu sang danh sách các trang ảnh JPEG (1600px, 82%)...")
	t0 := time.Now()
	jpegPages, errConv := mediaConv.ConvertBytesToJPEGPages(ctx, pdfBytes, document.FileTypePDF, filepath.Base(samplePDF))
	if errConv != nil {
		log.Fatalf("❌ Chuyển đổi PDF sang JPEG thất bại: %v", errConv)
	}
	fmt.Printf("✅ Đã chuyển đổi thành công: %d trang ảnh JPEG (thời gian: %v)\n", len(jpegPages), time.Since(t0))

	// Đóng gói thành ai.Document
	var parts []ai.Part
	for _, pageBytes := range jpegPages {
		if len(pageBytes) > 0 {
			parts = append(parts, ai.NewMediaPart("image/jpeg", pageBytes))
		}
	}
	doc := ai.NewDocument("DOC_1", filepath.Base(samplePDF), parts...)

	// 2. Khởi tạo DeepSeek Provider và Planner Stage
	dsProvider := deepseek.NewProvider(apiKey, modelName)
	planner := pipeline.NewPlanner(dsProvider, modelName)

	userPrompt := "Biên soạn theo chương trình GDPT 2018. Phân chia dạng toán chi tiết, tách riêng dạng toán thực tế ứng dụng và dạng toán mẹo giải nhanh."

	fmt.Println("\n⚡ Đang gửi yêu cầu tới DeepSeek Planner Stage...")
	startTime := time.Now()
	plan, resp, errPlan := planner.Plan(ctx, []ai.Document{doc}, userPrompt)
	if resp != nil && resp.Usage != nil {
		dsUsage, errParse := deepseek.ParseUsage(resp.Usage.Raw())
		if errParse == nil && dsUsage != nil {
			fmt.Printf("📊 Tokens: Input %d, Output %d, CacheHit %d, Total %d\n",
				dsUsage.PromptTokens, dsUsage.CompletionTokens, dsUsage.PromptCacheHitTokens, dsUsage.TotalTokens())
		}
	}
	if errPlan != nil {
		log.Fatalf("❌ Stage 1 Planner thất bại: %v", errPlan)
	}
	elapsed := time.Since(startTime)

	fmt.Println("\n==================================================================")
	fmt.Println("🎉 KẾT QUẢ THẨM ĐỊNH STAGE 1 PLANNER:")
	fmt.Println("==================================================================")
	fmt.Printf("⏱️  Thời gian phản hồi DeepSeek: %v\n", elapsed)
	fmt.Printf("📚 Tên bài giảng: %s\n", plan.LessonTitle)
	fmt.Printf("📝 Tổng quan: %s\n", plan.Overview)
	fmt.Printf("📦 Số cụm câu hỏi lập chỉ mục (question_catalog): %d cụm\n", len(plan.QuestionCatalog))
	fmt.Printf("🔢 Số lượng dạng toán (topics): %d dạng\n\n", len(plan.Topics))

	for i, tp := range plan.Topics {
		fmt.Printf("  [%d] %s (%s)\n", i+1, tp.Title, tp.Difficulty)
		fmt.Printf("      ↳ Đích đến: %s\n", tp.TargetOutput)
		fmt.Printf("      ↳ Cốt lõi: %s\n", tp.CoreConcept)
		fmt.Printf("      ↳ Câu hỏi phân bổ (%d câu): %s\n", len(tp.AssignedQuestionIDs), strings.Join(tp.AssignedQuestionIDs, ", "))
	}
	fmt.Println("==================================================================")
}
