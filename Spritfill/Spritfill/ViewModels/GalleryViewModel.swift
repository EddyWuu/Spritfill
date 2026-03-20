//
//  GalleryViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import SwiftUI

// A single item on the gallery photo board
struct GalleryBoardItem: Codable, Identifiable {
    let id: UUID                 // matches ProjectData.id
    var position: CGPoint        // center position on the board
    var displaySize: CGFloat     // width/height of the sprite on the board (square)
    var isArchived: Bool         // hidden from board, shown in storage
    
    enum CodingKeys: String, CodingKey {
        case id, positionX, positionY, displaySize, isArchived
    }
    
    init(id: UUID, position: CGPoint, displaySize: CGFloat, isArchived: Bool = false) {
        self.id = id
        self.position = position
        self.displaySize = displaySize
        self.isArchived = isArchived
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        let x = try c.decode(CGFloat.self, forKey: .positionX)
        let y = try c.decode(CGFloat.self, forKey: .positionY)
        position = CGPoint(x: x, y: y)
        displaySize = try c.decode(CGFloat.self, forKey: .displaySize)
        isArchived = try c.decode(Bool.self, forKey: .isArchived)
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(position.x, forKey: .positionX)
        try c.encode(position.y, forKey: .positionY)
        try c.encode(displaySize, forKey: .displaySize)
        try c.encode(isArchived, forKey: .isArchived)
    }
}

class GalleryViewModel: ObservableObject {
    
    @Published var boardItems: [GalleryBoardItem] = []
    @Published var isEditMode: Bool = false
    @Published var showStorage: Bool = false
    @Published var zoomScale: CGFloat = 1.0
    @Published var boardOffset: CGSize = .zero
    @Published var selectedItemID: UUID? = nil
    @Published var expandedImage: UIImage? = nil
    @Published var showExpandedImage: Bool = false
    
    private let storage = LocalStorageService.shared
    private let fileManager = FileManager.default
    
    // Thumbnail storage — using Dictionary instead of NSCache to prevent eviction during zoom
    private var thumbnailStore: [UUID: UIImage] = [:]
    
    init() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            // Only clear on actual memory warning, not during normal use
            self?.thumbnailStore.removeAll()
        }
    }
    
    // Board constants
    let boardSize: CGFloat = 3000
    let defaultItemSize: CGFloat = 100
    let minItemSize: CGFloat = 50
    let maxItemSize: CGFloat = 300
    let minZoom: CGFloat = 0.3
    let maxZoom: CGFloat = 2.0
    
    // MARK: - Gesture handling
    
    func applyPinchEnd(scale: CGFloat) {
        let newZoom = (zoomScale * scale).clamped(to: minZoom...maxZoom)
        zoomScale = newZoom
    }
    
    var canPan: Bool {
        !isEditMode
    }
    
    // MARK: - Persistence
    
    private var layoutFileURL: URL {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("GalleryBoardLayout.json")
    }
    
    func saveLayout() {
        do {
            let data = try JSONEncoder().encode(boardItems)
            try data.write(to: layoutFileURL, options: .atomic)
        } catch {
            print("Error saving gallery layout: \(error)")
        }
    }
    
    private func loadLayout() -> [GalleryBoardItem] {
        guard let data = try? Data(contentsOf: layoutFileURL) else { return [] }
        return (try? JSONDecoder().decode([GalleryBoardItem].self, from: data)) ?? []
    }
    
    // MARK: - Load
    
    @MainActor
    func loadGallery() {
        let projects = storage.fetchAllProjects()
        let savedLayout = loadLayout()
        let savedMap = Dictionary(uniqueKeysWithValues: savedLayout.map { ($0.id, $0) })
        
        // Filter to projects that have content
        let projectsWithContent = projects.filter { $0.pixelGrid.contains { $0 != "clear" } }
        
        var items: [GalleryBoardItem] = []
        var col = 0
        var row = 0
        let spacing: CGFloat = 130
        // Center items on the board
        let centerX = boardSize / 2
        let centerY = boardSize / 2
        // Calculate grid start so items are centered
        let maxCols = 4
        let totalCols = min(projectsWithContent.count, maxCols)
        let totalRows = (projectsWithContent.count + maxCols - 1) / maxCols
        let startX = centerX - CGFloat(totalCols - 1) * spacing / 2
        let startY = centerY - CGFloat(totalRows - 1) * spacing / 2
        
        for project in projectsWithContent {
            if let saved = savedMap[project.id] {
                items.append(saved)
            } else {
                // Place new items in a grid layout
                let x = startX + CGFloat(col) * spacing
                let y = startY + CGFloat(row) * spacing
                items.append(GalleryBoardItem(
                    id: project.id,
                    position: CGPoint(x: x, y: y),
                    displaySize: defaultItemSize
                ))
                col += 1
                if col >= 4 {
                    col = 0
                    row += 1
                }
            }
            
            // Generate thumbnail
            generateThumbnail(for: project)
        }
        
        // Remove items for deleted projects
        let validIDs = Set(projectsWithContent.map { $0.id })
        items = items.filter { validIDs.contains($0.id) }
        
        boardItems = items
        saveLayout()
    }
    
    // MARK: - Thumbnails
    
    @MainActor
    private func generateThumbnail(for project: ProjectData) {
        let width = project.settings.selectedCanvasSize.dimensions.width
        let height = project.settings.selectedCanvasSize.dimensions.height
        // Render at a large size to eliminate subpixel gaps between tiles
        let thumbSize: CGFloat = 512
        let tileSize = floor(thumbSize / CGFloat(max(width, height)))
        let renderW = CGFloat(width) * tileSize
        let renderH = CGFloat(height) * tileSize
        
        let view = PixelGridThumbnailView(
            pixelGrid: project.pixelGrid,
            gridWidth: width,
            gridHeight: height,
            tileSize: tileSize
        )
        .frame(width: renderW, height: renderH)
        
        let renderer = ImageRenderer(content: view)
        renderer.scale = 1.0  // 1x is enough for pixel art thumbnails
        renderer.isOpaque = false
        if let image = renderer.uiImage {
            thumbnailStore[project.id] = image
        }
    }
    
    func thumbnail(for id: UUID) -> UIImage? {
        thumbnailStore[id]
    }
    
    // MARK: - Board items accessors
    
    var visibleItems: [GalleryBoardItem] {
        boardItems.filter { !$0.isArchived }
    }
    
    var archivedItems: [GalleryBoardItem] {
        boardItems.filter { $0.isArchived }
    }
    
    // MARK: - Edit actions
    
    func moveItem(id: UUID, to position: CGPoint) {
        guard let index = boardItems.firstIndex(where: { $0.id == id }) else { return }
        boardItems[index].position = position
        saveLayout()
    }
    
    func resizeItem(id: UUID, to size: CGFloat) {
        guard let index = boardItems.firstIndex(where: { $0.id == id }) else { return }
        boardItems[index].displaySize = size.clamped(to: minItemSize...maxItemSize)
        saveLayout()
    }
    
    func archiveItem(id: UUID) {
        guard let index = boardItems.firstIndex(where: { $0.id == id }) else { return }
        boardItems[index].isArchived = true
        saveLayout()
    }
    
    func restoreItem(id: UUID) {
        guard let index = boardItems.firstIndex(where: { $0.id == id }) else { return }
        boardItems[index].isArchived = false
        saveLayout()
    }
    
    // MARK: - Selection (tap to bring to top)
    
    func selectItem(id: UUID) {
        if selectedItemID == id {
            selectedItemID = nil
        } else {
            selectedItemID = id
        }
    }
    
    func deselectItem() {
        selectedItemID = nil
    }
    
    func expandSelectedItem() {
        guard let id = selectedItemID, let image = thumbnail(for: id) else { return }
        expandedImage = image
        showExpandedImage = true
    }
    
    // Sorted visible items so the selected one is drawn last (on top)
    var sortedVisibleItems: [GalleryBoardItem] {
        let items = visibleItems
        guard let selectedID = selectedItemID else { return items }
        var sorted = items.filter { $0.id != selectedID }
        if let selected = items.first(where: { $0.id == selectedID }) {
            sorted.append(selected)
        }
        return sorted
    }
}
