// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Spritz",
    products: [
        .library(
            name: "Spritz",
            targets: ["Spritz"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Spritz",
            resources: [
              .copy("Resources/comuni.csv"),
              .copy("Resources/stati.csv")
            ]
        ),
        .testTarget(
            name: "SpritzTests",
            dependencies: ["Spritz"]
        ),
    ]
)
