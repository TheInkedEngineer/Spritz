// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Spritz",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v10)
  ],
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
      dependencies: [],
      resources: [
          .process("Resources/stati.csv"),
          .process("Resources/comuni.csv")
      ]
    ),
    .testTarget(
      name: "SpritzTests",
      dependencies: ["Spritz"]
    ),
  ],
  swiftLanguageVersions: [.v5]
)
