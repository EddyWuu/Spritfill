//
//  SelectControlView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-04-02.
//

import SwiftUI

// Bottom panel shown when the Select tool is active.
// Always shows brush size + mode picker at the top.
// When pixels are selected, shows shift arrows + action buttons below.
struct SelectControlView: View {
    
    @ObservedObject var canvasVM: CanvasViewModel
    @ObservedObject var toolsVM: ToolsViewModel
    @ObservedObject private var storeService = StoreService.shared
    @State private var showLayerLimitAlert = false
    @State private var showMoveProAlert = false
    @State private var showStoreSheet = false
    @State private var showMoveSuccessAlert = false
    
    var body: some View {
        VStack(spacing: 8) {
            // MARK: - Selection options (always visible)
            selectionOptionsBar
            
            Divider()
            
            if canvasVM.hasSelection {
                // MARK: - Shift controls + actions
                selectionShiftControls
            } else {
                // No selection yet — hint
                VStack(spacing: 4) {
                    Image(systemName: "lasso")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Text(toolsVM.selectFillMode
                         ? "Tap to fill inside picked boundary"
                         : "Drag on the canvas to pick pixels")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
        .alert("Layer Limit Reached", isPresented: $showLayerLimitAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You already have \(LayerManagerViewModel.maxLayers) layers. Delete or merge a layer before moving the selection.")
        }
        .alert("Pro Feature", isPresented: $showMoveProAlert) {
            Button("Unlock Pro") { showStoreSheet = true }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Free users can have up to \(StoreProducts.freeLayerLimit) layers. Upgrade to Pro to add more.")
        }
        .alert("Moved to Layer ✓", isPresented: $showMoveSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The selected pixels have been moved to a new \"Selection\" layer.")
        }
        .sheet(isPresented: $showStoreSheet) {
            StoreView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: - Selection Options Bar (brush size + mode)
    
    @ViewBuilder
    private var selectionOptionsBar: some View {
        HStack(spacing: 12) {
            // Mode picker: Pick / Fill
            HStack(spacing: 4) {
                modeButton(label: "Pick", icon: "lasso", isActive: !toolsVM.selectFillMode) {
                    toolsVM.selectFillMode = false
                }
                modeButton(label: "Fill", icon: "drop.halffull", isActive: toolsVM.selectFillMode) {
                    toolsVM.selectFillMode = true
                }
            }
            
            // Divider
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 24)
            
            // Brush size picker
            HStack(spacing: 4) {
                Text("Size")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                ForEach(1...5, id: \.self) { size in
                    let isActive = toolsVM.selectBrushSize == size
                    Button(action: {
                        toolsVM.selectBrushSize = size
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        Text("\(size)")
                            .font(.system(size: 11, weight: .semibold))
                            .frame(width: 26, height: 26)
                            .foregroundColor(isActive ? .white : .primary)
                            .background(isActive ? Color.blue : Color(.tertiarySystemBackground))
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 12)
    }
    
    // MARK: - Shift Controls + Action Buttons
    
    @ViewBuilder
    private var selectionShiftControls: some View {
        // Offset label
        let dR = canvasVM.selectionOffset.dRow
        let dC = canvasVM.selectionOffset.dCol
        if dR != 0 || dC != 0 {
            Text("Offset: \(dC > 0 ? "+" : "")\(dC), \(dR > 0 ? "+" : "")\(dR)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        
        // Arrow pad
        VStack(spacing: 4) {
            arrowButton(direction: .up, icon: "chevron.up")
            HStack(spacing: 4) {
                arrowButton(direction: .left, icon: "chevron.left")
                Color.clear.frame(width: 38, height: 38)
                arrowButton(direction: .right, icon: "chevron.right")
            }
            arrowButton(direction: .down, icon: "chevron.down")
        }
        
        // Action buttons
        HStack(spacing: 10) {
            Button(action: { canvasVM.confirmSelection() }) {
                Label("Confirm", systemImage: "checkmark")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .cornerRadius(8)
            }
            
            Button(action: { canvasVM.cancelSelection() }) {
                Label("Cancel", systemImage: "xmark")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.2))
                    .foregroundColor(.red)
                    .cornerRadius(8)
            }
            
            Button(action: {
                let freeLimit = StoreProducts.freeLayerLimit
                if !storeService.isPro && canvasVM.layers.count >= freeLimit {
                    showMoveProAlert = true
                } else if canvasVM.layers.count >= LayerManagerViewModel.maxLayers {
                    showLayerLimitAlert = true
                } else {
                    if let _ = canvasVM.moveSelectionToNewLayer() {
                        showLayerLimitAlert = true
                    } else {
                        showMoveSuccessAlert = true
                    }
                }
            }) {
                Label("To Layer", systemImage: "square.3.layers.3d")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func modeButton(label: String, icon: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.caption2)
                Text(label)
                    .font(.caption2.weight(.medium))
            }
            .foregroundColor(isActive ? .white : .primary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isActive ? (label == "Fill" ? Color.cyan : Color.blue) : Color(.tertiarySystemBackground))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
    
    private func arrowButton(direction: CanvasViewModel.ShiftDirection, icon: String) -> some View {
        Button(action: {
            canvasVM.shiftSelection(direction)
        }) {
            Image(systemName: icon)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(width: 38, height: 38)
                .foregroundColor(.primary)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(8)
        }
    }
}
