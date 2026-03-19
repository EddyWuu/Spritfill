//
//  CatalogView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import SwiftUI

struct CatalogView: View {
    
    @StateObject private var viewModel = CatalogViewModel()
    
    @State private var selectedSprite: PremadeSpriteData? = nil
    @State private var showDetail = false
    @State private var showSavedAlert = false
    @State private var shareImage: IdentifiableImage? = nil
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    private var columns: [GridItem] {
        let isRegular = sizeClass == .regular
        return [GridItem(.adaptive(minimum: isRegular ? 120 : 100), spacing: isRegular ? 20 : 16)]
    }
    
    private var gridSpacing: CGFloat {
        sizeClass == .regular ? 20 : 16
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    ForEach(viewModel.groupedSprites, id: \.name) { section in
                        
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
                        
                        // Sprite grid
                        LazyVGrid(columns: columns, spacing: gridSpacing) {
                            ForEach(section.sprites) { sprite in
                                Button {
                                    // Show sprite detail overlay
                                    selectedSprite = sprite
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showDetail = true
                                    }
                                } label: {
                                    VStack(spacing: 6) {
                                        spritePreview(sprite: sprite)
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(10)
                                        
                                        Text(sprite.name)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                    }
                                    .padding(8)
                                    .background(Color(.systemBackground))
                                    .cornerRadius(12)
                                    .shadow(radius: 2)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Community sprites status message
                    if viewModel.communityFetchFailed {
                        HStack(spacing: 8) {
                            Image(systemName: "wifi.slash")
                                .foregroundColor(.orange)
                            Text("Connect to the internet to see community sprites")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    } else if viewModel.isCommunityLoading {
                        HStack(spacing: 8) {
                            ProgressView()
                            Text("Loading community sprites...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
                
                // Detail overlay
                if let sprite = selectedSprite {
                    detailOverlay(sprite)
                        .opacity(showDetail ? 1 : 0)
                        .allowsHitTesting(showDetail)
                        .animation(.easeInOut(duration: 0.2), value: showDetail)
                }
            }
            .navigationTitle("Catalog")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadCommunitySprites()
            }
            .alert("Saved!", isPresented: $viewModel.showSavedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("\(viewModel.savedSpriteName) has been saved as a transparent PNG to your photo library.")
            }
            .sheet(item: $shareImage) { item in
                ShareSheet(activityItems: [item.image])
            }
        }
    }
    
    // MARK: - Detail overlay
    
    private func detailOverlay(_ sprite: PremadeSpriteData) -> some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    showDetail = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        selectedSprite = nil
                    }
                }
            
            VStack(spacing: 0) {
                
                // Header with sprite name and dimensions
                HStack {
                    Text(sprite.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    let dims = sprite.canvasSize.dimensions
                    Text("\(dims.width)×\(dims.height)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                // Sprite preview
                spritePreview(sprite: sprite, size: 250)
                    .frame(width: 250, height: 250)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                
                Divider()
                
                // Save and Export buttons
                HStack(spacing: 20) {
                    Button {
                        // Save sprite as PNG to photo library
                        viewModel.exportSprite(sprite)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.down")
                            Text("Save to Photos")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .clipShape(Capsule())
                    }
                    
                    Button {
                        // Share sprite image
                        if let image = viewModel.renderSpriteImage(sprite) {
                            shareImage = IdentifiableImage(image: image)
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .clipShape(Capsule())
                    }
                }
                .padding(.vertical, 16)
            }
            .frame(maxWidth: 320)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 10)
        }
        .transition(.opacity)
    }
    
    // MARK: - Sprite preview
    
    @MainActor
    private func spritePreview(sprite: PremadeSpriteData, size: CGFloat = 100) -> some View {
        let width = sprite.canvasSize.dimensions.width
        let height = sprite.canvasSize.dimensions.height
        let tileSize: CGFloat = min(size / CGFloat(width), size / CGFloat(height))
        let renderW = CGFloat(width) * tileSize
        let renderH = CGFloat(height) * tileSize
        
        return Canvas { context, _ in
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
}
