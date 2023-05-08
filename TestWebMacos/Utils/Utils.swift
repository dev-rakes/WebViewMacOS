//
//  Utils.swift
//  TestWebMacos
//
//  Created by dev Rakes on 06/05/2023.
//

import Foundation
import WebKit

class Utils {

  static func getConfig() -> WKWebViewConfiguration {

    let css = loadCss()

    // Make CSS into single liner
    let cssString = css.components(separatedBy: .newlines).joined()

    // Create JavaScript that loads the CSS
    let javaScript = loadJavascript(css: cssString)

    // Create user script that inject the JavaScript after the HTML finishes loading
    let userScript = WKUserScript(
      source: javaScript,
      injectionTime: .atDocumentEnd,
      forMainFrameOnly: true)

    let userContentController = WKUserContentController()
    userContentController.addUserScript(userScript)
    let configuration = WKWebViewConfiguration()
    configuration.userContentController = userContentController
    return configuration

  }

  static func loadCss() -> String {
    do {
      let css = try loadFile("styles", "css")
      return css
    } catch let error {
      print("[E]\(error)")
    }

    return ""
  }

  static func loadJavascript(css: String = "") -> String {
    do {
      var temp = try loadFile("app", "js")
      temp = temp.replacing("{{CSS}}", with: css)
      return temp
    } catch let error {
      print("[E]\(error)")
    }
    return ""
  }

  static func loadFile(_ name: String, _ ext: String) throws -> String {
    guard
      let url = Bundle.main.path(
        forResource: name,
        ofType: ext
      )
    else {
      throw Error.fileNotFound(name: name)
    }

    do {
      return try String(contentsOfFile: url)
    } catch {
      throw Error.fileDecodingFailed(name: name, error)
    }
  }

  enum Error: Swift.Error {
    case fileNotFound(name: String)
    case fileDecodingFailed(name: String, Swift.Error)
  }

  static func macSerialNumber() -> String {
    let platformExpert: io_service_t = IOServiceGetMatchingService(
      kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))

    guard
      let serialNumberAsCFString = IORegistryEntryCreateCFProperty(
        platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0)
    else { fatalError("Can not get serialNumberAsCFString") }

    IOObjectRelease(platformExpert)

    return (serialNumberAsCFString.takeUnretainedValue() as? String) ?? ""
  }

  static func applicationDidFinishLaunching(_ aNotification: Notification) {
    print("Unique Device Identifier: \(macSerialNumber())")
  }
}
