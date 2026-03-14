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
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(0..<toolsVM.availableColors.count, id: \.self) { index in
                    let color = toolsVM.availableColors[index]
                    let isSelected = index == toolsVM.selectedColorIndex

                    Circle()
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
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }
}
