//
//  ToolsModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

protocol Tool {
    
    var name: String { get }
    var icon: String { get }
    func apply(to pixel: inout Color, with selectedColor: Color)
}

struct PencilTool: Tool {
    
    let name = "Pencil"
    let icon = "pencil"
    
    
    func apply(to pixel: inout Color, with selectedColor: Color) {
        pixel = selectedColor
    }
}

struct EraserTool: Tool {
    
    let name = "Eraser"
    let icon = "eraser"
    
    func apply(to pixel: inout Color, with selectedColor: Color) {
        pixel = Color.clear
    }
}

class ToolManager: ObservableObject {
    
    @Published var selectedTool: Tool = PencilTool()
}
