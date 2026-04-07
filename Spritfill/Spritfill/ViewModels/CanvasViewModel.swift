//
//  CanvasViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

class CanvasViewModel: ObservableObject {
    
    // MARK: - Type Alias (for backward compatibility)
    
    typealias Layer = LayerManagerViewModel.Layer
    
    static let maxLayers = LayerManagerViewModel.maxLayers
    
    // MARK: - Properties
 
    @Published var projectSettings: ProjectSettings
    
    let projectID: UUID
    @Published var projectName: String
    
    @Published var layerManager: LayerManagerViewModel
    
    // Forwarding properties so existing code reads/writes layers transparently.
    var layers: [Layer] {
        get { layerManager.layers }
        set { layerManager.layers = newValue }
    }
    
    var activeLayerIndex: Int {
        get { layerManager.activeLayerIndex }
        set { layerManager.activeLayerIndex = newValue }
    }
    
    var activeLayer: Layer { layerManager.activeLayer }
    
    var pixels: [Color] {
        get { layerManager.pixels }
        set { layerManager.pixels = newValue }
    }
    
    var pixelHexes: [String] {
        get { layerManager.pixelHexes }
        set { layerManager.pixelHexes = newValue }
    }
    
    @Published var toolsVM: ToolsViewModel
    @Published var isFinished: Bool = false
    
    @Published var zoomScale: CGFloat = 1.0
    @Published var viewSize: CGSize = .zero
    
    // Monotonically increasing counter — bumped whenever the pixel array changes.
    // Used by PixelCanvasRenderer's Equatable check instead of comparing [Color].
    @Published private(set) var pixelGeneration: UInt = 0
    
    // MARK: - Undo / Redo (per-layer)
    
    @Published var canUndo: Bool = false
    @Published var canRedo: Bool = false
    private var memoryObserver: Any?
    
    private var maxUndoSteps: Int {
        let pixelCount = pixels.count
        let layerDivisor = max(1, layers.count)
        let base: Int
        if pixelCount > 16384 { base = 20 }       // 128x128 and above
        else if pixelCount > 4096 { base = 50 }    // 64x64 and above
        else if pixelCount > 1024 { base = 100 }   // 32x32 and above
        else { base = 150 }
        return max(5, base / layerDivisor)
    }
    
    private func setupMemoryWarning() {
        memoryObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            for layer in self.layers {
                layer.undoHistory.removeAll()
                layer.redoHistory.removeAll()
            }
            self.canUndo = false
            self.canRedo = false
        }
    }
    
    // MARK: - Auto-save
    
    private var autoSaveTimer: Timer?
    private let storage = LocalStorageService.shared
    private var strokesSinceSave: Int = 0
    
    // Debounced auto-save — respects the user's auto-save interval setting.
    private func debouncedAutoSave() {
        let interval = SettingsService.shared.autoSaveInterval
        switch interval {
        case .onExitOnly:
            // Don't auto-save at all — flushSave() handles it on dismiss
            return
        case .every5Strokes:
            strokesSinceSave += 1
            guard strokesSinceSave >= 5 else { return }
            strokesSinceSave = 0
        case .everyMove:
            break
        }
        autoSaveTimer?.invalidate()
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            self?.saveInBackground()
        }
    }
    
    // Performs the actual save on a background queue so the main thread stays responsive.
    private func saveInBackground() {
        let projectData = toProjectData()
        DispatchQueue.global(qos: .utility).async { [storage] in
            storage.saveProject(projectData)
        }
    }
    
    // Immediately flush any pending auto-save (e.g. on back / dismiss).
    func flushSave() {
        autoSaveTimer?.invalidate()
        autoSaveTimer = nil
        saveInBackground()
    }
    
    deinit {
        autoSaveTimer?.invalidate()
        if let observer = memoryObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // Restore active layer pixels from a hex string snapshot
    private func restorePixels(from hexes: [String]) {
        activeLayer.pixelHexes = hexes
        activeLayer.pixels = hexes.map { $0 == "clear" ? Color.clear : Color(hex: $0) }
        pixelGeneration &+= 1
    }
    
    // Save current pixel state before an action (per-layer, O(1) COW copy)
    private func saveSnapshot() {
        let layer = activeLayer
        layer.undoHistory.append(layer.pixelHexes)
        if layer.undoHistory.count > maxUndoSteps {
            layer.undoHistory.removeFirst()
        }
        layer.redoHistory.removeAll()
        canUndo = true
        canRedo = false
    }
    
    // Undo the last action on the active layer
    func undo() {
        let layer = activeLayer
        guard let previous = layer.undoHistory.popLast() else { return }
        layer.redoHistory.append(layer.pixelHexes)
        restorePixels(from: previous)
        canUndo = !layer.undoHistory.isEmpty
        canRedo = true
        debouncedAutoSave()
    }
    
    // Redo on the active layer
    func redo() {
        let layer = activeLayer
        guard let next = layer.redoHistory.popLast() else { return }
        layer.undoHistory.append(layer.pixelHexes)
        restorePixels(from: next)
        canUndo = true
        canRedo = !layer.redoHistory.isEmpty
        debouncedAutoSave()
    }
    
    // Sync canUndo / canRedo with the active layer's stacks (call on layer switch)
    private func syncUndoRedoState() {
        canUndo = !activeLayer.undoHistory.isEmpty
        canRedo = !activeLayer.redoHistory.isEmpty
    }
    
    // Call once at the start of a drawing gesture to capture the "before" state
    private var actionInProgress = false
    private var actionDidChange = false
    
    func beginAction() {
        if !actionInProgress {
            saveSnapshot()
            actionInProgress = true
            actionDidChange = false
        }
    }
    
    func endAction() {
        // If no pixels actually changed, discard the phantom snapshot
        if !actionDidChange {
            _ = activeLayer.undoHistory.popLast()
            canUndo = !activeLayer.undoHistory.isEmpty
        } else {
            debouncedAutoSave()
        }
        actionInProgress = false
        actionDidChange = false
    }
    
    // MARK: - Pixel mutation helpers
    
    // Set a single pixel to the current tool's effective color (pencil) or clear (eraser).
    // Keeps pixels and pixelHexes in sync.
    private func applyToolToPixel(at index: Int) {
        guard index >= 0, index < pixels.count else { return }
        let oldHex = pixelHexes[index]
        switch toolsVM.selectedTool {
        case .pencil:
            let newHex = toolsVM.effectiveDrawingHex
            guard oldHex != newHex else { return }
            pixels[index] = toolsVM.effectiveDrawingColor
            pixelHexes[index] = newHex
        case .eraser:
            guard oldHex != "clear" else { return }
            pixels[index] = .clear
            pixelHexes[index] = "clear"
        default:
            return
        }
        actionDidChange = true
    }
    
    // MARK: - Init: New Project
    
    init(projectName: String, selectedCanvasSize: CanvasSizes, selectedPalette: ColorPalettes, selectedTileSize: Int) {
        
        self.projectID = UUID()
        self.projectName = projectName
        self.projectSettings = ProjectSettings(
            selectedCanvasSize: selectedCanvasSize,
            selectedTileSize: selectedTileSize,
            selectedPalette: selectedPalette
        )
        
        let dimensions = selectedCanvasSize.dimensions
        let totalPixels = dimensions.width * dimensions.height
        let clearPixels = Array(repeating: Color.clear, count: totalPixels)
        let clearHexes = Array(repeating: "clear", count: totalPixels)
        
        self.layerManager = LayerManagerViewModel(
            layers: [Layer(name: "Background", pixels: clearPixels, pixelHexes: clearHexes)]
        )
        
        self.toolsVM = ToolsViewModel(defaultColor: selectedPalette.colors[0], palette: selectedPalette)
        self.toolsVM.canvasVM = self
        setupMemoryWarning()
    }
    
    // MARK: - Init: From Saved Project
    
    init(from data: ProjectData) {
        self.projectID = data.id
        self.projectName = data.name
        self.projectSettings = data.settings
        let resolvedColors = data.settings.selectedPalette.resolvedColors(embeddedColors: data.settings.customPaletteColors)
        self.toolsVM = ToolsViewModel(
            defaultColor: resolvedColors[0],
            palette: data.settings.selectedPalette,
            embeddedPaletteColors: data.settings.customPaletteColors,
            extraColors: data.settings.extraColors
        )
        
        // Load layers — backward compatible with single-layer projects
        if let savedLayers = data.layers, !savedLayers.isEmpty {
            let loadedLayers = savedLayers.map { Layer(from: $0) }
            self.layerManager = LayerManagerViewModel(layers: loadedLayers, activeLayerIndex: loadedLayers.count - 1)
        } else {
            // Legacy project — wrap pixelGrid into a single "Background" layer
            let colors = data.pixelGrid.map { hex in
                hex == "clear" ? Color.clear : Color(hex: hex)
            }
            self.layerManager = LayerManagerViewModel(
                layers: [Layer(name: "Background", pixels: colors, pixelHexes: data.pixelGrid)]
            )
        }
        
        self.isFinished = data.isFinished
        self.toolsVM.canvasVM = self
        setupMemoryWarning()
    }

    // MARK: - Zoom calculations
    
    // Base canvas size is 1pt per pixel — tile size is only used for export
    var baseCanvasSize: CGSize {
        let gridWidth = projectSettings.selectedCanvasSize.dimensions.width
        let gridHeight = projectSettings.selectedCanvasSize.dimensions.height
        return CGSize(width: CGFloat(gridWidth), height: CGFloat(gridHeight))
    }
    
    // Scale that fits the entire canvas in the view with ~90% padding
    var fitScale: CGFloat {
        guard viewSize != .zero else { return 1.0 }
        let canvas = baseCanvasSize
        let paddingFactor: CGFloat = 0.9
        let scaleW = (viewSize.width * paddingFactor) / canvas.width
        let scaleH = (viewSize.height * paddingFactor) / canvas.height
        return min(scaleW, scaleH)
    }
    
    var minimumZoomScale: CGFloat {
        return fitScale
    }
    
    var maximumZoomScale: CGFloat {
        // Target: each pixel should be ~35pt on screen at max zoom,
        // regardless of canvas size. This makes zoom depth consistent
        // across 16×16 and 128×128 canvases.
        let targetPixelSize: CGFloat = 35.0
        let result = targetPixelSize // since base canvas is 1pt per pixel, zoom = target pixel size
        // Safety: max must always exceed min
        return max(result, minimumZoomScale + 1.0)
    }
    
    func updateViewSize(_ size: CGSize) {
        let oldViewSize = viewSize
        viewSize = size
        
        let isFirstTime = oldViewSize == .zero
        let significantChange = abs(oldViewSize.width - size.width) > 20 ||
                               abs(oldViewSize.height - size.height) > 20
        
        guard isFirstTime || significantChange else { return }
        
        if isFirstTime {
            zoomScale = fitScale
        } else {
            zoomScale = zoomScale.clamped(to: minimumZoomScale...maximumZoomScale)
        }
    }

    // MARK: - Convert to ProjectData
    
    func compositePixelHexes() -> [String] {
        layerManager.compositePixelHexes(generation: pixelGeneration)
    }
    
    func toProjectData() -> ProjectData {
        return ProjectData(
            id: projectID,
            name: projectName,
            settings: projectSettings,
            pixelGrid: compositePixelHexes(),
            layers: layers.map { $0.toLayerData() },
            lastEdited: Date(),
            isFinished: isFinished
        )
    }
    
    // Sync extra colors from ToolsViewModel back to project settings for persistence
    func syncExtraColors(_ colors: [String]) {
        projectSettings.extraColors = colors
    }
    
    // MARK: - Layer Management (delegates to LayerManagerViewModel)
    
    func switchToLayer(at index: Int) {
        layerManager.switchToLayer(at: index)
        syncUndoRedoState()
        pixelGeneration &+= 1
    }
    
    func addLayer() {
        let totalPixels = projectSettings.selectedCanvasSize.dimensions.width *
                          projectSettings.selectedCanvasSize.dimensions.height
        if layerManager.addLayer(totalPixels: totalPixels) {
            syncUndoRedoState()
            pixelGeneration &+= 1
            debouncedAutoSave()
        }
    }
    
    func deleteLayer(at index: Int) {
        if layerManager.deleteLayer(at: index) {
            syncUndoRedoState()
            pixelGeneration &+= 1
            debouncedAutoSave()
        }
    }
    
    func duplicateLayer(at index: Int) {
        if layerManager.duplicateLayer(at: index) {
            syncUndoRedoState()
            pixelGeneration &+= 1
            debouncedAutoSave()
        }
    }
    
    func moveLayer(from source: Int, to destination: Int) {
        layerManager.moveLayer(from: source, to: destination)
        pixelGeneration &+= 1
        debouncedAutoSave()
    }
    
    func toggleLayerVisibility(at index: Int) {
        layerManager.toggleLayerVisibility(at: index)
        
        // If we just hid the active layer, switch to the nearest visible one
        if !layers[activeLayerIndex].isVisible {
            if let nearest = nearestVisibleLayerIndex() {
                layerManager.switchToLayer(at: nearest)
                syncUndoRedoState()
            }
        }
        
        // If we just made a layer visible and the current active layer is hidden,
        // switch to the newly-visible layer
        if layers[index].isVisible && !layers[activeLayerIndex].isVisible {
            layerManager.switchToLayer(at: index)
            syncUndoRedoState()
        }
        
        pixelGeneration &+= 1
        debouncedAutoSave()
    }
    
    // Returns the index of the nearest visible layer to the current active layer, or nil if all hidden.
    private func nearestVisibleLayerIndex() -> Int? {
        let current = activeLayerIndex
        let count = layers.count
        // Search outward from the current index
        for offset in 1..<count {
            let above = current + offset
            let below = current - offset
            if above < count && layers[above].isVisible { return above }
            if below >= 0 && layers[below].isVisible { return below }
        }
        return nil
    }
    
    func setLayerOpacity(at index: Int, _ opacity: Double) {
        layerManager.setLayerOpacity(at: index, opacity)
        pixelGeneration &+= 1
        debouncedAutoSave()
    }
    
    func renameLayer(at index: Int, to name: String) {
        layerManager.renameLayer(at: index, to: name)
        debouncedAutoSave()
    }
    
    func mergeDown(at index: Int) {
        if layerManager.mergeDown(at: index) {
            syncUndoRedoState()
            pixelGeneration &+= 1
            debouncedAutoSave()
        }
    }
    
    func clearCurrentLayer() {
        saveSnapshot()
        layerManager.clearLayer(at: activeLayerIndex)
        actionDidChange = true
        pixelGeneration &+= 1
        debouncedAutoSave()
    }
    
    // MARK: - Import Project as Layer
    
    // Imports another project's composite artwork as a new layer, centered on this canvas.
    // Returns nil on success, or an error message string on failure.
    func importProject(_ data: ProjectData) -> String? {
        // Check layer limit
        guard layers.count < LayerManagerViewModel.maxLayers else {
            return "You already have \(LayerManagerViewModel.maxLayers) layers. Delete or merge a layer first."
        }
        
        let currentW = projectSettings.selectedCanvasSize.dimensions.width
        let currentH = projectSettings.selectedCanvasSize.dimensions.height
        let importW = data.settings.selectedCanvasSize.dimensions.width
        let importH = data.settings.selectedCanvasSize.dimensions.height
        
        // The imported canvas must fit within the current canvas
        guard importW <= currentW && importH <= currentH else {
            return "The imported project (\(importW)×\(importH)) is larger than this canvas (\(currentW)×\(currentH))."
        }
        
        // Get the imported project's composite pixel grid
        let importedHexes = data.pixelGrid
        guard importedHexes.count == importW * importH else {
            return "The imported project's pixel data is corrupted."
        }
        
        // Build the new layer: center the imported art onto this canvas
        let totalPixels = currentW * currentH
        var newHexes = Array(repeating: "clear", count: totalPixels)
        
        let offsetX = (currentW - importW) / 2
        let offsetY = (currentH - importH) / 2
        
        for row in 0..<importH {
            for col in 0..<importW {
                let srcIndex = row * importW + col
                let hex = importedHexes[srcIndex]
                guard hex != "clear" else { continue }
                
                let dstRow = row + offsetY
                let dstCol = col + offsetX
                let dstIndex = dstRow * currentW + dstCol
                newHexes[dstIndex] = hex
            }
        }
        
        let newColors = newHexes.map { $0 == "clear" ? Color.clear : Color(hex: $0) }
        let importedLayer = Layer(
            name: "Import: \(data.name)",
            pixels: newColors,
            pixelHexes: newHexes
        )
        
        // Insert above the current active layer
        let insertIndex = activeLayerIndex + 1
        layers.insert(importedLayer, at: insertIndex)
        layerManager.activeLayerIndex = insertIndex
        syncUndoRedoState()
        pixelGeneration &+= 1
        debouncedAutoSave()
        
        return nil  // success
    }
    
    func updatePixel(row: Int, col: Int) {
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let index = row * width + col

        guard index >= 0, index < pixels.count else { return }

        let color = toolsVM.selectedColor
        pixels[index] = color
        pixelHexes[index] = color.isClear ? "clear" : (color.toHex() ?? "#000000")
        pixelGeneration &+= 1
    }
    
    // Clamp to screen bounds — with extra padding when zoomed in so
    // edge pixels aren't stuck at the device edge.
    func clampedOffset(for offset: CGSize, geoSize: CGSize, canvasSize: CGSize) -> CGSize {
        
        // Extra padding ramps up smoothly based on how far the canvas
        // exceeds the view. This avoids a sudden snap when zooming out
        // crosses the canvas == view threshold.
        let overflowX = max(0, canvasSize.width - geoSize.width)
        let overflowY = max(0, canvasSize.height - geoSize.height)
        let extraPaddingX = min(overflowX * 0.5, geoSize.width * 0.4)
        let extraPaddingY = min(overflowY * 0.5, geoSize.height * 0.4)
        
        let maxX = max(0, (canvasSize.width - geoSize.width) / 2 + extraPaddingX)
        let maxY = max(0, (canvasSize.height - geoSize.height) / 2 + extraPaddingY)

        return CGSize(
            width: offset.width.clamped(to: -maxX...maxX),
            height: offset.height.clamped(to: -maxY...maxY)
        )
    }
    
    func applyTool(at point: CGPoint) {
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height

        let col = Int(point.x)
        let row = Int(point.y)
        let index = row * width + col

        guard row >= 0, row < height, col >= 0, col < width, index < pixels.count else { return }

        if toolsVM.selectedTool == .fill {
            floodFill(at: index, with: toolsVM.effectiveDrawingColor)
        } else {
            applyToolToPixel(at: index)
        }
        pixelGeneration &+= 1
    }
    
    // Apply tool at a grid index (used for drag drawing to avoid duplicate coordinate math)
    func applyToolAtIndex(_ index: Int) {
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height
        guard index >= 0, index < pixels.count else { return }
        
        let row = index / width
        let col = index % width
        guard row >= 0, row < height, col >= 0, col < width else { return }
        
        // Eyedropper is handled separately via eyedropperPickColor
        if toolsVM.selectedTool == .eyedropper { return }
        
        let tool = toolsVM.selectedTool
        let isBrushTool = (tool == .pencil || tool == .eraser)
        let brushSize = isBrushTool ? toolsVM.brushSize : 1
        
        // Compute the set of pixel indices for this brush stroke (NxN centered)
        let indices = brushIndices(centerRow: row, centerCol: col, brushSize: brushSize, width: width, height: height)
        
        for idx in indices {
            if tool == .fill {
                let fillColor = toolsVM.fillEraseMode ? Color.clear : toolsVM.effectiveDrawingColor
                floodFill(at: idx, with: fillColor)
            } else {
                applyToolToPixel(at: idx)
            }
        }
        
        // Apply symmetry mirrors EXCEPT for fill tool (doesn't make semantic sense)
        let shouldApplySymmetry = (tool != .fill)
        
        if shouldApplySymmetry {
            let hSym = toolsVM.horizontalSymmetry
            let vSym = toolsVM.verticalSymmetry
            
            if hSym {
                let mirrorCol = width - 1 - col
                let mirrorIndices = brushIndices(centerRow: row, centerCol: mirrorCol, brushSize: brushSize, width: width, height: height)
                for idx in mirrorIndices where idx != index {
                    applyToolToPixel(at: idx)
                }
            }
            
            if vSym {
                let mirrorRow = height - 1 - row
                let mirrorIndices = brushIndices(centerRow: mirrorRow, centerCol: col, brushSize: brushSize, width: width, height: height)
                for idx in mirrorIndices where idx != index {
                    applyToolToPixel(at: idx)
                }
            }
            
            // Diagonal mirror when both symmetries are active
            if hSym && vSym {
                let mirrorRow = height - 1 - row
                let mirrorCol = width - 1 - col
                let mirrorIndices = brushIndices(centerRow: mirrorRow, centerCol: mirrorCol, brushSize: brushSize, width: width, height: height)
                for idx in mirrorIndices where idx != index {
                    applyToolToPixel(at: idx)
                }
            }
        }
        
        pixelGeneration &+= 1
    }
    
    // Returns all grid indices for an NxN brush centered on (centerRow, centerCol).
    // Clamps to grid boundaries.
    private func brushIndices(centerRow: Int, centerCol: Int, brushSize: Int, width: Int, height: Int) -> [Int] {
        if brushSize <= 1 {
            return [centerRow * width + centerCol]
        }
        let half = brushSize / 2
        var result: [Int] = []
        result.reserveCapacity(brushSize * brushSize)
        for dr in -half...(brushSize - 1 - half) {
            for dc in -half...(brushSize - 1 - half) {
                let r = centerRow + dr
                let c = centerCol + dc
                guard r >= 0, r < height, c >= 0, c < width else { continue }
                result.append(r * width + c)
            }
        }
        return result
    }
    
    // Eyedropper: pick the color at a grid index from the composite (visible) result
    func eyedropperPickColor(at index: Int) {
        guard index >= 0, index < activeLayer.pixels.count else { return }
        
        // Sample composite so the eyedropper picks what the user actually sees
        let compositeHex = compositePixelHexes()
        guard index < compositeHex.count else { return }
        let hex = compositeHex[index]
        guard hex != "clear" else { return }
        let color = Color(hex: hex)
        
        // Convert picked pixel to RGBA for comparison
        var pr: CGFloat = 0, pg: CGFloat = 0, pb: CGFloat = 0, pa: CGFloat = 0
        UIColor(color).getRed(&pr, green: &pg, blue: &pb, alpha: &pa)
        
        // Find matching palette color using a wider tolerance (3/255)
        // to handle color space rounding from hex → Color → UIColor roundtrips
        let colors = toolsVM.availableColors
        var matchIndex = -1
        let tolerance: CGFloat = 3.0 / 255.0
        
        for i in 0..<colors.count {
            var cr: CGFloat = 0, cg: CGFloat = 0, cb: CGFloat = 0, ca: CGFloat = 0
            UIColor(colors[i]).getRed(&cr, green: &cg, blue: &cb, alpha: &ca)
            if abs(pr - cr) < tolerance && abs(pg - cg) < tolerance && abs(pb - cb) < tolerance {
                matchIndex = i
                break
            }
        }
        
        // If matched, use the palette color directly so the swatch highlights
        if matchIndex >= 0 {
            toolsVM.selectColor(colors[matchIndex], at: matchIndex)
        } else {
            toolsVM.selectedColor = color
            toolsVM.selectedColorIndex = -1
        }
        toolsVM.selectedTool = .pencil
    }
    
    // Returns the composite color at a grid index (for eyedropper preview)
    func colorAtIndex(_ index: Int) -> Color? {
        guard index >= 0, index < activeLayer.pixels.count else { return nil }
        let compositeHex = compositePixelHexes()
        guard index < compositeHex.count else { return nil }
        let hex = compositeHex[index]
        return hex == "clear" ? nil : Color(hex: hex)
    }
    
    // Convert a screen-space point to a grid index, given the geo size, canvas offset, and zoom scale
    func gridIndex(from screenPoint: CGPoint, geoSize: CGSize, canvasOffset: CGSize, zoomScale: CGFloat) -> Int? {
        let gridWidth = projectSettings.selectedCanvasSize.dimensions.width
        let gridHeight = projectSettings.selectedCanvasSize.dimensions.height
        
        let scaledCanvasSize = CGSize(width: CGFloat(gridWidth) * zoomScale,
                                       height: CGFloat(gridHeight) * zoomScale)
        
        let canvasCenter = CGPoint(
            x: geoSize.width / 2 + canvasOffset.width,
            y: geoSize.height / 2 + canvasOffset.height
        )
        let canvasOrigin = CGPoint(
            x: canvasCenter.x - scaledCanvasSize.width / 2,
            y: canvasCenter.y - scaledCanvasSize.height / 2
        )
        
        let col = Int((screenPoint.x - canvasOrigin.x) / zoomScale)
        let row = Int((screenPoint.y - canvasOrigin.y) / zoomScale)
        
        guard row >= 0, row < gridHeight, col >= 0, col < gridWidth else { return nil }
        return row * gridWidth + col
    }
    
    // Convert a screen-space point to grid (row, col) — used by shape tools
    func gridRowCol(from screenPoint: CGPoint, geoSize: CGSize, canvasOffset: CGSize, zoomScale: CGFloat) -> (row: Int, col: Int)? {
        let gridWidth = projectSettings.selectedCanvasSize.dimensions.width
        let gridHeight = projectSettings.selectedCanvasSize.dimensions.height
        
        let scaledCanvasSize = CGSize(width: CGFloat(gridWidth) * zoomScale,
                                       height: CGFloat(gridHeight) * zoomScale)
        
        let canvasCenter = CGPoint(
            x: geoSize.width / 2 + canvasOffset.width,
            y: geoSize.height / 2 + canvasOffset.height
        )
        let canvasOrigin = CGPoint(
            x: canvasCenter.x - scaledCanvasSize.width / 2,
            y: canvasCenter.y - scaledCanvasSize.height / 2
        )
        
        let col = Int((screenPoint.x - canvasOrigin.x) / zoomScale)
        let row = Int((screenPoint.y - canvasOrigin.y) / zoomScale)
        
        guard row >= 0, row < gridHeight, col >= 0, col < gridWidth else { return nil }
        return (row, col)
    }
    
    // MARK: - Selection (Select tool)
    
    // Current pixel coordinate being touched (for coordinate overlay)
    @Published var currentPixelCoordinate: (col: Int, row: Int)? = nil
    
    // Current grid index being touched (for pencil highlight overlay)
    @Published var currentDrawingIndex: Int? = nil
    
    // Indices of pixels currently selected by the Select tool.
    @Published var selectedIndices: Set<Int> = []
    
    // How far the selected pixels have been shifted (preview, not yet committed).
    @Published var selectionOffset: (dRow: Int, dCol: Int) = (0, 0)
    
    // Whether a selection is active and has pixels.
    var hasSelection: Bool { !selectedIndices.isEmpty }
    
    // Toggle a pixel into/out of the selection (used during drag-to-select).
    func addToSelection(_ index: Int) {
        guard index >= 0, index < pixels.count else { return }
        selectedIndices.insert(index)
    }
    
    // Add pixels using the current select brush size (NxN centered on the touched pixel).
    func addToSelectionWithBrush(_ index: Int) {
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height
        guard index >= 0, index < pixels.count else { return }
        let row = index / width
        let col = index % width
        let size = toolsVM.selectBrushSize
        let indices = brushIndices(centerRow: row, centerCol: col, brushSize: size, width: width, height: height)
        for idx in indices {
            selectedIndices.insert(idx)
        }
    }
    
    // Fill-select: given the current selectedIndices as a drawn boundary,
    // flood-fill the interior so all enclosed pixels become selected.
    // Uses an "inverse flood fill from edges" approach: any pixel NOT reachable
    // from the canvas border without crossing the boundary is interior.
    // If the boundary doesn't enclose anything, the selection is cleared.
    func fillEnclosedSelection() {
        guard !selectedIndices.isEmpty else { return }
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height
        let total = width * height
        
        let boundaryPixels = selectedIndices   // remember original boundary
        
        // BFS from every edge pixel that is NOT part of the boundary.
        // Everything reached is "outside". Everything not reached is "inside".
        var outside = Set<Int>()
        outside.reserveCapacity(total)
        var queue: [Int] = []
        queue.reserveCapacity(total)
        
        // Seed with all canvas-border pixels that aren't in the selection boundary
        for col in 0..<width {
            let top = col
            let bot = (height - 1) * width + col
            if !boundaryPixels.contains(top)  && outside.insert(top).inserted  { queue.append(top) }
            if !boundaryPixels.contains(bot)  && outside.insert(bot).inserted  { queue.append(bot) }
        }
        for row in 0..<height {
            let left  = row * width
            let right = row * width + (width - 1)
            if !boundaryPixels.contains(left)  && outside.insert(left).inserted  { queue.append(left) }
            if !boundaryPixels.contains(right) && outside.insert(right).inserted { queue.append(right) }
        }
        
        // BFS — spread to all reachable non-boundary pixels
        var head = 0
        while head < queue.count {
            let current = queue[head]
            head += 1
            let r = current / width
            let c = current % width
            
            let neighbors = [
                r > 0         ? (r - 1) * width + c       : -1,
                r < height-1  ? (r + 1) * width + c       : -1,
                c > 0         ? r * width + (c - 1)       : -1,
                c < width-1   ? r * width + (c + 1)       : -1
            ]
            
            for n in neighbors {
                guard n >= 0, n < total else { continue }
                guard !outside.contains(n), !boundaryPixels.contains(n) else { continue }
                outside.insert(n)
                queue.append(n)
            }
        }
        
        // Collect interior pixels (not outside, not boundary)
        var interiorCount = 0
        for idx in 0..<total {
            if !outside.contains(idx) && !boundaryPixels.contains(idx) {
                interiorCount += 1
            }
        }
        
        // If nothing is enclosed, do nothing — preserve existing selection
        if interiorCount == 0 {
            return
        }
        
        // Add all interior pixels to the selection (boundary stays selected too)
        for idx in 0..<total {
            if !outside.contains(idx) {
                selectedIndices.insert(idx)
            }
        }
    }
    
    // Clear the selection entirely (no undo snapshot).
    func clearSelection() {
        selectedIndices.removeAll()
        selectionOffset = (0, 0)
    }
    
    // Preview-shift the selection by 1 pixel in the given direction.
    func shiftSelection(_ direction: ShiftDirection) {
        switch direction {
        case .up:    selectionOffset.dRow -= 1
        case .down:  selectionOffset.dRow += 1
        case .left:  selectionOffset.dCol -= 1
        case .right: selectionOffset.dCol += 1
        }
    }
    
    // Commit the shifted selection to the canvas: lift selected pixels from their
    // original positions, place them at the offset positions, clear originals.
    func confirmSelection() {
        guard hasSelection, (selectionOffset.dRow != 0 || selectionOffset.dCol != 0) else {
            clearSelection()
            return
        }
        
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height
        
        saveSnapshot()
        
        // 1. Collect selected pixels and their hex values
        var selected: [(origIndex: Int, hex: String, color: Color)] = []
        for idx in selectedIndices {
            selected.append((origIndex: idx, hex: pixelHexes[idx], color: pixels[idx]))
        }
        
        // 2. Clear original positions
        for idx in selectedIndices {
            pixels[idx] = .clear
            pixelHexes[idx] = "clear"
        }
        
        // 3. Place at new positions
        for item in selected {
            let origRow = item.origIndex / width
            let origCol = item.origIndex % width
            let newRow = origRow + selectionOffset.dRow
            let newCol = origCol + selectionOffset.dCol
            
            guard newRow >= 0, newRow < height, newCol >= 0, newCol < width else { continue }
            let newIdx = newRow * width + newCol
            pixels[newIdx] = item.color
            pixelHexes[newIdx] = item.hex
        }
        
        actionDidChange = true
        pixelGeneration &+= 1
        debouncedAutoSave()
        clearSelection()
    }
    
    // Cancel the selection without applying any shift.
    func cancelSelection() {
        clearSelection()
    }
    
    // Move selected pixels to a new layer (if room). Returns nil on success, error string on failure.
    func moveSelectionToNewLayer() -> String? {
        guard hasSelection else { return "No pixels selected." }
        guard layers.count < LayerManagerViewModel.maxLayers else {
            return "Layer limit reached (\(LayerManagerViewModel.maxLayers)). Delete or merge a layer first."
        }
        
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height
        let totalPixels = width * height
        
        saveSnapshot()
        
        // Build new layer pixels from selection
        var newHexes = Array(repeating: "clear", count: totalPixels)
        for idx in selectedIndices {
            newHexes[idx] = pixelHexes[idx]
            // Clear from current layer
            pixels[idx] = .clear
            pixelHexes[idx] = "clear"
        }
        
        let newColors = newHexes.map { $0 == "clear" ? Color.clear : Color(hex: $0) }
        let newLayer = Layer(
            name: "Selection",
            pixels: newColors,
            pixelHexes: newHexes
        )
        
        let insertIndex = activeLayerIndex + 1
        layers.insert(newLayer, at: insertIndex)
        layerManager.activeLayerIndex = insertIndex
        
        actionDidChange = true
        pixelGeneration &+= 1
        syncUndoRedoState()
        debouncedAutoSave()
        clearSelection()
        return nil
    }
    
    // MARK: - Shift
    
    enum ShiftDirection {
        case up, down, left, right
    }
    
    func shiftPixels(_ direction: ShiftDirection) {
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height
        
        saveSnapshot()
        
        var newPixels = Array(repeating: Color.clear, count: width * height)
        var newHexes = Array(repeating: "clear", count: width * height)
        
        for row in 0..<height {
            for col in 0..<width {
                let sourceRow: Int
                let sourceCol: Int
                
                switch direction {
                case .up:
                    sourceRow = (row + 1) % height
                    sourceCol = col
                case .down:
                    sourceRow = (row - 1 + height) % height
                    sourceCol = col
                case .left:
                    sourceRow = row
                    sourceCol = (col + 1) % width
                case .right:
                    sourceRow = row
                    sourceCol = (col - 1 + width) % width
                }
                
                let destIdx = row * width + col
                let srcIdx = sourceRow * width + sourceCol
                newPixels[destIdx] = pixels[srcIdx]
                newHexes[destIdx] = pixelHexes[srcIdx]
            }
        }
        
        pixels = newPixels
        pixelHexes = newHexes
        pixelGeneration &+= 1
    }
    
    // MARK: - Flip
    
    enum FlipDirection {
        case horizontal, vertical
    }
    
    func flipPixels(_ direction: FlipDirection) {
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height
        
        saveSnapshot()
        
        var newPixels = Array(repeating: Color.clear, count: width * height)
        var newHexes = Array(repeating: "clear", count: width * height)
        
        for row in 0..<height {
            for col in 0..<width {
                let sourceRow: Int
                let sourceCol: Int
                
                switch direction {
                case .horizontal:
                    sourceRow = row
                    sourceCol = width - 1 - col
                case .vertical:
                    sourceRow = height - 1 - row
                    sourceCol = col
                }
                
                let destIdx = row * width + col
                let srcIdx = sourceRow * width + sourceCol
                newPixels[destIdx] = pixels[srcIdx]
                newHexes[destIdx] = pixelHexes[srcIdx]
            }
        }
        
        pixels = newPixels
        pixelHexes = newHexes
        pixelGeneration &+= 1
    }
    
    // MARK: - Flood Fill (BFS)
    
    private func floodFill(at startIndex: Int, with newColor: Color) {
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height
        let totalPixels = width * height
        
        guard startIndex >= 0, startIndex < totalPixels else { return }
        
        let targetHex = pixelHexes[startIndex]
        let newHex = newColor.isClear ? "clear" : (newColor.toHex() ?? "#000000")
        
        // Don't fill if the color is the same
        guard targetHex != newHex else { return }
        actionDidChange = true
        
        // Fast path: if every pixel matches the target, fill the entire canvas at once
        // This turns a 65K-iteration BFS into two Array(repeating:), so basically instant
        let allMatch = pixelHexes.allSatisfy { $0 == targetHex }
        if allMatch {
            pixels = Array(repeating: newColor, count: totalPixels)
            pixelHexes = Array(repeating: newHex, count: totalPixels)
            return
        }
        
        // Phase 1: BFS to collect all matching indices (no pixel mutation yet)
        var visited = [Bool](repeating: false, count: totalPixels)
        var fillIndices = [Int]()
        fillIndices.reserveCapacity(min(totalPixels, 4096))
        
        visited[startIndex] = true
        fillIndices.append(startIndex)
        var head = 0
        
        while head < fillIndices.count {
            let current = fillIndices[head]
            head += 1
            
            let row = current / width
            let col = current % width
            
            // check if out of bounds, if same color, or if visited. if not out of bounds,
            // is same color, and is not visited, mark visited and add to fillIndices for next iteration
            if row > 0 {
                let n = current - width
                if !visited[n] && pixelHexes[n] == targetHex { visited[n] = true; fillIndices.append(n) }
            }
            if row < height - 1 {
                let n = current + width
                if !visited[n] && pixelHexes[n] == targetHex { visited[n] = true; fillIndices.append(n) }
            }
            if col > 0 {
                let n = current - 1
                if !visited[n] && pixelHexes[n] == targetHex { visited[n] = true; fillIndices.append(n) }
            }
            if col < width - 1 {
                let n = current + 1
                if !visited[n] && pixelHexes[n] == targetHex { visited[n] = true; fillIndices.append(n) }
            }
        }
        
        // Phase 2: Batch-apply all changes at once.
        // Copy arrays out, mutate locally, write back once — avoids per-pixel
        // published-array copy-on-write overhead.
        var localPixels = pixels
        var localHexes = pixelHexes
        for idx in fillIndices {
            localPixels[idx] = newColor
            localHexes[idx] = newHex
        }
        pixels = localPixels
        pixelHexes = localHexes
    }
    
    // colorsMatch kept for any remaining callers but now uses hex comparison
    private func colorsMatch(_ a: Color, _ b: Color) -> Bool {
        if a.isClear && b.isClear { return true }
        if a.isClear || b.isClear { return false }
        return a.toHex() == b.toHex()
    }
    
    func getGridCoordinates(from location: CGPoint) -> (row: Int, col: Int)? {
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height

        let col = Int(location.x)
        let row = Int(location.y)

        if row >= 0, row < height, col >= 0, col < width {
            return (row, col)
        } else {
            return nil
        }
    }

    // MARK: - Export
    
    @Published var isExporting: Bool = false
    
    // Whether the current export resolution is below 512px (blurry on iOS Photos).
    var exportNeedsUpscale: Bool {
        let dims = projectSettings.selectedCanvasSize.dimensions
        return BitmapExporter.needsUpscaleForPhotos(gridWidth: dims.width,
                                                    gridHeight: dims.height,
                                                    tileSize: projectSettings.selectedTileSize)
    }
    
    // Human-readable export resolution label, e.g. "128×128".
    var exportResolutionLabel: String {
        let dims = projectSettings.selectedCanvasSize.dimensions
        return BitmapExporter.exportResolutionLabel(gridWidth: dims.width,
                                                    gridHeight: dims.height,
                                                    tileSize: projectSettings.selectedTileSize)
    }
    
    @MainActor
    func exportImage() -> UIImage? {
        let dims = projectSettings.selectedCanvasSize.dimensions
        let tileSize = projectSettings.selectedTileSize
        let hexes = compositePixelHexes()
        return BitmapExporter.renderImage(hexes: hexes,
                                          gridWidth: dims.width,
                                          gridHeight: dims.height,
                                          tileSize: tileSize)
    }
    
    // Save to Photos with optional upscale for small exports.
    func saveToPhotos(upscale: Bool, completion: (() -> Void)? = nil) {
        isExporting = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 50_000_000)
            var image = self.exportImage()
            if upscale, let img = image {
                image = BitmapExporter.upscaleForPhotos(img)
            }
            self.isExporting = false
            guard let image else {
                completion?()
                return
            }
            PhotoSaver.saveAsPNG(image) {
                completion?()
            }
        }
    }
    
    func exportAndSaveToPhotos(completion: (() -> Void)? = nil) {
        saveToPhotos(upscale: false, completion: completion)
    }
    
    func exportAndGetShareImage(upscale: Bool = false, completion: @escaping (IdentifiableImage) -> Void) {
        isExporting = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
            var image = self.exportImage()
            if upscale, let img = image {
                image = BitmapExporter.upscaleForPhotos(img)
            }
            self.isExporting = false
            guard let image else { return }
            completion(IdentifiableImage(image: image))
        }
    }
    
    // MARK: - Submit Artwork
    
    // MARK: - Export Project JSON
    
    func exportProjectJSON() -> URL? {
        // Export uses composite-only (no layer data) — keeps exports lightweight and legacy-compatible
        var exportData = toProjectData()
        exportData.layers = nil
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        guard let data = try? encoder.encode(exportData) else { return nil }
        
        let fileName = "\(projectName.replacingOccurrences(of: " ", with: "_")).json"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        try? data.write(to: tempURL)
        return tempURL
    }
    
    @Published var isSubmitting: Bool = false
    @Published var submissionError: String? = nil
    
    @MainActor
    func submitArtwork(artistName: String, personalLink: String? = nil, completion: @escaping (Bool) -> Void) {
        isSubmitting = true
        submissionError = nil
        
        let dims = projectSettings.selectedCanvasSize.dimensions
        
        let submission = ArtSubmission(
            artistName: artistName.trimmingCharacters(in: .whitespaces),
            projectName: projectName,
            canvasWidth: dims.width,
            canvasHeight: dims.height,
            pixelGrid: compositePixelHexes(),
            personalLink: personalLink
        )
        
        guard let image = exportImage() else {
            isSubmitting = false
            submissionError = "Failed to render export image"
            completion(false)
            return
        }
        
        FirebaseSubmissionService.shared.submitArtwork(submission: submission, image: image) { [weak self] result in
            DispatchQueue.main.async {
                self?.isSubmitting = false
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    self?.submissionError = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Shape Tool Preview System
    
    // Stores (index, hexColor) pairs for the live preview overlay while dragging
    @Published var shapePreviewPixels: [(index: Int, hex: String)] = []
    
    // Grid coordinate of the shape start point (touch began)
    var shapeStartRow: Int = 0
    var shapeStartCol: Int = 0
    
    // Called on touch began for shape tools — records the anchor point
    func beginShapeDrag(row: Int, col: Int) {
        shapeStartRow = row
        shapeStartCol = col
        shapePreviewPixels = []
    }
    
    // Called on touch moved for shape tools — recomputes the preview
    func updateShapePreview(row: Int, col: Int) {
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height
        let tool = toolsVM.selectedTool
        
        switch tool {
        case .line:
            shapePreviewPixels = linePixels(
                r0: shapeStartRow, c0: shapeStartCol,
                r1: row, c1: col,
                width: width, height: height,
                hex: toolsVM.effectiveDrawingHex
            )
        case .rectangle:
            shapePreviewPixels = rectanglePixels(
                r0: shapeStartRow, c0: shapeStartCol,
                r1: row, c1: col,
                width: width, height: height,
                hex: toolsVM.effectiveDrawingHex,
                filled: toolsVM.rectangleFilled
            )
        case .circle:
            shapePreviewPixels = circlePixels(
                r0: shapeStartRow, c0: shapeStartCol,
                r1: row, c1: col,
                width: width, height: height,
                hex: toolsVM.effectiveDrawingHex,
                filled: toolsVM.circleFilled
            )
        case .gradient:
            shapePreviewPixels = gradientPixels(
                r0: shapeStartRow, c0: shapeStartCol,
                r1: row, c1: col,
                width: width, height: height,
                colorA: toolsVM.gradientColorA,
                colorB: toolsVM.gradientColorB,
                steps: toolsVM.gradientSteps,
                thickness: toolsVM.gradientThickness
            )
        case .dither:
            shapePreviewPixels = ditherPixels(
                r0: shapeStartRow, c0: shapeStartCol,
                r1: row, c1: col,
                width: width, height: height,
                colorA: toolsVM.ditherColorA,
                colorB: toolsVM.ditherColorB,
                pattern: toolsVM.ditherPattern
            )
        default:
            break
        }
    }
    
    // Called on touch ended — commits the preview pixels to the active layer
    func commitShapePreview() {
        guard !shapePreviewPixels.isEmpty else { return }
        beginAction()
        
        var localPixels = pixels
        var localHexes = pixelHexes
        for (index, hex) in shapePreviewPixels {
            guard index >= 0, index < localPixels.count else { continue }
            localPixels[index] = hex == "clear" ? .clear : Color(hex: hex)
            localHexes[index] = hex
        }
        pixels = localPixels
        pixelHexes = localHexes
        
        actionDidChange = true
        shapePreviewPixels = []
        pixelGeneration &+= 1
        endAction()
    }
    
    // Cancel / clear preview without committing
    func cancelShapePreview() {
        shapePreviewPixels = []
    }
    
    // MARK: - Line (Bresenham + thickness)
    
    private func linePixels(r0: Int, c0: Int, r1: Int, c1: Int,
                            width: Int, height: Int, hex: String) -> [(index: Int, hex: String)] {
        var spine: [(Int, String)] = []
        
        var x0 = c0, y0 = r0, x1 = c1, y1 = r1
        let dx = abs(x1 - x0)
        let dy = -abs(y1 - y0)
        let sx = x0 < x1 ? 1 : -1
        let sy = y0 < y1 ? 1 : -1
        var err = dx + dy
        
        while true {
            if x0 >= 0 && x0 < width && y0 >= 0 && y0 < height {
                spine.append((y0 * width + x0, hex))
            }
            if x0 == x1 && y0 == y1 { break }
            let e2 = 2 * err
            if e2 >= dy { err += dy; x0 += sx }
            if e2 <= dx { err += dx; y0 += sy }
        }
        
        // Expand spine by stroke thickness using the shared brush kernel
        let thickness = toolsVM.lineThickness
        guard thickness > 1 else { return spine }
        
        var seen = Set<Int>(spine.map { $0.0 })
        var expanded = spine
        for (idx, _) in spine {
            let row = idx / width
            let col = idx % width
            for i in brushIndices(centerRow: row, centerCol: col,
                                  brushSize: thickness, width: width, height: height) {
                if seen.insert(i).inserted {
                    expanded.append((i, hex))
                }
            }
        }
        return expanded
    }
    
    // MARK: - Rectangle (thickness-aware)
    
    private func rectanglePixels(r0: Int, c0: Int, r1: Int, c1: Int,
                                  width: Int, height: Int, hex: String,
                                  filled: Bool) -> [(index: Int, hex: String)] {
        let minR = max(0, min(r0, r1))
        let maxR = min(height - 1, max(r0, r1))
        let minC = max(0, min(c0, c1))
        let maxC = min(width - 1, max(c0, c1))
        
        // Thickness only applies to the outline mode; filled ignores it
        let thickness = filled ? 1 : toolsVM.rectangleThickness
        
        var result: [(Int, String)] = []
        
        for r in minR...maxR {
            for c in minC...maxC {
                if filled {
                    result.append((r * width + c, hex))
                } else {
                    // Draw a band of `thickness` pixels inward from each edge
                    let onBorder = r < minR + thickness || r > maxR - thickness
                                || c < minC + thickness || c > maxC - thickness
                    if onBorder {
                        result.append((r * width + c, hex))
                    }
                }
            }
        }
        return result
    }
    
    // MARK: - Circle / Ellipse (Midpoint, thickness-aware)
    
    private func circlePixels(r0: Int, c0: Int, r1: Int, c1: Int,
                               width: Int, height: Int, hex: String,
                               filled: Bool) -> [(index: Int, hex: String)] {
        // Bounding box defines the ellipse
        let minR = min(r0, r1)
        let maxR = max(r0, r1)
        let minC = min(c0, c1)
        let maxC = max(c0, c1)
        
        let cx = Double(minC + maxC) / 2.0
        let cy = Double(minR + maxR) / 2.0
        let rx = Double(maxC - minC) / 2.0
        let ry = Double(maxR - minR) / 2.0
        
        guard rx > 0 || ry > 0 else {
            // Single pixel
            let r = minR, c = minC
            if r >= 0 && r < height && c >= 0 && c < width {
                return [(r * width + c, hex)]
            }
            return []
        }
        
        var result: [(Int, String)] = []
        var addedSet = Set<Int>()
        
        func addPixel(_ r: Int, _ c: Int) {
            guard r >= 0, r < height, c >= 0, c < width else { return }
            let idx = r * width + c
            if addedSet.insert(idx).inserted {
                result.append((idx, hex))
            }
        }
        
        if filled {
            // Scan each row, find extent of ellipse
            for r in max(0, minR)...min(height - 1, maxR) {
                let dy = Double(r) - cy
                if ry == 0 {
                    // Horizontal line
                    for c in max(0, minC)...min(width - 1, maxC) {
                        addPixel(r, c)
                    }
                } else {
                    let ratio = (1.0 - (dy * dy) / (ry * ry))
                    guard ratio >= 0 else { continue }
                    let halfWidth = rx * sqrt(ratio)
                    let startC = Int(floor(cx - halfWidth + 0.5))
                    let endC = Int(floor(cx + halfWidth + 0.5))
                    for c in max(0, startC)...min(width - 1, endC) {
                        addPixel(r, c)
                    }
                }
            }
        } else {
            // Build the 1-pixel outline ring via angle sampling
            let perimeter = max(4, Int(2.0 * Double.pi * max(rx, ry)))
            let steps = perimeter * 4  // oversample for clean edges
            for i in 0..<steps {
                let angle = (Double(i) / Double(steps)) * 2.0 * Double.pi
                let px = cx + rx * cos(angle)
                let py = cy + ry * sin(angle)
                let c = Int(floor(px + 0.5))
                let r = Int(floor(py + 0.5))
                addPixel(r, c)
            }
            
            // Expand the 1px ring by stroke thickness using the shared brush kernel
            let thickness = toolsVM.circleThickness
            if thickness > 1 {
                let spine = result
                for (idx, _) in spine {
                    let row = idx / width
                    let col = idx % width
                    for i in brushIndices(centerRow: row, centerCol: col,
                                         brushSize: thickness, width: width, height: height) {
                        if addedSet.insert(i).inserted {
                            result.append((i, hex))
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    // MARK: - Gradient
    
    private func gradientPixels(r0: Int, c0: Int, r1: Int, c1: Int,
                                 width: Int, height: Int,
                                 colorA: Color, colorB: Color,
                                 steps: Int, thickness: Int) -> [(index: Int, hex: String)] {
        let dr = Double(r1 - r0)
        let dc = Double(c1 - c0)
        let length = sqrt(dr * dr + dc * dc)
        guard length > 0.5 else { return [] }
        
        // Direction unit vector from A to B
        let dirR = dr / length
        let dirC = dc / length
        
        // Perpendicular unit vector (rotated 90°)
        let perpR = -dirC
        let perpC = dirR
        
        // Half-thickness for perpendicular distance check (0 = full canvas)
        let halfThick = thickness > 0 ? Double(thickness) / 2.0 : Double.greatestFiniteMagnitude
        
        // Pre-compute gradient color band hex values
        let clampedSteps = max(2, min(steps, 32))
        var bandHexes: [String] = []
        
        var rA: CGFloat = 0, gA: CGFloat = 0, bA: CGFloat = 0, aA: CGFloat = 0
        var rB: CGFloat = 0, gB: CGFloat = 0, bB: CGFloat = 0, aB: CGFloat = 0
        UIColor(colorA).getRed(&rA, green: &gA, blue: &bA, alpha: &aA)
        UIColor(colorB).getRed(&rB, green: &gB, blue: &bB, alpha: &aB)
        
        for i in 0..<clampedSteps {
            let t = clampedSteps == 1 ? 0.0 : Double(i) / Double(clampedSteps - 1)
            let r = rA + CGFloat(t) * (rB - rA)
            let g = gA + CGFloat(t) * (gB - gA)
            let b = bA + CGFloat(t) * (bB - bA)
            let color = Color(red: Double(r), green: Double(g), blue: Double(b))
            bandHexes.append(color.toHex() ?? "#000000")
        }
        
        var result: [(Int, String)] = []
        
        for r in 0..<height {
            for c in 0..<width {
                let vr = Double(r - r0)
                let vc = Double(c - c0)
                
                // Project onto gradient direction
                let proj = vr * dirR + vc * dirC
                
                // Normalize to 0...1 along the drag distance
                let t = proj / length
                guard t >= 0 && t <= 1.0 else { continue }
                
                // Check perpendicular distance from the gradient line
                let perpDist = abs(vr * perpR + vc * perpC)
                guard perpDist <= halfThick else { continue }
                
                // Map to band index
                let bandIndex = min(clampedSteps - 1, Int(t * Double(clampedSteps)))
                result.append((r * width + c, bandHexes[bandIndex]))
            }
        }
        
        return result
    }
    
    // MARK: - Dither
    
    private func ditherPixels(r0: Int, c0: Int, r1: Int, c1: Int,
                               width: Int, height: Int,
                               colorA: Color, colorB: Color,
                               pattern: ToolsViewModel.DitherPattern) -> [(index: Int, hex: String)] {
        let minR = max(0, min(r0, r1))
        let maxR = min(height - 1, max(r0, r1))
        let minC = max(0, min(c0, c1))
        let maxC = min(width - 1, max(c0, c1))
        
        let hexA = colorA.toHex() ?? "#000000"
        let hexB = colorB.toHex() ?? "#FFFFFF"
        
        var result: [(Int, String)] = []
        
        for r in minR...maxR {
            for c in minC...maxC {
                let useA: Bool
                switch pattern {
                case .checkerboard:
                    useA = (r + c) % 2 == 0
                case .bayer2x2:
                    // 25% color B: only the darkest cell in each 2×2 block
                    let threshold = Self.bayer2x2[r % 2][c % 2]
                    useA = threshold < 1  // only cell 0 → A; cells 1,2,3 → B
                case .bayer4x4:
                    useA = (r % 4 == 0 && c % 4 == 0) || (r % 4 == 2 && c % 4 == 2)
                case .horizontal:
                    useA = r % 2 == 0
                case .vertical:
                    useA = c % 2 == 0
                case .diagonal:
                    useA = (r + c) % 3 != 0
                case .diagonalReversed:
                    useA = ((r - c) % 3 + 3) % 3 != 0
                case .zigzag:
                    useA = (r + c * 2) % 4 != 0
                case .sparse:
                    useA = r % 3 == 0 && c % 3 == 0
                case .zigzagReversed:
                    useA = !( (r % 2 == 0 && c % 4 == 0) || (r % 2 == 1 && c % 4 == 2) )
                case .diamond:
                    switch r % 4 {
                    case 0: // xxx0xxx0
                        useA = c % 4 != 3
                    case 1, 3: // 0x0x0x0x
                        useA = c % 2 == 1
                    case 2: // x0xxx0x
                        useA = c % 4 != 1
                    default:
                        useA = true
                    }
                }
                
                result.append((r * width + c, useA ? hexA : hexB))
            }
        }
        
        return result
    }
    
    // Bayer dither matrices
    private static let bayer2x2: [[Int]] = [
        [0, 2],
        [3, 1]
    ]
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
