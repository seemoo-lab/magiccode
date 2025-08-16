//
//  ScannerView.swift
//  VisualPair2
//
//  Created by Leon Böttger on 11.08.25.
//

import SwiftUI

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


#Preview {
    ScannerView()
}
