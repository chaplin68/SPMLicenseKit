//
//  SPMLibraryInfoReader.swift
//  SPMLicenseInfo
//
//  Created by Kota Endo on 2025/04/13.
//

import Foundation

public class SPMLibraryInfoReader {
  public static func parseWorkspaceState(at path: String) throws -> [SPMLibraryInfo] {
    let checkoutsPath = path.replacingOccurrences(of: "workspace-state.json", with: "checkouts")

    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
      throw NSError(domain: "SPMLicenseGenerator", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to read workspace-state.json"])
    }

    do {
      let decoder = JSONDecoder()
      let workspaceState = try decoder.decode(WorkspaceState.self, from: data)

      var libraries = [SPMLibraryInfo]()

      for (dependency) in workspaceState.object.dependencies {
        let repositoryName = dependency.packageRef.location
            .components(separatedBy: "/").last!
            .replacingOccurrences(of: ".git", with: "")
        let directoryURL = URL(fileURLWithPath: "\(checkoutsPath)/\(repositoryName)")

        let licenseBody = extractLicenseBody(directoryURL)

        let library = SPMLibraryInfo(identity: dependency.packageRef.identity,
                                     name: dependency.packageRef.name,
                                     repositoryURL: dependency.packageRef.location,
                                     licenseBody: licenseBody)
        libraries.append(library)
      }

      return libraries
    } catch {
      throw error
    }
  }

  public static func extractLicenseBody(_ directoryURL: URL) -> String? {
    let fileManager = FileManager.default
    let contents = (try? fileManager.contentsOfDirectory(atPath: directoryURL.path)) ?? []

    let licenseURL = contents
      .map { directoryURL.appendingPathComponent($0) }
      .filter { contentURL in
        let fileName = contentURL.deletingPathExtension().lastPathComponent.lowercased()
        guard ["license", "LICENSE"].contains(fileName) else { return false }

        var isDirectory: ObjCBool = false
        fileManager.fileExists(atPath: contentURL.path, isDirectory: &isDirectory)
        return isDirectory.boolValue == false
      }
      .first
    guard let licenseURL, let text = try? String(contentsOf: licenseURL) else {
      return nil
    }

    return text
  }
}
