//
//  ProjectViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

class ProjectViewModel: ObservableObject {
    
    // MARK: - properties
 
    @Published var projectSettings: ProjectSettings
    
    @Published var pixels: [[Color]]
    @Published var selectedTool: ToolType = .pencil
    @Published var selectedColor: Color
    
    // MARK: - initializer
    
    init(selectedCanvasSize: CanvasSizes, selectedPalette: ColorPalettes, selectedTileSize: TileSizes) {
        
        self.projectSettings = ProjectSettings(
            selectedCanvasSize: selectedCanvasSize,
            selectedTileSize: selectedTileSize,
            selectedPalette: selectedPalette
        )
        
        let dimensions = selectedCanvasSize.dimensions
        self.pixels = Array(repeating: Array(repeating: Color.clear, count: dimensions.width), count: dimensions.height)
        
        self.selectedColor = selectedPalette.colors[0]
    }
    
    enum ToolType {
        case pencil, eraser, fill
    }
    
    // MARK: - methods
    
    func selectTool(_ tool: ToolType) {
        
        selectedTool = tool
    }
    
    
    func selectColor(_ color: Color) {
        
        selectedColor = color
    }
    
    func updatePixel(row: Int, col: Int) {
        
        guard row >= 0, row < pixels.count,
              col >= 0, col < pixels[0].count else { return }

        pixels[row][col] = selectedColor
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
