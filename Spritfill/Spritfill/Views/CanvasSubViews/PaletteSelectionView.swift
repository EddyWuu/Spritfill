//
//  PaletteSelectionView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-21.
//

import SwiftUI

struct PaletteSelectionView: View {
    
    @ObservedObject var toolsVM: ToolsViewModel

    var body: some View {
        VStack {
            Text("Choose Color")
                .font(.headline)
                .padding()

            let columns = [GridItem(.adaptive(minimum: 40))]
            let availableColors = toolsVM.availableColors

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<availableColors.count, id: \.self) { index in
                    let color = availableColors[index]
                    let isSelected = color.toHex() == toolsVM.selectedColor.toHex()

                    Circle()
                        .fill(color)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle().stroke(Color.black, lineWidth: isSelected ? 3 : 0)
                        )
                        .onTapGesture {
                            toolsVM.selectColor(color)
                        }
                }
            }
            .padding()
        }
        .presentationDetents([.medium])
    }
}
