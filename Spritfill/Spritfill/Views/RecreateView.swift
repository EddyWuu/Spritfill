//
//  RecreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-24.
//

import SwiftUI

struct RecreateView: View {
    
    @ObservedObject var recreateViewModel = RecreateViewModel()

    let columns = [GridItem(.adaptive(minimum: 100), spacing: 16)]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(recreateViewModel.availableSprites, id: \.id) { sprite in
                        NavigationLink(destination: RecreateCanvasView(sprite: sprite)) {
                            VStack {
                                Image(uiImage: sprite.thumbnail)
                                    .resizable()
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
            .navigationTitle("Recreate a Sprite")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        recreateViewModel.startPhotoImport()
                    } label: {
                        Label("Import Photo", systemImage: "camera")
                    }
                }
            }
        }
    }
}

