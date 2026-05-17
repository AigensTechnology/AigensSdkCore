# SPM 迁移检查清单

## ✅ 自动完成的步骤

- [x] 删除 CocoaPods 相关文件（Pods/, Podfile, Podfile.lock）
- [x] 清理 Flutter 构建缓存
- [x] 清理 Xcode DerivedData
- [x] 重新获取 Flutter 依赖

## ⚠️ 需要手动完成的步骤

### 1. 在 Xcode 中添加 SPM 包

- [ ] 打开 `ios/Runner.xcodeproj`
- [ ] File → Add Package Dependencies
- [ ] 添加 `aigens_sdk_core` 包

### 2. 验证配置

- [ ] 检查 `aigens_sdk_core/pubspec.yaml`
  - `pluginClass: AigensSdkCorePlugin` ✓
  - `package: aigens_sdk_core` ✓

- [ ] 检查 `aigens_sdk_core/ios/Package.swift`
  - `name: "aigens_sdk_core"` ✓
  - `product name: "aigens-sdk-core"` ✓

### 3. 编译测试

- [ ] 在 Xcode 中编译 (Cmd + B)
- [ ] 运行 Flutter 应用: `flutter run`
- [ ] 测试插件功能

### 4. 清理旧配置

- [ ] 从 Git 中移除 CocoaPods 文件（如果已提交）
  ```bash
  git rm -r --cached ios/Pods
  git rm ios/Podfile
  git rm ios/Podfile.lock
  ```

- [ ] 更新 `.gitignore`，添加：
  ```
  ios/Pods/
  ios/Podfile
  ios/Podfile.lock
  ios/.symlinks/
  ```

## 🔧 常见问题

### Q: 编译错误 "Package.swift doesn't exist"
A: 确保 aigens_sdk_core/ios/Package.swift 存在且配置正确

### Q: 插件无法注册
A: 检查 pubspec.yaml 中 `pluginClass` 是否已声明

### Q: Xcode 添加包时崩溃
A: 清理缓存:
```bash
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf ~/Library/Developer/Xcode/DerivedData
```

## 📚 相关文档

- [Flutter SPM 支持](https://docs.flutter.dev/release/breaking-changes/swift-package-manager-support)
- [Swift Package Manager](https://www.swift.org/package-manager/)
