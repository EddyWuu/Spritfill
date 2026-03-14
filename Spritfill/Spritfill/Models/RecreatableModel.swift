//
//  RecreatableArtModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-06.
//

import UIKit

/// A sprite available for recreating (shown in the Browse tab)
struct RecreatableArtModel: Identifiable {
    
    let id: String                     // premade ID or user project UUID string
    let name: String
    let thumbnail: UIImage
    let sourceType: RecreateSource
    let canvasSize: CanvasSizes
    let palette: ColorPalettes
    let pixelGrid: [String]           // original hex colors
    let colorNumberMap: [String: Int]  // hex -> number label for paint-by-numbers
}

/// A recreate session shown in the In Progress tab
struct RecreateSessionItem: Identifiable {
    let id: UUID                      // session ID
    let session: RecreateSession
    let thumbnail: UIImage            // rendered from user's current progress
    let progressText: String          // e.g. "42/128"
}
