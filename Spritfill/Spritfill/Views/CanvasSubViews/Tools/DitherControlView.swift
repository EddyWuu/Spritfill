//
//  DitherControlView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-28.
//

import SwiftUI

struct DitherControlView: View {
    
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
                                    .fill(toolsVM.ditherColorA)
                                    .frame(width: 44, height: 44)
                                    .overlay(Circle().stroke(Color.primary.opacity(0.3), lineWidth: 1.5))
                            }
                        }
                        
                        // Swap button
                        Button(action: {
                            let temp = toolsVM.ditherColorA
                            toolsVM.ditherColorA = toolsVM.ditherColorB
                            toolsVM.ditherColorB = temp
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
                                    .fill(toolsVM.ditherColorB)
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
                
                // Pattern selection
                VStack(spacing: 6) {
                    Text("Pattern")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(ToolsViewModel.DitherPattern.allCases, id: \.self) { pattern in
                        let isActive = toolsVM.ditherPattern == pattern
                        Button(action: {
                            toolsVM.ditherPattern = pattern
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }) {
                            HStack(spacing: 10) {
                                ditherPreview(pattern: pattern)
                                    .frame(width: 24, height: 24)
                                    .cornerRadius(4)
                                
                                Text(pattern.rawValue)
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
                            .padding(.vertical, 10)
                            .background(isActive ? Color.blue : Color(.systemGray5))
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 12)
            }
            .padding(.vertical, 12)
        }
        .background(Color(.secondarySystemBackground))
        .sheet(isPresented: $showColorASheet) {
            DitherColorPickerSheet(title: "Dither Color A", selectedColor: $toolsVM.ditherColorA, paletteColors: toolsVM.availableColors)
        }
        .sheet(isPresented: $showColorBSheet) {
            DitherColorPickerSheet(title: "Dither Color B", selectedColor: $toolsVM.ditherColorB, paletteColors: toolsVM.availableColors)
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
                    case .bayer4x4: useA = (r % 4 == 0 && c % 4 == 0) || (r % 4 == 2 && c % 4 == 2)
                    case .horizontal: useA = r % 2 == 0
                    case .vertical: useA = c % 2 == 0
                    case .diagonal: useA = (r + c) % 3 != 0
                    case .diagonalReversed: useA = ((r - c) % 3 + 3) % 3 != 0
                    case .diamond:
                        switch r % 4 {
                        case 0: useA = c % 4 != 3
                        case 1, 3: useA = c % 2 == 1
                        case 2: useA = c % 4 != 1
                        default: useA = true
                        }
                    case .zigzag: useA = (r + c * 2) % 4 != 0
                    case .sparse: useA = r % 3 == 0 && c % 3 == 0
                    case .zigzagReversed: useA = !( (r % 2 == 0 && c % 4 == 0) || (r % 2 == 1 && c % 4 == 2) )
                    }
                    let rect = CGRect(x: CGFloat(c) * cellW, y: CGFloat(r) * cellH, width: cellW, height: cellH)
                    context.fill(Path(rect), with: .color(useA ? .black : .white))
                }
            }
        }
    }
}

