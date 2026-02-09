//
//  GeneratorSettingsView.swift
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
                
                LabeledTextField(text: $deviceName, imageName: "textformat", labelText: "Bluetooth Name", labelColor: .blue, defaultText: "Name", characterLimit: 8, inputOptions: nil, allowsEditing: canEdit)
                
                LabeledTextField(text: $watchOSVersion, imageName: "arrow.down.applewatch", labelText: "watchOS Version", labelColor: .green, defaultText: "Version", characterLimit: nil, inputOptions: [.numbers, .dots], allowsEditing: canEdit)
                
                LabeledTextField(text: $pairingVersion, imageName: "applewatch.radiowaves.left.and.right", labelText: "Pairing Version", labelColor: .orange, defaultText: "Version", characterLimit: nil, inputOptions: .numbers, allowsEditing: canEdit)
                
                LabeledTextField(text: $maxPairingVersion, imageName: "inset.filled.triangle", labelText: "Max. Pairing Vers.", labelColor: .red, defaultText: "Version", characterLimit: nil, inputOptions: .numbers, allowsEditing: canEdit)
            }
            
            CustomSection(header: "Verification Code") {
                
                LabeledTextField(text: $random, imageName: "dice", labelText: "Random", labelColor: .blue, defaultText: "Random", characterLimit: 32, inputOptions: .hex, allowsEditing: canEdit)
                
                LabeledTextField(text: $check, imageName: "checkmark", labelText: "Check", labelColor: .green, defaultText: "Check", characterLimit: 32, inputOptions: .hex, allowsEditing: canEdit)
            }
            
            CustomSection(header: "Watch Appearance") {
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
                            else if(materialIndex < materials.count) {
                                Text(materials[materialIndex-1])
                                    .foregroundStyle(.gray)
                            }
                            else {
                                Text("unknown(\(materialIndex))")
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                
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
                        else if(sizeIndex < sizes.count) {
                            Text(sizes[sizeIndex-1])
                                .foregroundStyle(.gray)
                        }
                        else {
                            Text("unknown(\(sizeIndex))")
                                .foregroundStyle(.gray)
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
                    .contentShape(Rectangle())
                    .onTapGesture {
                        copyToClipboard(string: code)
                    }
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
