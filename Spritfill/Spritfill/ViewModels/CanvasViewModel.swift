//
//  CanvasViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

class CanvasViewModel: ObservableObject {
    
    // MARK: - properties
 
    @Published var projectSettings: ProjectSettings
    
    let projectID: UUID
    @Published var projectName: String
    @Published var pixels: [Color]
    
    @Published var toolsVM: ToolsViewModel
    @Published var isFinished: Bool = false
    
    @Published var zoomScale: CGFloat = 1.0
    @Published var viewSize: CGSize = .zero
    
    // MARK: - Undo / Redo history (stored as hex strings for low memory usage)
    
    private var undoHistory: [[String]] = []
    private var redoHistory: [[String]] = []
    @Published var canUndo: Bool = false
    @Published var canRedo: Bool = false
    private var memoryObserver: Any?
    
    private var maxUndoSteps: Int {
        let pixelCount = pixels.count
        if pixelCount > 4096 { return 50 }       // 64x64+
        if pixelCount > 1024 { return 100 }      // 32x32+
        return 150                                // 16x16
    }
    
    private func setupMemoryWarning() {
        memoryObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            self?.undoHistory.removeAll()
            self?.redoHistory.removeAll()
            self?.canUndo = false
            self?.canRedo = false
        }
    }
    
    deinit {
        if let observer = memoryObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    /// Convert the current pixel array to hex strings for storage
    private func pixelsToHex() -> [String] {
        pixels.map { $0.isClear ? "clear" : ($0.toHex() ?? "#000000") }
    }
    
    /// Restore pixels from a hex string snapshot
    private func restorePixels(from hexes: [String]) {
        pixels = hexes.map { $0 == "clear" ? Color.clear : Color(hex: $0) }
    }
    
    // Save current pixel state before an action
    private func saveSnapshot() {
        undoHistory.append(pixelsToHex())
        if undoHistory.count > maxUndoSteps {
            undoHistory.removeFirst()
        }
        // Any new action clears the redo stack
        redoHistory.removeAll()
        canUndo = true
        canRedo = false
    }
    
    // Undo the last action — restores the previous pixel state
    func undo() {
        guard let previous = undoHistory.popLast() else { return }
        // Push current state onto redo stack before restoring
        redoHistory.append(pixelsToHex())
        restorePixels(from: previous)
        canUndo = !undoHistory.isEmpty
        canRedo = true
    }
    
    // Redo — restores a previously undone state
    func redo() {
        guard let next = redoHistory.popLast() else { return }
        // Push current state onto undo stack before restoring
        undoHistory.append(pixelsToHex())
        restorePixels(from: next)
        canUndo = true
        canRedo = !redoHistory.isEmpty
    }
    
    // Call once at the start of a drawing gesture to capture the "before" state
    private var actionInProgress = false
    
    func beginAction() {
        if !actionInProgress {
            saveSnapshot()
            actionInProgress = true
        }
    }
    
    func endAction() {
        actionInProgress = false
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
        self.pixels = Array(repeating: Color.clear, count: dimensions.width * dimensions.height)
        
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
        
        // rebuild 2D array from 1D
        self.pixels = data.pixelGrid.map { hex in
            if hex == "clear" {
                return Color.clear
            } else {
                return Color(hex: hex)
            }
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
    
    func toProjectData() -> ProjectData {
        
        let flatHexGrid = pixels.map {
            $0.isClear ? "clear" : ($0.toHex() ?? "#000000")
        }

        return ProjectData(
            id: projectID,
            name: projectName,
            settings: projectSettings,
            pixelGrid: flatHexGrid,
            lastEdited: Date(),
            isFinished: isFinished
        )
    }
    
    // Sync extra colors from ToolsViewModel back to project settings for persistence
    func syncExtraColors(_ colors: [String]) {
        projectSettings.extraColors = colors
    }
    
    func updatePixel(row: Int, col: Int) {
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let index = row * width + col

        guard index >= 0, index < pixels.count else { return }

        pixels[index] = toolsVM.selectedColor
        objectWillChange.send()
    }
    
    // Clamp to screen bounds
    func clampedOffset(for offset: CGSize, geoSize: CGSize, canvasSize: CGSize) -> CGSize {
        
        let maxX = max(0, (canvasSize.width - geoSize.width) / 2)
        let maxY = max(0, (canvasSize.height - geoSize.height) / 2)

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
            toolsVM.applyTool(to: &pixels[index])
        }
        objectWillChange.send()
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
        
        if toolsVM.selectedTool == .fill {
            floodFill(at: index, with: toolsVM.effectiveDrawingColor)
        } else {
            toolsVM.applyTool(to: &pixels[index])
        }
        
        // Apply symmetry mirrors
        let hSym = toolsVM.horizontalSymmetry
        let vSym = toolsVM.verticalSymmetry
        
        if hSym {
            let mirrorCol = width - 1 - col
            let mirrorIndex = row * width + mirrorCol
            if mirrorIndex != index, mirrorIndex >= 0, mirrorIndex < pixels.count {
                if toolsVM.selectedTool == .fill {
                    floodFill(at: mirrorIndex, with: toolsVM.effectiveDrawingColor)
                } else {
                    toolsVM.applyTool(to: &pixels[mirrorIndex])
                }
            }
        }
        
        if vSym {
            let mirrorRow = height - 1 - row
            let mirrorIndex = mirrorRow * width + col
            if mirrorIndex != index, mirrorIndex >= 0, mirrorIndex < pixels.count {
                if toolsVM.selectedTool == .fill {
                    floodFill(at: mirrorIndex, with: toolsVM.effectiveDrawingColor)
                } else {
                    toolsVM.applyTool(to: &pixels[mirrorIndex])
                }
            }
        }
        
        // Diagonal mirror when both symmetries are active
        if hSym && vSym {
            let mirrorRow = height - 1 - row
            let mirrorCol = width - 1 - col
            let mirrorIndex = mirrorRow * width + mirrorCol
            if mirrorIndex != index, mirrorIndex >= 0, mirrorIndex < pixels.count {
                if toolsVM.selectedTool == .fill {
                    floodFill(at: mirrorIndex, with: toolsVM.effectiveDrawingColor)
                } else {
                    toolsVM.applyTool(to: &pixels[mirrorIndex])
                }
            }
        }
        
        objectWillChange.send()
    }
    
    /// Eyedropper: pick the color at a grid index, set it as selected, and switch to pencil
    func eyedropperPickColor(at index: Int) {
        guard index >= 0, index < pixels.count else { return }
        let color = pixels[index]
        guard !color.isClear else { return }
        
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
    
    /// Returns the color at a grid index (for eyedropper preview)
    func colorAtIndex(_ index: Int) -> Color? {
        guard index >= 0, index < pixels.count else { return nil }
        let color = pixels[index]
        return color.isClear ? nil : color
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
                
                newPixels[row * width + col] = pixels[sourceRow * width + sourceCol]
            }
        }
        
        pixels = newPixels
        objectWillChange.send()
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
                
                newPixels[row * width + col] = pixels[sourceRow * width + sourceCol]
            }
        }
        
        pixels = newPixels
        objectWillChange.send()
    }
    
    // MARK: - Flood Fill (BFS)
    
    private func floodFill(at startIndex: Int, with newColor: Color) {
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height
        let totalPixels = width * height
        
        guard startIndex >= 0, startIndex < totalPixels else { return }
        
        let targetColor = pixels[startIndex]
        
        // Don't fill if the color is the same
        if colorsMatch(targetColor, newColor) { return }
        
        var queue: [Int] = [startIndex]
        var visited = Set<Int>()
        visited.insert(startIndex)
        
        while !queue.isEmpty {
            let current = queue.removeFirst()
            pixels[current] = newColor
            
            let row = current / width
            let col = current % width
            
            // Check 4 neighbors
            let neighbors = [
                (row - 1, col), // up
                (row + 1, col), // down
                (row, col - 1), // left
                (row, col + 1)  // right
            ]
            
            for (r, c) in neighbors {
                guard r >= 0, r < height, c >= 0, c < width else { continue }
                let neighborIndex = r * width + c
                guard !visited.contains(neighborIndex) else { continue }
                guard colorsMatch(pixels[neighborIndex], targetColor) else { continue }
                
                visited.insert(neighborIndex)
                queue.append(neighborIndex)
            }
        }
    }
    
    private func colorsMatch(_ a: Color, _ b: Color) -> Bool {
        if a.isClear && b.isClear { return true }
        if a.isClear || b.isClear { return false }
        // Direct RGBA comparison — avoids expensive Color->UIColor->hex roundtrip
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        UIColor(a).getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        UIColor(b).getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        let tolerance: CGFloat = 1.0 / 255.0
        return abs(r1 - r2) < tolerance && abs(g1 - g2) < tolerance && abs(b1 - b2) < tolerance
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

    @MainActor
    func renderCanvasImage(from view: some View, size: CGSize) -> UIImage {
        let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        renderer.scale = UIScreen.main.scale
        renderer.isOpaque = false
        return renderer.uiImage ?? UIImage()
    }
    
    // MARK: - Export
    
    @Published var isExporting: Bool = false
    
    @MainActor
    func exportImage() -> UIImage {
        let dims = projectSettings.selectedCanvasSize.dimensions
        let tileSize = CGFloat(projectSettings.selectedTileSize)
        let exportSize = CGSize(width: CGFloat(dims.width) * tileSize,
                                height: CGFloat(dims.height) * tileSize)
        let canvasView = ProjectCanvasExportView(viewModel: self)
        return renderCanvasImage(from: canvasView, size: exportSize)
    }
    
    func exportAndSaveToPhotos(completion: (() -> Void)? = nil) {
        isExporting = true
        Task { @MainActor in
            // Yield so the UI can show the loading state
            try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
            let image = self.exportImage()
            self.isExporting = false
            PhotoSaver.saveAsPNG(image) {
                completion?()
            }
        }
    }
    
    func exportAndGetShareImage(completion: @escaping (IdentifiableImage) -> Void) {
        isExporting = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
            let image = self.exportImage()
            self.isExporting = false
            completion(IdentifiableImage(image: image))
        }
    }
    
    // MARK: - Submit Artwork
    
    @Published var isSubmitting: Bool = false
    @Published var submissionError: String? = nil
    
    @MainActor
    func submitArtwork(artistName: String, completion: @escaping (Bool) -> Void) {
        isSubmitting = true
        submissionError = nil
        
        let dims = projectSettings.selectedCanvasSize.dimensions
        let pixelGrid = pixels.map { $0.isClear ? "clear" : ($0.toHex() ?? "#000000") }
        
        let submission = ArtSubmission(
            artistName: artistName.trimmingCharacters(in: .whitespaces),
            projectName: projectName,
            canvasWidth: dims.width,
            canvasHeight: dims.height,
            pixelGrid: pixelGrid
        )
        
        let image = exportImage()
        
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
