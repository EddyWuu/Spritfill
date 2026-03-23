//
//  ProjectViewMode.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-16.
//

import SwiftUI

struct ProjectViewModeView: View {
    
    @ObservedObject var viewModel: CanvasViewModel
    @StateObject private var projectManager = ProjectManagerViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var onEdit: (() -> Void)? = nil
    
    @State private var showDeleteAlert = false
    @State private var showEditAlert = false
    @State private var shareImage: IdentifiableImage? = nil
    @State private var showSavedAlert = false
    @State private var showSaveSizeSheet = false
    @State private var showShareSizeSheet = false
    @State private var showProjectDetails = false
    @State private var showSubmitSheet = false
    
    @State private var zoomScale: CGFloat = 1.0
    @State private var panOffset: CGSize = .zero
    @State private var lastPanOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                
                // MARK: - Top nav bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                    }
                    
                    Spacer()
                    
                    Text(viewModel.projectName)
                        .font(.headline)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                
                Divider()
                
                // MARK: - Canvas (no grid lines, no checkerboard)
                canvasDisplay(availableSize: geo.size)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                
                Divider()
                
                // MARK: - Action buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        actionButton(icon: "info.circle", label: "Details", color: .blue) {
                            showProjectDetails = true
                        }
                        
                        actionButton(icon: "square.and.arrow.down", label: "Save", color: .green) {
                            if viewModel.exportNeedsUpscale {
                                showSaveSizeSheet = true
                            } else {
                                viewModel.saveToPhotos(upscale: false) {
                                    showSavedAlert = true
                                }
                            }
                        }
                        
                        actionButton(icon: "square.and.arrow.up", label: "Export", color: .indigo) {
                            if viewModel.exportNeedsUpscale {
                                showShareSizeSheet = true
                            } else {
                                viewModel.exportAndGetShareImage { image in
                                    shareImage = image
                                }
                            }
                        }
                        
                        actionButton(icon: "paperplane.fill", label: "Submit", color: .purple) {
                            showSubmitSheet = true
                        }
                        
                        actionButton(icon: "pencil.circle", label: "Edit", color: .orange) {
                            showEditAlert = true
                        }
                        
                        actionButton(icon: "trash", label: "Delete", color: .red) {
                            showDeleteAlert = true
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
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
        .alert("Delete this project?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                let data = viewModel.toProjectData()
                projectManager.delete(data)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
        .alert("Edit this project?", isPresented: $showEditAlert) {
            Button("Edit") {
                viewModel.isFinished = false
                viewModel.flushSave()
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onEdit?()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will move \"\(viewModel.projectName)\" back to In Progress for editing.")
        }
        .alert("Saved!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Image saved to Photos!")
        }
        .confirmationDialog(
            "Small Export Size (\(viewModel.exportResolutionLabel))",
            isPresented: $showSaveSizeSheet,
            titleVisibility: .visible
        ) {
            Button("Save at Original Size — \(viewModel.exportResolutionLabel)") {
                viewModel.saveToPhotos(upscale: false) {
                    showSavedAlert = true
                }
            }
            Button("Upscale for Photos — sharper on device") {
                viewModel.saveToPhotos(upscale: true) {
                    showSavedAlert = true
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This image may appear blurry in your Photos library. You can upscale it for a sharper result, or keep the original size for use in editors and game engines.")
        }
        .confirmationDialog(
            "Small Export Size (\(viewModel.exportResolutionLabel))",
            isPresented: $showShareSizeSheet,
            titleVisibility: .visible
        ) {
            Button("Export at Original Size — \(viewModel.exportResolutionLabel)") {
                viewModel.exportAndGetShareImage(upscale: false) { image in
                    shareImage = image
                }
            }
            Button("Upscale for Sharing — sharper on device") {
                viewModel.exportAndGetShareImage(upscale: true) { image in
                    shareImage = image
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This image may appear blurry when shared. You can upscale it for a sharper result, or keep the original size for use in editors and game engines.")
        }
        .sheet(item: $shareImage) { item in
            ShareSheet(activityItems: [item.image])
        }
        .sheet(isPresented: $showProjectDetails) {
            ProjectDetailsPopupView(viewModel: viewModel)
                .presentationDetents([.height(420)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showSubmitSheet) {
            SubmitArtView(viewModel: viewModel)
        }
    }
    
    // MARK: - Action button
    
    private func actionButton(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(color)
            .frame(width: 72, height: 64)
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Canvas display (no grid lines)
    
    private func canvasDisplay(availableSize: CGSize) -> some View {
        let gridWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
        let gridHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height
        
        let fitScale = min(availableSize.width * 0.9 / CGFloat(gridWidth),
                           (availableSize.height * 0.8) * 0.9 / CGFloat(gridHeight))
        
        let displayWidth = CGFloat(gridWidth) * fitScale * zoomScale
        let displayHeight = CGFloat(gridHeight) * fitScale * zoomScale
        let cellSize = fitScale * zoomScale
        let compositeHexes = viewModel.compositePixelHexes()
        
        return Canvas { context, size in
            for row in 0..<gridHeight {
                for col in 0..<gridWidth {
                    let index = row * gridWidth + col
                    let hex = index < compositeHexes.count ? compositeHexes[index] : "clear"
                    guard hex != "clear" else { continue }
                    // Use floor/ceil to snap to pixel boundaries and avoid subpixel gaps
                    let x = floor(CGFloat(col) * cellSize)
                    let y = floor(CGFloat(row) * cellSize)
                    let nextX = floor(CGFloat(col + 1) * cellSize)
                    let nextY = floor(CGFloat(row + 1) * cellSize)
                    let rect = CGRect(x: x, y: y, width: nextX - x, height: nextY - y)
                    context.fill(Path(rect), with: .color(Color(hex: hex)))
                }
            }
        }
        .frame(width: displayWidth, height: displayHeight)
        .offset(panOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    panOffset = CGSize(
                        width: lastPanOffset.width + value.translation.width,
                        height: lastPanOffset.height + value.translation.height
                    )
                }
                .onEnded { _ in
                    lastPanOffset = panOffset
                }
        )
        .gesture(
            MagnificationGesture()
                .onChanged { scale in
                    zoomScale = max(0.5, min(scale, 5.0))
                }
        )
    }
}
