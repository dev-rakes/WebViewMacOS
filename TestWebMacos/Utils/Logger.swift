//
//  Logger.swift
//  TestWebMacos
//
//  Created by dev Rakes on 08/05/2023.
//

import Foundation


class Logger {
  
  static func d(tag: String? = nil, message: String) {
    printLog(type: "[D]", tag: tag, message: message)
  }
  
  static func e(tag: String? = nil, message: String) {
    printLog(type: "[E]", tag: tag, message: message)
  }
  
  private static func printLog(type: String, tag: String?, message: String) {
    (tag != nil && tag!.isEmpty) ? print("\(type)-[\(tag!)]-\(message)") : print("[D]-\(message)")
  }
}
