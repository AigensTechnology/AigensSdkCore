# Flutter Plugin 项目总结

## 项目结构

已创建完整的 Flutter plugin 项目结构：

```
AigensSdkCore/
├── aigens_sdk_core/          # Flutter Plugin 主目录
│   ├── lib/
│   │   └── aigens_sdk_core.dart  # Dart API
│   ├── android/               # Android 平台代码
│   │   ├── src/main/kotlin/com/aigens/sdk/flutter/
│   │   │   └── AigensSdkCorePlugin.kt
│   │   ├── build.gradle
│   │   └── src/main/AndroidManifest.xml
│   ├── ios/                   # iOS 平台代码
│   │   └── Classes/
│   │       └── AigensSdkCorePlugin.swift
│   ├── pubspec.yaml
│   ├── README.md
│   ├── CHANGELOG.md
│   ├── LICENSE
│   └── analysis_options.yaml
│
└── flutter_example/           # Flutter 示例项目
    ├── lib/
    │   └── main.dart
    ├── android/
    │   ├── app/build.gradle
    │   └── settings.gradle
    ├── ios/
    │   └── Podfile
    ├── pubspec.yaml
    └── README.md
```

## 功能特性

### Dart API (`lib/aigens_sdk_core.dart`)

1. **AigensSdkCore.openUrl()** - 打开 Aigens WebContainer
   - 支持 member 数据传递
   - 支持 deeplink 数据传递
   - 支持 debug 模式
   - 支持清理缓存
   - 返回 ClosedData（包含 redirectUrl 和 action）

2. **AigensSdkCore.dismiss()** - 关闭 WebContainer

3. **AigensSdkCore.isInstalledApp()** - 检查应用是否已安装

4. **AigensSdkCore.openExternalUrl()** - 打开外部 URL

5. **数据模型**：
   - `MemberData` - 会员数据
   - `DeeplinkData` - 深度链接数据
   - `ClosedData` - 关闭时返回的数据

### iOS 实现 (`ios/Classes/AigensSdkCorePlugin.swift`)

- 使用 Flutter MethodChannel 通信
- 动态加载 WebContainerViewController
- 设置 closeCB 回调
- 处理 URL scheme 和 universal links
- 注意：需要在 Flutter 应用的 Podfile 中添加 `pod 'AigensSdkCore', '0.1.3'`

### Android 实现 (`android/src/main/kotlin/com/aigens/sdk/flutter/AigensSdkCorePlugin.kt`)

- 使用 Flutter MethodChannel 通信
- 启动 WebContainerActivity
- 使用 ActivityResult 接收关闭数据
- 处理 Intent extras
- 注意：需要在 build.gradle 中添加 `implementation 'com.aigens:aigens-sdk-core:5.0.8'`

## 发布流程

详细发布流程请参考：`aigens_sdk_core/PUBLISH_GUIDE.md`

### 快速发布步骤：

1. **检查代码**
   ```bash
   cd aigens_sdk_core
   flutter analyze
   dart format .
   ```

2. **更新版本**
   - 编辑 `pubspec.yaml` 中的版本号
   - 更新 `CHANGELOG.md`

3. **发布到 pub.dev**
   ```bash
   dart pub login
   flutter pub publish --dry-run  # 先测试
   flutter pub publish            # 正式发布
   ```

4. **或者使用 Git**
   用户可以直接从 Git 仓库安装：
   ```yaml
   dependencies:
     aigens_sdk_core:
       git:
         url: https://github.com/AigensTechnology/AigensSdkCore.git
         path: aigens_sdk_core
   ```

## 使用示例

### 在 Flutter 应用中使用

1. **添加依赖** (`pubspec.yaml`)
   ```yaml
   dependencies:
     aigens_sdk_core:
       path: ../aigens_sdk_core  # 本地路径
       # 或
       # git:
       #   url: https://github.com/AigensTechnology/AigensSdkCore.git
       #   path: aigens_sdk_core
   ```

2. **iOS 配置**
   - 编辑 `ios/Podfile`，添加 `pod 'AigensSdkCore', '0.1.3'`
   - 运行 `pod install`
   - 配置 `Info.plist` 权限和 URL schemes
   - 更新 `AppDelegate.swift`

3. **Android 配置**
   - 编辑 `android/app/build.gradle`，添加依赖
   - 确保 `jcenter()` 在 `settings.gradle` 中
   - 配置 `AndroidManifest.xml`

4. **使用代码**
   ```dart
   import 'package:aigens_sdk_core/aigens_sdk_core.dart';
   
   final closedData = await AigensSdkCore.openUrl(
     url: 'https://scantest.aigens.com/scan?code=...',
     member: MemberData(
       memberCode: 'member123',
       source: 'merchant',
       // ... 其他参数
     ),
   );
   ```

## 示例项目

完整的示例项目位于 `flutter_example/` 目录，包含：
- 完整的 Flutter 应用
- iOS 和 Android 配置示例
- 使用示例代码

## 注意事项

1. **iOS 依赖**：必须在 Flutter 应用的 Podfile 中添加 AigensSdkCore pod
2. **Android 依赖**：必须在 build.gradle 中添加 Aigens SDK 依赖
3. **权限配置**：确保在 Info.plist 和 AndroidManifest.xml 中配置了必要的权限
4. **URL Schemes**：确保配置了正确的 URL schemes 和 universal links
5. **静态回调**：iOS 中使用了静态属性 closeCB，需要确保正确设置

## 后续工作

1. 在实际设备上测试 iOS 和 Android 实现
2. 验证 closeCB 回调是否正确工作
3. 测试所有功能（member data, deeplink, external protocols 等）
4. 根据需要调整错误处理
5. 添加单元测试和集成测试
6. 完善文档和示例

## 相关文档

- Flutter Plugin 开发文档：https://docs.flutter.dev/development/packages-and-plugins/developing-packages
- pub.dev 发布指南：https://dart.dev/tools/pub/publishing
- 原始 SDK 文档：`README.md`

