//
//  OpacitySliderView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-19.
//

import SwiftUI

// A self-contained opacity slider that uses local @State to avoid re-rendering
// the entire view hierarchy on every slider tick. It only writes to the
// ToolsViewModel when the drag ends or on discrete taps.
struct OpacitySliderView: View {
    @ObservedObject var toolsVM: ToolsViewModel
    @State private var localOpacity: Double = 1.0

    // Pre-composite the selected color onto white at the local opacity,
    // matching the canvas behaviour so the slider preview is accurate.
    private var blendedTint: Color {
        guard localOpacity < 1.0 else { return toolsVM.selectedColor }
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(toolsVM.selectedColor).getRed(&r, green: &g, blue: &b, alpha: &a)
        let alpha = CGFloat(localOpacity)
        return Color(
            red: Double(r * alpha + 1.0 * (1.0 - alpha)),
            green: Double(g * alpha + 1.0 * (1.0 - alpha)),
            blue: Double(b * alpha + 1.0 * (1.0 - alpha))
        )
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "circle.lefthalf.filled")
                .font(.caption)
                .foregroundColor(.secondary)

            Slider(
                value: $localOpacity,
                in: 0.05...1.0,
                step: 0.01
            )
            .tint(blendedTint)

            Text("\(Int(localOpacity * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 36, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(Color(.secondarySystemBackground))
        .onAppear {
            localOpacity = toolsVM.drawingOpacity
        }
        .onChange(of: localOpacity) { _, newValue in
            toolsVM.drawingOpacity = newValue
        }
        .onChange(of: toolsVM.drawingOpacity) { _, newValue in
            if abs(localOpacity - newValue) > 0.001 {
                localOpacity = newValue
            }
        }
    }
}
