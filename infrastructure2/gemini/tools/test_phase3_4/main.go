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

	"meet-attendance-clean/infrastructure2/gemini"
)

func loadAPIKeys() []string {
	var keys []string
	keyFiles := []string{
		filepath.Join("infrastructure2", "gemini", "key1.txt"),
		filepath.Join("infrastructure2", "gemini", "key3.txt"),
		filepath.Join("infrastructure2", "gemini", "key4.txt"),
		"key1.txt", "key3.txt", "key4.txt",
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
	fmt.Println("🧪 CHẠY KIỂM THỬ ĐỘC LẬP PHASE 3 & 4 VỚI GEMINI-3.5-FLASH-LITE")
	fmt.Println("==================================================================")

	keys := loadAPIKeys()
	if len(keys) == 0 {
		log.Fatalf("❌ Không tìm thấy API key nào.")
	}
	fmt.Printf("🔑 Nạp thành công %d API keys\n", len(keys))

	// 1. Nạp Phase 1 Plan đã lưu
	planPath := filepath.Join("infrastructure2", "gemini", ".artifacts", "phase1_plan.json")
	planData, err := os.ReadFile(planPath)
	if err != nil {
		log.Fatalf("❌ Không đọc được %s: %v", planPath, err)
	}
	var plan gemini.LessonPlan
	if err := json.Unmarshal(planData, &plan); err != nil {
		log.Fatalf("❌ Parse phase1_plan.json thất bại: %v", err)
	}
	fmt.Printf("📋 Đã nạp Kế hoạch: %s (%d dạng toán)\n", plan.LessonTitle, len(plan.Topics))

	// 2. Nạp Phase 2 Workers đã lưu
	workersPath := filepath.Join("infrastructure2", "gemini", ".artifacts", "phase2_all_results.json")
	workersData, err := os.ReadFile(workersPath)
	if err != nil {
		log.Fatalf("❌ Không đọc được %s: %v", workersPath, err)
	}
	var workers []gemini.WorkerResult
	if err := json.Unmarshal(workersData, &workers); err != nil {
		log.Fatalf("❌ Parse phase2_all_results.json thất bại: %v", err)
	}
	fmt.Printf("👥 Đã nạp dữ liệu Worker: %d dạng toán\n\n", len(workers))

	ctx := context.Background()
	pool, err := gemini.NewKeyPool(ctx, keys)
	if err != nil {
		log.Fatalf("❌ Tạo KeyPool thất bại: %v", err)
	}

	repairModel := "gemini-3.5-flash-lite"
	fmt.Printf("⚡ Khởi tạo BatchRepairer dùng Model: \033[1;32m%s\033[0m\n", repairModel)

	llm := gemini.NewGeminiLLMProvider(pool, repairModel)
	compiler := gemini.NewCLITypstCompiler()
	assembler := gemini.NewDefaultDocumentAssembler()
	validator := gemini.NewDefaultMathValidator()
	repairer := gemini.NewDefaultBatchRepairer(llm, repairModel)

	qg := gemini.NewDefaultQualityGateStage(assembler, compiler, repairer, validator)

	outDir := filepath.Join("infrastructure2", "gemini", ".artifacts", "test_phase3_4_output")
	_ = os.MkdirAll(outDir, 0755)

	startTime := time.Now()
	output, err := qg.VerifyAndCompile(ctx, &plan, workers, outDir)
	if err != nil {
		log.Fatalf("❌ Phase 3 & 4 thất bại: %v", err)
	}

	elapsed := time.Since(startTime)
	fmt.Println("\n==================================================================")
	fmt.Println("🎉 PHASE 3 & 4 ĐÃ BIÊN DỊCH VÀ XUẤT BẢN THÀNH CÔNG RỰC RỠ!")
	fmt.Println("==================================================================")
	fmt.Printf("⏱️  Thời gian thực thi: %v\n", elapsed.Round(time.Millisecond))
	fmt.Printf("📘 File Giáo Viên: %s\n", output.TeacherPDFPath)
	fmt.Printf("📗 File Học Sinh:  %s\n", output.StudentPDFPath)

	if infoGV, err := os.Stat(output.TeacherPDFPath); err == nil {
		fmt.Printf("   ↳ Dung lượng Giáo Viên: %.2f KB\n", float64(infoGV.Size())/1024)
	}
	if infoHS, err := os.Stat(output.StudentPDFPath); err == nil {
		fmt.Printf("   ↳ Dung lượng Học Sinh:  %.2f KB\n", float64(infoHS.Size())/1024)
	}
	fmt.Println("==================================================================")
}
