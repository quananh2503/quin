package wails

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestApp_OpenExternalURL_EmptyURL(t *testing.T) {
	app := &App{}

	err := app.OpenExternalURL("")
	assert.Error(t, err)

	err = app.OpenExternalURL("   \t\n  ")
	assert.Error(t, err)
}

func TestApp_OpenExternalURL_InvalidScheme(t *testing.T) {
	app := &App{}

	err := app.OpenExternalURL("javascript:alert(1)")
	assert.Error(t, err)

	err = app.OpenExternalURL("file:///C:/secret.txt")
	assert.Error(t, err)
}
