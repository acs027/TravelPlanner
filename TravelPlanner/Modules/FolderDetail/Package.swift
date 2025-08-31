// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FolderDetail",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FolderDetail",
            targets: ["FolderDetail"]),
    ],
    dependencies: [
        .package(path: "../AppResources"),
        .package(path: "../CoreDataManager")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FolderDetail",
            dependencies: [
                "AppResources",
                "CoreDataManager"
            ]
        ),

    ]
)
