//
//  PaletteButtonView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-25.
//

import SwiftUI

struct PaletteButtonView: View {
    
    @ObservedObject var toolsVM: ToolsViewModel
    @State private var showPalettePicker = false

    var body: some View {
        Button(action: {
            showPalettePicker = true
        }) {
            Image(systemName: "paintpalette")
                .foregroundColor(toolsVM.selectedColor)
                .padding()
                .background(Color.gray.opacity(0.15))
                .clipShape(Circle())
        }
        .sheet(isPresented: $showPalettePicker) {
            PaletteSelectionView(toolsVM: toolsVM)
        }
    }
}
