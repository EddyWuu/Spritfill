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
        let tileSize = CGFloat(viewModel.projectSettings.selectedTileSize.size)
        let gridWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
        let gridHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height

        Canvas { context, size in
            for row in 0..<gridHeight {
                for col in 0..<gridWidth {
                    let color = viewModel.pixels[row * gridWidth + col]
                    let rect = CGRect(
                        x: CGFloat(col) * tileSize,
                        y: CGFloat(row) * tileSize,
                        width: tileSize,
                        height: tileSize
                    )

                    let isLight = (row + col) % 2 == 0
                    let background = isLight ? Color.gray.opacity(0.15) : Color.gray.opacity(0.3)

                    context.fill(Path(rect), with: .color(background))
                    if color != .clear {
                        context.fill(Path(rect), with: .color(color))
                    }
                }
            }
        }
        .frame(width: CGFloat(gridWidth) * tileSize, height: CGFloat(gridHeight) * tileSize)
    }
}
