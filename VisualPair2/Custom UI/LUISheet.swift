//
//  LUISheet.swift
//  AirGuard (iOS)
//
//  Created by Leon Böttger on 25.03.24.
//

import SwiftUI

struct LUISheet<Content1: View>: ViewModifier {
    
    internal init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content1) {
        self.sheetContent = content()
        self._isPresented = isPresented
    }
    
    let sheetContent: Content1
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented, content: {
                sheetContent
                    .environment(\.sheetActive, true)
                    .modifier(SheetCornerRadiusModifier())
            })
    }
}


struct SheetCornerRadiusModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .presentationCornerRadius(20)
        }
        else {
            content
        }
    }
}


public extension View {
    func luiSheet<Content1: View>(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content1) -> some View {
        self.modifier(LUISheet(isPresented: isPresented, content: content))
    }
}
