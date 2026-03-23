//
//  CatalogViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-17.
//

import SwiftUI
import Combine

class CatalogViewModel: ObservableObject {
    
    @Published var showSavedAlert = false
    @Published var savedSpriteName = ""
    
    private let communityService = CommunitySpritesService.shared
    
    // All sprites: premade + community
    private var allSprites: [PremadeSpriteData] {
        PremadeSprites.all + communityService.communitySprites
    }
    
    var groupedSprites: [(name: String, sprites: [PremadeSpriteData])] {
        var groups: [(name: String, sprites: [PremadeSpriteData])] = []
        var ungrouped: [PremadeSpriteData] = []
        var communitySprites: [PremadeSpriteData] = []
        var seen: Set<String> = []
        
        for sprite in allSprites {
            if let group = sprite.group {
                // Collect community sprites separately so they appear last
                if group == "Community" {
                    communitySprites.append(sprite)
                    continue
                }
                if !seen.contains(group) {
                    seen.insert(group)
                    let members = allSprites
                        .filter { $0.group == group }
                        .sorted { $0.groupOrder < $1.groupOrder }
                    groups.append((name: group, sprites: members))
                }
            } else {
                ungrouped.append(sprite)
            }
        }
        
        if !ungrouped.isEmpty {
            groups.append((name: "Individual Sprites", sprites: ungrouped))
        }
        
        // Community sprites always last
        if !communitySprites.isEmpty {
            groups.append((name: "Community", sprites: communitySprites))
        }
        
        return groups
    }
    
    var communityFetchFailed: Bool {
        communityService.fetchFailed
    }
    
    var isCommunityLoading: Bool {
        communityService.isLoading
    }
    
    func loadCommunitySprites() {
        communityService.fetchCommunitySprites()
        // Observe changes from the community service
        communityService.$communitySprites
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        communityService.$fetchFailed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private static let exportTileSize = 16
    
    /// Whether the given sprite's export resolution is below 512px.
    func spriteNeedsUpscale(_ sprite: PremadeSpriteData) -> Bool {
        let dims = sprite.canvasSize.dimensions
        return BitmapExporter.needsUpscaleForPhotos(gridWidth: dims.width,
                                                    gridHeight: dims.height,
                                                    tileSize: Self.exportTileSize)
    }
    
    /// Human-readable export resolution label for a sprite.
    func spriteExportResolutionLabel(_ sprite: PremadeSpriteData) -> String {
        let dims = sprite.canvasSize.dimensions
        return BitmapExporter.exportResolutionLabel(gridWidth: dims.width,
                                                    gridHeight: dims.height,
                                                    tileSize: Self.exportTileSize)
    }
    
    @MainActor
    func exportSprite(_ sprite: PremadeSpriteData, upscale: Bool = false) {
        guard var image = renderSpriteImage(sprite) else { return }
        if upscale {
            image = BitmapExporter.upscaleForPhotos(image)
        }
        PhotoSaver.saveAsPNG(image) { [weak self] in
            self?.savedSpriteName = sprite.name
            self?.showSavedAlert = true
        }
    }
    
    @MainActor
    func renderSpriteImage(_ sprite: PremadeSpriteData) -> UIImage? {
        let width = sprite.canvasSize.dimensions.width
        let height = sprite.canvasSize.dimensions.height
        let tileSize = Self.exportTileSize
        return BitmapExporter.renderImage(hexes: sprite.pixelGrid,
                                           gridWidth: width,
                                           gridHeight: height,
                                           tileSize: tileSize)
    }
}
//
