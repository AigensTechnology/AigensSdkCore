# 删除缓存文件
rm -f .flutter-plugins-dependencies
rm -f .flutter-plugins

# 清理 Flutter 缓存
flutter clean

# 重新获取依赖
flutter pub get

# 重新生成 Android 项目文件
flutter build apk --config-only