//
//  Encodable+Ext.swift
//  TestWebMacos
//
//  Created by dev Rakes on 08/05/2023.
//

import Foundation

extension Encodable {
  var convertToString: String? {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    do {
      let jsonData = try jsonEncoder.encode(self)
      return String(data: jsonData, encoding: .utf8)
    } catch {
      return nil
    }
  }
}
