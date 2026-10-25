package gemini_test

import (
	"strings"
	"testing"

	"meet-attendance-clean/infrastructure2/gemini"

	"github.com/stretchr/testify/assert"
)

func TestLaTeXToMiTeX_SanitizeHTMLBr(t *testing.T) {
	input := "Ta có: $AB = 5$.<br/>BC = 3.<br>CA = 2.<br />Chu vi là: $P = 10$."
	output := gemini.LaTeXToMiTeX(input)

	assert.False(t, strings.Contains(output, "<br"), "LaTeXToMiTeX phải loại bỏ hoàn toàn các thẻ html <br>, <br/>: %s", output)
	assert.True(t, strings.Contains(output, `\`), "LaTeXToMiTeX phải thay thế thẻ <br> bằng ký tự xuống dòng Typst: %s", output)
}
