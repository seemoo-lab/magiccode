//
//  GeneratorSettings.swift
//  VisualPair2
//
//  Created by Leon Böttger on 15.08.25.
//

import SwiftUI

struct GeneratorSettingsView: View {
    
    @Binding var deviceName: String
    @Binding var watchOSVersion: String
    @Binding var pairingVersion: String
    @Binding var maxPairingVersion: String
    @Binding var random: String
    @Binding var check: String
    @Binding var materialIndex: Int
    @Binding var sizeIndex: Int
    
    let code: String
    let canEdit: Bool
    
    private let materials = [
        "Aluminium Cashmere",
        "Aluminium Pink",
        "Aluminium Light",
        "Aluminium Dark",
        "Aluminium Mirror",
        "Generic",
        "Black",
        "Yellow",
        "Rose",
        "Ceramic",
        "Ceramic Gray",
        "Aluminium Blush Gold",
        "Steel Gold",
        "Vapour-Polished Natural",
        "Vapour-Polished Alternate"
    ]

    private let sizes = [
        "42 mm",
        "38 mm",
        "40 mm",
        "44 mm",
    ]
    
    var body: some View {
        NavigationSubView {
            CustomSection {
                // Device name input
                SettingsLabel(imageName: "textformat", text: "Bluetooth Name") {
                    TextField("Name", text: $deviceName)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.mainColor)
                }
                
                SettingsLabel(imageName: "arrow.down.applewatch", text: "watchOS Version", backgroundColor: .green) {
                    TextField("Version", text: $watchOSVersion)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.mainColor)
                }
                
                SettingsLabel(imageName: "applewatch.radiowaves.left.and.right", text: "Pairing Version", backgroundColor: .orange) {
                    TextField("Version", text: $pairingVersion)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.mainColor)
                }
                
                SettingsLabel(imageName: "inset.filled.triangle", text: "Max. Pairing Vers.", backgroundColor: .red) {
                    TextField("Version", text: $maxPairingVersion)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.mainColor)
                }
            }
            
            CustomSection(header: "Verification Code") {
                SettingsLabel(imageName: "dice", text: "Random") {
                    TextField("Random", text: $random)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.mainColor)
                }
                
                SettingsLabel(imageName: "checkmark", text: "Check", backgroundColor: .green) {
                    TextField("Check", text: $check)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.mainColor)
                }
            }
            
            CustomSection(header: "Watch Appearance") {
                // Material picker
                HStack {
                    SettingsLabel(imageName: "paintbrush.pointed.fill", text: "Material", backgroundColor: .orange) {
                        ZStack {
                            if canEdit {
                                Picker("Material", selection: $materialIndex) {
                                    ForEach(1...materials.count, id: \.self) { index in
                                        Text(materials[index - 1])
                                            .tag(index)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            else {
                                Text(materials[materialIndex])
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }

                // Size picker
                HStack {
                    SettingsLabel(imageName: "ruler", text: "Size", backgroundColor: .indigo) {
                        ZStack {
                            if canEdit {
                                Picker("Size", selection: $sizeIndex) {
                                    ForEach(1...sizes.count, id: \.self) { index in
                                        Text(sizes[index - 1])
                                            .tag(index)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            else {
                                Text(sizes[sizeIndex])
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
            }
            
            CustomSection(header: canEdit ? "Generated Code" : "Scanned Code") {
                Text(code)
                    .font(.system(.footnote, design: .monospaced))
                    .lineLimit(nil)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(canEdit ? "Settings" : "Info")
    }
}


#Preview {
    NavigationView {
        GeneratorSettingsView(deviceName: .constant("Apple Watch"),
                              watchOSVersion: .constant("9.0"),
                              pairingVersion: .constant("1.0"),
                              maxPairingVersion: .constant("2.0"),
                              random: .constant("12345678"),
                              check: .constant("87654321"),
                              materialIndex: .constant(0),
                              sizeIndex: .constant(0),
                              code: "Generated Code Example",
                              canEdit: true)
    }
}
