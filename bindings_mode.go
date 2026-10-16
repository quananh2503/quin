//go:build bindings

package main

// isBindingGeneration is compiled only into Wails' temporary bindings binary.
// That binary needs method signatures, not databases, OAuth clients, or files.
func isBindingGeneration() bool { return true }
