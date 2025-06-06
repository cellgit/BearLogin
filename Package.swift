// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BearLogin",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BearLogin",
            targets: ["BearLogin"]),
    ],
    dependencies: [
//        .package(path: "../BearBasic"),
//        .package(url: "https://github.com/cellgit/BearBasic.git", .upToNextMajor(from: "0.0.4")),
//        .package(url: "https://gitee.com/cellgit/BearBasic.git", .upToNextMajor(from: "0.0.9")),
        .package(url: "https://github.com/cellgit/BearBasic.git", .upToNextMajor(from: "0.1.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BearLogin",
            dependencies: ["BearBasic"]
        ),
        .testTarget(
            name: "BearLoginTests",
            dependencies: ["BearLogin"]
        ),
    ]
)



