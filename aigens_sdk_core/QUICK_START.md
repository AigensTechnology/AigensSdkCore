# 快速开始

## 发布到 pub.dev 后的安装步骤

### 1. 在 `pubspec.yaml` 中添加依赖

```yaml
dependencies:
  flutter:
    sdk: flutter
  aigens_sdk_core: ^0.1.0  # 添加这一行
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 配置平台代码

**iOS** - 编辑 `ios/Podfile`：
```ruby
pod 'AigensSdkCore', '0.1.3'
```

然后运行：
```bash
cd ios && pod install && cd ..
```

**Android** - 编辑 `android/app/build.gradle`：
```gradle
dependencies {
    implementation 'com.aigens:aigens-sdk-core:5.0.8'
}
```

### 4. 使用

```dart
import 'package:aigens_sdk_core/aigens_sdk_core.dart';

final closedData = await AigensSdkCore.openUrl(
  url: 'https://scantest.aigens.com/scan?code=...',
);
```

## 发布流程摘要

### 发布到 pub.dev

```bash
cd aigens_sdk_core

# 1. 登录 pub.dev
dart pub login

# 2. 验证发布（不实际上传）
flutter pub publish --dry-run

# 3. 正式发布
flutter pub publish
```

发布成功后，其他开发者就可以通过 `aigens_sdk_core: ^0.1.0` 安装了。

### 从 pub.dev 安装

其他开发者只需要：

1. 在 `pubspec.yaml` 中添加：
   ```yaml
   dependencies:
     aigens_sdk_core: ^0.1.0
   ```

2. 运行：
   ```bash
   flutter pub get
   ```

就这么简单！🎉

