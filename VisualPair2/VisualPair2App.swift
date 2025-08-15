//
//  VisualPair2App.swift
//  VisualPair2
//
//  Created by Leon Böttger on 11.08.25.
//

import SwiftUI

// MARK: - Main App
@main
struct VisualPairingSwiftUIApp: App {
    init() {
        let _ = Bundle(path: "/System/Library/PrivateFrameworks/VisualPairing.framework")?.load()
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView { GeneratorView() }
                    .tabItem {
                        Image(systemName: "qrcode")
                        Text("Generate")
                    }
                NavigationView { ScannerView() }
                    .tabItem {
                        Image(systemName: "camera")
                        Text("Scan")
                    }
            }
            .preferredColorScheme(.dark)
        }
    }
}
