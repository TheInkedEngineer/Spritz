// swift-tools-version:5.5
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
  ]
)
