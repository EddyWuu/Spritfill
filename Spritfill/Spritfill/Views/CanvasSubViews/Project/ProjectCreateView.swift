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
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    var onFinish: (() -> Void)? = nil
    
    @State private var showRenameAlert = false
    @State private var newProjectName = ""
    @State private var shareImage: IdentifiableImage? = nil
    @State private var showProjectDetails = false
    
    @State private var showDeleteAlert = false
    @State private var showClearLayerAlert = false
    @State private var showExportedAlert = false
    @State private var showFinishAlert = false
    @State private var showFinishCongrats = false
    @State private var showColorAdder = false
    @State private var showHelpSheet = false
    @State private var showLayerPanel = false
    @State private var bottomPanelCollapsed = false
    
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
                        viewModel.flushSave()
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
                            showClearLayerAlert = true
                        }) {
                            Image(systemName: "xmark.rectangle")
                                .foregroundColor(.orange)
                        }
                        
                        Button(action: {
                            showHelpSheet = true
                        }) {
                            Image(systemName: "questionmark.circle")
                        }
                        
                        Button(action: {
                            showProjectDetails = true
                        }) {
                            Image(systemName: "info.circle")
                        }
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showLayerPanel.toggle()
                            }
                        }) {
                            Image(systemName: "square.3.layers.3d")
                                .foregroundColor(showLayerPanel ? .primary : .blue)
                        }
                        
                        Button(action: {
                            newProjectName = viewModel.projectName
                            showRenameAlert = true
                        }) {
                            Image(systemName: "pencil")
                        }
                        
                        Button(action: {
                            viewModel.exportAndSaveToPhotos {
                                showExportedAlert = true
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
                    .clipped()
                    .frame(maxHeight: .infinity)
                
                // MARK: - Collapse/expand handle
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        bottomPanelCollapsed.toggle()
                    }
                }) {
                    VStack(spacing: 2) {
                        Image(systemName: bottomPanelCollapsed ? "chevron.up" : "chevron.down")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.secondary)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(.systemGray3))
                            .frame(width: 36, height: 4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .background(Color(.secondarySystemBackground))
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                // MARK: - Tool buttons (always visible)
                ToolsBarView(toolsVM: toolsVM, canvasVM: viewModel, showColorAdder: $showColorAdder)
                    .background(Color(.secondarySystemBackground))
                
                // MARK: - Collapsible bottom panel
                if !bottomPanelCollapsed {
                    VStack(spacing: 0) {
                        // Zoom slider (disabled — pinch-to-zoom is used instead)
                        // ZoomSliderView(canvasVM: viewModel)
                        //     .background(Color(.secondarySystemBackground))
                        
                        // Opacity slider
                        OpacitySliderView(toolsVM: toolsVM)
                        
                        Divider()
                        
                        // Bottom panel (palette / shift / flip)
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
                    .clipped()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .overlay(alignment: .trailing) {
                // Layer panel — overlays the full view so the slide animation isn't clipped
                if showLayerPanel {
                    let isRegular = sizeClass == .regular
                    LayerPanelView(viewModel: viewModel, onClose: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showLayerPanel = false
                        }
                    })
                    .frame(width: isRegular ? 240 : 160)
                    .frame(maxHeight: geo.size.height * (isRegular ? 0.65 : 0.55))
                    .shadow(color: .black.opacity(0.15), radius: 8, x: -2, y: 2)
                    .padding(.trailing, 6)
                    .padding(.top, 50)
                    .transition(.move(edge: .trailing))
                }
            }
            
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
        .alert("Clear Current Layer?", isPresented: $showClearLayerAlert) {
            Button("Clear", role: .destructive) {
                viewModel.clearCurrentLayer()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will erase all pixels on \"\(viewModel.activeLayer.name)\". This can be undone.")
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
        .alert("Saved", isPresented: $showExportedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Image saved to Photos!")
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
        .sheet(isPresented: $showHelpSheet) {
            CanvasHelpSheetView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .alert("Finish Project?", isPresented: $showFinishAlert) {
            Button("Finish", role: .destructive) {
                viewModel.isFinished = true
                viewModel.flushSave()
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
