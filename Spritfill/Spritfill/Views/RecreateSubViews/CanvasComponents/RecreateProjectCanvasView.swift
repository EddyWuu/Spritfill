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
                RecreateCanvasRenderer(
                    userPixels: viewModel.userPixels,
                    userPixelHexes: viewModel.userPixelHexes,
                    referenceGrid: viewModel.referenceGrid,
                    referenceColors: viewModel.referenceColors,
                    colorNumberMap: viewModel.colorNumberMap,
                    pixelGeneration: viewModel.pixelGeneration,
                    gridWidth: gridWidth,
                    gridHeight: gridHeight,
                    zoomScale: zoomScale
                )
                .equatable()
                .frame(width: scaledCanvasSize.width, height: scaledCanvasSize.height)
                .drawingGroup()
                .offset(x: canvasOffset.width, y: canvasOffset.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
            .contentShape(Rectangle())
            .overlay(
                TwoFingerDoubleTapView(
                    doubleTapAction: { viewModel.undo() },
                    onPan: { delta in
                        let proposed = CGSize(
                            width: canvasOffset.width + delta.width,
                            height: canvasOffset.height + delta.height
                        )
                        canvasOffset = viewModel.clampedOffset(
                            for: proposed,
                            geoSize: geo.size,
                            canvasSize: scaledCanvasSize
                        )
                    },
                    onPanEnd: {
                        dragStart = canvasOffset
                    }
                )
            )
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
                            // Auto-save after each paint/erase action (debounced)
                            viewModel.debouncedSave()
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

// MARK: - Isolated recreate canvas renderer

/// Only re-renders when pixelGeneration or zoomScale changes.
/// Panning (canvasOffset) does NOT trigger a re-draw because offset is applied outside.
private struct RecreateCanvasRenderer: View, Equatable {
    let userPixels: [Color]
    let userPixelHexes: [String]
    let referenceGrid: [String]
    let referenceColors: [Color]
    let colorNumberMap: [String: Int]
    let pixelGeneration: UInt
    let gridWidth: Int
    let gridHeight: Int
    let zoomScale: CGFloat
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.pixelGeneration == rhs.pixelGeneration &&
        lhs.gridWidth == rhs.gridWidth &&
        lhs.gridHeight == rhs.gridHeight &&
        lhs.zoomScale == rhs.zoomScale
    }
    
    var body: some View {
        Canvas { context, size in
            let cellSize = zoomScale
            let showGrid = cellSize > 8
            
            // Pre-resolve all unique number labels ONCE (not per-pixel)
            let fontSize = max(cellSize * 0.4, 6)
            var resolvedLabels: [Int: GraphicsContext.ResolvedText] = [:]
            
            if cellSize >= 4 {
                for (_, number) in colorNumberMap {
                    let text = Text("\(number)")
                        .font(.system(size: fontSize, weight: .bold, design: .rounded))
                        .foregroundColor(.gray.opacity(0.7))
                    resolvedLabels[number] = context.resolve(text)
                }
            }
            
            var resolvedWrongLabels: [Int: GraphicsContext.ResolvedText] = [:]
            if cellSize >= 4 {
                for (_, number) in colorNumberMap {
                    let text = Text("\(number)")
                        .font(.system(size: fontSize, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    resolvedWrongLabels[number] = context.resolve(text)
                }
            }
            
            let lightBg = Color.gray.opacity(0.1)
            let darkBg = Color.gray.opacity(0.2)
            let pixelCount = userPixelHexes.count
            
            for row in 0..<gridHeight {
                for col in 0..<gridWidth {
                    let index = row * gridWidth + col
                    let rect = CGRect(
                        x: CGFloat(col) * cellSize,
                        y: CGFloat(row) * cellSize,
                        width: cellSize,
                        height: cellSize
                    )
                    
                    let targetHex = referenceGrid[index]
                    let userHex = index < pixelCount ? userPixelHexes[index] : "clear"
                    
                    // Checkerboard background
                    let bg = (row + col) % 2 == 0 ? lightBg : darkBg
                    context.fill(Path(rect), with: .color(bg))
                    
                    if userHex != "clear" {
                        let userColor = index < userPixels.count ? userPixels[index] : Color.clear
                        context.fill(Path(rect), with: .color(userColor))
                        
                        if targetHex == "clear" {
                            let inset = cellSize * 0.2
                            var xPath = Path()
                            xPath.move(to: CGPoint(x: rect.minX + inset, y: rect.minY + inset))
                            xPath.addLine(to: CGPoint(x: rect.maxX - inset, y: rect.maxY - inset))
                            xPath.move(to: CGPoint(x: rect.maxX - inset, y: rect.minY + inset))
                            xPath.addLine(to: CGPoint(x: rect.minX + inset, y: rect.maxY - inset))
                            context.stroke(xPath, with: .color(.red.opacity(0.4)),
                                           lineWidth: max(cellSize * 0.08, 1))
                        } else if userHex.lowercased() != targetHex.lowercased() {
                            if let number = colorNumberMap[targetHex.lowercased()],
                               let resolved = resolvedWrongLabels[number] {
                                context.draw(resolved, at: CGPoint(x: rect.midX, y: rect.midY))
                            }
                        }
                    } else if targetHex != "clear" {
                        // Use pre-cached reference color instead of Color(hex:)
                        context.fill(Path(rect), with: .color(referenceColors[index].opacity(0.15)))
                        
                        if let number = colorNumberMap[targetHex.lowercased()],
                           let resolved = resolvedLabels[number] {
                            context.draw(resolved, at: CGPoint(x: rect.midX, y: rect.midY))
                        }
                    }
                }
            }
            
            // Draw grid lines
            if showGrid {
                var gridPath = Path()
                let totalWidth = CGFloat(gridWidth) * cellSize
                let totalHeight = CGFloat(gridHeight) * cellSize
                for row in 0...gridHeight {
                    let y = CGFloat(row) * cellSize
                    gridPath.move(to: CGPoint(x: 0, y: y))
                    gridPath.addLine(to: CGPoint(x: totalWidth, y: y))
                }
                for col in 0...gridWidth {
                    let x = CGFloat(col) * cellSize
                    gridPath.move(to: CGPoint(x: x, y: 0))
                    gridPath.addLine(to: CGPoint(x: x, y: totalHeight))
                }
                context.stroke(gridPath, with: .color(Color.gray.opacity(0.15)), lineWidth: 0.5)
            }
        }
    }
}
