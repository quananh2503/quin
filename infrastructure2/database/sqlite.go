package database

import (
	"context"
	"crypto/sha256"
	"database/sql"
	_ "embed"
	"errors"
	"fmt"
	"strings"
	"time"
	"uuid"

	_ "modernc.org/sqlite"
)

//go:embed schema.sql
var schema string

type SQLite struct{ DB *sql.DB }

func Open(path string) (*SQLite, error) {
	db, err := sql.Open("sqlite", path)
	if err != nil {
		return nil, err
	}
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(10)
	if _, err = db.Exec("PRAGMA foreign_keys=ON; PRAGMA busy_timeout=5000; PRAGMA journal_mode=WAL;"); err != nil {
		db.Close()
		return nil, err
	}
	if _, err = db.Exec(schema); err != nil {
		db.Close()
		return nil, fmt.Errorf("khởi tạo schema v2: %w", err)
	}
	if err := migrateLegacyStudents(db); err != nil {
		db.Close()
		return nil, fmt.Errorf("chuyển dữ liệu students sang schema v2: %w", err)
	}
	return &SQLite{DB: db}, nil
}

func migrateLegacyStudents(db *sql.DB) error {
	rows, err := db.Query(`SELECT class,name,cycle_start_day FROM students`)
	if err != nil {
		if strings.Contains(strings.ToLower(err.Error()), "no such table") {
			return nil
		}
		return err
	}
	defer rows.Close()
	for rows.Next() {
		var className, name string
		var cycle int
		if err := rows.Scan(&className, &name, &cycle); err != nil {
			return err
		}
		id := legacyUUID("student", className)
		if _, err := db.Exec(`INSERT INTO v2_students(id,name,class,cycle_start_day,created_at) VALUES(?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET name=excluded.name,class=excluded.class,cycle_start_day=excluded.cycle_start_day`, id.String(), name, className, cycle, timeText(time.Now().UTC())); err != nil {
			return err
		}
	}
	return rows.Err()
}

func legacyUUID(kind, value string) uuid.UUID {
	sum := sha256.Sum256([]byte("legacy:" + kind + ":" + value))
	var id uuid.UUID
	copy(id[:], sum[:16])
	id[6] = (id[6] & 0x0f) | 0x80
	id[8] = (id[8] & 0x3f) | 0x80
	return id
}

func (s *SQLite) Close() error { return s.DB.Close() }

func parseID(raw string) (uuid.UUID, error) {
	id, err := uuid.Parse(raw)
	if err != nil || id == uuid.Nil() {
		return uuid.Nil(), fmt.Errorf("UUID lưu trữ không hợp lệ: %q", raw)
	}
	return id, nil
}

func parseTime(raw string) (time.Time, error) {
	value, err := time.Parse(time.RFC3339Nano, raw)
	if err != nil {
		return time.Time{}, fmt.Errorf("thời gian lưu trữ không hợp lệ %q: %w", raw, err)
	}
	return value, nil
}

func timeText(value time.Time) string { return value.UTC().Format(time.RFC3339Nano) }

func nullableTime(value *time.Time) any {
	if value == nil {
		return nil
	}
	return timeText(*value)
}

func missing(err error, entity string) error {
	if errors.Is(err, sql.ErrNoRows) {
		return fmt.Errorf("%s không tồn tại: %w", entity, err)
	}
	return err
}

func (s *SQLite) GetLastSyncTime(ctx context.Context) (*time.Time, error) {
	var raw string
	err := s.DB.QueryRowContext(ctx, `SELECT value FROM v2_settings WHERE key='last_meet_sync'`).Scan(&raw)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	v, err := parseTime(raw)
	return &v, err
}

func (s *SQLite) UpdateLastSyncTime(ctx context.Context, value time.Time) error {
	_, err := s.DB.ExecContext(ctx, `INSERT INTO v2_settings(key,value) VALUES('last_meet_sync',?) ON CONFLICT(key) DO UPDATE SET value=excluded.value`, timeText(value))
	return err
}
