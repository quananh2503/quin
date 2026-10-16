package document

import (
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
)

type LocalStorage struct {
	Root string
}

func NewLocalStorage(root string) (*LocalStorage, error) {
	if strings.TrimSpace(root) == "" {
		return nil, errors.New("thư mục storage không được để trống")
	}
	if err := os.MkdirAll(root, 0755); err != nil {
		return nil, fmt.Errorf("tạo thư mục storage: %w", err)
	}
	return &LocalStorage{Root: root}, nil
}

func (s *LocalStorage) path(name string) (string, error) {
	if s == nil || strings.TrimSpace(s.Root) == "" {
		return "", errors.New("local storage chưa được cấu hình")
	}
	clean := filepath.Clean(name)
	if clean == "." || filepath.IsAbs(clean) || clean == ".." || strings.HasPrefix(clean, ".."+string(os.PathSeparator)) {
		return "", fmt.Errorf("storage path không hợp lệ: %q", name)
	}
	return filepath.Join(s.Root, clean), nil
}

func (s *LocalStorage) SaveStream(ctx context.Context, storagePath string, reader io.Reader) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	path, err := s.path(storagePath)
	if err != nil {
		return err
	}
	if err := os.MkdirAll(filepath.Dir(path), 0755); err != nil {
		return err
	}
	tmp, err := os.CreateTemp(filepath.Dir(path), ".upload-*")
	if err != nil {
		return err
	}
	tmpName := tmp.Name()
	defer os.Remove(tmpName)
	if _, err := io.Copy(tmp, reader); err != nil {
		tmp.Close()
		return err
	}
	if err := tmp.Close(); err != nil {
		return err
	}
	if err := os.Rename(tmpName, path); err != nil {
		return err
	}
	return nil
}

func (s *LocalStorage) OpenStream(ctx context.Context, storagePath string) (io.ReadCloser, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	path, err := s.path(storagePath)
	if err != nil {
		return nil, err
	}
	return os.Open(path)
}
