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
    @Published var drawingOpacity: Double = 1.0
    
    // Symmetry toggles — can be active alongside pencil/eraser/fill
    @Published var horizontalSymmetry: Bool = false
    @Published var verticalSymmetry: Bool = false
    
    // Brush size for pencil and eraser — independent per tool (1 = 1x1, ..., 5 = 5x5)
    @Published var pencilBrushSize: Int = 1
    @Published var eraserBrushSize: Int = 1
    
    // Fill mode: false = fill with color, true = fill erase (clear connected area)
    @Published var fillEraseMode: Bool = false
    
    // The brush size for the currently selected tool.
    var brushSize: Int {
        get {
            switch selectedTool {
            case .pencil: return pencilBrushSize
            case .eraser: return eraserBrushSize
            default: return 1
            }
        }
        set {
            switch selectedTool {
            case .pencil: pencilBrushSize = newValue
            case .eraser: eraserBrushSize = newValue
            default: break
            }
        }
    }
    
    // Brush size for a specific tool (used by badge display).
    func brushSize(for tool: ToolType) -> Int {
        switch tool {
        case .pencil: return pencilBrushSize
        case .eraser: return eraserBrushSize
        default: return 1
        }
    }
    
    private var palette: ColorPalettes
    private var embeddedPaletteColors: [String]?
    
    // Cached values to avoid recomputation on every pixel
    private var _cachedAvailableColors: [Color]?
    private var _cachedExtraColorsSnapshot: [String] = []
    
    // Cached effective drawing color hex — avoids repeated toHex() during drag drawing
    private var _cachedEffectiveHex: String?
    private var _cachedEffectiveColor: Color?
    private var _cachedEffectiveOpacity: Double = -1
    private var _cachedEffectiveBaseColor: Color?

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
        // Return cached if extraColors haven't changed
        if let cached = _cachedAvailableColors, _cachedExtraColorsSnapshot == extraColors {
            return cached
        }
        var colors = baseColors
        colors.append(contentsOf: extraColors.map { Color(hex: $0) })
        _cachedAvailableColors = colors
        _cachedExtraColorsSnapshot = extraColors
        return colors
    }
    
    // Number of colors in the base palette (before extras)
    var basePaletteCount: Int {
        baseColors.count
    }
    
    // The selected color with drawingOpacity applied, pre-composited onto white.
    // Cached so the UIColor blend is only computed once per color/opacity change.
    var effectiveDrawingColor: Color {
        if let cached = _cachedEffectiveColor,
           _cachedEffectiveOpacity == drawingOpacity,
           _cachedEffectiveBaseColor == selectedColor {
            return cached
        }
        let result: Color
        if drawingOpacity >= 1.0 {
            result = selectedColor
        } else {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            UIColor(selectedColor).getRed(&r, green: &g, blue: &b, alpha: &a)
            let alpha = CGFloat(drawingOpacity)
            let blendedR = r * alpha + 1.0 * (1.0 - alpha)
            let blendedG = g * alpha + 1.0 * (1.0 - alpha)
            let blendedB = b * alpha + 1.0 * (1.0 - alpha)
            result = Color(red: Double(blendedR), green: Double(blendedG), blue: Double(blendedB))
        }
        _cachedEffectiveColor = result
        _cachedEffectiveOpacity = drawingOpacity
        _cachedEffectiveBaseColor = selectedColor
        _cachedEffectiveHex = nil  // invalidate hex cache
        return result
    }
    
    // Cached hex of the effective drawing color — avoids repeated toHex() during drag strokes
    var effectiveDrawingHex: String {
        if let cached = _cachedEffectiveHex { return cached }
        let hex = effectiveDrawingColor.toHex() ?? "#000000"
        _cachedEffectiveHex = hex
        return hex
    }
    
    // Add a user-picked color to the extra colors list
    func addColor(_ hex: String) {
        let normalized = hex.uppercased()
        // Avoid duplicates across base + extras
        let allHexes = baseColors.map { $0.toHex()?.uppercased() ?? "" } + extraColors.map { $0.uppercased() }
        guard !allHexes.contains(normalized) else { return }
        extraColors.append(normalized)
        _cachedAvailableColors = nil  // invalidate cache
        canvasVM?.syncExtraColors(extraColors)
    }
    
    // Remove a user-added extra color by index (relative to extraColors array)
    func removeExtraColor(at index: Int) {
        guard index >= 0, index < extraColors.count else { return }
        extraColors.remove(at: index)
        _cachedAvailableColors = nil  // invalidate cache
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
            pixel = effectiveDrawingColor
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
