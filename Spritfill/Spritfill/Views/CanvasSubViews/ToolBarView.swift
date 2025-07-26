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
        HStack {
            
            VStack {
                Text("Zoom")
                    .font(.caption)

                if let canvasVM = toolsVM.canvasVM {
                    Slider(
                        value: Binding(
                            get: { canvasVM.zoomScale },
                            set: { canvasVM.zoomScale = $0 }
                        ),
                        in: 0.8...5.0,
                        step: 0.1
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(height: 120)
                }
            }
            .padding(.leading)
            
            Spacer()

            HStack(spacing: 20) {
                ForEach(toolsVM.availableTools, id: \.self) { tool in
                    ToolButtonView(tool: tool, toolsVM: toolsVM)
                }

                PaletteButtonView(toolsVM: toolsVM)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

