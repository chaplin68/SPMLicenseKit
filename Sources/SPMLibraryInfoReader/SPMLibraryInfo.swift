//
//  SPMLibraryInfo.swift
//  SPMLicenseInfo
//
//  Created by Kota Endo on 2025/04/13.
//

// ライブラリ情報の構造体
public struct SPMLibraryInfo: Codable {
  public let identity: String
  public let name: String
  public let repositoryURL: String?
  public let licenseBody: String?
}
