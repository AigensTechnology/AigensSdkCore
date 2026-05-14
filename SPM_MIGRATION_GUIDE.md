# Aigens SDK - Swift Package Manager (SPM) 迁移指南

## 概述

本文档介绍如何将 Aigens SDK 从 CocoaPods 迁移到 Swift Package Manager (SPM)。

## 重要说明

### SPM 不需要登录！

与 CocoaPods 不同，**Swift Package Manager 不需要登录或发布到中央仓库**。SPM 的工作原理是：

1. 代码存储在 GitHub 仓库中
2. 通过 Git 标签（tag）进行版本管理
3. 用户直接通过 GitHub URL 引用你的包

所以，**部署到 SPM = 推送代码到 GitHub + 打 Git 标签**

## 项目结构

```
AigensSdkCore/
├── AigensSdkCore/              # 主 SDK 源代码
│   ├── Classes/                # 源代码
│   └── Assets/                 # 资源文件
├── aigens-sdk-applepay/        # Apple Pay 插件源代码
│   └── Classes/
├── aigens-sdk-wechatpay/       # WeChat Pay 插件源代码
│   └── Classes/
├── Package.swift               # SPM 配置 (包含所有模块)
├── deploy-spm.sh               # 部署脚本
└── verify-spm.sh               # 验证脚本
```

**重要**：所有模块都在**同一个** `Package.swift` 中定义，使用同一个 Git 标签。

## 快速开始

### 1. 验证配置

在部署之前，先验证 Package.swift 配置是否正确：

```bash
./verify-spm.sh
```

### 2. 部署到 SPM

运行部署脚本，它会自动：
- 创建 Git 标签
- 推送到 GitHub

```bash
./deploy-spm.sh
```

### 3. 在 Xcode 中使用

#### 方式 1：通过 Xcode UI

1. 打开 Xcode 项目
2. File → Add Package Dependency
3. 输入仓库 URL：`https://github.com/AigensTechnology/AigensSdkCore.git`
4. 选择版本：
   - `0.1.3` (AigensSdkCore)
   - `0.0.8applepay` (AigensSdkApplepay)
   - `0.0.1wechatpay` (AigensSdkWechatpay)

#### 方式 2：通过 Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/AigensTechnology/AigensSdkCore.git", from: "0.1.3"),
]

targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            // 选择你需要的模块
            .product(name: "AigensSdkCore", package: "AigensSdkCore"),
            .product(name: "AigensSdkApplepay", package: "AigensSdkCore"),
            .product(name: "AigensSdkWechatpay", package: "AigensSdkCore"),
        ]),
]
```

## 版本标签说明

所有模块在**同一个** `Package.swift` 中定义，使用**同一个** Git 标签：

| 标签 | 包含模块 |
|------|----------|
| `0.1.3` | AigensSdkCore, AigensSdkApplepay, AigensSdkWechatpay |

## Capacitor 依赖

你的 SDK 依赖多个 Capacitor 插件。在 SPM 中，我们使用官方的 SPM 版本：

- `capacitor-swift-pm` - Capacitor 核心
- `capacitor-plugins-swift-pm` - Capacitor 插件

这些已经配置在 `Package.swift` 中。

## 故障排除

### 问题：找不到 Capacitor 模块

**解决方案**：确保 Package.swift 中的依赖 URL 正确：
```swift
.package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "3.5.1")
```

### 问题：标签已存在

**解决方案**：部署脚本会询问是否删除并重新创建标签。

### 问题：Swift 版本不兼容

**解决方案**：确保使用 Swift 5.7 或更高版本。

## 从 CocoaPods 迁移

如果你之前使用 CocoaPods，可以：

1. **保留双支持**：同时保留 `.podspec` 和 `Package.swift`
2. **逐步迁移**：先测试 SPM 版本，再完全切换
3. **更新文档**：告知用户两种集成方式

## 脚本说明

### deploy-spm.sh

- 自动创建 Git 标签
- 推送代码和标签到 GitHub
- 交互式确认，避免误操作

### verify-spm.sh

- 验证 Package.swift 语法
- 检查依赖配置
- 显示包信息

## 后续步骤

1. 更新 Flutter 插件的 `Package.swift` 以引用这些库
2. 测试 SPM 集成
3. 更新文档，提供 SPM 集成指南
4. 考虑逐步淘汰 CocoaPods 支持

## 参考资料

- [Swift Package Manager 官方文档](https://swift.org/package-manager/)
- [Capacitor SPM 支持](https://capacitorjs.com/docs/ios)
- [Flutter SPM 支持](https://docs.flutter.dev/packages-and-plugins/ios-plugin-api)
