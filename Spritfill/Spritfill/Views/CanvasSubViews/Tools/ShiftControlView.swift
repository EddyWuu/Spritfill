//
//  ShiftControlView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-16.
//

import SwiftUI

struct ShiftControlView: View {
    
    @ObservedObject var canvasVM: CanvasViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            
            arrowButton(direction: .up, icon: "chevron.up")
            
            HStack(spacing: 8) {
                arrowButton(direction: .left, icon: "chevron.left")
                
                Color.clear
                    .frame(width: 48, height: 48)
                
                arrowButton(direction: .right, icon: "chevron.right")
            }
            
            arrowButton(direction: .down, icon: "chevron.down")
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
    }
    
    private func arrowButton(direction: CanvasViewModel.ShiftDirection, icon: String) -> some View {
        Button(action: {
            canvasVM.shiftPixels(direction)
        }) {
            Image(systemName: icon)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 48, height: 48)
                .foregroundColor(.primary)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(12)
        }
    }
}
