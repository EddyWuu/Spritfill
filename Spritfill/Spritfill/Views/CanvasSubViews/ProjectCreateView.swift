//
//  ProjectCreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

struct ProjectCreateView: View {
    
    @ObservedObject var viewModel: ProjectViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    
    @State private var zoomScale: CGFloat = 1.0  // track zoom level
    @State private var lastScale: CGFloat = 1.0  // track the last pinch scale
    
    var body: some View {
        
        VStack {
            
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Back")
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .padding(.top)
            
            Spacer()
            
            GeometryReader { geometry in
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    VStack {
                        Canvas { context, size in
                            
                            let tileSize = CGFloat(viewModel.projectSettings.selectedTileSize.size)
                            let canvasWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
                            let canvasHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height
                            
                            for row in 0..<canvasHeight {
                                for col in 0..<canvasWidth {
                                    
                                    let rect = CGRect(x: CGFloat(col) * tileSize, y: CGFloat(row) * tileSize, width: tileSize, height: tileSize)
                                    
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
                            width: CGFloat(viewModel.projectSettings.selectedCanvasSize.dimensions.width) * CGFloat(viewModel.projectSettings.selectedTileSize.size),
                            height: CGFloat(viewModel.projectSettings.selectedCanvasSize.dimensions.height) * CGFloat(viewModel.projectSettings.selectedTileSize.size)
                        )
                        .gesture(
                            DragGesture(minimumDistance: 0).onChanged { value in
                                let tileSize = CGFloat(viewModel.projectSettings.selectedTileSize.size)
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
            .gesture(
                MagnificationGesture()
                    .onChanged { scale in
                        let newScale = lastScale * scale
                        zoomScale = max(0.5, min(newScale, 5.0))  // limit zoom
                    }
                    .onEnded { _ in
                        lastScale = zoomScale
                    }
            )
            
            Text("Tile Size: \(CGFloat(viewModel.projectSettings.selectedTileSize.size))²")
        }
        .padding()
    }
}
