// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserProfile",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "UserProfile",
            targets: ["UserProfile"]
        ),
    ],
    dependencies: [
        .package(path: "../AppResources"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.0.0")
    ],
    targets: [
        .target(
            name: "UserProfile",
            dependencies: [
                "AppResources",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ],
            resources: [.process("Resources")]
        )
    ]
)
