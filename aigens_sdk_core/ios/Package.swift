// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aigens_sdk_core",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "aigens-sdk-core",
            targets: ["aigens_sdk_core"]),
    ],
    dependencies: [
        // Aigens SDK（包含 Core、Applepay、Wechatpay）
        .package(url: "https://github.com/AigensTechnology/AigensSdkCore.git", from: "spm6.0.0"),
    ],
    targets: [
        .target(
            name: "aigens_sdk_core",
            dependencies: [
                .product(name: "AigensSdkCore", package: "AigensSdkCore"),
                .product(name: "AigensSdkApplepay", package: "AigensSdkCore"),
            ],
            path: "Classes",
            resources: []
        ),
    ]
)