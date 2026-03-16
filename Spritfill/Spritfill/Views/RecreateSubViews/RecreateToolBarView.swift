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
                RecreateToolButtonView(tool: tool, viewModel: viewModel)
            }
            
            Spacer()
            
            // Undo button
            Button(action: { viewModel.undo() }) {
                Image(systemName: "arrow.uturn.backward")
                    .font(.title3)
                    .foregroundColor(viewModel.canUndo ? .primary : .gray.opacity(0.4))
            }
            .disabled(!viewModel.canUndo)
            
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
