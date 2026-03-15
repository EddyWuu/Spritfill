//
//  DownloadsView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import SwiftUI

struct DownloadsView: View {
    
    @State private var showSavedAlert = false
    @State private var savedSpriteName = ""
    
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 16)]
    
    // Organize sprites by groups
    private var groupedSprites: [(name: String, sprites: [PremadeSpriteData])] {
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
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(groupedSprites, id: \.name) { section in
                    
                    // Section header
                    HStack {
                        Text(section.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 4)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(section.sprites) { sprite in
                            VStack(spacing: 6) {
                                spritePreview(sprite: sprite)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                
                                Text(sprite.name)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                
                                Button(action: {
                                    exportSprite(sprite)
                                }) {
                                    Label("PNG", systemImage: "arrow.down.circle.fill")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                            }
                            .padding(8)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Community Sprites")
            .alert("Saved!", isPresented: $showSavedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("\(savedSpriteName) has been saved as a transparent PNG to your photo library.")
            }
        }
    }
    
    // MARK: - Sprite preview (inline Canvas rendering)
    
    @MainActor
    private func spritePreview(sprite: PremadeSpriteData) -> some View {
        let width = sprite.canvasSize.dimensions.width
        let height = sprite.canvasSize.dimensions.height
        let tileSize: CGFloat = min(100.0 / CGFloat(width), 100.0 / CGFloat(height))
        let renderW = CGFloat(width) * tileSize
        let renderH = CGFloat(height) * tileSize
        
        return Canvas { context, size in
            // Draw pixels only - transparent background
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
    }
    
    // MARK: - Export as transparent PNG
    
    @MainActor
    private func exportSprite(_ sprite: PremadeSpriteData) {
        let width = sprite.canvasSize.dimensions.width
        let height = sprite.canvasSize.dimensions.height
        let tileSize: CGFloat = 16  // export at 16px per pixel for crisp output
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
        renderer.isOpaque = false  // transparent background
        
        if let image = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            savedSpriteName = sprite.name
            showSavedAlert = true
        }
    }
}
