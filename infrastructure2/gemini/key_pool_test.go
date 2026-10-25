package gemini

import (
	"errors"
	"os"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestIsTransientError(t *testing.T) {
	tests := []struct {
		name     string
		err      error
		expected bool
	}{
		{
			name:     "nil error",
			err:      nil,
			expected: false,
		},
		{
			name:     "HTTP 429 Rate limit",
			err:      errors.New("googleapi: Error 429: RESOURCE_EXHAUSTED"),
			expected: true,
		},
		{
			name:     "HTTP 503 Service Unavailable",
			err:      errors.New("googleapi: Error 503: The service is currently unavailable."),
			expected: true,
		},
		{
			name:     "HTTP 500 Internal error",
			err:      errors.New("googleapi: Error 500: Internal error encountered."),
			expected: true,
		},
		{
			name:     "wsarecv connection aborted",
			err:      errors.New("read tcp 192.168.1.5:55799->142.250.190.42:443: wsarecv: An established connection was aborted by the software in your host machine."),
			expected: true,
		},
		{
			name:     "connection reset by peer",
			err:      errors.New("read tcp 127.0.0.1:5000: connection reset by peer"),
			expected: true,
		},
		{
			name:     "unexpected EOF",
			err:      errors.New("unexpected EOF"),
			expected: true,
		},
		{
			name:     "i/o timeout",
			err:      errors.New("net/http: request canceled (Client.Timeout exceeded while awaiting headers)"),
			expected: true,
		},
		{
			name:     "broken pipe",
			err:      errors.New("write: broken pipe"),
			expected: true,
		},
		{
			name:     "404 not found (non-transient)",
			err:      errors.New("googleapi: Error 404: models/xyz is not found"),
			expected: false,
		},
		{
			name:     "400 bad request (non-transient)",
			err:      errors.New("googleapi: Error 400: INVALID_ARGUMENT"),
			expected: false,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			actual := isTransientError(tc.err)
			assert.Equal(t, tc.expected, actual, "Case '%s' failed", tc.name)
		})
	}
}

func TestLoadAvailableAPIKeys_EmbeddedOnly1_3_4(t *testing.T) {
	keys := LoadAvailableAPIKeys()
	assert.NotEmpty(t, keys, "Danh sách keys phải có ít nhất các embedded keys")

	k1 := strings.TrimSpace(embeddedKey1)
	k3 := strings.TrimSpace(embeddedKey3)
	k4 := strings.TrimSpace(embeddedKey4)

	assert.Contains(t, keys, k1, "Phải chứa embedded key 1")
	assert.Contains(t, keys, k3, "Phải chứa embedded key 3")
	assert.Contains(t, keys, k4, "Phải chứa embedded key 4")

	// Đảm bảo không nạp key2 và key5
	key2Data, err2 := os.ReadFile("key2.txt")
	if err2 == nil && len(key2Data) > 0 {
		assert.NotContains(t, keys, strings.TrimSpace(string(key2Data)), "Không được chứa key2")
	}
	key5Data, err5 := os.ReadFile("key5.txt")
	if err5 == nil && len(key5Data) > 0 {
		assert.NotContains(t, keys, strings.TrimSpace(string(key5Data)), "Không được chứa key5")
	}
}
