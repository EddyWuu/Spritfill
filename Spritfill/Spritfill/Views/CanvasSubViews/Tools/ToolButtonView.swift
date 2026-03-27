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

    var body: some View {
        let isSelected = toolsVM.isSelected(tool: tool)
        let isBrushTool = (tool == .pencil || tool == .eraser)
        let isFillTool = (tool == .fill)
        let hasOptions = isBrushTool || isFillTool || tool == .rectangle || tool == .circle || tool == .gradient || tool == .dither
        let toolBrushSize = toolsVM.brushSize(for: tool)
        let hasBrushSize = isBrushTool && toolBrushSize > 1
        
        let button = Button(action: {
            // Skip if long press just opened a picker
            if longPressTriggered {
                longPressTriggered = false
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
            }
        }
        
        // Attach long-press + popover
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
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            showFillPicker = true
                        }
                )
                .popover(isPresented: $showFillPicker, arrowEdge: .top) {
                    FillModePickerView(toolsVM: toolsVM)
                        .presentationCompactAdaptation(.popover)
                }
        } else if hasOptions {
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
                .popover(isPresented: $showShapePicker, arrowEdge: .top) {
                    shapeOptionsPopover
                        .presentationCompactAdaptation(.popover)
                }
        } else {
            button
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
        case .rectangle:
            RectangleOptionsView(toolsVM: toolsVM)
        case .circle:
            CircleOptionsView(toolsVM: toolsVM)
        case .gradient:
            GradientOptionsView(toolsVM: toolsVM)
        case .dither:
            DitherOptionsView(toolsVM: toolsVM)
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

// MARK: - Rectangle Options Popover

private struct RectangleOptionsView: View {
    @ObservedObject var toolsVM: ToolsViewModel
    
    var body: some View {
        VStack(spacing: 8) {
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
        }
        .padding(12)
        .frame(width: 180)
    }
}

// MARK: - Circle Options Popover

private struct CircleOptionsView: View {
    @ObservedObject var toolsVM: ToolsViewModel
    
    var body: some View {
        VStack(spacing: 8) {
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
        }
        .padding(12)
        .frame(width: 180)
    }
}

// MARK: - Gradient Options Popover

private struct GradientOptionsView: View {
    @ObservedObject var toolsVM: ToolsViewModel
    @State private var showColorASheet = false
    @State private var showColorBSheet = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Gradient Options")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            // Color A
            HStack {
                Text("Color A")
                    .font(.caption)
                Spacer()
                Button(action: { showColorASheet = true }) {
                    Circle()
                        .fill(toolsVM.gradientColorA)
                        .frame(width: 28, height: 28)
                        .overlay(Circle().stroke(Color.primary.opacity(0.3), lineWidth: 1))
                }
            }
            
            // Color B
            HStack {
                Text("Color B")
                    .font(.caption)
                Spacer()
                Button(action: { showColorBSheet = true }) {
                    Circle()
                        .fill(toolsVM.gradientColorB)
                        .frame(width: 28, height: 28)
                        .overlay(Circle().stroke(Color.primary.opacity(0.3), lineWidth: 1))
                }
            }
            
            // Steps
            VStack(spacing: 4) {
                HStack {
                    Text("Steps: \(toolsVM.gradientSteps)")
                        .font(.caption)
                    Spacer()
                }
                Stepper("", value: $toolsVM.gradientSteps, in: 2...32)
                    .labelsHidden()
            }
            
            // Thickness
            VStack(spacing: 4) {
                HStack {
                    Text("Thickness: \(toolsVM.gradientThickness == 0 ? "Full" : "\(toolsVM.gradientThickness)px")")
                        .font(.caption)
                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        // Full canvas option
                        Button(action: {
                            toolsVM.gradientThickness = 0
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }) {
                            Text("Full")
                                .font(.system(size: 10, weight: .medium))
                                .frame(width: 34, height: 28)
                                .background(toolsVM.gradientThickness == 0 ? Color.blue : Color(.systemGray5))
                                .foregroundColor(toolsVM.gradientThickness == 0 ? .white : .primary)
                                .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                        
                        // 1-10 pixel options
                        ForEach(1...16, id: \.self) { px in
                            Button(action: {
                                toolsVM.gradientThickness = px
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }) {
                                Text("\(px)")
                                    .font(.system(size: 10, weight: .medium))
                                    .frame(width: 28, height: 28)
                                    .background(toolsVM.gradientThickness == px ? Color.blue : Color(.systemGray5))
                                    .foregroundColor(toolsVM.gradientThickness == px ? .white : .primary)
                                    .cornerRadius(6)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            
            // Preview
            HStack(spacing: 0) {
                ForEach(0..<toolsVM.gradientSteps, id: \.self) { i in
                    let t = toolsVM.gradientSteps == 1 ? 0.0 : Double(i) / Double(toolsVM.gradientSteps - 1)
                    interpolatedColor(t: t)
                        .frame(height: 20)
                }
            }
            .cornerRadius(4)
        }
        .padding(12)
        .frame(width: 200)
        .sheet(isPresented: $showColorASheet) {
            DitherColorPickerSheet(title: "Color A", selectedColor: $toolsVM.gradientColorA, paletteColors: toolsVM.availableColors)
        }
        .sheet(isPresented: $showColorBSheet) {
            DitherColorPickerSheet(title: "Color B", selectedColor: $toolsVM.gradientColorB, paletteColors: toolsVM.availableColors)
        }
    }
    
    private func interpolatedColor(t: Double) -> Color {
        var rA: CGFloat = 0, gA: CGFloat = 0, bA: CGFloat = 0, aA: CGFloat = 0
        var rB: CGFloat = 0, gB: CGFloat = 0, bB: CGFloat = 0, aB: CGFloat = 0
        UIColor(toolsVM.gradientColorA).getRed(&rA, green: &gA, blue: &bA, alpha: &aA)
        UIColor(toolsVM.gradientColorB).getRed(&rB, green: &gB, blue: &bB, alpha: &aB)
        return Color(
            red: Double(rA + CGFloat(t) * (rB - rA)),
            green: Double(gA + CGFloat(t) * (gB - gA)),
            blue: Double(bA + CGFloat(t) * (bB - bA))
        )
    }
}

// MARK: - Dither Options Popover

private struct DitherOptionsView: View {
    @ObservedObject var toolsVM: ToolsViewModel
    @State private var showColorASheet = false
    @State private var showColorBSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Dither Options")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                // Color A
                HStack {
                    Text("Color A")
                        .font(.caption)
                    Spacer()
                    Button(action: { showColorASheet = true }) {
                        Circle()
                            .fill(toolsVM.ditherColorA)
                            .frame(width: 28, height: 28)
                            .overlay(Circle().stroke(Color.primary.opacity(0.3), lineWidth: 1))
                    }
                }
                
                // Color B
                HStack {
                    Text("Color B")
                        .font(.caption)
                    Spacer()
                    Button(action: { showColorBSheet = true }) {
                        Circle()
                            .fill(toolsVM.ditherColorB)
                            .frame(width: 28, height: 28)
                            .overlay(Circle().stroke(Color.primary.opacity(0.3), lineWidth: 1))
                    }
                }
                
                // Pattern selection
                VStack(spacing: 4) {
                    Text("Pattern")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(ToolsViewModel.DitherPattern.allCases, id: \.self) { pattern in
                        let isActive = toolsVM.ditherPattern == pattern
                        Button(action: {
                            toolsVM.ditherPattern = pattern
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }) {
                            HStack {
                                ditherPreview(pattern: pattern)
                                    .frame(width: 20, height: 20)
                                    .cornerRadius(2)
                                Text(pattern.rawValue)
                                    .font(.caption)
                                Spacer()
                                if isActive {
                                    Image(systemName: "checkmark")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                            }
                            .foregroundColor(isActive ? .white : .primary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(isActive ? Color.blue : Color(.systemGray5))
                            .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(12)
        }
        .frame(width: 230)
        .frame(maxHeight: 420)
        .sheet(isPresented: $showColorASheet) {
            DitherColorPickerSheet(title: "Color A", selectedColor: $toolsVM.ditherColorA, paletteColors: toolsVM.availableColors)
        }
        .sheet(isPresented: $showColorBSheet) {
            DitherColorPickerSheet(title: "Color B", selectedColor: $toolsVM.ditherColorB, paletteColors: toolsVM.availableColors)
        }
    }
    
    private func ditherPreview(pattern: ToolsViewModel.DitherPattern) -> some View {
        Canvas { context, size in
            let gridN = 6  // preview grid size
            let cellW = size.width / CGFloat(gridN)
            let cellH = size.height / CGFloat(gridN)
            for r in 0..<gridN {
                for c in 0..<gridN {
                    let useA: Bool
                    switch pattern {
                    case .checkerboard: useA = (r + c) % 2 == 0
                    case .bayer2x2: useA = [[0,2],[3,1]][r % 2][c % 2] < 1
                    case .horizontal: useA = r % 2 == 0
                    case .vertical: useA = c % 2 == 0
                    case .diagonal: useA = (r + c) % 3 != 0
                    }
                    let rect = CGRect(x: CGFloat(c) * cellW, y: CGFloat(r) * cellH, width: cellW, height: cellH)
                    context.fill(Path(rect), with: .color(useA ? .black : .white))
                }
            }
        }
    }
}

// MARK: - Dither Color Picker Sheet

private struct DitherColorPickerSheet: View {
    let title: String
    @Binding var selectedColor: Color
    let paletteColors: [Color]
    @Environment(\.dismiss) private var dismiss
    
    @State private var hue: Double = 0.0
    @State private var saturation: Double = 1.0
    @State private var brightness: Double = 1.0
    @State private var gridSize: CGSize = .zero
    
    private var currentColor: Color {
        Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    
                    // Hue/Saturation grid
                    ZStack {
                        DitherHueSatGrid(brightness: brightness)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 16, height: 16)
                            .shadow(color: .black.opacity(0.5), radius: 1)
                            .position(
                                x: gridSize.width > 0 ? hue * gridSize.width : 0,
                                y: gridSize.height > 0 ? (1.0 - saturation) * gridSize.height : 0
                            )
                    }
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear { gridSize = geo.size }
                                .onChange(of: geo.size) { _, newSize in gridSize = newSize }
                        }
                    )
                    .contentShape(Rectangle())
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                guard gridSize.width > 0, gridSize.height > 0 else { return }
                                hue = min(max(value.location.x / gridSize.width, 0), 1)
                                saturation = min(max(1.0 - value.location.y / gridSize.height, 0), 1)
                            }
                    )
                    .frame(height: 200)
                    .padding(.horizontal)
                    
                    // Brightness slider
                    HStack(spacing: 10) {
                        Image(systemName: "sun.min")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        ZStack(alignment: .leading) {
                            GeometryReader { geo in
                                LinearGradient(
                                    colors: [
                                        Color(hue: hue, saturation: saturation, brightness: 0),
                                        Color(hue: hue, saturation: saturation, brightness: 1)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .clipShape(Capsule())
                                .frame(height: 12)
                                .position(x: geo.size.width / 2, y: geo.size.height / 2)
                            }
                            
                            Slider(value: $brightness, in: 0...1)
                                .tint(.clear)
                        }
                        .frame(height: 28)
                        
                        Image(systemName: "sun.max")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Preview swatch
                    RoundedRectangle(cornerRadius: 8)
                        .fill(currentColor)
                        .frame(height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                        )
                        .overlay(
                            Text(currentColor.toHex() ?? "#000000")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(brightness > 0.5 ? .black : .white)
                        )
                        .padding(.horizontal)
                    
                    // Palette colors — pick from existing palette
                    if !paletteColors.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Label("Pick from Palette", systemImage: "eyedropper")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 8)
                            LazyVGrid(columns: columns, spacing: 4) {
                                ForEach(0..<paletteColors.count, id: \.self) { i in
                                    let color = paletteColors[i]
                                    Button(action: {
                                        navigateToColor(color)
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    }) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(color)
                                            .frame(height: 32)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.top, 8)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        selectedColor = currentColor
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                navigateToColor(selectedColor)
            }
            .presentationDetents([.large])
        }
    }
    
    private func navigateToColor(_ color: Color) {
        let uiColor = UIColor(color)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        hue = Double(h)
        saturation = Double(s)
        brightness = Double(b)
    }
}

// Hue/Saturation grid for dither color picker (matches ColorAdderSheetView style)
private struct DitherHueSatGrid: View, Equatable {
    let brightness: Double
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.brightness == rhs.brightness
    }
    
    var body: some View {
        Canvas { context, size in
            let cols = Int(size.width)
            let rows = Int(size.height)
            let colStep = max(1, cols / 64)
            let rowStep = max(1, rows / 32)
            
            for x in stride(from: 0, to: cols, by: colStep) {
                for y in stride(from: 0, to: rows, by: rowStep) {
                    let h = Double(x) / Double(cols)
                    let s = 1.0 - (Double(y) / Double(rows))
                    let color = Color(hue: h, saturation: s, brightness: brightness)
                    context.fill(
                        Path(CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(colStep), height: CGFloat(rowStep))),
                        with: .color(color)
                    )
                }
            }
        }
        .drawingGroup()
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
