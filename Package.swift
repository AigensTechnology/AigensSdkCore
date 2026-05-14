// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "AigensSdkCore",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        // 主 SDK
        .library(
            name: "AigensSdkCore",
            targets: ["AigensSdkCore"]),
        // Apple Pay 插件
        .library(
            name: "AigensSdkApplepay",
            targets: ["AigensSdkApplepay"]),
        // WeChat Pay 插件
        .library(
            name: "AigensSdkWechatpay",
            targets: ["AigensSdkWechatpay"]),
    ],
    dependencies: [
        // Capacitor 核心包
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "6.0.0"),
        // Capacitor 插件包（包含所有插件）
        .package(url: "https://github.com/ionic-team/capacitor-plugins.git", from: "@capacitor/toast@6.0.4"),
    ],
    targets: [
        // 主 SDK Target
        .target(
            name: "AigensSdkCore",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "CapacitorApp", package: "capacitor-plugins"),
                .product(name: "CapacitorCamera", package: "capacitor-plugins"),
                .product(name: "CapacitorDevice", package: "capacitor-plugins"),
                .product(name: "CapacitorGeolocation", package: "capacitor-plugins"),
                .product(name: "CapacitorKeyboard", package: "capacitor-plugins"),
                .product(name: "CapacitorNetwork", package: "capacitor-plugins"),
                .product(name: "CapacitorShare", package: "capacitor-plugins"),
            ],
            path: "AigensSdkCore/Classes",
            resources: [
                // 相对于 Classes 目录，Assets 在上一级
                .copy("../Assets")
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        // Apple Pay Target
        .target(
            name: "AigensSdkApplepay",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
            ],
            path: "aigens-sdk-applepay/Classes",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        // WeChat Pay Target
        .target(
            name: "AigensSdkWechatpay",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
            ],
            path: "aigens-sdk-wechatpay/Classes",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
    ]
)
