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
                    userPixelHexes: viewModel.userPixelHexes,
                    referenceGrid: viewModel.referenceGrid,
                    referenceRGB: viewModel.referenceRGB,
                    colorNumberMap: viewModel.colorNumberMap,
                    pixelGeneration: viewModel.pixelGeneration,
                    gridWidth: gridWidth,
                    gridHeight: gridHeight,
                    zoomScale: zoomScale
                )
                .equatable()
                .frame(width: scaledCanvasSize.width, height: scaledCanvasSize.height)
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

// Two-layer renderer:
// Layer 1: CGImage bitmap — checkerboard + user pixels + reference ghost colors.
//          Eliminates ~32K SwiftUI Path fills per frame.
// Layer 2: SwiftUI Canvas overlay — text labels, grid lines, error X markers.
//          Only draws the lightweight vector/text elements.
private struct RecreateCanvasRenderer: View, Equatable {
    let userPixelHexes: [String]
    let referenceGrid: [String]
    let referenceRGB: [(r: UInt8, g: UInt8, b: UInt8)?]
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
        let bitmapImage = renderBitmap()
        
        ZStack {
            // Layer 1: Bitmap (checkerboard + pixels + reference ghost)
            if let bitmapImage {
                Image(uiImage: bitmapImage)
                    .interpolation(.none)
                    .resizable()
            }
            
            // Layer 2: Text labels, grid lines, error markers
            // Only rendered when zoomed in enough — at low zoom, text is illegible
            // and the per-pixel loop is pure waste.
            let cellSize = zoomScale
            let showNumbers = cellSize >= 18  // numbers unreadable below ~18pt
            let showGrid = cellSize > 8
            
            if showNumbers || showGrid {
                Canvas { context, size in
                    if showNumbers {
                        // Only render numbers for pixels visible in the current viewport.
                        // This avoids iterating all 16K+ pixels for large canvases.
                        let visMinCol = max(0, Int(floor(0 / cellSize)))
                        let visMaxCol = min(gridWidth - 1, Int(ceil(size.width / cellSize)))
                        let visMinRow = max(0, Int(floor(0 / cellSize)))
                        let visMaxRow = min(gridHeight - 1, Int(ceil(size.height / cellSize)))
                        
                        // Pre-resolve all unique number labels ONCE
                        let fontSize = max(cellSize * 0.4, 8)
                        var resolvedLabels: [Int: GraphicsContext.ResolvedText] = [:]
                        var resolvedWrongLabels: [Int: GraphicsContext.ResolvedText] = [:]
                        
                        for (_, number) in colorNumberMap {
                            let text = Text("\(number)")
                                .font(.system(size: fontSize, weight: .bold, design: .rounded))
                                .foregroundColor(.gray.opacity(0.7))
                            resolvedLabels[number] = context.resolve(text)
                            
                            let wrongText = Text("\(number)")
                                .font(.system(size: fontSize, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            resolvedWrongLabels[number] = context.resolve(wrongText)
                        }
                        
                        let pixelCount = userPixelHexes.count
                        
                        for row in visMinRow...visMaxRow {
                            for col in visMinCol...visMaxCol {
                                let index = row * gridWidth + col
                                let targetHex = referenceGrid[index]
                                let userHex = index < pixelCount ? userPixelHexes[index] : "clear"
                                
                                if userHex != "clear" {
                                    if targetHex == "clear" {
                                        // Wrong placement — X marker
                                        let rect = CGRect(
                                            x: CGFloat(col) * cellSize,
                                            y: CGFloat(row) * cellSize,
                                            width: cellSize,
                                            height: cellSize
                                        )
                                        let inset = cellSize * 0.2
                                        var xPath = Path()
                                        xPath.move(to: CGPoint(x: rect.minX + inset, y: rect.minY + inset))
                                        xPath.addLine(to: CGPoint(x: rect.maxX - inset, y: rect.maxY - inset))
                                        xPath.move(to: CGPoint(x: rect.maxX - inset, y: rect.minY + inset))
                                        xPath.addLine(to: CGPoint(x: rect.minX + inset, y: rect.maxY - inset))
                                        context.stroke(xPath, with: .color(.red.opacity(0.4)),
                                                       lineWidth: max(cellSize * 0.08, 1))
                                    } else if userHex.lowercased() != targetHex.lowercased() {
                                        // Wrong color — show target number in white
                                        if let number = colorNumberMap[targetHex.lowercased()],
                                           let resolved = resolvedWrongLabels[number] {
                                            let pt = CGPoint(x: (CGFloat(col) + 0.5) * cellSize,
                                                             y: (CGFloat(row) + 0.5) * cellSize)
                                            context.draw(resolved, at: pt)
                                        }
                                    }
                                } else if targetHex != "clear" {
                                    // Unpainted reference cell — show number label
                                    if let number = colorNumberMap[targetHex.lowercased()],
                                       let resolved = resolvedLabels[number] {
                                        let pt = CGPoint(x: (CGFloat(col) + 0.5) * cellSize,
                                                         y: (CGFloat(row) + 0.5) * cellSize)
                                        context.draw(resolved, at: pt)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Grid lines
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
    }
    
    // MARK: - Bitmap rendering
    
    // Renders checkerboard + user pixels + reference ghost into a 1:1 CGImage.
    // Pure byte-level operations — no UIColor, no SwiftUI Color, no Path fills.
    private func renderBitmap() -> UIImage? {
        let w = gridWidth
        let h = gridHeight
        guard w > 0, h > 0 else { return nil }
        
        // Checkerboard RGBA
        let lightR: UInt8 = 240, lightG: UInt8 = 240, lightB: UInt8 = 240
        let darkR:  UInt8 = 220, darkG:  UInt8 = 220, darkB:  UInt8 = 220
        
        var buffer = [UInt8](repeating: 255, count: w * h * 4)
        let pixelCount = userPixelHexes.count
        
        for i in 0..<(w * h) {
            let bi = i * 4
            let row = i / w
            let col = i % w
            let isLight = (row + col) % 2 == 0
            
            let userHex = i < pixelCount ? userPixelHexes[i] : "clear"
            let refRGB = referenceRGB[i]
            
            if userHex != "clear" {
                // User-painted pixel
                let rgb = hexToRGB(userHex)
                buffer[bi]     = rgb.r
                buffer[bi + 1] = rgb.g
                buffer[bi + 2] = rgb.b
            } else if let ref = refRGB {
                // Unpainted reference cell — blend reference color at 15% over checkerboard
                let bgR = isLight ? lightR : darkR
                let bgG = isLight ? lightG : darkG
                let bgB = isLight ? lightB : darkB
                // alpha blend: out = src * 0.15 + bg * 0.85
                buffer[bi]     = UInt8(Double(ref.r) * 0.15 + Double(bgR) * 0.85)
                buffer[bi + 1] = UInt8(Double(ref.g) * 0.15 + Double(bgG) * 0.85)
                buffer[bi + 2] = UInt8(Double(ref.b) * 0.15 + Double(bgB) * 0.85)
            } else {
                // Empty cell — checkerboard
                buffer[bi]     = isLight ? lightR : darkR
                buffer[bi + 1] = isLight ? lightG : darkG
                buffer[bi + 2] = isLight ? lightB : darkB
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
    
    @inline(__always)
    private func hexToRGB(_ hex: String) -> (r: UInt8, g: UInt8, b: UInt8) {
        let start = hex.hasPrefix("#") ? hex.utf8.index(after: hex.utf8.startIndex) : hex.utf8.startIndex
        let bytes = hex.utf8[start...]
        guard bytes.count >= 6 else { return (0, 0, 0) }
        var val: UInt32 = 0
        for byte in bytes.prefix(6) {
            val <<= 4
            switch byte {
            case 0x30...0x39: val |= UInt32(byte - 0x30)
            case 0x41...0x46: val |= UInt32(byte - 0x41 + 10)
            case 0x61...0x66: val |= UInt32(byte - 0x61 + 10)
            default: return (0, 0, 0)
            }
        }
        return (
            r: UInt8((val >> 16) & 0xFF),
            g: UInt8((val >> 8) & 0xFF),
            b: UInt8(val & 0xFF)
        )
    }
}
