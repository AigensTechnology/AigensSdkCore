# SPM package 参数填写指南

## 核心规则

`.product(name: "产品名", package: "包名")` 中的 `package` 参数必须与 `dependencies` 中定义的**包名称**完全匹配。

## 包名称的确定方式

### 方式 1：自动推导（最常用）

```swift
dependencies: [
    .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "6.0.0"),
]
```

**包名称 = URL 最后一段（去掉 .git）**

| URL | 包名称 |
|-----|--------|
| `https://github.com/ionic-team/capacitor-swift-pm.git` | `capacitor-swift-pm` |
| `https://github.com/ionic-team/capacitor-plugins.git` | `capacitor-plugins` |
| `https://github.com/Alamofire/Alamofire.git` | `Alamofire` |

### 方式 2：显式指定

```swift
dependencies: [
    .package(
        name: "CapacitorCore",  // ✅ 显式指定包名称
        url: "https://github.com/ionic-team/capacitor-swift-pm.git",
        from: "6.0.0"
    ),
]
```

使用时：
```swift
.product(name: "Capacitor", package: "CapacitorCore")  // 使用显式指定的名称
```

## 你的项目示例

### Dependencies 定义

```swift
dependencies: [
    // 包 1: capacitor-swift-pm
    .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "6.0.0"),
    
    // 包 2: capacitor-plugins
    .package(url: "https://github.com/ionic-team/capacitor-plugins.git", from: "6.0.0"),
]
```

### Targets 中使用

```swift
.target(
    name: "AigensSdkCore",
    dependencies: [
        // ✅ 正确：package 匹配 dependencies 中的包名称
        .product(name: "Capacitor", package: "capacitor-swift-pm"),
        .product(name: "CapacitorApp", package: "capacitor-plugins"),
        .product(name: "CapacitorBrowser", package: "capacitor-plugins"),
    ]
)
```

## 常见错误

### ❌ 错误 1：包名称不匹配

```swift
dependencies: [
    .package(url: "https://github.com/ionic-team/capacitor-plugins.git", from: "6.0.0"),
]

targets: [
    .target(
        dependencies: [
            // ❌ 错误！包名称应该是 "capacitor-plugins"
            .product(name: "CapacitorApp", package: "capacitor-plugins-swift-pm"),
        ]
    )
]
```

**错误信息：**
```
product 'CapacitorApp' required by package 'AigensSdkCore' target 'AigensSdkCore' not found.
```

### ❌ 错误 2：拼写错误

```swift
dependencies: [
    .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "6.0.0"),
]

targets: [
    .target(
        dependencies: [
            // ❌ 错误！拼写错误，应该是 "capacitor-swift-pm"
            .product(name: "Capacitor", package: "capacitor-swift_pm"),
        ]
    )
]
```

### ✅ 正确示例

```swift
dependencies: [
    .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "6.0.0"),
    .package(url: "https://github.com/ionic-team/capacitor-plugins.git", from: "6.0.0"),
]

targets: [
    .target(
        dependencies: [
            // ✅ 正确：包名称与 dependencies 中的 URL 推导出的名称一致
            .product(name: "Capacitor", package: "capacitor-swift-pm"),
            .product(name: "CapacitorApp", package: "capacitor-plugins"),
            .product(name: "CapacitorBrowser", package: "capacitor-plugins"),
        ]
    )
]
```

## 验证包名称

### 方法 1：查看 Package.swift 的 name 字段

如果目标包的 `Package.swift` 中有 `name` 字段：

```swift
// 在 capacitor-swift-pm 的 Package.swift 中
let package = Package(
    name: "capacitor-swift-pm",  // ← 这就是包名称
    ...
)
```

### 方法 2：使用 URL 推导（默认）

如果没有显式指定 name，使用 URL 最后一段：

```bash
# 从 URL 提取包名称
URL="https://github.com/ionic-team/capacitor-swift-pm.git"
echo ${URL##*/} | sed 's/\.git$//'
# 输出: capacitor-swift-pm
```

### 方法 3：显式指定（推荐用于复杂场景）

```swift
dependencies: [
    .package(
        name: "MyCustomName",  // 显式指定，避免歧义
        url: "https://github.com/user/repo.git",
        from: "1.0.0"
    ),
]
```

## 实际映射表

| Dependencies 定义 | 包名称 | Product 中使用 |
|------------------|--------|---------------|
| `.package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", ...)` | `capacitor-swift-pm` | `package: "capacitor-swift-pm"` |
| `.package(url: "https://github.com/ionic-team/capacitor-plugins.git", ...)` | `capacitor-plugins` | `package: "capacitor-plugins"` |
| `.package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", ...)` | `Alamofire` | `package: "Alamofire"` |

## 快速检查清单

- [ ] `package` 参数与 dependencies 中的包名称完全匹配
- [ ] 检查拼写（区分大小写）
- [ ] 如果使用了 `name` 参数，使用显式指定的名称
- [ ] 如果没使用 `name` 参数，使用 URL 最后一段（去掉 .git）

## 调试技巧

如果遇到问题，运行：

```bash
swift package resolve
```

这会显示解析后的依赖关系，帮助你确认包名称是否正确。
