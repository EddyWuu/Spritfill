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
    @ObservedObject private var settings = SettingsService.shared
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
    @State private var showSaveSizeSheet = false
    @State private var showShareSizeSheet = false
    @State private var showFinishAlert = false
    @State private var showFinishCongrats = false
    @State private var showColorAdder = false
    @State private var showHelpSheet = false
    @State private var showSettingsSheet = false
    @State private var showImportSheet = false
    @State private var showImportProAlert = false
    @State private var showImportLayerLimitAlert = false
    @State private var showStoreSheet = false
    @State private var showLayerPanel = false
    @State private var bottomPanelCollapsed = false
    
    // Draggable layer panel position
    @State private var layerPanelOffset: CGSize = .zero
    @State private var layerPanelDragStart: CGSize = .zero
    
    init(viewModel: CanvasViewModel, onFinish: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onFinish = onFinish
        self.toolsVM = viewModel.toolsVM
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                
                // MARK: - Top nav bar
                topNavBar
                
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
                ToolsBarView(toolsVM: toolsVM, canvasVM: viewModel, showColorAdder: $showColorAdder, bottomPanelCollapsed: bottomPanelCollapsed)
                    .padding(.bottom, bottomPanelCollapsed ? 6 : 0)
                    .background(Color(.secondarySystemBackground))
                
                // MARK: - Collapsible bottom panel
                if !bottomPanelCollapsed {
                    VStack(spacing: 0) {
                        // Zoom slider (toggled via Settings)
                        if settings.zoomDragBar {
                            ZoomSliderView(canvasVM: viewModel)
                                .background(Color(.secondarySystemBackground))
                        }
                        
                        // Opacity slider
                        OpacitySliderView(toolsVM: toolsVM)
                        
                        Divider()
                        
                        // Bottom panel (palette / shift / flip / gradient / dither / select)
                        bottomPanelContent
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
                    LayerPanelView(viewModel: viewModel, layerManager: viewModel.layerManager, onClose: {
                        showLayerPanel = false
                    })
                    .frame(width: isRegular ? 280 : 190)
                    .frame(maxHeight: geo.size.height * (isRegular ? 0.7 : 0.55))
                    .shadow(color: .black.opacity(0.15), radius: 8, x: -2, y: 2)
                    .padding(.trailing, 6)
                    .padding(.top, 50)
                    .offset(x: layerPanelOffset.width, y: layerPanelOffset.height)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                layerPanelOffset = CGSize(
                                    width: layerPanelDragStart.width + value.translation.width,
                                    height: layerPanelDragStart.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                layerPanelDragStart = layerPanelOffset
                            }
                    )
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
        .onChange(of: toolsVM.selectedTool) { _, newTool in
            if newTool != .select && viewModel.hasSelection {
                viewModel.clearSelection()
            }
        }
        .modifier(ProjectCreateAlertsModifier(
            viewModel: viewModel,
            toolsVM: toolsVM,
            projectManager: projectManager,
            dismiss: dismiss,
            onFinish: onFinish,
            showDeleteAlert: $showDeleteAlert,
            showClearLayerAlert: $showClearLayerAlert,
            showRenameAlert: $showRenameAlert,
            newProjectName: $newProjectName,
            showExportedAlert: $showExportedAlert,
            showSaveSizeSheet: $showSaveSizeSheet,
            showShareSizeSheet: $showShareSizeSheet,
            shareImage: $shareImage,
            showProjectDetails: $showProjectDetails,
            showColorAdder: $showColorAdder,
            showHelpSheet: $showHelpSheet,
            showSettingsSheet: $showSettingsSheet,
            showFinishAlert: $showFinishAlert,
            showFinishCongrats: $showFinishCongrats,
            showImportSheet: $showImportSheet,
            showImportProAlert: $showImportProAlert,
            showImportLayerLimitAlert: $showImportLayerLimitAlert,
            showStoreSheet: $showStoreSheet
        ))
    }
    
    // MARK: - Top Nav Bar (extracted for type-checker performance)
    
    @ViewBuilder
    private var topNavBar: some View {
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
                
                Button(action: { showClearLayerAlert = true }) {
                    Image(systemName: "xmark.rectangle")
                        .foregroundColor(.orange)
                }
                
                Button(action: { showHelpSheet = true }) {
                    Image(systemName: "questionmark.circle")
                }
                
                Button(action: { showProjectDetails = true }) {
                    Image(systemName: "info.circle")
                }
                
                Button(action: {
                    showLayerPanel.toggle()
                    if showLayerPanel {
                        layerPanelOffset = .zero
                        layerPanelDragStart = .zero
                    }
                }) {
                    Image(systemName: "square.3.layers.3d")
                        .foregroundColor(showLayerPanel ? .primary : .blue)
                }
                
                Button(action: {
                    if !StoreService.shared.isPro {
                        showImportProAlert = true
                    } else if viewModel.layers.count >= LayerManagerViewModel.maxLayers {
                        showImportLayerLimitAlert = true
                    } else {
                        showImportSheet = true
                    }
                }) {
                    Image(systemName: "square.and.arrow.down.on.square")
                }
                
                Button(action: {
                    newProjectName = viewModel.projectName
                    showRenameAlert = true
                }) {
                    Image(systemName: "pencil")
                }
                
                Button(action: {
                    if viewModel.exportNeedsUpscale {
                        showSaveSizeSheet = true
                    } else {
                        viewModel.saveToPhotos(upscale: false) { showExportedAlert = true }
                    }
                }) {
                    Image(systemName: "square.and.arrow.down")
                }
                
                Button(action: {
                    if viewModel.exportNeedsUpscale {
                        showShareSizeSheet = true
                    } else {
                        viewModel.exportAndGetShareImage { image in shareImage = image }
                    }
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                
                Button(action: { showSettingsSheet = true }) {
                    Image(systemName: "gearshape")
                }
                
                Button(action: { showFinishAlert = true }) {
                    Image(systemName: "checkmark.seal")
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Bottom Panel Content (extracted for type-checker performance)
    
    @ViewBuilder
    private var bottomPanelContent: some View {
        ZStack {
            ColorPaletteView(toolsVM: toolsVM)
            
            if toolsVM.selectedTool == .shift {
                ShiftControlView(canvasVM: viewModel)
            }
            
            if toolsVM.selectedTool == .flip {
                FlipControlView(canvasVM: viewModel)
            }
            
            if toolsVM.selectedTool == .gradient {
                GradientControlView(toolsVM: toolsVM)
            }
            
            if toolsVM.selectedTool == .dither {
                DitherControlView(toolsVM: toolsVM)
            }
            
            if toolsVM.selectedTool == .select {
                SelectControlView(canvasVM: viewModel, toolsVM: toolsVM)
            }
        }
    }
}

// MARK: - Alerts & Sheets Modifier (extracted for type-checker performance)

private struct ProjectCreateAlertsModifier: ViewModifier {
    @ObservedObject var viewModel: CanvasViewModel
    @ObservedObject var toolsVM: ToolsViewModel
    @ObservedObject var projectManager: ProjectManagerViewModel
    let dismiss: DismissAction
    let onFinish: (() -> Void)?
    
    @Binding var showDeleteAlert: Bool
    @Binding var showClearLayerAlert: Bool
    @Binding var showRenameAlert: Bool
    @Binding var newProjectName: String
    @Binding var showExportedAlert: Bool
    @Binding var showSaveSizeSheet: Bool
    @Binding var showShareSizeSheet: Bool
    @Binding var shareImage: IdentifiableImage?
    @Binding var showProjectDetails: Bool
    @Binding var showColorAdder: Bool
    @Binding var showHelpSheet: Bool
    @Binding var showSettingsSheet: Bool
    @Binding var showFinishAlert: Bool
    @Binding var showFinishCongrats: Bool
    @Binding var showImportSheet: Bool
    @Binding var showImportProAlert: Bool
    @Binding var showImportLayerLimitAlert: Bool
    @Binding var showStoreSheet: Bool
    
    func body(content: Content) -> some View {
        content
            .alert("Delete this project?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    let data = viewModel.toProjectData()
                    projectManager.delete(data)
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            }
            .alert("Clear Current Layer?", isPresented: $showClearLayerAlert) {
                Button("Clear", role: .destructive) { viewModel.clearCurrentLayer() }
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
            .modifier(ProjectCreateDialogsModifier(
                viewModel: viewModel,
                toolsVM: toolsVM,
                dismiss: dismiss,
                onFinish: onFinish,
                showSaveSizeSheet: $showSaveSizeSheet,
                showShareSizeSheet: $showShareSizeSheet,
                showExportedAlert: $showExportedAlert,
                shareImage: $shareImage,
                showProjectDetails: $showProjectDetails,
                showColorAdder: $showColorAdder,
                showHelpSheet: $showHelpSheet,
                showSettingsSheet: $showSettingsSheet,
                showFinishAlert: $showFinishAlert,
                showFinishCongrats: $showFinishCongrats,
                showImportSheet: $showImportSheet,
                showImportProAlert: $showImportProAlert,
                showImportLayerLimitAlert: $showImportLayerLimitAlert,
                showStoreSheet: $showStoreSheet
            ))
    }
}

private struct ProjectCreateDialogsModifier: ViewModifier {
    @ObservedObject var viewModel: CanvasViewModel
    @ObservedObject var toolsVM: ToolsViewModel
    let dismiss: DismissAction
    let onFinish: (() -> Void)?
    
    @Binding var showSaveSizeSheet: Bool
    @Binding var showShareSizeSheet: Bool
    @Binding var showExportedAlert: Bool
    @Binding var shareImage: IdentifiableImage?
    @Binding var showProjectDetails: Bool
    @Binding var showColorAdder: Bool
    @Binding var showHelpSheet: Bool
    @Binding var showSettingsSheet: Bool
    @Binding var showFinishAlert: Bool
    @Binding var showFinishCongrats: Bool
    @Binding var showImportSheet: Bool
    @Binding var showImportProAlert: Bool
    @Binding var showImportLayerLimitAlert: Bool
    @Binding var showStoreSheet: Bool
    
    func body(content: Content) -> some View {
        content
            .confirmationDialog("Small Export Size (\(viewModel.exportResolutionLabel))", isPresented: $showSaveSizeSheet, titleVisibility: .visible) {
                Button("Save at Original Size — \(viewModel.exportResolutionLabel)") {
                    viewModel.saveToPhotos(upscale: false) { showExportedAlert = true }
                }
                Button("Upscale for Photos — sharper on device") {
                    viewModel.saveToPhotos(upscale: true) { showExportedAlert = true }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This image may appear blurry in your Photos library. You can upscale it for a sharper result, or keep the original size for use in editors and game engines.")
            }
            .confirmationDialog("Small Export Size (\(viewModel.exportResolutionLabel))", isPresented: $showShareSizeSheet, titleVisibility: .visible) {
                Button("Export at Original Size — \(viewModel.exportResolutionLabel)") {
                    viewModel.exportAndGetShareImage(upscale: false) { image in shareImage = image }
                }
                Button("Upscale for Sharing — sharper on device") {
                    viewModel.exportAndGetShareImage(upscale: true) { image in shareImage = image }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This image may appear blurry when shared. You can upscale it for a sharper result, or keep the original size for use in editors and game engines.")
            }
            .sheet(isPresented: $showProjectDetails) {
                ProjectDetailsPopupView(viewModel: viewModel).presentationDetents([.height(420)]).presentationDragIndicator(.visible)
            }
            .sheet(item: $shareImage) { item in ShareSheet(activityItems: [item.image]) }
            .sheet(isPresented: $showColorAdder) {
                ColorAdderSheetView(toolsVM: toolsVM).presentationDetents([.large]).presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showHelpSheet) {
                CanvasHelpSheetView().presentationDetents([.large]).presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsSheetView().presentationDetents([.large]).presentationDragIndicator(.visible)
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { onFinish?() }
                }
            } message: {
                Text("Great work on \"\(viewModel.projectName)\"!")
            }
            .sheet(isPresented: $showImportSheet) {
                ImportProjectSheetView(viewModel: viewModel).presentationDetents([.large]).presentationDragIndicator(.visible)
            }
            .alert("Pro Feature", isPresented: $showImportProAlert) {
                Button("Unlock Pro") { showStoreSheet = true }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Importing projects as layers is a Pro feature.")
            }
            .alert("Layer Limit Reached", isPresented: $showImportLayerLimitAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You already have \(LayerManagerViewModel.maxLayers) layers. Delete or merge a layer before importing.")
            }
            .sheet(isPresented: $showStoreSheet) {
                StoreView().presentationDetents([.large]).presentationDragIndicator(.visible)
            }
    }
}
