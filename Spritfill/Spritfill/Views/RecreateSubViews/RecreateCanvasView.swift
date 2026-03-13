//
//  RecreateCanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-18.
//

import SwiftUI

struct RecreateCanvasView: View {
    let sprite: RecreatableArtModel
    
    @StateObject private var viewModel: RecreateCanvasViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(sprite: RecreatableArtModel) {
        self.sprite = sprite
        _viewModel = StateObject(wrappedValue: RecreateCanvasViewModel(sprite: sprite))
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
                    
                    Text("Recreate: \(sprite.name)")
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
    }
}
