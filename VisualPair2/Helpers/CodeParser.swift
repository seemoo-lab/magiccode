//
//  WatchCode.swift
//  VisualPair2
//
//  Created by Leon Böttger on 15.08.25.
//

import Foundation
import SwiftUI

struct WatchCode {
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
        
        // Split watchOS version
        let parts = code.components(separatedBy: "&&")
        guard parts.count == 2 else { return nil }
        self.watchOSVersion = parts[1]
        
        // Split main part
        let fields = parts[0].components(separatedBy: "--")
        guard fields.count == 6 else { return nil }
        
        self.pairingVersion = fields[0]
        self.maxPairingVersion = fields[1]
        self.deviceName = fields[2]
        
        let oobKey = fields[3]
        // Must be exactly 2 + 32 + 2 + 32 = 68 chars
        guard oobKey.count == 68 else { return nil }
        
        // Check the "72" prefix and "63" delimiter
        guard oobKey.hasPrefix("72") else { return nil }
        let delimiterRange = oobKey.index(oobKey.startIndex, offsetBy: 34)..<oobKey.index(oobKey.startIndex, offsetBy: 36)
        guard oobKey[delimiterRange] == "63" else { return nil }
        
        // Extract random (after "72", 32 chars)
        let startRandom = oobKey.index(oobKey.startIndex, offsetBy: 2)
        let endRandom = oobKey.index(startRandom, offsetBy: 32)
        self.random = String(oobKey[startRandom..<endRandom])
        
        // Extract check (after "63", 32 chars)
        let startCheck = oobKey.index(oobKey.startIndex, offsetBy: 36)
        let endCheck = oobKey.index(startCheck, offsetBy: 32)
        self.check = String(oobKey[startCheck..<endCheck])
        
        self.materialIndex = Int(fields[4]) ?? 1
        self.sizeIndex = Int(fields[5]) ?? 1
    }
}


#Preview {
    Text(WatchCode(code: "3--15--21716DEI--726ECEF10C8009CF18BE30159DDODD423163A86CE827D4ADD20EF1C33046626801A2--4--8&&7.3.3").debugDescription)
}
