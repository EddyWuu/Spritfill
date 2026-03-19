//
//  RecreateViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-06.
//

import SwiftUI
import Combine

class RecreateViewModel: ObservableObject {
    
    // MARK: - Published state
    
    // Browse tab: premade + community + user sprites available to recreate
    @Published var browseSprites: [RecreatableArtModel] = []
    
    // In Progress tab: saved sessions the user has started
    @Published var inProgressSessions: [RecreateSessionItem] = []
    
    // Finished tab: completed recreations
    @Published var finishedSessions: [RecreateSessionItem] = []
    
    private let projectStorage = LocalStorageService.shared
    private let sessionStorage = RecreateStorageService.shared
    private let communityService = CommunitySpritesService.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Load everything
    
    func loadAll() {
        loadSessions()
        
        // Clear previous subscriptions to prevent stacking
        cancellables.removeAll()
        
        // Fetch community sprites (may already be cached from Catalog)
        communityService.fetchCommunitySprites()
        
        // React to community sprite changes — rebuild browse list whenever they update
        communityService.$communitySprites
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadBrowseSprites()
            }
            .store(in: &cancellables)
        communityService.$fetchFailed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Browse tab: premade + community + user sprites
    
    private func loadBrowseSprites() {
        var sprites: [RecreatableArtModel] = []
        
        for premade in PremadeSprites.all {
            sprites.append(RecreatableArtModel(
                id: premade.id,
                name: premade.name,
                sourceType: .premade,
                canvasSize: premade.canvasSize,
                palette: premade.palette,
                pixelGrid: premade.pixelGrid,
                colorNumberMap: buildColorNumberMap(from: premade.pixelGrid)
            ))
        }
        
        // Community sprites from Firebase
        for community in communityService.communitySprites {
            sprites.append(RecreatableArtModel(
                id: community.id,
                name: community.name,
                sourceType: .community,
                canvasSize: community.canvasSize,
                palette: nil,
                pixelGrid: community.pixelGrid,
                colorNumberMap: buildColorNumberMap(from: community.pixelGrid)
            ))
        }
        
        let projects = projectStorage.fetchAllProjects()
        for project in projects {
            let hasContent = project.pixelGrid.contains(where: { $0 != "clear" })
            guard hasContent else { continue }
            
            sprites.append(RecreatableArtModel(
                id: project.id.uuidString,
                name: project.name,
                sourceType: .userMade,
                canvasSize: project.settings.selectedCanvasSize,
                palette: project.settings.selectedPalette,
                pixelGrid: project.pixelGrid,
                colorNumberMap: buildColorNumberMap(from: project.pixelGrid)
            ))
        }
        
        browseSprites = sprites
    }
    
    // MARK: - Load sessions (in progress + finished)
    
    private func loadSessions() {
        let sessions = sessionStorage.fetchAllSessions()
        
        var inProgress: [RecreateSessionItem] = []
        var finished: [RecreateSessionItem] = []
        
        for session in sessions {
            let item = RecreateSessionItem(
                id: session.id,
                session: session,
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
    
    // MARK: - Grouped browse data (for views)
    
    var groupedCommunitySprites: [(name: String, sprites: [RecreatableArtModel])] {
        let premade = browseSprites.filter { $0.sourceType == .premade }
        var groups: [(name: String, sprites: [RecreatableArtModel])] = []
        var ungrouped: [RecreatableArtModel] = []
        var seen: Set<String> = []
        
        for sprite in premade {
            if let premadeData = PremadeSprites.all.first(where: { $0.id == sprite.id }),
               let group = premadeData.group {
                if !seen.contains(group) {
                    seen.insert(group)
                    let members = premade.filter { s in
                        PremadeSprites.all.first(where: { $0.id == s.id })?.group == group
                    }
                    groups.append((name: group, sprites: members))
                }
            } else {
                ungrouped.append(sprite)
            }
        }
        
        if !ungrouped.isEmpty {
            groups.append((name: "Individual Sprites", sprites: ungrouped))
        }
        
        // Community sprites from Firebase
        let community = browseSprites.filter { $0.sourceType == .community }
        if !community.isEmpty {
            groups.append((name: "Community", sprites: community))
        }
        
        return groups
    }
    
    var userMadeSprites: [RecreatableArtModel] {
        browseSprites.filter { $0.sourceType == .userMade }
    }
    
    var isCommunityLoading: Bool {
        communityService.isLoading
    }
    
    var communityFetchFailed: Bool {
        communityService.fetchFailed
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
    
    // MARK: - Export
    
    @MainActor
    func saveSessionToPhotos(_ session: RecreateSession, completion: (() -> Void)? = nil) {
        let width = session.canvasSize.dimensions.width
        let height = session.canvasSize.dimensions.height
        let tileSize: CGFloat = 16
        let renderW = CGFloat(width) * tileSize
        let renderH = CGFloat(height) * tileSize
        
        let pixelGrid = session.userPixels
        let view = Canvas { context, size in
            for row in 0..<height {
                for col in 0..<width {
                    let index = row * width + col
                    guard index < pixelGrid.count else { continue }
                    let hex = pixelGrid[index]
                    guard hex != "clear" else { continue }
                    let rect = CGRect(x: CGFloat(col) * tileSize, y: CGFloat(row) * tileSize,
                                      width: tileSize, height: tileSize)
                    context.fill(Path(rect), with: .color(Color(hex: hex)))
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
    
    @MainActor
    func exportSessionImage(_ session: RecreateSession) -> UIImage? {
        let width = session.canvasSize.dimensions.width
        let height = session.canvasSize.dimensions.height
        let tileSize: CGFloat = 16
        let renderW = CGFloat(width) * tileSize
        let renderH = CGFloat(height) * tileSize
        
        let pixelGrid = session.userPixels
        let view = Canvas { context, size in
            for row in 0..<height {
                for col in 0..<width {
                    let index = row * width + col
                    guard index < pixelGrid.count else { continue }
                    let hex = pixelGrid[index]
                    guard hex != "clear" else { continue }
                    let rect = CGRect(x: CGFloat(col) * tileSize, y: CGFloat(row) * tileSize,
                                      width: tileSize, height: tileSize)
                    context.fill(Path(rect), with: .color(Color(hex: hex)))
                }
            }
        }
        .frame(width: renderW, height: renderH)
        
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        renderer.isOpaque = false
        return renderer.uiImage
    }
}
