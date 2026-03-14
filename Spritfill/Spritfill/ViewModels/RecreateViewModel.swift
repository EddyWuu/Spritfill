//
//  RecreateViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-06.
//

import SwiftUI

class RecreateViewModel: ObservableObject {
    
    // MARK: - Published state
    
    /// Browse tab: premade + user sprites available to recreate
    @Published var browseSprites: [RecreatableArtModel] = []
    
    /// In Progress tab: saved sessions the user has started
    @Published var inProgressSessions: [RecreateSessionItem] = []
    
    /// Finished tab: completed recreations
    @Published var finishedSessions: [RecreateSessionItem] = []
    
    private let projectStorage = LocalStorageService.shared
    private let sessionStorage = RecreateStorageService.shared
    
    // MARK: - Load everything
    
    @MainActor
    func loadAll() {
        loadBrowseSprites()
        loadSessions()
    }
    
    // MARK: - Browse tab: premade + user sprites
    
    @MainActor
    private func loadBrowseSprites() {
        var sprites: [RecreatableArtModel] = []
        
        // 1. Premade sprites
        for premade in PremadeSprites.all {
            let colorNumberMap = buildColorNumberMap(from: premade.pixelGrid)
            let thumbnail = generateThumbnailFromGrid(
                pixelGrid: premade.pixelGrid,
                width: premade.canvasSize.dimensions.width,
                height: premade.canvasSize.dimensions.height
            )
            sprites.append(RecreatableArtModel(
                id: premade.id,
                name: premade.name,
                thumbnail: thumbnail,
                sourceType: .premade,
                canvasSize: premade.canvasSize,
                palette: premade.palette,
                pixelGrid: premade.pixelGrid,
                colorNumberMap: colorNumberMap
            ))
        }
        
        // 2. User-made sprites (from saved canvas projects)
        let projects = projectStorage.fetchAllProjects()
        for project in projects {
            let hasContent = project.pixelGrid.contains(where: { $0 != "clear" })
            guard hasContent else { continue }
            
            let colorNumberMap = buildColorNumberMap(from: project.pixelGrid)
            let thumbnail = generateThumbnailFromGrid(
                pixelGrid: project.pixelGrid,
                width: project.settings.selectedCanvasSize.dimensions.width,
                height: project.settings.selectedCanvasSize.dimensions.height
            )
            let sourceID = project.id.uuidString
            sprites.append(RecreatableArtModel(
                id: sourceID,
                name: project.name,
                thumbnail: thumbnail,
                sourceType: .userMade,
                canvasSize: project.settings.selectedCanvasSize,
                palette: project.settings.selectedPalette,
                pixelGrid: project.pixelGrid,
                colorNumberMap: colorNumberMap
            ))
        }
        
        browseSprites = sprites
    }
    
    // MARK: - Load sessions (in progress + finished)
    
    @MainActor
    private func loadSessions() {
        let sessions = sessionStorage.fetchAllSessions()
        
        var inProgress: [RecreateSessionItem] = []
        var finished: [RecreateSessionItem] = []
        
        for session in sessions {
            let thumbnail = generateThumbnailFromGrid(
                pixelGrid: session.isComplete ? session.referenceGrid : session.userPixels,
                width: session.canvasSize.dimensions.width,
                height: session.canvasSize.dimensions.height
            )
            
            let item = RecreateSessionItem(
                id: session.id,
                session: session,
                thumbnail: thumbnail,
                progressText: "\(session.completionCount)/\(session.totalColoredPixels)"
            )
            
            if session.isComplete {
                finished.append(item)
            } else {
                inProgress.append(item)
            }
        }
        
        inProgressSessions = inProgress
        finishedSessions = finished
    }
    
    // MARK: - Create or resume session for a sprite
    
    func getOrCreateSession(for sprite: RecreatableArtModel) -> RecreateSession {
        // Check if a session already exists for this sprite
        if let existing = sessionStorage.findSession(sourceType: sprite.sourceType, sourceID: sprite.id) {
            return existing
        }
        
        // Create new session
        let totalPixels = sprite.canvasSize.dimensions.width * sprite.canvasSize.dimensions.height
        let session = RecreateSession(
            id: UUID(),
            sourceType: sprite.sourceType,
            sourceID: sprite.id,
            spriteName: sprite.name,
            canvasSize: sprite.canvasSize,
            palette: sprite.palette,
            referenceGrid: sprite.pixelGrid,
            userPixels: Array(repeating: "clear", count: totalPixels),
            lastEdited: Date()
        )
        sessionStorage.saveSession(session)
        return session
    }
    
    // MARK: - Delete a session
    
    @MainActor
    func deleteSession(_ item: RecreateSessionItem) {
        sessionStorage.deleteSession(id: item.id)
        inProgressSessions.removeAll { $0.id == item.id }
        finishedSessions.removeAll { $0.id == item.id }
    }
    
    @MainActor
    func deleteSessionByID(_ id: UUID) {
        sessionStorage.deleteSession(id: id)
        inProgressSessions.removeAll { $0.id == id }
        finishedSessions.removeAll { $0.id == id }
    }
    
    // MARK: - Helpers
    
    private func buildColorNumberMap(from pixelGrid: [String]) -> [String: Int] {
        var map: [String: Int] = [:]
        var nextNumber = 1
        for hex in pixelGrid {
            if hex != "clear" && map[hex.lowercased()] == nil {
                map[hex.lowercased()] = nextNumber
                nextNumber += 1
            }
        }
        return map
    }
    
    @MainActor
    private func generateThumbnailFromGrid(pixelGrid: [String], width: Int, height: Int) -> UIImage {
        let thumbSize: CGFloat = 120
        let tileSize = min(thumbSize / CGFloat(width), thumbSize / CGFloat(height))
        let renderW = CGFloat(width) * tileSize
        let renderH = CGFloat(height) * tileSize
        
        let view = PixelGridThumbnailView(
            pixelGrid: pixelGrid,
            gridWidth: width,
            gridHeight: height,
            tileSize: tileSize
        )
        .frame(width: renderW, height: renderH)
        
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage ?? UIImage(systemName: "square.grid.3x3")!
    }
}

// MARK: - Simple thumbnail renderer for any pixel grid

struct PixelGridThumbnailView: View {
    let pixelGrid: [String]
    let gridWidth: Int
    let gridHeight: Int
    let tileSize: CGFloat
    
    var body: some View {
        Canvas { context, size in
            for row in 0..<gridHeight {
                for col in 0..<gridWidth {
                    let index = row * gridWidth + col
                    guard index < pixelGrid.count else { continue }
                    let hex = pixelGrid[index]
                    guard hex != "clear" else { continue }
                    
                    let rect = CGRect(
                        x: CGFloat(col) * tileSize,
                        y: CGFloat(row) * tileSize,
                        width: tileSize,
                        height: tileSize
                    )
                    context.fill(Path(rect), with: .color(Color(hex: hex)))
                }
            }
        }
    }
}
