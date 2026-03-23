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
    @State private var jsonShareItem: IdentifiableURL? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    
                    // ...existing code...
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
                        let tileSize = viewModel.projectSettings.selectedTileSize
                        Text("\(tileSize) × \(tileSize) pixels")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "photo")
                            .foregroundColor(.teal)
                            .frame(width: 20)
                        Text("Export Resolution:")
                            .font(.headline)
                        Spacer()
                        Text(viewModel.exportResolutionLabel)
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
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(viewModel.projectSettings.selectedPalette.displayName)
                                .font(.body)
                                .foregroundColor(.secondary)
                            if !viewModel.projectSettings.extraColors.isEmpty {
                                Text("+\(viewModel.projectSettings.extraColors.count) custom")
                                    .font(.caption)
                                    .foregroundColor(.purple)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Export project as JSON for adding to community sprites
                Button(action: exportProjectJSON) {
                    Label("Export Project Data", systemImage: "square.and.arrow.up.on.square")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 16)
            .navigationTitle("Project Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $jsonShareItem) { item in
                ShareSheet(activityItems: [item.url])
            }
        }
    }
    
    private func exportProjectJSON() {
        guard let url = viewModel.exportProjectJSON() else { return }
        jsonShareItem = IdentifiableURL(url: url)
    }
}
