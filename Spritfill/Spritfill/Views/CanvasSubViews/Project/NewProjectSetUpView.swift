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
    @State private var tileSize: Double = 8
    
    let allCanvasSizes = CanvasSizes.allCases
    
    @State private var customPalettes: [CustomPaletteData] = []
    @State private var showPaletteEditor = false
    @State private var editingPalette: CustomPaletteData? = nil
    
    @State private var projectName: String = ""
    
    @State private var navigateToProject = false
    @State private var canvasViewModel: CanvasViewModel?
    
    // Pro gating
    @ObservedObject private var storeService = StoreService.shared
    @State private var showProAlert = false
    @State private var showProAlertMessage = ""
    @State private var showStoreSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Project Name
                sectionHeader("Project Name", icon: "character.cursor.ibeam")
                
                TextField("Enter project name", text: $projectName)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // MARK: - Tile Size
                sectionHeader(
                    "Tile Size",
                    icon: "square.grid.3x3",
                    subtitle: "Export resolution per pixel — larger = bigger image"
                )
                
                VStack(spacing: 8) {
                    HStack {
                        Text("\(Int(tileSize))×\(Int(tileSize)) px\(Int(tileSize) == 8 ? " (default)" : "")")
                            .font(.headline)
                            .monospacedDigit()
                        
                        Spacer()
                        
                        if let canvas = selectedCanvasSize {
                            let exportW = canvas.dimensions.width * Int(tileSize)
                            let exportH = canvas.dimensions.height * Int(tileSize)
                            Text("Export: \(exportW)×\(exportH)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Slider(value: $tileSize, in: 1...32, step: 1)
                        .tint(.blue)
                    
                    HStack {
                        Text("1 px")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("32 px")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    // Low-resolution warning
                    if let canvas = selectedCanvasSize {
                        let longestSide = max(canvas.dimensions.width, canvas.dimensions.height) * Int(tileSize)
                        if longestSide < 128 {
                            HStack(alignment: .top, spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                                Text("This export size is very small and may look blurry when saved to your phone's photo library. You can upscale it later when exporting or downloading. If you plan to export to a computer, this is fine.")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(10)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Downscale warning
                        let maxSide = BitmapExporter.maxPixelSide
                        let maxDim = max(canvas.dimensions.width, canvas.dimensions.height)
                        if maxDim * Int(tileSize) > maxSide {
                            let effectiveTile = maxSide / maxDim
                            let effectiveW = canvas.dimensions.width * effectiveTile
                            let effectiveH = canvas.dimensions.height * effectiveTile
                            HStack(alignment: .top, spacing: 6) {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                                Text("Export will be \(effectiveW)×\(effectiveH) instead of \(canvas.dimensions.width * Int(tileSize))×\(canvas.dimensions.height * Int(tileSize)). Images are capped at \(maxSide)×\(maxSide) due to device memory limits.")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(10)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Canvas Size
                sectionHeader(
                    "Canvas Size",
                    icon: "rectangle.dashed",
                    subtitle: "Number of pixels to draw on — bigger = more detail"
                )
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                    ForEach(allCanvasSizes, id: \.self) { canvas in
                        let isSelected = selectedCanvasSize == canvas
                        let w = canvas.dimensions.width
                        let h = canvas.dimensions.height
                        let aspectRatio = CGFloat(w) / CGFloat(h)
                        let needsPro = StoreProducts.requiresPro(canvas) && !storeService.isPro
                        
                        Button {
                            if needsPro {
                                showProAlertMessage = "128×128, 256×256, and 512×512 canvas sizes are available with Spritfill Pro."
                                showProAlert = true
                            } else {
                                selectedCanvasSize = canvas
                            }
                        } label: {
                            VStack(spacing: 8) {
                                // Aspect-ratio preview box inside a fixed container
                                let maxDim: CGFloat = 50
                                let previewW = aspectRatio >= 1 ? maxDim : maxDim * aspectRatio
                                let previewH = aspectRatio <= 1 ? maxDim : maxDim / aspectRatio
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(isSelected ? Color.white.opacity(0.3) : Color(.tertiarySystemBackground))
                                        .frame(width: max(previewW, 20), height: max(previewH, 20))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(isSelected ? Color.white.opacity(0.5) : Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    if needsPro {
                                        Image(systemName: "lock.fill")
                                            .font(.caption)
                                            .foregroundColor(.yellow)
                                    }
                                }
                                .frame(width: maxDim, height: maxDim)
                                
                                HStack(spacing: 4) {
                                    Text("\(w)×\(h)")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(isSelected ? .white : (needsPro ? .secondary : .primary))
                                    if needsPro {
                                        Image(systemName: "lock.fill")
                                            .font(.caption2)
                                            .foregroundColor(.yellow)
                                    }
                                }
                                
                                Text(canvasSizeLabel(w: w, h: h))
                                    .font(.caption2)
                                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isSelected ? Color.blue : Color(.secondarySystemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Color Palette
                sectionHeader(
                    "Color Palette",
                    icon: "paintpalette",
                    subtitle: "Starting colors — you can always add more while drawing"
                )
                
                VStack(spacing: 10) {
                    ForEach(ColorPalettes.builtInCases, id: \.self) { palette in
                        let needsPro = StoreProducts.paletteRequiresPro(palette) && !storeService.isPro
                        paletteButton(
                            name: palette.displayName + (needsPro ? " 🔒" : ""),
                            colorCount: palette.colors.count,
                            isSelected: selectedPalette == palette,
                            colors: palette.colors
                        ) {
                            if needsPro {
                                showProAlertMessage = "The Spritfill 128 palette is exclusive to Spritfill Pro."
                                showProAlert = true
                            } else {
                                selectedPalette = palette
                            }
                        }
                    }
                    
                    if !customPalettes.isEmpty {
                        HStack {
                            Rectangle()
                                .fill(Color.secondary.opacity(0.3))
                                .frame(height: 1)
                            Text("Your Palettes")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Rectangle()
                                .fill(Color.secondary.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 4)
                        
                        ForEach(customPalettes) { palette in
                            let paletteEnum = ColorPalettes.custom(id: palette.id)
                            paletteButton(
                                name: palette.name,
                                colorCount: palette.hexColors.count,
                                isSelected: selectedPalette == paletteEnum,
                                colors: palette.hexColors.map { Color(hex: $0) }
                            ) {
                                selectedPalette = paletteEnum
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
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text("Create Custom Palette")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.blue, style: StrokeStyle(lineWidth: 1.5, dash: [8, 4]))
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 30)
            }
            .padding(.top, 8)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    if let canvasSize = selectedCanvasSize,
                       let palette = selectedPalette {

                        let viewModel = CanvasViewModel(
                            projectName: projectName.isEmpty ? "Untitled Project" : projectName,
                            selectedCanvasSize: canvasSize,
                            selectedPalette: palette,
                            selectedTileSize: Int(tileSize)
                        )

                        onProjectCreated(viewModel)
                    }
                }
                .disabled(selectedCanvasSize == nil || selectedPalette == nil)
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
        .alert("Pro Feature", isPresented: $showProAlert) {
            Button("Unlock Pro") { showStoreSheet = true }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(showProAlertMessage)
        }
        .sheet(isPresented: $showStoreSheet) {
            StoreView()
        }

    }
    
    // MARK: - Section Header
    
    @ViewBuilder
    private func sectionHeader(_ title: String, icon: String, subtitle: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
            }
            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.leading, 16)
    }
    
    // MARK: - Canvas Size Label
    
    private func canvasSizeLabel(w: Int, h: Int) -> String {
        if w == h { return "Square" }
        if w > h { return "Landscape" }
        return "Portrait"
    }
    
    // MARK: - Palette Button
    
    private func paletteButton(name: String, colorCount: Int, isSelected: Bool, colors: [Color], action: @escaping () -> Void) -> some View {
        // Split colors into balanced rows (max 64 per row, evenly distributed)
        let maxPerRow = 64
        let count = colors.count
        let rowCount = max(1, Int(ceil(Double(count) / Double(maxPerRow))))
        let basePerRow = count / rowCount
        let remainder = count % rowCount  // first 'remainder' rows get one extra
        let rowHeight: CGFloat = 8
        let swatchHeight = CGFloat(rowCount) * rowHeight
        
        return Button(action: action) {
            VStack(spacing: 0) {
                HStack {
                    Text(name)
                        .foregroundColor(isSelected ? .white : .primary)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 12)
                    
                    Text("\(colorCount) colors")
                        .foregroundColor(isSelected ? .white.opacity(0.7) : .secondary)
                        .font(.caption)
                        .padding(.trailing, 12)
                }
                .padding(.vertical, 11)
                
                // Color swatch bars — balanced rows, each filling full width
                Canvas { context, size in
                    guard count > 0 else { return }
                    
                    var startIdx = 0
                    for row in 0..<rowCount {
                        let rowColorCount = basePerRow + (row < remainder ? 1 : 0)
                        let stripWidth = size.width / CGFloat(rowColorCount)
                        let y = CGFloat(row) * rowHeight
                        
                        for i in 0..<rowColorCount {
                            let rect = CGRect(x: CGFloat(i) * stripWidth, y: y,
                                              width: stripWidth + 0.5, height: rowHeight)
                            context.fill(Path(rect), with: .color(colors[startIdx + i]))
                        }
                        startIdx += rowColorCount
                    }
                }
                .frame(height: swatchHeight)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 12,
                        bottomTrailingRadius: 12,
                        topTrailingRadius: 0
                    )
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
