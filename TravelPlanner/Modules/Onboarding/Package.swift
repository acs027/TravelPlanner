// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Onboarding",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Onboarding",
            targets: ["Onboarding"]),
    ],
    targets: [
        .target(
            name: "Onboarding",
        )
    ]
)
