//
//  Scanner.swift
//  VisualPair2
//
//  Created by Leon Böttger on 11.08.25.
//

import SwiftUI


// MARK: - Scan Tab
struct ScannerView: View {
    @State private var scannedCode = "Waiting for scan..."

    var body: some View {
        VStack(spacing: 0) {
            Text(scannedCode)
                .multilineTextAlignment(.center)
                .padding()

            VPScannerView { code in
                scannedCode = code
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            .aspectRatio(0.58, contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity) // fill space
            .padding(.bottom, 120)
        }
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
