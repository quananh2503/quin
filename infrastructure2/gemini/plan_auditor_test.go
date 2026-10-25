package gemini_test

import (
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestDefaultPlanAuditor_CleanPlan(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	plan := &gemini.LessonPlan{
		LessonTitle: "Bài 1: Vectơ không gian",
		Overview:    "Tổng quan",
		QuestionCatalog: []gemini.CatalogItem{
			{DocID: "DOC_1", TargetOutput: "Tính độ dài", CoreMethod: "Định nghĩa", QuestionIDs: []string{"C1", "C2"}},
		},
		Topics: []gemini.Topic{
			{
				TopicID:             "dang_1",
				Title:               "Dạng 1: Khái niệm",
				AssignedQuestionIDs: []string{"C1", "C2"},
			},
		},
	}

	report := auditor.Audit(plan)
	assert.False(t, report.NeedsRefinement, "Kế hoạch sạch sẽ không cần tinh chỉnh")
	assert.Empty(t, report.UnassignedIDs)
	assert.Empty(t, report.OverloadedTopics)
	assert.Empty(t, report.RedundantTopics)
}

func TestDefaultPlanAuditor_DetectsUnassignedCatalogQuestions(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	plan := &gemini.LessonPlan{
		LessonTitle: "Bài 1: Vectơ không gian",
		QuestionCatalog: []gemini.CatalogItem{
			{DocID: "DOC_1", TargetOutput: "Tính độ dài", CoreMethod: "Định nghĩa", QuestionIDs: []string{"C1", "C2", "C3"}},
		},
		Topics: []gemini.Topic{
			{
				TopicID:             "dang_1",
				Title:               "Dạng 1: Khái niệm",
				AssignedQuestionIDs: []string{"C1"},
			},
		},
	}

	report := auditor.Audit(plan)
	assert.True(t, report.NeedsRefinement)
	require.NotEmpty(t, report.UnassignedIDs)
	assert.Contains(t, report.UnassignedIDs[0], "C2")
}

func TestDefaultPlanAuditor_DetectsSequenceHoles(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	plan := &gemini.LessonPlan{
		LessonTitle: "Bài 1: Vectơ",
		Topics: []gemini.Topic{
			{
				TopicID:             "dang_1",
				Title:               "Dạng 1: Trắc nghiệm",
				AssignedQuestionIDs: []string{"C1", "C4"}, // Thiếu C2, C3
			},
		},
	}

	report := auditor.Audit(plan)
	assert.True(t, report.NeedsRefinement)
	assert.Contains(t, report.UnassignedIDs, "C2")
	assert.Contains(t, report.UnassignedIDs, "C3")
}

func TestDefaultPlanAuditor_DetectsOverloadedTopics(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	// Topic có 12 câu (> 10 câu)
	overloadedQuestions := []string{"C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "C12"}
	plan := &gemini.LessonPlan{
		Topics: []gemini.Topic{
			{
				TopicID:             "dang_1",
				Title:               "Dạng gom gộp",
				AssignedQuestionIDs: overloadedQuestions,
			},
		},
	}

	report := auditor.Audit(plan)
	assert.True(t, report.NeedsRefinement)
	require.Len(t, report.OverloadedTopics, 1)
	assert.Equal(t, "dang_1", report.OverloadedTopics[0].TopicID)
}

func TestDefaultPlanAuditor_DetectsRedundantTopics(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	plan := &gemini.LessonPlan{
		Topics: []gemini.Topic{
			{
				TopicID: "dang_1",
				Title:   "Phân tích vectơ theo 3 cạnh tứ diện",
			},
			{
				TopicID: "dang_2",
				Title:   "Phân tích vectơ theo 3 cạnh tứ diện", // Trùng tiêu đề
			},
		},
	}

	report := auditor.Audit(plan)
	assert.True(t, report.NeedsRefinement)
	require.Len(t, report.RedundantTopics, 1)
	assert.Equal(t, "dang_2", report.RedundantTopics[0].TopicID)
}

func TestDefaultPlanAuditor_NilOrEmptyPlan(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	reportNil := auditor.Audit(nil)
	assert.False(t, reportNil.NeedsRefinement)

	reportEmpty := auditor.Audit(&gemini.LessonPlan{})
	assert.False(t, reportEmpty.NeedsRefinement)
}

// =============================================================================
// BỔ SUNG CÁC TEST CASE CHO TIẾNG VIỆT, Ý CON VÀ BẢO VỆ CHỐNG NHẬN DIỆN NHẦM
// =============================================================================

func TestDefaultPlanAuditor_VietnameseAndSpaces(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	plan := &gemini.LessonPlan{
		LessonTitle: "Bài 1: Nguyên hàm",
		Topics: []gemini.Topic{
			{
				TopicID:             "dang_1",
				Title:               "Dạng 1: Cơ bản",
				AssignedQuestionIDs: []string{"Câu 1", "Câu 3."}, // Thiếu Câu 2
			},
		},
	}

	report := auditor.Audit(plan)
	assert.True(t, report.NeedsRefinement)
	assert.Contains(t, report.UnassignedIDs, "C2")
}

func TestDefaultPlanAuditor_SubItemsABCDEFGH(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	// Ví dụ có ý con a, b, c, d, e, f, g, h. Đề bài có VD1a và VD1d -> Thiếu VD1b, VD1c
	plan := &gemini.LessonPlan{
		LessonTitle: "Bài 1: Nguyên hàm",
		Topics: []gemini.Topic{
			{
				TopicID:             "dang_1",
				Title:               "Dạng 1: Ví dụ mẫu",
				AssignedQuestionIDs: []string{"VD1a", "VD 1d"}, // Thiếu VD1b, VD1c
			},
		},
	}

	report := auditor.Audit(plan)
	assert.True(t, report.NeedsRefinement)
	assert.Contains(t, report.UnassignedIDs, "VD1b")
	assert.Contains(t, report.UnassignedIDs, "VD1c")
}

func TestDefaultPlanAuditor_NumberSafetyGuards(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	// Nếu xuất hiện số năm "2024" hoặc số trang lớn "150" trơ trọi -> Hệ thống phải bỏ qua, KHÔNG sinh ra hàng nghìn câu rác
	plan := &gemini.LessonPlan{
		LessonTitle: "Bài 1: Khảo sát",
		QuestionCatalog: []gemini.CatalogItem{
			{DocID: "DOC_1", QuestionIDs: []string{"2024", "150"}},
		},
		Topics: []gemini.Topic{
			{
				TopicID:             "dang_1",
				Title:               "Dạng 1",
				AssignedQuestionIDs: []string{"C1", "C2"},
			},
		},
	}

	report := auditor.Audit(plan)
	// Chỉ có số 2024, 150 không được coi là câu hỏi hợp lệ -> không báo thiếu Q1..Q2024
	for _, unassigned := range report.UnassignedIDs {
		assert.NotContains(t, unassigned, "Q2")
		assert.NotContains(t, unassigned, "Q1000")
	}
}

// =============================================================================
// TEST SUITE TOÀN DIỆN CHO ParseQuestionID (CÓ DẤU, KHÔNG DẤU, VIẾT TẮT, LA MÃ)
// =============================================================================

func TestParseQuestionID_VietnameseWithAccents(t *testing.T) {
	tests := []struct {
		input      string
		wantPrefix string
		wantNum    int
		wantSub    string
		wantNorm   string
	}{
		// Câu hỏi trắc nghiệm / câu hỏi chung
		{"Câu 1", "C", 1, "", "C1"},
		{"Câu 12", "C", 12, "", "C12"},
		{"Câu 50", "C", 50, "", "C50"},
		{"CÂU 9", "C", 9, "", "C9"},
		{"Câu hỏi 3", "C", 3, "", "C3"},
		{"Trắc nghiệm 1", "C", 1, "", "C1"},
		{"TRẮC NGHIỆM 8", "C", 8, "", "C8"},

		// Bài tập / Tự luận
		{"Bài 1", "B", 1, "", "B1"},
		{"Bài 25", "B", 25, "", "B25"},
		{"BÀI 4", "B", 4, "", "B4"},
		{"Bài tập 3", "B", 3, "", "B3"},
		{"BÀI TẬP 10", "B", 10, "", "B10"},
		{"Tự luận 2", "B", 2, "", "B2"},
		{"TỰ LUẬN 6", "B", 6, "", "B6"},

		// Ví dụ
		{"Ví dụ 1", "VD", 1, "", "VD1"},
		{"Ví dụ 15", "VD", 15, "", "VD15"},
		{"VÍ DỤ 2", "VD", 2, "", "VD2"},
		{"Ví dụ mẫu 3", "VD", 3, "", "VD3"},
		{"Vd 4", "VD", 4, "", "VD4"},

		// Đúng sai
		{"Đúng sai 1", "D", 1, "", "D1"},
		{"ĐÚNG SAI 2", "D", 2, "", "D2"},
		{"Đúng - sai 3", "D", 3, "", "D3"},
		{"Đúng / Sai 4", "D", 4, "", "D4"},
		{"ĐS 5", "D", 5, "", "D5"},
		{"Đ/S 6", "D", 6, "", "D6"},
	}

	for _, tc := range tests {
		t.Run(tc.input, func(t *testing.T) {
			p := gemini.ParseQuestionID(tc.input)
			require.NotNil(t, p, "Phải nhận diện được: %s", tc.input)
			assert.Equal(t, tc.wantPrefix, p.Prefix)
			assert.Equal(t, tc.wantNum, p.MainNum)
			assert.Equal(t, tc.wantSub, p.SubLetter)
			assert.Equal(t, tc.wantNorm, p.Normalized)
		})
	}
}

func TestParseQuestionID_VietnameseNoAccents(t *testing.T) {
	tests := []struct {
		input    string
		wantNorm string
	}{
		{"Cau 1", "C1"},
		{"Cau 20", "C20"},
		{"cau 5", "C5"},
		{"Trac nghiem 3", "C3"},
		{"Bai 1", "B1"},
		{"Bai tap 4", "B4"},
		{"Tu luan 2", "B2"},
		{"Vi du 1", "VD1"},
		{"Vi du mau 5", "VD5"},
		{"Dung sai 1", "D1"},
		{"Dung - sai 2", "D2"},
		{"Dung / Sai 3", "D3"},
		{"DS 4", "D4"},
	}

	for _, tc := range tests {
		t.Run(tc.input, func(t *testing.T) {
			p := gemini.ParseQuestionID(tc.input)
			require.NotNil(t, p, "Phải nhận diện được không dấu: %s", tc.input)
			assert.Equal(t, tc.wantNorm, p.Normalized)
		})
	}
}

func TestParseQuestionID_Abbreviations(t *testing.T) {
	tests := []struct {
		input    string
		wantNorm string
	}{
		// Viết tắt Câu
		{"C1", "C1"},
		{"c1", "C1"},
		{"C.1", "C1"},
		{"C-1", "C1"},
		{"C_1", "C1"},
		{"C 12", "C12"},
		{"TN1", "C1"},
		{"tn 4", "C4"},

		// Viết tắt Bài
		{"B1", "B1"},
		{"b1", "B1"},
		{"B.2", "B2"},
		{"B-3", "B3"},
		{"BT1", "B1"},
		{"BT 2", "B2"},
		{"BT.3", "B3"},
		{"BT-4", "B4"},
		{"TL1", "B1"},
		{"tl 5", "B5"},

		// Viết tắt Ví dụ
		{"VD1", "VD1"},
		{"vd1", "VD1"},
		{"VD 2", "VD2"},
		{"VD.3", "VD3"},
		{"VD-4", "VD4"},

		// Viết tắt Đúng sai
		{"D1", "D1"},
		{"d1", "D1"},
		{"DS1", "D1"},
		{"ds 2", "D2"},
		{"D.3", "D3"},
		{"D-4", "D4"},

		// Tiếng Anh / Giáo trình
		{"E1", "E1"},
		{"Ex 2", "E2"},
		{"Exercise 3", "E3"},
		{"P1", "P1"},
		{"Prob 2", "P2"},
		{"Problem 3", "P3"},
	}

	for _, tc := range tests {
		t.Run(tc.input, func(t *testing.T) {
			p := gemini.ParseQuestionID(tc.input)
			require.NotNil(t, p, "Phải nhận diện được viết tắt: %s", tc.input)
			assert.Equal(t, tc.wantNorm, p.Normalized)
		})
	}
}

func TestParseQuestionID_RomanNumerals(t *testing.T) {
	tests := []struct {
		input      string
		wantPrefix string
		wantNum    int
		wantNorm   string
	}{
		// Số La Mã với Câu (I đến XX)
		{"Câu I", "C", 1, "C1"},
		{"Câu II", "C", 2, "C2"},
		{"Câu III", "C", 3, "C3"},
		{"Câu IV", "C", 4, "C4"},
		{"Câu V", "C", 5, "C5"},
		{"Câu VI", "C", 6, "C6"},
		{"Câu VII", "C", 7, "C7"},
		{"Câu VIII", "C", 8, "C8"},
		{"Câu IX", "C", 9, "C9"},
		{"Câu X", "C", 10, "C10"},
		{"Câu XI", "C", 11, "C11"},
		{"Câu XII", "C", 12, "C12"},
		{"Câu XV", "C", 15, "C15"},
		{"Câu XX", "C", 20, "C20"},

		// Chữ thường
		{"câu i", "C", 1, "C1"},
		{"câu ii", "C", 2, "C2"},
		{"câu iv", "C", 4, "C4"},
		{"câu x", "C", 10, "C10"},

		// Không dấu
		{"Cau I", "C", 1, "C1"},
		{"Bai II", "B", 2, "B2"},
		{"Vi du III", "VD", 3, "VD3"},
		{"VD IV", "VD", 4, "VD4"},

		// Tiền tố khác với số La Mã
		{"Bài I", "B", 1, "B1"},
		{"Bài II", "B", 2, "B2"},
		{"Bài tập III", "B", 3, "B3"},
		{"Ví dụ IV", "VD", 4, "VD4"},
		{"VD V", "VD", 5, "VD5"},
		{"Tự luận I", "B", 1, "B1"},

		// Viết tắt với số La Mã
		{"C.I", "C", 1, "C1"},
		{"C-II", "C", 2, "C2"},
		{"C_III", "C", 3, "C3"},
		{"VD.IV", "VD", 4, "VD4"},
		{"B.V", "B", 5, "B5"},

		// Số La Mã đứng đơn độc (bare Roman)
		{"I", "Q", 1, "Q1"},
		{"II", "Q", 2, "Q2"},
		{"III", "Q", 3, "Q3"},
		{"IV", "Q", 4, "Q4"},
		{"V", "Q", 5, "Q5"},
		{"X", "Q", 10, "Q10"},
	}

	for _, tc := range tests {
		t.Run(tc.input, func(t *testing.T) {
			p := gemini.ParseQuestionID(tc.input)
			require.NotNil(t, p, "Phải nhận diện được số La Mã: %s", tc.input)
			assert.Equal(t, tc.wantPrefix, p.Prefix)
			assert.Equal(t, tc.wantNum, p.MainNum)
			assert.Equal(t, tc.wantNorm, p.Normalized)
		})
	}
}

func TestParseQuestionID_SubLetters(t *testing.T) {
	tests := []struct {
		input      string
		wantPrefix string
		wantNum    int
		wantSub    string
		wantNorm   string
	}{
		// Dính liền số Ả Rập
		{"Câu 1a", "C", 1, "a", "C1a"},
		{"Câu 1b", "C", 1, "b", "C1b"},
		{"Câu 1c", "C", 1, "c", "C1c"},
		{"Câu 1d", "C", 1, "d", "C1d"},
		{"VD1a", "VD", 1, "a", "VD1a"},
		{"VD 1b", "VD", 1, "b", "VD1b"},
		{"Bài 2c", "B", 2, "c", "B2c"},
		{"D1a", "D", 1, "a", "D1a"},
		{"ĐS 1b", "D", 1, "b", "D1b"},
		{"c1a", "C", 1, "a", "C1a"},

		// Ý con chữ hoa -> chuẩn hóa thành chữ thường
		{"Câu 1A", "C", 1, "a", "C1a"},
		{"Câu 1B", "C", 1, "b", "C1b"},
		{"VD 2C", "VD", 2, "c", "VD2c"},
		{"D 3D", "D", 3, "d", "D3d"},

		// Ký tự phân cách (chấm, gạch nối, gạch dưới)
		{"Câu 1.a", "C", 1, "a", "C1a"},
		{"Câu 1-b", "C", 1, "b", "C1b"},
		{"Câu 1_c", "C", 1, "c", "C1c"},
		{"VD 2.d", "VD", 2, "d", "VD2d"},
		{"Bài 3-a", "B", 3, "a", "B3a"},

		// Trong dấu ngoặc đơn / vuông
		{"Câu 1 (a)", "C", 1, "a", "C1a"},
		{"Câu 1 [b]", "C", 1, "b", "C1b"},
		{"Câu 1 (c)", "C", 1, "c", "C1c"},
		{"(Câu 1a)", "C", 1, "a", "C1a"},
		{"[VD 2b]", "VD", 2, "b", "VD2b"},
		{"1a", "Q", 1, "a", "Q1a"},
		{"(1a)", "Q", 1, "a", "Q1a"},
		{"1 (b)", "Q", 1, "b", "Q1b"},

		// Có từ phụ: "ý", "phần", "mục"
		{"Câu 1 ý a", "C", 1, "a", "C1a"},
		{"Câu 1 ý b", "C", 1, "b", "C1b"},
		{"Câu 1 Ý c", "C", 1, "c", "C1c"},
		{"Câu 1 y d", "C", 1, "d", "C1d"},
		{"Bài 2 ý a", "B", 2, "a", "B2a"},
		{"Ví dụ 3 ý b", "VD", 3, "b", "VD3b"},
		{"Câu 1 phần a", "C", 1, "a", "C1a"},
		{"Câu 1 mục b", "C", 1, "b", "C1b"},

		// Số La Mã kèm ý con
		{"Câu Ia", "C", 1, "a", "C1a"},
		{"Câu I.a", "C", 1, "a", "C1a"},
		{"Câu I (a)", "C", 1, "a", "C1a"},
		{"Câu I ý a", "C", 1, "a", "C1a"},
		{"Câu IIb", "C", 2, "b", "C2b"},
		{"Câu II (b)", "C", 2, "b", "C2b"},
		{"VD IVa", "VD", 4, "a", "VD4a"},
		{"VD IV-c", "VD", 4, "c", "VD4c"},
		{"Bài III ý a", "B", 3, "a", "B3a"},
		{"Ia", "Q", 1, "a", "Q1a"},
		{"II (b)", "Q", 2, "b", "Q2b"},
	}

	for _, tc := range tests {
		t.Run(tc.input, func(t *testing.T) {
			p := gemini.ParseQuestionID(tc.input)
			require.NotNil(t, p, "Phải nhận diện được ý con: %s", tc.input)
			assert.Equal(t, tc.wantPrefix, p.Prefix)
			assert.Equal(t, tc.wantNum, p.MainNum)
			assert.Equal(t, tc.wantSub, p.SubLetter)
			assert.Equal(t, tc.wantNorm, p.Normalized)
		})
	}
}

func TestParseQuestionID_BareNumbersAndSafetyRejections(t *testing.T) {
	// 1. Số thuần túy hợp lệ (1 <= n <= 100)
	validBare := []struct {
		input    string
		wantNorm string
	}{
		{"1", "Q1"},
		{"2", "Q2"},
		{"10", "Q10"},
		{"50", "Q50"},
		{"100", "Q100"},
		{"(1)", "Q1"},
		{"[2]", "Q2"},
		{"{3}", "Q3"},
	}

	for _, tc := range validBare {
		t.Run("ValidBare_"+tc.input, func(t *testing.T) {
			p := gemini.ParseQuestionID(tc.input)
			require.NotNil(t, p, "Số thuần túy hợp lệ phải nhận diện được: %s", tc.input)
			assert.Equal(t, tc.wantNorm, p.Normalized)
		})
	}

	// 2. Các chuỗi BẮT BUỘC PHẢI BỊ LOẠI BỎ (nil) - Tránh nhận diện nhầm
	invalidCases := []string{
		// Số thuần túy vượt ngưỡng (năm học, số trang)
		"2024", "2025", "1999", "150", "101", "500", "1000",
		"0", "-1", "-5",

		// Từ khóa không phải câu hỏi (trang sách, năm học, hình vẽ...)
		"Trang 15", "trang 20", "Page 22",
		"Năm 2024", "Nam 2023", "Year 2025",
		"Tháng 5", "Ngày 10",
		"Lớp 12", "lop 11", "Grade 10",
		"Tập 1", "tap 2", "Vol 3",
		"Hình 1", "Hinh 2", "Fig 3",
		"Bảng 1", "Bang 2", "Table 3",
		"Chương 1", "Chuong 2", "Chapter 3",
		"Tiết 1", "tiet 4",

		// Chuỗi rác / văn bản chung không có số
		"", "   ", "Câu", "Bài", "Ví dụ", "abcxyz",
		"Toán học 12", "Phân tích vectơ",
	}

	for _, input := range invalidCases {
		t.Run("Rejected_"+input, func(t *testing.T) {
			p := gemini.ParseQuestionID(input)
			assert.Nil(t, p, "Chuỗi này KHÔNG ĐƯỢC coi là câu hỏi: %q", input)
		})
	}
}

func TestDefaultPlanAuditor_ExhaustiveIntegration(t *testing.T) {
	auditor := gemini.NewDefaultPlanAuditor()

	// 1. Tích hợp số La Mã: Topic có "Câu I", "Câu II", "C4" -> Phải phát hiện thiếu "C3"
	t.Run("RomanHoleDetection", func(t *testing.T) {
		plan := &gemini.LessonPlan{
			LessonTitle: "Bài 1: Khảo sát hàm số",
			Topics: []gemini.Topic{
				{
					TopicID:             "dang_1",
					Title:               "Dạng 1",
					AssignedQuestionIDs: []string{"Câu I", "Câu II", "C4"}, // Thiếu C3 (Câu III)
				},
			},
		}
		report := auditor.Audit(plan)
		assert.True(t, report.NeedsRefinement)
		assert.Contains(t, report.UnassignedIDs, "C3")
	})

	// 2. Tích hợp ý con số La Mã: "Câu Ia", "Câu Id" -> Phải phát hiện thiếu "C1b", "C1c"
	t.Run("RomanSubItemHoleDetection", func(t *testing.T) {
		plan := &gemini.LessonPlan{
			LessonTitle: "Bài 1: Khảo sát hàm số",
			Topics: []gemini.Topic{
				{
					TopicID:             "dang_1",
					Title:               "Dạng 1",
					AssignedQuestionIDs: []string{"Câu Ia", "Câu Id"},
				},
			},
		}
		report := auditor.Audit(plan)
		assert.True(t, report.NeedsRefinement)
		assert.Contains(t, report.UnassignedIDs, "C1b")
		assert.Contains(t, report.UnassignedIDs, "C1c")
	})

	// 3. Tích hợp Đúng/Sai 4 ý (a, b, c, d) với nhiều format hỗn hợp
	t.Run("TrueFalseMultiFormatHoleDetection", func(t *testing.T) {
		plan := &gemini.LessonPlan{
			LessonTitle: "Bài 1: Trắc nghiệm đúng sai",
			Topics: []gemini.Topic{
				{
					TopicID:             "dang_1",
					Title:               "Dạng Đúng Sai",
					AssignedQuestionIDs: []string{"Đúng sai 1a", "D1b", "Đúng - Sai 1 (d)"}, // Thiếu D1c
				},
			},
		}
		report := auditor.Audit(plan)
		assert.True(t, report.NeedsRefinement)
		assert.Contains(t, report.UnassignedIDs, "D1c")
	})

	// 4. Tích hợp Bài tập tự luận hỗn hợp
	t.Run("EssayMultiFormatHoleDetection", func(t *testing.T) {
		plan := &gemini.LessonPlan{
			LessonTitle: "Bài 1: Tự luận",
			Topics: []gemini.Topic{
				{
					TopicID:             "dang_1",
					Title:               "Dạng Tự luận",
					AssignedQuestionIDs: []string{"Bài 1", "Bài tập 3", "TL 4"}, // Thiếu B2
				},
			},
		}
		report := auditor.Audit(plan)
		assert.True(t, report.NeedsRefinement)
		assert.Contains(t, report.UnassignedIDs, "B2")
	})
}
