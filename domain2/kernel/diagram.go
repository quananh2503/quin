package sharekernel

type DiagramType string

const (
	DiagramNone DiagramType = ""
	DiagramSVG  DiagramType = "SVG"
	DiagramURL  DiagramType = "URL"
)

type Diagram struct {
	typ     DiagramType
	content string
}

func NewDiagram(dType DiagramType, content string) Diagram {
	return Diagram{
		typ:     dType,
		content: content,
	}
}

func (d Diagram) HasDiagram() bool {
	return d.typ != DiagramNone && len(d.content) > 0
}
func (d Diagram) Type() DiagramType {
	return d.typ
}
func (d Diagram) Content() string {
	return d.content
}
