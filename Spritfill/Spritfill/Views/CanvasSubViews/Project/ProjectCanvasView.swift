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
    @ObservedObject private var settings = SettingsService.shared

    // All offsets are in screen-space (points on screen)
    @State private var canvasOffset: CGSize = .zero
    @State private var dragStart: CGSize = .zero
    @State private var dragVisitedIndices: Set<Int> = []
    @State private var panStartLocation: CGPoint = .zero
    
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
                    vSymmetry: vSymmetry,
                    backgroundTileSize: settings.backgroundTileSize,
                    showGridLines: settings.gridLines
                )
                .equatable()
                .frame(width: scaledCanvasSize.width, height: scaledCanvasSize.height)
                .offset(x: canvasOffset.width, y: canvasOffset.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
            .contentShape(Rectangle())
            .overlay {
                // Eyedropper magnifier overlay — in geo.size coordinate space
                if showMagnifier {
                    let magnifierOffset: CGFloat = 80
                    // Flip below finger if too close to top edge
                    let yPos = magnifierPosition.y < magnifierOffset + 40
                        ? magnifierPosition.y + magnifierOffset
                        : magnifierPosition.y - magnifierOffset
                    // Clamp horizontally so it doesn't go off-screen
                    let xPos = max(40, min(magnifierPosition.x, geo.size.width - 40))
                    
                    magnifierView
                        .position(x: xPos, y: yPos)
                }
            }
            .overlay {
                // Eraser brush area preview overlay — in geo.size coordinate space
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
            .overlay {
                // Pencil drawing highlight overlay — white border on touched pixel
                if let idx = viewModel.currentDrawingIndex {
                    pencilHighlightOverlay(
                        index: idx,
                        gridWidth: gridWidth,
                        gridHeight: gridHeight,
                        zoomScale: zoomScale,
                        canvasOffset: canvasOffset,
                        geoSize: geo.size
                    )
                }
            }
            .overlay(alignment: .topLeading) {
                // Pixel coordinate overlay
                if let coord = viewModel.currentPixelCoordinate {
                    Text("(\(coord.col), \(coord.row))")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(5)
                        .padding(8)
                        .allowsHitTesting(false)
                }
            }
            .overlay {
                // Shape tool live preview overlay
                if !viewModel.shapePreviewPixels.isEmpty {
                    ShapePreviewOverlay(
                        previewPixels: viewModel.shapePreviewPixels,
                        gridWidth: gridWidth,
                        gridHeight: gridHeight,
                        zoomScale: zoomScale,
                        canvasOffset: canvasOffset,
                        geoSize: geo.size
                    )
                }
            }
            .overlay {
                // Selection highlight overlay
                if viewModel.hasSelection {
                    SelectionOverlay(
                        selectedIndices: viewModel.selectedIndices,
                        selectionOffset: viewModel.selectionOffset,
                        pixelHexes: viewModel.activeLayer.pixelHexes,
                        gridWidth: gridWidth,
                        gridHeight: gridHeight,
                        zoomScale: zoomScale,
                        canvasOffset: canvasOffset,
                        geoSize: geo.size
                    )
                }
            }
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
                        // Detect Apple Pencil on pencil touch — starts/restarts auto-reset timer
                        if isPencil {
                            toolsVM.registerPencilTouch()
                        }
                        
                        let tool = toolsVM.selectedTool
                        
                        // Update pixel coordinate for overlay
                        if let (row, col) = viewModel.gridRowCol(from: location,
                                                                   geoSize: geo.size,
                                                                   canvasOffset: canvasOffset,
                                                                   zoomScale: zoomScale) {
                            viewModel.currentPixelCoordinate = (col: col, row: row)
                        }
                        
                        // When Apple Pencil Only is enabled, or Apple Pencil was recently used,
                        // finger touches on drawing tools are treated as pan
                        let pencilOnly = SettingsService.shared.applePencilOnly
                        let fingerOnDrawTool = (pencilOnly || toolsVM.applePencilDetected) && !isPencil && ToolsViewModel.isDrawingTool(tool)
                        
                        if fingerOnDrawTool || tool == .pan {
                            panStartLocation = location
                        } else if tool == .eyedropper {
                            magnifierPosition = location
                            if let index = viewModel.gridIndex(from: location,
                                                                geoSize: geo.size,
                                                                canvasOffset: canvasOffset,
                                                                zoomScale: zoomScale) {
                                magnifierIndex = index
                                magnifierColor = viewModel.colorAtIndex(index)
                            }
                            showMagnifier = true
                        } else if tool.isShapeTool {
                            // Shape tools: record start point
                            if let (row, col) = viewModel.gridRowCol(from: location,
                                                                      geoSize: geo.size,
                                                                      canvasOffset: canvasOffset,
                                                                      zoomScale: zoomScale) {
                                viewModel.beginShapeDrag(row: row, col: col)
                                viewModel.updateShapePreview(row: row, col: col)
                            }
                        } else if tool == .select {
                            // Select tool: only add pixels in Pick mode; Fill mode is tap-only (handled on touch end)
                            if !toolsVM.selectFillMode {
                                if let index = viewModel.gridIndex(from: location,
                                                                    geoSize: geo.size,
                                                                    canvasOffset: canvasOffset,
                                                                    zoomScale: zoomScale) {
                                    viewModel.addToSelectionWithBrush(index)
                                }
                            }
                        } else if tool != .shift && tool != .flip {
                            viewModel.beginAction()
                            if let index = viewModel.gridIndex(from: location,
                                                                geoSize: geo.size,
                                                                canvasOffset: canvasOffset,
                                                                zoomScale: zoomScale) {
                                if tool == .eraser {
                                    eraserPreviewIndex = index
                                    showEraserPreview = true
                                }
                                viewModel.currentDrawingIndex = index
                                dragVisitedIndices.insert(index)
                                viewModel.applyToolAtIndex(index)
                            }
                        }
                    },
                    onSingleTouchMoved: { location, isPencil in
                        let tool = toolsVM.selectedTool
                        let pencilOnly = SettingsService.shared.applePencilOnly
                        let fingerOnDrawTool = (pencilOnly || toolsVM.applePencilDetected) && !isPencil && ToolsViewModel.isDrawingTool(tool)
                        
                        // Update pixel coordinate for overlay
                        if let (row, col) = viewModel.gridRowCol(from: location,
                                                                   geoSize: geo.size,
                                                                   canvasOffset: canvasOffset,
                                                                   zoomScale: zoomScale) {
                            viewModel.currentPixelCoordinate = (col: col, row: row)
                        } else {
                            viewModel.currentPixelCoordinate = nil
                        }
                        
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
                        } else if tool == .eyedropper {
                            magnifierPosition = location
                            if let index = viewModel.gridIndex(from: location,
                                                                geoSize: geo.size,
                                                                canvasOffset: canvasOffset,
                                                                zoomScale: zoomScale) {
                                magnifierIndex = index
                                magnifierColor = viewModel.colorAtIndex(index)
                            } else {
                                magnifierIndex = nil
                                magnifierColor = nil
                            }
                        } else if tool.isShapeTool {
                            // Shape tools: update live preview
                            if let (row, col) = viewModel.gridRowCol(from: location,
                                                                      geoSize: geo.size,
                                                                      canvasOffset: canvasOffset,
                                                                      zoomScale: zoomScale) {
                                viewModel.updateShapePreview(row: row, col: col)
                            }
                        } else if tool == .select {
                            // Select tool: only drag-select in Pick mode
                            if !toolsVM.selectFillMode {
                                if let index = viewModel.gridIndex(from: location,
                                                                    geoSize: geo.size,
                                                                    canvasOffset: canvasOffset,
                                                                    zoomScale: zoomScale) {
                                    viewModel.addToSelectionWithBrush(index)
                                }
                            }
                        } else if tool != .shift && tool != .flip {
                            if let index = viewModel.gridIndex(from: location,
                                                                geoSize: geo.size,
                                                                canvasOffset: canvasOffset,
                                                                zoomScale: zoomScale) {
                                if tool == .eraser {
                                    eraserPreviewIndex = index
                                    showEraserPreview = true
                                }
                                viewModel.currentDrawingIndex = index
                                if !dragVisitedIndices.contains(index) {
                                    dragVisitedIndices.insert(index)
                                    viewModel.applyToolAtIndex(index)
                                }
                            }
                        }
                    },
                    onSingleTouchEnded: { location, isPencil in
                        // Restart pencil timeout on pencil lift so countdown starts fresh
                        if isPencil {
                            toolsVM.registerPencilTouch()
                        }
                        
                        let tool = toolsVM.selectedTool
                        let pencilOnly = SettingsService.shared.applePencilOnly
                        let fingerOnDrawTool = (pencilOnly || toolsVM.applePencilDetected) && !isPencil && ToolsViewModel.isDrawingTool(tool)
                        
                        if fingerOnDrawTool || tool == .pan {
                            dragStart = canvasOffset
                        } else if tool == .eyedropper {
                            if let index = magnifierIndex ?? viewModel.gridIndex(from: location,
                                                                                   geoSize: geo.size,
                                                                                   canvasOffset: canvasOffset,
                                                                                   zoomScale: zoomScale) {
                                viewModel.eyedropperPickColor(at: index)
                            }
                            showMagnifier = false
                            magnifierColor = nil
                            magnifierIndex = nil
                            viewModel.currentPixelCoordinate = nil
                        } else if tool.isShapeTool {
                            // Shape tools: commit the preview to the canvas
                            viewModel.commitShapePreview()
                            viewModel.currentPixelCoordinate = nil
                        } else if tool == .select {
                            // Select tool: if fill mode, flood-fill the interior of the drawn boundary
                            if toolsVM.selectFillMode {
                                viewModel.fillEnclosedSelection()
                            }
                        } else if tool != .shift && tool != .flip {
                            if dragVisitedIndices.isEmpty {
                                viewModel.beginAction()
                                if let index = viewModel.gridIndex(from: location,
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
                            viewModel.currentDrawingIndex = nil
                            viewModel.currentPixelCoordinate = nil
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
    
    // MARK: - Pencil drawing highlight
    
    private func pencilHighlightOverlay(
        index: Int,
        gridWidth: Int,
        gridHeight: Int,
        zoomScale: CGFloat,
        canvasOffset: CGSize,
        geoSize: CGSize
    ) -> some View {
        let row = index / gridWidth
        let col = index % gridWidth
        
        // Canvas origin in screen space
        let scaledCanvasWidth = CGFloat(gridWidth) * zoomScale
        let scaledCanvasHeight = CGFloat(gridHeight) * zoomScale
        let canvasOriginX = geoSize.width / 2 + canvasOffset.width - scaledCanvasWidth / 2
        let canvasOriginY = geoSize.height / 2 + canvasOffset.height - scaledCanvasHeight / 2
        
        // Screen-space rect for the single pixel
        let rectX = canvasOriginX + CGFloat(col) * zoomScale
        let rectY = canvasOriginY + CGFloat(row) * zoomScale
        
        return Rectangle()
            .fill(Color.clear)
            .overlay(
                Rectangle()
                    .stroke(Color.white, lineWidth: max(1, zoomScale * 0.1))
            )
            .frame(width: zoomScale, height: zoomScale)
            .position(x: rectX + zoomScale / 2, y: rectY + zoomScale / 2)
            .allowsHitTesting(false)
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

// Shape tool preview overlay — renders preview pixels as semi-transparent overlay
private struct ShapePreviewOverlay: View {
    let previewPixels: [(index: Int, hex: String)]
    let gridWidth: Int
    let gridHeight: Int
    let zoomScale: CGFloat
    let canvasOffset: CGSize
    let geoSize: CGSize
    
    var body: some View {
        let scaledCanvasSize = CGSize(width: CGFloat(gridWidth) * zoomScale,
                                      height: CGFloat(gridHeight) * zoomScale)
        let cellSize = zoomScale
        
        let canvasOriginX = (geoSize.width - scaledCanvasSize.width) / 2 + canvasOffset.width
        let canvasOriginY = (geoSize.height - scaledCanvasSize.height) / 2 + canvasOffset.height
        
        Canvas { context, size in
            for (index, hex) in previewPixels {
                let row = index / gridWidth
                let col = index % gridWidth
                let x = canvasOriginX + CGFloat(col) * cellSize
                let y = canvasOriginY + CGFloat(row) * cellSize
                
                let color: Color = hex == "clear" ? .clear : Color(hex: hex)
                let rect = CGRect(x: x, y: y, width: cellSize, height: cellSize)
                context.fill(Path(rect), with: .color(color.opacity(0.75)))
            }
        }
        .allowsHitTesting(false)
    }
}

// Overlay that highlights selected pixels with a blue tint,
// and shows a ghost preview of where they'll land if shifted.
private struct SelectionOverlay: View {
    let selectedIndices: Set<Int>
    let selectionOffset: (dRow: Int, dCol: Int)
    let pixelHexes: [String]
    let gridWidth: Int
    let gridHeight: Int
    let zoomScale: CGFloat
    let canvasOffset: CGSize
    let geoSize: CGSize
    
    var body: some View {
        let scaledCanvasSize = CGSize(width: CGFloat(gridWidth) * zoomScale,
                                      height: CGFloat(gridHeight) * zoomScale)
        let cellSize = zoomScale
        let canvasOriginX = (geoSize.width - scaledCanvasSize.width) / 2 + canvasOffset.width
        let canvasOriginY = (geoSize.height - scaledCanvasSize.height) / 2 + canvasOffset.height
        let hasOffset = selectionOffset.dRow != 0 || selectionOffset.dCol != 0
        
        Canvas { context, size in
            for idx in selectedIndices {
                let row = idx / gridWidth
                let col = idx % gridWidth
                let x = canvasOriginX + CGFloat(col) * cellSize
                let y = canvasOriginY + CGFloat(row) * cellSize
                let rect = CGRect(x: x, y: y, width: cellSize, height: cellSize)
                
                // Highlight selected pixels with blue tint
                context.fill(Path(rect), with: .color(Color.blue.opacity(0.35)))
                
                // Draw a marching-ants-style border on each cell
                context.stroke(Path(rect), with: .color(Color.blue.opacity(0.7)),
                               style: StrokeStyle(lineWidth: max(0.5, cellSize * 0.04),
                                                  dash: [cellSize * 0.2, cellSize * 0.2]))
                
                // Ghost preview at shifted position
                if hasOffset {
                    let newRow = row + selectionOffset.dRow
                    let newCol = col + selectionOffset.dCol
                    guard newRow >= 0, newRow < gridHeight, newCol >= 0, newCol < gridWidth else { continue }
                    
                    let hex = pixelHexes[idx]
                    let nx = canvasOriginX + CGFloat(newCol) * cellSize
                    let ny = canvasOriginY + CGFloat(newRow) * cellSize
                    let nRect = CGRect(x: nx, y: ny, width: cellSize, height: cellSize)
                    
                    if hex != "clear" {
                        let color = Color(hex: hex)
                        context.fill(Path(nRect), with: .color(color.opacity(0.55)))
                    }
                    context.stroke(Path(nRect), with: .color(Color.green.opacity(0.6)),
                                   style: StrokeStyle(lineWidth: max(0.5, cellSize * 0.04),
                                                      dash: [cellSize * 0.15, cellSize * 0.15]))
                }
            }
        }
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
    let backgroundTileSize: Int
    let showGridLines: Bool

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.pixelGeneration == rhs.pixelGeneration &&
        lhs.gridWidth == rhs.gridWidth &&
        lhs.gridHeight == rhs.gridHeight &&
        lhs.zoomScale == rhs.zoomScale &&
        lhs.hSymmetry == rhs.hSymmetry &&
        lhs.vSymmetry == rhs.vSymmetry &&
        lhs.backgroundTileSize == rhs.backgroundTileSize &&
        lhs.showGridLines == rhs.showGridLines
    }

    var body: some View {
        let image = renderBitmap()
        let cellSize = zoomScale
        let drawGrid = showGridLines && cellSize > 8

        ZStack {
            if let image {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
            }
            
            // Grid lines overlay
            if drawGrid {
                Canvas { context, size in
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

    // Render the pixel grid + checkerboard into a bitmap.
    // For small canvases (< 512px), the bitmap is upscaled by repeating each pixel
    // so the GPU doesn't need extreme nearest-neighbor upscaling on real hardware.
    // Parses hex strings directly to RGB bytes — no UIColor/Color conversion needed.
    private func renderBitmap() -> UIImage? {
        let w = gridWidth
        let h = gridHeight
        guard w > 0, h > 0 else { return nil }

        // Determine upscale factor so the bitmap is at least 512px on its longest side.
        // This avoids rendering artifacts on real iPhone hardware (3x Retina)
        // where a tiny bitmap (e.g. 16×16) upscaled to 350+pt causes GPU issues.
        let minBitmapSize = 512
        let maxDim = max(w, h)
        let scale = maxDim < minBitmapSize ? (minBitmapSize / maxDim) : 1
        let bw = w * scale
        let bh = h * scale

        let lightR: UInt8 = 230, lightG: UInt8 = 230, lightB: UInt8 = 230
        let darkR:  UInt8 = 204, darkG:  UInt8 = 204, darkB:  UInt8 = 204

        var buffer = [UInt8](repeating: 255, count: bw * bh * 4)

        for row in 0..<h {
            for col in 0..<w {
                let i = row * w + col
                let hex = pixelHexes[i]

                let r: UInt8, g: UInt8, b: UInt8
                if hex == "clear" {
                    let tileSize = max(1, backgroundTileSize)
                    let isLight = (row / tileSize + col / tileSize) % 2 == 0
                    r = isLight ? lightR : darkR
                    g = isLight ? lightG : darkG
                    b = isLight ? lightB : darkB
                } else {
                    let rgb = hexToRGB(hex)
                    r = rgb.r; g = rgb.g; b = rgb.b
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

    // Fast hex string to RGB bytes — pure UTF8 byte math, no Scanner/UIColor.
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
