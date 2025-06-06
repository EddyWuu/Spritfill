//
//  ProjectCanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-31.
//

import SwiftUI

struct ProjectCanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel

    @State private var currentScale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0

    @State private var canvasOffset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero

    @State private var zoomAnchor: UnitPoint = .center
    @State private var hasAutoZoomed = false

    var body: some View {
        GeometryReader { geo in
            let tileSize = CGFloat(viewModel.projectSettings.selectedTileSize.size)
            let gridWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
            let gridHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height

            let baseWidth = CGFloat(gridWidth) * tileSize
            let baseHeight = CGFloat(gridHeight) * tileSize
            let zoomScale = currentScale * gestureScale
            let totalOffset = CGSize(
                width: canvasOffset.width + dragOffset.width,
                height: canvasOffset.height + dragOffset.height
            )

            ZStack {
                Color.white.ignoresSafeArea()

                LazyVStack(spacing: 0) {
                    ForEach(0..<gridHeight, id: \.self) { row in
                        LazyHStack(spacing: 0) {
                            ForEach(0..<gridWidth, id: \.self) { col in
                                let index = row * gridWidth + col
                                Rectangle()
                                    .fill(viewModel.pixels[index])
                                    .frame(width: tileSize, height: tileSize)
                                    .border(Color.gray.opacity(0.2), width: 0.5)
                            }
                        }
                    }
                }
                .frame(width: baseWidth, height: baseHeight)
                .scaleEffect(zoomScale, anchor: zoomAnchor)
                .offset(totalOffset)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .updating($gestureScale) { value, state, _ in
                                state = value
                            }
                            .onEnded { value in
                                currentScale = (currentScale * value).clamped(to: 1.0...5.0)
                            },
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation
                            }
                            .onEnded { value in
                                canvasOffset.width += value.translation.width
                                canvasOffset.height += value.translation.height
                            }
                    )
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            zoomAnchor = UnitPoint(
                                x: value.location.x / geo.size.width,
                                y: value.location.y / geo.size.height
                            )
                        }
                )
                .onAppear {
                    guard !hasAutoZoomed else { return }
                    hasAutoZoomed = true

                    let horizontalRatio = geo.size.width / baseWidth
                    let verticalRatio = geo.size.height / baseHeight
                    let initialZoom = min(horizontalRatio, verticalRatio, 2.0)

                    if initialZoom > 1.0 {
                        currentScale = initialZoom
                    }
                }
            }
        }
    }
}

// MARK: - Clamp Helper
private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
