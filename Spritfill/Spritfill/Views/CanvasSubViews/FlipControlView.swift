//
//  FlipControlView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-17.
//

import SwiftUI

struct FlipControlView: View {
    
    @ObservedObject var canvasVM: CanvasViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            HStack(spacing: 20) {
                flipButton(direction: .horizontal, icon: "arrow.left.and.right", label: "Flip Horizontal")
                flipButton(direction: .vertical, icon: "arrow.up.and.down", label: "Flip Vertical")
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
    }
    
    private func flipButton(direction: CanvasViewModel.FlipDirection, icon: String, label: String) -> some View {
        Button(action: {
            canvasVM.flipPixels(direction)
        }) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(.primary)
            .frame(width: 120, height: 64)
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(12)
        }
    }
}
