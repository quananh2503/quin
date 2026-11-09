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
	fmt.Println("🚀 BẮT ĐẦU CHẠY FULL END-TO-END PIPELINE VỚI DEEPSEEK (deepseek-flash)")
	fmt.Println("==================================================================")

	// 1. Đọc API Key hoàn toàn từ biến môi trường (Tuyệt đối không lưu vào file)
	apiKey := strings.TrimSpace(os.Getenv("DEEPSEEK_API_KEY"))
	if apiKey == "" {
		fmt.Println("❌ LỖI: Chưa tìm thấy biến môi trường DEEPSEEK_API_KEY!")
		fmt.Println("\n👉 Vui lòng chạy lệnh sau trong PowerShell trước khi chạy pipeline:")
		fmt.Println("   $env:DEEPSEEK_API_KEY=\"sk-key-thật-của-bạn\"")
		fmt.Println("   go run ./infrastructure2/gemini/tools/run_deepseek_pipeline")
		os.Exit(1)
	}

	modelName := strings.TrimSpace(os.Getenv("DEEPSEEK_MODEL"))
	if modelName == "" {
		modelName = "deepseek-flash"
	}

	// Ẩn bớt ký tự key để hiển thị an toàn
	maskedKey := apiKey
	if len(apiKey) > 10 {
		maskedKey = apiKey[:6] + "..." + apiKey[len(apiKey)-4:]
	}
	fmt.Printf("🔑 Đã nhận DeepSeek API Key: %s\n", maskedKey)
	fmt.Printf("🤖 Model AI áp dụng: %s (Hỗ trợ Multimodal Vision + JSON mode)\n\n", modelName)

	// 2. Danh mục tài liệu đầu vào: 2 file PDF kiểm thử thực tế
	type inputItem struct {
		docID    string
		path     string
		roleHint string
	}

	items := []inputItem{
		{"DOC_MINH_THU", filepath.Join("infrastructure2", "gemini", "pdfs", "tests", "Minh Thư tha6 ..pdf"), "Tài liệu đề thi và bài tập toán ôn luyện (Minh Thư)"},
		{"DOC_KHAO_SAT_HAM_SO", filepath.Join("infrastructure2", "gemini", "pdfs", "tests", "Cầu 6 Cho hàm số y = f (x) có đồ thị là đường cong trong hình vẽ dưới đây. Hàm số y =  (x) đồng.pdf"), "Tài liệu chuyên đề khảo sát hàm số, đồ thị và bảng biến thiên"},
	}

	fmt.Println("📂 DANH SÁCH TÀI LIỆU ĐẦU VÀO:")
	var docs []gemini.DocumentInput

	for idx, item := range items {
		optFile := strings.TrimSuffix(item.path, ".pdf") + "_opt.pdf"
		pdfBytes, errRead := os.ReadFile(optFile)
		if errRead != nil || len(pdfBytes) == 0 {
			rawBytes, errRaw := os.ReadFile(item.path)
			if errRaw != nil {
				log.Fatalf("❌ Lỗi đọc file %s: %v", item.path, errRaw)
			}
			if len(rawBytes) > gemini.ScannedPDFThreshold {
				fmt.Printf("  🔄 [%d] Đang tối ưu nén ảnh PDF scan: %s (%.2f MB)...\n", idx+1, filepath.Base(item.path), float64(len(rawBytes))/(1024*1024))
				optBytes, errOpt := gemini.OptimizeScannedPDF(rawBytes)
				if errOpt == nil && len(optBytes) > 0 {
					pdfBytes = optBytes
					if errSave := os.WriteFile(optFile, optBytes, 0644); errSave != nil {
						log.Printf("⚠️ Không thể ghi file cache %s: %v", optFile, errSave)
					}
				} else {
					pdfBytes = rawBytes
				}
			} else {
				pdfBytes = rawBytes
			}
		}
		fmt.Printf("  ✅ [%d] %s -> %s (%.2f MB)\n", idx+1, item.docID, filepath.Base(item.path), float64(len(pdfBytes))/(1024*1024))
		docs = append(docs, gemini.DocumentInput{
			DocID:    item.docID,
			FileName: filepath.Base(item.path),
			RoleHint: item.roleHint,
			RawPDF:   pdfBytes,
		})
	}

	// 3. Khởi tạo Pipeline hoàn chỉnh
	ctx := context.Background()

	// Bổ sung tài liệu YouTube từ link theo kịch bản chuẩn
	youtubeURL := "https://www.youtube.com/watch?v=g1TNk2RqjNM"
	fmt.Printf("  📺 [3] Đang lấy transcript YouTube: %s...\n", youtubeURL)
	ytDoc, errYT := gemini.NewDocumentInputFromYouTube(ctx, "DOC_YOUTUBE_1", youtubeURL, "Video bài giảng YouTube: Khảo sát hàm số, trích xuất mẹo giải nhanh và tư duy đồ thị")
	if errYT != nil {
		log.Printf("⚠️ Cảnh báo: Tải transcript YouTube thất bại (%v), tiếp tục với các file PDF", errYT)
	} else {
		fmt.Printf("  ✅ [3] DOC_YOUTUBE_1 -> %s (%.2f KB)\n", ytDoc.FileName, float64(len(ytDoc.RawPDF))/1024)
		docs = append(docs, ytDoc)
	}

	pipeline, errPipeline := gemini.NewDeepSeekLessonPipeline(apiKey, modelName)
	if errPipeline != nil {
		log.Fatalf("❌ Khởi tạo NewDeepSeekLessonPipeline thất bại: %v", errPipeline)
	}

	runID := fmt.Sprintf("deepseek_run_%s", time.Now().Format("20060102_150405"))
	outDir := filepath.Join("infrastructure2", "gemini", ".artifacts", "full_pipeline_output", runID)
	if errMk := os.MkdirAll(outDir, 0755); errMk != nil {
		log.Fatalf("❌ Tạo thư mục output thất bại: %v", errMk)
	}
	fmt.Printf("\n📁 Thư mục lưu kết quả xuất bản: %s\n\n", outDir)

	req := gemini.PipelineRequest{
		Documents: docs,
		UserInstruction: `Phân tích toàn diện kịch bản kết hợp đa tài liệu (2 file PDF scan và 1 Video bài giảng YouTube):
- Trích xuất toàn bộ các dạng toán liên quan đến hàm số, tính đơn điệu, cực trị, tiệm cận, đồ thị và bảng biến thiên.
- Khai thác tối đa mẹo giải nhanh, phương pháp Casio và nhận xét sư phạm từ video bài giảng YouTube để làm giàu phần Mẹo giải nhanh (CalloutTip).
- Phân chia dạng toán rõ ràng theo chuẩn GDPT 2018.
- Biên soạn đầy đủ lý thuyết, bài tập mẫu và bài tập rèn luyện tương ứng.`,
		OutputDir: outDir,
	}

	fmt.Println("⚡ ĐANG KÍCH HOẠT PIPELINE TỰ ĐỘNG VỚI DEEPSEEK:")
	fmt.Println("  [Stage 1] Master Planner: Phân tích tài liệu & ảnh PDF để lập danh mục dạng toán.")
	fmt.Println("  [Stage 1.5] Reviewer: Kiểm tra độ phủ bài tập và tinh chỉnh dạng toán.")
	fmt.Println("  [Stage 1.75] Polisher: Chuốt lại sư phạm (Khái niệm -> Cơ bản -> Nâng cao -> Ứng dụng).")
	fmt.Println("  [Stage 2] Worker Pool: 6 Worker chạy song song biên soạn chi tiết từng dạng toán.")
	fmt.Println("  [Stage 2.5] Visual Enrichment Stage.")
	fmt.Println("  [Stage 3 & 4] Document Assembler -> Typst Compile -> Quality Gate.")
	fmt.Println("------------------------------------------------------------------")

	startTime := time.Now()
	output, errExec := pipeline.Execute(ctx, req)
	if errExec != nil {
		log.Fatalf("❌ Pipeline DeepSeek thất bại: %v", errExec)
	}

	elapsed := time.Since(startTime)
	fmt.Println("\n==================================================================")
	fmt.Println("🎉 PIPELINE DEEPSEEK ĐÃ HOÀN TẤT XUẤT SẮC TOÀN BỘ TIẾN TRÌNH!")
	fmt.Println("==================================================================")
	fmt.Printf("⏱️  Tổng thời gian thực thi: %v\n", elapsed)
	if output.Plan != nil {
		fmt.Printf("📚 Tên bài giảng: %s\n", output.Plan.LessonTitle)
		fmt.Printf("🔢 Số lượng dạng toán: %d\n", len(output.Plan.Topics))
		for i, t := range output.Plan.Topics {
			fmt.Printf("   [%d] %s (%s)\n", i+1, t.Title, t.Difficulty)
		}
	}
	fmt.Printf("👥 Số lượng Worker hoàn thành: %d\n", len(output.Workers))

	fmt.Println("\n📊 THỐNG KÊ TOKEN & CHI PHÍ:")
	fmt.Printf("  • Prompt Tokens (Input):     %d\n", output.TotalUsage.PromptTokens)

	hitPercent := 0.0
	if output.TotalUsage.PromptTokens > 0 {
		hitPercent = float64(output.TotalUsage.PromptCacheHitTokens) * 100.0 / float64(output.TotalUsage.PromptTokens)
	}

	offPeak := isDeepSeekOffPeak(time.Now())
	rateHit := 0.003
	rateMiss := 0.15
	rateOut := 0.60
	statusLabel := "🟢 GIỜ THẤP ĐIỂM (Off-Peak - Ưu đãi giảm 50%)"
	if !offPeak {
		rateHit = 0.006
		rateMiss = 0.30
		rateOut = 1.20
		statusLabel = "🔴 GIỜ CAO ĐIỂM (Peak - Giờ hành chính)"
	}

	fmt.Printf("     ├─ 🟢 Cache Hit:           %d tokens (%.1f%%) [$%.3f/1M]\n", output.TotalUsage.PromptCacheHitTokens, hitPercent, rateHit)
	fmt.Printf("     └─ ⚪ Cache Miss:          %d tokens [$%.2f/1M]\n", output.TotalUsage.PromptCacheMissTokens, rateMiss)
	fmt.Printf("  • Candidates Tokens (Output): %d [$%.2f/1M]\n", output.TotalUsage.CandidatesTokens, rateOut)
	fmt.Printf("  • Total Tokens:              %d\n", output.TotalUsage.TotalTokens)

	// Tính chi phí thực tế theo khung giờ hiện tại
	costHit := float64(output.TotalUsage.PromptCacheHitTokens) * rateHit / 1000000.0
	costMiss := float64(output.TotalUsage.PromptCacheMissTokens) * rateMiss / 1000000.0
	costOut := float64(output.TotalUsage.CandidatesTokens) * rateOut / 1000000.0
	totalCostUSD := costHit + costMiss + costOut
	totalCostVND := totalCostUSD * 25400.0

	var altCostUSD float64
	var altLabel string
	if offPeak {
		altCostUSD = costHit*2.0 + costMiss*2.0 + costOut*2.0
		altLabel = "nếu chạy trong Giờ hành chính (Peak)"
	} else {
		altCostUSD = costHit*0.5 + costMiss*0.5 + costOut*0.5
		altLabel = "nếu chạy trong Giờ thấp điểm (Off-Peak/Trưa/Cuối tuần)"
	}
	altCostVND := altCostUSD * 25400.0

	fmt.Printf("  ⏱️  Khung giờ thực thi:      %s\n", statusLabel)
	fmt.Printf("  💰 Chi phí thực tế lượt này: $%.5f USD (~%.0f VNĐ)\n", totalCostUSD, totalCostVND)
	fmt.Printf("     ↳ So sánh tham chiếu:      $%.5f USD (~%.0f VNĐ) %s\n", altCostUSD, altCostVND, altLabel)

	fmt.Println("\n📁 KẾT QUẢ ĐẦU RA PDF ĐÃ ĐƯỢC XUẤT:")
	fmt.Printf("  📘 Bản Giáo Viên (Đầy đủ lời giải & đáp án): %s\n", output.TeacherPDFPath)
	fmt.Printf("  📗 Bản Học Sinh (Phiếu bài tập & chừa dòng làm bài): %s\n", output.StudentPDFPath)

	if infoGV, errStatGV := os.Stat(output.TeacherPDFPath); errStatGV == nil {
		fmt.Printf("     ↳ Kích thước file Giáo Viên: %.2f KB\n", float64(infoGV.Size())/1024)
	}
	if infoHS, errStatHS := os.Stat(output.StudentPDFPath); errStatHS == nil {
		fmt.Printf("     ↳ Kích thước file Học Sinh: %.2f KB\n", float64(infoHS.Size())/1024)
	}
	fmt.Println("==================================================================")
}

// isDeepSeekOffPeak kiểm tra thời điểm hiện tại có thuộc khung giờ giảm giá 50% của DeepSeek hay không.
// Quy định UTC của DeepSeek:
// Peak (Giờ cao điểm): Thứ 2 - Thứ 6 từ 01:00-04:00 UTC (08:00-11:00 VN) và 06:00-10:00 UTC (13:00-17:00 VN).
// Off-Peak (Giảm 50%): Thứ 7, CN (cả ngày), ngày thường từ 11:00-13:00 trưa và sau 17:00 - trước 08:00 sáng VN.
func isDeepSeekOffPeak(t time.Time) bool {
	utc := t.UTC()
	wd := utc.Weekday()
	if wd == time.Saturday || wd == time.Sunday {
		return true
	}
	minutes := utc.Hour()*60 + utc.Minute()
	// Peak 1: 01:00 - 04:00 UTC (08:00 - 11:00 VN)
	if minutes >= 60 && minutes < 240 {
		return false
	}
	// Peak 2: 06:00 - 10:00 UTC (13:00 - 17:00 VN)
	if minutes >= 360 && minutes < 600 {
		return false
	}
	return true
}
