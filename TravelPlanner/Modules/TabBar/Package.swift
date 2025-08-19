// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TabBar",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "TabBar",
            targets: ["TabBar"]),
    ],
    dependencies: [
        .package(path: "../AIPlanner"),
        .package(path: "../UserProfile")
    ],
    targets: [
        .target(
            name: "TabBar",
            dependencies: [
                "AIPlanner", "UserProfile"
            ]
        )
    ]
)
