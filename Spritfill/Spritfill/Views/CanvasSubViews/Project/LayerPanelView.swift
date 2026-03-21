//
//  LayerPanelView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-20.
//

import SwiftUI

struct LayerPanelView: View {
    @ObservedObject var viewModel: CanvasViewModel
    var onClose: (() -> Void)? = nil
    
    @State private var showRenameAlert = false
    @State private var renameText = ""
    @State private var renameIndex = 0
    @State private var showDeleteAlert = false
    @State private var deleteIndex = 0
    
    // Drag-to-reorder state
    @State private var draggingLayerID: UUID? = nil
    @State private var dragOffset: CGFloat = 0
    
    // Height of each layer row for calculating swap thresholds
    private let rowHeight: CGFloat = 46
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Layers")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(viewModel.layers.count)/\(CanvasViewModel.maxLayers)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Button(action: { viewModel.addLayer() }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.caption)
                        .foregroundColor(viewModel.layers.count < CanvasViewModel.maxLayers ? .blue : .gray)
                }
                .disabled(viewModel.layers.count >= CanvasViewModel.maxLayers)
                
                Button(action: { onClose?() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            
            Divider()
            
            // Layer list (top = frontmost = highest index, bottom = background = index 0)
            ScrollView {
                VStack(spacing: 2) {
                    // Front indicator
                    Text("▲ Front")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.secondary.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 2)
                    
                    // We display reversed so top row = last element in array (frontmost)
                    ForEach(Array(viewModel.layers.enumerated().reversed()), id: \.element.id) { index, layer in
                        let isDragging = draggingLayerID == layer.id
                        
                        layerRow(layer: layer, index: index)
                            .zIndex(isDragging ? 1 : 0)
                            .offset(y: isDragging ? dragOffset : 0)
                            .scaleEffect(isDragging ? 1.03 : 1.0)
                            .opacity(isDragging ? 0.9 : 1.0)
                            .animation(.easeInOut(duration: 0.15), value: isDragging)
                    }
                    
                    // Back indicator
                    Text("▼ Back")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.secondary.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 2)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
        }
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
    
    private func layerRow(layer: CanvasViewModel.Layer, index: Int) -> some View {
        let isActive = index == viewModel.activeLayerIndex
        
        return HStack(spacing: 6) {
            // Drag handle
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .frame(width: 14)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if draggingLayerID == nil {
                                draggingLayerID = layer.id
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                            }
                            dragOffset = value.translation.height
                            
                            // Look up the current index of the dragged layer dynamically
                            // to avoid stale captured index after a swap.
                            guard let currentIndex = viewModel.layers.firstIndex(where: { $0.id == layer.id }) else { return }
                            
                            // The visual list is reversed: top of screen = highest index.
                            // Dragging UP (negative Y) in the visual list means moving to a HIGHER index.
                            // Dragging DOWN (positive Y) means moving to a LOWER index.
                            let threshold = rowHeight * 0.6
                            
                            if dragOffset < -threshold, currentIndex < viewModel.layers.count - 1 {
                                // Dragged up visually → move to higher index (toward front)
                                viewModel.moveLayer(from: currentIndex, to: currentIndex + 1)
                                dragOffset = 0
                            } else if dragOffset > threshold, currentIndex > 0 {
                                // Dragged down visually → move to lower index (toward back)
                                viewModel.moveLayer(from: currentIndex, to: currentIndex - 1)
                                dragOffset = 0
                            }
                        }
                        .onEnded { _ in
                            draggingLayerID = nil
                            dragOffset = 0
                        }
                )
            
            // Visibility toggle
            Button(action: { viewModel.toggleLayerVisibility(at: index) }) {
                Image(systemName: layer.isVisible ? "eye.fill" : "eye.slash")
                    .font(.caption2)
                    .foregroundColor(layer.isVisible ? .blue : .gray)
                    .frame(width: 18)
            }
            .buttonStyle(.plain)
            
            // Layer thumbnail (tiny bitmap preview)
            layerThumbnail(hexes: layer.pixelHexes)
                .frame(width: 28, height: 28)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isActive ? Color.blue : Color.clear, lineWidth: 2)
                )
            
            // Name + opacity
            VStack(alignment: .leading, spacing: 1) {
                Text(layer.name)
                    .font(.caption2)
                    .fontWeight(isActive ? .semibold : .regular)
                    .lineLimit(1)
                
                if layer.opacity < 1.0 {
                    Text("\(Int(layer.opacity * 100))%")
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
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
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 6)
        .frame(height: rowHeight)
        .background(isActive ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(8)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.switchToLayer(at: index)
        }
    }
    
    // MARK: - Tiny Layer Thumbnail (bitmap-based for speed)
    
    private func layerThumbnail(hexes: [String]) -> some View {
        let gridWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
        let gridHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height
        let image = renderLayerThumbnail(hexes: hexes, gridWidth: gridWidth, gridHeight: gridHeight)
        
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
    
    // Renders a layer's pixel data + checkerboard into a tiny CGImage bitmap.
    // Pure byte-level operations — no SwiftUI Path fills, no Color conversions.
    private func renderLayerThumbnail(hexes: [String], gridWidth: Int, gridHeight: Int) -> UIImage? {
        let w = gridWidth, h = gridHeight
        guard w > 0, h > 0 else { return nil }
        
        let lightGray: UInt8 = 235
        let darkGray: UInt8 = 215
        
        var buffer = [UInt8](repeating: 255, count: w * h * 4)
        
        for i in 0..<min(hexes.count, w * h) {
            let bi = i * 4
            let hex = hexes[i]
            
            if hex != "clear" {
                // Parse hex directly to RGB bytes
                var str = hex
                if str.hasPrefix("#") { str = String(str.dropFirst()) }
                if str.count >= 6 {
                    var val: UInt32 = 0
                    for byte in str.utf8.prefix(6) {
                        val <<= 4
                        switch byte {
                        case 0x30...0x39: val |= UInt32(byte - 0x30)
                        case 0x41...0x46: val |= UInt32(byte - 0x41 + 10)
                        case 0x61...0x66: val |= UInt32(byte - 0x61 + 10)
                        default: break
                        }
                    }
                    buffer[bi]     = UInt8((val >> 16) & 0xFF)
                    buffer[bi + 1] = UInt8((val >> 8) & 0xFF)
                    buffer[bi + 2] = UInt8(val & 0xFF)
                }
            } else {
                // Checkerboard
                let row = i / w, col = i % w
                let gray = (row + col) % 2 == 0 ? lightGray : darkGray
                buffer[bi] = gray; buffer[bi + 1] = gray; buffer[bi + 2] = gray
            }
            buffer[bi + 3] = 255
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(
            data: &buffer, width: w, height: h,
            bitsPerComponent: 8, bytesPerRow: w * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ), let cgImage = ctx.makeImage() else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
