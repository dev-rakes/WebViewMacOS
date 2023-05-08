//
//  AppDelegate.swift
//  TestWebMacos
//
//  Created by dev Rakes on 05/05/2023.
//

import Foundation
import SwiftUI
import Swifter

class AppDelegate: NSObject, NSApplicationDelegate {

  static private(set) var instance: AppDelegate! = nil

  var server: HttpServer!

  func applicationDidFinishLaunching(_ notification: Notification) {
    AppDelegate.instance = self

    Logger.d(message: "\(Utils.macSerialNumber())")

    setupServer()
  }
}


extension AppDelegate {

  func setupServer() {
    do {
      server = HttpServer()
      server["/index"] = { request in
        self.createIndex(request)
      }
      server["/api"] = { request in
        request.path
        let response = BaseResponse(
          deviceId: Utils.macSerialNumber()
        )

        return HttpResponse.ok(.text(response.convertToString ?? ""))
      }

      try server.start(3000, forceIPv4: true)
      Logger.d(message: "Server has started (port = \(3000) ). Try to connect now...")

    } catch {
      Logger.e(message: "Server start error: \(error)")
    }
  }

  func createIndex(_ request: HttpRequest) -> HttpResponse {
    do {
      let htmlData = try Utils.loadFile("index", "html")
      return HttpResponse.ok(.html(htmlData))
    } catch {
      return HttpResponse.ok(.htmlBody("Error: \(error)"))
    }
  }

}
