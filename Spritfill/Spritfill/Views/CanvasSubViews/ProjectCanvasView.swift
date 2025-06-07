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
    @GestureState private var gestureScale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geo in
            let tileSize = CGFloat(viewModel.projectSettings.selectedTileSize.size)
            let gridWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
            let gridHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height
            let canvasWidth = CGFloat(gridWidth) * tileSize
            let canvasHeight = CGFloat(gridHeight) * tileSize
            let zoomScale = scale * gestureScale

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
            .scaleEffect(zoomScale, anchor: .topLeading)
            .offset(canvasOffset)
            .gesture(
                SimultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            let proposed = CGSize(
                                width: dragStart.width + value.translation.width,
                                height: dragStart.height + value.translation.height
                            )

                            // Clamping offset to keep canvas inside screen
                            canvasOffset = clampedOffset(for: proposed, geoSize: geo.size, canvasSize: CGSize(width: canvasWidth * zoomScale, height: canvasHeight * zoomScale))
                        }
                        .onEnded { value in
                            dragStart = canvasOffset
                        },
                    MagnificationGesture()
                        .updating($gestureScale) { value, state, _ in
                            state = value
                        }
                        .onEnded { value in
                            scale = (scale * value).clamped(to: 1.0...5.0)
                        }
                )
            )
        }
    }

    // Clamp to screen bounds
    private func clampedOffset(for offset: CGSize, geoSize: CGSize, canvasSize: CGSize) -> CGSize {
        let maxX = max(0, (canvasSize.width - geoSize.width))
        let maxY = max(0, (canvasSize.height - geoSize.height))

        return CGSize(
            width: offset.width.clamped(to: -maxX...0),
            height: offset.height.clamped(to: -maxY...0)
        )
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
