//
//  NewProjectSetUpView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-24.
//

import SwiftUI

struct NewProjectSetUpView: View {
    
    let onProjectCreated: (CanvasViewModel) -> Void

    @State private var selectedCanvasSize: CanvasSizes?
    @State private var selectedPalette: ColorPalettes?
    @State private var selectedTileSize: TileSizes?
    
    let allTileSizes = TileSizes.allCases
    let allCanvasSizes = CanvasSizes.allCases
    
    @State private var customPalettes: [CustomPaletteData] = []
    @State private var showPaletteEditor = false
    @State private var editingPalette: CustomPaletteData? = nil
    
    @State private var projectName: String = ""
    
    @State private var navigateToProject = false
    @State private var canvasViewModel: CanvasViewModel?
    
    var body: some View {
            
        VStack {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("Project Name")
                        .font(.headline)
                        .padding(.leading, 15)

                    TextField("Enter project name", text: $projectName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    
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
                        
                        ForEach(ColorPalettes.builtInCases, id: \.self) { palette in
                            Button(action: {
                                selectedPalette = palette
                            }) {
                                HStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedPalette == palette ? Color.blue : Color.gray.opacity(0.3))
                                        .frame(height: 50)
                                        .overlay(
                                            HStack {
                                                Text(palette.displayName)
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
                        
                        if !customPalettes.isEmpty {
                            Divider()
                            
                            Text("Your Palettes")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach(customPalettes) { palette in
                                let paletteEnum = ColorPalettes.custom(id: palette.id)
                                Button(action: {
                                    selectedPalette = paletteEnum
                                }) {
                                    HStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(selectedPalette == paletteEnum ? Color.blue : Color.gray.opacity(0.3))
                                            .frame(height: 50)
                                            .overlay(
                                                HStack {
                                                    Text(palette.name)
                                                        .foregroundColor(.black)
                                                        .font(.subheadline)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.leading, 10)
                                                    
                                                    Text("\(palette.hexColors.count) colors")
                                                        .foregroundColor(.black)
                                                        .font(.subheadline)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                        .padding(.trailing, 10)
                                                }
                                            )
                                    }
                                }
                                .contextMenu {
                                    Button {
                                        editingPalette = palette
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    
                                    Button(role: .destructive) {
                                        CustomPaletteService.shared.deletePalette(id: palette.id)
                                        customPalettes = CustomPaletteService.shared.fetchAllPalettes()
                                        if selectedPalette == paletteEnum {
                                            selectedPalette = nil
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        
                        Button {
                            showPaletteEditor = true
                        } label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [6]))
                                    .frame(height: 50)
                                    .overlay(
                                        HStack {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.blue)
                                            Text("Create Custom Palette")
                                                .foregroundColor(.blue)
                                                .font(.subheadline)
                                        }
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    if let canvasSize = selectedCanvasSize,
                       let palette = selectedPalette,
                       let tileSize = selectedTileSize {

                        let viewModel = CanvasViewModel(
                            projectName: projectName.isEmpty ? "Untitled Project" : projectName,
                            selectedCanvasSize: canvasSize,
                            selectedPalette: palette,
                            selectedTileSize: tileSize
                        )

                        onProjectCreated(viewModel)
                    }
                }
                .disabled(selectedCanvasSize == nil || selectedPalette == nil || selectedTileSize == nil)
            }
        }
        .onAppear {
            customPalettes = CustomPaletteService.shared.fetchAllPalettes()
        }
        .sheet(isPresented: $showPaletteEditor) {
            PaletteEditorView { savedPalette in
                customPalettes = CustomPaletteService.shared.fetchAllPalettes()
                selectedPalette = .custom(id: savedPalette.id)
            }
        }
        .sheet(item: $editingPalette) { palette in
            PaletteEditorView(existingPalette: palette) { savedPalette in
                customPalettes = CustomPaletteService.shared.fetchAllPalettes()
                selectedPalette = .custom(id: savedPalette.id)
            }
        }

    }
}
