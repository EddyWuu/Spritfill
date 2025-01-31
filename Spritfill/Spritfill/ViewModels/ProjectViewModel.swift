//
//  ProjectViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

class ProjectViewModel: ObservableObject {
 
    @Published var selectedCanvasSize: CanvasSizes
    @Published var selectedPalette: ColorPalettes
    @Published var selectedTileSize: TileSizes
    
    @Published var pixels: [[Color]]
    
    init(selectedCanvasSize: CanvasSizes, selectedPalette: ColorPalettes, selectedTileSize: TileSizes) {
        
        self.selectedCanvasSize = selectedCanvasSize
        self.selectedPalette = selectedPalette
        self.selectedTileSize = selectedTileSize
        
        let dimensions = selectedCanvasSize.dimensions
        self.pixels = Array(repeating: Array(repeating: Color.clear, count: dimensions.width), count: dimensions.height)
    }
    
}
