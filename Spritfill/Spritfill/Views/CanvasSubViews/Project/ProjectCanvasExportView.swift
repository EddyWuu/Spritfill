//
//  ProjectCanvasExportView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-27.
//

import SwiftUI

struct ProjectCanvasExportView: View {
    let viewModel: CanvasViewModel

    var body: some View {
        let tileSize = viewModel.projectSettings.selectedTileSize
        let gridWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
        let gridHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height
        let compositeHexes = viewModel.compositePixelHexes()
        
        let image = BitmapExporter.renderImage(
            hexes: compositeHexes,
            gridWidth: gridWidth,
            gridHeight: gridHeight,
            tileSize: tileSize
        )
        
        if let image {
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .frame(width: CGFloat(gridWidth * tileSize), height: CGFloat(gridHeight * tileSize))
        }
    }
}
