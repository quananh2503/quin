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

func loadAPIKeys() []string {
	var keys []string
	keyFiles := []string{
		filepath.Join("infrastructure2", "gemini", "key1.txt"),
		filepath.Join("infrastructure2", "gemini", "key2.txt"),
		filepath.Join("infrastructure2", "gemini", "key3.txt"),
		filepath.Join("infrastructure2", "gemini", "key4.txt"),
		filepath.Join("infrastructure2", "gemini", "key5.txt"),
		filepath.Join("infrastructure2", "gemini", "key.txt"),
		"key1.txt", "key2.txt", "key3.txt", "key4.txt", "key5.txt", "key.txt",
	}
	seen := make(map[string]bool)

	for _, kf := range keyFiles {
		data, err := os.ReadFile(kf)
		if err == nil {
			k := strings.TrimSpace(string(data))
			if k != "" && !seen[k] {
				seen[k] = true
				keys = append(keys, k)
			}
		}
	}
	if envKey := strings.TrimSpace(os.Getenv("GEMINI_API_KEY")); envKey != "" && !seen[envKey] {
		keys = append(keys, envKey)
	}
	return keys
}

func main() {
	fmt.Println("==================================================================")
	fmt.Println("🚀 BẮT ĐẦU CHẠY FULL END-TO-END PIPELINE BIÊN SOẠN BÀI GIẢNG TOÁN")
	fmt.Println("==================================================================")

	// 1. Tải API keys
	keys := loadAPIKeys()
	if len(keys) == 0 {
		log.Fatalf("❌ Không tìm thấy API Key nào trong key*.txt")
	}
	fmt.Printf("🔑 Đã nạp %d API keys khả dụng cho KeyPool\n\n", len(keys))

	// 2. Danh mục tài liệu đầu vào: 2 file PDF kiểm thử theo yêu cầu
	type inputItem struct {
		docID    string
		path     string
		roleHint string
	}

	items := []inputItem{
		{"DOC_MINH_THU", filepath.Join("infrastructure2", "gemini", "pdfs", "tests", "Minh Thư tha6 ..pdf"), "Tài liệu đề thi và bài tập toán ôn luyện (Minh Thư)"},
		{"DOC_KHAO_SAT_HAM_SO", filepath.Join("infrastructure2", "gemini", "pdfs", "tests", "Cầu 6 Cho hàm số y = f (x) có đồ thị là đường cong trong hình vẽ dưới đây. Hàm số y =  (x) đồng.pdf"), "Tài liệu chuyên đề khảo sát hàm số, đồ thị và bảng biến thiên"},
	}

	fmt.Println("📂 DANH SÁCH CÁC TÀI LIỆU ĐẦU VÀO (TỰ ĐỘNG TỐI ƯU ẢNH SCAN NẾU CẦN):")
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

	// Bổ sung tài liệu YouTube từ link theo yêu cầu của người dùng
	youtubeURL := "https://www.youtube.com/watch?v=g1TNk2RqjNM"
	fmt.Printf("  📺 [3] Đang cào transcript và biên dịch N-Up 4 từ YouTube: %s...\n", youtubeURL)
	ytDoc, errYT := gemini.NewDocumentInputFromYouTube(ctx, "DOC_YOUTUBE_1", youtubeURL, "Video bài giảng YouTube: Khảo sát hàm số, trích xuất mẹo giải nhanh và tư duy đồ thị")
	if errYT != nil {
		log.Printf("⚠️ Cảnh báo: Tải transcript YouTube thất bại (%v), tiếp tục với các file PDF", errYT)
	} else {
		fmt.Printf("  ✅ [3] DOC_YOUTUBE_1 -> %s (%.2f KB)\n", ytDoc.FileName, float64(len(ytDoc.RawPDF))/1024)
		docs = append(docs, ytDoc)
	}

	pipeline, err := gemini.NewStandardLessonPipeline(ctx, keys, gemini.ModelGemma4_31B)
	if err != nil {
		log.Fatalf("❌ Khởi tạo StandardLessonPipeline thất bại: %v", err)
	}

	runID := fmt.Sprintf("run_%s", time.Now().Format("20060102_150405"))
	outDir := filepath.Join("infrastructure2", "gemini", ".artifacts", "full_pipeline_output", runID)
	if errMk := os.MkdirAll(outDir, 0755); errMk != nil {
		log.Fatalf("❌ Tạo thư mục output thất bại: %v", errMk)
	}
	fmt.Printf("📁 Thư mục lưu kết quả xuất bản: %s\n\n", outDir)

	req := gemini.PipelineRequest{
		Documents: docs,
		UserInstruction: `Phân tích toàn diện kịch bản kết hợp đa tài liệu (2 file PDF scan và 1 Video bài giảng YouTube):
- Trích xuất toàn bộ các dạng toán liên quan đến hàm số, tính đơn điệu, cực trị, tiệm cận, đồ thị và bảng biến thiên.
- Khai thác tối đa mẹo giải nhanh, phương pháp Casio và nhận xét sư phạm từ video bài giảng YouTube để làm giàu phần Mẹo giải nhanh (CalloutTip).
- Phân chia dạng toán rõ ràng theo chuẩn GDPT 2018.
- Biên soạn đầy đủ lý thuyết, bài tập mẫu và bài tập rèn luyện tương ứng.`,
		OutputDir: outDir,
	}

	fmt.Println("⚡ ĐANG KÍCH HOẠT PIPELINE TỰ ĐỘNG:")
	fmt.Println("  [Stage 1] Master Planner phân tích tài liệu hợp nhất để thiết lập danh mục dạng toán.")
	fmt.Println("  [Stage 1.5] Reviewer kiểm tra unassigned questions và bổ sung dạng khuyết.")
	fmt.Println("  [Stage 1.75] Polisher sắp xếp sư phạm (Khái niệm -> Cơ bản -> Nâng cao -> Ứng dụng).")
	fmt.Println("  [Stage 2] Worker Pool biên soạn song song các dạng toán (12 workers).")
	fmt.Println("  [Stage 2.5] Visual Enrichment Stage.")
	fmt.Println("  [Stage 3 & 4] Document Assembler -> Typst Compile -> Line Isolation Quality Gate.")
	fmt.Println("------------------------------------------------------------------")

	startTime := time.Now()
	output, err := pipeline.Execute(ctx, req)
	if err != nil {
		log.Fatalf("❌ Pipeline thất bại: %v", err)
	}

	elapsed := time.Since(startTime)
	fmt.Println("\n==================================================================")
	fmt.Println("🎉 PIPELINE ĐÃ HOÀN TẤT XUẤT SẮC TOÀN BỘ TIẾN TRÌNH!")
	fmt.Println("==================================================================")
	fmt.Printf("⏱️  Tổng thời gian: %v\n", elapsed)
	if output.Plan != nil {
		fmt.Printf("📚 Tên bài giảng: %s\n", output.Plan.LessonTitle)
		fmt.Printf("🔢 Số lượng dạng toán: %d\n", len(output.Plan.Topics))
		for i, t := range output.Plan.Topics {
			fmt.Printf("   [%d] %s (%s)\n", i+1, t.Title, t.Difficulty)
		}
	}
	fmt.Printf("👥 Số lượng Worker hoàn thành: %d\n", len(output.Workers))
	fmt.Println("\n📁 KẾT QUẢ ĐẦU RA PDF ĐÃ ĐƯỢC XUẤT:")
	fmt.Printf("  📘 Bản Giáo Viên (Đầy đủ lời giải & đáp án): %s\n", output.TeacherPDFPath)
	fmt.Printf("  📗 Bản Học Sinh (Phiếu bài tập & chừa dòng làm bài): %s\n", output.StudentPDFPath)

	// Kiểm tra kích thước file thật
	if infoGV, err := os.Stat(output.TeacherPDFPath); err == nil {
		fmt.Printf("     ↳ Kích thước file Giáo Viên: %.2f KB\n", float64(infoGV.Size())/1024)
	}
	if infoHS, err := os.Stat(output.StudentPDFPath); err == nil {
		fmt.Printf("     ↳ Kích thước file Học Sinh: %.2f KB\n", float64(infoHS.Size())/1024)
	}
	fmt.Println("==================================================================")
}
