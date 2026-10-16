-- ============================================================
-- 1. STUDENTS & SESSIONS
-- ============================================================

-- name: GetStudentByID :one
SELECT id, name, class, cycle_start_day, created_at
FROM students
WHERE id = ?;

-- name: UpsertStudent :exec
INSERT INTO students (id, name, class, cycle_start_day, created_at)
VALUES (?, ?, ?, ?, ?)
ON CONFLICT(id) DO UPDATE SET
  name = excluded.name,
  class = excluded.class,
  cycle_start_day = excluded.cycle_start_day;

-- name: ListStudentIDs :many
SELECT id FROM students ORDER BY name COLLATE NOCASE;

-- name: UpsertClassSession :exec
INSERT INTO class_sessions (id, student_id, start_at, end_at, attendance_json)
VALUES (?, ?, ?, ?, ?)
ON CONFLICT(id) DO UPDATE SET
  attendance_json = excluded.attendance_json;

-- name: ListSessionsByStudentID :many
SELECT id, start_at, end_at, attendance_json
FROM class_sessions
WHERE student_id = ?
ORDER BY start_at DESC;

-- ============================================================
-- 2. DRAFTS & LESSONS
-- ============================================================

-- name: RecoverInterruptedDrafts :exec
UPDATE lesson_drafts
SET status = 'failed', updated_at = ?, error_text = ?
WHERE status = 'processing';

-- name: UpsertDraft :exec
INSERT INTO lesson_drafts (
  id, title, model, prompt, status, 
  material_json, lesson_json, created_at, updated_at, error_text
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
ON CONFLICT(id) DO UPDATE SET
  title = excluded.title,
  model = excluded.model,
  prompt = excluded.prompt,
  status = excluded.status,
  material_json = excluded.material_json,
  lesson_json = excluded.lesson_json,
  updated_at = excluded.updated_at,
  error_text = excluded.error_text;

-- name: GetDraftByID :one
SELECT id, title, model, prompt, status, material_json, lesson_json, created_at, updated_at, error_text
FROM lesson_drafts
WHERE id = ?;

-- name: ListDraftIDs :many
SELECT id FROM lesson_drafts ORDER BY created_at DESC;

-- name: UpsertLesson :exec
INSERT INTO lessons (id, draft_id, lesson_json)
VALUES (?, ?, ?)
ON CONFLICT(id) DO UPDATE SET
  lesson_json = excluded.lesson_json;

-- name: GetLessonByID :one
SELECT lesson_json
FROM lessons
WHERE id = ?;

-- ============================================================
-- 3. ASSIGNMENTS
-- ============================================================

-- name: UpsertAssignment :exec
INSERT INTO assignments (
  id, student_id, title, purpose, 
  origin_mistake_id, status, assigned_at, items_json
) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
ON CONFLICT(id) DO UPDATE SET
  title = excluded.title,
  purpose = excluded.purpose,
  origin_mistake_id = excluded.origin_mistake_id,
  status = excluded.status,
  items_json = excluded.items_json;

-- name: GetAssignmentByID :one
SELECT student_id, title, purpose, origin_mistake_id, status, assigned_at, items_json
FROM assignments
WHERE id = ?;

-- name: ListAssignmentIDs :many
SELECT id FROM assignments ORDER BY assigned_at DESC;

-- name: ListAssignmentItemSources :many
SELECT id, items_json FROM assignments;

-- ============================================================
-- 4. MISTAKES
-- ============================================================

-- name: DeleteMistakesByStudentID :exec
DELETE FROM mistakes WHERE student_id = ?;

-- name: InsertMistake :exec
INSERT INTO mistakes (
  id, student_id, parent_id, topic, 
  reason, assignment_item_id, status, created_at, resolved_at
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);

-- name: ListMistakesByStudentID :many
SELECT id, parent_id, topic, reason, assignment_item_id, status, created_at, resolved_at
FROM mistakes
WHERE student_id = ?
ORDER BY created_at ASC;

-- name: ListDistinctMistakeStudentIDs :many
SELECT DISTINCT student_id FROM mistakes ORDER BY student_id;

-- ============================================================
-- 5. DOCUMENTS
-- ============================================================

-- name: InsertDocument :exec
INSERT INTO documents (id, file_name, storage_path, page_count, created_at)
VALUES (?, ?, ?, ?, ?);

-- name: GetDocumentByID :one
SELECT file_name, storage_path, page_count, created_at
FROM documents
WHERE id = ?;

-- name: GetDocumentByStoragePath :one
SELECT id, file_name, page_count
FROM documents
WHERE storage_path = ?
LIMIT 1;

-- name: ListDocuments :many
SELECT id, file_name, storage_path, page_count, created_at
FROM documents
ORDER BY created_at DESC;

-- ============================================================
-- 6. EXTERNAL LINKS
-- ============================================================

-- name: FindStudentIDBySpaceID :one
SELECT student_id
FROM external_student_links
WHERE provider = 'google_meet_space' AND external_key = ?;

-- name: SaveSpaceLink :exec
INSERT INTO external_student_links (provider, external_key, student_id, meeting_code, space_name)
VALUES ('google_meet_space', ?, ?, ?, ?)
ON CONFLICT(provider, external_key) DO UPDATE SET
  student_id = excluded.student_id,
  meeting_code = excluded.meeting_code,
  space_name = excluded.space_name;

-- name: GetMeetLinkByStudentID :one
SELECT meeting_code, space_name
FROM external_student_links
WHERE student_id = ? AND provider = 'google_meet_space'
LIMIT 1;