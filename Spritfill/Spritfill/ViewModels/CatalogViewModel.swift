//
//  CatalogViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-17.
//

import SwiftUI

class CatalogViewModel: ObservableObject {
    
    @Published var showSavedAlert = false
    @Published var savedSpriteName = ""
    
    var groupedSprites: [(name: String, sprites: [PremadeSpriteData])] {
        var groups: [(name: String, sprites: [PremadeSpriteData])] = []
        var ungrouped: [PremadeSpriteData] = []
        var seen: Set<String> = []
        
        for sprite in PremadeSprites.all {
            if let group = sprite.group {
                if !seen.contains(group) {
                    seen.insert(group)
                    let members = PremadeSprites.all
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
        
        return groups
    }
    
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
