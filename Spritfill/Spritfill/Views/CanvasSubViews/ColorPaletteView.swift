//
//  ColorPaletteView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-06.
//

import SwiftUI

struct ColorPaletteView: View {
    @ObservedObject var toolsVM: ToolsViewModel

    private let columns = [GridItem(.adaptive(minimum: 36), spacing: 8)]

    var body: some View {
        ScrollView {
            // Dynamic opacity color — shown when opacity is less than 100%
            if toolsVM.drawingOpacity < 1.0 {
                HStack(spacing: 8) {
                    Circle()
                        .fill(toolsVM.effectiveDrawingColor)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2.5)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                                .padding(1)
                        )
                        .shadow(color: .black.opacity(0.3), radius: 2)
                    
                    Text("\(Int(toolsVM.drawingOpacity * 100))%")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)
                .padding(.bottom, 2)
            }
            
            LazyVGrid(columns: columns, spacing: 8) {
                // Base palette colors
                ForEach(0..<toolsVM.basePaletteCount, id: \.self) { index in
                    colorCircle(at: index)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            
            // Extra colors section
            if !toolsVM.extraColors.isEmpty {
                Divider()
                    .padding(.horizontal, 12)
                
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(toolsVM.basePaletteCount..<toolsVM.availableColors.count, id: \.self) { index in
                        colorCircle(at: index)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
        }
    }
    
    private func colorCircle(at index: Int) -> some View {
        let color = toolsVM.availableColors[index]
        let isSelected = index == toolsVM.selectedColorIndex
        
        return Circle()
            .fill(color)
            .frame(width: 32, height: 32)
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2.5)
            )
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.black : Color.clear, lineWidth: 1)
                    .padding(1)
            )
            .shadow(color: isSelected ? .black.opacity(0.3) : .clear, radius: 2)
            .onTapGesture {
                toolsVM.selectColor(color, at: index)
            }
    }
}
