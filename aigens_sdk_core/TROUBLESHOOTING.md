# 故障排除指南

## 登录问题

### 问题：`dart pub login` 后提示 "Could not retrieve your user-details"

**解决方案**：

1. **登出并清除凭据**：
   ```bash
   dart pub logout
   # 或
   flutter pub logout
   ```

2. **删除缓存的凭据文件**：
   ```bash
   # macOS/Linux
   rm -rf ~/.pub-cache/credentials.json
   
   # Windows
   del %LOCALAPPDATA%\Pub\Cache\credentials.json
   ```

3. **使用 Flutter 命令重新登录**（推荐）：
   ```bash
   flutter pub login
   ```
   
   如果使用 Flutter，建议使用 `flutter pub login` 而不是 `dart pub login`。

4. **在浏览器中完成登录**：
   - 命令会打开浏览器
   - 使用 Google 账户登录
   - 授权应用访问

5. **如果仍然失败**，尝试：
   ```bash
   # 检查网络连接
   ping pub.dev
   
   # 检查代理设置
   echo $HTTP_PROXY
   echo $HTTPS_PROXY
   ```

### 问题：需要创建 Verified Publisher 吗？

**答案**：**不需要！** 首次发布包到 pub.dev 不需要 Verified Publisher。

- ✅ 可以直接使用个人账户发布
- ✅ Verified Publisher 是可选的
- ✅ 创建 Verified Publisher 需要域名验证，可能需要时间

**何时需要 Verified Publisher**：
- 想要显示验证徽章
- 想要保护个人邮箱隐私
- 想要使用公司/组织域名

**创建 Verified Publisher（可选）**：
1. 访问 https://pub.dev/
2. 登录后点击右上角头像
3. 选择 "Create Publisher"
4. 输入域名并完成验证

## 发布问题

### 问题：`flutter pub publish` 提示 "Package already exists"

**原因**：包名已被其他开发者使用。

**解决方案**：
1. 更改 `pubspec.yaml` 中的 `name` 字段
2. 包名必须是唯一的
3. 建议使用有意义的名称，如 `aigens_sdk_core_flutter`

### 问题：`flutter pub publish --dry-run` 失败

**检查清单**：
- [ ] `pubspec.yaml` 格式正确
- [ ] 版本号格式正确（如 `0.1.0`）
- [ ] 所有必需的文件都存在
- [ ] 没有未提交的更改（如果使用 Git）
- [ ] `README.md` 存在且非空
- [ ] `CHANGELOG.md` 存在（可选但推荐）
- [ ] `LICENSE` 文件存在

### 问题：发布后找不到包

**可能原因**：
1. 发布需要几分钟时间索引
2. 包名拼写错误
3. 版本号错误

**解决方案**：
1. 等待 5-10 分钟后重试
2. 检查包名：访问 `https://pub.dev/packages/YOUR_PACKAGE_NAME`
3. 检查版本号是否正确

## 依赖问题

### 问题：`flutter pub get` 找不到包

**解决方案**：
1. 检查包名拼写
2. 检查版本号是否正确
3. 如果是新发布的包，等待几分钟后重试
4. 清除缓存：
   ```bash
   flutter clean
   flutter pub cache repair
   flutter pub get
   ```

### 问题：iOS Podfile 找不到 AigensSdkCore

**解决方案**：
1. 确保在 `ios/Podfile` 中添加了：
   ```ruby
   pod 'AigensSdkCore', '0.1.3'
   ```
2. 运行：
   ```bash
   cd ios
   pod repo update
   pod install
   cd ..
   ```
3. 如果仍然失败，检查网络连接或使用代理

### 问题：Android build.gradle 找不到 Aigens SDK

**解决方案**：
1. 确保 `settings.gradle` 包含 `jcenter()`：
   ```gradle
   repositories {
       google()
       mavenCentral()
       jcenter()  // 必须添加
   }
   ```
2. 同步 Gradle：
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

## 编译问题

### 问题：iOS 编译错误

**常见错误及解决方案**：

1. **找不到 WebContainerViewController**：
   - 确保运行了 `pod install`
   - 使用 `.xcworkspace` 打开项目

2. **Capacitor 相关错误**：
   - 确保所有 Capacitor 依赖都已安装
   - 检查 Podfile 中的版本号

### 问题：Android 编译错误

**常见错误及解决方案**：

1. **找不到 WebContainerActivity**：
   - 确保 `build.gradle` 中添加了依赖
   - 确保 `jcenter()` 在 repositories 中

2. **Kotlin 版本问题**：
   - 检查 `kotlin_version` 是否兼容
   - 更新到最新版本

## 其他问题

### 问题：如何检查是否已登录？

```bash
dart pub whoami
# 或
flutter pub whoami
```

### 问题：如何查看已发布的包？

访问：https://pub.dev/packages/YOUR_PACKAGE_NAME

或使用命令：
```bash
dart pub deps
```

### 问题：如何更新已发布的包？

1. 更新 `pubspec.yaml` 中的版本号
2. 更新 `CHANGELOG.md`
3. 运行 `flutter pub publish`

### 问题：可以撤回已发布的包吗？

**可以**，但有限制：
- 撤回后 7 天内可以取消撤回
- 访问包的管理页面进行操作
- 建议先发布一个新版本修复问题，而不是撤回

## 获取帮助

如果以上方法都无法解决问题：

1. 查看官方文档：
   - [Pub.dev Publishing Guide](https://dart.dev/tools/pub/publishing)
   - [Flutter Plugin Development](https://docs.flutter.dev/development/packages-and-plugins/developing-packages)

2. 搜索相关问题：
   - [pub.dev Issues](https://github.com/dart-lang/pub-dev/issues)
   - [Flutter Issues](https://github.com/flutter/flutter/issues)

3. 联系支持：
   - pub.dev 支持邮箱（如果有）
   - Flutter 社区论坛

