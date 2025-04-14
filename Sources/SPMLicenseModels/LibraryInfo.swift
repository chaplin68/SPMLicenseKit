//
//  LibraryInfo.swift
//  SPMLicenseInfo
//
//  Created by Kota Endo on 2025/04/13.
//


import Foundation

public struct LibraryInfo: Codable, Identifiable, Sendable {
  public var id: String { identity }
  public let identity: String
  public let name: String
  public let repositoryURL: String?
  public let licenseBody: String
  
  public init(identity: String, name: String, repositoryURL: String?, licenseBody: String) {
    self.identity = identity
    self.name = name
    self.repositoryURL = repositoryURL
    self.licenseBody = licenseBody
  }
}
