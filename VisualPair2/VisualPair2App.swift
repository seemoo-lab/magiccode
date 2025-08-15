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
    
    @State var scanning = false
    
    var body: some Scene {
        WindowGroup {
            
            VStack {
                NavigationView {
                    ZStack {
                        if scanning {
                            ScannerView()
                        }
                        else {
                            GeneratorView()
                        }
                    }
                    .navigationBarItems(trailing: Button(action: {
                        scanning.toggle()
                    }, label: {
                        Text(scanning ? "Generate Code..." : "Scan Code...")
                            .id("toggleButton" + scanning.description)
                    }))
                }
            }
            .navigationViewStyle(.stack)
            .preferredColorScheme(.dark)
        }
    }
}
