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
                VStack {
                    Canvas { context, size in
                        
                        let tileSize = CGFloat(viewModel.projectSettings.selectedTileSize.size) * zoomScale
                        let canvasWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
                        let canvasHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height
                        
                        for row in 0..<canvasHeight {
                            for col in 0..<canvasWidth {
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
                        width: CGFloat(viewModel.projectSettings.selectedCanvasSize.dimensions.width) * CGFloat(viewModel.projectSettings.selectedTileSize.size) * zoomScale,
                        height: CGFloat(viewModel.projectSettings.selectedCanvasSize.dimensions.height) * CGFloat(viewModel.projectSettings.selectedTileSize.size) * zoomScale
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0).onChanged { value in
                            let tileSize = CGFloat(viewModel.projectSettings.selectedTileSize.size) * zoomScale
                            let col = Int(value.location.x / tileSize)
                            let row = Int(value.location.y / tileSize)
                            
                            viewModel.updatePixel(row: row, col: col)
                        }
                    )
                }
                .padding()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
        }
    }
}
