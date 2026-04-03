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
                    
                    // Snap to pixel boundaries to eliminate subpixel gaps between tiles
                    let x = floor(offsetX + CGFloat(col) * tileSize)
                    let y = floor(offsetY + CGFloat(row) * tileSize)
                    let nextX = floor(offsetX + CGFloat(col + 1) * tileSize)
                    let nextY = floor(offsetY + CGFloat(row + 1) * tileSize)
                    
                    let rect = CGRect(x: x, y: y, width: nextX - x, height: nextY - y)
                    context.fill(Path(rect), with: .color(Color(hex: hex)))
                }
            }
        }
    }
}
