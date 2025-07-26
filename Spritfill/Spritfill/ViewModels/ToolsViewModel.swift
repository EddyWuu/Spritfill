//
//  ToolsViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-06-04.
//

import SwiftUI

class ToolsViewModel: ObservableObject {
    
    enum ToolType: CaseIterable {
        
        case pencil, eraser, fill

        var iconName: String {
            switch self {
            case .pencil: return "pencil"
            case .eraser: return "eraser"
            case .fill: return "paintbrush"
            }
        }
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
    
    var availableTools: [ToolType] {
        ToolType.allCases
    }
    
    func isSelected(tool: ToolType) -> Bool {
        return selectedTool == tool
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
