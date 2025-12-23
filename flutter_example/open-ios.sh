#!/bin/bash

echo "Installing CocoaPods dependencies..."
cd ios
pod install
cd ..

echo "Running Flutter iOS..."
flutter run -d ios &

echo "Opening Xcode..."
sleep 3
open ios/Runner.xcworkspace



# 直接在 Debug 模式运行（会自动打开调试）
# flutter run --debug -d ios

# 或者指定模拟器
# flutter run --debug -d "iPhone 14"