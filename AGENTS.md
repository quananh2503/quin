# AGENTS & SUBAGENTS CODING RULES (QUIN PROJECT)

Tài liệu này định nghĩa các quy tắc cốt lõi mang tính bắt buộc (MANDATORY RULES) áp dụng cho mọi Agent và Subagent khi phát triển, sửa đổi hoặc mở rộng mã nguồn trong dự án QUIN.

---

## 1. NGUYÊN TẮC TEST-DRIVEN & TỰ KIỂM CHỨNG (AUTOMATED VERIFICATION)

1. **Hợp đồng là Unit Test (Contract via Tests)**:
   - Mọi logic nghiệp vụ mới đều phải được bao phủ bởi Unit Test.
   - Code chỉ được coi là hoàn thành khi lệnh `go test -v <package>` trả về **PASS (exit code 0)**.
2. **Nghiêm cấm sửa Test (Do Not Tamper With Tests)**:
   - Khi được giao nhiệm vụ implement một hàm để pass bài test đã có sẵn, Subagent **TUYỆT ĐỐI KHÔNG ĐƯỢC PHÉP** sửa file `*_test.go` nhằm mục đích làm cho test pass.
   - Chỉ được sửa đổi file implementation.
3. **Mã nguồn tối thiểu (Minimal Implementation)**:
   - Chỉ viết lượng code vừa đủ để thỏa mãn các điều kiện của Unit Test, không viết tính năng thừa thãi hoặc tự ý phỏng đoán nghiệp vụ ngoài phạm vi test.

---

## 2. NGUYÊN TẮC XỬ LÝ LỖI (ZERO UNCHECKED ERRORS)

1. **Tuyệt đối không bỏ qua lỗi (No Ignored Errors)**:
   - Mọi hàm hoặc method trả về `error` đều **BẮT BUỘC PHẢI ĐƯỢC KIỂM TRA** bằng `if err != nil`.
   - **CẤM** gán error vào blank identifier `_ = someFunc()` hoặc `_, _ = someFunc()`.
   - **CẤM** nuốt lỗi trong block `if err != nil` mà không trả về hoặc không ghi log ngữ cảnh cụ thể.
2. **Bắt buộc bọc lỗi với ngữ cảnh rõ ràng (Wrap with Context)**:
   - Khi chuyển tiếp lỗi, dùng `fmt.Errorf("mô tả hành động thất bại: %w", err)` để giữ nguyên call-chain.
   - Không trả về lỗi mơ hồ kiểu `errors.New("fail")`.

---

## 3. BỘ CÔNG CỤ BẮT BUỘC KIỂM TRA (VERIFICATION TOOLCHAIN)

Trước khi Subagent báo cáo hoàn thành nhiệm vụ, Subagent **BẮT BUỘC** phải tự chạy 3 lệnh sau trên package vừa chỉnh sửa:

### Lệnh 1: Kiểm thử chức năng
```powershell
go test -v ./<path-to-package>/...
```
*(Yêu cầu: 100% Pass, không có bài test nào bị Fail)*

### Lệnh 2: Kiểm tra triệt để lỗi bị bỏ qua (Unchecked / Blank Errors)
Sử dụng công cụ `errcheck` với cờ `-blank` để quét mọi chỗ gán vào `_`:
```powershell
& "C:\Users\ADMIN\go\bin\errcheck.exe" -blank ./<path-to-package>/...
```
*(Yêu cầu: Không có bất kỳ dòng output nào báo lỗi chưa kiểm tra)*

### Lệnh 3: Kiểm tra cấu trúc & chuẩn Go
```powershell
go vet ./<path-to-package>/...
```
*(Yêu cầu: Không có cảnh báo cú pháp)*

> **Nếu bất kỳ lệnh nào trong 3 lệnh trên báo lỗi, Subagent BẮT BUỘC phải tự đọc lỗi, tự sửa code và chạy lại cho đến khi cả 3 đều xanh.**

---

## 4. QUY TRÌNH TRA CỨU TÀI LIỆU (GODOC-FIRST)

1. Không cần nạp toàn bộ context của dự án vào prompt của Subagent.
2. Khi Subagent cần biết signature hoặc tài liệu của hàm/struct, dùng lệnh `go doc`:
   ```powershell
   go doc <package>.<SymbolName>
   # Ví dụ:
   go doc meet-attendance-clean/domain2/lesson.Topic
   go doc meet-attendance-clean/domain2/lesson.NewTopic
   ```
3. Đọc kỹ comment GoDoc được viết sẵn trong file interface/stub để hiểu đúng input, output và invariants trước khi viết code.
