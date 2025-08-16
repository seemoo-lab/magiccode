//
//  TextFieldLabel.swift
//  VisualPair2
//
//  Created by Leon Böttger on 16.08.25.
//

import SwiftUI
import Combine

/// Allowed character sets for validation
struct InputOptions: OptionSet {
    let rawValue: Int
    
    static let numbers     = InputOptions(rawValue: 1 << 0)
    static let hex         = InputOptions(rawValue: 1 << 1)
    static let dots        = InputOptions(rawValue: 1 << 2)
    
    var allowedCharacters: CharacterSet {
        var set = CharacterSet()
        if contains(.numbers) { set.formUnion(.decimalDigits) }
        if contains(.hex) { set.formUnion(CharacterSet(charactersIn: "abcdefABCDEF0123456789")) }
        if contains(.dots) { set.formUnion(CharacterSet(charactersIn: ".")) }
        return set
    }
}

struct LabeledTextField: View {
    @Binding var text: String
    let imageName: String
    let labelText: String
    let labelColor: Color
    let defaultText: String
    let characterLimit: Int?
    let inputOptions: InputOptions?
    let allowsEditing: Bool
    
    @State private var previousValue: String = ""
    @FocusState private var isFocused: Bool
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        
        SettingsLabel(imageName: imageName, text: labelText, backgroundColor: labelColor) {
            TextField(defaultText, text: $text)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.mainColor)
                .focused($isFocused)
                .onChange(of: isFocused) { focus in
                    if focus {
                        DispatchQueue.main.async {
                            UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
                        }
                    }
                }
                .onChange(of: text) { newValue in
                    filterInput(newValue)
                }
                .onSubmit {
                    validateFinal()
                }
                .onAppear {
                    previousValue = text
                }
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.trailing)
                .disabled(!allowsEditing)
                .opacity(allowsEditing ? 1 : 0.5)
        }
        .alert("Invalid Input", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .if(!allowsEditing, transform: {
            $0
            .contentShape(Rectangle())
            .onTapGesture {
                copyToClipboard(string: text)
            }
        })
    }
    
    private func filterInput(_ newValue: String) {
        // Restrict to allowed characters
        if let inputOptions = inputOptions {
            let filtered = newValue.filter { char in
                char.unicodeScalars.allSatisfy { inputOptions.allowedCharacters.contains($0) }
            }
            if filtered != newValue {
                text = filtered
                showRevertMessage("Only \(describeAllowedCharacters()) are allowed.")
            }
        }
        
        // Limit length
        if let limit = characterLimit, text.count > limit {
            text = String(text.prefix(limit))
            showRevertMessage("Maximum length is \(limit) characters.")
        }
    }
    
    private func validateFinal() {
        if let limit = characterLimit, text.count != limit {
            text = previousValue // revert
            showRevertMessage("Input needs to be \(limit) characters long. Reverted to previous value.")
        } else if text.isEmpty {
            text = previousValue
        } else {
            previousValue = text
        }
    }
    
    private func showRevertMessage(_ message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func describeAllowedCharacters() -> String {
        var parts: [String] = []
        
        if let inputOptions = inputOptions {
            if inputOptions.contains(.numbers) { parts.append("numbers") }
            if inputOptions.contains(.hex) { parts.append("hexadecimal") }
            if inputOptions.contains(.dots) { parts.append("dots") }
            return parts.joined(separator: ", ")
        }
        
        return ""
    }
}


fileprivate struct Preview: View {
    
    @State private var text: String = ""
    
    var body: some View {
        ZStack {
            
            Color.defaultBackground
                .ignoresSafeArea()
            
            CustomSection {
                LabeledTextField(
                    text: $text,
                    imageName: "pencil",
                    labelText: "Enter text",
                    labelColor: .blue,
                    defaultText: "Version",
                    characterLimit: 5,
                    inputOptions: [.numbers, .hex],
                    allowsEditing: true
                )
            }
        }
    }
}


#Preview {
    Preview()
}
