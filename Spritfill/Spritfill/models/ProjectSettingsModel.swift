//
//  ProjectSettingsModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-29.
//

import SwiftUI

struct ProjectSettings: Identifiable {
    let id = UUID()
    var canvasSize: CanvasSizes
    var tileSize: TileSizes
    var selectedPalette: ColorPalettes
}

enum ColorPalettes: String, CaseIterable {
    
    case endesga64 = "Endesga 64"   // 64 colors
    case endesga32 = "Endesga 32"   // 32 colors
    case zughy32 = "Zughy 32"   // 32 colors
    case generic16 = "Generic 16"   // 16 colors
    case pico8 = "Pico-8"   // 16 colors
    
    var colors: [Color] {
        
        switch self {
        case .endesga64:
            return [
                Color("#ff0040"), Color("#131313"), Color("#1b1b1b"), Color("#272727"),
                Color("#3d3d3d"), Color("#5d5d5d"), Color("#858585"), Color("#b4b4b4"),
                Color("#ffffff"), Color("#c7cfdd"), Color("#92a1b9"), Color("#657392"),
                Color("#424c6e"), Color("#2a2f4e"), Color("#1a1932"), Color("#0e071b"),
                Color("#1c121c"), Color("#391f21"), Color("#5d2c28"), Color("#8a4836"),
                Color("#bf6f4a"), Color("#e69c69"), Color("#f6ca9f"), Color("#f9e6cf"),
                Color("#edab50"), Color("#e07438"), Color("#c64524"), Color("#8e251d"),
                Color("#ff5000"), Color("#ed7614"), Color("#ffa214"), Color("#ffc825"),
                Color("#ffeb57"), Color("#d3fc7e"), Color("#99e65f"), Color("#5ac54f"),
                Color("#33984b"), Color("#1e6f50"), Color("#134c4c"), Color("#0c2e44"),
                Color("#00396d"), Color("#0069aa"), Color("#0098dc"), Color("#00cdf9"),
                Color("#0cf1ff"), Color("#94fdff"), Color("#fdd2ed"), Color("#f389f5"),
                Color("#db3ffd"), Color("#7a09fa"), Color("#3003d9"), Color("#0c0293"),
                Color("#03193f"), Color("#3b1443"), Color("#622461"), Color("#93388f"),
                Color("#ca52c9"), Color("#c85086"), Color("#f68187"), Color("#f5555d"),
                Color("#ea323c"), Color("#c42430"), Color("#891e2b"), Color("#571c27")
            ]
            
        case .endesga32:
            return [
                Color("#be4a2f"), Color("#d77643"), Color("#ead4aa"), Color("#e4a672"),
                Color("#b86f50"), Color("#733e39"), Color("#3e2731"), Color("#a22633"),
                Color("#e43b44"), Color("#f77622"), Color("#feae34"), Color("#fee761"),
                Color("#63c74d"), Color("#3e8948"), Color("#265c42"), Color("#193c3e"),
                Color("#124e89"), Color("#0099db"), Color("#2ce8f5"), Color("#ffffff"),
                Color("#c0cbdc"), Color("#8b9bb4"), Color("#5a6988"), Color("#3a4466"),
                Color("#262b44"), Color("#181425"), Color("#ff0044"), Color("#68386c"),
                Color("#b55088"), Color("#f6757a"), Color("#e8b796"), Color("#c28569")
            ]
            
        case .zughy32:
            return [
                Color("#472d3c"), Color("#5e3643"), Color("#7a444a"), Color("#a05b53"),
                Color("#bf7958"), Color("#eea160"), Color("#f4cca1"), Color("#b6d53c"),
                Color("#71aa34"), Color("#397b44"), Color("#3c5956"), Color("#302c2e"),
                Color("#5a5353"), Color("#7d7071"), Color("#a0938e"), Color("#cfc6b8"),
                Color("#dff6f5"), Color("#8aebf1"), Color("#28ccdf"), Color("#3978a8"),
                Color("#394778"), Color("#39314b"), Color("#564064"), Color("#8e478c"),
                Color("#cd6093"), Color("#ffaeb6"), Color("#f4b41b"), Color("#f47e1b"),
                Color("#e6482e"), Color("#a93b3b"), Color("#827094"), Color("#4f546b")
            ]
        
        case .generic16:
            return [
                Color("#000000"), Color("#9D9D9D"), Color("#FFFFFF"), Color("#BE2633"),
                Color("#E06F8B"), Color("#493C2B"), Color("#A46422"), Color("#EB8931"),
                Color("#F7E26B"), Color("#2F484E"), Color("#44891A"), Color("#A3CE27"),
                Color("#1B2632"), Color("#005784"), Color("#31A2F2"), Color("#B2DCEF")
            ]
            
        case .pico8:
            return [
                Color("#000000"), Color("#1D2B53"), Color("#7E2553"), Color("#008751"),
                Color("#AB5236"), Color("#5F574F"), Color("#C2C3C7"), Color("#FFF1E8"),
                Color("#FF004D"), Color("#FFA300"), Color("#FFEC27"), Color("#00E436"),
                Color("#29ADFF"), Color("#83769C"), Color("#FF77A8"), Color("#FFCCAA")
            ]
            
        }
    }
}

enum CanvasSizes: CaseIterable {
    
    case smallSquare  // 16x16
    case mediumSquare // 32x32
    case largeSquare  // 64x64
    case extraLargeSquare // 128x128
    case wide // 64x32
    case tall // 32x64
    case landscape // 80x60
    case portrait // 60x80
    
    
    // (width, height)
    var dimensions: (width: Int, height: Int) {
        
        switch self {
            
        case .smallSquare:
            return (16, 16)
            
        case .mediumSquare:
            return (32, 32)
            
        case .largeSquare:
            return (64, 64)
            
        case .extraLargeSquare:
            return (128, 128)
            
        case .wide:
            return (64, 32)
            
        case .tall:
            return (32, 64)
            
        case .landscape:
            return (80, 60)
            
        case .portrait:
            return (60, 80)
            
        }
    }
}

enum TileSizes: CaseIterable {
    
    case small
    case medium
    case big
    
    var dimensions: (width: Int, height: Int) {
        
        switch self {
            
        case .small:
            return (1, 1)
            
        case .medium:
            return (2, 2)
            
        case .big:
            return (4, 4)
        }
    }
}
