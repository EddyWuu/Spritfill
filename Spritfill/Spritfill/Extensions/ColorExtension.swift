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

        if hexSanitized.count == 6 {
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
        } else {
            
            r = 1.0
            g = 1.0
            b = 1.0
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    func toHex() -> String? {
        UIColor(self).toHex()
    }
    
    var isClear: Bool {
        UIColor(self).cgColor.alpha < 0.01
    }
}
