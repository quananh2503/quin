package assignment

func (e MCQEvalReq) SelectedOption() string { return e.selectedOption }
func (e MCQEvalReq) WorkingText() string    { return e.text }
func (e MCQEvalReq) WorkingData() [][]byte  { return cloneBytes2D(e.data) }

func (e EssayEvalReq) Text() string   { return e.text }
func (e EssayEvalReq) Data() [][]byte { return cloneBytes2D(e.data) }
func (e EssayEvalReq) TargetParts() []string {
	parts := make([]string, len(e.subItems))
	for i, sub := range e.subItems {
		parts[i] = sub.label
	}
	return parts
}
