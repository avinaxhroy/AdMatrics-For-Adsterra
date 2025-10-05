// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AdMetricsShared",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "AdMetricsShared",
            targets: ["AdMetricsShared"]
        )
    ],
    targets: [
        .target(
            name: "AdMetricsShared",
            path: "Sources/AdMetricsShared",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
