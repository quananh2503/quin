//go:build !windows

package renderer

import "os/exec"

func hideConsoleWindow(cmd *exec.Cmd) {}
