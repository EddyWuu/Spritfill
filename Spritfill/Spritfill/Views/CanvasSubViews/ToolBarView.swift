//
//  ToolBarView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-06.
//

import SwiftUI

struct ToolsBarView: View {
    
    @ObservedObject var toolsVM: ToolsViewModel
    @State private var showPalettePicker = false

    var body: some View {
        HStack(spacing: 20) {
            
            Spacer()
            
            ToolButton(tool: .pencil, toolsVM: toolsVM)
            ToolButton(tool: .eraser, toolsVM: toolsVM)
            ToolButton(tool: .fill, toolsVM: toolsVM)

            Button(action: {
                showPalettePicker = true
            }) {
                Image(systemName: "paintpalette")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(toolsVM.selectedColor)
            }
            .sheet(isPresented: $showPalettePicker) {
                PaletteSelectionView(toolsVM: toolsVM)
            }


                
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func ToolButton(tool: ToolsViewModel.ToolType, toolsVM: ToolsViewModel) -> some View {
        Button(action: {
            toolsVM.selectTool(tool)
        }) {
            Image(systemName: icon(for: tool))
                .foregroundColor(toolsVM.selectedTool == tool ? .blue : .primary)
                .padding()
                .background(toolsVM.selectedTool == tool ? Color.blue.opacity(0.2) : Color.clear)
                .clipShape(Circle())
        }
    }

    private func icon(for tool: ToolsViewModel.ToolType) -> String {
        switch tool {
        case .pencil: return "pencil"
        case .eraser: return "eraser"
        case .fill: return "paintbrush"
        }
    }
}
