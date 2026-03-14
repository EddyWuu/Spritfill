//
//  GalleryStorageView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import SwiftUI

struct GalleryStorageView: View {
    
    @ObservedObject var viewModel: GalleryViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [GridItem(.adaptive(minimum: 80), spacing: 12)]
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.archivedItems.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "archivebox")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No archived sprites")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Archive sprites from the board in edit mode")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.archivedItems) { item in
                                VStack(spacing: 4) {
                                    if let image = viewModel.thumbnail(for: item.id) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .interpolation(.none)
                                            .scaledToFit()
                                            .frame(width: 70, height: 70)
                                            .cornerRadius(8)
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 70, height: 70)
                                    }
                                    
                                    Button(action: {
                                        viewModel.restoreItem(id: item.id)
                                    }) {
                                        Text("Restore")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.blue)
                                            .cornerRadius(6)
                                    }
                                }
                                .padding(6)
                                .background(Color(.systemBackground))
                                .cornerRadius(10)
                                .shadow(radius: 1)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Archived Sprites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
