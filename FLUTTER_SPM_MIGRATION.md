# Flutter 插件 SPM 迁移指南

## pubspec.yaml 配置

### 使用 CocoaPods（旧方式）

```yaml
flutter:
  plugin:
    platforms:
      ios:
        pluginClass: AigensSdkCorePlugin
```

### 使用 SPM（新方式）

```yaml
flutter:
  plugin:
    platforms:
      ios:
        pluginClass: AigensSdkCorePlugin
        package: aigens_sdk_core  # ← 添加这一行
```

**重要说明：**
- `package` 的值必须与 `Package.swift` 中的 `name` 一致
- 你的 `Package.swift` 中 `name: "AigensSdkCore"`
- 但在 Flutter 中，通常使用下划线命名：`aigens_sdk_core`

## 完整迁移步骤

### 1. 确保 Flutter 版本

SPM 支持需要 **Flutter 3.16+**：

```bash
flutter --version
# 确保版本 >= 3.16.0
```

### 2. 更新 pubspec.yaml

```yaml
flutter:
  plugin:
    platforms:
      ios:
        pluginClass: AigensSdkCorePlugin
        package: aigens_sdk_core  # ← 指定 SPM 包名称
```

### 3. 确保 iOS 目录结构

```
aigens_sdk_core/
├── ios/
│   ├── Package.swift           ← SPM 配置（必须）
│   ├── Classes/
│   │   └── AigensSdkCorePlugin.swift
│   └── aigens_sdk_core.podspec ← 可选，保留以兼容旧版本
└── pubspec.yaml
```

### 4. Package.swift 配置

```swift
// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "aigens_sdk_core",  // ← 这个名称要与 pubspec.yaml 中的 package 一致
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "aigens-sdk-core",
            targets: ["aigens_sdk_core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "6.0.0"),
    ],
    targets: [
        .target(
            name: "aigens_sdk_core",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
            ],
            path: "Classes"
        ),
    ]
)
```

### 5. podspec 文件处理

**建议保留 podspec 文件**，以兼容使用旧版本 Flutter 的项目：

```yaml
# pubspec.yaml 中不指定 package（使用 CocoaPods）
flutter:
  plugin:
    platforms:
      ios:
        pluginClass: AigensSdkCorePlugin
        # 不指定 package，Flutter 会使用 podspec
```

**或者指定 package（使用 SPM）：**

```yaml
# pubspec.yaml 中指定 package（使用 SPM）
flutter:
  plugin:
    platforms:
      ios:
        pluginClass: AigensSdkCorePlugin
        package: aigens_sdk_core  # ← Flutter 3.16+ 会使用 SPM
```

## 命名约定

### 推荐命名方案

| 文件 | 名称 | 说明 |
|------|------|------|
| `pubspec.yaml` | `package: aigens_sdk_core` | Flutter 插件标识 |
| `Package.swift` | `name: "aigens_sdk_core"` | SPM 包名称 |
| `Package.swift` product | `name: "aigens-sdk-core"` | 库产品名称（使用连字符） |
| `Package.swift` target | `name: "aigens_sdk_core"` | Target 名称 |

### 为什么 product 用连字符？

Apple 的惯例：
- **包名/Target 名**：使用下划线 `aigens_sdk_core`
- **Product 名**：使用连字符 `aigens-sdk-core`

## 用户使用方式

### 用户项目配置（SPM）

用户的项目使用 Flutter 3.16+ 时，会自动使用 SPM：

```yaml
dependencies:
  aigens_sdk_core: ^0.1.4
```

### 用户项目配置（CocoaPods）

用户的项目使用旧版本 Flutter 时，会自动使用 CocoaPods：

```yaml
dependencies:
  aigens_sdk_core: ^0.1.4
```

## 兼容性策略

### 方案 1：同时支持（推荐）

```
ios/
├── Package.swift           ← Flutter 3.16+ 使用
└── aigens_sdk_core.podspec ← Flutter < 3.16 使用
```

**pubspec.yaml：**
```yaml
flutter:
  plugin:
    platforms:
      ios:
        pluginClass: AigensSdkCorePlugin
        package: aigens_sdk_core  # 优先使用 SPM
```

### 方案 2：仅 SPM

```
ios/
├── Package.swift           ← 唯一配置
└── （删除 podspec）
```

**pubspec.yaml：**
```yaml
flutter:
  plugin:
    platforms:
      ios:
        pluginClass: AigensSdkCorePlugin
        package: aigens_sdk_core
```

## 测试迁移

### 1. 清理并重新获取依赖

```bash
cd flutter_example
flutter clean
flutter pub get
```

### 2. 检查 iOS 项目

```bash
cd flutter_example/ios
# 检查是否生成了正确的 SPM 配置
cat .symlinks/plugins/aigens_sdk_core/ios/Package.swift
```

### 3. 构建测试

```bash
flutter build ios --no-codesign
```

## 常见问题

### Q: 是否需要删除 podspec 文件？

**A:** 不需要。建议保留 podspec 文件以兼容旧版本 Flutter。

### Q: Flutter 如何选择使用 SPM 还是 CocoaPods？

**A:** 
- 如果 `pubspec.yaml` 中指定了 `package`，且 Flutter >= 3.16，使用 SPM
- 否则，如果有 podspec 文件，使用 CocoaPods

### Q: 用户的 iOS 项目需要修改吗？

**A:** 不需要。Flutter 会自动处理 SPM 集成。

## 你的项目当前状态

根据你当前的配置：

✅ **已配置：**
- `Package.swift` 在根目录
- `pubspec.yaml` 已准备支持 SPM

⚠️ **需要注意：**
- `Package.swift` 的 `name` 是 `"AigensSdkCore"`
- 建议改为 `"aigens_sdk_core"` 以匹配 Flutter 插件名称

## 建议修改

### Package.swift

```swift
let package = Package(
    name: "aigens_sdk_core",  // ← 改为与 Flutter 插件名一致
    // ...
)
```

### pubspec.yaml

```yaml
flutter:
  plugin:
    platforms:
      ios:
        pluginClass: AigensSdkCorePlugin
        package: aigens_sdk_core  # ← 取消注释
```

这样配置后，你的 Flutter 插件就能完美支持 SPM 了！
