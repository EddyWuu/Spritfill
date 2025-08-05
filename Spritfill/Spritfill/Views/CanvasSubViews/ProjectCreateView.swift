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
                HStack {
                    Button(action: {
                        projectManager.save(viewModel)
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }

                    Spacer()

                    HStack {
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
                            // Rename
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
                            // share
                            let tileSize = CGFloat(viewModel.projectSettings.selectedTileSize.size)
                            let dimensions = viewModel.projectSettings.selectedCanvasSize.dimensions
                            let canvasSize = CGSize(width: CGFloat(dimensions.width) * tileSize,
                                                    height: CGFloat(dimensions.height) * tileSize)

                            let canvasView = ProjectCanvasExportView(viewModel: viewModel)
                            let image = viewModel.renderCanvasImage(from: canvasView, size: canvasSize)
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
                .padding()
                .frame(height: geo.size.height * 0.08)
                .background(Color.gray.opacity(0.3))
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

                ProjectCanvasView(viewModel: viewModel)
                    .frame(height: geo.size.height * 0.54)
                    .clipped()

                ToolsBarView(toolsVM: viewModel.toolsVM)
                    .frame(height: geo.size.height * 0.38)
                    .background(Color.gray.opacity(0.2))
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}
