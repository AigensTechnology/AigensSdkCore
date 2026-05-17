# Aigens SDK Core - Flutter 插件

## ⚡ 快速开始

### 步骤 1：添加依赖

在你的 Flutter 项目的 `pubspec.yaml` 中添加：

```yaml
dependencies:
  aigens_sdk_core: ^0.2.0
```

### 步骤 2：获取依赖

```bash
flutter pub get
```

### 步骤 3：在 Xcode 中添加 SPM 包（仅首次）

```bash
open ios/Runner.xcworkspace
```

然后在 Xcode 中：

1. **File** → **Add Package Dependencies...**
2. 输入 URL：
   ```
   https://github.com/AigensTechnology/AigensSdkCore.git
   ```
3. 选择版本：
   - **Branch** → `spm-swift`
4. 选择产品：
   - ✅ `aigens-sdk-core`（Flutter 插件）
5. 点击 **Finish**

### 步骤 4：运行项目

```bash
flutter run
```

**完成！** 🎉 之后只需 `flutter pub get` 即可，不需要重复步骤 3。

---

## 📖 详细说明

### 为什么需要手动添加 SPM 包？

Flutter 3.16+ 支持 SPM，但**只会自动处理 Flutter 生成的插件**。
第三方 SPM 依赖仍需要手动添加到 Xcode 项目中。

好消息是：
- ✅ **只需添加一次**
- ✅ 添加后永久有效
- ✅ 之后 `flutter pub get` 即可正常使用

---

## 🔧 常见问题

### Q: 如何验证 SPM 包已正确集成？

在 Xcode 中：
1. 选择项目
2. 查看 **Package Dependencies** 标签
3. 应该能看到 `AigensSdkCore`

### Q: 构建失败怎么办？

尝试清理缓存后重新构建：

```bash
flutter clean
flutter pub get
flutter build ios
```

---

## 📱 使用示例

```dart
import 'package:aigens_sdk_core/aigens_sdk_core.dart';

// 打开 WebContainer
final closedData = await AigensSdkCore.openUrl(
  url: 'https://your-server.com',
  member: MemberData(
    memberCode: 'member123',
    source: 'your-brand',
    universalLink: 'https://your-domain.com',
    appScheme: 'yourapp',
  ),
  deeplink: DeeplinkData(
    addItemId: 'item-001',
    addDiscountCode: 'SAVE10',
  ),
);

// 关闭 WebContainer
await AigensSdkCore.dismiss();
```

---

## 📋 版本要求

- **Flutter**: >= 3.16.0
- **Dart**: >= 3.0.0
- **iOS**: >= 13.0
- **Xcode**: >= 14.0

---

## 📞 技术支持

- GitHub: https://github.com/AigensTechnology/AigensSdkCore
- Issues: https://github.com/AigensTechnology/AigensSdkCore/issues

## 📄 许可证

详见 LICENSE 文件。
