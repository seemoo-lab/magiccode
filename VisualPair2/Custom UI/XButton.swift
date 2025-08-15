//
//  XButton.swift
//  VisualPair2
//
//  Created by Leon Böttger on 15.08.25.
//

import SwiftUI

public struct XButton: View {
    
    public init(action: @escaping () -> ()) {
        self.action = action
    }
    
    let action: () -> ()
    
    public var body: some View {
        RoundGrayButton(imageName: "xmark", action: action)
    }
}


public struct RoundGrayButton: View {
    
    public init(imageName: String, action: @escaping () -> ()) {
        self.imageName = imageName
        self.action = action
    }
    
    let imageName: String
    let action: () -> ()
    
    public var body: some View {
        LUIButton(action: action, label: {
            RoundGrayIcon(imageName: imageName)
        })
    }
}


public struct RoundGrayIcon: View {
    
    public init(imageName: String, color: Color = .grayColor) {
        self.imageName = imageName
        self.color = color
    }
    
    let imageName: String
    let color: Color
    
    public var body: some View {
        
        let sz = 16.5
        
        Image(systemName: imageName)
            .scaleEffect(0.9)
            .font(.system(size: 12).weight(.heavy))
            .foregroundColor(color)
            .frame(width: sz, height: sz)
            .padding(7)
            .background(Circle().foregroundColor(color.opacity(0.15)))
    }
}
