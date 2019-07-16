// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Multiaddr",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Multiaddr",
            targets: ["Multiaddr"]),
    ],
    dependencies: [
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Multiaddr",
            dependencies: []),
        .testTarget(
            name: "MultiaddrTests",
            dependencies: ["Multiaddr"]),
    ]
)
