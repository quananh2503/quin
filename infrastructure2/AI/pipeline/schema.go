package pipeline

import (
	"encoding/json"

	"github.com/invopop/jsonschema"
)

// GetPlannerSchemaBytes sinh chuỗi JSON Schema chuẩn từ struct LessonPlan.
// Dùng để hướng dẫn AI Provider trả về đúng cấu trúc mong muốn.
func GetPlannerSchemaBytes() []byte {
	r := &jsonschema.Reflector{ExpandedStruct: true, DoNotReference: true}
	sch := r.Reflect(LessonPlan{})
	bytes, err := json.Marshal(sch)
	if err != nil {
		return []byte("{}")
	}
	return bytes
}

// GetInventorySchemaBytes sinh chuỗi JSON Schema chuẩn từ struct DocumentInventory.
// Dùng cho Bước 1A (Harvester) để bóc tách vét cạn mọi câu hỏi từ tài liệu.
func GetInventorySchemaBytes() []byte {
	r := &jsonschema.Reflector{ExpandedStruct: true, DoNotReference: true}
	sch := r.Reflect(DocumentInventory{})
	bytes, err := json.Marshal(sch)
	if err != nil {
		return []byte("{}")
	}
	return bytes
}
