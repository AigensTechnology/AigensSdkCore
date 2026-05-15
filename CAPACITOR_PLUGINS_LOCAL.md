# Capacitor 插件本地化配置说明

## 概述

你已经将 Capacitor 插件的代码复制到了项目的 `capacitor-plugins/` 目录中，现在 Package.swift 配置为使用这些本地插件，而不是依赖外部仓库。

## 目录结构

```
AigensSdkCore/
├── Package.swift                    ← SPM 配置文件
├── AigensSdkCore/Classes/           ← 主 SDK 代码
├── aigens-sdk-applepay/Classes/     ← Apple Pay 插件
├── aigens-sdk-wechatpay/Classes/    ← WeChat Pay 插件
└── capacitor-plugins/               ← Capacitor 插件（本地）
    ├── CapacitorApp/
    ├── CapacitorCamera/
    ├── CapacitorDevice/
    ├── CapacitorGeolocation/
    ├── CapacitorKeyboard/
    ├── CapacitorNetwork/
    └── CapacitorShare/
```

## Package.swift 配置

### 1. 依赖声明

```swift
dependencies: [
    // 只依赖 Capacitor 核心框架
    .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "5.7.4"),
]
```

**不再依赖** `capacitor-plugins` 外部仓库！

### 2. 主 SDK 依赖

```swift
.target(
    name: "AigensSdkCore",
    dependencies: [
        .product(name: "Capacitor", package: "capacitor-swift-pm"),
        // 引用本地的插件 target
        "CapacitorApp",
        "CapacitorCamera",
        "CapacitorDevice",
        "CapacitorGeolocation",
        "CapacitorKeyboard",
        "CapacitorNetwork",
        "CapacitorShare",
    ],
    path: "AigensSdkCore/Classes",
)
```

### 3. 插件 Target 定义

每个插件都有独立的 target 定义：

```swift
// CapacitorApp
.target(
    name: "CapacitorApp",
    dependencies: [
        .product(name: "Capacitor", package: "capacitor-swift-pm"),
    ],
    path: "capacitor-plugins/CapacitorApp",
    publicHeadersPath: ".",
    cSettings: [
        .headerSearchPath(".")
    ]
),
```

## 关键概念

### Target vs Product

**Target（编译单元）：**
- 实际的代码编译单位
- 定义在 `targets` 数组中
- 内部使用或对外暴露都可以

**Product（对外库）：**
- 对外暴露的库
- 定义在 `products` 数组中
- 用户导入的名称

### 当前配置

```
内部使用（不暴露）:
  ┌─ CapacitorApp (target)
  ├─ CapacitorCamera (target)
  ├─ CapacitorDevice (target)
  ├─ CapacitorGeolocation (target)
  ├─ CapacitorKeyboard (target)
  ├─ CapacitorNetwork (target)
  └─ CapacitorShare (target)
        ↓ (被引用)
  AigensSdkCore (target + product)

对外暴露:
  ├─ AigensSdkCore ✅
  ├─ AigensSdkApplepay ✅
  └─ AigensSdkWechatpay ✅
```

### 是否需要暴露插件？

**情况 1：插件只供 SDK 内部使用**
```swift
// products 中不需要添加
products: [
    .library(name: "AigensSdkCore", targets: ["AigensSdkCore"]),
]
```

**情况 2：希望用户也能直接使用插件**
```swift
// products 中添加
products: [
    .library(name: "AigensSdkCore", targets: ["AigensSdkCore"]),
    .library(name: "CapacitorApp", targets: ["CapacitorApp"]),
    .library(name: "CapacitorCamera", targets: ["CapacitorCamera"]),
    // ... 其他插件
]
```

当前配置是**情况 1**（插件注释掉了），如果需要使用**情况 2**，取消注释即可。

## 优势

### ✅ 优点

1. **完全控制**
   - 插件代码在你的仓库中
   - 不依赖外部仓库的可用性
   - 可以自定义修改

2. **版本稳定**
   - 不会因为外部仓库更新而出问题
   - 固定使用你测试过的版本

3. **简化依赖**
   - 只需要一个依赖：`capacitor-swift-pm`
   - 不需要处理 `capacitor-plugins` 的复杂版本

4. **避免标签问题**
   - 不需要处理 `@capacitor/toast@6.0.4` 这种非标准标签
   - 使用标准语义化版本

### ⚠️ 注意事项

1. **更新需要手动同步**
   - 如果 Capacitor 插件有新版本
   - 需要手动复制代码到你的项目

2. **许可证**
   - 确保你遵守 Capacitor 的开源许可证
   - 通常 MIT 许可证允许这样做

## 使用方式

### 在 Xcode 中添加

用户只需要添加一个包：

```
URL: https://github.com/AigensTechnology/AigensSdkCore.git
版本: spm6.0.0 (或你的 tag)
```

然后选择产品：
- ✅ AigensSdkCore（包含所有本地插件）
- ✅ AigensSdkApplepay（可选）
- ✅ AigensSdkWechatpay（可选）

**不需要**单独添加 Capacitor 插件！

### 在代码中导入

```swift
import AigensSdkCore
// 所有 Capacitor 插件已经自动包含

import AigensSdkApplepay
import AigensSdkWechatpay
```

## 添加新插件

如果需要添加新的 Capacitor 插件：

### 步骤 1：复制插件代码

```bash
# 假设添加 CapacitorBrowser
cp -r /path/to/capacitor-browser capacitor-plugins/CapacitorBrowser
```

### 步骤 2：在 Package.swift 中添加 target

```swift
// 在 targets 数组中添加
.target(
    name: "CapacitorBrowser",
    dependencies: [
        .product(name: "Capacitor", package: "capacitor-swift-pm"),
    ],
    path: "capacitor-plugins/CapacitorBrowser",
    publicHeadersPath: ".",
    cSettings: [
        .headerSearchPath(".")
    ]
),
```

### 步骤 3：在主 SDK 中引用

```swift
.target(
    name: "AigensSdkCore",
    dependencies: [
        .product(name: "Capacitor", package: "capacitor-swift-pm"),
        "CapacitorApp",
        "CapacitorCamera",
        // ... 现有插件
        "CapacitorBrowser",  // ← 新增
    ],
    path: "AigensSdkCore/Classes",
)
```

### 步骤 4：（可选）对外暴露

```swift
products: [
    // ...
    .library(name: "CapacitorBrowser", targets: ["CapacitorBrowser"]),
],
```

## 验证配置

```bash
cd /Users/chenpeijue/Desktop/workspace/AigensSdkCore

# 验证语法
swift package dump-package

# 尝试解析依赖
swift package resolve

# 构建
swift build
```

## 常见问题

### Q: 为什么不在 products 中暴露插件？

A: 因为这些插件是 SDK 的内部依赖，用户不需要直接导入。如果用户需要额外的 Capacitor 插件，可以自己从官方仓库添加。

### Q: 可以混合使用本地插件和外部插件吗？

A: 可以，但不推荐。最好统一使用本地或统一使用外部，避免版本冲突。

### Q: 如何更新本地插件？

A: 从 Capacitor 官方仓库下载最新代码，覆盖 `capacitor-plugins/` 中的对应目录。

### Q: 需要保留 podspec 文件吗？

A: 如果需要兼容 CocoaPods，建议保留。SPM 和 CocoaPods 可以同时存在。

## 总结

当前配置：
- ✅ 所有 Capacitor 插件都在本地
- ✅ 不再依赖外部 `capacitor-plugins` 仓库
- ✅ 只需一个外部依赖：`capacitor-swift-pm`
- ✅ 插件供 SDK 内部使用（可选择是否暴露）

这是一个**完全自包含**的解决方案！
