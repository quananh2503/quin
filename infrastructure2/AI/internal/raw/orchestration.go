package raw

// PipelineOptions holds execution parameters for a single lesson generation run.
type PipelineOptions struct {
	Title            string
	Model            string
	UserPrompt       string
	OutputDir        string
	Workers          int
	SelectedTopicIDs []string
}

// ChatCallResult pairs a parsed ChatResponse with its raw response bytes or error.
type ChatCallResult struct {
	Response ChatResponse
	Raw      []byte
	Err      error
}

// RepairBatchOutput represents the JSON payload returned by the Phase 3 math repair LLM call.
type RepairBatchOutput struct {
	RepairedItems []RepairBatchItem `json:"repaired_items"`
}

// RepairBatchItem represents a single repaired item returned by the LLM.
type RepairBatchItem struct {
	TargetID     string `json:"target_id"`
	FixedContent string `json:"fixed_content"`
}
