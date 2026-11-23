# HƯỚNG DẪN CỐT LÕI DÀNH CHO AI (QUIN + GOA ARCHITECTURE HARNESS)

Tài liệu này là quy chuẩn bắt buộc AI phải luôn ghi nhớ và tuân thủ khi làm việc trên workspace `quin` với bộ kiểm toán kiến trúc **GOA**.

---

## 1. Kiến Trúc Phân Tầng Của QUIN & Nguồn Chân Lý Thực Thi (`make check-ai`)

Dự án `quin` (module `meet-attendance-clean`) phân tầng Clean Architecture như sau:
- **Domain**: `domain2/` (Shared kernel: `domain2/kernel`)
- **Application**: `application2/` (Port contract tests: `application2/porttest/`)
- **Infrastructure**: `infrastructure2/`

Bộ 5 tầng **`make check-ai`** (`Makefile`, `.golangci.yml`, `goa-audit`) là **nguồn chân lý thực thi** cho mọi quy chuẩn kiến trúc và kiểm thử:
1. `make lint` (`golangci-lint`: `depguard`, `funlen`, `errcheck`, `errorlint`, `gocritic`, `bodyclose`, `noctx`, `nilerr`, `nilnil`, `revive`, `wrapcheck`, `unused`)
2. `make audit` (`goa-audit`: 46 luật kiểm toán kiến trúc & test boundary)
3. `make ratchet` (Test Sans-I/O thuần trên RAM: `encode`, `process`, `decode`, `application2/porttest`)
4. `make test-race` (`go test -race -shuffle=on`)
5. `make build-check` (Đảm bảo `domain2`, `application2`, và package `infrastructure2/<pkg>` biên dịch & pass test)

---

## 2. Kiến Trúc Bất Biến Của Package Infrastructure (Lồng Package & Cô Lập Trình Biên Dịch)

Mọi package trong `infrastructure2/<ten_package>/` chỉ có **1 mục đích tồn tại duy nhất**:
> Nhận yêu cầu từ tầng Application (qua Port Interface), giao tiếp với hệ thống vật lý bên ngoài, và trả về đối tượng nghiệp vụ thông qua hàm khởi tạo `domain2.*.New...()` (hoặc `Reconstitute...()`).

Cấu trúc thư mục BẮT BUỘC:

```text
infrastructure2/<ten_package>/
├── adapter.go / adapter_<context>.go   # Mặt tiền DUY NHẤT (chỉ cho phép file prefix adapter*)
├── adapter_test.go                     # Gọi application2/porttest.Verify*Contract
└── internal/                           # HỘP KHÓA Go compiler: ngoài <ten_package>/ không import được
    ├── raw/                            # 0. DTO dữ liệu thuần (0 func, 0 method)
    ├── driver/                         # 1. Client/Connection vật lý & Wrapper (HTTP/Pool/Retry/KeyPool)
    ├── encode/                         # 2. Chiều đi (Sans-I/O, stateless): Domain/Input ──► raw
    ├── process/                        # 3. Trung gian (Sans-I/O, stateless): Raw ──► raw (+ testdata/fixtures/)
    └── decode/                         # 4. Chiều về ACL (Sans-I/O, stateless): raw ──► Domain
```

* **Tài nguyên tĩnh (Static Assets)**: Prompt hoặc template dài > 50 dòng có thể đặt trong `assets/` bên trong stage sử dụng chúng (ví dụ `internal/encode/assets/`) và nạp qua `//go:embed`.
* **CẤM TUYỆT ĐỐI**:
  * Tạo file không bắt đầu bằng `adapter` ở thư mục gốc `infrastructure2/<ten_package>/`.
  * Tạo thư mục/package con dưới `infrastructure2/<ten_package>/` khác `internal/` (cấm `deepseek/`, `gemini/`, `keys/`, `pipeline/`, `tools/` ở cấp trực tiếp dưới `<ten_package>/`).
  * Tạo package con dưới `internal/` ngoài 5 tên chuẩn `{raw, driver, encode, process, decode}` (mỗi stage có thể chia subpackage nếu cần, trừ giới hạn file/export).
  * Import chéo ngang sang package anh em khác trong `infrastructure2/*` (ví dụ `infrastructure2/AI` **CẤM** import `infrastructure2/media` hay `infrastructure2/database`; nếu cần dependency như chuyển đổi media, nhận qua interface nhỏ tại constructor ở `adapter.go` hoặc để tầng `application2`/`main.go` điều phối!).
  * Import chéo ngang giữa `driver`, `encode`, `process`, `decode` (chỉ được import `internal/raw`).

---

## 3. Ma Trận Cô Lập & Ngưỡng Cứng (Hard Thresholds)

| Package | Vai trò | Được import | CẤM tuyệt đối |
| :--- | :--- | :--- | :--- |
| **`<ten_package>` (`adapter*.go`)** | Mặt tiền điều phối Port | `domain2`, `internal/{raw,driver,encode,process,decode}` | I/O trực tiếp (`os`, `net`, `database/sql`, `syscall`), `application2`, infra anh em. Hàm/method ≤ **50 dòng**; struct ≤ **4 fields**; export ≤ **4 symbols**. |
| **`internal/raw`** | DTO dữ liệu trung chuyển | stdlib thuần dữ liệu | **0 function, 0 method**. Cấm SDK bên thứ ba (`*.*/**`), `domain2`, `application2`, `os`, `net`, `io`, `context`, `sync`, `reflect`, `unsafe`, `runtime`, `embed`, `html/template`, `text/template`, `database/sql`, `syscall`. |
| **`internal/driver`** | Client vật lý & Wrapper (`HTTP`, `KeyPool`, `Retry`) | `internal/raw`, SDK I/O, stdlib | Cấm `domain2`, `application2`, `encode`/`process`/`decode`. Struct ≤ **4 fields**. |
| **`internal/encode`** | Chiều đi 100% Sans-I/O | `internal/raw`, `domain2` (≤ 1 Aggregate/file, trừ `domain2/kernel`) | Cấm `driver`/`process`/`decode`, SDK bên thứ ba (`*.*/**`), I/O (`os`, `net` trừ `net/url`,`net/netip`,`net/mail`, `database/sql`, `syscall`), ambient clock (`time.Now`, `time.Sleep`...), **0 method trên struct**, **cấm `context.Context`**, export ≤ **5 symbols**. |
| **`internal/process`** | Gia công/Sanitize/Parse/Verify dữ liệu thô 100% Sans-I/O | `internal/raw`, parser/schema libs | Cấm `domain2`, `application2`, `driver`/`encode`/`decode`, I/O, ambient clock, **0 method**, **cấm `context.Context`**, export ≤ **5 symbols**. |
| **`internal/decode`** | Chốt chặn ACL 100% Sans-I/O (`raw` → `domain2.*.New*`) | `internal/raw`, `domain2` (≤ 1 Aggregate/file, bắt buộc gọi `New*`/`Reconstitute*`) | Cấm `driver`/`encode`/`process`, SDK bên thứ ba (`*.*/**`), I/O, ambient clock, **0 method**, **cấm `context.Context`**, export ≤ **5 symbols**. |

### Ngưỡng Cứng Bắt Buộc
1. **Hàm ở `adapter*.go`**: ≤ **50 dòng**. Hàm ở các file khác: ≤ **80 dòng / 50 statements** (`funlen`).
2. **Số file non-test / package**: ≤ **12 file `.go`**.
3. **Bề mặt Export**: Root ≤ **4 symbols**; mỗi package trong `encode`/`process`/`decode` ≤ **5 symbols**.
4. **Struct Fields**: ≤ **4 fields** trên mọi struct ở root và `internal/driver`.
5. **Layout**: `const`/`var` đặt ở đầu file hoặc sát type sở hữu; pure field getter đặt sau các non-getter methods của cùng struct (`make fmt-layout`).

---

## 4. Quy Chuẩn Kiểm Thử Hạ Tầng Sans-I/O & 14 Luật Test Tự Động (`infra-test/*`)

1. **Black-Box 100%**: Mọi `*_test.go` trong `infrastructure2/**` bắt buộc dùng `package <stage>_test`.
2. **Bắt buộc có test ở mọi package logic**: Mọi adapter và stage (trừ `internal/raw`) phải có ít nhất 1 `Test*(t *testing.T)` trực tiếp gọi hàm/method export của package đó.
3. **100% Exported Sans-I/O Coverage**: Mọi hàm export trong `encode`, `process`, `decode` phải được gọi trực tiếp từ `Test*`.
4. **Kỹ thuật Mối Hàn Vàng (Golden Seam)** ở `internal/process`:
   - Đặt fixture thật trong `internal/process/testdata/fixtures/`.
   - `internal/process/*_test.go` bắt buộc nhúng bằng `//go:embed testdata/fixtures/...` (CẤM import `os`, `net/http`, `httptest`, `mock`).
   - `internal/process/*_test.go` bắt buộc có ít nhất 1 `Fuzz*(f *testing.F)` trực tiếp gọi hàm của `internal/process`.
5. **Ranh giới Test `internal/driver`**:
   - Dùng hộp cát vật lý (`httptest.NewServer`, `t.TempDir`), CẤM import `domain2`/`application2`.
   - Bắt buộc gọi `defer goleak.VerifyNone(t)` (`go.uber.org/goleak`).
   - Bắt buộc test `context.WithCancel` / `context.WithTimeout` nếu driver nhận `context.Context`.
6. **Ranh giới Test `internal/decode` & Projection `internal/encode`**:
   - `decode_test.go` phải kiểm chứng trực tiếp hành vi/invariant của đối tượng `domain2` trả về.
   - Nếu `encode` import `domain2`, `encode_test.go` phải khởi tạo đối tượng `domain2` thật.
7. **Port Contract Test (`application2/porttest`)**:
   - Định nghĩa bộ kiểm thử hợp đồng `Verify<Port>Contract` trong `application2/porttest/` (pure in-memory/contract, không phụ thuộc `infrastructure2`).
   - `adapter_test.go` bắt buộc gọi `porttest.Verify*Contract(...)`.

---

## 5. Quy Định Bắt Buộc Về Model AI Trong Mã Nguồn QUIN

- Model Gemini hợp lệ duy nhất trong code QUIN là **`gemini-3.8-flash`** (cấm fallback về `gemini-2.5-flash` / `gemini-1.5-flash`).
- Xử lý lỗi nghiêm ngặt: mọi `error` phải được kiểm tra (`errcheck -blank`) và bọc ngữ cảnh rõ ràng (`wrapcheck`).

---

## 6. Quy Trình 4 Giai Đoạn Staged Test-First & Tách Vai Clean-Room (Bắt Buộc)

Thay vì để 1 agent vừa tự ra đề test dễ vừa tự viết code cắt bớt nghiệp vụ, bắt buộc vận hành **4 Giai Đoạn Tuyến Tính** kết hợp **tách vai Agent (Spec/Test Agent ≠ Implementer Agent)**:

0. **Giai Đoạn 0 — Trinh Sát & Đọc Đủ 100% Nghiệp Vụ Cũ + Đóng Băng Fixture (`testdata/fixtures/`)**:
   - Đọc đầy đủ 100% file nguồn và test cũ của package mục tiêu trước khi xóa hay thiết kế lại.
   - Đóng băng payload mẫu thật vào `internal/process/testdata/fixtures/` (và đồng bộ với `driver_test.go` theo kỹ thuật Mối Hàn Vàng).
1. **Giai Đoạn 1 — Chốt `internal/raw` & Dựng Khung Stub (Compile Xanh)**:
   - Chốt toàn bộ DTO dữ liệu thuần trong `internal/raw/` (`0 func, 0 method`).
   - Dựng khung chữ ký hàm stub trả `errors.New("TODO: not implemented")` cho `adapter*.go` và các stage `driver`, `encode`, `process`, `decode` (có thể chia subpackage bên trong từng stage để vừa giữ 100% nghiệp vụ vừa đảm bảo mỗi package ≤ 5 exported symbols và ≤ 12 files).
2. **Giai Đoạn 2 — Viết & Khóa Cứng Bộ Test 5 Chốt Chặn (Trạng Thái RED)**:
   - Viết đầy đủ 5 lớp test black-box theo **Ma Trận Checklist Mục 7** bên dưới + `application2/porttest/` (có cả happy path lẫn error path) + E2E loopback test ở `adapter_test.go` kiểm chứng đầy đủ từng Phase điều phối.
   - Chạy `make lint && make audit` để xác nhận bộ test vượt 100% quy chuẩn kiến trúc (`infra-test/*` và `depguard`).
   - Khóa cứng toàn bộ file test & fixture bằng staging area:
     `git add 'infrastructure2/AI/*_test.go' 'infrastructure2/AI/**/*_test.go' 'infrastructure2/AI/**/testdata/**' 'application2/porttest/**'`
3. **Giai Đoạn 3 — Gọi Subagent Implementer Con Độc Lập Làm Xanh & Nghiệm Thu**:
   - Gọi một **Subagent Implementer con với context mới tinh** (chỉ giao: đọc `AGENTS.md`, triển khai code sản xuất trong `infrastructure2/AI/` và wiring `main.go` cho tới khi `make check-ai` xanh 100%, **TUYỆT ĐỐI CẤM** sửa bất kỳ file `*_test.go`, `**/testdata/**`, hay `application2/porttest/**` nào).
   - Sau khi Implementer hoàn tất, Orchestrator nghiệm thu bắt buộc:
     1. `make test-lock-check SPEC_REF=STAGED TARGET=infrastructure2/AI` (chứng minh 0 file test/fixture bị chỉnh sửa trong Pha Implement).
     2. `make check-ai` (5 tầng `lint`, `audit` 46 rules, `ratchet`, `test-race`, `build-check` xanh 100%).
     3. `make fmt-layout-check` (`reordered=0`).

---

## 7. Ma Trận Checklist Bao Phủ 100% Cho 5 Lớp Test (Universal Coverage Matrix)

1. **`internal/encode/*_test.go` (`package <pkg>_test`) — Bảng Hoán Vị Đầu Vào (Input Permutation)**:
   - *Full Payload*: Đủ tài liệu text + ảnh multimodal thật (`image_url` base64 đầy đủ, không cắt cụt) + schema JSON thật + user prompt.
   - *Minimal / Zero-Value*: Bỏ trống trường optional (`model == ""`, `userPrompt == ""`).
   - *Boundary & Escaping*: Ký tự đặc biệt, Unicode toán học, model variant (`chat` vs `flash`/`reasoner`).
   - *Collection Edges*: 0, 1, N tài liệu / câu hỏi phân bổ.
   - *Invalid Input*: Input thiếu bắt buộc báo lỗi ngay trong RAM.
2. **`internal/driver/*_test.go` (`package driver_test`) — Hộp Cát Vật Lý & Cơ Học**:
   - *Physical Happy Path & Capture*: `httptest.NewServer` kiểm tra header, payload JSON thật (gồm multimodal `image_url`), đối chiếu fixture `../process/testdata/fixtures/`.
   - *Context Cancellation & Timeout*: `context.WithCancel` / `context.WithTimeout` dừng ngay, trả lỗi chuẩn.
   - *Transient Fault & Retry*: Giả lập 429 / 500 / 503 ở 1–2 lần đầu → tự retry thành công + xoay vòng `KeyPool`.
   - *Permanent Fault & Fast-Fail*: 400 / 401 hoặc API key rỗng → dừng ngay ở lần đầu, không retry lãng phí.
   - *Resource Cleanup & Concurrency*: `defer goleak.VerifyNone(t)` + test `KeyPool` cooldown/auto-disable & `CallParallel` dưới `-race` (kể cả khi 1 worker lỗi giữa chừng).
3. **`internal/process/*_test.go` (`package <pkg>_test`) — Lọc Rác Đa Hình + Fuzzing**:
   - *Standard Extraction*: Nạp fixture thật qua `//go:embed testdata/fixtures/*`.
   - *High-Noise / Filtering*: Markdown fence, text thừa ngoài JSON, `<think>...</think>`, LaTeX unescaped, mã ASCII rác (`\f`, `\b`, `\v`, `\x0Dightarrow`, `\x0Aeq`).
   - *Malformed / Corrupted*: JSON cụt (cắt giữa chuỗi/ngoặc), JSON hỏng hoàn toàn trả lỗi rõ ràng, không panic.
   - *Audit & Repair Semantics*: Test `AuditMathField`/`AuditTopicContent` (dấu `$` lẻ, LaTeX trần ngoài `$`, ASCII rác), `ExtractContextField`/`SetContextField`, `ExtractCompilerErrorAnchors`, `LaTeXToMiTeX`.
   - *Go Fuzzing (`Fuzz*`)*: Ít nhất 1 hàm `Fuzz*(f *testing.F)` gọi trực tiếp hàm trong `process`.
4. **`internal/decode/*_test.go` (`package <pkg>_test`) — Đột Biến Phá Luật Domain**:
   - *Valid Reconstitution*: DTO đầy đủ (`TheoryPoints`, `ClozeFormula`, `CalloutTip`, `Variants`, `Examples`, `Drills`, `ShortAnswers`, `AnswerKey`) → đúc thành công `*lesson.Lesson` và assert sâu nội dung từng Block & Exercise.
   - *Domain Invariant Rejections*: Đột biến từng trường bắt buộc (`materials` rỗng, field rỗng) → trả lỗi Domain.
   - *Lossless Conversion*: Kiểm tra `FormatStepSolution` / `SplitStepLines` và chế độ fallback `PlanToLesson`.
5. **`adapter*_test.go` (`package ai_test`) & `application2/porttest/` — Port Contract + E2E Loopback Full-Pipeline**:
   - `application2/porttest.VerifyLessonGeneratorContract`: Kiểm chứng CẢ **Happy Path** (trả `*lesson.Lesson` hợp lệ thỏa mãn invariants) LẪN **Error Paths** (`materials` rỗng, `ctx` cancel).
   - **E2E Loopback Test trong `adapter_test.go`**: Dựng `httptest.NewServer` phân biệt rõ request từng Phase, xác nhận `adapter.Generate(...)` chạy **đủ chuỗi Phase theo đúng thứ tự**:
     `Phase 0 (Convert Media -> JPEG)` → `Phase 1A (Harvester kèm ảnh multimodal image_url thật)` → `Phase 1B (Curriculum Planner dùng Inventory + JSON Schema thật)` → `Phase 1.5 (Verifier kiểm tra UnassignedIDs)` → `Phase 2 (Parallel Topic Generator kèm ảnh + assigned questions)` → `Phase 3 (Repairer Audit + RepairMath/SanitizeLaTeX khi có lỗi toán)` → `Phase 4/5 (Assemble/Decode ra *lesson.Lesson đầy đủ nội dung & Typst khi yêu cầu)`.
