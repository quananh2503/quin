package pipeline_test

import (
	"context"
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/AI"
	"meet-attendance-clean/infrastructure2/AI/pipeline"
)

const mockTopicJSON = `{
  "topic_id": "T1",
  "title": "Khái niệm vectơ trong không gian",
  "difficulty": "Nhận biết",
  "theory_points": [
    "Vectơ trong không gian là một đoạn thẳng có hướng.",
    "Hai vectơ bằng nhau nếu chúng cùng hướng và cùng độ dài."
  ],
  "cloze_formula": "$|\\overrightarrow{AB}| = ...$",
  "callout_tip": "Vectơ đối là vectơ ngược hướng và cùng độ dài.",
  "variants": [
    {
      "variant_id": "V1",
      "variant_name": "Nhận biết vectơ và tính độ dài",
      "recognition": "Đề bài cho hình khối và yêu cầu xác định vectơ hoặc độ dài",
      "action_steps": [
        "Bước 1: Xác định điểm đầu và điểm cuối của vectơ.",
        "Bước 2: Áp dụng công thức tính độ dài đoạn thẳng tương ứng."
      ],
      "quick_tip": "Nhìn nhanh: Các cạnh song song và bằng nhau tạo ra các vectơ bằng nhau.",
      "example": {
        "title": "Ví dụ 1 (SGK)",
        "problem": "Cho hình lập phương $ABCD.A'B'C'$ cạnh $1$. Tính $|\\overrightarrow{AB}|$.",
        "solution": "Bước 1: Điểm đầu là $A$, ngọn là $B$.\nBước 2: Độ dài $|\\overrightarrow{AB}| = AB = 1$."
      },
      "drills": [
        {
          "title": "Bài 1.1",
          "level": "TuongTu100",
          "prompt": "Cho hình lập phương cạnh $2$. Tính $|\\overrightarrow{AD}|$.",
          "solution": "Độ dài $|\\overrightarrow{AD}| = AD = 2$.",
          "answer": "2"
        }
      ]
    }
  ],
  "answer_key": [
    {
      "drill_id": "Bài 1.1",
      "short_guide": "Độ dài cạnh hình lập phương",
      "final_answer": "2"
    }
  ]
}`

func TestDefaultGenerator_GenerateTopicJSON_Success(t *testing.T) {
	mockProv := &mockAIProvider{
		responseContent: mockTopicJSON,
	}

	generator := pipeline.NewGenerator(mockProv, "deepseek-flash", 2)

	topic := pipeline.TopicPlan{
		TopicID:             "T1",
		Title:               "Khái niệm vectơ trong không gian",
		Difficulty:          "Nhận biết",
		TargetOutput:        "Nhận diện vectơ",
		CoreConcept:         "Định nghĩa vectơ",
		AssignedQuestionIDs: []string{"DOC1_B1_HD1", "DOC1_B1_VD1"},
	}

	plan := &pipeline.LessonPlan{
		LessonTitle: "Chuyên đề Vectơ",
		Inventory: pipeline.DocumentInventory{
			TotalItems: 2,
			Items: []pipeline.InventoryItem{
				{ID: "DOC1_B1_HD1", SourceName: "SGK", SourceLabel: "HĐ 1", ItemType: "hoat_dong", Snippet: "Vectơ lực"},
				{ID: "DOC1_B1_VD1", SourceName: "SGK", SourceLabel: "VD 1", ItemType: "vi_du", Snippet: "Tứ diện đều"},
			},
		},
		Topics: []pipeline.TopicPlan{topic},
	}

	docs := []ai.Document{
		ai.NewDocument("DOC1", "test.pdf", ai.NewTextPart("test")),
	}

	tc, resp, err := generator.GenerateTopicJSON(context.Background(), topic, docs, plan, "Dành cho học sinh mất gốc")
	if err != nil {
		t.Fatalf("GenerateTopicJSON thất bại: %v", err)
	}
	if resp == nil {
		t.Fatal("Response nil")
	}
	if tc == nil {
		t.Fatal("TopicContent nil")
	}
	if tc.TopicID != "T1" {
		t.Errorf("Kỳ vọng TopicID T1, nhận: %s", tc.TopicID)
	}
	if len(tc.Variants) == 0 {
		t.Fatal("Variants rỗng")
	}
	if len(tc.Variants[0].ActionSteps) != 2 {
		t.Errorf("Kỳ vọng 2 action steps, nhận: %d", len(tc.Variants[0].ActionSteps))
	}
	if !strings.Contains(tc.TypstContent, "DẠNG TOÁN [T1]") {
		t.Errorf("TypstContent không chứa tiêu đề dạng toán: %s", tc.TypstContent)
	}
}

func TestDefaultGenerator_GenerateTopic_Success(t *testing.T) {
	mockProv := &mockAIProvider{
		responseContent: mockTopicJSON,
	}

	generator := pipeline.NewGenerator(mockProv, "deepseek-flash", 2)
	topic := pipeline.TopicPlan{
		TopicID: "T1",
		Title:   "Khái niệm vectơ",
	}

	tc, err := generator.GenerateTopic(context.Background(), topic, nil, nil, "")
	if err != nil {
		t.Fatalf("GenerateTopic thất bại: %v", err)
	}
	if tc.TopicID != "T1" {
		t.Errorf("Kỳ vọng TopicID T1, nhận được: %s", tc.TopicID)
	}
	if len(tc.TypstContent) == 0 {
		t.Errorf("TypstContent rỗng")
	}
}

func TestDefaultGenerator_GenerateAll_Success(t *testing.T) {
	mockProv := &mockAIProvider{
		responseContent: mockTopicJSON,
	}

	generator := pipeline.NewGenerator(mockProv, "deepseek-flash", 2)
	plan := &pipeline.LessonPlan{
		Topics: []pipeline.TopicPlan{
			{TopicID: "T1", Title: "Dạng 1"},
			{TopicID: "T2", Title: "Dạng 2"},
		},
	}

	results, err := generator.GenerateAll(context.Background(), plan, nil, "", 2)
	if err != nil {
		t.Fatalf("GenerateAll thất bại: %v", err)
	}
	if len(results) != 2 {
		t.Fatalf("Kỳ vọng 2 kết quả, nhận: %d", len(results))
	}
}

func TestDefaultGenerator_GenerateTopic_NilProvider(t *testing.T) {
	generator := pipeline.NewGenerator(nil, "deepseek-flash", 2)
	_, err := generator.GenerateTopic(context.Background(), pipeline.TopicPlan{TopicID: "T1"}, nil, nil, "")
	if err == nil {
		t.Fatal("Kỳ vọng lỗi khi provider nil")
	}
}

func TestDefaultGenerator_GenerateAll_NilPlan(t *testing.T) {
	mockProv := &mockAIProvider{responseContent: mockTopicJSON}
	generator := pipeline.NewGenerator(mockProv, "deepseek-flash", 2)
	_, err := generator.GenerateAll(context.Background(), nil, nil, "", 2)
	if err == nil {
		t.Fatal("Kỳ vọng lỗi khi plan nil")
	}
}

func TestDefaultGenerator_VariantNameFallback(t *testing.T) {
	jsonWithoutVariantName := `{
		"topic_id": "T1",
		"title": "Dạng 1",
		"variants": [
			{
				"variant_id": "V1",
				"variant_name": "",
				"recognition": "Đề cho hình vẽ"
			}
		]
	}`

	mockProv := &mockAIProvider{responseContent: jsonWithoutVariantName}
	generator := pipeline.NewGenerator(mockProv, "deepseek-flash", 1)

	topic := pipeline.TopicPlan{
		TopicID:  "T1",
		Title:    "Dạng 1",
		Variants: []string{"Xác định điểm thỏa mãn đẳng thức"},
	}

	tc, _, err := generator.GenerateTopicJSON(context.Background(), topic, nil, nil, "")
	if err != nil {
		t.Fatalf("GenerateTopicJSON thất bại: %v", err)
	}
	if len(tc.Variants) == 0 {
		t.Fatal("Variants rỗng")
	}
	if tc.Variants[0].VariantName != "Xác định điểm thỏa mãn đẳng thức" {
		t.Errorf("Kỳ vọng fallback tên biến thể từ topic.Variants, nhận: %s", tc.Variants[0].VariantName)
	}
}
