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
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Tile Size")
                        .font(.headline)
                        .padding(.leading, 10)
                    
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        
                        ForEach(allTileSizes, id: \ .self) { tile in
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
                        .padding(.leading, 10)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                        
                        ForEach(allCanvasSizes, id: \ .self) { canvas in
                            Button(action: {
                                selectedCanvasSize = canvas
                            }) {
                                VStack {
                                    let aspectRatio = CGFloat(canvas.dimensions.width) / CGFloat(canvas.dimensions.height)
                                    
                                    ZStack {
                                        
                                        let maxSize: CGFloat = 90
                                        let width = aspectRatio >= 1 ? maxSize : maxSize * aspectRatio
                                        let height = aspectRatio <= 1 ? maxSize : maxSize / aspectRatio
                                        
                                        Rectangle()
                                            .fill(selectedCanvasSize == canvas ? Color.blue : Color.gray.opacity(0.3))
                                            .frame(width: width, height: max(height, 30))
                                            .cornerRadius(4)
                                            .border(Color.white, width: 1)
                                        
                                        Text("\(canvas.dimensions.width / 16)x\(canvas.dimensions.height / 16)")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text("\(canvas.dimensions.width)x\(canvas.dimensions.height)")
                                        .font(.caption)
                                        .foregroundColor(Color.gray.opacity(0.7))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
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
}
