//
//  Generator.swift
//  VisualPair2
//
//  Created by Leon Böttger on 11.08.25.
//

import SwiftUI
import UIKit

// MARK: - Generate Tab
struct GeneratorView: View {
    @State private var deviceName = "21716DEI"
    @State private var materialIndex = 1
    @State private var sizeIndex = 1

    private let materials = [
        "AlumCashmere", "AlumPink", "AlumLight", "AlumDark", "AlumMirror",
        "Generic", "Black", "Yellow", "Rose", "Ceramic", "Ceramic Gray",
        "AlumBlushGold", "SteelGold", "vp-natural", "vp-alternate"
    ]
    private let sizes = [
        "42mm (1)", "38mm (2)", "40mm (3)", "44mm (4)",
        "unk (5)", "unk (6)", "unk (7)", "unk (8)"
    ]

    private var code: String {
        "3--15--\(deviceName)--723AA261D4F461D69D58D7E02C645ABEDB63DEF5E5D3EA3C19EB0304926719B1BB28--\(materialIndex)--\(sizeIndex)&&7.3.3"
    }

    var body: some View {
        VStack(spacing: 20) {
            TextField("Device Name", text: $deviceName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            HStack {
                Text("Material: \(materials[materialIndex - 1])")
                Spacer()
                Stepper("", value: $materialIndex, in: 1...15)
            }.padding(.horizontal)

            HStack {
                Text("Size: \(sizes[sizeIndex - 1])")
                Spacer()
                Stepper("", value: $sizeIndex, in: 1...8)
            }.padding(.horizontal)

            Spacer()

            VPPresenterView(code: code)
                .frame(width: 300, height: 300)
                .background(Color.black)
                //.cornerRadius(20)
                .shadow(color: .white, radius: 1)
                

            Spacer()
        }
        .navigationTitle("Generate")
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
            presenter.perform(NSSelectorFromString("setVerificationCode:"), with: code)
            presenter.perform(NSSelectorFromString("start"))
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
