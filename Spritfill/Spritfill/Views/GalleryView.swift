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
        ZStack(alignment: .top) {
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
                    Text("Create some pixel art in the Canvas tab\nand it will appear here!")
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
            
            // Floating toolbar
            toolbar
        }
        .onAppear {
            galleryViewModel.loadGallery()
        }
        .sheet(isPresented: $galleryViewModel.showStorage) {
            GalleryStorageView(viewModel: galleryViewModel)
                .presentationDetents([.medium, .large])
        }
    }
    
    // MARK: - Floating toolbar
    
    private var toolbar: some View {
        HStack(spacing: 16) {
            Text("Gallery")
                .font(.headline)
            
            Spacer()
            
            // Storage button (archived items)
            if galleryViewModel.isEditMode {
                Button(action: {
                    galleryViewModel.showStorage = true
                }) {
                    Image(systemName: "archivebox")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
            
            // Edit / Done button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    galleryViewModel.isEditMode.toggle()
                }
            }) {
                Text(galleryViewModel.isEditMode ? "Done" : "Edit")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(galleryViewModel.isEditMode ? .blue : .primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
}
