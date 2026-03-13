//
//  RecreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-24.
//

import SwiftUI

struct RecreateView: View {
    
    @StateObject var recreateViewModel = RecreateViewModel()

    let columns = [GridItem(.adaptive(minimum: 100), spacing: 16)]

    var body: some View {
        NavigationView {
            Group {
                if recreateViewModel.availableSprites.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "paintbrush")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No projects to recreate")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Create and save a sprite in Canvas first!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(recreateViewModel.availableSprites) { sprite in
                                NavigationLink(destination: RecreateCanvasView(sprite: sprite)) {
                                    VStack {
                                        Image(uiImage: sprite.thumbnail)
                                            .resizable()
                                            .interpolation(.none)
                                            .scaledToFit()
                                            .frame(height: 100)
                                            .cornerRadius(10)

                                        Text(sprite.name)
                                            .font(.caption)
                                            .lineLimit(1)
                                    }
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 2)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                recreateViewModel.loadSprites()
            }
        }
    }
}

