// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppCheckProvider",
    platforms: [
           .iOS(.v15)
       ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppCheckProvider",
            targets: ["AppCheckProvider"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.0.0")
    ],
    targets: [
        .target(
            name: "AppCheckProvider",
            dependencies: [
                .product(name: "FirebaseAppCheck", package: "firebase-ios-sdk")
            ],
        )
    ]
)

