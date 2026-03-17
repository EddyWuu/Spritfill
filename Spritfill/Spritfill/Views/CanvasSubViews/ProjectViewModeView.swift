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
    @State private var showProjectDetails = false
    
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
                            viewModel.exportAndSaveToPhotos {
                                showSavedAlert = true
                            }
                        }
                        
                        actionButton(icon: "square.and.arrow.up", label: "Share", color: .indigo) {
                            viewModel.exportAndGetShareImage { image in
                                shareImage = image
                            }
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
                projectManager.save(viewModel)
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
        .sheet(item: $shareImage) { item in
            ShareSheet(activityItems: [item.image])
        }
        .sheet(isPresented: $showProjectDetails) {
            ProjectDetailsPopupView(viewModel: viewModel)
                .presentationDetents([.height(360)])
                .presentationDragIndicator(.visible)
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
        
        return Canvas { context, size in
            for row in 0..<gridHeight {
                for col in 0..<gridWidth {
                    let color = viewModel.pixels[row * gridWidth + col]
                    guard color != .clear else { continue }
                    let rect = CGRect(
                        x: CGFloat(col) * cellSize,
                        y: CGFloat(row) * cellSize,
                        width: cellSize,
                        height: cellSize
                    )
                    context.fill(Path(rect), with: .color(color))
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
