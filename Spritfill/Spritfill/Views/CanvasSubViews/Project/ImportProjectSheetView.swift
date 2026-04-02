//
//  ImportProjectSheetView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-04-02.
//

import SwiftUI

// Sheet that lists saved projects eligible for import (canvas fits within the current project).
// Selecting a project imports its composite art as a new layer.
struct ImportProjectSheetView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var allProjects: [ProjectData] = []
    @State private var importError: String? = nil
    @State private var showError = false
    @State private var showSuccessAlert = false
    @State private var importedName = ""
    
    // Projects that fit within the current canvas (width ≤ and height ≤), excluding self.
    private var eligibleProjects: [ProjectData] {
        let currentW = viewModel.projectSettings.selectedCanvasSize.dimensions.width
        let currentH = viewModel.projectSettings.selectedCanvasSize.dimensions.height
        let currentID = viewModel.projectID
        
        return allProjects.filter { project in
            guard project.id != currentID else { return false }
            let w = project.settings.selectedCanvasSize.dimensions.width
            let h = project.settings.selectedCanvasSize.dimensions.height
            return w <= currentW && h <= currentH
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if eligibleProjects.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No Eligible Projects")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Only projects with a canvas size equal to or smaller than this project (\(currentDimensionLabel)) can be imported.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        Section {
                            ForEach(eligibleProjects, id: \.id) { project in
                                Button {
                                    performImport(project)
                                } label: {
                                    projectRow(project)
                                }
                                .buttonStyle(.plain)
                            }
                        } header: {
                            Text("Select a project to import as a new layer")
                        } footer: {
                            Text("The imported art will be centered on this canvas. If the imported canvas is smaller, the surrounding area will be transparent.")
                        }
                    }
                }
            }
            .navigationTitle("Import Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                allProjects = LocalStorageService.shared.fetchAllProjects()
            }
            .alert("Import Failed", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(importError ?? "An unknown error occurred.")
            }
            .alert("Imported! ✓", isPresented: $showSuccessAlert) {
                Button("OK") { dismiss() }
            } message: {
                Text("\"\(importedName)\" was added as a new layer.")
            }
        }
    }
    
    // MARK: - Helpers
    
    private var currentDimensionLabel: String {
        let w = viewModel.projectSettings.selectedCanvasSize.dimensions.width
        let h = viewModel.projectSettings.selectedCanvasSize.dimensions.height
        return "\(w)×\(h)"
    }
    
    private func projectRow(_ project: ProjectData) -> some View {
        let dims = project.settings.selectedCanvasSize.dimensions
        let maxDim = max(dims.width, dims.height)
        
        return HStack(spacing: 12) {
            PixelGridThumbnailView(
                pixelGrid: project.pixelGrid,
                gridWidth: dims.width,
                gridHeight: dims.height,
                tileSize: 50.0 / CGFloat(maxDim)
            )
            .frame(width: 50, height: 50)
            .cornerRadius(6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemGray5))
            )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(project.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("\(dims.width)×\(dims.height)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "square.and.arrow.down.on.square")
                .foregroundColor(.blue)
        }
        .padding(.vertical, 4)
    }
    
    private func performImport(_ project: ProjectData) {
        if let error = viewModel.importProject(project) {
            importError = error
            showError = true
        } else {
            importedName = project.name
            showSuccessAlert = true
        }
    }
}
