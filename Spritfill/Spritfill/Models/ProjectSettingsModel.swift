//
//  ProjectSettingsModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-29.
//

import SwiftUI

struct ProjectSettings: Codable {
    
    var selectedCanvasSize: CanvasSizes
    var selectedTileSize: TileSizes
    var selectedPalette: ColorPalettes
    var customPaletteColors: [String]?
    var extraColors: [String]
    
    init(selectedCanvasSize: CanvasSizes, selectedTileSize: TileSizes, selectedPalette: ColorPalettes) {
        self.selectedCanvasSize = selectedCanvasSize
        self.selectedTileSize = selectedTileSize
        self.selectedPalette = selectedPalette
        self.extraColors = []
        
        if case .custom(let id) = selectedPalette,
           let palette = CustomPaletteService.shared.fetchPalette(by: id) {
            self.customPaletteColors = palette.hexColors
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        selectedCanvasSize = try container.decode(CanvasSizes.self, forKey: .selectedCanvasSize)
        selectedTileSize = try container.decode(TileSizes.self, forKey: .selectedTileSize)
        selectedPalette = try container.decode(ColorPalettes.self, forKey: .selectedPalette)
        customPaletteColors = try container.decodeIfPresent([String].self, forKey: .customPaletteColors)
        extraColors = try container.decodeIfPresent([String].self, forKey: .extraColors) ?? []
    }
}


// MARK: - Color Palettes

enum ColorPalettes: Hashable, Codable {
    
    case endesga64
    case endesga32
    case zughy32
    case generic16
    case pico8
    case custom(id: String)
    
    static var builtInCases: [ColorPalettes] {
        [.endesga64, .endesga32, .zughy32, .generic16, .pico8]
    }
    
    var displayName: String {
        switch self {
        case .endesga64: return "Endesga 64"
        case .endesga32: return "Endesga 32"
        case .zughy32: return "Zughy 32"
        case .generic16: return "Generic 16"
        case .pico8: return "Pico-8"
        case .custom(let id):
            return CustomPaletteService.shared.fetchPalette(by: id)?.name ?? "Custom"
        }
    }
    
    var colors: [Color] {
        switch self {
        case .endesga64:
            return [
                Color(hex: "#ff0040"), Color(hex: "#131313"), Color(hex: "#1b1b1b"), Color(hex: "#272727"),
                Color(hex: "#3d3d3d"), Color(hex: "#5d5d5d"), Color(hex: "#858585"), Color(hex: "#b4b4b4"),
                Color(hex: "#ffffff"), Color(hex: "#c7cfdd"), Color(hex: "#92a1b9"), Color(hex: "#657392"),
                Color(hex: "#424c6e"), Color(hex: "#2a2f4e"), Color(hex: "#1a1932"), Color(hex: "#0e071b"),
                Color(hex: "#1c121c"), Color(hex: "#391f21"), Color(hex: "#5d2c28"), Color(hex: "#8a4836"),
                Color(hex: "#bf6f4a"), Color(hex: "#e69c69"), Color(hex: "#f6ca9f"), Color(hex: "#f9e6cf"),
                Color(hex: "#edab50"), Color(hex: "#e07438"), Color(hex: "#c64524"), Color(hex: "#8e251d"),
                Color(hex: "#ff5000"), Color(hex: "#ed7614"), Color(hex: "#ffa214"), Color(hex: "#ffc825"),
                Color(hex: "#ffeb57"), Color(hex: "#d3fc7e"), Color(hex: "#99e65f"), Color(hex: "#5ac54f"),
                Color(hex: "#33984b"), Color(hex: "#1e6f50"), Color(hex: "#134c4c"), Color(hex: "#0c2e44"),
                Color(hex: "#00396d"), Color(hex: "#0069aa"), Color(hex: "#0098dc"), Color(hex: "#00cdf9"),
                Color(hex: "#0cf1ff"), Color(hex: "#94fdff"), Color(hex: "#fdd2ed"), Color(hex: "#f389f5"),
                Color(hex: "#db3ffd"), Color(hex: "#7a09fa"), Color(hex: "#3003d9"), Color(hex: "#0c0293"),
                Color(hex: "#03193f"), Color(hex: "#3b1443"), Color(hex: "#622461"), Color(hex: "#93388f"),
                Color(hex: "#ca52c9"), Color(hex: "#c85086"), Color(hex: "#f68187"), Color(hex: "#f5555d"),
                Color(hex: "#ea323c"), Color(hex: "#c42430"), Color(hex: "#891e2b"), Color(hex: "#571c27")
            ]
            
        case .endesga32:
            return [
                Color(hex: "#be4a2f"), Color(hex: "#d77643"), Color(hex: "#ead4aa"), Color(hex: "#e4a672"),
                Color(hex: "#b86f50"), Color(hex: "#733e39"), Color(hex: "#3e2731"), Color(hex: "#a22633"),
                Color(hex: "#e43b44"), Color(hex: "#f77622"), Color(hex: "#feae34"), Color(hex: "#fee761"),
                Color(hex: "#63c74d"), Color(hex: "#3e8948"), Color(hex: "#265c42"), Color(hex: "#193c3e"),
                Color(hex: "#124e89"), Color(hex: "#0099db"), Color(hex: "#2ce8f5"), Color(hex: "#ffffff"),
                Color(hex: "#c0cbdc"), Color(hex: "#8b9bb4"), Color(hex: "#5a6988"), Color(hex: "#3a4466"),
                Color(hex: "#262b44"), Color(hex: "#181425"), Color(hex: "#ff0044"), Color(hex: "#68386c"),
                Color(hex: "#b55088"), Color(hex: "#f6757a"), Color(hex: "#e8b796"), Color(hex: "#c28569")
            ]
            
        case .zughy32:
            return [
                Color(hex: "#472d3c"), Color(hex: "#5e3643"), Color(hex: "#7a444a"), Color(hex: "#a05b53"),
                Color(hex: "#bf7958"), Color(hex: "#eea160"), Color(hex: "#f4cca1"), Color(hex: "#b6d53c"),
                Color(hex: "#71aa34"), Color(hex: "#397b44"), Color(hex: "#3c5956"), Color(hex: "#302c2e"),
                Color(hex: "#5a5353"), Color(hex: "#7d7071"), Color(hex: "#a0938e"), Color(hex: "#cfc6b8"),
                Color(hex: "#dff6f5"), Color(hex: "#8aebf1"), Color(hex: "#28ccdf"), Color(hex: "#3978a8"),
                Color(hex: "#394778"), Color(hex: "#39314b"), Color(hex: "#564064"), Color(hex: "#8e478c"),
                Color(hex: "#cd6093"), Color(hex: "#ffaeb6"), Color(hex: "#f4b41b"), Color(hex: "#f47e1b"),
                Color(hex: "#e6482e"), Color(hex: "#a93b3b"), Color(hex: "#827094"), Color(hex: "#4f546b")
            ]
        
        case .generic16:
            return [
                Color(hex: "#000000"), Color(hex: "#9D9D9D"), Color(hex: "#FFFFFF"), Color(hex: "#BE2633"),
                Color(hex: "#E06F8B"), Color(hex: "#493C2B"), Color(hex: "#A46422"), Color(hex: "#EB8931"),
                Color(hex: "#F7E26B"), Color(hex: "#2F484E"), Color(hex: "#44891A"), Color(hex: "#A3CE27"),
                Color(hex: "#1B2632"), Color(hex: "#005784"), Color(hex: "#31A2F2"), Color(hex: "#B2DCEF")
            ]
            
        case .pico8:
            return [
                Color(hex: "#000000"), Color(hex: "#1D2B53"), Color(hex: "#7E2553"), Color(hex: "#008751"),
                Color(hex: "#AB5236"), Color(hex: "#5F574F"), Color(hex: "#C2C3C7"), Color(hex: "#FFF1E8"),
                Color(hex: "#FF004D"), Color(hex: "#FFA300"), Color(hex: "#FFEC27"), Color(hex: "#00E436"),
                Color(hex: "#29ADFF"), Color(hex: "#83769C"), Color(hex: "#FF77A8"), Color(hex: "#FFCCAA")
            ]
            
        case .custom(let id):
            if let palette = CustomPaletteService.shared.fetchPalette(by: id) {
                return palette.hexColors.map { Color(hex: $0) }
            }
            return [.black, .white]
        }
    }
    
    func resolvedColors(embeddedColors: [String]?) -> [Color] {
        if case .custom(let id) = self {
            if let palette = CustomPaletteService.shared.fetchPalette(by: id) {
                return palette.hexColors.map { Color(hex: $0) }
            }
            if let embedded = embeddedColors, !embedded.isEmpty {
                return embedded.map { Color(hex: $0) }
            }
            return [.black, .white]
        }
        return colors
    }
    
    // Custom Codable to handle associated value
    
    enum CodingKeys: String, CodingKey {
        case type, customId
    }
    
    init(from decoder: Decoder) throws {
        // Try new keyed format first
        if let container = try? decoder.container(keyedBy: CodingKeys.self),
           let type = try? container.decode(String.self, forKey: .type) {
            switch type {
            case "Endesga 64": self = .endesga64
            case "Endesga 32": self = .endesga32
            case "Zughy 32": self = .zughy32
            case "Generic 16": self = .generic16
            case "Pico-8": self = .pico8
            case "custom":
                let id = try container.decode(String.self, forKey: .customId)
                self = .custom(id: id)
            default:
                self = .endesga64
            }
            return
        }
        
        // Fall back to old raw string format for existing saved projects
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        switch rawValue {
        case "Endesga 64": self = .endesga64
        case "Endesga 32": self = .endesga32
        case "Zughy 32": self = .zughy32
        case "Generic 16": self = .generic16
        case "Pico-8": self = .pico8
        default: self = .endesga64
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .endesga64: try container.encode("Endesga 64", forKey: .type)
        case .endesga32: try container.encode("Endesga 32", forKey: .type)
        case .zughy32: try container.encode("Zughy 32", forKey: .type)
        case .generic16: try container.encode("Generic 16", forKey: .type)
        case .pico8: try container.encode("Pico-8", forKey: .type)
        case .custom(let id):
            try container.encode("custom", forKey: .type)
            try container.encode(id, forKey: .customId)
        }
    }
}

// MARK: - Canvas Sizes

enum CanvasSizes: String, CaseIterable, Codable {
    
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

// MARK: - Tile Sizes

enum TileSizes: String, CaseIterable, Codable {
    
    case small   // 8x8 per tile
    case medium  // 16x16 per tile
    case big     // 32x32 per tile
    
    var size: Int {
        
        switch self {
        
        case .small:
            return 8
        
        case .medium:
            return 16
        
        case .big:
            return 32
        }
    }
}

// MARK: - Canvas Route

enum CanvasRoute: Hashable {
    case newProject
    case projectCreate(UUID)
    case projectView(UUID)
}



// MARK: helper extension for UIcolor from hex

extension UIColor {
    
    convenience init(hex: String) {
        
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        
        self.init(
            
            red: CGFloat((hexNumber & 0xFF0000) >> 16) / 255,
            green: CGFloat((hexNumber & 0x00FF00) >> 8) / 255,
            blue: CGFloat(hexNumber & 0x0000FF) / 255,
            alpha: 1.0
        )
    }
}

extension UIColor {
    func toHex() -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)

        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

