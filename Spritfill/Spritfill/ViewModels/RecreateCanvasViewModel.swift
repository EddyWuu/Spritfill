//
//  RecreateCanvasViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-18.
//

import SwiftUI

class RecreateCanvasViewModel: ObservableObject {
    
    // MARK: - Tool types for recreate mode
    
    enum RecreateTool: CaseIterable {
        case paint, eraser, pan
        
        var iconName: String {
            switch self {
            case .paint: return "pencil"
            case .eraser: return "eraser"
            case .pan: return "hand.draw"
            }
        }
    }
    
    // MARK: - Source sprite data
    
    let sprite: RecreatableArtModel
    
    // MARK: - User state
    
    @Published var userPixels: [Color]
    @Published var selectedTool: RecreateTool = .paint
    @Published var selectedColor: Color = .clear
    @Published var zoomScale: CGFloat = 1.0
    @Published var viewSize: CGSize = .zero
    
    // MARK: - Computed properties
    
    var gridWidth: Int { sprite.canvasSize.dimensions.width }
    var gridHeight: Int { sprite.canvasSize.dimensions.height }
    
    var numberedColors: [(number: Int, hex: String, color: Color)] {
        sprite.colorNumberMap
            .sorted { $0.value < $1.value }
            .map { (number: $0.value, hex: $0.key, color: Color(hex: $0.key)) }
    }
    
    var completionCount: Int {
        var count = 0
        for i in 0..<sprite.pixelGrid.count {
            let targetHex = sprite.pixelGrid[i]
            if targetHex == "clear" { continue }
            if i < userPixels.count && !userPixels[i].isClear {
                let userHex = userPixels[i].toHex() ?? ""
                if userHex.lowercased() == targetHex.lowercased() {
                    count += 1
                }
            }
        }
        return count
    }
    
    var totalColoredPixels: Int {
        sprite.pixelGrid.filter { $0 != "clear" }.count
    }
    
    var isComplete: Bool {
        totalColoredPixels > 0 && completionCount == totalColoredPixels
    }
    
    // MARK: - Zoom calculations
    
    var fitScale: CGFloat {
        guard viewSize != .zero else { return 4.0 }
        let paddingFactor: CGFloat = 0.9
        let scaleW = (viewSize.width * paddingFactor) / CGFloat(gridWidth)
        let scaleH = (viewSize.height * paddingFactor) / CGFloat(gridHeight)
        return min(scaleW, scaleH)
    }
    
    var minimumZoomScale: CGFloat {
        return fitScale
    }
    
    var maximumZoomScale: CGFloat {
        let result = fitScale * 5.0
        return max(result, minimumZoomScale + 1.0)
    }
    
    // MARK: - Init
    
    init(sprite: RecreatableArtModel) {
        self.sprite = sprite
        let totalPixels = sprite.canvasSize.dimensions.width * sprite.canvasSize.dimensions.height
        self.userPixels = Array(repeating: Color.clear, count: totalPixels)
    }
    
    // MARK: - Actions
    
    func updateViewSize(_ size: CGSize) {
        let oldViewSize = viewSize
        viewSize = size
        
        if oldViewSize == .zero {
            zoomScale = fitScale
        } else {
            zoomScale = zoomScale.clamped(to: minimumZoomScale...maximumZoomScale)
        }
    }
    
    func applyToolAtIndex(_ index: Int) {
        guard index >= 0, index < userPixels.count else { return }
        
        switch selectedTool {
        case .paint:
            guard selectedColor != .clear else { return }
            userPixels[index] = selectedColor
        case .eraser:
            userPixels[index] = .clear
        case .pan:
            break
        }
        objectWillChange.send()
    }
    
    func gridIndex(from screenPoint: CGPoint, geoSize: CGSize, canvasOffset: CGSize) -> Int? {
        let scaledCanvasSize = CGSize(width: CGFloat(gridWidth) * zoomScale,
                                       height: CGFloat(gridHeight) * zoomScale)
        let canvasCenter = CGPoint(
            x: geoSize.width / 2 + canvasOffset.width,
            y: geoSize.height / 2 + canvasOffset.height
        )
        let canvasOrigin = CGPoint(
            x: canvasCenter.x - scaledCanvasSize.width / 2,
            y: canvasCenter.y - scaledCanvasSize.height / 2
        )
        let col = Int((screenPoint.x - canvasOrigin.x) / zoomScale)
        let row = Int((screenPoint.y - canvasOrigin.y) / zoomScale)
        
        guard row >= 0, row < gridHeight, col >= 0, col < gridWidth else { return nil }
        return row * gridWidth + col
    }
    
    func clampedOffset(for offset: CGSize, geoSize: CGSize, canvasSize: CGSize) -> CGSize {
        let maxX = max(0, (canvasSize.width - geoSize.width) / 2)
        let maxY = max(0, (canvasSize.height - geoSize.height) / 2)
        return CGSize(
            width: offset.width.clamped(to: -maxX...maxX),
            height: offset.height.clamped(to: -maxY...maxY)
        )
    }
    
    func selectTool(_ tool: RecreateTool) {
        selectedTool = tool
    }
    
    func selectColor(_ color: Color) {
        selectedColor = color
    }
    
    func isSelected(tool: RecreateTool) -> Bool {
        return selectedTool == tool
    }
}
