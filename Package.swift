// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "AigensSdkCore",
    platforms: [
        .iOS(.v13)
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
        // Flutter 插件（供 Flutter 项目使用）
        .library(
            name: "aigens-sdk-core",
            targets: ["aigens_sdk_core"]),
        // Capacitor 插件（内部使用）
        .library(name: "Capacitor", targets: ["Capacitor"]),
        .library(name: "CapacitorApp", targets: ["CapacitorApp"]),
        .library(name: "CapacitorCamera", targets: ["CapacitorCamera"]),
        .library(name: "CapacitorDevice", targets: ["CapacitorDevice"]),
        .library(name: "CapacitorGeolocation", targets: ["CapacitorGeolocation"]),
        .library(name: "CapacitorKeyboard", targets: ["CapacitorKeyboard"]),
        .library(name: "CapacitorNetwork", targets: ["CapacitorNetwork"]),
        .library(name: "CapacitorShare", targets: ["CapacitorShare"]),
    ],
    dependencies: [
        // Capacitor 核心包
        // .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "5.7.4"),
    ],
    targets: [
        // 主 SDK Target
        .target(
            name: "AigensSdkCore",
            dependencies: [
                // .product(name: "Capacitor", package: "capacitor-swift-pm"),
                "Capacitor",
                "Cordova",
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
            resources: [
                // JSON 配置文件（已复制到 Classes 目录）
                .process("spm-files/"),
                // XIB 文件作为资源
                .process("WebContainer.xib")
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
                // .product(name: "Capacitor", package: "capacitor-swift-pm"),
                "Capacitor",
                "Cordova",
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
                // .product(name: "Capacitor", package: "capacitor-swift-pm"),
                "Capacitor",
                "Cordova",
            ],
            path: "aigens-sdk-wechatpay/Classes",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        // Capacitor（本地二进制框架）
        .binaryTarget(
            name: "Capacitor",
            url: "https://github.com/ionic-team/capacitor-swift-pm/releases/download/6.2.1/Capacitor.xcframework.zip",
            checksum: "dad7b961661855fecd45c38b1e317f64a046323cc05d204d054ada6d5b7f4378"
        ),
        .binaryTarget(
            name: "Cordova",
            url: "https://github.com/ionic-team/capacitor-swift-pm/releases/download/6.2.1/Cordova.xcframework.zip",
            checksum: "fb10239d76bf36787063e9a0c60219397c3648c781b8cd9e1a9e2a3990cbe5ce"
        ),
        // CapacitorApp
        .target(
            name: "CapacitorApp",
            dependencies: [
                "Capacitor",
                "Cordova",
            ],
            path: "capacitor-plugins/CapacitorApp",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        // CapacitorCamera
        .target(
            name: "CapacitorCamera",
            dependencies: [
                "Capacitor",
                "Cordova",
            ],
            path: "capacitor-plugins/CapacitorCamera",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        // CapacitorDevice
        .target(
            name: "CapacitorDevice",
            dependencies: [
                "Capacitor",
                "Cordova",
            ],
            path: "capacitor-plugins/CapacitorDevice",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        // CapacitorGeolocation
        .target(
            name: "CapacitorGeolocation",
            dependencies: [
                "Capacitor",
                "Cordova",
            ],
            path: "capacitor-plugins/CapacitorGeolocation",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        // CapacitorKeyboard（纯 Objective-C 插件）
        .target(
            name: "CapacitorKeyboard",
            dependencies: [
                "Capacitor",
                "Cordova",
            ],
            path: "capacitor-plugins/CapacitorKeyboard",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        // CapacitorNetwork
        .target(
            name: "CapacitorNetwork",
            dependencies: [
                "Capacitor",
                "Cordova",
            ],
            path: "capacitor-plugins/CapacitorNetwork",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        // CapacitorShare
        .target(
            name: "CapacitorShare",
            dependencies: [
                "Capacitor",
                "Cordova",
            ],
            path: "capacitor-plugins/CapacitorShare",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        // Flutter 插件 Target
        .target(
            name: "aigens_sdk_core",
            dependencies: [
                "AigensSdkCore",
                "AigensSdkApplepay",
            ],
            path: "aigens_sdk_core/ios/aigens_sdk_core/Sources/aigens_sdk_core",
            resources: []
        ),
    ]
)
