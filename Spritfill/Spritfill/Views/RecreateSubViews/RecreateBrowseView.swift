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
    
    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 16)]
    
    var body: some View {
        Group {
            if viewModel.browseSprites.isEmpty {
                emptyState
            } else {
                spriteList
            }
        }
    }
    
    // MARK: - Empty state
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "paintbrush")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("No sprites available")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Premade sprites and your saved projects will appear here")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Sprite list
    
    private var spriteList: some View {
        ScrollView {
            let premade = viewModel.browseSprites.filter { $0.sourceType == .premade }
            let userMade = viewModel.browseSprites.filter { $0.sourceType == .userMade }
            
            if !premade.isEmpty {
                sectionHeader("Premade Sprites")
                spriteGrid(premade)
            }
            
            if !userMade.isEmpty {
                sectionHeader("Your Sprites")
                spriteGrid(userMade)
            }
        }
    }
    
    // MARK: - Helpers
    
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
                Button(action: {
                    spriteToConfirm = sprite
                    showConfirmAlert = true
                }) {
                    VStack(spacing: 4) {
                        Image(uiImage: sprite.thumbnail)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(height: 100)
                            .cornerRadius(10)
                        
                        Text(sprite.name)
                            .font(.caption)
                            .fontWeight(.medium)
                            .lineLimit(1)
                        
                        Text(sprite.sourceType == .premade ? "Premade" : "Your Art")
                            .font(.caption2)
                            .foregroundColor(.secondary)
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
}
