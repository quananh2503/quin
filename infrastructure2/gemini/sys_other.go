//go:build !windows

package gemini

import "os/exec"

func hideConsoleWindow(cmd *exec.Cmd) {}
