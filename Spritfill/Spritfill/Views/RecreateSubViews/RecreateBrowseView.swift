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
    
    // Group the premade browse sprites by their group field
    private var groupedCommunity: [(name: String, sprites: [RecreatableArtModel])] {
        let premade = viewModel.browseSprites.filter { $0.sourceType == .premade }
        var groups: [(name: String, sprites: [RecreatableArtModel])] = []
        var ungrouped: [RecreatableArtModel] = []
        var seen: Set<String> = []
        
        // Build group info from PremadeSprites lookup
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
        
        return groups
    }
    
    var body: some View {
        Group {
            if viewModel.browseSprites.isEmpty {
                emptyState
            } else {
                spriteList
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
            let userMade = viewModel.browseSprites.filter { $0.sourceType == .userMade }
            
            // Community sprite groups
            ForEach(groupedCommunity, id: \.name) { section in
                sectionHeader(section.name)
                spriteGrid(section.sprites)
            }
            
            // User-made sprites
            if !userMade.isEmpty {
                sectionHeader("Your Sprites")
                spriteGrid(userMade)
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
