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
    
    // MARK: - methods
    
    func selectColor(_ color: Color) {
        selectedColor = color
    }
    
    func updatePixel(row: Int, col: Int) {
        
        guard row >= 0, row < projectSettings.pixels.count,
              col >= 0, col < projectSettings.pixels[0].count else { return }
        
        projectSettings.pixels[row][col] = selectedColor
        objectWillChange.send()
    }
    
    func clearCanvas() {
        
        let dimensions = projectSettings.selectedCanvasSize.dimensions
        
        projectSettings.pixels = Array(
            repeating: Array(repeating: Color.clear, count: dimensions.width),
            count: dimensions.height
        )
    }
}
