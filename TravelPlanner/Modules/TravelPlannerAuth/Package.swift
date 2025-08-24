// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TravelPlannerAuth",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TravelPlannerAuth",
            targets: ["TravelPlannerAuth"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.0.0")
    ],
    targets: [
        .target(
            name: "TravelPlannerAuth",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ],
        )
    ]
)
