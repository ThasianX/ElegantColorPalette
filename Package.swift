// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ElegantColorPicker",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ElegantColorPicker",
            targets: ["ElegantColorPicker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ElegantColorPicker",
            dependencies: [])
    ]
)
