#!/bin/bash

echo "Checking Flutter setup..."
flutter doctor --android-licenses

echo "Running Flutter Android..."
flutter run -d android

# 可选：如果需要打开 Android Studio 进行调试
# echo "Opening Android Studio..."
open -a "Android Studio" .

# 可选：指定特定设备
# flutter run -d "emulator-5554"  # 替换为你的设备 ID
# flutter run -d "sdk gphone x86"  # Android 模拟器

# 调试模式（带热重载）
# flutter run --debug -d android

# 分析模式（用于性能分析）
# flutter run --profile -d android

# 发布模式
# flutter run --release -d android