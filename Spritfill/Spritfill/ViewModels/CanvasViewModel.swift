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
    
    // Debounced auto-save — coalesces rapid pixel changes into a single background disk write.
    private func debouncedAutoSave() {
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
            self.layerManager = LayerManagerViewModel(layers: savedLayers.map { Layer(from: $0) })
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
        pixelGeneration &+= 1
        debouncedAutoSave()
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
        
        // Apply symmetry mirrors
        let hSym = toolsVM.horizontalSymmetry
        let vSym = toolsVM.verticalSymmetry
        
        if hSym {
            let mirrorCol = width - 1 - col
            let mirrorIndices = brushIndices(centerRow: row, centerCol: mirrorCol, brushSize: brushSize, width: width, height: height)
            for idx in mirrorIndices where idx != index {
                if tool == .fill {
                    let fillColor = toolsVM.fillEraseMode ? Color.clear : toolsVM.effectiveDrawingColor
                    floodFill(at: idx, with: fillColor)
                } else {
                    applyToolToPixel(at: idx)
                }
            }
        }
        
        if vSym {
            let mirrorRow = height - 1 - row
            let mirrorIndices = brushIndices(centerRow: mirrorRow, centerCol: col, brushSize: brushSize, width: width, height: height)
            for idx in mirrorIndices where idx != index {
                if tool == .fill {
                    let fillColor = toolsVM.fillEraseMode ? Color.clear : toolsVM.effectiveDrawingColor
                    floodFill(at: idx, with: fillColor)
                } else {
                    applyToolToPixel(at: idx)
                }
            }
        }
        
        // Diagonal mirror when both symmetries are active
        if hSym && vSym {
            let mirrorRow = height - 1 - row
            let mirrorCol = width - 1 - col
            let mirrorIndices = brushIndices(centerRow: mirrorRow, centerCol: mirrorCol, brushSize: brushSize, width: width, height: height)
            for idx in mirrorIndices where idx != index {
                if tool == .fill {
                    let fillColor = toolsVM.fillEraseMode ? Color.clear : toolsVM.effectiveDrawingColor
                    floodFill(at: idx, with: fillColor)
                } else {
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
    
    func exportAndGetShareImage(completion: @escaping (IdentifiableImage) -> Void) {
        isExporting = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
            let image = self.exportImage()
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
    func submitArtwork(artistName: String, completion: @escaping (Bool) -> Void) {
        isSubmitting = true
        submissionError = nil
        
        let dims = projectSettings.selectedCanvasSize.dimensions
        
        let submission = ArtSubmission(
            artistName: artistName.trimmingCharacters(in: .whitespaces),
            projectName: projectName,
            canvasWidth: dims.width,
            canvasHeight: dims.height,
            pixelGrid: compositePixelHexes()
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
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
