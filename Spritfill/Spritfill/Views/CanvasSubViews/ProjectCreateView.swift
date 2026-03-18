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
    
    var onFinish: (() -> Void)? = nil
    
    @State private var showRenameAlert = false
    @State private var newProjectName = ""
    @State private var shareImage: IdentifiableImage? = nil
    @State private var showProjectDetails = false
    
    @State private var showSavedAlert = false
    @State private var savedAlertMessage = ""
    
    @State private var showDeleteAlert = false
    @State private var showFinishAlert = false
    @State private var showFinishCongrats = false
    @State private var showColorAdder = false
    
    init(viewModel: CanvasViewModel, onFinish: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onFinish = onFinish
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
                            viewModel.exportAndSaveToPhotos {
                                savedAlertMessage = "Image saved to Photos!"
                                showSavedAlert = true
                            }
                        }) {
                            Image(systemName: "square.and.arrow.down")
                        }
                        
                        Button(action: {
                            viewModel.exportAndGetShareImage { image in
                                shareImage = image
                            }
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        
                        Button(action: {
                            showFinishAlert = true
                        }) {
                            Image(systemName: "checkmark.seal")
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                
                // MARK: - Canvas
                ProjectCanvasView(viewModel: viewModel, toolsVM: toolsVM)
                    .frame(height: geo.size.height * 0.48)
                    .clipped()
                
                // MARK: - Zoom slider
                ZoomSliderView(canvasVM: viewModel)
                    .background(Color(.secondarySystemBackground))
                
                Divider()
                
                // MARK: - Tool buttons
                ToolsBarView(toolsVM: toolsVM, canvasVM: viewModel, showColorAdder: $showColorAdder)
                    .background(Color(.secondarySystemBackground))
                
                Divider()
                
                // MARK: - Bottom panel
                ZStack {
                    ColorPaletteView(toolsVM: toolsVM)
                    
                    if toolsVM.selectedTool == .shift {
                        ShiftControlView(canvasVM: viewModel)
                    }
                    
                    if toolsVM.selectedTool == .flip {
                        FlipControlView(canvasVM: viewModel)
                    }
                }
                .frame(maxHeight: .infinity)
                .background(Color(.secondarySystemBackground))
            }
            .frame(width: geo.size.width, height: geo.size.height)
            
            // Export loading overlay
            if viewModel.isExporting {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay(
                        VStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                            Text("Exporting…")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        .padding(24)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    )
                    .allowsHitTesting(true)
            }
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
                .presentationDetents([.height(360)])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $shareImage) { item in
            ShareSheet(activityItems: [item.image])
        }
        .sheet(isPresented: $showColorAdder) {
            ColorAdderSheetView(toolsVM: toolsVM)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .alert("Finish Project?", isPresented: $showFinishAlert) {
            Button("Finish", role: .destructive) {
                viewModel.isFinished = true
                projectManager.save(viewModel)
                showFinishCongrats = true
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Mark \"\(viewModel.projectName)\" as finished? You can still edit it later from the Finished tab.")
        }
        .alert("Congratulations! 🎉", isPresented: $showFinishCongrats) {
            Button("Done") {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onFinish?()
                }
            }
        } message: {
            Text("Great work on \"\(viewModel.projectName)\"!")
        }
    }
}
