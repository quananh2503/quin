#!/bin/bash
set -e

echo "🚀 Đang build QUIN với WebKitGTK 4.1..."
~/go/bin/wails build -tags "webkit2_41" "$@"
echo "✅ Build hoàn tất: build/bin/quin-1.1.2"
