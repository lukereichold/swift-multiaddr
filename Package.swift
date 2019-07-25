// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Multiaddr",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "Multiaddr",
            targets: ["Multiaddr"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Multiaddr",
            dependencies: []),
        .testTarget(
            name: "MultiaddrTests",
            dependencies: ["Multiaddr"]),
    ]
)
