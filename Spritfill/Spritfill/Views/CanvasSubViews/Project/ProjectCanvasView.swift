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
    
    // Eraser brush preview state
    @State private var eraserPreviewIndex: Int? = nil
    @State private var showEraserPreview: Bool = false

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
                    pixelHexes: viewModel.compositePixelHexes(),
                    pixelGeneration: viewModel.pixelGeneration,
                    gridWidth: gridWidth,
                    gridHeight: gridHeight,
                    zoomScale: zoomScale,
                    hSymmetry: hSymmetry,
                    vSymmetry: vSymmetry
                )
                .equatable()
                .frame(width: scaledCanvasSize.width, height: scaledCanvasSize.height)
                .offset(x: canvasOffset.width, y: canvasOffset.height)
                
                // Eyedropper magnifier overlay
                if showMagnifier {
                    magnifierView
                        .position(x: magnifierPosition.x, y: magnifierPosition.y - 80)
                }
                
                // Eraser brush area preview overlay
                if showEraserPreview, let idx = eraserPreviewIndex {
                    eraserPreviewOverlay(
                        index: idx,
                        gridWidth: gridWidth,
                        gridHeight: gridHeight,
                        zoomScale: zoomScale,
                        canvasOffset: canvasOffset,
                        geoSize: geo.size
                    )
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
                    },
                    onPinch: { scale in
                        let newZoom = (viewModel.zoomScale * scale)
                            .clamped(to: viewModel.minimumZoomScale...viewModel.maximumZoomScale)
                        viewModel.zoomScale = newZoom
                    },
                    onPinchEnd: {
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
                                // Show eraser brush preview
                                if tool == .eraser {
                                    eraserPreviewIndex = index
                                    showEraserPreview = true
                                }
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
                            showEraserPreview = false
                            eraserPreviewIndex = nil
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
    
    // MARK: - Eraser brush area preview
    
    private func eraserPreviewOverlay(
        index: Int,
        gridWidth: Int,
        gridHeight: Int,
        zoomScale: CGFloat,
        canvasOffset: CGSize,
        geoSize: CGSize
    ) -> some View {
        let brushSize = toolsVM.eraserBrushSize
        let row = index / gridWidth
        let col = index % gridWidth
        let half = brushSize / 2
        
        // Top-left grid coordinate of the brush area (clamped)
        let minRow = max(0, row - half)
        let minCol = max(0, col - half)
        let maxRow = min(gridHeight - 1, row + brushSize - 1 - half)
        let maxCol = min(gridWidth - 1, col + brushSize - 1 - half)
        
        // Canvas origin in screen space
        let scaledCanvasWidth = CGFloat(gridWidth) * zoomScale
        let scaledCanvasHeight = CGFloat(gridHeight) * zoomScale
        let canvasOriginX = geoSize.width / 2 + canvasOffset.width - scaledCanvasWidth / 2
        let canvasOriginY = geoSize.height / 2 + canvasOffset.height - scaledCanvasHeight / 2
        
        // Screen-space rect for the brush area
        let rectX = canvasOriginX + CGFloat(minCol) * zoomScale
        let rectY = canvasOriginY + CGFloat(minRow) * zoomScale
        let rectW = CGFloat(maxCol - minCol + 1) * zoomScale
        let rectH = CGFloat(maxRow - minRow + 1) * zoomScale
        
        return Rectangle()
            .fill(Color.red.opacity(0.15))
            .overlay(
                Rectangle()
                    .stroke(Color.red.opacity(0.6), lineWidth: max(1, zoomScale * 0.08))
            )
            .frame(width: rectW, height: rectH)
            .position(x: rectX + rectW / 2, y: rectY + rectH / 2)
            .allowsHitTesting(false)
    }
}

// Isolated canvas renderer — only re-renders when pixels, zoom, or symmetry change.
// Because it takes value types (not ObservedObject), changes to unrelated @Published
// properties like drawingOpacity do NOT cause a re-draw.
private struct PixelCanvasRenderer: View, Equatable {
    let pixelHexes: [String]
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
        let image = renderBitmap()

        ZStack {
            if let image {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
            }

            if hSymmetry || vSymmetry {
                Canvas { context, size in
                    let cellSize = zoomScale
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
    }

    // Render the pixel grid + checkerboard into a 1:1 bitmap.
    // Parses hex strings directly to RGB bytes — no UIColor/Color conversion needed.
    private func renderBitmap() -> UIImage? {
        let w = gridWidth
        let h = gridHeight
        guard w > 0, h > 0 else { return nil }

        let lightR: UInt8 = 230, lightG: UInt8 = 230, lightB: UInt8 = 230
        let darkR:  UInt8 = 204, darkG:  UInt8 = 204, darkB:  UInt8 = 204

        var buffer = [UInt8](repeating: 255, count: w * h * 4)

        for i in 0..<(w * h) {
            let bi = i * 4
            let hex = pixelHexes[i]

            if hex == "clear" {
                let row = i / w
                let col = i % w
                let isLight = (row + col) % 2 == 0
                buffer[bi]     = isLight ? lightR : darkR
                buffer[bi + 1] = isLight ? lightG : darkG
                buffer[bi + 2] = isLight ? lightB : darkB
            } else {
                // Parse "#RRGGBB" directly to bytes
                let rgb = hexToRGB(hex)
                buffer[bi]     = rgb.r
                buffer[bi + 1] = rgb.g
                buffer[bi + 2] = rgb.b
            }
            buffer[bi + 3] = 255
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(
            data: &buffer,
            width: w,
            height: h,
            bitsPerComponent: 8,
            bytesPerRow: w * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ), let cgImage = ctx.makeImage() else { return nil }

        return UIImage(cgImage: cgImage)
    }

    // Fast hex string to RGB bytes — pure integer math, no UIColor.
    @inline(__always)
    private func hexToRGB(_ hex: String) -> (r: UInt8, g: UInt8, b: UInt8) {
        var str = hex
        if str.hasPrefix("#") { str = String(str.dropFirst()) }
        guard str.count == 6 else { return (0, 0, 0) }
        var val: UInt64 = 0
        Scanner(string: str).scanHexInt64(&val)
        return (
            r: UInt8((val >> 16) & 0xFF),
            g: UInt8((val >> 8) & 0xFF),
            b: UInt8(val & 0xFF)
        )
    }
}
