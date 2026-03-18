//
//  ToolsViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-06-04.
//

import SwiftUI

class ToolsViewModel: ObservableObject {
    
    enum ToolType: CaseIterable {
        
        case pencil, eraser, fill, eyedropper, shift, flip, pan

        var iconName: String {
            switch self {
            case .pencil: return "pencil"
            case .eraser: return "eraser"
            case .fill: return "drop.halffull"
            case .eyedropper: return "eyedropper"
            case .shift: return "arrow.up.and.down.and.arrow.left.and.right"
            case .flip: return "arrow.left.and.right.righttriangle.left.righttriangle.right"
            case .pan: return "hand.draw"
            }
        }
    }

    weak var canvasVM: CanvasViewModel?
    @Published var selectedTool: ToolType = .pencil
    @Published var selectedColor: Color
    @Published var selectedColorIndex: Int = 0
    @Published var extraColors: [String] = []
    
    // Symmetry toggles — can be active alongside pencil/eraser/fill
    @Published var horizontalSymmetry: Bool = false
    @Published var verticalSymmetry: Bool = false
    
    private var palette: ColorPalettes
    private var embeddedPaletteColors: [String]?

    init(defaultColor: Color, palette: ColorPalettes, embeddedPaletteColors: [String]? = nil, extraColors: [String] = []) {
        self.selectedColor = defaultColor
        self.palette = palette
        self.embeddedPaletteColors = embeddedPaletteColors
        self.extraColors = extraColors
    }
    
    var baseColors: [Color] {
        palette.resolvedColors(embeddedColors: embeddedPaletteColors)
    }
    
    var availableColors: [Color] {
        var colors = baseColors
        colors.append(contentsOf: extraColors.map { Color(hex: $0) })
        return colors
    }
    
    // Number of colors in the base palette (before extras)
    var basePaletteCount: Int {
        baseColors.count
    }
    
    // Add a user-picked color to the extra colors list
    func addColor(_ hex: String) {
        let normalized = hex.uppercased()
        // Avoid duplicates across base + extras
        let allHexes = baseColors.map { $0.toHex()?.uppercased() ?? "" } + extraColors.map { $0.uppercased() }
        guard !allHexes.contains(normalized) else { return }
        extraColors.append(normalized)
        canvasVM?.syncExtraColors(extraColors)
    }
    
    // Remove a user-added extra color by index (relative to extraColors array)
    func removeExtraColor(at index: Int) {
        guard index >= 0, index < extraColors.count else { return }
        extraColors.remove(at: index)
        canvasVM?.syncExtraColors(extraColors)
    }
    
    var availableTools: [ToolType] {
        ToolType.allCases
    }
    
    func isSelected(tool: ToolType) -> Bool {
        return selectedTool == tool
    }
    
    func applyTool(to pixel: inout Color) {
        switch selectedTool {
        case .pencil:
            pixel = selectedColor
        case .eraser:
            pixel = .clear
        case .fill:
            break
        case .eyedropper:
            break
        case .shift:
            break
        case .flip:
            break
        case .pan:
            break
        }
    }

    func selectTool(_ tool: ToolType) {
        selectedTool = tool
    }

    func selectColor(_ color: Color, at index: Int = -1) {
        selectedColor = color
        selectedColorIndex = index
        if selectedTool != .fill && selectedTool != .pencil {
            selectedTool = .pencil
        }
    }
}
