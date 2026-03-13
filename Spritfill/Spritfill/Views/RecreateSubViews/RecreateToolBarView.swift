//
//  RecreateToolBarView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-13.
//

import SwiftUI

struct RecreateToolBarView: View {
    @ObservedObject var viewModel: RecreateCanvasViewModel

    var body: some View {
        HStack(spacing: 16) {
            ForEach(RecreateCanvasViewModel.RecreateTool.allCases, id: \.self) { tool in
                Button(action: {
                    viewModel.selectTool(tool)
                }) {
                    Image(systemName: tool.iconName)
                        .foregroundColor(viewModel.isSelected(tool: tool) ? .blue : .primary)
                        .padding()
                        .background(viewModel.isSelected(tool: tool) ? Color.blue.opacity(0.2) : Color.clear)
                        .clipShape(Circle())
                }
            }
            
            Spacer()
            
            // Show currently selected color swatch
            Circle()
                .fill(viewModel.selectedColor)
                .frame(width: 28, height: 28)
                .overlay(Circle().stroke(Color.primary, lineWidth: 2))
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
