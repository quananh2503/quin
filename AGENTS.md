# HƯỚNG DẪN CỐT LÕI DÀNH CHO AI (QUIN + GOA ARCHITECTURE HARNESS)

Tài liệu này là quy chuẩn bắt buộc AI phải luôn ghi nhớ và tuân thủ khi làm việc trên workspace `quin` với bộ kiểm toán kiến trúc **GOA**.

---

## 1. Kiến Trúc Phân Tầng Của QUIN & Nguồn Chân Lý Thực Thi (`make check-ai`)

Dự án `quin` (module `meet-attendance-clean`) phân tầng Clean Architecture như sau:
- **Domain**: `domain2/` (Shared kernel: `domain2/kernel`)
- **Application**: `application2/` (Port contract tests: `application2/porttest/`)
- **Infrastructure**: `infrastructure2/`

Bộ 6 tầng **`make check-ai`** (`Makefile`, `.golangci.yml`, `goa-audit`, `goa-cmdvcr`) là **nguồn chân lý thực thi** cho mọi quy chuẩn kiến trúc và kiểm thử:
1. `make lint` (`golangci-lint`: `depguard`, `funlen`, `errcheck`, `errorlint`, `gocritic`, `bodyclose`, `noctx`, `nilerr`, `nilnil`, `revive`, `unparam`, `unused`, `wrapcheck`)
2. `make audit` (`goa-audit`: **57 luật kiểm toán** kiến trúc, policy & test boundary, gồm `infra/adapter-no-branching-math`, `infra/driver-no-policy-math`, `infra/no-raw-exec`, `infra/policy-pure-functions`, `infra/no-orphan-policy`, `infra/driver-resilience-requires-policy`, `infra-test/driver-no-raw-exec`, `infra-test/http-driver-uses-vcr`, `infra-test/cli-driver-uses-cmdvcr`)
3. `make verify-cassettes` (`goa-cmdvcr verify -require-version`: kiểm tra schema v1, checksum, không rò secret và cấm wildcard mù `*` / `{{any}}`)
4. `make ratchet` (Test Sans-I/O thuần trên RAM: `policy`, `encode`, `process`, `decode`, `application2/porttest`)
5. `make test-race` (`go test -race -shuffle=on`)
6. `make build-check` (Đảm bảo `domain2`, `application2`, và package `infrastructure2/<pkg>` biên dịch & pass test)
- Kiểm tra chất lượng assertion bằng Mutation Testing: `make mutate [TARGET=<pkg>] [DIFF=<commit>]` (`gremlins` trên `policy`, `encode`, `process`, `decode` với ngưỡng `Test efficacy >= 70%`, `Mutator coverage >= 75%`).
- Kiểm tra môi trường runtime thật (tùy chọn `//go:build live`): `make test-live`.

---

## 2. Kiến Trúc Bất Biến Của Package Infrastructure (Lồng Package & Cô Lập Trình Biên Dịch)

Mọi package trong `infrastructure2/<ten_package>/` chỉ có **1 mục đích tồn tại duy nhất**:
> Nhận yêu cầu từ tầng Application (qua Port Interface), giao tiếp với hệ thống vật lý bên ngoài, và trả về đối tượng nghiệp vụ thông qua hàm khởi tạo `domain2.*.New...()` (hoặc `Reconstitute...()`).

Cấu trúc thư mục BẮT BUỘC:

```text
infrastructure2/<ten_package>/
├── adapter.go / adapter_<context>.go   # Mặt tiền DUY NHẤT (0 toán tử <, >, ++, *, switch, classic for)
├── adapter_test.go                     # Offline Pipe Contract (application2/porttest.Verify*Contract)
├── adapter_live_test.go                # (Tùy chọn //go:build live) 1 Happy Path kiểm tra Runtime thật
└── internal/                           # HỘP KHÓA Go compiler: ngoài <ten_package>/ không import được
    ├── raw/                            # 0. DTO dữ liệu thuần (0 func, 0 method)
    ├── policy/                         # 1. (Tùy chọn) Luật kỹ thuật hạ tầng (100% Pure Funcs, 0 struct/interface)
    ├── driver/                         # 2. Client 1-shot + Thin Decorator Wrapper (gọi policy, 0 os/exec)
    ├── encode/                         # 3. Chiều đi (Sans-I/O, stateless): Domain/Input ──► raw
    ├── process/                        # 4. Trung gian (Sans-I/O, stateless): Raw ──► raw (+ testdata/fixtures/)
    └── decode/                         # 5. Chiều về ACL (Sans-I/O, stateless): raw ──► Domain
```

* **Tài nguyên tĩnh (Static Assets)**: Prompt hoặc template dài > 50 dòng có thể đặt trong `assets/` bên trong stage sử dụng chúng (ví dụ `internal/encode/assets/`) và nạp qua `//go:embed`.
* **Phép Thử Ranh Giới & `internal/policy` (Swap-Vendor Litmus Test)**:
  * Trước khi viết bất kỳ nhánh ngưỡng/đếm/trạng thái (`<`, `<=`, `>`, `>=`, `++`, `*`, `/`, `%`, `switch`) nào: tự hỏi *"Nếu mai thay công cụ/vendor bằng công cụ khác hoặc In-Memory, luật này còn tồn tại không?"*. Nếu **CÒN** $\rightarrow$ thuộc `domain2` hoặc `application2`. Nếu **BIẾN MẤT THEO CÔNG CỤ** (retry/backoff, khóa/xoay API key, clamp kích thước ảnh Vision, circuit breaker vòng lặp hạ tầng, chuẩn hóa config worker/pool) $\rightarrow$ tách làm **Pure Function trong `internal/policy`**!
  * **`internal/policy`**: **100% Pure Stateless Functions (`0 struct`, `0 method`, `0 interface`)**, chỉ dùng `internal/raw` DTO, truyền `now time.Time` qua tham số, CẤM I/O / `context.Context` / `domain2` / `application2`, và mọi hàm export đều **bắt buộc được `driver` hoặc `adapter` sử dụng thật** (`infra/no-orphan-policy`). Có thể truyền pure function từ `policy` qua function value (Strategy) cho Decorator Wrapper trong `driver`.
* **CẤM TUYỆT ĐỐI**:
  * Tạo file không bắt đầu bằng `adapter` ở thư mục gốc `infrastructure2/<ten_package>/`.
  * Tạo thư mục/package con dưới `infrastructure2/<ten_package>/` khác `internal/`.
  * Tạo package con dưới `internal/` ngoài 6 tên chuẩn `{raw, policy, driver, encode, process, decode}`.
  * Import chéo ngang sang package anh em khác trong `infrastructure2/*`.
  * Import chéo ngang giữa `policy`, `encode`, `process`, `decode` (chỉ được import `internal/raw`). Riêng `internal/driver` được phép import `{internal/raw, internal/policy}` (cấm import `encode`/`process`/`decode`).
  * Import `os/exec` hoặc `syscall` trong `infrastructure2/**` (`infra/no-raw-exec`) — mọi lệnh CLI đi qua `goa/pkg/cmdvcr` (dùng `cmdvcr.LookPath`, `cmdvcr.OSRunner`, và `OSRunner.Run` bị chặn cứng khi `testing.Testing() == true`).
  * Viết toán tử `<, <=, >, >=, ++, --, +, -, *, /, %, switch, classic for` trong `adapter*.go` (`infra/adapter-no-branching-math`), hoặc `++, --, *, /, %, <`/`>` khác `0` trong `internal/driver` (`infra/driver-no-policy-math`).

---

## 3. Ma Trận Cô Lập & Ngưỡng Cứng (Hard Thresholds)

| Package | Vai trò | Được import | CẤM tuyệt đối |
| :--- | :--- | :--- | :--- |
| **`<ten_package>` (`adapter*.go`)** | Nối ống tuyến tính & Port Decorator | `domain2`, `internal/{raw,policy,driver,encode,process,decode}` | I/O trực tiếp (`os`, `net`, `database/sql`, `syscall`), `application2`, infra anh em, **0 toán tử `<, >, ++, +, -, *, /, %, switch`, classic `for`**. Hàm/method ≤ **50 dòng**; struct ≤ **4 fields**; export ≤ **4 symbols**. |
| **`internal/raw`** | DTO dữ liệu trung chuyển | stdlib thuần dữ liệu | **0 function, 0 method**. Cấm SDK bên thứ ba (`*.*/**`), `domain2`, `application2`, `os`, `net`, `io`, `context`, `sync`, `reflect`, `unsafe`, `runtime`, `embed`, `html/template`, `text/template`, `database/sql`, `syscall`. |
| **`internal/policy`** *(Tùy chọn)* | Luật kỹ thuật hạ tầng 100% Pure RAM | `internal/raw`, stdlib thuần | **0 struct, 0 method, 0 interface**, CẤM `domain2`, `application2`, SDK bên thứ ba (`*.*/**`), I/O, ambient clock (`time.Now`, `time.Sleep`...), `context.Context`, `driver`/`encode`/`process`/`decode`. Export ≤ **5 symbols**; cấm hàm mồ côi (`infra/no-orphan-policy`). |
| **`internal/driver`** | Base 1-shot I/O & Thin Decorator Wrapper (`HTTP`, `KeyPool`, `Retry`) | `internal/raw`, **`internal/policy`**, `cmdvcr`, SDK I/O, stdlib | Cấm `os/exec`, `syscall`, `domain2`, `application2`, `encode`/`process`/`decode`, **cấm `++`, `--`, `*`, `/`, `%`, so sánh khác `0`**. Nếu dùng timer/sync/atomic bắt buộc gọi `internal/policy`. Struct ≤ **4 fields**. |
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
3. **100% Exported Sans-I/O Coverage**: Mọi hàm export trong `policy`, `encode`, `process`, `decode` phải được gọi trực tiếp từ `Test*` (và đạt ngưỡng `make mutate`).
4. **Kỹ thuật Mối Hàn Vàng (Golden Seam)** ở `internal/process`:
   - Đặt fixture thật trong `internal/process/testdata/fixtures/`.
   - `internal/process/*_test.go` bắt buộc nhúng bằng `//go:embed testdata/fixtures/...` (CẤM import `os`, `net/http`, `httptest`, `mock`).
   - `internal/process/*_test.go` bắt buộc có ít nhất 1 `Fuzz*(f *testing.F)` trực tiếp gọi hàm của `internal/process`.
5. **Ranh giới Test `internal/driver`**:
   - Dùng hộp cát vật lý (`httptest.NewServer`, `t.TempDir`), CẤM import `domain2`/`application2`.
   - **HTTP API** (`net/http`): dùng `gopkg.in/dnaeon/go-vcr.v4` (`ModeReplayOnly` trong test/CI; `BeforeSaveHook` xóa secret + `WithIgnoreAuthorization()`).
   - **CLI bên ngoài**: **CẤM gọi `os/exec` trực tiếp trong cả `driver` lẫn `driver/*_test.go`** (`OSRunner.Run` chặn cứng trong `go test`); dùng `cmdvcr.LookPath` và trong test replay dùng `cmdvcr.NewRecorder("../process/.../testdata/fixtures/cassettes/...", cmdvcr.WithMode(cmdvcr.ModeReplayOnly), cmdvcr.WithWorkDir(...))` (mặc định `ExactMatcher` với token chuẩn hóa `<WORKDIR>`/`<HOME>`/`<TMPDIR>`/`<REDACTED>`/`<DYN:<tên>>`; cấm wildcard mù `*` / `{{any}}`).
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

## 6. Bảng Phân Tuyến 3 Luồng & Quy Trình Staged Test-First (Bắt Buộc)

Tùy tính chất công việc (viết mới hay sửa trên code đã có), chọn đúng **1 trong 3 Luồng** sau — nhưng mọi luồng đều bắt buộc qua đủ **1 Cổng Nghiệm Thu Harness duy nhất (`make check-ai`)**:

| Luồng | Khi nào dùng | Các bước LÀM | Các bước BỎ QUA | Tách Subagent Implementer? |
| :--- | :--- | :--- | :--- | :--- |
| **Luồng 1: Viết mới / Đập xây lại** *(Greenfield)* | Tạo package infra mới hoàn toàn | Đủ **4 giai đoạn (0 → 1 → 2 → 3)** bên dưới (`record` → `raw` + `scaffold-infra` → 5 file test RED + khóa `SPEC_REF` → Subagent Implementer + `test-lock-check` + `check-ai` + `mutate`) | Không bỏ bước nào | **Bắt buộc** |
| **Luồng 2: Sửa Bug / Thêm Case / Đổi Logic** *(Brownfield — 80% hằng ngày)* | Sửa bug, thêm cờ CLI, thêm case lỗi API trên code đã có | 1. Đọc cục bộ file/test liên quan + chạy `make check-ai` lấy mốc.<br>2. *Chỉ* chạy `record` thêm cassette nếu cờ/output CLI hoặc payload HTTP đổi (bỏ qua nếu bug thuần RAM).<br>3. *Prove-It RED Test*: thêm/siết đúng test case tái hiện → thấy **RED** → khóa `SPEC_REF`.<br>4. Sửa tối thiểu code gây RED → `make test-lock-check` → `make check-ai` → `make mutate TARGET=<pkg> DIFF=<commit>`. | Bỏ `scaffold-infra`, bỏ quay lại cassette cũ không đổi, bỏ viết lại 5 file test, bỏ `mutate` toàn repo | **Bắt buộc** nếu logic phức tạp/nhiều nhánh (bug 1–2 dòng hiển nhiên có thể sửa trực tiếp nhưng vẫn qua đủ `check-ai` + `mutate DIFF`) |
| **Luồng 3: Siết Test / Đổi Cassette / Refactor Thuần** *(Không đổi hành vi)* | Nâng cassette sang `<WORKDIR>`, tách hàm quá 50 dòng | • **Refactor thuần**: khóa test cũ (`SPEC_REF=HEAD`) → refactor → `make test-lock-check` + `make check-ai`.<br>• **Siết test/cassette**: record mới + siết test → `make check-ai` (nếu lòi **RED** thật → chuyển sang **Luồng 2**). | Bỏ `scaffold-infra`; bỏ viết test mới khi refactor thuần | Không cần (test cũ đã khóa làm lưới an toàn) |

### Chi Tiết 4 Giai Đoạn (Luồng 1 — Greenfield)

Thay vì để 1 agent vừa tự ra đề test dễ vừa tự viết code cắt bớt nghiệp vụ, bắt buộc vận hành **4 Giai Đoạn Tuyến Tính** kết hợp **tách vai Agent (Spec/Test Agent ≠ Implementer Agent)**:

0. **Giai Đoạn 0 — Trinh Sát & Đóng Băng Bằng Chứng Thật (`testdata/fixtures/`)**:
   - Đọc đầy đủ 100% nghiệp vụ/flag thực tế trước khi thiết kế (`<tool> --help` hoặc file nguồn cũ).
   - Thu thập bằng chứng thật bằng đúng công cụ (không sửa tay YAML cassette):
     * **HTTP API**: Quay bằng `gopkg.in/dnaeon/go-vcr.v4` (`BeforeSaveHook` xóa secret + `WithIgnoreAuthorization()`).
     * **CLI bên ngoài (`os/exec`)**: Quay bằng `/home/quanan/Projects/goa/bin/goa-cmdvcr record` vào `internal/process/.../testdata/fixtures/cassettes/*.yaml`, xác thực ngay bằng `goa-cmdvcr verify -require-version`.
     * **Dữ liệu nội bộ**: Đóng băng payload mẫu thật vào `internal/process/testdata/fixtures/`.
1. **Giai Đoạn 1 — Chốt `internal/raw` & Dựng Khung Stub (Compile Xanh)**:
   - Chốt toàn bộ DTO dữ liệu thuần trong `internal/raw/` (`0 func, 0 method`) từ cassette/fixture thật.
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
     2. `make check-ai` (6 tầng `lint`, `audit` 49 rules, `verify-cassettes`, `ratchet`, `test-race`, `build-check` xanh 100%).
     3. `make fmt-layout-check` (`reordered=0`).
     4. `make mutate [TARGET=<pkg>] [DIFF=<commit>]` (`gremlins` ≥ 70% efficacy, ≥ 75% mcover trên Sans-I/O).

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
