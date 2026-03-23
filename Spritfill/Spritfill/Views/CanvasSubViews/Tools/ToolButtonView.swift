//
//  ToolButtonView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-25.
//

import SwiftUI

struct ToolButtonView: View {
    
    let tool: ToolsViewModel.ToolType
    @ObservedObject var toolsVM: ToolsViewModel
    @State private var showBrushPicker = false
    @State private var showFillPicker = false
    @State private var longPressTriggered = false

    var body: some View {
        let isSelected = toolsVM.isSelected(tool: tool)
        let isBrushTool = (tool == .pencil || tool == .eraser)
        let isFillTool = (tool == .fill)
        let toolBrushSize = toolsVM.brushSize(for: tool)
        let hasBrushSize = isBrushTool && toolBrushSize > 1
        
        let button = Button(action: {
            // Skip if long press just opened a picker
            if longPressTriggered {
                longPressTriggered = false
                return
            }
            
            if isSelected {
                // Already selected — open options popover if this tool has one
                if isBrushTool {
                    showBrushPicker.toggle()
                } else if isFillTool {
                    showFillPicker.toggle()
                }
            } else if isBrushTool && showBrushPicker {
                showBrushPicker = false
            } else if isFillTool && showFillPicker {
                showFillPicker = false
            } else {
                toolsVM.selectTool(tool)
            }
        }) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: isFillTool && toolsVM.fillEraseMode ? "drop.halffull" : tool.iconName)
                    .font(.body)
                    .foregroundColor(isSelected ? .blue : .primary)
                    .padding(10)
                    .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
                    .clipShape(Circle())
                
                // Brush size badge (only for pencil/eraser when > 1)
                if hasBrushSize {
                    Text("\(toolBrushSize)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 14, height: 14)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .offset(x: 2, y: -2)
                }
                
                // Fill erase badge
                if isFillTool && toolsVM.fillEraseMode {
                    Image(systemName: "xmark")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 14, height: 14)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 2, y: -2)
                }
            }
        }
        
        // Attach long-press + popover to pencil, eraser, and fill
        if isBrushTool {
            button
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.4)
                        .onEnded { _ in
                            longPressTriggered = true
                            toolsVM.selectTool(tool)
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            showBrushPicker = true
                        }
                )
                .popover(isPresented: $showBrushPicker, arrowEdge: .top) {
                    BrushSizePickerView(toolsVM: toolsVM, tool: tool)
                        .presentationCompactAdaptation(.popover)
                }
        } else if isFillTool {
            button
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.4)
                        .onEnded { _ in
                            longPressTriggered = true
                            toolsVM.selectTool(tool)
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            showFillPicker = true
                        }
                )
                .popover(isPresented: $showFillPicker, arrowEdge: .top) {
                    FillModePickerView(toolsVM: toolsVM)
                        .presentationCompactAdaptation(.popover)
                }
        } else {
            button
        }
    }
}

// MARK: - Fill Mode Picker Popover

private struct FillModePickerView: View {
    @ObservedObject var toolsVM: ToolsViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Fill Mode")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            VStack(spacing: 6) {
                Button(action: {
                    toolsVM.fillEraseMode = false
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "drop.halffull")
                            .font(.body)
                            .frame(width: 24)
                        Text("Fill Color")
                            .font(.subheadline)
                        Spacer()
                        if !toolsVM.fillEraseMode {
                            Image(systemName: "checkmark")
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                    }
                    .foregroundColor(!toolsVM.fillEraseMode ? .white : .primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(!toolsVM.fillEraseMode ? Color.blue : Color(.systemGray5))
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    toolsVM.fillEraseMode = true
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "eraser")
                            .font(.body)
                            .frame(width: 24)
                        Text("Fill Erase")
                            .font(.subheadline)
                        Spacer()
                        if toolsVM.fillEraseMode {
                            Image(systemName: "checkmark")
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                    }
                    .foregroundColor(toolsVM.fillEraseMode ? .white : .primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(toolsVM.fillEraseMode ? Color.red : Color(.systemGray5))
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .frame(width: 180)
    }
}

// MARK: - Brush Size Picker Popover

private struct BrushSizePickerView: View {
    @ObservedObject var toolsVM: ToolsViewModel
    let tool: ToolsViewModel.ToolType
    
    private var currentSize: Int {
        toolsVM.brushSize(for: tool)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Brush Size")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            HStack(spacing: 6) {
                ForEach(1...5, id: \.self) { size in
                    let isSelected = currentSize == size
                    Button(action: {
                        switch tool {
                        case .pencil: toolsVM.pencilBrushSize = size
                        case .eraser: toolsVM.eraserBrushSize = size
                        default: break
                        }
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(isSelected ? Color.blue : Color(.systemGray5))
                                .frame(width: 36, height: 36)
                            
                            // Visual grid showing the NxN size — proportionally sized
                            brushPreview(size: size, isSelected: isSelected)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Text("\(currentSize)×\(currentSize)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(12)
    }
    
    // Draws NxN filled squares at a constant cell size within a 5×5 grid area, centered.
    private func brushPreview(size: Int, isSelected: Bool) -> some View {
        Canvas { context, canvasSize in
            // Each cell is 1/5 of the canvas — so a 1×1 brush is small, 5×5 fills everything
            let cellSize = canvasSize.width / 5.0
            let totalSize = CGFloat(size) * cellSize
            let offsetX = (canvasSize.width - totalSize) / 2.0
            let offsetY = (canvasSize.height - totalSize) / 2.0
            
            for r in 0..<size {
                for c in 0..<size {
                    let rect = CGRect(
                        x: offsetX + CGFloat(c) * cellSize,
                        y: offsetY + CGFloat(r) * cellSize,
                        width: cellSize - 0.5,
                        height: cellSize - 0.5
                    )
                    context.fill(Path(rect), with: .color(isSelected ? .white : .blue))
                }
            }
        }
    }
}
