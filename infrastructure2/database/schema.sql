-- ============================================================
-- 1. HỌC SINH & ĐIỂM DANH BUỔI HỌC
-- ============================================================

CREATE TABLE IF NOT EXISTS students (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  class TEXT NOT NULL,
  cycle_start_day INTEGER NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS class_sessions (
  id TEXT PRIMARY KEY,
  student_id TEXT NOT NULL,
  start_at TEXT NOT NULL,
  end_at TEXT NOT NULL,
  attendance_json TEXT NOT NULL,
  FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_sessions_student_time 
ON class_sessions(student_id, start_at DESC);

-- ============================================================
-- 2. SOẠN GIÁO ÁN (DRAFTS & LESSONS)
-- ============================================================

CREATE TABLE IF NOT EXISTS lesson_drafts (
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

CREATE INDEX IF NOT EXISTS idx_drafts_created 
ON lesson_drafts(created_at DESC);

CREATE TABLE IF NOT EXISTS lessons (
  id TEXT PRIMARY KEY,
  draft_id TEXT NOT NULL,
  lesson_json TEXT NOT NULL,
  FOREIGN KEY(draft_id) REFERENCES lesson_drafts(id) ON DELETE CASCADE
);

-- ============================================================
-- 3. PHIẾU BÀI TẬP (ASSIGNMENTS)
-- ============================================================

CREATE TABLE IF NOT EXISTS assignments (
  id TEXT PRIMARY KEY,
  student_id TEXT NOT NULL,
  title TEXT NOT NULL,
  purpose TEXT NOT NULL,
  origin_mistake_id TEXT,
  status TEXT NOT NULL,
  assigned_at TEXT NOT NULL,
  items_json TEXT NOT NULL,
  FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_assignments_student_time 
ON assignments(student_id, assigned_at DESC);

-- ============================================================
-- 4. PHẢ HỆ LỖ HỔNG KIẾN THỨC (MISTAKES - ĐÃ CHUẨN HÓA PARENT_ID)
-- ============================================================

CREATE TABLE IF NOT EXISTS mistakes (
  id TEXT PRIMARY KEY,
  student_id TEXT NOT NULL,
  parent_id TEXT,                    -- Nút gốc thì NULL, nút con chứa ID cha
  topic TEXT NOT NULL,
  reason TEXT NOT NULL,
  assignment_item_id TEXT NOT NULL,
  status TEXT NOT NULL,              -- 'DETECTED', 'REMEDIATING', 'RESOLVED'
  created_at TEXT NOT NULL,
  resolved_at TEXT,
  FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY(parent_id) REFERENCES mistakes(id) ON DELETE CASCADE
);

-- Index lọc cực nhanh các lỗi chưa đóng (Active Mistakes)
CREATE INDEX IF NOT EXISTS idx_mistakes_student_status 
ON mistakes(student_id, status);

-- ============================================================
-- 5. TÀI LIỆU PDF NGUYÊN BẢN (DOCUMENTS)
-- ============================================================

CREATE TABLE IF NOT EXISTS documents (
  id TEXT PRIMARY KEY,
  file_name TEXT NOT NULL,
  storage_path TEXT NOT NULL,
  page_count INTEGER NOT NULL,
  created_at TEXT NOT NULL
);

-- ============================================================
-- 6. LIÊN KẾT MICROSOFT ONENOTE (NOTEBOOKS & PAGES)
-- ============================================================

CREATE TABLE IF NOT EXISTS notebook_bindings (
  student_id TEXT NOT NULL,
  audience TEXT NOT NULL,
  account_id TEXT NOT NULL,
  notebook_id TEXT NOT NULL,
  notebook_name TEXT NOT NULL,
  PRIMARY KEY(student_id, audience, account_id),
  UNIQUE(account_id, notebook_id),
  FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS assignment_pages (
  assignment_id TEXT NOT NULL,
  audience TEXT NOT NULL,
  account_id TEXT NOT NULL,
  page_id TEXT NOT NULL,
  page_url TEXT NOT NULL,
  notebook_id TEXT NOT NULL,
  section_id TEXT NOT NULL,
  PRIMARY KEY(assignment_id, audience),
  UNIQUE(account_id, page_id),
  FOREIGN KEY(assignment_id) REFERENCES assignments(id) ON DELETE CASCADE
);

-- ============================================================
-- 7. CẤU HÌNH & LIÊN KẾT NGOÀI (GOOGLE MEET)
-- ============================================================

CREATE TABLE IF NOT EXISTS settings (
  key TEXT PRIMARY KEY, 
  value TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS external_student_links (
  provider TEXT NOT NULL,
  external_key TEXT NOT NULL,
  student_id TEXT NOT NULL,
  meeting_code TEXT NOT NULL DEFAULT '',
  space_name TEXT NOT NULL DEFAULT '',
  PRIMARY KEY(provider, external_key),
  FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE
);