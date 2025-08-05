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
        HStack(alignment: .center, spacing: 20) {

            VStack {
                Text("Zoom")
                    .font(.caption)
                    .padding(.bottom, 2)
                
                if let canvasVM = toolsVM.canvasVM {
                    
                    let minZoom = canvasVM.minimumZoomScale
                    let maxZoom = canvasVM.maximumZoomScale
                    
                    Slider(
                        value: Binding(
                            get: { canvasVM.zoomScale },
                            set: { newValue in
                                canvasVM.zoomScale = newValue.clamped(to: minZoom...maxZoom)
                            }
                        ),
                        in: minZoom...maxZoom,
                        step: minZoom < 0.5 ? 0.05 : 0.1  // finer steps for small zooms
                    )
                    .frame(width: 200)
                    .rotationEffect(.degrees(-90))
                    .scaleEffect(x: 0.5, y: 0.5)
                    .frame(height: 100)
                }
            }
            .frame(width: 50)
            .padding(.leading)

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
