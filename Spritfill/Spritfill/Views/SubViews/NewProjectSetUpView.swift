//
//  NewProjectSetUpView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-24.
//

import SwiftUI

struct NewProjectSetUpView: View {
    
    @Binding var isPresented: Bool
    
    @State private var selectedCanvasSize: CanvasSizes?
    @State private var selectedPalette: ColorPalettes?
    @State private var selectedTileSize: TileSizes?
    
    let allTileSizes = TileSizes.allCases
    let allCanvasSizes = CanvasSizes.allCases
    
    var body: some View {
    
        NavigationStack {
            
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Tile Size")
                    .font(.headline)
                
                HStack(spacing: 10) {
                    
                    ForEach(allTileSizes, id: \.self) { tile in
                        Button(action: {
                            selectedTileSize = tile
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(selectedTileSize == tile ? Color.blue : Color.gray.opacity(0.3))
                                    .frame(width: 45, height: 45)
                                    .cornerRadius(2)
                                
                                Text("\(tile.dimensions.width)²")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                
                Text("Canvas Size")
                    .font(.headline)
                
                HStack(spacing: 10) {
                    
                    ForEach(allCanvasSizes, id: \.self) { canvas in
                        Button(action: {
                            selectedCanvasSize = canvas
                        }) {

                        }
                    }
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("New Project")
                        .font(.title2)
                        .bold(true)
                }
            }
        }
    }
}
