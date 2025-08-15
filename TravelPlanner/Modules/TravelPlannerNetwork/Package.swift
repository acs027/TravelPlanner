// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TravelPlannerNetwork",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TravelPlannerNetwork",
            targets: ["TravelPlannerNetwork"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.0.0"),
        .package(path: "../AppResources"),
        .package(path: "../MockData")
    ],
    targets: [
        .target(
            name: "TravelPlannerNetwork",
            dependencies: [
                .product(name: "FirebaseAI", package: "firebase-ios-sdk"),
                "AppResources", "MockData"
            ]
        )
    ]
)
