//
//  Scanner.swift
//  VisualPair2
//
//  Created by Leon Böttger on 11.08.25.
//

import SwiftUI


// MARK: - Scan Tab
struct ScannerView: View {
    @State private var scannedCode: WatchCode? = nil
    @State private var isSheetPresented = false
    
    var body: some View {
        
        let showSheet = Binding {
            scannedCode != nil
        } set: { newValue in
            scannedCode = nil
        }
        
        VPScannerView { code in
            // only scan code if sheet view not presented
            if scannedCode == nil {
                scannedCode = WatchCode(code: code)
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }
        .aspectRatio(0.58, contentMode: .fill)
        .frame(maxWidth: .infinity, maxHeight: .infinity) // fill space
        .padding(.bottom, 120)
        
        .luiSheet(isPresented: showSheet, content: {
            NavigationView {
                if let scannedCode = scannedCode {
                    GeneratorSettingsView(deviceName: .constant(scannedCode.deviceName),
                                          watchOSVersion: .constant(scannedCode.watchOSVersion),
                                          pairingVersion: .constant(scannedCode.pairingVersion),
                                          maxPairingVersion: .constant(scannedCode.maxPairingVersion),
                                          random: .constant(scannedCode.random),
                                          check: .constant(scannedCode.check),
                                          materialIndex: .constant(scannedCode.materialIndex),
                                          sizeIndex: .constant(scannedCode.sizeIndex),
                                          code: scannedCode.code,
                                          canEdit: false)
                    .navigationBarItems(trailing: XButton(action: { showSheet.wrappedValue = false }))
                }
            }
        })
        .navigationTitle("Scan")
    }
}


// MARK: - Wrapper for VPScannerViewController
struct VPScannerView: UIViewControllerRepresentable {
    var onCodeScanned: (String) -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        let container = UIViewController()
        
        guard
            let cls: AnyObject = NSClassFromString("VPScannerViewController"),
            let scannerVC = cls.perform(NSSelectorFromString("instantiateViewController"))?
                .takeUnretainedValue() as? UIViewController
        else { return container }
        
        scannerVC.setValue("Hold the device that's generating the code up to the camera.", forKey: "titleMessage")
        
        // Important: Use this handler as swift closure will crash the app
        let handler: @convention(block) (NSString) -> Void = { code in
            DispatchQueue.main.async { onCodeScanned(code as String) }
        }
        
        scannerVC.setValue(handler, forKey: "scannedCodeHandler")
        
        container.addChild(scannerVC)
        scannerVC.view.translatesAutoresizingMaskIntoConstraints = false
        container.view.addSubview(scannerVC.view)
        NSLayoutConstraint.activate([
            scannerVC.view.topAnchor.constraint(equalTo: container.view.topAnchor),
            scannerVC.view.bottomAnchor.constraint(equalTo: container.view.bottomAnchor),
            scannerVC.view.leadingAnchor.constraint(equalTo: container.view.leadingAnchor),
            scannerVC.view.trailingAnchor.constraint(equalTo: container.view.trailingAnchor)
        ])
        scannerVC.didMove(toParent: container)
        
        return container
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


fileprivate struct WatchCode {
    var code: String
    var pairingVersion: String
    var maxPairingVersion: String
    var deviceName: String
    var random: String
    var check: String
    var materialIndex: Int
    var sizeIndex: Int
    var watchOSVersion: String
    
    init?(code: String) {
        
        self.code = code
        
        // Split by "&&" to separate watchOS version
        let parts = code.components(separatedBy: "&&")
        guard parts.count == 2 else { return nil }
        self.watchOSVersion = parts[1]
        
        // Split the first part by "--"
        let fields = parts[0].components(separatedBy: "--")
        guard fields.count == 6 else { return nil }
        
        self.pairingVersion = fields[0]
        self.maxPairingVersion = fields[1]
        self.deviceName = fields[2]
        
        let oobKey = fields[3]
        // oobKey = "72" + random + "63" + check
        // Remove prefix "72" and suffix "63" to extract random & check
        guard oobKey.count >= 4 else { return nil }
        let start = oobKey.index(oobKey.startIndex, offsetBy: 2)
        let end = oobKey.index(oobKey.endIndex, offsetBy: -2)
        let middle = oobKey[start..<end]
        let midCount = middle.count / 2
        let randomEnd = middle.index(middle.startIndex, offsetBy: midCount)
        self.random = String(middle[middle.startIndex..<randomEnd])
        self.check = String(middle[randomEnd..<middle.endIndex])
        
        self.materialIndex = Int(fields[4]) ?? 1
        self.sizeIndex = Int(fields[5]) ?? 1
    }
}
