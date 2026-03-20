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
    
    @MainActor
    func exportSprite(_ sprite: PremadeSpriteData) {
        guard let image = renderSpriteImage(sprite) else { return }
        PhotoSaver.saveAsPNG(image) { [weak self] in
            self?.savedSpriteName = sprite.name
            self?.showSavedAlert = true
        }
    }
    
    @MainActor
    func renderSpriteImage(_ sprite: PremadeSpriteData) -> UIImage? {
        let width = sprite.canvasSize.dimensions.width
        let height = sprite.canvasSize.dimensions.height
        let tileSize: CGFloat = 16
        let renderW = CGFloat(width) * tileSize
        let renderH = CGFloat(height) * tileSize
        
        let view = Canvas { context, size in
            for row in 0..<height {
                for col in 0..<width {
                    let index = row * width + col
                    guard index < sprite.pixelGrid.count else { continue }
                    let hex = sprite.pixelGrid[index]
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
