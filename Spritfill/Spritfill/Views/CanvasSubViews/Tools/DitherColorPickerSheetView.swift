//
//  DitherColorPickerSheetView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-28.
//

import SwiftUI

// MARK: - Dither Color Picker Sheet

struct DitherColorPickerSheet: View {
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

// Hue/Saturation grid for color picker
struct DitherHueSatGrid: View, Equatable {
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
