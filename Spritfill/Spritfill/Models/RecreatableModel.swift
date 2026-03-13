//
//  RecreatableArtModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-06.
//

import UIKit

struct RecreatableArtModel: Identifiable {
    
    let id: UUID
    let name: String
    let thumbnail: UIImage
    let canvasSize: CanvasSizes
    let palette: ColorPalettes
    let tileSize: TileSizes
    let pixelGrid: [String]           // original hex colors
    let colorNumberMap: [String: Int]  // hex -> number label for paint-by-numbers
}
