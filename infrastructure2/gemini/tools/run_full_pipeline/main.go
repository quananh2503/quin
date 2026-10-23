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
	"meet-attendance-clean/infrastructure2/pdf"
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

	// 2. Danh mục 3 tài liệu PDF đầu vào
	pdfPaths := []string{
		filepath.Join("infrastructure2", "gemini", "dsd.pdf"),
		filepath.Join("infrastructure2", "gemini", "HH12-KNTT- C2-GHEP FULL GIAI.pdf"),
		filepath.Join("infrastructure2", "gemini", "ÔN VEC TƠ KG 10T10.pdf"),
	}

	fmt.Println("📂 DANH SÁCH 3 TÀI LIỆU PDF ĐẦU VÀO ĐƯỢC KẾT HỢP:")
	fmt.Printf("  [1] Tài liệu dsd: %s\n", filepath.Base(pdfPaths[0]))
	fmt.Printf("  [2] Tài liệu chính (SGK & Bài giải Chương II): %s\n", filepath.Base(pdfPaths[1]))
	fmt.Printf("  [3] Tài liệu ngân hàng bài tập ôn luyện: %s\n", filepath.Base(pdfPaths[2]))

	// Với mô hình Gemma trên gói Free Tier (trần 16,000 input tokens/phút),
	// 3 tài liệu PDF được tự động N-Up 8 trang/sheet để nén số tokens tối đa
	nupPath := filepath.Join("infrastructure2", "gemini", "consolidated_dsd_hh12_onvec_nup8.pdf")
	nupBytes, err := os.ReadFile(nupPath)
	if err != nil || len(nupBytes) == 0 {
		fmt.Println("🔄 Đang hợp nhất 3 file PDF thành định dạng N-Up 8 trang/sheet...")
		proc := pdf.NewProcessor()
		nupBytes, err = proc.MergeAndNUp8(context.Background(), pdfPaths)
		if err != nil {
			log.Fatalf("❌ Lỗi NUp: %v", err)
		}
		_ = os.WriteFile(nupPath, nupBytes, 0644)
	}

	docs := []gemini.DocumentInput{
		{
			DocID:    "DOC_CONSOLIDATED_3PDFS",
			FileName: "consolidated_dsd_hh12_onvec_nup8.pdf",
			RoleHint: "Tài liệu hợp nhất 3 nguồn: dsd + SGK HH12 + Đề bài ôn tập vectơ (N-Up 8)",
			RawPDF:   nupBytes,
		},
	}
	fmt.Printf("✅ Đã hợp nhất 3 tài liệu thành 1 khối KV-Cache N-Up 8 tối ưu (Kích thước: %.2f MB, ~2,850 tokens)\n\n",
		float64(len(nupBytes))/(1024*1024))

	// 3. Khởi tạo Pipeline hoàn chỉnh
	ctx := context.Background()
	pipeline, err := gemini.NewStandardLessonPipeline(ctx, keys, gemini.ModelGemma4_31B)
	if err != nil {
		log.Fatalf("❌ Khởi tạo StandardLessonPipeline thất bại: %v", err)
	}

	outDir := filepath.Join("infrastructure2", "gemini", ".artifacts", "full_pipeline_output")
	_ = os.MkdirAll(outDir, 0755)

	req := gemini.PipelineRequest{
		Documents: docs,
		UserInstruction: `Tập trung khai thác kịch bản kết hợp đa tài liệu:
- Lấy mạch SGK làm khung lý thuyết cốt lõi.
- Bổ sung bài tập và biến thể từ tài liệu ôn tập và tài liệu tóm tắt.
- Yêu cầu xuất bài giảng chuyên sâu về Vectơ và Tọa độ trong không gian Oxyz.`,
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
