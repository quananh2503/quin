package raw

// InventoryItem identifies a single question, exercise, or activity harvested from source materials.
type InventoryItem struct {
	ID          string `json:"id"`
	SourceName  string `json:"source_name"`
	SourceLabel string `json:"source_label"`
	ItemType    string `json:"item_type"`
	Snippet     string `json:"snippet"`
	HasSolution bool   `json:"has_solution,omitempty"`
}

// DocumentInventory holds the exhaustive Phase 1A item inventory.
type DocumentInventory struct {
	TotalItems int             `json:"total_items"`
	Items      []InventoryItem `json:"items"`
}

// CatalogItem groups question IDs by type and core method.
type CatalogItem struct {
	DocID        string   `json:"doc_id"`
	QuestionIDs  []string `json:"question_ids"`
	QuestionType string   `json:"question_type"`
	TargetOutput string   `json:"target_output"`
	CoreMethod   string   `json:"core_method"`
}

// TopicPlan describes a single pedagogical topic planned in Phase 1B.
type TopicPlan struct {
	TopicID             string   `json:"topic_id"`
	Title               string   `json:"title"`
	Difficulty          string   `json:"difficulty"`
	TargetOutput        string   `json:"target_output"`
	CoreConcept         string   `json:"core_concept"`
	AssignedQuestionIDs []string `json:"assigned_question_ids"`
	Variants            []string `json:"variants,omitempty"`
	SourceRefs          []string `json:"source_refs,omitempty"`
}

// LessonPlan is the full Phase 1B curriculum plan.
type LessonPlan struct {
	LessonTitle     string            `json:"lesson_title"`
	Overview        string            `json:"overview"`
	Inventory       DocumentInventory `json:"inventory,omitempty"`
	QuestionCatalog []CatalogItem     `json:"question_catalog,omitempty"`
	Topics          []TopicPlan       `json:"topics"`
}

// ExampleItem models a worked example inside a variant or topic.
type ExampleItem struct {
	Title       string `json:"title"`
	Problem     string `json:"problem"`
	Solution    string `json:"solution"`
	Explanation string `json:"explanation,omitempty"`
}

// ShortAnswerExercise models a numeric short-answer exercise.
type ShortAnswerExercise struct {
	Prompt      string `json:"prompt"`
	Solution    string `json:"solution"`
	FinalNumber string `json:"final_number"`
}

// DrillExercise models an isomorphic practice drill.
type DrillExercise struct {
	Title    string `json:"title"`
	Level    string `json:"level"`
	Prompt   string `json:"prompt"`
	Solution string `json:"solution"`
	Answer   string `json:"answer,omitempty"`
}

// AnswerItem holds a concise answer key entry for quick lookup.
type AnswerItem struct {
	DrillID     string `json:"drill_id"`
	ShortGuide  string `json:"short_guide"`
	FinalAnswer string `json:"final_answer"`
}

// VariantGuide models a variant method, recognition cue, action steps, example, and drills.
type VariantGuide struct {
	VariantID   string          `json:"variant_id"`
	VariantName string          `json:"variant_name"`
	Recognition string          `json:"recognition"`
	ActionSteps []string        `json:"action_steps"`
	QuickTip    string          `json:"quick_tip"`
	Example     ExampleItem     `json:"example"`
	Drills      []DrillExercise `json:"drills"`
}

// TopicContent holds the authored pedagogical content produced in Phase 2.
type TopicContent struct {
	TopicID      string                `json:"topic_id"`
	Title        string                `json:"title"`
	Difficulty   string                `json:"difficulty,omitempty"`
	TheoryPoints []string              `json:"theory_points,omitempty"`
	CalloutTip   string                `json:"callout_tip,omitempty"`
	ClozeFormula string                `json:"cloze_formula,omitempty"`
	Variants     []VariantGuide        `json:"variants,omitempty"`
	AnswerKey    []AnswerItem          `json:"answer_key,omitempty"`
	Examples     []ExampleItem         `json:"examples,omitempty"`
	ShortAnswers []ShortAnswerExercise `json:"short_answers,omitempty"`
	Drills       []DrillExercise       `json:"drills,omitempty"`
	TypstContent string                `json:"typst_content,omitempty"`
	LaTeXContent string                `json:"latex_content,omitempty"`
}

// AuditReport summarizes Phase 1.5 / 2.5 plan & content coverage verification.
type AuditReport struct {
	UnassignedIDs    []string    `json:"unassigned_ids"`
	OverloadedTopics []TopicPlan `json:"overloaded_topics"`
	RedundantTopics  []TopicPlan `json:"redundant_topics"`
	NeedsRefinement  bool        `json:"needs_refinement"`
}

// RepairTask describes a single math/Typst syntax repair target.
type RepairTask struct {
	TargetID      string `json:"target_id"`
	ErrorReason   string `json:"error_reason"`
	BrokenSnippet string `json:"broken_snippet"`
	Context       string `json:"context,omitempty"`
	Content       string `json:"content,omitempty"`
	FixedContent  string `json:"fixed_content,omitempty"`
}
