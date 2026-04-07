//
//  RecreatableArtModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-06.
//

import SwiftUI

// A sprite available for recreating (shown in the Browse tab)
struct RecreatableArtModel: Identifiable {
    
    let id: String
    let name: String
    let sourceType: RecreateSource
    let canvasSize: CanvasSizes
    let palette: ColorPalettes?
    let pixelGrid: [String]
    let colorNumberMap: [String: Int]
    let personalLink: String?
    
    init(id: String, name: String, sourceType: RecreateSource, canvasSize: CanvasSizes, palette: ColorPalettes?, pixelGrid: [String], colorNumberMap: [String: Int], personalLink: String? = nil) {
        self.id = id
        self.name = name
        self.sourceType = sourceType
        self.canvasSize = canvasSize
        self.palette = palette
        self.pixelGrid = pixelGrid
        self.colorNumberMap = colorNumberMap
        self.personalLink = personalLink
    }
    
    var gridWidth: Int { canvasSize.dimensions.width }
    var gridHeight: Int { canvasSize.dimensions.height }
}

// A recreate session shown in the In Progress tab
struct RecreateSessionItem: Identifiable {
    let id: UUID
    let session: RecreateSession
    let progressText: String
    
    var gridWidth: Int { session.canvasSize.dimensions.width }
    var gridHeight: Int { session.canvasSize.dimensions.height }
}
