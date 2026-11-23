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
