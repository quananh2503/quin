package driver_test

import (
	"context"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"go.uber.org/goleak"
	"goa/pkg/cmdvcr"

	"meet-attendance-clean/infrastructure2/AI/internal/driver"
)

// TestTypstRunner_CmdVCR_ReplayCompileAndStderr replays recorded real typst cassettes offline
// without invoking os/exec directly in tests.
func TestTypstRunner_CmdVCR_ReplayCompileAndStderr(t *testing.T) {
	defer goleak.VerifyNone(t)

	outDir := t.TempDir()

	// 1. Happy path: replay typst_ok.yaml and restore captured out.pdf with real %PDF- header.
	okRec := cmdvcr.NewRecorder(
		filepath.Join("..", "process", "typst", "testdata", "fixtures", "cassettes", "typst_ok.yaml"),
		cmdvcr.WithMode(cmdvcr.ModeReplayOnly),
		cmdvcr.WithWorkDir(outDir),
		cmdvcr.WithRestoreDir(outDir),
	)
	okRunner := driver.NewTypstRunner(outDir, 1).WithRunner(okRec)

	validTyp := `#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"
// @ANCHOR:T1|theory|0
#if IS_TEACHER [
  = Giao An Giao Vien
] else [
  = Phieu Bai Tap Hoc Sinh
]
`
	if _, err := okRunner.CompileTypst(context.Background(), "raw_data/ok.typ", "out.pdf", validTyp, true); err != nil {
		t.Fatalf("cmdvcr replay typst_ok failed: %v", err)
	}
	pdfBytes, err := os.ReadFile(filepath.Join(outDir, "out.pdf"))
	if err != nil {
		t.Fatalf("read restored PDF: %v", err)
	}
	if !strings.HasPrefix(string(pdfBytes), "%PDF-") {
		t.Fatalf("expected restored %%PDF- header from cassette, got %d bytes", len(pdfBytes))
	}

	// 2. Error path: replay typst_error.yaml and verify real exit_code=1 + stderr propagation.
	errRec := cmdvcr.NewRecorder(
		filepath.Join("..", "process", "typst", "testdata", "fixtures", "cassettes", "typst_error.yaml"),
		cmdvcr.WithMode(cmdvcr.ModeReplayOnly),
		cmdvcr.WithWorkDir(outDir),
	)
	errRunner := driver.NewTypstRunner(outDir, 1).WithRunner(errRec)

	brokenTyp := `#let x = 1
// @ANCHOR:T1|theory|0
#text[Ly thuyet hop le]
// @ANCHOR:T1|v|0|rec
#unknown_typst_symbol[Nhan dien dang toan]
`
	stderr, errBroken := errRunner.CompileTypst(context.Background(), "raw_data/broken.typ", "broken.pdf", brokenTyp, true)
	if errBroken == nil {
		t.Fatal("expected typst compile error from cassette replay, got nil")
	}
	if !strings.Contains(stderr, "broken.typ:5:") {
		t.Errorf("expected replayed typst stderr to contain broken.typ:5:, got:\n%s", stderr)
	}
}
