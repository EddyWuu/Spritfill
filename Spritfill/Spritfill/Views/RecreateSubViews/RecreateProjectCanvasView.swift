//
//  RecreateProjectCanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-13.
//

import SwiftUI

struct RecreateProjectCanvasView: View {
    @ObservedObject var viewModel: RecreateCanvasViewModel

    @State private var canvasOffset: CGSize = .zero
    @State private var dragStart: CGSize = .zero
    @State private var dragVisitedIndices: Set<Int> = []

    var body: some View {
        GeometryReader { geo in
            let gridWidth = viewModel.gridWidth
            let gridHeight = viewModel.gridHeight
            let zoomScale = viewModel.zoomScale
            let scaledCanvasSize = CGSize(width: CGFloat(gridWidth) * zoomScale,
                                          height: CGFloat(gridHeight) * zoomScale)

            ZStack {
                Canvas { context, size in
                    let cellSize = zoomScale
                    for row in 0..<gridHeight {
                        for col in 0..<gridWidth {
                            let index = row * gridWidth + col
                            let rect = CGRect(
                                x: CGFloat(col) * cellSize,
                                y: CGFloat(row) * cellSize,
                                width: cellSize,
                                height: cellSize
                            )

                            let targetHex = viewModel.referenceGrid[index]
                            let userColor = index < viewModel.userPixels.count ? viewModel.userPixels[index] : Color.clear
                            let userHex = index < viewModel.userPixelHexes.count ? viewModel.userPixelHexes[index] : "clear"

                            // Checkerboard background
                            let isLight = (row + col) % 2 == 0
                            let bg = isLight ? Color.gray.opacity(0.1) : Color.gray.opacity(0.2)
                            context.fill(Path(rect), with: .color(bg))

                            if userHex != "clear" {
                                // User has painted this cell
                                context.fill(Path(rect), with: .color(userColor))
                                
                                if targetHex == "clear" {
                                    // Wrong placement — painted on a cell that should be empty
                                    let inset = cellSize * 0.2
                                    let x1 = rect.minX + inset
                                    let y1 = rect.minY + inset
                                    let x2 = rect.maxX - inset
                                    let y2 = rect.maxY - inset
                                    var xPath = Path()
                                    xPath.move(to: CGPoint(x: x1, y: y1))
                                    xPath.addLine(to: CGPoint(x: x2, y: y2))
                                    xPath.move(to: CGPoint(x: x2, y: y1))
                                    xPath.addLine(to: CGPoint(x: x1, y: y2))
                                    context.stroke(xPath, with: .color(.red.opacity(0.4)),
                                                   lineWidth: max(cellSize * 0.08, 1))
                                } else if userHex.lowercased() != targetHex.lowercased() {
                                    // Wrong color — show the target number
                                    if let number = viewModel.colorNumberMap[targetHex.lowercased()] {
                                        let fontSize = max(cellSize * 0.4, 6)
                                        let text = Text("\(number)")
                                            .font(.system(size: fontSize, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                        let resolved = context.resolve(text)
                                        context.draw(resolved, at: CGPoint(x: rect.midX, y: rect.midY))
                                    }
                                }
                            } else if targetHex != "clear" {
                                // Show reference at lighter opacity
                                context.fill(Path(rect), with: .color(Color(hex: targetHex).opacity(0.15)))

                                // Draw the number
                                if let number = viewModel.colorNumberMap[targetHex.lowercased()] {
                                    let fontSize = max(cellSize * 0.4, 6)
                                    let text = Text("\(number)")
                                        .font(.system(size: fontSize, weight: .bold, design: .rounded))
                                        .foregroundColor(.gray.opacity(0.7))

                                    let resolved = context.resolve(text)
                                    context.draw(resolved, at: CGPoint(x: rect.midX, y: rect.midY))
                                }
                            }

                            // Grid lines when zoomed in enough
                            if cellSize > 8 {
                                let borderRect = rect.insetBy(dx: 0.5, dy: 0.5)
                                context.stroke(Path(borderRect), with: .color(Color.gray.opacity(0.15)), lineWidth: 0.5)
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
                        if viewModel.selectedTool == .pan {
                            let proposed = CGSize(
                                width: dragStart.width + value.translation.width,
                                height: dragStart.height + value.translation.height
                            )
                            canvasOffset = viewModel.clampedOffset(
                                for: proposed,
                                geoSize: geo.size,
                                canvasSize: scaledCanvasSize
                            )
                        } else {
                            // Draw on drag for paint/eraser
                            viewModel.beginAction()
                            if let index = viewModel.gridIndex(from: value.location,
                                                                geoSize: geo.size,
                                                                canvasOffset: canvasOffset) {
                                if !dragVisitedIndices.contains(index) {
                                    dragVisitedIndices.insert(index)
                                    viewModel.applyToolAtIndex(index)
                                }
                            }
                        }
                    }
                    .onEnded { value in
                        if viewModel.selectedTool == .pan {
                            dragStart = canvasOffset
                        } else {
                            if dragVisitedIndices.isEmpty {
                                viewModel.beginAction()
                                if let index = viewModel.gridIndex(from: value.location,
                                                                    geoSize: geo.size,
                                                                    canvasOffset: canvasOffset) {
                                    viewModel.applyToolAtIndex(index)
                                }
                            }
                            viewModel.endAction()
                            dragVisitedIndices.removeAll()
                            // Auto-save after each paint/erase action
                            viewModel.saveProgress()
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
