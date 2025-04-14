// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPMLicenseKit",
    platforms: [.iOS(.v12), .macOS(.v10_14)],
    products: [
        .library(
            name: "SPMLicenseModels",
            targets: ["SPMLicenseModels"]),
        .library(
            name: "SPMLicenseInfo",
            targets: ["SPMLicenseInfo"]),
    ],
    dependencies: [],
    targets: [
      .target(name: "SPMLicenseModels"),
      .target(name: "SPMLibraryInfoReader"),
      // 自動生成されるライセンス情報
      .target(
          name: "SPMLicenseInfo",
          dependencies: ["SPMLicenseModels"],
          swiftSettings: [.define("SWIFT_PACKAGE_MANAGER_BUILD")],
          plugins: [.plugin(name: "SPMLicensePlugin")]
      ),
      // ビルドツールプラグイン
      .plugin(
          name: "SPMLicensePlugin",
          capability: .buildTool(),
          dependencies: ["spm-license-generator"]),
      
      // ライセンス情報生成ツール
      .executableTarget(
          name: "spm-license-generator",
          dependencies: ["SPMLicenseModels", "SPMLibraryInfoReader"],
          path: "Tools/spm-license-generator"),
        
        // テスト
        .testTarget(
            name: "SPMLicenseInfoTests",
            dependencies: ["SPMLicenseInfo"]),
    ]
)
