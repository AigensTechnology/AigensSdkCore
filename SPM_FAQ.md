# SPM 常见问题解答

## Q1: Package.swift 文件名能否更改？

**不能！** `Package.swift` 是 Swift Package Manager 的固定文件名，这是 SPM 的约定，不能更改。

## Q2: 同一个 Tag 有多个 SDK，SPM 如何知道我要用哪个？

**答案：通过 Product 名称区分！**

在同一个 `Package.swift` 中，你可以定义多个 `product`（产品），每个 product 有独立的名称：

```swift
products: [
    .library(name: "AigensSdkCore", targets: ["AigensSdkCore"]),
    .library(name: "AigensSdkApplepay", targets: ["AigensSdkApplepay"]),
    .library(name: "AigensSdkWechatpay", targets: ["AigensSdkWechatpay"]),
]
```

使用时，通过 `product name` 来选择需要的模块：

```swift
dependencies: [
    .product(name: "AigensSdkCore", package: "AigensSdkCore"),
    .product(name: "AigensSdkApplepay", package: "AigensSdkCore"),
]
```

## Q3: 一定要创建单独的目录放 Package.swift 吗？

**不需要！** 

### ❌ 错误做法（之前的方案）
```
AigensSdkCore/Package.swift       # 主 SDK
AigensSdkApplepay/Package.swift   # Apple Pay
AigensSdkWechatpay/Package.swift  # WeChat Pay
```

这样会导致：
- 需要多个 Git 标签（0.1.3, 0.0.8applepay, 0.0.1wechatpay）
- 管理复杂
- 版本不一致

### ✅ 正确做法（当前方案）
```
Package.swift  # 根目录，包含所有模块
```

在同一个 `Package.swift` 中定义所有模块：
- 只需一个 Git 标签（如 0.1.3）
- 统一管理
- 版本一致

## Q4: SPM 如何识别不同的模块？

SPM 通过以下层次结构识别：

```
Package (包)
  ├── Products (产品) - 对外暴露的库
  │   ├── AigensSdkCore
  │   ├── AigensSdkApplepay
  │   └── AigensSdkWechatpay
  └── Targets (目标) - 实际的编译单元
      ├── AigensSdkCore (指向 AigensSdkCore/Classes)
      ├── AigensSdkApplepay (指向 aigens-sdk-applepay/Classes)
      └── AigensSdkWechatpay (指向 aigens-sdk-wechatpay/Classes)
```

## Q5: 如果我只想发布部分模块怎么办？

你有两个选择：

### 方案 1：条件编译（推荐）
在 `Package.swift` 中使用条件依赖，但这比较复杂。

### 方案 2：统一发布（当前方案）
所有模块一起发布，用户按需选择使用哪些 product。

**这是最佳实践**，因为：
- 简化版本管理
- 减少维护成本
- 用户灵活性高

## Q6: CocoaPods 的 podspec 和 SPM 的 Package.swift 对比

| 特性 | CocoaPods | SPM |
|------|-----------|-----|
| 配置文件 | `*.podspec` | `Package.swift` |
| 文件名 | 可以自定义 | 必须叫 `Package.swift` |
| 发布方式 | 发布到 CocoaPods trunk | 推送 Git 标签 |
| 需要登录 | 是 | 否 |
| 多模块支持 | 多个 podspec | 一个 Package.swift 定义多个 product |
| 版本管理 | 每个 pod 独立版本 | 统一版本 |

## 总结

**当前方案的优势：**
1. ✅ 只需一个 `Package.swift` 文件
2. ✅ 只需一个 Git 标签
3. ✅ 统一管理所有模块
4. ✅ 用户按需选择模块
5. ✅ 版本保持一致

**使用方式：**
```bash
# 部署
./deploy-spm.sh

# 验证
./verify-spm.sh
```

用户只需要添加一个依赖，然后选择需要的模块即可！
