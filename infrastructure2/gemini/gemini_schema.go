package gemini

import (
	"encoding/json"
	"fmt"

	"github.com/invopop/jsonschema"
	"google.golang.org/genai"
)

func (p *GeminiLLMProvider) PlannerSchema() *genai.Schema     { return reflectCleanSchema(LessonPlan{}) }
func (p *GeminiLLMProvider) PlannerSchemaBytes() []byte       { return schemaToBytes(p.PlannerSchema()) }
func (p *GeminiLLMProvider) WorkerSchema() *genai.Schema      { return reflectCleanSchema(WorkerResult{}) }
func (p *GeminiLLMProvider) WorkerSchemaBytes() []byte        { return schemaToBytes(p.WorkerSchema()) }
func (p *GeminiLLMProvider) RepairSchema() *genai.Schema      { return reflectCleanSchema(RepairBatchResponse{}) }
func (p *GeminiLLMProvider) RepairSchemaBytes() []byte        { return schemaToBytes(p.RepairSchema()) }
func (p *GeminiLLMProvider) DeltaPlannerSchema() *genai.Schema { return reflectCleanSchema(DeltaTopicResponse{}) }
func (p *GeminiLLMProvider) DeltaPlannerSchemaBytes() []byte   { return schemaToBytes(p.DeltaPlannerSchema()) }

// Các hàm tiện ích sinh JSONSchema cấp package dùng trong các Stage
func GetPlannerSchemaBytes() []byte      { return schemaToBytes(reflectCleanSchema(LessonPlan{})) }
func GetWorkerSchemaBytes() []byte       { return schemaToBytes(reflectCleanSchema(WorkerResult{})) }
func GetRepairSchemaBytes() []byte        { return schemaToBytes(reflectCleanSchema(RepairBatchResponse{})) }
func GetDeltaPlannerSchemaBytes() []byte  { return schemaToBytes(reflectCleanSchema(DeltaTopicResponse{})) }
func GetRefinedTopicsSchemaBytes() []byte { return schemaToBytes(reflectCleanSchema(RefinedTopicsResponse{})) }

func schemaToBytes(s *genai.Schema) []byte {
	b, _ := json.Marshal(s)
	return b
}

func reflectCleanSchema(v any) *genai.Schema {
	r := &jsonschema.Reflector{ExpandedStruct: true, DoNotReference: true}
	return toGenAISchema(r.Reflect(v))
}

var typeMap = map[string]genai.Type{
	"string": genai.TypeString, "number": genai.TypeNumber, "integer": genai.TypeInteger,
	"boolean": genai.TypeBoolean, "array": genai.TypeArray, "object": genai.TypeObject,
}

func toGenAISchema(src *jsonschema.Schema) *genai.Schema {
	if src == nil {
		return nil
	}
	t, ok := typeMap[src.Type]
	if !ok {
		if src.Properties != nil {
			t = genai.TypeObject
		} else if src.Items != nil {
			t = genai.TypeArray
		} else {
			t = genai.TypeObject
		}
	}
	dst := &genai.Schema{
		Type: t, Description: src.Description, Title: src.Title, Format: src.Format, Required: src.Required,
	}
	for _, e := range src.Enum {
		dst.Enum = append(dst.Enum, fmt.Sprint(e))
	}
	if src.Properties != nil {
		dst.Properties = make(map[string]*genai.Schema)
		for p := src.Properties.Oldest(); p != nil; p = p.Next() {
			dst.Properties[p.Key] = toGenAISchema(p.Value)
		}
	}
	if src.Items != nil {
		dst.Items = toGenAISchema(src.Items)
	}
	cleanSchema(dst)
	return dst
}

func cleanSchema(sch *genai.Schema) {
	if sch == nil {
		return
	}
	if sch.Type == genai.TypeArray {
		for sch.Items != nil && sch.Items.Type == genai.TypeArray {
			sch.Items = sch.Items.Items
		}
		if sch.Items == nil {
			sch.Items = &genai.Schema{Type: genai.TypeString}
		}
		cleanSchema(sch.Items)
	}
	if sch.Properties != nil {
		for _, prop := range sch.Properties {
			cleanSchema(prop)
		}
	}
}
