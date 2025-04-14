//
//  String+Extension.swift
//  SPMLicenseInfo
//
//  Created by Kota Endo on 2025/04/13.
//

public extension String {
  func indent(by level: Int) -> String {
    let indentation = String(repeating: "    ", count: level)
    return split(separator: "\n").map { indentation + $0 }.joined(separator: "\n")
  }
}
