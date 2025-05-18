// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftllm",
    platforms: [.macOS(.v12)],
    dependencies: [
            .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
            .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.15.0"),
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "swiftllm",
            dependencies: [
                            .product(name: "ArgumentParser", package: "swift-argument-parser"),
                            .product(name: "AsyncHTTPClient", package: "async-http-client"),
                        ],
            path: "Sources"
        ),
    ]
)
