// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Coordinator",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Coordinator",
            targets: ["Coordinator"]),
    ],
    dependencies: [
        .package(path: "../AIPlanner"),
        .package(path: "../TravelPlannerAuth"),
        .package(path: "../UserProfile"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.0.0")
                  ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Coordinator",
            dependencies: ["AIPlanner", "TravelPlannerAuth", "UserProfile",
                           .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
                          ]
        ),

    ]
)
