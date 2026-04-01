//
//  ColorAdderSheetView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-17.
//

import SwiftUI

// A lightweight sheet for picking and adding individual colors to the active palette.
struct ColorAdderSheetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var toolsVM: ToolsViewModel
    
    @State private var hue: Double = 0.0
    @State private var saturation: Double = 1.0
    @State private var brightness: Double = 1.0
    @State private var hexInput: String = ""
    @State private var addedFlash: Bool = false
    @State private var overrideHex: String? = nil
    
    // Pro gating
    @ObservedObject private var storeService = StoreService.shared
    @State private var showProAlert = false
    @State private var showStoreSheet = false
    
    @FocusState private var hexFieldFocused: Bool
    
    private var selectedColor: Color {
        if let hex = overrideHex {
            return Color(hex: hex)
        }
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    private var selectedHex: String {
        if let hex = overrideHex {
            return hex
        }
        return selectedColor.toHex() ?? "#000000"
    }
    
    private var isDuplicate: Bool {
        let raw = selectedHex.uppercased()
        let normalized = raw.hasPrefix("#") ? raw : "#\(raw)"
        // Check base palette colors via toHex() roundtrip
        let baseMatch = toolsVM.baseColors.contains { ($0.toHex() ?? "").uppercased() == normalized }
        // Check extra colors directly as stored hex strings (avoids double roundtrip loss)
        let extraMatch = toolsVM.extraColors.contains { $0.uppercased() == normalized || "#\($0)".uppercased() == normalized }
        return baseMatch || extraMatch
    }
    
    @State private var gridSize: CGSize = .zero
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                
                // Hue/Saturation grid
                ZStack {
                    HueSaturationGrid(brightness: brightness)
                        .equatable()
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
                            overrideHex = nil
                            guard gridSize.width > 0, gridSize.height > 0 else { return }
                            hue = min(max(value.location.x / gridSize.width, 0), 1)
                            saturation = min(max(1.0 - value.location.y / gridSize.height, 0), 1)
                        }
                )
                .frame(height: 140)
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
                        
                        Slider(value: Binding(
                            get: { brightness },
                            set: { newValue in
                                overrideHex = nil
                                brightness = newValue
                            }
                        ), in: 0...1)
                            .tint(.clear)
                    }
                    .frame(height: 28)
                    
                    Image(systemName: "sun.max")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Preview swatch + hex + Add button
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedColor)
                        .frame(width: 48, height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .scaleEffect(addedFlash ? 1.15 : 1.0)
                        .animation(.easeOut(duration: 0.2), value: addedFlash)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(selectedHex)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                        
                        if isDuplicate {
                            Text("Already in palette")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        addCurrentColor()
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                            .font(.callout.weight(.semibold))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .disabled(isDuplicate)
                }
                .padding(.horizontal)
                
                // Hex input field
                HStack(spacing: 8) {
                    Text("#")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.secondary)
                    
                    TextField("Type hex (e.g. FF5924)", text: $hexInput)
                        .font(.system(.body, design: .monospaced))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                        .focused($hexFieldFocused)
                        .onChange(of: hexInput) { _, newValue in
                            let cleaned = newValue.replacingOccurrences(of: "#", with: "")
                            if cleaned != newValue {
                                hexInput = cleaned
                            }
                            if cleaned.count == 6 {
                                navigateToHex(cleaned)
                            }
                        }
                    
                    Button {
                        applyHexInput()
                        hexFieldFocused = false
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title3)
                            .foregroundColor(hexInput.replacingOccurrences(of: "#", with: "").count == 6 ? .blue : .gray)
                    }
                    .disabled(hexInput.replacingOccurrences(of: "#", with: "").count != 6)
                }
                .padding(.horizontal)
                
                // Quick color row
                HStack(spacing: 8) {
                    ForEach(["#000000", "#333333", "#666666", "#999999", "#CCCCCC", "#FFFFFF",
                             "#FF0000", "#FF8800", "#FFFF00", "#00FF00", "#0088FF", "#8800FF"], id: \.self) { hex in
                        Circle()
                            .fill(Color(hex: hex))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(hex == "#FFFFFF" ? Color.gray.opacity(0.3) : Color.clear, lineWidth: 1)
                            )
                            .onTapGesture {
                                navigateToColor(hex)
                            }
                    }
                }
                .padding(.horizontal, 8)
                
                Divider()
                
                // Show user-added extra colors with remove option
                if toolsVM.extraColors.isEmpty {
                    Text("Pick a color above and press Add")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(toolsVM.extraColors.count) extra color\(toolsVM.extraColors.count == 1 ? "" : "s")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if !storeService.isPro {
                                Text("(\(StoreProducts.freeExtraColorLimit) max)")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 36), spacing: 6)], spacing: 6) {
                                ForEach(Array(toolsVM.extraColors.enumerated()), id: \.offset) { index, hex in
                                    ZStack(alignment: .topTrailing) {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color(hex: hex))
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                        
                                        Button {
                                            toolsVM.removeExtraColor(at: index)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(.white)
                                                .background(Circle().fill(Color.red).frame(width: 14, height: 14))
                                        }
                                        .offset(x: 4, y: -4)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer(minLength: 0)
            }
            .padding(.top, 8)
            .navigationTitle("Add Colors")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let hex = toolsVM.selectedColor.toHex() {
                    navigateToColor(hex)
                }
            }
            .alert("Pro Feature", isPresented: $showProAlert) {
                Button("Unlock Pro") { showStoreSheet = true }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Free users can add up to \(StoreProducts.freeExtraColorLimit) extra colors. Unlock Spritfill Pro for unlimited colors.")
            }
            .sheet(isPresented: $showStoreSheet) {
                StoreView()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func addCurrentColor() {
        let hex = selectedHex
        guard !isDuplicate else { return }
        
        // Pro limit check
        if !storeService.isPro && toolsVM.extraColors.count >= StoreProducts.freeExtraColorLimit {
            showProAlert = true
            return
        }
        
        toolsVM.addColor(hex)
        flashPreview()
    }
    
    private func flashPreview() {
        withAnimation(.easeOut(duration: 0.2)) {
            addedFlash = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            addedFlash = false
        }
    }
    
    private func applyHexInput() {
        let cleaned = hexInput.replacingOccurrences(of: "#", with: "")
        guard cleaned.count == 6 else { return }
        navigateToHex(cleaned)
        addCurrentColor()
        hexInput = ""
    }
    
    private func navigateToHex(_ cleaned: String) {
        let hex = "#" + cleaned.uppercased()
        overrideHex = hex  // Preserve exact hex to avoid HSB roundtrip rounding
        let color = Color(hex: hex)
        let uiColor = UIColor(color)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        hue = Double(h)
        saturation = Double(s)
        brightness = Double(b)
    }
    
    private func navigateToColor(_ hex: String) {
        overrideHex = hex.uppercased().hasPrefix("#") ? hex.uppercased() : "#" + hex.uppercased()
        let uiColor = UIColor(Color(hex: hex))
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        hue = Double(h)
        saturation = Double(s)
        brightness = Double(b)
    }
}


// MARK: - Hue/Saturation Grid

// Isolated equatable view so the spectrum only re-draws when brightness changes,
// not on every hue/saturation drag.
private struct HueSaturationGrid: View, Equatable {
    
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
