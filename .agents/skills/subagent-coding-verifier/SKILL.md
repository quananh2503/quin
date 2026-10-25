---
name: subagent-coding-verifier
description: >-
  Quy trình chuẩn cho Subagent khi nhận task viết code Go: tra cứu GoDoc, viết minimal code,
  tự động chạy go test, errcheck -blank và go vet để kiểm chứng chất lượng trước khi báo cáo.
---

# Subagent Coding & Verification Procedure

Khi bạn được giao nhiệm vụ triển khai (implement) một hàm hoặc một module trong dự án QUIN, hãy tuân thủ nghiêm ngặt quy trình 4 bước sau:

---

## Bước 1: Tra cứu tài liệu bằng GoDoc (GoDoc First)

Không phỏng đoán context ngoài phạm vi task. Hãy dùng lệnh `go doc` để đọc signature, invariants và hướng dẫn:
```powershell
go doc <package-path>.<SymbolName>
```
Đọc kỹ file stub và file test tương ứng để nắm rõ các trường hợp biên (edge cases).

---

## Bước 2: Viết mã nguồn tối thiểu (Minimal Implementation)

- Chỉ viết lượng code vừa đủ để thỏa mãn các Assertions trong file test.
- **TUYỆT ĐỐI KHÔNG SỬA FILE TEST** (các file có đuôi `_test.go`).
- Xử lý triệt để mọi lỗi: Nếu gọi hàm trả về `error`, luôn viết `if err != nil { return ..., fmt.Errorf("...: %w", err) }`.
- **CẤM** gán error vào `_` (blank identifier).

---

## Bước 3: Chạy bộ 3 công cụ tự kiểm chứng (Verification Suite)

Chạy tuần tự 3 lệnh sau trong PowerShell:

```powershell
# 1. Chạy Unit Test
go test -v ./<package-path>/...

# 2. Quét mọi lỗi bị bỏ qua hoặc gán vào '_'
& "C:\Users\ADMIN\go\bin\errcheck.exe" -blank ./<package-path>/...

# 3. Kiểm tra code correctness
go vet ./<package-path>/...
```

---

## Bước 4: Vòng lặp tự sửa lỗi (Self-Correction Loop)

1. Nếu `go test` fail: Đọc kỹ dòng báo fail của test, phân tích xem kỳ vọng (expected) và thực tế (got) khác nhau ở đâu, rồi sửa implementation.
2. Nếu `errcheck` báo lỗi: Xem dòng nào gọi hàm mà không hứng error, hoặc dòng nào gán vào `_ = err`, sửa thành kiểm tra `if err != nil`.
3. Lặp lại Bước 3 cho đến khi cả 3 lệnh đều chạy thành công 100%.
4. Báo cáo ngắn gọn cho Parent Agent: Các file đã sửa, kết quả test, và xác nhận đã qua `errcheck -blank`.
