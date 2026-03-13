//
//  ProjectCreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

struct ProjectCreateView: View {

    @ObservedObject var viewModel: CanvasViewModel
    @StateObject private var projectManager = ProjectManagerViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showRenameAlert = false
    @State private var newProjectName = ""
    @State private var shareImage: UIImage?
    @State private var isSharing = false
    @State private var showProjectDetails = false
    
    @State private var showDeleteAlert = false

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                
                // MARK: - Top nav bar
                HStack {
                    Button(action: {
                        projectManager.save(viewModel)
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }

                    Spacer()

                    HStack(spacing: 16) {
                        Button(role: .destructive) {
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                        
                        Button(action: {
                            showProjectDetails = true
                        }) {
                            Image(systemName: "info.circle")
                        }
                        
                        Button(action: {
                            showRenameAlert = true
                        }) {
                            Image(systemName: "pencil")
                        }
                        
                        Button(action: {
                            // Save
                        }) {
                            Image(systemName: "square.and.arrow.down")
                        }
                        
                        Button(action: {
                            let dims = viewModel.projectSettings.selectedCanvasSize.dimensions
                            let tileSize = CGFloat(viewModel.projectSettings.selectedTileSize.size)
                            let exportSize = CGSize(width: CGFloat(dims.width) * tileSize,
                                                    height: CGFloat(dims.height) * tileSize)
                            let canvasView = ProjectCanvasExportView(viewModel: viewModel)
                            let image = viewModel.renderCanvasImage(from: canvasView, size: exportSize)
                            self.shareImage = image
                            self.isSharing = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .sheet(isPresented: $isSharing) {
                            if let image = shareImage {
                                ShareSheet(activityItems: [image])
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                .alert("Delete this project?", isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        let data = viewModel.toProjectData()
                        projectManager.delete(data)
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) { }
                }
                .alert("Rename Project", isPresented: $showRenameAlert) {
                    TextField("New name", text: $newProjectName)
                    Button("Save") {
                        if !newProjectName.trimmingCharacters(in: .whitespaces).isEmpty {
                            viewModel.projectName = newProjectName
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }
                .sheet(isPresented: $showProjectDetails) {
                    ProjectDetailsPopupView(viewModel: viewModel)
                        .presentationDetents([.height(280)])
                        .presentationDragIndicator(.visible)
                }
                
                // MARK: - Canvas
                ProjectCanvasView(viewModel: viewModel)
                    .frame(height: geo.size.height * 0.48)
                    .clipped()
                
                // MARK: - Zoom slider
                ZoomSliderView(canvasVM: viewModel)
                    .background(Color(.secondarySystemBackground))
                
                Divider()
                
                // MARK: - Tool buttons
                ToolsBarView(toolsVM: viewModel.toolsVM)
                    .background(Color(.secondarySystemBackground))
                
                Divider()
                
                // MARK: - Inline color palette
                ColorPaletteView(toolsVM: viewModel.toolsVM)
                    .frame(maxHeight: .infinity)
                    .background(Color(.secondarySystemBackground))
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}
