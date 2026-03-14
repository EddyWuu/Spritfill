//
//  RecreateToolButtonView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import SwiftUI

struct RecreateToolButtonView: View {
    
    let tool: RecreateCanvasViewModel.RecreateTool
    @ObservedObject var viewModel: RecreateCanvasViewModel

    var body: some View {
        
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
}
