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
    
    @Published var zoomScale: CGFloat = 1.0
    @Published var viewSize: CGSize = .zero
    
    // MARK: - Undo history
    
    private var undoHistory: [[Color]] = []
    private let maxUndoSteps = 50
    @Published var canUndo: Bool = false
    
    /// Save current pixel state before an action
    private func saveSnapshot() {
        undoHistory.append(pixels)
        if undoHistory.count > maxUndoSteps {
            undoHistory.removeFirst()
        }
        canUndo = true
    }
    
    /// Undo the last action — restores the previous pixel state
    func undo() {
        guard let previous = undoHistory.popLast() else { return }
        pixels = previous
        canUndo = !undoHistory.isEmpty
    }
    
    /// Call once at the start of a drawing gesture to capture the "before" state
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
    
    init(projectName: String, selectedCanvasSize: CanvasSizes, selectedPalette: ColorPalettes, selectedTileSize: TileSizes) {
        
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
            embeddedPaletteColors: data.settings.customPaletteColors
        )
        
        // rebuild 2D array from 1D
        self.pixels = data.pixelGrid.map { hex in
            if hex == "clear" {
                return Color.clear
            } else {
                return Color(hex: hex)
            }
        }

        self.toolsVM.canvasVM = self
    }

    // MARK: - Zoom calculations
    
    /// Base canvas size is 1pt per pixel — tile size is only used for export
    var baseCanvasSize: CGSize {
        let gridWidth = projectSettings.selectedCanvasSize.dimensions.width
        let gridHeight = projectSettings.selectedCanvasSize.dimensions.height
        return CGSize(width: CGFloat(gridWidth), height: CGFloat(gridHeight))
    }
    
    /// Scale that fits the entire canvas in the view with ~90% padding
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
        let gridArea = baseCanvasSize.width * baseCanvasSize.height
        let multiplier: CGFloat
        if gridArea <= 256 {         // 16×16
            multiplier = 6.0
        } else if gridArea <= 1024 { // 32×32
            multiplier = 5.0
        } else if gridArea <= 4096 { // 64×64
            multiplier = 4.0
        } else {                     // 128×128+
            multiplier = 3.0
        }
        let result = fitScale * multiplier
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
            lastEdited: Date()
        )
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
            floodFill(at: index, with: toolsVM.selectedColor)
        } else {
            toolsVM.applyTool(to: &pixels[index])
        }
        objectWillChange.send()
    }
    
    /// Apply tool at a grid index (used for drag drawing to avoid duplicate coordinate math)
    func applyToolAtIndex(_ index: Int) {
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height
        guard index >= 0, index < pixels.count else { return }
        
        let row = index / width
        let col = index % width
        guard row >= 0, row < height, col >= 0, col < width else { return }
        
        if toolsVM.selectedTool == .fill {
            floodFill(at: index, with: toolsVM.selectedColor)
        } else {
            toolsVM.applyTool(to: &pixels[index])
        }
        objectWillChange.send()
    }
    
    /// Convert a screen-space point to a grid index, given the geo size, canvas offset, and zoom scale
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
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
