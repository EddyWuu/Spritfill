//
//  PixelGridThumbnailView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-16.
//

import SwiftUI

// Lightweight SwiftUI view that renders a pixel grid from hex strings.
// Used for thumbnails across browse, in-progress, finished, gallery, and downloads.
struct PixelGridThumbnailView: View {
    
    let pixelGrid: [String]
    let gridWidth: Int
    let gridHeight: Int
    let tileSize: CGFloat
    
    var body: some View {
        Canvas { context, size in
            // Center the grid within the canvas for non-square grids
            let drawnWidth = CGFloat(gridWidth) * tileSize
            let drawnHeight = CGFloat(gridHeight) * tileSize
            let offsetX = (size.width - drawnWidth) / 2.0
            let offsetY = (size.height - drawnHeight) / 2.0
            
            for row in 0..<gridHeight {
                for col in 0..<gridWidth {
                    let index = row * gridWidth + col
                    guard index < pixelGrid.count else { continue }
                    let hex = pixelGrid[index]
                    guard hex != "clear" else { continue }
                    
                    let rect = CGRect(
                        x: offsetX + CGFloat(col) * tileSize,
                        y: offsetY + CGFloat(row) * tileSize,
                        width: tileSize,
                        height: tileSize
                    )
                    context.fill(Path(rect), with: .color(Color(hex: hex)))
                }
            }
        }
    }
}
