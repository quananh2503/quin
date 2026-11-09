package pipeline_test

import (
	"testing"

	"meet-attendance-clean/infrastructure2/AI/pipeline"
)

func TestSanitizeRawJSONLaTeX(t *testing.T) {
	// 1. Kiểm tra lột bỏ markdown fence
	fenced := "```json\n{\"test\": \"ok\"}\n```"
	clean := pipeline.SanitizeRawJSONLaTeX(fenced)
	if clean != `{"test": "ok"}` {
		t.Errorf("SanitizeRawJSONLaTeX không cắt bỏ fence: %s", clean)
	}

	// 2. Kiểm tra escape các lệnh LaTeX như \frac, \vec
	latexInput := `{"formula": "\frac{1}{2} + \vec{AB}"}`
	sanitized := pipeline.SanitizeRawJSONLaTeX(latexInput)
	expected := `{"formula": "\\frac{1}{2} + \\vec{AB}"}`
	if sanitized != expected {
		t.Errorf("SanitizeRawJSONLaTeX escape sai: Got %s, Want %s", sanitized, expected)
	}

	// 3. Kiểm tra sửa lỗi ASCII control character (\x0Dightarrow)
	controlInput := "{\"arrow\": \"\x0Dightarrow\"}"
	sanitizedArrow := pipeline.SanitizeRawJSONLaTeX(controlInput)
	if sanitizedArrow != `{"arrow": "\\rightarrow"}` {
		t.Errorf("SanitizeRawJSONLaTeX sửa ASCII control char sai: %s", sanitizedArrow)
	}
}

func TestRepairTruncatedJSON(t *testing.T) {
	// 1. Kiểm tra tự đóng ngoặc nhọn
	truncated := `{"topics": [{"id": "1"`
	repaired := pipeline.RepairTruncatedJSON(truncated)
	if repaired != `{"topics": [{"id": "1"}]}` {
		t.Errorf("RepairTruncatedJSON đóng ngoặc sai: %s", repaired)
	}

	// 2. Chuỗi rỗng
	if pipeline.RepairTruncatedJSON("") != "{}" {
		t.Errorf("RepairTruncatedJSON với chuỗi rỗng phải trả về {}")
	}
}
