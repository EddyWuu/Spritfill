//
//  ProjectDetailsPopupView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-04.
//

import SwiftUI

struct ProjectDetailsPopupView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        Text("Project Name:")
                            .font(.headline)
                        Spacer()
                        Text(viewModel.projectName)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "rectangle.grid.3x2")
                            .foregroundColor(.green)
                            .frame(width: 20)
                        Text("Canvas Size:")
                            .font(.headline)
                        Spacer()
                        let dimensions = viewModel.projectSettings.selectedCanvasSize.dimensions
                        Text("\(dimensions.width) × \(dimensions.height)")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "square.grid.3x3")
                            .foregroundColor(.orange)
                            .frame(width: 20)
                        Text("Tile Size:")
                            .font(.headline)
                        Spacer()
                        let tileSize = viewModel.projectSettings.selectedTileSize.size
                        Text("\(tileSize) × \(tileSize) pixels")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "paintpalette")
                            .foregroundColor(.purple)
                            .frame(width: 20)
                        Text("Palette:")
                            .font(.headline)
                        Spacer()
                        Text(viewModel.projectSettings.selectedPalette.rawValue)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Project Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
