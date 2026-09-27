package document

import (
	"context"
	"log"
)

type Logger struct{}

func (Logger) Error(_ context.Context, msg string, err error, args ...any) {
	log.Printf("ERROR %s: %v %v", msg, err, args)
}

func (Logger) Warn(_ context.Context, msg string, args ...any) {
	log.Printf("WARN %s %v", msg, args)
}

func (Logger) Info(_ context.Context, msg string, args ...any) {
	log.Printf("INFO %s %v", msg, args)
}
