//
//  ContentView.swift
//  TestWebMacos
//
//  Created by dev Rakes on 28/04/2023.
//

import SwiftUI
import Swifter
import WebKit

struct WebMacView: NSViewRepresentable {

  let link: String

  func makeNSView(context: Context) -> WKWebView {

    let webView = WKWebView(frame: CGRect.zero, configuration: Utils.getConfig())
    webView.navigationDelegate = context.coordinator
    webView.uiDelegate = context.coordinator
    return webView
  }

  func updateNSView(_ webView: WKWebView, context: Context) {

    DispatchQueue.global().async {

      if isLocalhost() {

        let url = URL(string: link)!
        let request = URLRequest(url: url)
        DispatchQueue.main.async {
          webView.load(request)
        }
      } else {
        guard
          let url = URL(string: link),
          let htmlContent = try? String(contentsOf: url, encoding: .utf8)
        else {
          assertionFailure("Fail to get agreement HTML")
          return
        }

        DispatchQueue.main.async {
          webView.loadHTMLString(htmlContent, baseURL: nil)
        }

      }
    }
  }

  func isLocalhost() -> Bool {
    return link.contains("localhost")
      || link.contains("0.0.0.0")
      || link.contains("127.0.0.1")
  }

  public class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
    var parent: WebMacView

    init(parent: WebMacView) {
      self.parent = parent
    }

    public func webView(
      _ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!
    ) {

    }

    public func webView(
      _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
      decisionHandler(.allow)
    }

    public func webView(
      _ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
      for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
      if navigationAction.targetFrame == nil {
        webView.load(navigationAction.request)
      }
      return nil
    }
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
}

//let ipAddress = "0.0.0.0"
let ipAddress = "127.0.0.1"
let port = 3000
//let ipAddress = "localhost"

struct ContentView: View {

  @State
  private var path: String = "http://\(ipAddress):\(port)/index"

  var body: some View {
    VStack {
      WebMacView(link: path)
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
