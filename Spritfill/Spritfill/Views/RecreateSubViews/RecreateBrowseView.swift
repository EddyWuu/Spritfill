//
//  RecreateBrowseView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import SwiftUI

struct RecreateBrowseView: View {
    
    @ObservedObject var viewModel: RecreateViewModel
    @Binding var spriteToConfirm: RecreatableArtModel?
    @Binding var showConfirmAlert: Bool
    
    @State private var previewSprite: RecreatableArtModel? = nil
    @State private var showPreview = false
    
    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 16)]
    
    var body: some View {
        ZStack {
            Group {
                if viewModel.browseSprites.isEmpty {
                    emptyState
                } else {
                    spriteList
                }
            }
            
            if let sprite = previewSprite {
                spritePreviewOverlay(sprite)
                    .opacity(showPreview ? 1 : 0)
                    .allowsHitTesting(showPreview)
                    .animation(.easeInOut(duration: 0.2), value: showPreview)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "paintbrush")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("No sprites available")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Community sprites and your saved projects will appear here")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var spriteList: some View {
        ScrollView {
            ForEach(viewModel.groupedCommunitySprites, id: \.name) { section in
                sectionHeader(section.name)
                spriteGrid(section.sprites)
            }
            
            if !viewModel.userMadeSprites.isEmpty {
                sectionHeader("Your Sprites")
                spriteGrid(viewModel.userMadeSprites)
            }
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 4)
    }
    
    private func spriteGrid(_ sprites: [RecreatableArtModel]) -> some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(sprites) { sprite in
                Button {
                    previewSprite = sprite
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showPreview = true
                    }
                } label: {
                    VStack(spacing: 4) {
                        PixelGridThumbnailView(
                            pixelGrid: sprite.pixelGrid,
                            gridWidth: sprite.gridWidth,
                            gridHeight: sprite.gridHeight,
                            tileSize: max(1, 100 / CGFloat(max(sprite.gridWidth, sprite.gridHeight)))
                        )
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
    
    // MARK: - Sprite preview overlay
    
    private func spritePreviewOverlay(_ sprite: RecreatableArtModel) -> some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    showPreview = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        previewSprite = nil
                    }
                }
            
            VStack(spacing: 0) {
                HStack {
                    Text(sprite.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button {
                        showPreview = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            previewSprite = nil
                            spriteToConfirm = sprite
                            showConfirmAlert = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                PixelGridThumbnailView(
                    pixelGrid: sprite.pixelGrid,
                    gridWidth: sprite.gridWidth,
                    gridHeight: sprite.gridHeight,
                    tileSize: max(1, 250 / CGFloat(max(sprite.gridWidth, sprite.gridHeight)))
                )
                .frame(width: 250, height: 250)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: 300, maxHeight: 350)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 10)
        }
        .transition(.opacity)
    }
}
