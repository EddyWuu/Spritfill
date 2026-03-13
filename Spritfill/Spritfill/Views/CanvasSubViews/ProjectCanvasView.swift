//
//  ProjectCanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-31.
//

import SwiftUI

struct ProjectCanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel

    // All offsets are in screen-space (points on screen)
    @State private var canvasOffset: CGSize = .zero
    @State private var dragStart: CGSize = .zero

    var body: some View {
        
        GeometryReader { geo in
            let gridWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
            let gridHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height

            let zoomScale = viewModel.zoomScale
            // Render at the full scaled size — no scaleEffect needed
            let scaledCanvasSize = CGSize(width: CGFloat(gridWidth) * zoomScale,
                                          height: CGFloat(gridHeight) * zoomScale)

            ZStack {
                Canvas { context, size in
                    let cellSize = zoomScale
                    for row in 0..<gridHeight {
                        for col in 0..<gridWidth {
                            let color = viewModel.pixels[row * gridWidth + col]
                            let rect = CGRect(
                                x: CGFloat(col) * cellSize,
                                y: CGFloat(row) * cellSize,
                                width: cellSize,
                                height: cellSize
                            )

                            // checkerboard background color
                            let isLight = (row + col) % 2 == 0
                            let background = isLight ? Color.gray.opacity(0.15) : Color.gray.opacity(0.3)

                            context.fill(Path(rect), with: .color(background))
                            if color != .clear {
                                context.fill(Path(rect), with: .color(color))
                            }
                        }
                    }
                }
                .frame(width: scaledCanvasSize.width, height: scaledCanvasSize.height)
                .offset(x: canvasOffset.width, y: canvasOffset.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        guard viewModel.toolsVM.selectedTool == .pan else { return }
                        
                        let proposed = CGSize(
                            width: dragStart.width + value.translation.width,
                            height: dragStart.height + value.translation.height
                        )

                        canvasOffset = viewModel.clampedOffset(
                            for: proposed,
                            geoSize: geo.size,
                            canvasSize: scaledCanvasSize
                        )
                    }
                    .onEnded { value in
                        if viewModel.toolsVM.selectedTool == .pan {
                            dragStart = canvasOffset
                        } else {
                            // Tap-to-draw: use the tap location
                            let tapPoint = value.location

                            let canvasCenter = CGPoint(
                                x: geo.size.width / 2 + canvasOffset.width,
                                y: geo.size.height / 2 + canvasOffset.height
                            )

                            let canvasOrigin = CGPoint(
                                x: canvasCenter.x - scaledCanvasSize.width / 2,
                                y: canvasCenter.y - scaledCanvasSize.height / 2
                            )

                            let basePoint = CGPoint(
                                x: (tapPoint.x - canvasOrigin.x) / zoomScale,
                                y: (tapPoint.y - canvasOrigin.y) / zoomScale
                            )

                            viewModel.applyTool(at: basePoint)
                        }
                    }
            )
            .onAppear {
                viewModel.updateViewSize(geo.size)
            }
            .onChange(of: geo.size) {
                viewModel.updateViewSize(geo.size)
            }
            .onChange(of: viewModel.zoomScale) { oldZoom, newZoom in
                // When zoom changes, scale the offset so the canvas center stays stable
                if oldZoom != 0 {
                    let ratio = newZoom / oldZoom
                    let scaled = CGSize(
                        width: canvasOffset.width * ratio,
                        height: canvasOffset.height * ratio
                    )
                    
                    let newScaledCanvasSize = CGSize(
                        width: CGFloat(gridWidth) * newZoom,
                        height: CGFloat(gridHeight) * newZoom
                    )
                    
                    canvasOffset = viewModel.clampedOffset(
                        for: scaled,
                        geoSize: geo.size,
                        canvasSize: newScaledCanvasSize
                    )
                    dragStart = canvasOffset
                }
            }
        }
    }
}
