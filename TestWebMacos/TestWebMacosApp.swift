//
//  TestWebMacosApp.swift
//  TestWebMacos
//
//  Created by dev Rakes on 28/04/2023.
//

import SwiftUI

@main
struct TestWebMacosApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

}
