//
//  plugin.swift
//  SPMLicenseKit
//
//  Created by Kota Endo on 2025/04/12.
//

import PackagePlugin
import Foundation

struct SourcePackagesNotFoundError: Error & CustomStringConvertible {
    let description: String = "SourcePackages not found"
}

@main
struct SPMLicensePlugin: BuildToolPlugin {
  enum SPMLicensePluginError: Swift.Error, CustomStringConvertible {
    case sourcePackagesNotFound

    var description: String {
      switch self {
      case .sourcePackagesNotFound: return "SourcePackages directory not found"
      }
    }
  }

  func existsSourcePackages(in url: URL) throws -> Bool {
      guard url.isFileURL,
            url.pathComponents.count > 1,
            let isDirectory = try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory else {
        throw SourcePackagesNotFoundError()
      }
      let existsSourcePackagesInDirectory = FileManager.default
          .fileExists(atPath: url.appending(path: "SourcePackages").path())
      return isDirectory && existsSourcePackagesInDirectory
  }

  func sourcePackages(_ pluginWorkDirectory: URL) throws -> URL {
      var tmpURL = pluginWorkDirectory.absoluteURL

      while try !existsSourcePackages(in: tmpURL) {
        tmpURL.deleteLastPathComponent()
      }
      tmpURL.append(path: "SourcePackages")
      return tmpURL
  }

  func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
    // SourcePackagesディレクトリを探す
    let sourcePackagesPath = try sourcePackages(context.pluginWorkDirectoryURL)
    // workspace-state.jsonのパス
    let workspaceStatePath = sourcePackagesPath.appending(path: "workspace-state.json")
    // 出力ファイルのパス
    let outputFilePath = context.pluginWorkDirectory.appending("SPMLicenseInfo.swift")
    // ビルドコマンドを作成
    return [
      .buildCommand(
        displayName: "Generating SPM License Info",
        executable: try context.tool(named: "spm-license-generator").path,
        arguments: [
            workspaceStatePath.absoluteURL.path(),
            outputFilePath.string
        ],
        environment: [:],
        outputFiles: [outputFilePath]
      )
    ]
  }

  private func findSourcePackages(in directory: Path) throws -> Path {
    var currentDir = directory

    for _ in 0..<10 {
      let sourcePackagesPath = currentDir.appending("SourcePackages")

      if FileManager.default.fileExists(atPath: sourcePackagesPath.string) {
          return sourcePackagesPath
      }

      if currentDir.string == "/" { break }

      // 親ディレクトリに移動
      currentDir = currentDir.removingLastComponent()
    }

    throw SPMLicensePluginError.sourcePackagesNotFound
  }
}
