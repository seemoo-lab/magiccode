//
//  Model.swift
//  VisualPair2
//
//  Created by Leon Böttger on 15.08.25.
//

import Foundation

enum Material: String, CaseIterable {
    case aluminiumCashmere = "Aluminium Cashmere"
    case aluminiumPink = "Aluminium Pink"
    case aluminiumLight = "Aluminium Light"
    case aluminiumDark = "Aluminium Dark"
    case aluminiumMirror = "Aluminium Mirror"
    case generic = "Generic"
    case black = "Black"
    case yellow = "Yellow"
    case rose = "Rose"
    case ceramic = "Ceramic"
    case ceramicGray = "Ceramic Gray"
    case aluminiumBlushGold = "Aluminium Blush Gold"
    case steelGold = "Steel Gold"
    case vapourPolishedNatural = "Vapour-Polished Natural"
    case vapourPolishedAlternate = "Vapour-Polished Alternate"
}

enum WatchSize: String, CaseIterable {
    case size42Millimetres = "42 mm"
    case size38Millimetres = "38 mm"
    case size40Millimetres = "40 mm"
    case size44Millimetres = "44 mm"
    case unknown5 = "Unknown 5"
    case unknown6 = "Unknown 6"
    case unknown7 = "Unknown 7"
    case unknown8 = "Unknown 8"
}
