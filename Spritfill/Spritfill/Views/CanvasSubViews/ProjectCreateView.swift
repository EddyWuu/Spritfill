//
//  ProjectCreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

struct ProjectCreateView: View {
    
    @ObservedObject var viewModel: ProjectViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    
    var body: some View {
        
        VStack {
            
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Back")
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .padding(.top)
            
            Spacer()
            
            Text("ProjectCreateView")
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: CGFloat(viewModel.selectedCanvasSize.dimensions.width),
                       height: CGFloat(viewModel.selectedCanvasSize.dimensions.height))
                .overlay(
                    Text("\(viewModel.selectedCanvasSize.dimensions.width) x \(viewModel.selectedCanvasSize.dimensions.height)")
                        .foregroundColor(.white)
                        .font(.headline)
                )
            
            Text("Tile Size: \(viewModel.selectedTileSize.size)²")
            Text("Palette: \(viewModel.selectedPalette.rawValue)")
        }
        .padding()
    }
}
