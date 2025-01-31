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
    let allPalettes = ColorPalettes.allCases
    let allCanvasSizes = CanvasSizes.allCases
    
    @State private var navigateToProject = false
    @StateObject private var projectViewModel = ProjectViewModel(
        selectedCanvasSize: .smallSquare,
        selectedPalette: .endesga32,
        selectedTileSize: .small
    )
    
    var body: some View {
    
        VStack {
            
            HStack {
                Button("Back") {
                    isPresented = false
                }
                .cornerRadius(8)
                
                Spacer()
                
                Text("New Project Setup")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    if let canvasSize = selectedCanvasSize,
                       let palette = selectedPalette,
                       let tileSize = selectedTileSize {
                        
                        projectViewModel.projectSettings.selectedCanvasSize = canvasSize
                        projectViewModel.projectSettings.selectedPalette = palette
                        projectViewModel.projectSettings.selectedTileSize = tileSize
                        
                        navigateToProject = true
                    }
                }) {
                    Text("Create")
                        .foregroundColor((selectedCanvasSize != nil && selectedPalette != nil && selectedTileSize != nil) ? .blue : .gray)
                        .cornerRadius(8)
                }
                .disabled(selectedCanvasSize == nil || selectedPalette == nil || selectedTileSize == nil)
            }
            .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Tile Size")
                        .font(.headline)
                        .padding(.leading, 15)
                    
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        
                        ForEach(allTileSizes, id: \.self) { tile in
                            Button(action: {
                                selectedTileSize = tile
                            }) {
                                ZStack {
                                    Rectangle()
                                        .fill(selectedTileSize == tile ? Color.blue : Color.gray.opacity(0.3))
                                        .frame(width: 45, height: 45)
                                        .cornerRadius(2)
                                    
                                    Text("\(Int(tile.size))²")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    
                    Text("Canvas Size")
                        .font(.headline)
                        .padding(.leading, 15)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                        
                        ForEach(allCanvasSizes, id: \.self) { canvas in
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
                                            .foregroundColor(.black)
                                    }
                                    
                                    Text("\(canvas.dimensions.width)x\(canvas.dimensions.height)")
                                        .font(.caption)
                                        .foregroundColor(Color.gray.opacity(0.7))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("Color Palette")
                        .font(.headline)
                        .padding(.leading, 15)
                    
                    VStack(spacing: 10) {
                        
                        ForEach(allPalettes, id: \.self) { palette in
                            Button(action: {
                                selectedPalette = palette
                            }) {
                                HStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedPalette == palette ? Color.blue : Color.gray.opacity(0.3))
                                        .frame(height: 50)
                                        .overlay(
                                            HStack {
                                                Text(palette.rawValue)
                                                    .foregroundColor(.black)
                                                    .font(.subheadline)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.leading, 10)
                                                
                                                Text("\(palette.colors.count) colors")
                                                    .foregroundColor(.black)
                                                    .font(.subheadline)
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                                    .padding(.trailing, 10)
                                            }
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented: $navigateToProject) {
            ProjectCreateView(viewModel: projectViewModel, isPresented: $isPresented)
        }
    }
}
