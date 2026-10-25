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

	// 2. Danh mục tài liệu đầu vào: nén N-Up 4 độc lập cho từng file để bảo toàn ranh giới trang & DocID
	type inputItem struct {
		docID    string
		path     string
		roleHint string
	}

	items := []inputItem{
		{"DOC_DSD", filepath.Join("infrastructure2", "gemini", "dsd.pdf"), "Tài liệu tóm tắt lý thuyết và kiến thức trọng tâm (dsd)"},
		{"DOC_SGK_HH12", filepath.Join("infrastructure2", "gemini", "HH12-KNTT- C2-GHEP FULL GIAI.pdf"), "Tài liệu chính: SGK & Bài giải chi tiết Chương II Hình học 12"},
		{"DOC_ON_VECTO", filepath.Join("infrastructure2", "gemini", "ÔN VEC TƠ KG 10T10.pdf"), "Tài liệu ngân hàng bài tập ôn luyện chuyên đề Vectơ"},
	}

	fmt.Println("📂 DANH SÁCH CÁC TÀI LIỆU ĐẦU VÀO ĐƯỢC NÉN N-UP 4 ĐỘC LẬP TỪNG TÀI LIỆU:")
	var docs []gemini.DocumentInput

	for idx, item := range items {
		nupFile := strings.TrimSuffix(item.path, ".pdf") + "_nup4.pdf"
		nupBytes, errRead := os.ReadFile(nupFile)
		if errRead != nil || len(nupBytes) == 0 {
			fmt.Printf("  🔄 [%d] Đang nén N-Up 4 riêng cho: %s...\n", idx+1, filepath.Base(item.path))
			proc := pdf.NewProcessor()
			var errNUp error
			nupBytes, errNUp = proc.MergeAndNUp(context.Background(), []string{item.path}, 4)
			if errNUp != nil {
				log.Fatalf("❌ Lỗi nén N-Up 4 cho %s: %v", item.path, errNUp)
			}
			_ = os.WriteFile(nupFile, nupBytes, 0644)
		}
		fmt.Printf("  ✅ [%d] %s -> %s (%.2f MB)\n", idx+1, item.docID, filepath.Base(nupFile), float64(len(nupBytes))/(1024*1024))
		docs = append(docs, gemini.DocumentInput{
			DocID:    item.docID,
			FileName: filepath.Base(nupFile),
			RoleHint: item.roleHint,
			RawPDF:   nupBytes,
		})
	}

	// 2.2 Tích hợp Video YouTube (hỗ trợ cào transcript & nén N-Up 4 tự động)
	youtubeURL := "https://www.youtube.com/watch?v=7urfQ8s20oY" // Video bài giảng Thầy Nguyễn Phan Tiến
	if strings.TrimSpace(youtubeURL) != "" {
		fmt.Printf("\n🎥 Đang tích hợp Video YouTube tự động: %s...\n", youtubeURL)
		ytDoc, errYT := gemini.NewDocumentInputFromYouTube(context.Background(), "DOC_YOUTUBE", youtubeURL, "Video bài giảng trích xuất mẹo giải nhanh và phương pháp tư duy")
		if errYT != nil {
			fmt.Printf("  ⚠️ Không thể nạp YouTube (%v), tiếp tục với các tài liệu PDF\n", errYT)
		} else {
			fmt.Printf("  ✅ DOC_YOUTUBE -> %s (%.2f KB)\n\n", ytDoc.FileName, float64(len(ytDoc.RawPDF))/1024)
			docs = append(docs, ytDoc)
		}
	}

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
