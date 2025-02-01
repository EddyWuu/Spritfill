//
//  ProjectCanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-31.
//

import SwiftUI

struct ProjectCanvasView: View {
    
    @ObservedObject var viewModel: ProjectViewModel
    @Binding var zoomScale: CGFloat
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                Canvas { context, size in
                    
                    let tileSize = CGFloat(viewModel.projectSettings.selectedTileSize.size) * zoomScale
                    let canvasSize = viewModel.projectSettings.selectedCanvasSize.dimensions
                    
                    for row in 0..<canvasSize.height {
                        for col in 0..<canvasSize.width {
                            let rect = CGRect(
                                x: CGFloat(col) * tileSize,
                                y: CGFloat(row) * tileSize,
                                width: tileSize,
                                height: tileSize
                            )
                            
                            if row < viewModel.pixels.count && col < viewModel.pixels[row].count {
                                context.fill(Path(rect), with: .color(viewModel.pixels[row][col]))
                            } else {
                                context.fill(Path(rect), with: .color(.clear))
                            }

                            context.stroke(Path(rect), with: .color(.gray), lineWidth: 0.5)
                        }
                    }
                }
                .frame(
                     width: CGFloat(viewModel.pixels[0].count) * CGFloat(viewModel.projectSettings.selectedTileSize.size) * zoomScale,
                     height: CGFloat(viewModel.pixels.count) * CGFloat(viewModel.projectSettings.selectedTileSize.size) * zoomScale
                 )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            viewModel.updatePixelAt(location: value.location, zoomScale: zoomScale)
                        }
                        .onEnded { value in
                            viewModel.updatePixelAt(location: value.location, zoomScale: zoomScale)
                        }
                )
                .onTapGesture { location in
                    viewModel.updatePixelAt(location: location, zoomScale: zoomScale)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
        }
    }
}
