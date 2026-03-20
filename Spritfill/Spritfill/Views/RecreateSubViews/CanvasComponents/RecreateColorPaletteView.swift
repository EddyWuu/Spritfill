//
//  RecreateColorPaletteView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-13.
//

import SwiftUI

struct RecreateColorPaletteView: View {
    @ObservedObject var viewModel: RecreateCanvasViewModel

    private let columns = [GridItem(.adaptive(minimum: 52), spacing: 8)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(viewModel.numberedColors, id: \.hex) { entry in
                    let isSelected = viewModel.selectedColorHex.lowercased() == entry.hex.lowercased()

                    VStack(spacing: 2) {
                        Circle()
                            .fill(entry.color)
                            .frame(width: 36, height: 36)
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

                        Text("\(entry.number)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .onTapGesture {
                        viewModel.selectColor(entry.color, hex: entry.hex)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }
}
