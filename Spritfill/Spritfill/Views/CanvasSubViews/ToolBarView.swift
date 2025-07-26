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
        HStack(spacing: 20) {
            
            Spacer()

            ForEach(toolsVM.availableTools, id: \.self) { tool in
                ToolButtonView(tool: tool, toolsVM: toolsVM)
            }

            PaletteButtonView(toolsVM: toolsVM)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
