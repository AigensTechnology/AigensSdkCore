#!/bin/bash

echo "=== Building Flutter iOS project ==="
flutter build ios --debug --no-codesign

if [ $? -eq 0 ]; then
    echo "✓ Flutter iOS build completed"
    echo ""
    echo "=== Opening Xcode workspace (SPM) ==="
    open ios/Runner.xcworkspace
else
    echo "✗ Flutter build failed!"
    exit 1
fi

# Flutter 使用 SPM，不需要 pod install
# Flutter 代码需要先编译成原生二进制，才能被 Xcode 使用
# 编译后的产物在 build/ios/ 目录

# 如果想直接在命令行运行（不需要打开 Xcode）：
# flutter run --debug -d ios

# 或者指定模拟器
# flutter run --debug -d "iPhone 15"