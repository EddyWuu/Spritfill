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
    @Published var needsPanReset: Bool = false
    
    @Published var toolsVM: ToolsViewModel
    
    @Published var zoomScale: CGFloat = 1.0
    @Published var viewSize: CGSize = .zero
    
    private var _cachedMinZoom: CGFloat?
    private var _cachedMaxZoom: CGFloat?
    private var _zoomBoundsLocked: Bool = false
    
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
    
    var canvasSize: CGSize {
        let tileSize = CGFloat(projectSettings.selectedTileSize.size)
        let gridWidth = projectSettings.selectedCanvasSize.dimensions.width
        let gridHeight = projectSettings.selectedCanvasSize.dimensions.height
        return CGSize(width: CGFloat(gridWidth) * tileSize,
                     height: CGFloat(gridHeight) * tileSize)
    }
    
    var minimumZoomScale: CGFloat {
        // Return cached value if bounds are locked (after initial setup)
        if _zoomBoundsLocked, let cached = _cachedMinZoom {
            return cached
        }
        
        guard viewSize != .zero else { return 0.5 }
        
        let canvas = canvasSize
        
        // Calculate the scale needed to fit the ENTIRE canvas in the view with some padding
        let paddingFactor: CGFloat = 0.9 // Use 90% of available space
        let scaleToFitWidth = (viewSize.width * paddingFactor) / canvas.width
        let scaleToFitHeight = (viewSize.height * paddingFactor) / canvas.height
        
        // The fit scale is the SMALLER of the two - this ensures the entire canvas fits
        let fitScale = min(scaleToFitWidth, scaleToFitHeight)
        
        // Set reasonable absolute minimums based on canvas size to prevent tiny canvases
        let canvasPixelArea = canvas.width * canvas.height
        let absoluteMinimum: CGFloat
        
        if canvasPixelArea <= 16384 { // Small canvases (≤128x128 pixels)
            absoluteMinimum = 0.5
        } else if canvasPixelArea <= 65536 { // Medium canvases (≤256x256 pixels)
            absoluteMinimum = 0.3
        } else if canvasPixelArea <= 262144 { // Large canvases (≤512x512 pixels)
            absoluteMinimum = 0.2
        } else { // Very large canvases
            absoluteMinimum = 0.1
        }
        
        // ALWAYS allow zooming out enough to see the full canvas
        // But don't go below our absolute minimum
        let result = min(fitScale, absoluteMinimum)
        
        // Cache the result
        _cachedMinZoom = result
        return result
    }
    
    var maximumZoomScale: CGFloat {
        // Return cached value if bounds are locked
        if _zoomBoundsLocked, let cached = _cachedMaxZoom {
            return cached
        }
        
        let canvas = canvasSize
        let canvasPixelArea = canvas.width * canvas.height
        
        // Base max zoom on actual rendered canvas size, not just grid dimensions
        let result: CGFloat
        if canvasPixelArea <= 16384 { // Small rendered canvases (e.g., 16x16 with 8px tiles = 128x128 pixels)
            result = 8.0
        } else if canvasPixelArea <= 65536 { // Medium canvases (e.g., 32x32 with 8px tiles = 256x256 pixels)
            result = 6.0
        } else if canvasPixelArea <= 262144 { // Large canvases (e.g., 64x64 with 16px tiles = 1024x1024 pixels)
            result = 4.0
        } else if canvasPixelArea <= 1048576 { // Very large canvases
            result = 3.0
        } else { // Huge canvases (128x128 with 32px tiles = 4096x4096 pixels)
            result = 2.0
        }
        
        // Cache the result
        _cachedMaxZoom = result
        return result
    }
    
    func updateViewSize(_ size: CGSize) {
        let oldViewSize = viewSize
        viewSize = size
        
        // Only recalculate zoom for significant size changes or first time setup
        let isFirstTime = oldViewSize == .zero
        let significantChange = abs(oldViewSize.width - size.width) > 20 ||
                               abs(oldViewSize.height - size.height) > 20
        
        guard isFirstTime || significantChange else { return }
        
        // Clear cached zoom bounds only for significant changes (not first time)
        if significantChange && !isFirstTime {
            _cachedMinZoom = nil
            _cachedMaxZoom = nil
            _zoomBoundsLocked = false
        }
        
        let newMinZoom = minimumZoomScale
        let newMaxZoom = maximumZoomScale
        
        if isFirstTime {
            // For first time, start with fit scale or 1.0, whichever is larger
            zoomScale = max(newMinZoom, 1.0)
            // Lock the zoom bounds after initial setup with a small delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self._zoomBoundsLocked = true
            }
        } else {
            // For size changes, only adjust if current zoom is outside valid range
            if zoomScale < newMinZoom {
                zoomScale = newMinZoom
            } else if zoomScale > newMaxZoom {
                zoomScale = newMaxZoom
            }
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
    
    func applyTool(at point: CGPoint, zoomScale: CGFloat) {
        
        let tileSize = CGFloat(projectSettings.selectedTileSize.size) * zoomScale
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height

        let col = Int(point.x / tileSize)
        let row = Int(point.y / tileSize)
        let index = row * width + col

        guard row >= 0, row < height, col >= 0, col < width, index < pixels.count else { return }

        toolsVM.applyTool(to: &pixels[index])
        objectWillChange.send()
    }
    
    func getGridCoordinates(from location: CGPoint, zoomScale: CGFloat) -> (row: Int, col: Int)? {
        
        let tileSize = CGFloat(projectSettings.selectedTileSize.size) * zoomScale
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height

        let col = Int(location.x / tileSize)
        let row = Int(location.y / tileSize)

        if row >= 0, row < height, col >= 0, col < width {
            return (row, col)
        } else {
            return nil
        }
    }

    func didSwitchToPanTool() {
        // Only set the pan reset flag, don't trigger any other updates
        needsPanReset = true
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
