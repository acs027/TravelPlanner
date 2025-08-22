// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Splash",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Splash",
            targets: ["Splash"]),
    ],
    dependencies: [
        .package(path: "../AppResources"),
        .package(path: "../TabBar"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.0.0")
    ],
    targets: [
        .target(
            name: "Splash",
            dependencies: [
                "AppResources", "TabBar",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ],
            resources: [.process("Resources")]
        )
    ]
)
