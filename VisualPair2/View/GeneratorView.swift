//
//  Generator.swift
//  VisualPair2
//
//  Created by Leon Böttger on 11.08.25.
//

import SwiftUI
import UIKit

struct GeneratorView: View {
    @AppStorage("deviceName") private var deviceName = "21716DEI"
    @AppStorage("watchOSVersion") private var watchOSVersion = "7.3.3"
    @AppStorage("pairingVersion") private var pairingVersion = "3"
    @AppStorage("maxPairingVersion") private var maxPairingVersion = "15"
    @AppStorage("random") private var random = "3AA261D4F461D69D58D7E02C645ABEDB"
    @AppStorage("check") private var check = "DEF5E5D3EA3C19EB0304926719B1BB28"
    @AppStorage("materialIndex") private var materialIndex = 1
    @AppStorage("sizeIndex") private var sizeIndex = 1
    
    private var oobKey: String {
        "72" + random + "63" + check
    }
    
    private var code: String {
        "\(pairingVersion)--\(maxPairingVersion)--\(deviceName)--\(oobKey)--\(materialIndex)--\(sizeIndex)&&\(watchOSVersion)"
    }
    
    var body: some View {
        VStack {
            
            let codeSize = 180.0
            
            Image(.appleWatch)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 260)
                .background(
                    ZStack {
                        PairingAnimation(size: codeSize*1.2)
                        VPPresenterView(code: code)
                            .opacity(0.5)
                    }
                    .frame(width: codeSize, height: codeSize)
                )
            
            LUILink(destination:  GeneratorSettingsView(
                deviceName: $deviceName,
                watchOSVersion: $watchOSVersion,
                pairingVersion: $pairingVersion,
                maxPairingVersion: $maxPairingVersion,
                random: $random,
                check: $check,
                materialIndex: $materialIndex,
                sizeIndex: $sizeIndex,
                code: code,
                canEdit: true
            )) {
                HStack {
                    Text("Settings")
                    Image(systemName: "chevron.right")
                        .opacity(0.5)
                }
                .padding(.horizontal, 5)
                .padding()
                .background(
                    Capsule()
                        .foregroundStyle(.gray.opacity(0.2))
                )
            }
            .frame(height: 100, alignment: .bottom)
        }
        .frame(maxHeight: .infinity)
        .navigationTitle("VisualPair2")
    }
}


// MARK: - Wrapper for VPPresenterView
struct VPPresenterView: UIViewRepresentable {
    var code: String
    
    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        if let cls = NSClassFromString("VPPresenterView") as? UIView.Type {
            let presenter = cls.init(frame: .zero)
            presenter.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(presenter)
            NSLayoutConstraint.activate([
                presenter.widthAnchor.constraint(equalTo: container.widthAnchor),
                presenter.heightAnchor.constraint(equalTo: container.heightAnchor),
                presenter.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                presenter.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
            
            // Set the code and start the presenter
            runAfter(seconds: 0.1) {
                presenter.perform(NSSelectorFromString("setVerificationCode:"), with: code)
                presenter.perform(NSSelectorFromString("start"))
            }
        }
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let presenter = uiView.subviews.first {
            presenter.perform(NSSelectorFromString("stop"))
            presenter.perform(NSSelectorFromString("setVerificationCode:"), with: code)
            presenter.perform(NSSelectorFromString("start"))
        }
    }
}


#Preview {
    NavigationView {
        GeneratorView()
    }
}
