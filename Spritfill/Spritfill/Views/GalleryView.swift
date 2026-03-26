//
//  GalleryView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-24.
//

import SwiftUI

struct GalleryView: View {
    
    @StateObject private var galleryViewModel = GalleryViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if galleryViewModel.boardItems.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("Your Gallery is Empty")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        Text("Create pixel art in the Canvas tab, then\nrestore it from the Archive to display here!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else {
                    // Photo board
                    GalleryBoardView(viewModel: galleryViewModel)
                        .edgesIgnoringSafeArea(.bottom)
                }
            }
            .navigationTitle("Gallery")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        galleryViewModel.showStorage = true
                    } label: {
                        Image(systemName: "archivebox")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            galleryViewModel.isEditMode.toggle()
                            if !galleryViewModel.isEditMode {
                                galleryViewModel.resizingItemID = nil
                                galleryViewModel.selectedItemID = nil
                            }
                        }
                    } label: {
                        Text(galleryViewModel.isEditMode ? "Done" : "Edit")
                            .fontWeight(.semibold)
                    }
                }
            }
            .onAppear {
                galleryViewModel.loadGallery()
            }
            .sheet(isPresented: $galleryViewModel.showStorage) {
                GalleryStorageView(viewModel: galleryViewModel)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}
