package driver

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"image"
	"image/jpeg"
	_ "image/png"
	"os"

	"golang.org/x/image/draw"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

// MediaRunner materializes study material specs into raw documents using an injected media converter.
type MediaRunner struct {
	convertFn   func(ctx context.Context, data []byte, fileType string, fileName string) ([][]byte, error)
	maxImageDim int
}

// NewMediaRunner creates a MediaRunner with the provided conversion callback.
func NewMediaRunner(convertFn func(ctx context.Context, data []byte, fileType string, fileName string) ([][]byte, error)) *MediaRunner {
	return &MediaRunner{convertFn: convertFn, maxImageDim: 1600}
}

// MaterializeDocuments reads material files and invokes the converter to produce raw.Document entries.
func (m *MediaRunner) MaterializeDocuments(ctx context.Context, specs []raw.MaterialSpec) ([]raw.Document, error) {
	if err := ctx.Err(); err != nil {
		return nil, fmt.Errorf("materialize documents context: %w", err)
	}
	if len(specs) == 0 {
		return nil, errors.New("material specs must not be empty")
	}

	docs := make([]raw.Document, 0, len(specs))
	for _, spec := range specs {
		doc, err := m.materializeOne(ctx, spec)
		if err != nil {
			return nil, err
		}
		docs = append(docs, doc)
	}
	return docs, nil
}

func (m *MediaRunner) materializeOne(ctx context.Context, spec raw.MaterialSpec) (raw.Document, error) {
	switch spec.Kind {
	case raw.MaterialPDF:
		data, err := os.ReadFile(spec.FilePath)
		if err != nil {
			return raw.Document{}, fmt.Errorf("read pdf %s: %w", spec.FilePath, err)
		}
		return m.convertToImageDoc(ctx, spec.ID, spec.Name, data, string(raw.MaterialPDF))
	case raw.MaterialYouTube:
		return m.convertToImageDoc(ctx, spec.ID, spec.Name, []byte(spec.URL), string(raw.MaterialYouTube))
	case raw.MaterialMistake:
		return raw.Document{
			ID:   spec.ID,
			Name: spec.Name,
			Parts: []raw.Part{
				{
					MimeType: "text/plain",
					Text:     spec.Text,
					Data:     []byte(spec.Text),
				},
			},
		}, nil
	default:
		return raw.Document{}, fmt.Errorf("unsupported material kind %q", spec.Kind)
	}
}

func (m *MediaRunner) convertToImageDoc(
	ctx context.Context,
	id string,
	name string,
	rawData []byte,
	fileType string,
) (raw.Document, error) {
	if m.convertFn == nil {
		return raw.Document{}, errors.New("media converter function is not configured")
	}
	pages, err := m.convertFn(ctx, rawData, fileType, name)
	if err != nil {
		return raw.Document{}, fmt.Errorf("convert %s (%s) to images: %w", fileType, name, err)
	}
	parts := make([]raw.Part, 0, len(pages))
	for _, page := range pages {
		if len(page) == 0 {
			continue
		}
		scaled := ensureMaxImageDimension(page, m.maxImageDim)
		parts = append(parts, raw.Part{
			MimeType: "image/jpeg",
			Data:     scaled,
		})
	}
	return raw.Document{
		ID:    id,
		Name:  name,
		Parts: parts,
	}, nil
}

func ensureMaxImageDimension(imgBytes []byte, maxDim int) []byte {
	if len(imgBytes) == 0 || maxDim <= 0 {
		return imgBytes
	}
	src, _, err := image.Decode(bytes.NewReader(imgBytes))
	if err != nil {
		return imgBytes
	}
	bounds := src.Bounds()
	w, h := bounds.Dx(), bounds.Dy()
	if w <= maxDim && h <= maxDim {
		return imgBytes
	}

	var targetW, targetH int
	if w > h {
		targetW = maxDim
		targetH = int(float64(h) * float64(maxDim) / float64(w))
	} else {
		targetH = maxDim
		targetW = int(float64(w) * float64(maxDim) / float64(h))
	}
	if targetW < 1 {
		targetW = 1
	}
	if targetH < 1 {
		targetH = 1
	}

	dst := image.NewRGBA(image.Rect(0, 0, targetW, targetH))
	draw.ApproxBiLinear.Scale(dst, dst.Bounds(), src, bounds, draw.Over, nil)

	var buf bytes.Buffer
	if errEnc := jpeg.Encode(&buf, dst, &jpeg.Options{Quality: 82}); errEnc != nil {
		return imgBytes
	}
	return buf.Bytes()
}
