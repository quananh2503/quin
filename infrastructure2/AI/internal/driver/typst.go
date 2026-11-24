package driver

import (
	"context"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"meet-attendance-clean/infrastructure2/AI/internal/raw"
)

// TypstRunner handles file output persistence and Typst CLI compilation.
type TypstRunner struct {
	typstCLI         string
	outputDir        string
	workers          int
	selectedTopicIDs []string
}

// NewTypstRunner creates a TypstRunner with output directory and worker count.
func NewTypstRunner(outputDir string, workers int) *TypstRunner {
	return &TypstRunner{outputDir: outputDir, workers: workers}
}

// WithTypstCLI configures a custom path to the typst executable.
func (t *TypstRunner) WithTypstCLI(cli string) *TypstRunner {
	t.typstCLI = cli
	return t
}

// WithOutputDir configures the artifact output directory.
func (t *TypstRunner) WithOutputDir(dir string) *TypstRunner {
	t.outputDir = dir
	return t
}

// WithSelectedTopics configures optional topic ID filtering.
func (t *TypstRunner) WithSelectedTopics(ids []string) *TypstRunner {
	t.selectedTopicIDs = append([]string(nil), ids...)
	return t
}

// WriteArtifact writes bytes to a path relative to OutputDir.
func (t *TypstRunner) WriteArtifact(relPath string, data []byte) error {
	if strings.TrimSpace(t.outputDir) == "" {
		return errors.New("output directory is not configured")
	}
	fullPath := filepath.Join(t.outputDir, relPath)
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

	cli, err := t.resolveTypstCLI()
	if err != nil {
		return "", err
	}

	typPath := filepath.Join(t.outputDir, typRelPath)
	pdfPath := filepath.Join(t.outputDir, pdfRelPath)
	if err := os.MkdirAll(filepath.Dir(pdfPath), 0o755); err != nil {
		return "", fmt.Errorf("create pdf directory for %s: %w", pdfRelPath, err)
	}

	teacherFlag := "teacher=false"
	if isTeacher {
		teacherFlag = "teacher=true"
	}

	cmd := exec.CommandContext(ctx, cli, "compile", "--input", teacherFlag, typPath, pdfPath)
	out, errCompile := cmd.CombinedOutput()
	if errCompile != nil {
		return string(out), fmt.Errorf("typst compile %s: %w", typRelPath, errCompile)
	}
	return string(out), nil
}

// BuildOptions constructs PipelineOptions from the runner configuration.
func (t *TypstRunner) BuildOptions(title, model, prompt string) raw.PipelineOptions {
	return raw.PipelineOptions{
		Title:            title,
		Model:            model,
		UserPrompt:       prompt,
		OutputDir:        t.outputDir,
		Workers:          t.workers,
		SelectedTopicIDs: append([]string(nil), t.selectedTopicIDs...),
	}
}

func (t *TypstRunner) resolveTypstCLI() (string, error) {
	if strings.TrimSpace(t.typstCLI) != "" {
		return t.typstCLI, nil
	}
	if p, err := exec.LookPath("typst"); err == nil {
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
	return append([]string(nil), t.selectedTopicIDs...)
}

// OutputDir returns the configured output directory.
func (t *TypstRunner) OutputDir() string { return t.outputDir }

// Workers returns the configured worker concurrency.
func (t *TypstRunner) Workers() int { return t.workers }
