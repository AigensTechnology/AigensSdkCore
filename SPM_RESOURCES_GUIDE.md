# SPM 资源配置说明

## 你的资源配置

```swift
.target(
    name: "AigensSdkCore",
    path: "AigensSdkCore/Classes",
    resources: [
        .copy("../Assets")  // ✅ 正确
    ]
)
```

## 目录结构

```
AigensSdkCore/
├── Assets/                          ← 资源目录
│   └── capacitor.config.json        ← JSON 文件
├── Classes/                         ← 源代码目录 (path)
│   └── Core.swift
└── Package.swift
```

## 路径说明

- **path**: `AigensSdkCore/Classes` - Target 的根目录
- **resources**: `../Assets` - 相对于 Classes 目录
  - `..` 表示上一级目录（AigensSdkCore）
  - `../Assets` 就是 `AigensSdkCore/Assets`

## .copy vs .process

| 方法 | 用途 | 适用场景 |
|------|------|---------|
| `.copy()` | 原样复制 | JSON、配置文件、数据库等 |
| `.process()` | 优化处理 | 图片、音频等（会压缩优化） |

**你的场景：**
```swift
// ✅ 正确：JSON 配置文件使用 .copy
.copy("../Assets")

// ❌ 错误：不要对 JSON 使用 .process
.process("../Assets")  // 可能会导致意外处理
```

## 在代码中访问资源

### Swift 中访问

```swift
import Foundation

// 方法 1：使用 Bundle.module（SPM 标准方式）
if let url = Bundle.module.url(forResource: "capacitor.config", withExtension: "json") {
    let data = try Data(contentsOf: url)
    // 使用 JSON 数据
}

// 方法 2：获取资源路径
let path = Bundle.module.path(forResource: "capacitor.config", ofType: "json")
```

### 注意事项

1. **Bundle.module**：SPM 会自动生成这个扩展
2. **资源名称**：不包括路径，只包括文件名
3. **扩展名**：需要单独指定

## 验证资源配置

运行以下命令验证：

```bash
# 在 Package.swift 所在目录运行
swift package describe

# 应该能看到资源文件列表
```

## 常见错误

### ❌ 错误 1：路径错误
```swift
// 错误：相对于 Package.swift 而不是 path
.copy("AigensSdkCore/Assets")
```

### ❌ 错误 2：使用 .process 处理 JSON
```swift
// 不推荐：JSON 应该用 .copy
.process("../Assets")
```

### ✅ 正确配置
```swift
.target(
    name: "AigensSdkCore",
    path: "AigensSdkCore/Classes",
    resources: [
        .copy("../Assets")  // ✅ 正确
    ]
)
```

## 构建后的资源位置

构建后，资源文件会被复制到：
```
BuildProductsPath/
└── AigensSdkCore.framework/
    └── Resources/
        └── capacitor.config.json
```

通过 `Bundle.module` 可以访问到这个资源。
