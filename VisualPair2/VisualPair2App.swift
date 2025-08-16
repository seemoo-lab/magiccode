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
            ContentView()
        }
    }
}


struct ContentView: View {
    
    @State var scanning = false
    
    var body: some View {
        ZStack {
            NavigationView {
                GeneratorView()
                .navigationBarItems(trailing: Button(action: {
                    withAnimation(.smooth) {
                        scanning.toggle()
                    }
                }, label: {
                    Text("Scan Code...")
                }))
            }
            .blur(radius: scanning ? 10 : 0)
            
            if scanning {
                Color.black.opacity(0.7)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                hideScanner()
                            })
                
                    .onTapGesture {
                        hideScanner()
                    }
                    .zIndex(.infinity)
            }
            
            if scanning {
                ScannerView()
                    .brightness(0.02)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                hideScanner()
                            })
                    .onTapGesture {
                        withAnimation(.smooth) {
                            scanning = false
                        }
                    }
                    .transition(.move(edge: .bottom))
                    .zIndex(.infinity)
            }
                //.offset(y: scanning ? 0 : UIScreen.main.bounds.height)
            
        }
        .navigationViewStyle(.stack)
        .preferredColorScheme(.dark)
    }
    
    
    func hideScanner() {
        withAnimation(.easeInOut(duration: 0.3)) {
            scanning = false
        }
    }
}
