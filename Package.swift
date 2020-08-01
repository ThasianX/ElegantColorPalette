// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ElegantColorPalette",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ElegantColorPalette",
            targets: ["ElegantColorPalette"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ElegantColorPalette",
            dependencies: [])
    ]
)
