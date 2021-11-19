// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "quess-engine",
    platforms: [
      .iOS(.v13),
      .macOS(.v10_15),
      .tvOS(.v13),
      .watchOS(.v6),
    ],
    products: [
        .library(
            name: "QuessEngine",
            targets: ["QuessEngine"]
        ),
    ],
    targets: [
        .target(
            name: "QuessEngine",
            dependencies: []
        ),
        .testTarget(
            name: "QuessEngineTests",
            dependencies: ["QuessEngine"]
        ),
    ]
)
