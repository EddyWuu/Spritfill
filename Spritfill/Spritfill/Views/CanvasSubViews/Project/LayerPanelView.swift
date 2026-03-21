//
//  LayerPanelView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-20.
//

import SwiftUI

struct LayerPanelView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @ObservedObject var layerManager: LayerManagerViewModel
    var onClose: (() -> Void)? = nil
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    @State private var showRenameAlert = false
    @State private var renameText = ""
    @State private var renameIndex = 0
    @State private var showDeleteAlert = false
    @State private var deleteIndex = 0
    
    // Drag-to-reorder state
    @State private var draggingLayerID: UUID? = nil
    @State private var dragOffset: CGFloat = 0
    
    // Adaptive sizing
    private var isCompact: Bool { sizeClass != .regular }
    private var rowHeight: CGFloat { isCompact ? 50 : 60 }
    private var thumbnailSize: CGFloat { isCompact ? 30 : 36 }
    private var rowSpacing: CGFloat { isCompact ? 8 : 10 }
    private var rowVPadding: CGFloat { isCompact ? 6 : 8 }
    
    // Dynamic panel height: header (~44) + front/back labels (~36) + rows + padding
    private var dynamicHeight: CGFloat {
        let headerHeight: CGFloat = isCompact ? 38 : 44
        let indicatorHeight: CGFloat = isCompact ? 28 : 36
        let rowsHeight = CGFloat(viewModel.layers.count) * (rowHeight + 4)
        let padding: CGFloat = 12
        return headerHeight + indicatorHeight + rowsHeight + padding
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Layers")
                    .font(isCompact ? .caption : .subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(viewModel.layers.count)/\(CanvasViewModel.maxLayers)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Button(action: { viewModel.addLayer() }) {
                    Image(systemName: "plus.circle.fill")
                        .font(isCompact ? .subheadline : .body)
                        .foregroundColor(viewModel.layers.count < CanvasViewModel.maxLayers ? .blue : .gray)
                }
                .disabled(viewModel.layers.count >= CanvasViewModel.maxLayers)
                
                Button(action: { onClose?() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(isCompact ? .subheadline : .body)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, isCompact ? 10 : 14)
            .padding(.vertical, isCompact ? 6 : 10)
            
            Divider()
            
            // Layer list (top = frontmost = highest index, bottom = background = index 0)
            ScrollView {
                VStack(spacing: 4) {
                    // Front indicator
                    Text("▲ Front")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 2)
                    
                    // We display reversed so top row = last element in array (frontmost)
                    ForEach(Array(viewModel.layers.enumerated().reversed()), id: \.element.id) { index, layer in
                        let isDragging = draggingLayerID == layer.id
                        
                        layerRow(layer: layer, index: index)
                            .zIndex(isDragging ? 1 : 0)
                            .offset(y: isDragging ? dragOffset : 0)
                            .scaleEffect(isDragging ? 1.05 : 1.0)
                            .opacity(isDragging ? 0.85 : 1.0)
                            .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.8), value: isDragging)
                    }
                    
                    // Back indicator
                    Text("▼ Back")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 2)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
            }
            .scrollDisabled(draggingLayerID != nil)
        }
        .frame(height: dynamicHeight)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .alert("Rename Layer", isPresented: $showRenameAlert) {
            TextField("Layer name", text: $renameText)
            Button("Save") {
                if !renameText.trimmingCharacters(in: .whitespaces).isEmpty {
                    viewModel.renameLayer(at: renameIndex, to: renameText)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .alert("Delete Layer?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteLayer(at: deleteIndex)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            if deleteIndex >= 0, deleteIndex < viewModel.layers.count {
                Text("This layer has content on it. Are you sure you want to delete \"\(viewModel.layers[deleteIndex].name)\"?")
            }
        }
    }
    
    // MARK: - Layer Row
    
    private func layerRow(layer: LayerManagerViewModel.Layer, index: Int) -> some View {
        let isActive = index == viewModel.activeLayerIndex
        
        return HStack(spacing: rowSpacing) {
            // Drag handle
            Image(systemName: "line.3.horizontal")
                .font(.system(size: isCompact ? 14 : 16, weight: .medium))
                .foregroundColor(draggingLayerID == layer.id ? .blue : .gray)
                .frame(width: isCompact ? 22 : 28, height: 44)
                .contentShape(Rectangle())
                .highPriorityGesture(
                    DragGesture(minimumDistance: 4)
                        .onChanged { value in
                            if draggingLayerID == nil {
                                draggingLayerID = layer.id
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                            }
                            // Only track vertical movement
                            dragOffset = value.translation.height
                            
                            guard let currentIndex = viewModel.layers.firstIndex(where: { $0.id == layer.id }) else { return }
                            
                            let threshold = rowHeight * 0.6
                            
                            if dragOffset < -threshold, currentIndex < viewModel.layers.count - 1 {
                                viewModel.moveLayer(from: currentIndex, to: currentIndex + 1)
                                dragOffset = 0
                                let swap = UIImpactFeedbackGenerator(style: .light)
                                swap.impactOccurred()
                            } else if dragOffset > threshold, currentIndex > 0 {
                                viewModel.moveLayer(from: currentIndex, to: currentIndex - 1)
                                dragOffset = 0
                                let swap = UIImpactFeedbackGenerator(style: .light)
                                swap.impactOccurred()
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.interactiveSpring(response: 0.25, dampingFraction: 0.8)) {
                                draggingLayerID = nil
                                dragOffset = 0
                            }
                        }
                )
            
            // Visibility toggle
            Button(action: { viewModel.toggleLayerVisibility(at: index) }) {
                Image(systemName: layer.isVisible ? "eye.fill" : "eye.slash")
                    .font(isCompact ? .caption : .subheadline)
                    .foregroundColor(layer.isVisible ? .blue : .gray)
                    .frame(width: isCompact ? 20 : 24, height: 44)
            }
            .buttonStyle(.plain)
            
            // Layer thumbnail
            layerThumbnail(hexes: layer.pixelHexes)
                .frame(width: thumbnailSize, height: thumbnailSize)
                .cornerRadius(isCompact ? 4 : 5)
                .overlay(
                    RoundedRectangle(cornerRadius: isCompact ? 4 : 5)
                        .stroke(isActive ? Color.blue : Color.clear, lineWidth: 2)
                )
            
            // Name + opacity — compact on iPhone, full on iPad
            if isCompact {
                Text(layer.name)
                    .font(.caption2)
                    .fontWeight(isActive ? .semibold : .regular)
                    .lineLimit(1)
                    .foregroundColor(isActive ? .primary : .secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    Text(layer.name)
                        .font(.caption)
                        .fontWeight(isActive ? .semibold : .regular)
                        .lineLimit(1)
                    
                    if layer.opacity < 1.0 {
                        Text("\(Int(layer.opacity * 100))%")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Context menu actions
            Menu {
                Button(action: {
                    renameIndex = index
                    renameText = layer.name
                    showRenameAlert = true
                }) {
                    Label("Rename", systemImage: "pencil")
                }
                
                Button(action: { viewModel.duplicateLayer(at: index) }) {
                    Label("Duplicate", systemImage: "plus.square.on.square")
                }
                .disabled(viewModel.layers.count >= CanvasViewModel.maxLayers)
                
                if index > 0 {
                    Button(action: { viewModel.mergeDown(at: index) }) {
                        Label("Merge Down", systemImage: "arrow.down.forward.and.arrow.up.backward")
                    }
                }
                
                // Move Up = toward front = higher index
                if index < viewModel.layers.count - 1 {
                    Button(action: { viewModel.moveLayer(from: index, to: index + 1) }) {
                        Label("Move Up", systemImage: "arrow.up")
                    }
                }
                
                // Move Down = toward back = lower index
                if index > 0 {
                    Button(action: { viewModel.moveLayer(from: index, to: index - 1) }) {
                        Label("Move Down", systemImage: "arrow.down")
                    }
                }
                
                Divider()
                
                Button(role: .destructive, action: {
                    let hasContent = viewModel.layers[index].pixelHexes.contains(where: { $0 != "clear" })
                    if hasContent && viewModel.layers.count > 1 {
                        deleteIndex = index
                        showDeleteAlert = true
                    } else {
                        viewModel.deleteLayer(at: index)
                    }
                }) {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(viewModel.layers.count <= 1)
            } label: {
                Image(systemName: "ellipsis")
                    .font(isCompact ? .caption : .subheadline)
                    .foregroundColor(.secondary)
                    .frame(width: isCompact ? 24 : 28, height: isCompact ? 24 : 28)
            }
        }
        .padding(.horizontal, isCompact ? 6 : 10)
        .padding(.vertical, rowVPadding)
        .frame(height: rowHeight)
        .background(isActive ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(10)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.switchToLayer(at: index)
        }
    }
    
    // MARK: - Tiny Layer Thumbnail (delegated to LayerManagerViewModel)
    
    private func layerThumbnail(hexes: [String]) -> some View {
        let gridWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
        let gridHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height
        let image = layerManager.renderLayerThumbnail(hexes: hexes, gridWidth: gridWidth, gridHeight: gridHeight)
        
        return Group {
            if let image {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
            } else {
                Color(.systemGray5)
            }
        }
    }
}
