//
//  ToolBarView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-06.
//

import SwiftUI

struct ToolsBarView: View {
    @ObservedObject var toolsVM: ToolsViewModel
    @ObservedObject var canvasVM: CanvasViewModel
    @Binding var showColorAdder: Bool

    var body: some View {
        HStack(spacing: 8) {
            ForEach(toolsVM.availableTools, id: \.self) { tool in
                ToolButtonView(tool: tool, toolsVM: toolsVM)
            }
            
            Spacer()
            
            // Undo button
            Button(action: { canvasVM.undo() }) {
                Image(systemName: "arrow.uturn.backward")
                    .font(.title3)
                    .foregroundColor(canvasVM.canUndo ? .primary : .gray.opacity(0.4))
            }
            .disabled(!canvasVM.canUndo)
            
            // Add colors to palette
            Button(action: { showColorAdder = true }) {
                Image(systemName: "paintpalette")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
            
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
