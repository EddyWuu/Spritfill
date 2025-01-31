//
//  ProjectCreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

struct ProjectCreateView: View {
    
    @ObservedObject var viewModel: ProjectViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    
    @State private var zoomScale: CGFloat = 1.0  // track zoom level
    @State private var lastScale: CGFloat = 1.0  // track the last pinch scale
    
    var body: some View {
        
        VStack {
            
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Back")
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .padding(.top)
            
            Spacer()
            
            ProjectCanvasView(viewModel: viewModel, zoomScale: $zoomScale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { scale in
                            let newScale = lastScale * scale
                            zoomScale = max(0.5, min(newScale, 5.0)) 
                        }
                        .onEnded { _ in
                            lastScale = zoomScale
                        }
                )
            
            Text("Tile Size: \(CGFloat(viewModel.projectSettings.selectedTileSize.size))²")
        }
        .padding()
    }
}
