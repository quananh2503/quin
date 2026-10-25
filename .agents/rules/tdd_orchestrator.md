---
description: Quy tắc bắt buộc về phân quyền Orchestrator - Worker và quy trình TDD trong dự án QUIN
alwaysApply: true
---
# QUY TẮC BẮT BUỘC: ORCHESTRATOR - WORKER & TDD ENFORCEMENT (QUIN PROJECT)

Tài liệu này được áp dụng liên tục cho mọi phiên làm việc của AI trong dự án QUIN.

---

## 1. PHÂN QUYỀN PARENT AGENT (NHẠC TRƯỞNG / ORCHESTRATOR)

1. **Nghiêm cấm viết tắt (No Implementation Shortcuts)**:
   - Parent Agent **TUYỆT ĐỐI KHÔNG ĐƯỢC TỰ Ý SỬA ĐỔI FILE IMPLEMENTATION** (`*.go`).
   - Bất kể khi context kéo dài hay khi gặp lỗi nhỏ, Parent Agent không được phá vỡ quy trình.
2. **Nhiệm vụ của Parent Agent**:
   - Trao đổi, làm rõ yêu cầu nghiệp vụ với người dùng.
   - Rà soát kiến trúc và đặc tả luồng dữ liệu.
   - Viết **Contract Unit Test** (`*_test.go`) chứng minh lỗi hoặc yêu cầu nghiệp vụ mới (Red stage).
   - Viết GoDoc / Stub interface.
   - **Giao việc cho Subagent** chuyên trách thực hiện code thực thi.

---

## 2. KỶ LUẬT SUBAGENT (THỢ THI CÔNG / WORKER)

1. **Ngữ cảnh mới & Tập trung tuyệt đối (Fresh Context)**:
   - Subagent luôn hoạt động độc lập, đọc GoDoc, nắm bắt quy tắc trong `AGENTS.md` và `SKILL.md`.
2. **Không sửa Test (Do Not Tamper With Tests)**:
   - Nghiêm cấm Subagent sửa file test để làm test pass. Chỉ được sửa file mã nguồn nghiệp vụ.
3. **Bộ 3 công cụ kiểm chứng bắt buộc**:
   Trước khi báo cáo hoàn thành, Subagent bắt buộc phải tự chạy:
   - `go test -v ./<package>/...` (100% Pass)
   - `errcheck -blank ./<package>/...` (0 lỗi bỏ qua)
   - `go vet ./<package>/...` (0 cảnh báo)

---

## 3. CƠ CHẾ BẢO VỆ CONTEXT DÀI (CONTEXT REFRESH)

- Khi context của phiên làm việc kéo dài, Parent Agent chủ động đề xuất hoặc người dùng gõ lệnh `/compact` để làm sạch context window, bảo toàn các quyết định kiến trúc và duy trì sự minh mẫn.
