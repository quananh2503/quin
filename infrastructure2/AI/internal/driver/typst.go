package driver

import (
	"context"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"goa/pkg/cmdvcr"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

// TypstRunner handles file output persistence and Typst CLI compilation.
type TypstRunner struct {
	typstCLI string
	runner   cmdvcr.Runner
	cfg      raw.PipelineOptions
}

// NewTypstRunner creates a TypstRunner with output directory and worker count.
func NewTypstRunner(outputDir string, workers int) *TypstRunner {
	return &TypstRunner{
		cfg: raw.PipelineOptions{
			OutputDir: outputDir,
			Workers:   workers,
		},
	}
}

// WithTypstCLI configures a custom path to the typst executable.
func (t *TypstRunner) WithTypstCLI(cli string) *TypstRunner {
	t.typstCLI = cli
	return t
}

// WithRunner injects a cmdvcr.Runner (for example a ReplayOnly Recorder in tests).
func (t *TypstRunner) WithRunner(r cmdvcr.Runner) *TypstRunner {
	t.runner = r
	return t
}

// WithOutputDir configures the artifact output directory.
func (t *TypstRunner) WithOutputDir(dir string) *TypstRunner {
	t.cfg.OutputDir = dir
	return t
}

// WithSelectedTopics configures optional topic ID filtering.
func (t *TypstRunner) WithSelectedTopics(ids []string) *TypstRunner {
	t.cfg.SelectedTopicIDs = append([]string(nil), ids...)
	return t
}

// WriteArtifact writes bytes to a path relative to OutputDir.
func (t *TypstRunner) WriteArtifact(relPath string, data []byte) error {
	if strings.TrimSpace(t.cfg.OutputDir) == "" {
		return errors.New("output directory is not configured")
	}
	fullPath := filepath.Join(t.cfg.OutputDir, relPath)
	if err := os.MkdirAll(filepath.Dir(fullPath), 0o755); err != nil {
		return fmt.Errorf("create artifact directory for %s: %w", relPath, err)
	}
	if err := os.WriteFile(fullPath, data, 0o644); err != nil {
		return fmt.Errorf("write artifact %s: %w", relPath, err)
	}
	return nil
}

// CompileTypst writes Typst markup and runs typst compile, returning compiler stderr on failure.
func (t *TypstRunner) CompileTypst(ctx context.Context, typRelPath, pdfRelPath, content string, isTeacher bool) (string, error) {
	if err := t.WriteArtifact(typRelPath, []byte(content)); err != nil {
		return "", err
	}

	runner := t.runner
	if runner == nil {
		runner = &cmdvcr.OSRunner{}
	}

	cli, err := t.resolveTypstCLI()
	if err != nil {
		return "", err
	}

	typPath := filepath.Join(t.cfg.OutputDir, typRelPath)
	pdfPath := filepath.Join(t.cfg.OutputDir, pdfRelPath)
	if err := os.MkdirAll(filepath.Dir(pdfPath), 0o755); err != nil {
		return "", fmt.Errorf("create pdf directory for %s: %w", pdfRelPath, err)
	}

	teacherFlag := "teacher=false"
	if isTeacher {
		teacherFlag = "teacher=true"
	}

	resp, errRun := runner.Run(ctx, cmdvcr.Request{
		Bin:  cli,
		Args: []string{"compile", "--input", teacherFlag, typPath, pdfPath},
	})
	if errRun != nil {
		return "", fmt.Errorf("typst compile %s: %w", typRelPath, errRun)
	}

	combined := resp.Stdout + resp.Stderr
	if resp.ExitCode != 0 {
		return combined, fmt.Errorf("typst compile %s: exit code %d", typRelPath, resp.ExitCode)
	}
	return combined, nil
}

// BuildOptions constructs PipelineOptions from the runner configuration.
func (t *TypstRunner) BuildOptions(title, model, prompt string) raw.PipelineOptions {
	return raw.PipelineOptions{
		Title:            title,
		Model:            model,
		UserPrompt:       prompt,
		OutputDir:        t.cfg.OutputDir,
		Workers:          t.cfg.Workers,
		SelectedTopicIDs: append([]string(nil), t.cfg.SelectedTopicIDs...),
	}
}

func (t *TypstRunner) resolveTypstCLI() (string, error) {
	if strings.TrimSpace(t.typstCLI) != "" {
		return t.typstCLI, nil
	}
	if t.runner != nil {
		return "typst", nil
	}
	if p, err := cmdvcr.LookPath("typst"); err == nil {
		return p, nil
	}
	homeDir, err := os.UserHomeDir()
	if err == nil {
		candidate := filepath.Join(homeDir, ".local", "bin", "typst")
		if _, errStat := os.Stat(candidate); errStat == nil {
			return candidate, nil
		}
	}
	return "", errors.New("typst CLI not found")
}

// SelectedTopicIDs returns a copy of the configured selected topic IDs.
func (t *TypstRunner) SelectedTopicIDs() []string {
	return append([]string(nil), t.cfg.SelectedTopicIDs...)
}

// OutputDir returns the configured output directory.
func (t *TypstRunner) OutputDir() string { return t.cfg.OutputDir }

// Workers returns the configured worker concurrency.
func (t *TypstRunner) Workers() int { return t.cfg.Workers }
