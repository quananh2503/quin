package pdf

import (
	"context"
	"os"
	"path/filepath"
	"testing"
)

func TestExtractPagesWithNoPagesReturnsWholeDocument(t *testing.T) {
	t.Parallel()

	want := []byte("a complete PDF stream")
	path := filepath.Join(t.TempDir(), "source.pdf")
	if err := os.WriteFile(path, want, 0600); err != nil {
		t.Fatal(err)
	}

	got, err := NewProcessor().ExtractPages(context.Background(), path, nil)
	if err != nil {
		t.Fatalf("ExtractPages() returned an error: %v", err)
	}
	if string(got) != string(want) {
		t.Fatalf("ExtractPages() = %q, want %q", got, want)
	}
}
