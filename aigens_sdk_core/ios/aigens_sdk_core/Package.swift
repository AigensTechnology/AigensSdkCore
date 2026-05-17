// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aigens_sdk_core",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "aigens-sdk-core",
            targets: ["aigens_sdk_core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/AigensTechnology/AigensSdkCore.git", branch: "spm-swift"),
    ],
    targets: [
        .target(
            name: "aigens_sdk_core",
            dependencies: [
                .product(name: "AigensSdkCore", package: "AigensSdkCore"),
                .product(name: "AigensSdkApplepay", package: "AigensSdkCore"),
            ],
            path: "Sources/aigens_sdk_core",
            resources: []
        ),
    ]
)