// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppRouter",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppRouter",
            targets: ["AppRouter"]),
    ],
    dependencies: [
        .package(path: "../AIPlanner"),
        .package(path: "../UserProfile"),
        .package(path: "../TravelPlannerAuth"),
        .package(path: "../TabBar"),
        .package(path: "../Splash"),
        .package(path: "../Onboarding"),
        .package(path: "../Folder"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.0.0")
    ],
    targets: [
        .target(
            name: "AppRouter",
            dependencies: [
                "AIPlanner",
                "UserProfile",
                "TravelPlannerAuth",
                "TabBar",
                "Splash",
                "Onboarding",
                "Folder",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ]
        )
    ]
)
