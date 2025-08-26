// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreDataManager",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoreDataManager",
            targets: ["CoreDataManager"]),
    ],
    dependencies: [
        .package(path: "../AppResources"),
    ],
    targets: [
        .target(
            name: "CoreDataManager",
            dependencies: [
                "AppResources",
            ],
            resources: [
                   .process("TravelPlannerDataModel.xcdatamodeld")
               ],
        )
    ]
)
