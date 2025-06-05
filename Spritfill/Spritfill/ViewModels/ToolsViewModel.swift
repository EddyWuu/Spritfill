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

    init(defaultColor: Color) {
        self.selectedColor = defaultColor
    }

    func selectTool(_ tool: ToolType) {
        selectedTool = tool
    }

    func selectColor(_ color: Color) {
        selectedColor = color
    }
}
