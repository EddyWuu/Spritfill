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
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(PremadeSprites.all) { sprite in
                        VStack(spacing: 6) {
                            // Render the sprite thumbnail
                            spritePreview(sprite: sprite)
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                            
                            Text(sprite.name)
                                .font(.caption)
                                .fontWeight(.medium)
                                .lineLimit(1)
                            
                            // Download button
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
                .padding()
            }
            .navigationTitle("Downloads")
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
