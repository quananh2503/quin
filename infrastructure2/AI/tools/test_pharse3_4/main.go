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

	"meet-attendance-clean/infrastructure2/AI/deepseek"
	"meet-attendance-clean/infrastructure2/AI/pipeline"
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
	fmt.Println("🚀 RUNNER KIỂM THỬ GIAI ĐOẠN 3 & 4 (TÌM LỖI & TỰ ĐỘNG SỬA LỖI)")
	fmt.Println("==================================================================")

	apiKey := strings.TrimSpace(os.Getenv("DEEPSEEK_API_KEY"))
	if apiKey == "" {
		apiKey = "sk-05b5e7c6b375480e96cf71e1cc4d7107"
	}
	modelName := "deepseek-flash"

	caseFolder := "case1"
	targetTopicID := "T1"
	simulateErrors := false

	var positional []string
	for _, arg := range os.Args[1:] {
		if arg == "--simulate-error" || arg == "--inject-error" {
			simulateErrors = true
		} else if !strings.HasPrefix(arg, "--") {
			positional = append(positional, arg)
		}
	}

	if len(positional) > 0 {
		caseFolder = positional[0]
	}
	if len(positional) > 1 {
		targetTopicID = positional[1]
	}

	targetDir := caseFolder
	if !filepath.IsAbs(targetDir) && !strings.Contains(targetDir, "test_pharse1") {
		targetDir = filepath.Join("infrastructure2", "AI", "tools", "test_pharse1", caseFolder)
	}

	fmt.Printf("📂 Thư mục: %s\n", targetDir)
	fmt.Printf("🎯 Dạng toán: %s\n", targetTopicID)
	if simulateErrors {
		fmt.Println("🧪 Chế độ: GIẢ LẬP TIÊM LỖI CÚ PHÁP (Kiểm chứng khả năng tự hồi phục)")
	} else {
		fmt.Println("🔍 Chế độ: KIỂM TOÁN VÀ BIÊN DỊCH BẢN CHUẨN")
	}

	// 1. Đọc Topic Content JSON
	jsonPath := filepath.Join(targetDir, fmt.Sprintf("topic_%s_content.json", targetTopicID))
	data, errRead := os.ReadFile(jsonPath)
	if errRead != nil {
		log.Fatalf("❌ Không tìm thấy file %s: %v", jsonPath, errRead)
	}

	var tc pipeline.TopicContent
	if errUnmarshal := json.Unmarshal(data, &tc); errUnmarshal != nil {
		log.Fatalf("❌ Giải mã JSON thất bại: %v", errUnmarshal)
	}

	// 2. Nếu ở chế độ giả lập lỗi: Tiêm các lỗi cú pháp kinh điển của LLM
	if simulateErrors {
		fmt.Println("\n💉 ĐANG TIÊM 3 LỖI CÚ PHÁP ĐẶC TRƯNG CỦA LLM VÀO DỮ LIỆU:")
		// Lỗi 1: Lệnh LaTeX trần không kẹp dấu $
		tc.TheoryPoints[0] = "Vectơ trong không gian là đoạn thẳng có hướng \\vec{AB} với điểm đầu và cuối."
		fmt.Printf("   [Lỗi 1 - Theory]: Đã tiêm lệnh LaTeX trần '\\vec{AB}' ngoài dấu $\n")

		// Lỗi 2: Dấu $ bị lẻ (thiếu đóng mở công thức)
		tc.Variants[0].QuickTip = "Mẹo phản xạ: Nếu gặp hình hộp $ABCD.A'B'C' thì áp dụng quy tắc đường chéo."
		fmt.Printf("   [Lỗi 2 - QuickTip]: Đã tiêm dấu $ bị lẻ (chưa đóng công thức)\n")

		// Lỗi 3: Biến thể lệnh lạ và dính ký tự # chưa escape
		tc.Variants[0].ActionSteps[0] = "Bước #1: Chuẩn hoá các vectơ lạ \\vecvec{u} và \\overline{BC} về dạng cơ sở."
		fmt.Printf("   [Lỗi 3 - ActionStep]: Đã tiêm '\\vecvec{u}', '\\overline{BC}' và ký tự '#1'\n")
	}

	// 3. GIAI ĐOẠN 3: PRE-AUDIT TOÁN HỌC (TÌM LỖI TRONG RAM)
	fmt.Println("\n==================================================================")
	fmt.Println("🔍 [GIAI ĐOẠN 3: TÌM LỖI] THẨM ĐỊNH TĨNH VÀ TRÍCH XUẤT LỖI (PRE-AUDIT)")
	fmt.Println("==================================================================")

	auditTasks := pipeline.AuditTopicContent(&tc)
	if len(auditTasks) == 0 {
		fmt.Println("✅ Kết quả Pre-Audit: 100% Cú pháp chuẩn, không có lỗi tiềm ẩn.")
	} else {
		fmt.Printf("⚠️ PHÁT HIỆN %d VỊ TRÍ LỖI CÚ PHÁP CẦN SỬA:\n", len(auditTasks))
		for idx, task := range auditTasks {
			fmt.Printf("   [%d] Mã Anchor: %-22s\n", idx+1, task.TargetID)
			fmt.Printf("       ↳ Nguyên nhân: %s\n", task.ErrorReason)
			fmt.Printf("       ↳ Đoạn lỗi:   %q\n", task.BrokenSnippet)
		}
	}

	// 4. GIAI ĐOẠN 4: SỬA LỖI (BATCH REPAIRER HOẶC FALLBACK)
	fmt.Println("\n==================================================================")
	fmt.Println("🩹 [GIAI ĐOẠN 4: SỬA LỖI] TIẾN HÀNH SỬA LỖI VÀ TỰ HỒI PHỤC")
	fmt.Println("==================================================================")

	dsProvider := deepseek.NewProvider(apiKey, modelName)
	repairer := pipeline.NewRepairer(dsProvider, modelName)

	if len(auditTasks) > 0 {
		fmt.Printf("🤖 Đang kích hoạt Repairer xử lý %d mục lỗi...\n", len(auditTasks))
		repairedTasks, errRep := repairer.RepairMath(ctx, auditTasks)
		if errRep != nil {
			fmt.Printf("⚠️ RepairMath AI báo lỗi (%v), chuyển sang Deterministic Regex Fallback\n", errRep)
		} else {
			fmt.Println("✅ KẾT QUẢ ĐỐI CHIẾU TRƯỚC VÀ SAU KHI SỬA:")
			for idx, task := range repairedTasks {
				pipeline.SetContextField(&tc, task.TargetID, task.FixedContent)
				fmt.Printf("   [%d] Anchor: %s\n", idx+1, task.TargetID)
				fmt.Printf("       - Trước sửa: %s\n", task.Content)
				fmt.Printf("       + Sau sửa:   %s\n", task.FixedContent)
			}
		}
	}

	// 5. GIAI ĐOẠN 4 (TIẾP THEO): BIÊN DỊCH VÀ KIỂM TRA COMPILER DIAGNOSTICS
	fmt.Println("\n==================================================================")
	fmt.Println("🔨 [GIAI ĐOẠN 4: BIÊN DỊCH] SELF-HEALING COMPILE SANG TYPST & PDF")
	fmt.Println("==================================================================")

	typstCLI := resolveTypstCLI()
	outTypPath := filepath.Join(targetDir, fmt.Sprintf("topic_%s_healed.typ", targetTopicID))
	teacherPDF := filepath.Join(targetDir, fmt.Sprintf("topic_%s_teacher_healed.pdf", targetTopicID))
	studentPDF := filepath.Join(targetDir, fmt.Sprintf("topic_%s_student_healed.pdf", targetTopicID))

	t0T := time.Now()
	errTeacher := repairer.SelfHealCompile(ctx, &tc, typstCLI, outTypPath, teacherPDF, true, 3)
	if errTeacher != nil {
		fmt.Printf("❌ Lỗi biên dịch Giáo viên: %v\n", errTeacher)
	} else {
		fmt.Printf("   ✅ Bản Giáo viên (Teacher PDF): %s (trong %v)\n", teacherPDF, time.Since(t0T))
	}

	t0S := time.Now()
	errStudent := repairer.SelfHealCompile(ctx, &tc, typstCLI, outTypPath, studentPDF, false, 3)
	if errStudent != nil {
		fmt.Printf("❌ Lỗi biên dịch Học sinh: %v\n", errStudent)
	} else {
		fmt.Printf("   ✅ Bản Học sinh (Student PDF):   %s (trong %v)\n", studentPDF, time.Since(t0S))
	}

	fmt.Println("\n==================================================================")
	fmt.Println("🎉 HOÀN THÀNH KIỂM CHỨNG GIAI ĐOẠN 3 & 4!")
	fmt.Println("==================================================================")
}
