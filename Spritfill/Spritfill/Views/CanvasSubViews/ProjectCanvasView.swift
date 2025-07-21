//
//  ProjectCanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-31.
//

import SwiftUI

struct ProjectCanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel

    @State private var canvasOffset: CGSize = .zero
    @State private var dragStart: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var gestureScale: CGFloat = 1.0

    var body: some View {
        
        GeometryReader { geo in
            let tileSize = CGFloat(viewModel.projectSettings.selectedTileSize.size)
            let gridWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
            let gridHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height
            let baseCanvasSize = CGSize(width: CGFloat(gridWidth) * tileSize,
                                        height: CGFloat(gridHeight) * tileSize)

            let zoomScale = scale * gestureScale
            let scaledCanvasSize = CGSize(width: baseCanvasSize.width * zoomScale,
                                          height: baseCanvasSize.height * zoomScale)

            ZStack {
                Canvas { context, size in
                    for row in 0..<gridHeight {
                        for col in 0..<gridWidth {
                            let color = viewModel.pixels[row * gridWidth + col]
                            let rect = CGRect(
                                x: CGFloat(col) * tileSize,
                                y: CGFloat(row) * tileSize,
                                width: tileSize,
                                height: tileSize
                            )

                            // checkerboard background color
                            let isLight = (row + col) % 2 == 0
                            let background = isLight ? Color.gray.opacity(0.15) : Color.gray.opacity(0.3)

                            context.fill(Path(rect), with: .color(background))
                            if color != .clear {
                                context.fill(Path(rect), with: .color(color))
                            }
                            
                            context.stroke(Path(rect), with: .color(.gray.opacity(0.2)), lineWidth: 0.5)
                        }
                    }
                }
                .frame(width: baseCanvasSize.width, height: baseCanvasSize.height)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
                .offset(
                    x: canvasOffset.width / zoomScale,
                    y: canvasOffset.height / zoomScale
                )
                .scaleEffect(zoomScale)
            }
            .contentShape(Rectangle())
            .gesture(
                SimultaneousGesture(
                    DragGesture()
                        .onChanged { value in
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
                        .onEnded { _ in
                            dragStart = canvasOffset
                        },
                    MagnificationGesture()
                        .onChanged { value in
                            gestureScale = value
                        }
                        .onEnded { value in
                            let newScale = (scale * value).clamped(to: 0.8...5.0)
                            let delta = newScale / scale

                            canvasOffset = CGSize(
                                width: canvasOffset.width * delta,
                                height: canvasOffset.height * delta
                            )

                            scale = newScale
                            gestureScale = 1.0
                        }
                )
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        let tapPoint = value.location

                        let canvasCenter = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)

                        let canvasOrigin = CGPoint(
                            x: canvasCenter.x + canvasOffset.width - scaledCanvasSize.width / 2,
                            y: canvasCenter.y + canvasOffset.height - scaledCanvasSize.height / 2
                        )

                        let local = CGPoint(
                          x: tapPoint.x - canvasOrigin.x,
                          y: tapPoint.y - canvasOrigin.y
                        )

                        viewModel.applyTool(at: local, zoomScale: zoomScale)
                    }
            )
        }
    }
}
