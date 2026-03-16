//
//  ProjectCreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

struct ProjectCreateView: View {

    @ObservedObject var viewModel: CanvasViewModel
    @ObservedObject private var toolsVM: ToolsViewModel
    @StateObject private var projectManager = ProjectManagerViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showRenameAlert = false
    @State private var newProjectName = ""
    @State private var shareImage: IdentifiableImage? = nil
    @State private var showProjectDetails = false
    
    @State private var showSavedAlert = false
    @State private var savedAlertMessage = ""
    
    @State private var showDeleteAlert = false
    
    init(viewModel: CanvasViewModel) {
        self.viewModel = viewModel
        self.toolsVM = viewModel.toolsVM
    }

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
                            newProjectName = viewModel.projectName
                            showRenameAlert = true
                        }) {
                            Image(systemName: "pencil")
                        }
                        
                        Button(action: {
                            exportAndSaveToPhotos()
                        }) {
                            Image(systemName: "square.and.arrow.down")
                        }
                        
                        Button(action: {
                            exportAndShare()
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                
                // MARK: - Canvas
                ProjectCanvasView(viewModel: viewModel)
                    .frame(height: geo.size.height * 0.48)
                    .clipped()
                
                // MARK: - Zoom slider
                ZoomSliderView(canvasVM: viewModel)
                    .background(Color(.secondarySystemBackground))
                
                Divider()
                
                // MARK: - Tool buttons
                ToolsBarView(toolsVM: toolsVM, canvasVM: viewModel)
                    .background(Color(.secondarySystemBackground))
                
                Divider()
                
                // MARK: - Bottom panel
                ZStack {
                    ColorPaletteView(toolsVM: toolsVM)
                    
                    if toolsVM.selectedTool == .shift {
                        ShiftControlView(canvasVM: viewModel)
                    }
                }
                .frame(maxHeight: .infinity)
                .background(Color(.secondarySystemBackground))
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .edgesIgnoringSafeArea(.bottom)
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
        .alert("Saved", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(savedAlertMessage)
        }
        .sheet(isPresented: $showProjectDetails) {
            ProjectDetailsPopupView(viewModel: viewModel)
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $shareImage) { item in
            ShareSheet(activityItems: [item.image])
        }
    }
    
    // MARK: - Export helpers
    
    @MainActor
    private func exportImage() -> UIImage {
        let dims = viewModel.projectSettings.selectedCanvasSize.dimensions
        let tileSize = CGFloat(viewModel.projectSettings.selectedTileSize.size)
        let exportSize = CGSize(width: CGFloat(dims.width) * tileSize,
                                height: CGFloat(dims.height) * tileSize)
        let canvasView = ProjectCanvasExportView(viewModel: viewModel)
        return viewModel.renderCanvasImage(from: canvasView, size: exportSize)
    }
    
    private func exportAndSaveToPhotos() {
        DispatchQueue.main.async {
            let image = exportImage()
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            savedAlertMessage = "Image saved to Photos!"
            showSavedAlert = true
        }
    }
    
    private func exportAndShare() {
        DispatchQueue.main.async {
            let image = exportImage()
            shareImage = IdentifiableImage(image: image)
        }
    }
}
