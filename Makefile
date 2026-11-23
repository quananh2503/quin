.PHONY: all lint lint-fix audit ratchet test-race deadcode build-check verify check-ai test scaffold-infra test-lock-check fmt-layout fmt-layout-check

GOLANGCI_LINT := $(shell which golangci-lint 2>/dev/null || echo $(HOME)/go/bin/golangci-lint)
GOA_BIN := /home/quanan/Projects/goa/bin
TARGET_INFRA ?= infrastructure2/AI

all: verify

# TẦNG 1: Phân tích tĩnh & Biên giới kiến trúc (depguard, funlen, gocritic, wrapcheck, revive)
lint:
	@echo "🔍 [TẦNG 1/5] Đang kiểm tra Phân Tích Tĩnh & Biên Giới Kiến Trúc ($(TARGET_INFRA))..."
	@PKGS="./$(TARGET_INFRA)/..."; [ -d application2/porttest ] && PKGS="$$PKGS ./application2/porttest/..."; \
		$(GOLANGCI_LINT) run $$PKGS
	@echo "✅ [TẦNG 1/5] Linter & Kiến Trúc đạt chuẩn 100%!"

lint-fix:
	@PKGS="./$(TARGET_INFRA)/..."; [ -d application2/porttest ] && PKGS="$$PKGS ./application2/porttest/..."; \
		$(GOLANGCI_LINT) run --fix $$PKGS

# TẦNG 2: Kiểm toán kiến trúc Pure DDD & Lồng Package (goa-audit)
audit:
	@echo "🏛️  [TẦNG 2/5] Đang chạy Kiểm Toán Kiến Trúc (goa-audit)..."
	@PKGS="./$(TARGET_INFRA)/..."; [ -d application2/porttest ] && PKGS="$$PKGS ./application2/porttest/..."; \
		$(GOA_BIN)/goa-audit -dir . -domain-dir domain2 -app-dir application2 -infra-dir infrastructure2 -shared-kernel kernel -pkg "$$PKGS"
	@echo "✅ [TẦNG 2/5] Kiến trúc đạt chuẩn 100%!"

# TẦNG 3: Kiểm Thử Sans-I/O trên RAM theo từng package vai trò
ratchet:
	@echo "🔒 [TẦNG 3/5] Đang chạy Kiểm Thử Sans-I/O trên RAM..."
	@PKGS=""; \
		[ -d application2/porttest ] && PKGS="$$PKGS ./application2/porttest/..."; \
		for d in $(TARGET_INFRA)/internal/encode $(TARGET_INFRA)/internal/process $(TARGET_INFRA)/internal/decode; do \
			[ -d "$$d" ] && PKGS="$$PKGS ./$$d/..."; \
		done; \
		test -n "$$PKGS" || (echo "❌ Không tìm thấy package Sans-I/O (internal/{encode,process,decode}) trong $(TARGET_INFRA)"; exit 1); \
		go test $$PKGS
	@echo "✅ [TẦNG 3/5] Kiểm Thử Sans-I/O trên RAM vượt qua!"

# TẦNG 4: Kiểm Thử Cơ Học, Đồng Thời & Rò Rỉ Goroutine (-race -shuffle=on)
test-race:
	@echo "⚡ [TẦNG 4/5] Đang kiểm tra Đồng Thời, Hộp Cát Vật Lý & Rò Rỉ Goroutine (-race -shuffle=on)..."
	@PKGS="./$(TARGET_INFRA)/..."; [ -d application2/porttest ] && PKGS="$$PKGS ./application2/porttest/..."; \
		go test -race -shuffle=on $$PKGS
	@echo "✅ [TẦNG 4/5] Đồng thời & Rò rỉ an toàn tuyệt đối!"

# TẦNG 5: Kiểm tra biên dịch caller (application2, domain2, main.go) & Dead Code
build-check:
	@echo "🔧 [TẦNG 5/5] Đang kiểm tra biên dịch toàn bộ caller (domain2, application2, $(TARGET_INFRA))..."
	@go build ./domain2/... ./application2/... ./$(TARGET_INFRA)/...
	@go test ./application2/... ./domain2/...
	@echo "✅ [TẦNG 5/5] Biên dịch & Test Domain/Application xanh 100%!"

deadcode:
	@echo "🧹 Đang quét Dead Code trên $(TARGET_INFRA)..."
	@go run golang.org/x/tools/cmd/deadcode@latest -test ./$(TARGET_INFRA)/...

# ĐƯỜNG GĂNG THỬ LỬA TOÀN DIỆN (THE GO HARNESS GAUNTLET)
verify: lint audit ratchet test-race build-check
	@echo ""
	@echo "================================================================================"
	@echo "🎉 TOÀN BỘ ĐƯỜNG GĂNG HARNESS GAUNTLET ĐÃ QUA 100%! CODE AN TOÀN ĐỂ COMMIT!"
	@echo "================================================================================"

check-ai: verify
test: test-race

fmt-layout-check:
	@$(GOA_BIN)/goa-fmt-layout -dir . -pkg "./$(TARGET_INFRA)/..."

fmt-layout:
	@$(GOA_BIN)/goa-fmt-layout -dir . -pkg "./$(TARGET_INFRA)/..." -write

# Dựng khung 5 package + 5 file test cho infrastructure mới
# Ví dụ: make scaffold-infra NAME=AI ADAPTER=LessonGenerator STAGES=raw,driver,encode,process,decode
scaffold-infra:
	@$(GOA_BIN)/goa-scaffold-infra -out infrastructure2 -name "$(NAME)" -adapter "$(ADAPTER)" -stages "$(if $(STAGES),$(STAGES),raw,driver,encode,process,decode)"

# Kiểm tra không sửa file *_test.go hoặc testdata/** so với mốc SPEC_REF
test-lock-check:
	@test -n "$(SPEC_REF)" || (echo "ERROR: SPEC_REF is required (e.g. make test-lock-check SPEC_REF=HEAD or SPEC_REF=STAGED)"; exit 1)
	@TARGET_DIR="$${TARGET%/}"; \
	if [ -n "$$TARGET_DIR" ]; then \
		set -- ":(glob)$$TARGET_DIR/*_test.go" ":(glob)$$TARGET_DIR/**/*_test.go" ":(glob)$$TARGET_DIR/**/testdata/**"; \
	else \
		set -- "*_test.go" ":(glob)**/testdata/**"; \
	fi; \
	if [ "$(SPEC_REF)" = "STAGED" ]; then \
		CHANGED=$$(git diff --name-only -- "$$@"); \
	else \
		CHANGED=$$(git diff --name-only $(SPEC_REF) -- "$$@"); \
	fi; \
	UNTRACKED=$$(git ls-files --others --exclude-standard -- "$$@"); \
	if [ -n "$$CHANGED" ] || [ -n "$$UNTRACKED" ]; then \
		echo "❌ VI PHẠM KHÓA TEST: Các file test hoặc fixture sau đã bị chỉnh sửa hoặc tạo mới:"; \
		[ -n "$$CHANGED" ] && echo "$$CHANGED"; \
		[ -n "$$UNTRACKED" ] && echo "$$UNTRACKED"; \
		exit 1; \
	fi
	@echo "✅ Khóa test an toàn: không có file *_test.go hay testdata/** nào bị sửa so với $(SPEC_REF)."
