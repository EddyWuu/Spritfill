//
//  RecreatableArtModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-06.
//

import UIKit

struct RecreatableArtModel {
    
    let id: UUID
    let name: String
    let thumbnail: UIImage
    let availableSizes: [CanvasSizes]
    // may need owner
}

struct RecreateArtModel: Identifiable {
    let id = UUID()
    let name: String
    let thumbnail: UIImage
    let gridSize: CGSize // For example: 16x16, 32x32, etc.
}
