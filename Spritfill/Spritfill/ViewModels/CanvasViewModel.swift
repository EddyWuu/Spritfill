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
    }
    
    // MARK: - Init: From Saved Project
    
    init(from data: ProjectData) {
        self.projectID = data.id
        self.projectName = data.name
        self.projectSettings = data.settings
        self.toolsVM = ToolsViewModel(defaultColor: data.settings.selectedPalette.colors[0], palette: data.settings.selectedPalette)
        
//        let width = data.settings.selectedCanvasSize.dimensions.width
//        let height = data.settings.selectedCanvasSize.dimensions.height

        // rebuild 2D array from 1D
        self.pixels = data.pixelGrid.map { hex in
            if hex == "clear" {
                return Color.clear
            } else {
                return Color(hex: hex)
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
    
    func updatePixelAt(location: CGPoint, zoomScale: CGFloat) {
        
        let tileSize = CGFloat(projectSettings.selectedTileSize.size) * zoomScale
        let width = projectSettings.selectedCanvasSize.dimensions.width
        let height = projectSettings.selectedCanvasSize.dimensions.height

        let col = Int(location.x / tileSize)
        let row = Int(location.y / tileSize)

        if row >= 0, row < height, col >= 0, col < width {
            updatePixel(row: row, col: col)
        }
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
    
    func clearCanvas() {
        

    }
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
