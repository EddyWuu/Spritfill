//
//  ColorExtension.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-31.
//

import SwiftUI

extension Color {
    
    // MARK: - initializer
    
    init(hex: String) {
        // Fast manual UTF8 hex parsing — avoids Scanner overhead on large canvases.
        let start = hex.hasPrefix("#") ? hex.utf8.index(after: hex.utf8.startIndex) : hex.utf8.startIndex
        let bytes = hex.utf8[start...]
        
        guard bytes.count >= 6 else {
            self.init(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
            return
        }
        
        var val: UInt32 = 0
        for byte in bytes.prefix(6) {
            val <<= 4
            switch byte {
            case 0x30...0x39: val |= UInt32(byte - 0x30)       // 0-9
            case 0x41...0x46: val |= UInt32(byte - 0x41 + 10)  // A-F
            case 0x61...0x66: val |= UInt32(byte - 0x61 + 10)  // a-f
            default:
                self.init(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
                return
            }
        }
        
        let r = Double((val >> 16) & 0xFF) / 255.0
        let g = Double((val >> 8) & 0xFF) / 255.0
        let b = Double(val & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, opacity: 1.0)
    }
    
    func toHex() -> String? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return String(format: "#%02X%02X%02X", Int(round(r * 255)), Int(round(g * 255)), Int(round(b * 255)))
    }
    
    var isClear: Bool {
        UIColor(self).cgColor.alpha < 0.01
    }
}
