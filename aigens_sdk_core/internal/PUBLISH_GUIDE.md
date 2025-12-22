# Flutter Plugin 发布指南

本指南说明如何将 `aigens_sdk_core` Flutter plugin 发布到 pub.dev。

## 发布前准备

### 1. 检查代码质量

```bash
cd aigens_sdk_core

# 运行分析工具
flutter analyze

# 运行格式化工具
dart format .

# 运行测试（如果有）
flutter test
```

### 2. 更新版本号

编辑 `pubspec.yaml`:

```yaml
version: 0.1.0  # 格式: MAJOR.MINOR.PATCH
```

版本号遵循语义化版本控制：
- **MAJOR**: 不兼容的 API 更改
- **MINOR**: 向后兼容的功能添加
- **PATCH**: 向后兼容的错误修复

### 3. 更新 CHANGELOG.md

在 `CHANGELOG.md` 中添加新版本的变更记录：

```markdown
## 0.1.0

* Initial release
* Feature: Open Aigens WebContainer
* Feature: Member data support
* Feature: Deeplink data support
```

### 4. 检查依赖

确保 `pubspec.yaml` 中的依赖版本正确：

```yaml
environment:
  sdk: '>=2.17.0 <4.0.0'
  flutter: ">=1.17.0"
```

## 关于 Verified Publisher（已验证发布者）

**重要说明**：首次发布包到 pub.dev **不需要** Verified Publisher。这是可选的，但推荐使用。

### Verified Publisher 的优点：
- ✅ 显示已验证徽章，增加包的信任度
- ✅ 保护个人邮箱隐私
- ✅ 使用域名而不是个人邮箱显示

### 创建 Verified Publisher（可选）：

1. 访问 https://pub.dev/ 并登录
2. 点击右上角头像 → "Create Publisher"
3. 输入域名（如 `aigens.com`）
4. 完成域名验证（需要访问 Google Search Console）
5. 验证成功后即可使用

**即使没有 Verified Publisher，你也可以正常发布包！**

## 发布步骤

### 方法 1: 发布到 pub.dev（推荐）

1. **注册 pub.dev 账户**

   访问 https://pub.dev/ 并注册账户。

2. **登录 pub.dev**

   ```bash
   dart pub login
   ```
   
   或使用 Flutter 命令：
   
   ```bash
   flutter pub login
   ```

   按照提示在浏览器中完成登录授权。
   
   **如果遇到 "Could not retrieve your user-details" 错误**：
   
   1. 先登出：
      ```bash
      dart pub logout
      # 或
      flutter pub logout
      ```
   
   2. 清除缓存的凭据：
      ```bash
      # macOS/Linux
      rm -rf ~/.pub-cache/credentials.json
      ```
   
   3. 重新登录：
      ```bash
      flutter pub login
      ```
   
   **注意**：如果使用 Flutter，建议使用 `flutter pub login` 而不是 `dart pub login`。

3. **验证发布**

   ```bash
   flutter pub publish --dry-run
   ```

   这会检查所有文件，但不会实际上传。

4. **发布插件**

   ```bash
   flutter pub publish
   ```

   确认发布后，插件将上传到 pub.dev。

5. **验证发布**

   访问 `https://pub.dev/packages/aigens_sdk_core` 查看你的插件。

### 方法 2: 使用 Git 仓库

如果不想发布到 pub.dev，可以在 `pubspec.yaml` 中直接使用 Git URL：

```yaml
dependencies:
  aigens_sdk_core:
    git:
      url: https://github.com/AigensTechnology/AigensSdkCore.git
      path: aigens_sdk_core
      ref: main  # 或特定标签
```

然后用户可以直接从 Git 安装。

### 方法 3: 发布到私有仓库

1. **设置私有 pub 服务器**

   可以使用 `pub_server` 或其他私有包服务器。

2. **配置 pubspec.yaml**

   ```yaml
   publish_to: 'https://your-private-server.com'
   ```

## 发布后的维护

### 更新版本

1. 更新 `pubspec.yaml` 中的版本号
2. 更新 `CHANGELOG.md`
3. 创建 Git tag:

   ```bash
   git tag v0.1.0
   git push origin v0.1.0
   ```

4. 重新发布：

   ```bash
   flutter pub publish
   ```

### 撤回发布

如果发现问题需要撤回：

1. 访问 https://pub.dev/packages/aigens_sdk_core/admin
2. 点击 "Retract" 按钮
3. 注意：撤回后 7 天内可以取消撤回

### 弃用版本

如果某个版本不再维护：

1. 访问包的管理页面
2. 标记该版本为 "Discontinued"
3. 在 CHANGELOG 中说明原因

## 发布检查清单

在发布前，确保：

- [ ] 代码通过 `flutter analyze`
- [ ] 所有测试通过
- [ ] `pubspec.yaml` 版本号已更新
- [ ] `CHANGELOG.md` 已更新
- [ ] `README.md` 完整且准确
- [ ] 所有示例代码可以正常运行
- [ ] iOS 和 Android 平台代码都已测试
- [ ] 许可证文件已包含
- [ ] 已登录 pub.dev (`dart pub login`)
- [ ] 运行了 `flutter pub publish --dry-run` 且无错误

## 发布后验证

发布后，创建一个新的 Flutter 项目测试安装：

```bash
flutter create test_app
cd test_app

# 编辑 pubspec.yaml，添加依赖
# dependencies:
#   aigens_sdk_core: ^0.1.0

flutter pub get
flutter run
```

## 常见问题

### Q: 发布时提示 "Package already exists"

A: 包名已被使用。需要更改 `pubspec.yaml` 中的 `name` 字段。

### Q: 如何更新已发布的包？

A: 更新版本号后重新发布即可。不能修改已发布版本的代码。

### Q: 可以发布预览版本吗？

A: 可以，使用版本后缀，如 `0.1.0-dev.1`，但这不是推荐做法。

### Q: 需要遵循特定的代码风格吗？

A: 建议遵循 Dart 官方风格指南，使用 `dart format` 格式化代码。

## 参考资料

- [Pub.dev Publishing Guide](https://dart.dev/tools/pub/publishing)
- [Flutter Plugin Development](https://docs.flutter.dev/development/packages-and-plugins/developing-packages)
- [Semantic Versioning](https://semver.org/)

