# 安装指南

本指南说明如何在 Flutter 项目中安装和使用 `aigens_sdk_core` plugin。

## 安装方式

### 方式 1: 从 pub.dev 安装（推荐）✅

**前提条件**: Plugin 已发布到 pub.dev

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  aigens_sdk_core: ^0.1.0
```

然后运行：

```bash
flutter pub get
```

**版本约束说明**：
- `^0.1.0` - 允许 0.1.0 及以上，但小于 0.2.0 的版本
- `0.1.0` - 仅允许 0.1.0 版本
- `>=0.1.0 <0.2.0` - 明确指定版本范围

### 方式 2: 从本地路径安装（开发/测试）

如果 plugin 在本地开发，可以使用路径依赖：

```yaml
dependencies:
  aigens_sdk_core:
    path: ../aigens_sdk_core  # 相对于当前项目的路径
```

然后运行：

```bash
flutter pub get
```

### 方式 3: 从 Git 仓库安装

如果 plugin 托管在 Git 仓库（如 GitHub）：

```yaml
dependencies:
  aigens_sdk_core:
    git:
      url: https://github.com/AigensTechnology/AigensSdkCore.git
      path: aigens_sdk_core  # Git 仓库中的子目录路径
      ref: main  # 分支名、标签或提交 hash
      # ref: v0.1.0  # 使用特定版本标签
      # ref: abc1234  # 使用特定提交 hash
```

然后运行：

```bash
flutter pub get
```

## 完整安装步骤（pub.dev）

### 1. 添加依赖

编辑 `pubspec.yaml`：

```yaml
name: your_app_name
description: Your app description
version: 1.0.0

dependencies:
  flutter:
    sdk: flutter
  aigens_sdk_core: ^0.1.0  # 添加这一行
```

### 2. 获取依赖

```bash
flutter pub get
```

### 3. 配置平台代码

#### iOS 配置

1. **编辑 `ios/Podfile`**，添加 Aigens SDK：

```ruby
platform :ios, '12.0'

target 'Runner' do
  use_frameworks!
  
  # ... 其他 pods ...
  
  # 添加 Aigens SDK Core
  pod 'AigensSdkCore', '0.1.3'
  
  # 如果使用 Apple Pay（可选）
  # pod 'AigensSdkApplepay', '0.0.8'
end
```

2. **安装 CocoaPods 依赖**：

```bash
cd ios
pod install
cd ..
```

3. **配置 `ios/Runner/Info.plist`**（添加权限和 URL schemes，参考主 README）

4. **更新 `ios/Runner/AppDelegate.swift`**（添加 URL 处理，参考主 README）

#### Android 配置

1. **编辑 `android/app/build.gradle`**，添加依赖：

```gradle
dependencies {
    implementation 'com.aigens:aigens-sdk-core:5.0.8'
    
    // 如果使用 Google Pay（可选）
    // implementation 'com.aigens:aigens-sdk-googlepay:5.0.1'
}
```

2. **确保 `android/settings.gradle` 包含 `jcenter()`**：

```gradle
repositories {
    google()
    mavenCentral()
    jcenter()  // 必须添加
}
```

3. **配置 `android/app/src/main/AndroidManifest.xml`**（添加 Activity 和权限，参考主 README）

### 4. 使用 Plugin

```dart
import 'package:aigens_sdk_core/aigens_sdk_core.dart';

// 打开 WebContainer
final closedData = await AigensSdkCore.openUrl(
  url: 'https://scantest.aigens.com/scan?code=...',
  member: MemberData(
    memberCode: 'member123',
    // ... 其他参数
  ),
);
```

### 5. 运行应用

```bash
flutter run
```

## 验证安装

安装成功后，可以运行以下命令验证：

```bash
flutter pub deps
```

应该能看到 `aigens_sdk_core` 在依赖树中。

## 更新 Plugin

### 更新 pub.dev 版本

```bash
flutter pub upgrade aigens_sdk_core
```

或手动编辑 `pubspec.yaml` 中的版本号，然后运行：

```bash
flutter pub get
```

### 更新 Git 版本

修改 `pubspec.yaml` 中的 `ref` 字段（标签或分支），然后运行：

```bash
flutter pub get
```

### 更新本地路径版本

直接更新本地 plugin 代码，然后运行：

```bash
flutter pub get
```

## 常见问题

### Q: `flutter pub get` 失败，提示找不到 package

**A:** 确保：
1. 包名拼写正确：`aigens_sdk_core`
2. 版本号正确
3. 如果从 pub.dev 安装，确保已发布
4. 如果从 Git 安装，确保 URL 和路径正确
5. 网络连接正常

### Q: iOS 编译错误，提示找不到 WebContainerViewController

**A:** 确保：
1. 在 `ios/Podfile` 中添加了 `pod 'AigensSdkCore', '0.1.3'`
2. 运行了 `pod install`
3. 使用 `.xcworkspace` 而不是 `.xcodeproj` 打开项目

### Q: Android 编译错误，提示找不到 WebContainerActivity

**A:** 确保：
1. 在 `android/app/build.gradle` 中添加了依赖
2. `settings.gradle` 中包含了 `jcenter()`
3. 运行了 `flutter clean && flutter pub get`

### Q: 如何切换到不同版本？

**A:** 编辑 `pubspec.yaml` 中的版本号，然后运行 `flutter pub get`

### Q: 可以同时使用多个安装方式吗？

**A:** 不可以，一个 package 只能使用一种安装方式。pub.dev 的优先级最高。

## 发布状态

- ✅ **已发布到 pub.dev**: 可以从 pub.dev 安装
- ⏳ **开发中**: 只能使用本地路径或 Git 仓库安装
- 🔒 **私有**: 只能使用 Git 仓库或私有服务器安装

## 相关文档

- [发布指南](./PUBLISH_GUIDE.md)
- [使用文档](./README.md)
- [Flutter Package 文档](https://dart.dev/tools/pub/get)

