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

---

## 5. QUY ĐỊNH BẮT BUỘC VỀ MODEL AI (MANDATORY MODEL POLICY)

1. **Model Gemini chuẩn hiện tại**:
   - Model Gemini duy nhất được phép sử dụng là **`gemini-3.8-flash`** (`ModelGeminiFlash`).
   - Google đã ngừng cung cấp và chặn truy cập đối với các model cũ (`gemini-3.7-flash`, `gemini-2.5-flash`, `gemini-1.5-flash`, v.v.). **TUYỆT ĐỐI CẤM** gọi hoặc fallback về các model đã bị Google deprecated này.
2. **Quy định về định dạng đầu vào PDF (`application/pdf`)**:
   - Giai đoạn có tài liệu PDF đầu vào (Stage 1 Planner, Stage 2 Authoring khi truyền tài liệu nguồn): **BẮT BUỘC** gọi qua **`gemini-3.8-flash`**.
   - Dòng **Gemma 4** (`gemma-4-31b-it`, `gemma-4-26b-a4b-it`) trên Google GenAI API chỉ nhận trực tiếp Text, Image (PNG/JPEG) và Video (frames); **KHÔNG** hỗ trợ binary blob `application/pdf` (Google API Gateway sẽ trả về `400 INVALID_ARGUMENT`).
3. **Quy định về Fallback**:
   - Khi cần fallback hoặc xử lý các Stage thuần Text/JSON (như Stage 1.75 Polisher, Stage Repairer), chỉ sử dụng các model hợp lệ và không rò rỉ các config không tương thích (`ThinkingConfig` unsupported).

---

## 6. NGUYÊN TẮC CẤU TRÚC FILE GO & PHÂN TÁCH TEST (MODULAR FILE & TEST ORGANIZATION)

1. **Một trách nhiệm - Một file (Single Responsibility File)**:
   - **CẤM** dồn toàn bộ các struct, interface, converters và helpers vào chung một file monolithic duy nhất (như `convertToJepg.go`).
   - Mỗi component / converter / domain service cần nằm ở một file riêng mang tên mô tả rõ ràng trách nhiệm của nó:
     - `interfaces.go`: Định nghĩa các interface giao tiếp chung (`Convert`, `MultiPageConvert`).
     - `detector.go`: Nhận diện định dạng tài liệu (`TypeDetector`).
     - `image_converter.go`: Xử lý chuyển đổi ảnh (`ImageToJPEGConverter`).
     - `pdf_converter.go`: Xử lý chuyển đổi PDF đa trang (`PDFToJPEGConverter`).
     - `docx_converter.go`: Xử lý chuyển đổi Word (`DocxToJPEGConverter`).
     - `converter.go`: Điều phối chuyển đổi tổng hợp (`Converter`) và helper lưu trữ.
2. **Phân tách file Test tương ứng (1-to-1 Test Mapping & Black-box Testing)**:
   - Mỗi file implementation `xyz.go` phải có một file test tương ứng `xyz_test.go` (ví dụ: `detector_test.go`, `image_converter_test.go`, `pdf_converter_test.go`, `docx_converter_test.go`, `converter_test.go`).
   - Các kịch bản kiểm thử tích hợp lớn (Batch Folder Scan, E2E Integration) phải được tách thành file riêng (như `batch_integration_test.go`).
   - Bắt buộc khai báo test theo chuẩn Black-box Testing: `package <pkg>_test` (ví dụ: `package media_test`) để kiểm tra đúng public API và tránh phụ thuộc vào private state.
3. **Mục đích hỗ trợ Debug cho Agent & Developer**:
   - Khi file được chia nhỏ theo đúng trách nhiệm, dung lượng file ngắn gọn (100–300 dòng), Agent và lập trình viên có thể đọc hiểu trọn vẹn ngữ cảnh, xác định vị trí lỗi ngay lập tức, không làm phình context window và giảm thiểu tối đa rủi ro xung đột hoặc hỏng hóc chéo khi refactor.

