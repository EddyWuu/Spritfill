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
            let canvasWidth = CGFloat(gridWidth) * tileSize
            let canvasHeight = CGFloat(gridHeight) * tileSize
            let zoomScale = scale * gestureScale

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

                            context.fill(Path(rect), with: .color(color))
                            context.stroke(Path(rect), with: .color(.gray.opacity(0.2)), lineWidth: 0.5)
                        }
                    }
                }
                .frame(width: canvasWidth, height: canvasHeight)
                .scaleEffect(zoomScale)
                .offset(canvasOffset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                                canvasSize: CGSize(
                                    width: canvasWidth * scale,
                                    height: canvasHeight * scale
                                )
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

                            // adjust offset to keep zoom centered visually
                            canvasOffset = CGSize(
                                width: canvasOffset.width * delta,
                                height: canvasOffset.height * delta
                            )

                            scale = newScale
                            gestureScale = 1.0
                        }
                )
            )
        }
    }
}
