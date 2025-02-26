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
        
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)

        let r, g, b: Double
        let a: Double = 1.0

        switch hexSanitized.count {
            
        case 6: // RGB (e.g. "FF5733")
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
            
        case 8: // ARGB (e.g. "FF5733AA")
            r = Double((int >> 24) & 0xFF) / 255.0
            g = Double((int >> 16) & 0xFF) / 255.0
            b = Double((int >> 8) & 0xFF) / 255.0
            
        default:
            r = 1.0
            g = 1.0
            b = 1.0
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
