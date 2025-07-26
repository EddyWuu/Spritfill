//
//  ToolButtonView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-25.
//

import SwiftUI

struct ToolButtonView: View {
    
    let tool: ToolsViewModel.ToolType
    @ObservedObject var toolsVM: ToolsViewModel

    var body: some View {
        
        Button(action: {
            toolsVM.selectTool(tool)
        }) {
            Image(systemName: tool.iconName)
                .foregroundColor(toolsVM.isSelected(tool: tool) ? .blue : .primary)
                .padding()
                .background(toolsVM.isSelected(tool: tool) ? Color.blue.opacity(0.2) : Color.clear)
                .clipShape(Circle())
        }
    }
}
