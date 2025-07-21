//
//  ToolsViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-06-04.
//

import SwiftUI

class ToolsViewModel: ObservableObject {
    
    enum ToolType {
        case pencil, eraser, fill
    }

    @Published var selectedTool: ToolType = .pencil
    @Published var selectedColor: Color
    private var palette: ColorPalettes

    init(defaultColor: Color, palette: ColorPalettes) {
        self.selectedColor = defaultColor
        self.palette = palette
    }
    
    var availableColors: [Color] {
        palette.colors
    }
    
    func applyTool(to pixel: inout Color) {
        switch selectedTool {
        case .pencil:
            pixel = selectedColor
        case .eraser:
            pixel = .clear
        case .fill:
            // not yet implemented
            break
        }
    }

    func selectTool(_ tool: ToolType) {
        selectedTool = tool
    }

    func selectColor(_ color: Color) {
        selectedColor = color
    }
}
