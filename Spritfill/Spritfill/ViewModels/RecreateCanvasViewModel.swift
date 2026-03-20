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
    
    // MARK: - Session data
    
    private(set) var session: RecreateSession
    private let storage = RecreateStorageService.shared
    
    // MARK: - User state
    
    @Published var userPixels: [Color]
    @Published var userPixelHexes: [String]   // parallel hex array for accurate comparison
    @Published var selectedTool: RecreateTool = .paint
    @Published var selectedColor: Color = .clear
    @Published var selectedColorHex: String = "clear"  // hex string for the selected color
    @Published var zoomScale: CGFloat = 1.0
    @Published var viewSize: CGSize = .zero
    
    // Monotonically increasing counter — bumped when user pixels change.
    // Used by RecreateCanvasRenderer's Equatable check instead of comparing arrays.
    @Published private(set) var pixelGeneration: UInt = 0
    
    // MARK: - Undo / Redo history
    
    private var undoHistory: [[String]] = []
    private var redoHistory: [[String]] = []
    private var memoryObserver: Any?
    
    private var maxUndoSteps: Int {
        let pixelCount = userPixels.count
        if pixelCount > 4096 { return 50 }
        if pixelCount > 1024 { return 100 }
        return 150
    }
    
    @Published var canUndo: Bool = false
    @Published var canRedo: Bool = false
    private var actionInProgress = false
    private var actionDidChange = false   // tracks whether any pixel actually changed
    
    func beginAction() {
        if !actionInProgress {
            undoHistory.append(userPixelHexes)
            if undoHistory.count > maxUndoSteps {
                undoHistory.removeFirst()
            }
            // Any new action clears the redo stack
            redoHistory.removeAll()
            canUndo = true
            canRedo = false
            actionInProgress = true
            actionDidChange = false
        }
    }
    
    func endAction() {
        // If no pixels actually changed, discard the phantom snapshot
        if !actionDidChange {
            _ = undoHistory.popLast()
            canUndo = !undoHistory.isEmpty
        }
        actionInProgress = false
        actionDidChange = false
        recalculateStats()
    }
    
    func undo() {
        guard let snapshot = undoHistory.popLast() else { return }
        // Push current state onto redo stack before restoring
        redoHistory.append(userPixelHexes)
        userPixelHexes = snapshot
        userPixels = snapshot.map { hex in
            hex == "clear" ? Color.clear : Color(hex: hex)
        }
        pixelGeneration &+= 1
        canUndo = !undoHistory.isEmpty
        canRedo = true
        recalculateStats()
    }
    
    func redo() {
        guard let next = redoHistory.popLast() else { return }
        // Push current state onto undo stack before restoring
        undoHistory.append(userPixelHexes)
        userPixelHexes = next
        userPixels = next.map { hex in
            hex == "clear" ? Color.clear : Color(hex: hex)
        }
        pixelGeneration &+= 1
        canUndo = true
        canRedo = !redoHistory.isEmpty
        recalculateStats()
    }
    
    // MARK: - Computed properties
    
    var gridWidth: Int { session.canvasSize.dimensions.width }
    var gridHeight: Int { session.canvasSize.dimensions.height }
    
    var referenceGrid: [String] { session.referenceGrid }
    
    // MARK: - Cached reference data (immutable per session)
    
    let colorNumberMap: [String: Int]
    let numberedColors: [(number: Int, hex: String, color: Color)]
    
    // Pre-cached Color values for the reference grid (computed once).
    // Index-parallel to referenceGrid. "clear" entries are Color.clear.
    let referenceColors: [Color]
    
    // Pre-cached RGB bytes for the reference grid (computed once).
    // Used by the bitmap renderer to avoid hex parsing every frame.
    // Each entry is (r, g, b) or nil for "clear" cells.
    let referenceRGB: [(r: UInt8, g: UInt8, b: UInt8)?]
    
    // Cached stats — updated only when pixels change via recalculateStats()
    @Published private(set) var completionCount: Int = 0
    @Published private(set) var totalColoredPixels: Int = 0
    @Published private(set) var hasWrongPlacements: Bool = false
    @Published private(set) var isComplete: Bool = false
    
    // Recompute completion stats. Call after pixel changes, not on every frame.
    private func recalculateStats() {
        var completion = 0
        var wrongPlacement = false
        let refGrid = session.referenceGrid
        let hexes = userPixelHexes
        let count = refGrid.count
        
        for i in 0..<count {
            let target = refGrid[i]
            let user = i < hexes.count ? hexes[i] : "clear"
            
            if target == "clear" {
                if user != "clear" { wrongPlacement = true }
            } else if user != "clear" && user.lowercased() == target.lowercased() {
                completion += 1
            }
        }
        
        completionCount = completion
        hasWrongPlacements = wrongPlacement
        isComplete = totalColoredPixels > 0 && completion == totalColoredPixels && !wrongPlacement
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
        // Target: each pixel should be ~35pt on screen at max zoom,
        // regardless of canvas size. Base canvas is 1pt per pixel.
        let targetPixelSize: CGFloat = 35.0
        return max(targetPixelSize, minimumZoomScale + 1.0)
    }
    
    // MARK: - Init
    
    init(session: RecreateSession) {
        self.session = session
        
        // Build color-to-number map once (reference grid never changes)
        var map: [String: Int] = [:]
        var nextNumber = 1
        for hex in session.referenceGrid {
            if hex != "clear" && map[hex.lowercased()] == nil {
                map[hex.lowercased()] = nextNumber
                nextNumber += 1
            }
        }
        self.colorNumberMap = map
        self.numberedColors = map
            .sorted { $0.value < $1.value }
            .map { (number: $0.value, hex: $0.key, color: Color(hex: $0.key)) }
        
        // Pre-cache reference colors so the render loop never calls Color(hex:)
        self.referenceColors = session.referenceGrid.map { hex in
            hex == "clear" ? Color.clear : Color(hex: hex)
        }
        
        // Pre-cache reference RGB bytes for the bitmap renderer
        self.referenceRGB = session.referenceGrid.map { hex -> (r: UInt8, g: UInt8, b: UInt8)? in
            guard hex != "clear" else { return nil }
            var str = hex
            if str.hasPrefix("#") { str = String(str.dropFirst()) }
            guard str.count == 6 else { return nil }
            var val: UInt64 = 0
            Scanner(string: str).scanHexInt64(&val)
            return (r: UInt8((val >> 16) & 0xFF),
                    g: UInt8((val >> 8) & 0xFF),
                    b: UInt8(val & 0xFF))
        }
        
        // Load saved user pixels from session
        let totalPixels = session.canvasSize.dimensions.width * session.canvasSize.dimensions.height
        let hexes = Array(session.userPixels.prefix(totalPixels))
        self.userPixelHexes = hexes
        self.userPixels = hexes.map { hex in
            hex == "clear" ? Color.clear : Color(hex: hex)
        }
        
        if userPixels.count < totalPixels {
            userPixels.append(contentsOf: Array(repeating: Color.clear, count: totalPixels - userPixels.count))
            userPixelHexes.append(contentsOf: Array(repeating: "clear", count: totalPixels - userPixelHexes.count))
        }
        
        // Compute totalColoredPixels once (reference grid is immutable)
        self.totalColoredPixels = session.referenceGrid.filter { $0 != "clear" }.count
        
        memoryObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            self?.undoHistory.removeAll()
            self?.redoHistory.removeAll()
            self?.canUndo = false
            self?.canRedo = false
        }
        
        // Initial stats calculation
        recalculateStats()
    }
    
    private var saveTimer: Timer?
    
    deinit {
        saveTimer?.invalidate()
        if let observer = memoryObserver {
            NotificationCenter.default.removeObserver(observer)
        }
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
        
        let oldHex = userPixelHexes[index]
        
        switch selectedTool {
        case .paint:
            guard selectedColorHex != "clear" else { return }
            guard oldHex != selectedColorHex else { return }
            userPixels[index] = selectedColor
            userPixelHexes[index] = selectedColorHex
        case .eraser:
            guard oldHex != "clear" else { return }
            userPixels[index] = .clear
            userPixelHexes[index] = "clear"
        case .pan:
            return
        }
        actionDidChange = true
        pixelGeneration &+= 1
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
    
    func selectColor(_ color: Color, hex: String) {
        selectedColor = color
        selectedColorHex = hex
        if selectedTool != .paint {
            selectedTool = .paint
        }
    }
    
    func isSelected(tool: RecreateTool) -> Bool {
        return selectedTool == tool
    }
    
    // MARK: - Persistence
    
    // Whether this session has been deleted (prevents saveProgress from re-creating it)
    private(set) var isDeleted = false
    
    // Mark session as deleted so saveProgress becomes a no-op
    func markDeleted() {
        isDeleted = true
    }
    
    // Save current progress to disk
    func saveProgress() {
        guard !isDeleted else { return }
        session.userPixels = userPixelHexes
        session.lastEdited = Date()
        storage.saveSession(session)
    }

    // Debounced save — coalesces rapid paint actions into a single disk write
    func debouncedSave() {
        saveTimer?.invalidate()
        saveTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            self?.saveProgress()
        }
    }
    // MARK: - Export
    
    @MainActor
    func saveCompletedSpriteToPhotos(completion: (() -> Void)? = nil) {
        let tileSize: CGFloat = 16
        let renderW = CGFloat(gridWidth) * tileSize
        let renderH = CGFloat(gridHeight) * tileSize
        
        let view = Canvas { [userPixels = self.userPixels, gridWidth = self.gridWidth, gridHeight = self.gridHeight] context, size in
            for row in 0..<gridHeight {
                for col in 0..<gridWidth {
                    let index = row * gridWidth + col
                    guard index < userPixels.count else { continue }
                    let color = userPixels[index]
                    guard !color.isClear else { continue }
                    let rect = CGRect(x: CGFloat(col) * tileSize, y: CGFloat(row) * tileSize,
                                      width: tileSize, height: tileSize)
                    context.fill(Path(rect), with: .color(color))
                }
            }
        }
        .frame(width: renderW, height: renderH)
        
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        renderer.isOpaque = false
        
        if let image = renderer.uiImage {
            PhotoSaver.saveAsPNG(image) {
                completion?()
            }
        }
    }
}
