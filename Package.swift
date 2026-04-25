// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "meduza",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "meduza", targets: ["meduza"]),
    ],
    targets: [
        .target(
            name: "meduza",
            path: "src"
        ),
    ]
)
