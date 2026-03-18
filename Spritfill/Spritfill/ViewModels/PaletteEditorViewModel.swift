//
//  PaletteEditorViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-17.
//

import SwiftUI

class PaletteEditorViewModel: ObservableObject {
    
    @Published var paletteName: String
    @Published var colors: [String]
    @Published var hue: Double = 0.0
    @Published var saturation: Double = 1.0
    @Published var brightness: Double = 1.0
    @Published var hexInput: String = ""
    @Published var addedFlash: Bool = false
    @Published var overrideHex: String? = nil  // Exact hex from typed input — avoids HSB roundtrip loss
    
    let existingPalette: CustomPaletteData?
    
    init(existingPalette: CustomPaletteData? = nil) {
        self.existingPalette = existingPalette
        self.paletteName = existingPalette?.name ?? ""
        self.colors = existingPalette?.hexColors ?? []
    }
    
    var selectedColor: Color {
        if let hex = overrideHex {
            return Color(hex: hex)
        }
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    var selectedHex: String {
        if let hex = overrideHex {
            return hex
        }
        return selectedColor.toHex() ?? "#000000"
    }
    
    var isDuplicate: Bool {
        colors.contains(where: { $0.lowercased() == selectedHex.lowercased() })
    }
    
    var canSave: Bool {
        colors.count >= 2
    }
    
    func addCurrentColor() {
        let hex = selectedHex
        guard !colors.contains(where: { $0.lowercased() == hex.lowercased() }) else { return }
        colors.append(hex)
        withAnimation(.easeOut(duration: 0.2)) {
            addedFlash = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.addedFlash = false
        }
    }
    
    func removeColor(at index: Int) {
        guard index >= 0, index < colors.count else { return }
        colors.remove(at: index)
    }
    
    func applyHexInput() {
        let cleaned = hexInput.replacingOccurrences(of: "#", with: "")
        guard cleaned.count == 6 else { return }
        navigateToHex(cleaned)
        addCurrentColor()
        hexInput = ""
    }
    
    func navigateToHex(_ cleaned: String) {
        let hex = "#" + cleaned.uppercased()
        overrideHex = hex
        let color = Color(hex: hex)
        let uiColor = UIColor(color)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        hue = Double(h)
        saturation = Double(s)
        brightness = Double(b)
    }
    
    func navigateToColor(_ hex: String) {
        overrideHex = hex.uppercased().hasPrefix("#") ? hex.uppercased() : "#" + hex.uppercased()
        let uiColor = UIColor(Color(hex: hex))
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        hue = Double(h)
        saturation = Double(s)
        brightness = Double(b)
    }
    
    func savePalette() -> CustomPaletteData {
        let id = existingPalette?.id ?? UUID().uuidString
        let name = paletteName.isEmpty ? "Custom Palette" : paletteName
        let palette = CustomPaletteData(id: id, name: name, hexColors: colors)
        CustomPaletteService.shared.savePalette(palette)
        return palette
    }
}
