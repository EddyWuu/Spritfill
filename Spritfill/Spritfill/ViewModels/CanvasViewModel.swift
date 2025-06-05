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
    @Published var pixels: [[Color]]
    
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
        self.pixels = Array(repeating: Array(repeating: Color.clear, count: dimensions.width), count: dimensions.height)
        
        self.toolsVM = ToolsViewModel(defaultColor: selectedPalette.colors[0])
    }
    
    // MARK: - Init: From Saved Project
    
    init(from data: ProjectData) {
        self.projectID = data.id
        self.projectName = data.name
        self.projectSettings = data.settings
        self.toolsVM = ToolsViewModel(defaultColor: data.settings.selectedPalette.colors[0])

        // convert hex strings to Color
        self.pixels = data.pixelGrid.map { row in
            row.map { Color(hex: $0) }
        }
    }

    // MARK: - Convert to ProjectData
    
    func toProjectData() -> ProjectData {
        let hexGrid = pixels.map { row in
            row.map { $0.toHex() ?? "#000000" } // fallback black if nil
        }
        
        return ProjectData(
            id: projectID,
            name: projectName,
            settings: projectSettings,
            pixelGrid: hexGrid,
            lastEdited: Date()
        )
    }
    
    func updatePixel(row: Int, col: Int) {
        
        guard row >= 0, row < pixels.count,
              col >= 0, col < pixels[0].count else { return }

        pixels[row][col] = toolsVM.selectedColor
        objectWillChange.send()
    }
    
    func clearCanvas() {
        

    }
    
    func updatePixelAt(location: CGPoint, zoomScale: CGFloat) {
        
        let tileSize = CGFloat(projectSettings.selectedTileSize.size) * zoomScale
        let canvasWidth = pixels[0].count
        let canvasHeight = pixels.count

        // convert location to pixel row/column
        let col = Int(location.x / tileSize)
        let row = Int(location.y / tileSize)

        // check if within bounds
        if row >= 0, row < canvasHeight, col >= 0, col < canvasWidth {
            updatePixel(row: row, col: col)
        }
    }
}
