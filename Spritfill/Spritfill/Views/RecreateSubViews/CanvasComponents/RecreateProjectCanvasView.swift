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
    @State private var panStartLocation: CGPoint = .zero

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
                    zoomScale: zoomScale,
                    sessionID: viewModel.sessionID
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
                    doubleTapAction: {
                        if SettingsService.shared.doubleTapToUndo {
                            viewModel.undo()
                        }
                    },
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
                    },
                    onSingleTouchBegan: { location, isPencil in
                        if isPencil {
                            viewModel.registerPencilTouch()
                        }
                        
                        let tool = viewModel.selectedTool
                        let pencilOnly = SettingsService.shared.applePencilOnly
                        let fingerOnDrawTool = (pencilOnly || viewModel.applePencilDetected) && !isPencil && RecreateCanvasViewModel.isDrawingTool(tool)
                        
                        if fingerOnDrawTool || tool == .pan {
                            panStartLocation = location
                        } else {
                            viewModel.beginAction()
                            if let index = viewModel.gridIndex(from: location,
                                                                geoSize: geo.size,
                                                                canvasOffset: canvasOffset) {
                                dragVisitedIndices.insert(index)
                                viewModel.applyToolAtIndex(index)
                            }
                        }
                    },
                    onSingleTouchMoved: { location, isPencil in
                        let tool = viewModel.selectedTool
                        let pencilOnly = SettingsService.shared.applePencilOnly
                        let fingerOnDrawTool = (pencilOnly || viewModel.applePencilDetected) && !isPencil && RecreateCanvasViewModel.isDrawingTool(tool)
                        
                        if fingerOnDrawTool || tool == .pan {
                            let dx = location.x - panStartLocation.x
                            let dy = location.y - panStartLocation.y
                            let proposed = CGSize(
                                width: dragStart.width + dx,
                                height: dragStart.height + dy
                            )
                            canvasOffset = viewModel.clampedOffset(
                                for: proposed,
                                geoSize: geo.size,
                                canvasSize: scaledCanvasSize
                            )
                        } else {
                            if let index = viewModel.gridIndex(from: location,
                                                                geoSize: geo.size,
                                                                canvasOffset: canvasOffset) {
                                if !dragVisitedIndices.contains(index) {
                                    dragVisitedIndices.insert(index)
                                    viewModel.applyToolAtIndex(index)
                                }
                            }
                        }
                    },
                    onSingleTouchEnded: { location, isPencil in
                        if isPencil {
                            viewModel.registerPencilTouch()
                        }
                        
                        let tool = viewModel.selectedTool
                        let pencilOnly = SettingsService.shared.applePencilOnly
                        let fingerOnDrawTool = (pencilOnly || viewModel.applePencilDetected) && !isPencil && RecreateCanvasViewModel.isDrawingTool(tool)
                        
                        if fingerOnDrawTool || tool == .pan {
                            dragStart = canvasOffset
                        } else {
                            if dragVisitedIndices.isEmpty {
                                viewModel.beginAction()
                                if let index = viewModel.gridIndex(from: location,
                                                                    geoSize: geo.size,
                                                                    canvasOffset: canvasOffset) {
                                    viewModel.applyToolAtIndex(index)
                                }
                            }
                            viewModel.endAction()
                            dragVisitedIndices.removeAll()
                            viewModel.debouncedSave()
                        }
                    }
                )
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
    let sessionID: UUID  // Tracks which session we're rendering
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.sessionID == rhs.sessionID &&
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
            let showGrid = cellSize > 8 && SettingsService.shared.gridLines
            
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
                        var resolvedWrongWhite: [Int: GraphicsContext.ResolvedText] = [:]
                        var resolvedWrongBlack: [Int: GraphicsContext.ResolvedText] = [:]
                        
                        for (_, number) in colorNumberMap {
                            let text = Text("\(number)")
                                .font(.system(size: fontSize, weight: .bold, design: .rounded))
                                .foregroundColor(.gray.opacity(0.7))
                            resolvedLabels[number] = context.resolve(text)
                            
                            let whiteText = Text("\(number)")
                                .font(.system(size: fontSize, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            resolvedWrongWhite[number] = context.resolve(whiteText)
                            
                            let blackText = Text("\(number)")
                                .font(.system(size: fontSize, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                            resolvedWrongBlack[number] = context.resolve(blackText)
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
                                        // Wrong color — show target number with contrasting text
                                        if let number = colorNumberMap[targetHex.lowercased()] {
                                            let rgb = hexToRGB(userHex)
                                            // Relative luminance: bright bg → black text, dark bg → white text
                                            let lum = 0.299 * Double(rgb.r) + 0.587 * Double(rgb.g) + 0.114 * Double(rgb.b)
                                            let resolved = lum > 150
                                                ? resolvedWrongBlack[number]
                                                : resolvedWrongWhite[number]
                                            if let resolved {
                                                let pt = CGPoint(x: (CGFloat(col) + 0.5) * cellSize,
                                                                 y: (CGFloat(row) + 0.5) * cellSize)
                                                context.draw(resolved, at: pt)
                                            }
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
    
    // Renders solid white background + user pixels + reference ghost into a bitmap.
    // For small canvases (< 512px), the bitmap is upscaled by repeating each pixel
    // so the GPU doesn't need extreme nearest-neighbor upscaling on real hardware.
    // Uses a plain white background (not checkerboard) so reference ghost colors
    // blend uniformly and don't show brightness differences per cell.
    private func renderBitmap() -> UIImage? {
        let w = gridWidth
        let h = gridHeight
        guard w > 0, h > 0 else { return nil }
        
        // Determine upscale factor so the bitmap is at least 512px on its longest side.
        let minBitmapSize = 512
        let maxDim = max(w, h)
        let scale = maxDim < minBitmapSize ? (minBitmapSize / maxDim) : 1
        let bw = w * scale
        let bh = h * scale
        
        // Solid white background
        let bgR: UInt8 = 255, bgG: UInt8 = 255, bgB: UInt8 = 255
        
        var buffer = [UInt8](repeating: 255, count: bw * bh * 4)
        let pixelCount = userPixelHexes.count
        
        for row in 0..<h {
            for col in 0..<w {
                let i = row * w + col
                
                let userHex = i < pixelCount ? userPixelHexes[i] : "clear"
                let refRGB = referenceRGB[i]
                
                let r: UInt8, g: UInt8, b: UInt8
                if userHex != "clear" {
                    // User-painted pixel
                    let rgb = hexToRGB(userHex)
                    r = rgb.r; g = rgb.g; b = rgb.b
                } else if let ref = refRGB {
                    // Unpainted reference cell — blend reference color at 15% over white
                    r = UInt8(Double(ref.r) * 0.15 + Double(bgR) * 0.85)
                    g = UInt8(Double(ref.g) * 0.15 + Double(bgG) * 0.85)
                    b = UInt8(Double(ref.b) * 0.15 + Double(bgB) * 0.85)
                } else {
                    // Empty cell — white
                    r = bgR; g = bgG; b = bgB
                }
                
                // Fill a scale×scale block in the output buffer
                for dy in 0..<scale {
                    for dx in 0..<scale {
                        let bx = col * scale + dx
                        let by = row * scale + dy
                        let bi = (by * bw + bx) * 4
                        buffer[bi]     = r
                        buffer[bi + 1] = g
                        buffer[bi + 2] = b
                        buffer[bi + 3] = 255
                    }
                }
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(
            data: &buffer,
            width: bw,
            height: bh,
            bitsPerComponent: 8,
            bytesPerRow: bw * 4,
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
