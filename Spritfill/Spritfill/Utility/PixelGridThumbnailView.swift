//
//  PixelGridThumbnailView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-16.
//

import SwiftUI

/// Lightweight SwiftUI view that renders a pixel grid from hex strings.
/// Used for thumbnails across browse, in-progress, finished, gallery, and downloads.
struct PixelGridThumbnailView: View {
    
    let pixelGrid: [String]
    let gridWidth: Int
    let gridHeight: Int
    let tileSize: CGFloat
    
    var body: some View {
        Canvas { context, size in
            for row in 0..<gridHeight {
                for col in 0..<gridWidth {
                    let index = row * gridWidth + col
                    guard index < pixelGrid.count else { continue }
                    let hex = pixelGrid[index]
                    guard hex != "clear" else { continue }
                    
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
}
