//
//  ToolsViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-06-04.
//

import SwiftUI

class ToolsViewModel: ObservableObject {
    
    enum ToolType: CaseIterable {
        
        case pencil, eraser, fill, eyedropper, line, rectangle, circle, gradient, dither, shift, flip, pan

        var iconName: String {
            switch self {
            case .pencil: return "pencil"
            case .eraser: return "eraser"
            case .fill: return "drop.halffull"
            case .eyedropper: return "eyedropper"
            case .line: return "line.diagonal"
            case .rectangle: return "rectangle"
            case .circle: return "circle"
            case .gradient: return "square.stack.3d.forward.dottedline"
            case .dither: return "checkerboard.rectangle"
            case .shift: return "arrow.up.and.down.and.arrow.left.and.right"
            case .flip: return "arrow.left.and.right.righttriangle.left.righttriangle.right"
            case .pan: return "hand.draw"
            }
        }
        
        // Whether this tool uses drag-to-define shape preview
        var isShapeTool: Bool {
            switch self {
            case .line, .rectangle, .circle, .gradient, .dither: return true
            default: return false
            }
        }
        
        var displayName: String {
            switch self {
            case .pencil: return "Pencil"
            case .eraser: return "Eraser"
            case .fill: return "Fill"
            case .eyedropper: return "Eyedropper"
            case .line: return "Line"
            case .rectangle: return "Rectangle"
            case .circle: return "Circle"
            case .gradient: return "Gradient"
            case .dither: return "Dither"
            case .shift: return "Shift"
            case .flip: return "Flip"
            case .pan: return "Pan"
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
    
    // Shape tool options
    @Published var rectangleFilled: Bool = false  // false = outline, true = filled
    @Published var circleFilled: Bool = false      // false = outline, true = filled
    
    // Stroke thickness for outline shapes (1–5 pixels). Only applies when not filled.
    @Published var lineThickness: Int = 1
    @Published var rectangleThickness: Int = 1
    @Published var circleThickness: Int = 1
    
    // Gradient tool options
    @Published var gradientColorA: Color = .black
    @Published var gradientColorB: Color = .white
    @Published var gradientSteps: Int = 4  // number of color bands (2 = just the two colors, up to 32)
    @Published var gradientThickness: Int = 0  // 0 = full canvas perpendicular, 1-16 = pixel thickness
    
    // Dither tool options
    enum DitherPattern: String, CaseIterable {
        case checkerboard = "Checkerboard"
        case bayer2x2 = "Bayer 2×2"
        case bayer4x4 = "Bayer 4×4"
        case horizontal = "Horizontal Lines"
        case vertical = "Vertical Lines"
        case diagonal = "Diagonal"
        case diagonalReversed = "Diagonal Reversed"
        case diamond = "Diamond"
        case zigzag = "Zigzag"
        case zigzagReversed = "Zigzag Reversed"
        case sparse = "Sparse"
    }
    @Published var ditherPattern: DitherPattern = .checkerboard
    @Published var ditherColorA: Color = .black
    @Published var ditherColorB: Color = .white
    
    // Apple Pencil detection — when true, only pencil can draw/erase/fill on canvas.
    // Finger touches are treated as pan. Resets automatically when no pencil touch
    // is detected for 10 seconds (i.e. pencil put back in holder).
    @Published var applePencilDetected: Bool = false
    private var pencilResetTimer: Timer?
    private static let pencilTimeout: TimeInterval = 10
    
    // Called when a pencil touch is detected. Sets the flag and starts/restarts the reset timer.
    func registerPencilTouch() {
        applePencilDetected = true
        pencilResetTimer?.invalidate()
        pencilResetTimer = Timer.scheduledTimer(withTimeInterval: Self.pencilTimeout, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.applePencilDetected = false
            }
        }
    }
    
    // Whether the given tool is a "drawing" tool that should be pencil-only when detected.
    static func isDrawingTool(_ tool: ToolType) -> Bool {
        switch tool {
        case .pencil, .eraser, .fill, .eyedropper, .line, .rectangle, .circle, .gradient, .dither: return true
        case .pan, .shift, .flip: return false
        }
    }
    
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
        let raw = hex.uppercased()
        let normalized = raw.hasPrefix("#") ? raw : "#\(raw)"
        // Avoid duplicates across base + extras
        let baseHexes = baseColors.map { $0.toHex()?.uppercased() ?? "" }
        let extraHexes = extraColors.map { h -> String in
            let u = h.uppercased()
            return u.hasPrefix("#") ? u : "#\(u)"
        }
        let allHexes = baseHexes + extraHexes
        guard !allHexes.contains(normalized) else { return }
        extraColors.append(normalized)
        _cachedAvailableColors = nil  // invalidate cache
        
        // Auto-select the newly added color so toolbar indicator reflects it
        let newIndex = basePaletteCount + extraColors.count - 1
        selectedColor = Color(hex: normalized)
        selectedColorIndex = newIndex
        
        canvasVM?.syncExtraColors(extraColors)
    }
    
    // Remove a user-added extra color by index (relative to extraColors array)
    func removeExtraColor(at index: Int) {
        guard index >= 0, index < extraColors.count else { return }
        let absoluteIndex = basePaletteCount + index
        extraColors.remove(at: index)
        _cachedAvailableColors = nil  // invalidate cache
        
        // Keep selectedColor as-is (last picked color stays), but fix the palette highlight
        if selectedColorIndex == absoluteIndex {
            // The selected color was deleted — remove highlight but keep the color
            selectedColorIndex = -1
        } else if selectedColorIndex > absoluteIndex {
            // A color before the selected one was removed — shift index
            selectedColorIndex -= 1
        }
        
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
        case .fill, .eyedropper, .shift, .flip, .pan,
             .line, .rectangle, .circle, .gradient, .dither:
            break
        }
    }

    func selectTool(_ tool: ToolType) {
        selectedTool = tool
    }

    func selectColor(_ color: Color, at index: Int = -1) {
        selectedColor = color
        selectedColorIndex = index
        if selectedTool != .fill && selectedTool != .pencil && !selectedTool.isShapeTool {
            selectedTool = .pencil
        }
    }
}
