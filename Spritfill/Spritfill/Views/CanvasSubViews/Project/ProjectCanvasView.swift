//
//  ProjectCanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-31.
//

import SwiftUI

struct ProjectCanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @ObservedObject var toolsVM: ToolsViewModel

    // All offsets are in screen-space (points on screen)
    @State private var canvasOffset: CGSize = .zero
    @State private var dragStart: CGSize = .zero
    @State private var dragVisitedIndices: Set<Int> = []
    
    // Eyedropper magnifier state
    @State private var magnifierPosition: CGPoint = .zero
    @State private var showMagnifier: Bool = false
    @State private var magnifierColor: Color? = nil
    @State private var magnifierIndex: Int? = nil

    var body: some View {
        
        GeometryReader { geo in
            let gridWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
            let gridHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height

            let zoomScale = viewModel.zoomScale
            // Render at the full scaled size — no scaleEffect needed
            let scaledCanvasSize = CGSize(width: CGFloat(gridWidth) * zoomScale,
                                          height: CGFloat(gridHeight) * zoomScale)

            // Read symmetry state outside Canvas so SwiftUI tracks changes
            let hSymmetry = toolsVM.horizontalSymmetry
            let vSymmetry = toolsVM.verticalSymmetry

            ZStack {
                PixelCanvasRenderer(
                    pixels: viewModel.pixels,
                    pixelGeneration: viewModel.pixelGeneration,
                    gridWidth: gridWidth,
                    gridHeight: gridHeight,
                    zoomScale: zoomScale,
                    hSymmetry: hSymmetry,
                    vSymmetry: vSymmetry
                )
                .equatable()
                .frame(width: scaledCanvasSize.width, height: scaledCanvasSize.height)
                .drawingGroup()
                .offset(x: canvasOffset.width, y: canvasOffset.height)
                
                // Eyedropper magnifier overlay
                if showMagnifier {
                    magnifierView
                        .position(x: magnifierPosition.x, y: magnifierPosition.y - 80)
                }
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
                        let tool = toolsVM.selectedTool
                        if tool == .eyedropper {
                            // Show magnifier and track color under finger
                            magnifierPosition = value.location
                            if let index = viewModel.gridIndex(from: value.location,
                                                                geoSize: geo.size,
                                                                canvasOffset: canvasOffset,
                                                                zoomScale: zoomScale) {
                                magnifierIndex = index
                                magnifierColor = viewModel.colorAtIndex(index)
                            } else {
                                magnifierIndex = nil
                                magnifierColor = nil
                            }
                            showMagnifier = true
                        } else if tool == .pan {
                            let proposed = CGSize(
                                width: dragStart.width + value.translation.width,
                                height: dragStart.height + value.translation.height
                            )
                            canvasOffset = viewModel.clampedOffset(
                                for: proposed,
                                geoSize: geo.size,
                                canvasSize: scaledCanvasSize
                            )
                        } else if tool != .shift && tool != .flip {
                            // Draw on drag for pencil/eraser/fill
                            viewModel.beginAction()
                            if let index = viewModel.gridIndex(from: value.location,
                                                                geoSize: geo.size,
                                                                canvasOffset: canvasOffset,
                                                                zoomScale: zoomScale) {
                                if !dragVisitedIndices.contains(index) {
                                    dragVisitedIndices.insert(index)
                                    viewModel.applyToolAtIndex(index)
                                }
                            }
                        }
                    }
                    .onEnded { value in
                        let tool = toolsVM.selectedTool
                        if tool == .eyedropper {
                            // Pick the color under the finger
                            if let index = magnifierIndex ?? viewModel.gridIndex(from: value.location,
                                                                                   geoSize: geo.size,
                                                                                   canvasOffset: canvasOffset,
                                                                                   zoomScale: zoomScale) {
                                viewModel.eyedropperPickColor(at: index)
                            }
                            showMagnifier = false
                            magnifierColor = nil
                            magnifierIndex = nil
                        } else if tool == .pan {
                            dragStart = canvasOffset
                        } else if tool != .shift && tool != .flip {
                            if dragVisitedIndices.isEmpty {
                                viewModel.beginAction()
                                if let index = viewModel.gridIndex(from: value.location,
                                                                    geoSize: geo.size,
                                                                    canvasOffset: canvasOffset,
                                                                    zoomScale: zoomScale) {
                                    viewModel.applyToolAtIndex(index)
                                }
                            }
                            viewModel.endAction()
                            dragVisitedIndices.removeAll()
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
    
    // MARK: - Eyedropper magnifier
    
    private var magnifierView: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(magnifierColor ?? Color.gray.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                )
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.3), lineWidth: 1)
                        .padding(-1)
                )
                .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
            
            // Hex label
            if let color = magnifierColor, let hex = color.toHex() {
                Text(hex)
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(4)
            }
        }
        .allowsHitTesting(false)
    }
}

// Isolated canvas renderer — only re-renders when pixels, zoom, or symmetry change.
// Because it takes value types (not ObservedObject), changes to unrelated @Published
// properties like drawingOpacity do NOT cause a re-draw.
private struct PixelCanvasRenderer: View, Equatable {
    let pixels: [Color]
    let pixelGeneration: UInt
    let gridWidth: Int
    let gridHeight: Int
    let zoomScale: CGFloat
    let hSymmetry: Bool
    let vSymmetry: Bool

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.pixelGeneration == rhs.pixelGeneration &&
        lhs.gridWidth == rhs.gridWidth &&
        lhs.gridHeight == rhs.gridHeight &&
        lhs.zoomScale == rhs.zoomScale &&
        lhs.hSymmetry == rhs.hSymmetry &&
        lhs.vSymmetry == rhs.vSymmetry
    }

    var body: some View {
        Canvas { context, size in
            let cellSize = zoomScale
            for row in 0..<gridHeight {
                for col in 0..<gridWidth {
                    let color = pixels[row * gridWidth + col]
                    let rect = CGRect(
                        x: CGFloat(col) * cellSize,
                        y: CGFloat(row) * cellSize,
                        width: cellSize,
                        height: cellSize
                    )

                    let isLight = (row + col) % 2 == 0
                    let background = isLight ? Color.gray.opacity(0.15) : Color.gray.opacity(0.3)

                    context.fill(Path(rect), with: .color(background))
                    if color != .clear {
                        context.fill(Path(rect), with: .color(color))
                    }
                }
            }

            let canvasWidth = CGFloat(gridWidth) * cellSize
            let canvasHeight = CGFloat(gridHeight) * cellSize

            if vSymmetry {
                var hLine = Path()
                let midY = canvasHeight / 2
                hLine.move(to: CGPoint(x: 0, y: midY))
                hLine.addLine(to: CGPoint(x: canvasWidth, y: midY))
                context.stroke(hLine, with: .color(Color.orange.opacity(0.7)),
                               style: StrokeStyle(lineWidth: max(1, cellSize * 0.06), dash: [cellSize * 0.3, cellSize * 0.3]))
            }

            if hSymmetry {
                var vLine = Path()
                let midX = canvasWidth / 2
                vLine.move(to: CGPoint(x: midX, y: 0))
                vLine.addLine(to: CGPoint(x: midX, y: canvasHeight))
                context.stroke(vLine, with: .color(Color.orange.opacity(0.7)),
                               style: StrokeStyle(lineWidth: max(1, cellSize * 0.06), dash: [cellSize * 0.3, cellSize * 0.3]))
            }
        }
    }
}
