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
    @State private var showShapePicker = false
    @State private var longPressTriggered = false
    
    // Pro gating
    @ObservedObject private var storeService = StoreService.shared
    @State private var showProAlert = false
    @State private var showStoreSheet = false
    
    let bottomPanelCollapsed: Bool

    var body: some View {
        let isSelected = toolsVM.isSelected(tool: tool)
        let isBrushTool = (tool == .pencil || tool == .eraser)
        let isFillTool = (tool == .fill)
        let hasOptions = isBrushTool || isFillTool || tool == .rectangle || tool == .circle || tool == .line
        let toolBrushSize = toolsVM.brushSize(for: tool)
        let hasBrushSize = isBrushTool && toolBrushSize > 1
        
        let needsPro = StoreProducts.toolRequiresPro(tool) && !storeService.isPro
        
        let button = Button(action: {
            // Skip if long press just opened a picker
            if longPressTriggered {
                longPressTriggered = false
                return
            }
            
            // Pro gating — show alert instead of selecting
            if needsPro {
                showProAlert = true
                return
            }
            
            if isSelected && hasOptions {
                // Already selected — open options popover
                if isBrushTool {
                    showBrushPicker.toggle()
                } else if isFillTool {
                    showFillPicker.toggle()
                } else {
                    showShapePicker.toggle()
                }
            } else if !isSelected {
                toolsVM.selectTool(tool)
            }
        }) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: toolIconName)
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
                
                // Filled mode badge for rectangle/circle
                if (tool == .rectangle && toolsVM.rectangleFilled) ||
                   (tool == .circle && toolsVM.circleFilled) {
                    Image(systemName: "square.fill")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 14, height: 14)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .offset(x: 2, y: -2)
                }
                
                // Thickness badge for line/rectangle outline/circle outline when > 1
                if thicknessBadgeValue > 1 {
                    Text("\(thicknessBadgeValue)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 14, height: 14)
                        .background(Color.purple)
                        .clipShape(Circle())
                        .offset(x: 2, y: -2)
                }
                
                // Pro lock badge for gated tools
                if needsPro {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 14, height: 14)
                        .background(Color.yellow)
                        .clipShape(Circle())
                        .offset(x: 2, y: -2)
                }
            }
        }
        
        // Determine arrow edge based on whether bottom panel is collapsed
        // When collapsed, popovers appear above (arrowEdge: .bottom)
        // When expanded, popovers appear below (arrowEdge: .top)
        let arrowEdge: Edge = bottomPanelCollapsed ? .bottom : .top
        
        // Attach long-press + popover
        Group {
        if isBrushTool {
            button
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.4)
                        .onEnded { _ in
                            longPressTriggered = true
                            toolsVM.selectTool(tool)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            showBrushPicker = true
                        }
                )
                .popover(isPresented: $showBrushPicker, arrowEdge: arrowEdge) {
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
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            showFillPicker = true
                        }
                )
                .popover(isPresented: $showFillPicker, arrowEdge: arrowEdge) {
                    FillModePickerView(toolsVM: toolsVM)
                        .presentationCompactAdaptation(.popover)
                }
        } else if tool == .rectangle || tool == .circle || tool == .line {
            button
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.4)
                        .onEnded { _ in
                            longPressTriggered = true
                            toolsVM.selectTool(tool)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            showShapePicker = true
                        }
                )
                .popover(isPresented: $showShapePicker, arrowEdge: arrowEdge) {
                    shapeOptionsPopover
                        .presentationCompactAdaptation(.popover)
                }
        } else {
            button
        }
        }
        .alert("Pro Feature", isPresented: $showProAlert) {
            Button("Unlock Pro") { showStoreSheet = true }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("The \(tool.displayName) tool requires Spritfill Pro. Unlock Pro to access all tools.")
        }
        .sheet(isPresented: $showStoreSheet) {
            StoreView()
        }
    }
    
    // Thickness badge value — only show for outline modes
    private var thicknessBadgeValue: Int {
        switch tool {
        case .line: return toolsVM.lineThickness
        case .rectangle: return toolsVM.rectangleFilled ? 1 : toolsVM.rectangleThickness
        case .circle: return toolsVM.circleFilled ? 1 : toolsVM.circleThickness
        default: return 1
        }
    }
    
    // Dynamic icon name for tools with mode variants
    private var toolIconName: String {
        switch tool {
        case .fill:
            return toolsVM.fillEraseMode ? "drop.halffull" : "drop.halffull"
        case .rectangle:
            return toolsVM.rectangleFilled ? "rectangle.fill" : "rectangle"
        case .circle:
            return toolsVM.circleFilled ? "circle.fill" : "circle"
        default:
            return tool.iconName
        }
    }
    
    // Shape options popover content
    @ViewBuilder
    private var shapeOptionsPopover: some View {
        switch tool {
        case .line:
            LineOptionsView(toolsVM: toolsVM)
        case .rectangle:
            RectangleOptionsView(toolsVM: toolsVM)
        case .circle:
            CircleOptionsView(toolsVM: toolsVM)
        default:
            EmptyView()
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

// MARK: - Thickness Picker Row (shared by line, rectangle outline, circle outline)

private struct ThicknessPickerRow: View {
    @Binding var thickness: Int
    
    var body: some View {
        VStack(spacing: 6) {
            Text("Thickness")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            HStack(spacing: 6) {
                ForEach(1...5, id: \.self) { size in
                    let isSelected = thickness == size
                    Button(action: {
                        thickness = size
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(isSelected ? Color.purple : Color(.systemGray5))
                                .frame(width: 36, height: 36)
                            // Horizontal bar whose height visually represents the thickness
                            Rectangle()
                                .fill(isSelected ? Color.white : Color.purple)
                                .frame(width: 20, height: CGFloat(size) * 2.5)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Text("\(thickness)px")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Line Options Popover

private struct LineOptionsView: View {
    @ObservedObject var toolsVM: ToolsViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            ThicknessPickerRow(thickness: $toolsVM.lineThickness)
        }
        .padding(12)
        .frame(width: 220)
    }
}

// MARK: - Rectangle Options Popover

private struct RectangleOptionsView: View {
    @ObservedObject var toolsVM: ToolsViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Rectangle Mode")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            VStack(spacing: 6) {
                optionButton(title: "Outline", icon: "rectangle", isActive: !toolsVM.rectangleFilled) {
                    toolsVM.rectangleFilled = false
                }
                optionButton(title: "Filled", icon: "rectangle.fill", isActive: toolsVM.rectangleFilled) {
                    toolsVM.rectangleFilled = true
                }
            }
            
            Divider()
            
            ThicknessPickerRow(thickness: $toolsVM.rectangleThickness)
                .disabled(toolsVM.rectangleFilled)
                .opacity(toolsVM.rectangleFilled ? 0.35 : 1)
        }
        .padding(12)
        .frame(width: 220)
    }
}

// MARK: - Circle Options Popover

private struct CircleOptionsView: View {
    @ObservedObject var toolsVM: ToolsViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Circle Mode")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            VStack(spacing: 6) {
                optionButton(title: "Outline", icon: "circle", isActive: !toolsVM.circleFilled) {
                    toolsVM.circleFilled = false
                }
                optionButton(title: "Filled", icon: "circle.fill", isActive: toolsVM.circleFilled) {
                    toolsVM.circleFilled = true
                }
            }
            
            Divider()
            
            ThicknessPickerRow(thickness: $toolsVM.circleThickness)
                .disabled(toolsVM.circleFilled)
                .opacity(toolsVM.circleFilled ? 0.35 : 1)
        }
        .padding(12)
        .frame(width: 220)
    }
}

// MARK: - Shared Option Button Helper

private func optionButton(title: String, icon: String, isActive: Bool, action: @escaping () -> Void) -> some View {
    Button(action: {
        action()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }) {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.body)
                .frame(width: 24)
            Text(title)
                .font(.subheadline)
            Spacer()
            if isActive {
                Image(systemName: "checkmark")
                    .font(.caption)
                    .fontWeight(.bold)
            }
        }
        .foregroundColor(isActive ? .white : .primary)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isActive ? Color.blue : Color(.systemGray5))
        .cornerRadius(8)
    }
    .buttonStyle(.plain)
}
