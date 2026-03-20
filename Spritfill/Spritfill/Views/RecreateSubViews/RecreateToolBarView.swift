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
            ForEach(RecreateCanvasViewModel.RecreateTool.allCases.filter { $0 != .pan }, id: \.self) { tool in
                RecreateToolButtonView(tool: tool, viewModel: viewModel)
            }
            
            Spacer()
            
            // Redo button
            Button(action: { viewModel.redo() }) {
                Image(systemName: "arrow.uturn.forward")
                    .font(.title3)
                    .foregroundColor(viewModel.canRedo ? .primary : .gray.opacity(0.4))
            }
            .disabled(!viewModel.canRedo)
            
            // Undo button
            Button(action: { viewModel.undo() }) {
                Image(systemName: "arrow.uturn.backward")
                    .font(.title3)
                    .foregroundColor(viewModel.canUndo ? .primary : .gray.opacity(0.4))
            }
            .disabled(!viewModel.canUndo)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 24)
            
            // Pan / move screen button
            RecreateToolButtonView(tool: .pan, viewModel: viewModel)
            
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
