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
        self.toolsVM = ToolsViewModel(defaultColor: data.settings.selectedPalette.colors[0], palette: data.settings.selectedPalette)
        
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

        toolsVM.applyTool(to: &pixels[index])
        objectWillChange.send()
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
        return renderer.uiImage ?? UIImage()
    }
    
    func clearCanvas() {
        // Implementation needed
    }
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
