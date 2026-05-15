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
            exclude: [
                // 排除 Objective-C 实现文件
                "CorePlugin.m"
            ],
            resources: [
                // 相对于 Classes 目录，Assets 在上一级
                .copy("../Assets"),
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
            ],
            path: "aigens-sdk-applepay/Classes",
            exclude: ["ApplepayPlugin.m"],
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
            ],
            path: "aigens-sdk-wechatpay/Classes",
            exclude: ["WechatHKPlugin.m"],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        // Capacitor（本地二进制框架）
        .binaryTarget(
            name: "Capacitor",
            path: "capacitor-plugins/Capacitor/Capacitor.xcframework"
        ),
        // CapacitorApp
        .target(
            name: "CapacitorApp",
            dependencies: [
                "Capacitor",
            ],
            path: "capacitor-plugins/CapacitorApp",
            exclude: ["AppPlugin.m"],
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
            ],
            path: "capacitor-plugins/CapacitorCamera",
            exclude: ["CameraPlugin.m"],
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
            ],
            path: "capacitor-plugins/CapacitorDevice",
            exclude: ["DevicePlugin.m"],
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
            ],
            path: "capacitor-plugins/CapacitorGeolocation",
            exclude: ["GeolocationPlugin.m"],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        // CapacitorKeyboard
        .target(
            name: "CapacitorKeyboard",
            dependencies: [
                "Capacitor",
            ],
            path: "capacitor-plugins/CapacitorKeyboard",
            exclude: ["Keyboard.m", "KeyboardPlugin.m"],
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
            ],
            path: "capacitor-plugins/CapacitorNetwork",
            exclude: ["NetworkPlugin.m"],
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
            ],
            path: "capacitor-plugins/CapacitorShare",
            exclude: ["SharePlugin.m"],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
    ]
)
