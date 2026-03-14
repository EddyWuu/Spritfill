//
//  RecreateCanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-18.
//

import SwiftUI

struct RecreateCanvasView: View {
    let session: RecreateSession
    
    @StateObject private var viewModel: RecreateCanvasViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showCompletionAlert = false
    @State private var showSavedAlert = false
    @State private var showDeleteAlert = false
    
    init(session: RecreateSession) {
        self.session = session
        _viewModel = StateObject(wrappedValue: RecreateCanvasViewModel(session: session))
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                
                // MARK: - Top nav bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                    }
                    
                    Spacer()
                    
                    Text("Recreate: \(session.spriteName)")
                        .font(.headline)
                    
                    Spacer()
                    
                    // Progress indicator
                    Text("\(viewModel.completionCount)/\(viewModel.totalColoredPixels)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if viewModel.isComplete {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    Button(action: { showDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                
                // MARK: - Canvas
                RecreateProjectCanvasView(viewModel: viewModel)
                    .frame(height: geo.size.height * 0.48)
                    .clipped()
                
                // MARK: - Zoom slider
                RecreateZoomSliderView(viewModel: viewModel)
                    .background(Color(.secondarySystemBackground))
                
                Divider()
                
                // MARK: - Tool buttons
                RecreateToolBarView(viewModel: viewModel)
                    .background(Color(.secondarySystemBackground))
                
                Divider()
                
                // MARK: - Numbered color palette
                RecreateColorPaletteView(viewModel: viewModel)
                    .frame(maxHeight: .infinity)
                    .background(Color(.secondarySystemBackground))
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .onDisappear {
            viewModel.saveProgress()
        }
        .onChange(of: viewModel.isComplete) { _, isComplete in
            if isComplete {
                showCompletionAlert = true
            }
        }
        .alert("Great Work! 🎉", isPresented: $showCompletionAlert) {
            Button("Save to Photos") {
                saveCompletedSpriteToPhotos()
            }
            Button("Done", role: .cancel) { }
        } message: {
            Text("You've completed recreating \(session.spriteName)! Would you like to save it to your photos?")
        }
        .alert("Saved!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your recreated sprite has been saved to your photo library.")
        }
        .alert("Delete Session?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.markDeleted()
                RecreateStorageService.shared.deleteSession(id: session.id)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will delete all progress for \(session.spriteName). This cannot be undone.")
        }
    }
    
    @MainActor
    private func saveCompletedSpriteToPhotos() {
        let gridWidth = viewModel.gridWidth
        let gridHeight = viewModel.gridHeight
        let tileSize: CGFloat = 16
        let renderW = CGFloat(gridWidth) * tileSize
        let renderH = CGFloat(gridHeight) * tileSize
        
        let view = Canvas { context, size in
            for row in 0..<gridHeight {
                for col in 0..<gridWidth {
                    let index = row * gridWidth + col
                    guard index < viewModel.userPixels.count else { continue }
                    let color = viewModel.userPixels[index]
                    guard !color.isClear else { continue }
                    let rect = CGRect(x: CGFloat(col) * tileSize, y: CGFloat(row) * tileSize,
                                      width: tileSize, height: tileSize)
                    context.fill(Path(rect), with: .color(color))
                }
            }
        }
        .frame(width: renderW, height: renderH)
        
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        renderer.isOpaque = false
        
        if let image = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            showSavedAlert = true
        }
    }
}
