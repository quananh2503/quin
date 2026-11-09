package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"

	"meet-attendance-clean/infrastructure2/gemini"
)

func main() {
	fmt.Println("==================================================================")
	fmt.Println("🧪 BẮT ĐẦU TEST THỰC NGHIỆM CƠ CHẾ PROMPT CACHE HIT CỦA DEEPSEEK")
	fmt.Println("==================================================================")

	apiKey := strings.TrimSpace(os.Getenv("DEEPSEEK_API_KEY"))
	if apiKey == "" {
		fmt.Println("❌ LỖI: Chưa tìm thấy biến môi trường DEEPSEEK_API_KEY!")
		fmt.Println("\n👉 Vui lòng gán key trong PowerShell:")
		fmt.Println("   $env:DEEPSEEK_API_KEY=\"sk-your-key\"")
		fmt.Println("   go run ./infrastructure2/gemini/tools/test_cache_hit")
		os.Exit(1)
	}

	modelName := strings.TrimSpace(os.Getenv("DEEPSEEK_MODEL"))
	if modelName == "" {
		modelName = "deepseek-flash"
	}

	// 1. Chỉ dùng ĐÚNG 1 FILE PDF để test nhẹ nhàng
	pdfPath := filepath.Join("infrastructure2", "gemini", "pdfs", "tests", "Minh Thư tha6 ..pdf")
	optPath := filepath.Join("infrastructure2", "gemini", "pdfs", "tests", "Minh Thư tha6 ._opt.pdf")

	usePath := pdfPath
	if _, errOpt := os.Stat(optPath); errOpt == nil {
		usePath = optPath
	}

	fmt.Printf("📄 Đang đọc file PDF thử nghiệm: %s\n", filepath.Base(usePath))
	pdfBytes, errRead := os.ReadFile(usePath)
	if errRead != nil {
		log.Fatalf("❌ Không thể đọc file PDF %s: %v", usePath, errRead)
	}

	ctx := context.Background()
	compiler := gemini.NewCLITypstCompiler()
	fmt.Println("🖼️  Đang render các trang PDF thành ảnh cho DeepSeek Vision...")
	imgs, errRast := compiler.RasterizePDF(ctx, pdfBytes)
	if errRast != nil || len(imgs) == 0 {
		log.Fatalf("❌ Rasterize PDF thất bại: %v", errRast)
	}
	fmt.Printf("✅ Đã chuẩn bị %d trang ảnh (đã tối ưu kích thước <= 1600px)\n\n", len(imgs))

	doc := gemini.DocumentInput{
		DocID:      "DOC_TEST_CACHE",
		FileName:   filepath.Base(usePath),
		RoleHint:   "Tài liệu toán thử nghiệm cache",
		PageImages: imgs,
	}

	provider := gemini.NewDeepSeekLLMProvider(apiKey, modelName)

	systemPrompt := "BẠN LÀ: Chuyên gia Sư phạm Toán học THPT. Hãy phân tích tài liệu đính kèm và trả về kết quả JSON theo đúng yêu cầu."

	// -------------------------------------------------------------
	// LẦN 1: Request khởi tạo (Prefill Cache)
	// -------------------------------------------------------------
	fmt.Println("------------------------------------------------------------------")
	fmt.Println("🚀 [LẦN 1] Gửi Request đầu tiên (Nạp ảnh và tài liệu vào Cache của DeepSeek)...")
	fmt.Println("------------------------------------------------------------------")

	req1 := gemini.LLMRequest{
		ModelName:    modelName,
		SystemPrompt: systemPrompt,
		Documents:    []gemini.DocumentInput{doc},
		UserPrompt:   `Yêu cầu 1: Hãy liệt kê ngắn gọn 3 chủ đề toán học chính có trong tài liệu này (trả về JSON dạng: {"topics": ["chủ đề 1", "chủ đề 2", "chủ đề 3"]}).`,
		Temperature:  0.2,
	}

	start1 := time.Now()
	resp1, err1 := provider.GenerateJSON(ctx, req1)
	dur1 := time.Since(start1)
	if err1 != nil {
		log.Fatalf("❌ Lần 1 thất bại: %v", err1)
	}

	fmt.Printf("⏱️  Thời gian phản hồi: %v\n", dur1)
	fmt.Printf("📥 Prompt Tokens:        %d\n", resp1.Usage.PromptTokens)
	fmt.Printf("   ├─ 🟦 Cache Hit:      %d tokens (Lần đầu thường là 0 hoặc rất nhỏ)\n", resp1.Usage.PromptCacheHitTokens)
	fmt.Printf("   └─ 🟥 Cache Miss:     %d tokens\n", resp1.Usage.PromptCacheMissTokens)
	fmt.Printf("📤 Output Tokens:        %d\n", resp1.Usage.CandidatesTokens)
	fmt.Printf("📝 Phản hồi JSON:        %s\n\n", strings.ReplaceAll(resp1.RawJSON, "\n", " "))

	// Chờ 2 giây để máy chủ DeepSeek hoàn tất ghi disk cache
	fmt.Println("⏳ Chờ 3 giây để hệ thống DeepSeek lưu trữ Cache Units trên máy chủ...")
	time.Sleep(3 * time.Second)

	// -------------------------------------------------------------
	// LẦN 2: Request thứ hai (Kiểm tra Cache Hit)
	// Dùng CÙNG SystemPrompt và CÙNG danh sách ảnh, chỉ đổi UserPrompt ở cuối
	// -------------------------------------------------------------
	fmt.Println("------------------------------------------------------------------")
	fmt.Println("🚀 [LẦN 2] Gửi Request thứ hai (CÙNG ẢNH, chỉ đổi câu hỏi ở cuối)...")
	fmt.Println("------------------------------------------------------------------")

	req2 := gemini.LLMRequest{
		ModelName:    modelName,
		SystemPrompt: systemPrompt,
		Documents:    []gemini.DocumentInput{doc},
		UserPrompt:   `Yêu cầu 2: Hãy chỉ ra 2 công thức quan trọng nhất cần ghi nhớ từ tài liệu này (trả về JSON dạng: {"formulas": ["công thức 1", "công thức 2"]}).`,
		Temperature:  0.2,
	}

	start2 := time.Now()
	resp2, err2 := provider.GenerateJSON(ctx, req2)
	dur2 := time.Since(start2)
	if err2 != nil {
		log.Fatalf("❌ Lần 2 thất bại: %v", err2)
	}

	fmt.Printf("⏱️  Thời gian phản hồi: %v\n", dur2)
	fmt.Printf("📥 Prompt Tokens:        %d\n", resp2.Usage.PromptTokens)
	fmt.Printf("   ├─ 🟢 Cache Hit:      %d tokens\n", resp2.Usage.PromptCacheHitTokens)
	fmt.Printf("   └─ ⚪ Cache Miss:     %d tokens\n", resp2.Usage.PromptCacheMissTokens)
	fmt.Printf("📤 Output Tokens:        %d\n", resp2.Usage.CandidatesTokens)
	fmt.Printf("📝 Phản hồi JSON:        %s\n\n", strings.ReplaceAll(resp2.RawJSON, "\n", " "))

	// -------------------------------------------------------------
	// TỔNG KẾT SO SÁNH
	// -------------------------------------------------------------
	fmt.Println("==================================================================")
	fmt.Println("📊 KẾT QUẢ ĐỐI CHỨNG CACHE HIT:")
	fmt.Println("==================================================================")
	if resp2.Usage.PromptTokens > 0 {
		hitRate := float64(resp2.Usage.PromptCacheHitTokens) * 100.0 / float64(resp2.Usage.PromptTokens)
		fmt.Printf("🎯 Tỷ lệ Cache Hit ở Lần 2: %.2f%%\n", hitRate)
		if hitRate >= 80 {
			fmt.Println("🎉 XÁC NHẬN: Cơ chế Prompt Caching của DeepSeek đã hoạt động HOÀN HẢO!")
			fmt.Println("   Toàn bộ ảnh PDF đã được đọc từ Cache với đơn giá giảm 98% ($0.003/1M)!")
		} else {
			fmt.Println("⚠️  Tỷ lệ Cache Hit chưa cao. Hãy kiểm tra lại sự đồng nhất của tiền tố.")
		}
	}
	fmt.Println("==================================================================")
}
