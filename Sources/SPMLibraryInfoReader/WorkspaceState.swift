//
//  WorkspaceState.swift
//  SPMLicenseInfo
//
//  Created by Kota Endo on 2025/04/13.
//

public struct WorkspaceState: Decodable {
  var object: ObjectRef
  var version: Int

  struct ObjectRef: Decodable {
    var dependencies: [DependencyRef]
  }

  struct DependencyRef: Decodable {
    var packageRef: PackageRef
  }

  struct PackageRef: Decodable {
    var identity: String
    var kind: String
    var location: String
    var name: String
  }
}
