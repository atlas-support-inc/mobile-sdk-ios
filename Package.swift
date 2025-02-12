// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "AtlasSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AtlasSDK",
            targets: ["AtlasSDK"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AtlasSDK",
            dependencies: [],
            path: "Sources")
    ]
)
