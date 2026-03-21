//
//  ProjectCanvasExportView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-27.
//

import SwiftUI

struct ProjectCanvasExportView: View {
    let viewModel: CanvasViewModel
    var overrideTileSize: CGFloat? = nil

    var body: some View {
        let tileSize = overrideTileSize ?? CGFloat(viewModel.projectSettings.selectedTileSize)
        let gridWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
        let gridHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height
        let compositeHexes = viewModel.compositePixelHexes()

        Canvas { context, size in
            for row in 0..<gridHeight {
                for col in 0..<gridWidth {
                    let index = row * gridWidth + col
                    let hex = index < compositeHexes.count ? compositeHexes[index] : "clear"
                    if hex != "clear" {
                        let rect = CGRect(
                            x: CGFloat(col) * tileSize,
                            y: CGFloat(row) * tileSize,
                            width: tileSize,
                            height: tileSize
                        )
                        context.fill(Path(rect), with: .color(Color(hex: hex)))
                    }
                }
            }
        }
        .frame(width: CGFloat(gridWidth) * tileSize, height: CGFloat(gridHeight) * tileSize)
        .background(Color.clear)
    }
}
