//
//  GradientControlView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-28.
//

import SwiftUI

struct GradientControlView: View {
    
    @ObservedObject var toolsVM: ToolsViewModel
    @State private var showColorASheet = false
    @State private var showColorBSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Color A & B with swap button and clear labels
                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        VStack(alignment: .center, spacing: 8) {
                            Text("A")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            Button(action: { showColorASheet = true }) {
                                Circle()
                                    .fill(toolsVM.gradientColorA)
                                    .frame(width: 44, height: 44)
                                    .overlay(Circle().stroke(Color.primary.opacity(0.3), lineWidth: 1.5))
                            }
                        }
                        
                        // Swap button
                        Button(action: {
                            let temp = toolsVM.gradientColorA
                            toolsVM.gradientColorA = toolsVM.gradientColorB
                            toolsVM.gradientColorB = temp
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }) {
                            Image(systemName: "arrow.left.arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.blue)
                                .frame(width: 36, height: 36)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .center, spacing: 8) {
                            Text("B")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            Button(action: { showColorBSheet = true }) {
                                Circle()
                                    .fill(toolsVM.gradientColorB)
                                    .frame(width: 44, height: 44)
                                    .overlay(Circle().stroke(Color.primary.opacity(0.3), lineWidth: 1.5))
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                // Thickness then Steps stacked vertically
                VStack(spacing: 12) {
                    // Thickness
                    VStack(spacing: 6) {
                        Text("Thickness")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(toolsVM.gradientThickness == 0 ? "Full" : "\(toolsVM.gradientThickness)px")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                // Full canvas option
                                Button(action: {
                                    toolsVM.gradientThickness = 0
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                }) {
                                    Text("∞")
                                        .font(.system(size: 11, weight: .medium))
                                        .frame(width: 28, height: 28)
                                        .background(toolsVM.gradientThickness == 0 ? Color.blue : Color(.systemGray5))
                                        .foregroundColor(toolsVM.gradientThickness == 0 ? .white : .primary)
                                        .cornerRadius(6)
                                }
                                .buttonStyle(.plain)
                                
                                // 1-16 pixel options
                                ForEach(1...16, id: \.self) { px in
                                    Button(action: {
                                        toolsVM.gradientThickness = px
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    }) {
                                        Text("\(px)")
                                            .font(.system(size: 11, weight: .medium))
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
                    
                    Divider()
                    
                    // Steps
                    VStack(spacing: 6) {
                        Text("Steps")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("\(toolsVM.gradientSteps)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Stepper("", value: $toolsVM.gradientSteps, in: 2...32)
                            .labelsHidden()
                    }
                }
                .padding(.horizontal)
                
                // Preview
                VStack(spacing: 6) {
                    Text("Preview")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    HStack(spacing: 0) {
                        ForEach(0..<toolsVM.gradientSteps, id: \.self) { i in
                            let t = toolsVM.gradientSteps == 1 ? 0.0 : Double(i) / Double(toolsVM.gradientSteps - 1)
                            interpolatedColor(t: t)
                                .frame(height: 30)
                        }
                    }
                    .cornerRadius(6)
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 12)
            }
            .padding(.vertical, 12)
        }
        .background(Color(.secondarySystemBackground))
        .sheet(isPresented: $showColorASheet) {
            DitherColorPickerSheet(title: "Gradient Color A", selectedColor: $toolsVM.gradientColorA, paletteColors: toolsVM.availableColors)
        }
        .sheet(isPresented: $showColorBSheet) {
            DitherColorPickerSheet(title: "Gradient Color B", selectedColor: $toolsVM.gradientColorB, paletteColors: toolsVM.availableColors)
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

extension View {
    func paddingHorizontal(_ value: CGFloat) -> some View {
        padding(.horizontal, value)
    }
}
