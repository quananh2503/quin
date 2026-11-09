#!/bin/bash
set -e

echo "🚀 Đang khởi chạy QUIN dev với WebKitGTK 4.1..."
~/go/bin/wails dev -tags "webkit2_41" "$@"
