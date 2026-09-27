CREATE TABLE IF NOT EXISTS v2_students (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  class TEXT NOT NULL,
  cycle_start_day INTEGER NOT NULL,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS v2_class_sessions (
  id TEXT PRIMARY KEY,
  student_id TEXT NOT NULL,
  start_at TEXT NOT NULL,
  end_at TEXT NOT NULL,
  attendance_json TEXT NOT NULL,
  FOREIGN KEY(student_id) REFERENCES v2_students(id)
);
CREATE INDEX IF NOT EXISTS v2_sessions_student_time ON v2_class_sessions(student_id, start_at DESC);
CREATE TABLE IF NOT EXISTS v2_lesson_drafts (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  model TEXT NOT NULL,
  prompt TEXT NOT NULL,
  status TEXT NOT NULL,
  material_json TEXT NOT NULL,
  lesson_json TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT,
  error_text TEXT
);
CREATE INDEX IF NOT EXISTS v2_drafts_created ON v2_lesson_drafts(created_at DESC);
CREATE TABLE IF NOT EXISTS v2_lessons (
  id TEXT PRIMARY KEY,
  draft_id TEXT NOT NULL,
  lesson_json TEXT NOT NULL,
  FOREIGN KEY(draft_id) REFERENCES v2_lesson_drafts(id)
);
CREATE TABLE IF NOT EXISTS v2_assignments (
  id TEXT PRIMARY KEY,
  student_id TEXT NOT NULL,
  title TEXT NOT NULL,
  purpose TEXT NOT NULL,
  origin_mistake_id TEXT,
  status TEXT NOT NULL,
  assigned_at TEXT NOT NULL,
  items_json TEXT NOT NULL,
  FOREIGN KEY(student_id) REFERENCES v2_students(id)
);
CREATE INDEX IF NOT EXISTS v2_assignments_student_time ON v2_assignments(student_id, assigned_at DESC);
CREATE TABLE IF NOT EXISTS v2_mistake_graphs (
  student_id TEXT PRIMARY KEY,
  graph_id TEXT NOT NULL,
  roots_json TEXT NOT NULL,
  FOREIGN KEY(student_id) REFERENCES v2_students(id)
);
CREATE TABLE IF NOT EXISTS v2_documents (
  id TEXT PRIMARY KEY,
  file_name TEXT NOT NULL,
  storage_path TEXT NOT NULL,
  page_count INTEGER NOT NULL,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS v2_notebook_bindings (
  student_id TEXT NOT NULL,
  audience TEXT NOT NULL,
  account_id TEXT NOT NULL,
  notebook_id TEXT NOT NULL,
  notebook_name TEXT NOT NULL,
  PRIMARY KEY(student_id, audience, account_id),
  UNIQUE(account_id, notebook_id)
);
CREATE TABLE IF NOT EXISTS v2_assignment_pages (
  assignment_id TEXT NOT NULL,
  audience TEXT NOT NULL,
  account_id TEXT NOT NULL,
  page_id TEXT NOT NULL,
  page_url TEXT NOT NULL,
  notebook_id TEXT NOT NULL,
  section_id TEXT NOT NULL,
  PRIMARY KEY(assignment_id, audience),
  UNIQUE(account_id, page_id)
);
CREATE TABLE IF NOT EXISTS v2_settings (key TEXT PRIMARY KEY, value TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS v2_external_student_links (
  provider TEXT NOT NULL,
  external_key TEXT NOT NULL,
  student_id TEXT NOT NULL,
  meeting_code TEXT NOT NULL DEFAULT '',
  space_name TEXT NOT NULL DEFAULT '',
  PRIMARY KEY(provider, external_key)
);
