//
//  ToolBarView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-06.
//

import SwiftUI

struct ToolsBarView: View {
    @ObservedObject var toolsVM: ToolsViewModel

    var body: some View {
        HStack(spacing: 16) {
            ForEach(toolsVM.availableTools, id: \.self) { tool in
                ToolButtonView(tool: tool, toolsVM: toolsVM)
            }
            
            Spacer()
            
            // Show currently selected color swatch
            Circle()
                .fill(toolsVM.selectedColor)
                .frame(width: 28, height: 28)
                .overlay(Circle().stroke(Color.primary, lineWidth: 2))
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
