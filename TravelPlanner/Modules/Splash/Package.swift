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
        .package(path: "../TravelPlannerNetwork"),
        .package(url: "https://github.com/LottieFiles/dotlottie-ios", from: "0.8.7")
    ],
    targets: [
        .target(
            name: "Splash",
            dependencies: [
                "TravelPlannerNetwork",
                .product(name: "DotLottie", package: "dotlottie-ios")
            ],
            resources: [
                .process("Resources")
            ]
        )
        
    ]
)
