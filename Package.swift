// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UPager",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(
            name: "UPager",
            targets: ["UPager"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "UPager",
            dependencies: []),
    ]
)
