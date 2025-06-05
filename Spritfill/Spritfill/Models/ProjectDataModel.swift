//
//  ProjectDataModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-06-04.
//

import SwiftUI
import FirebaseFirestore

struct ProjectData: Codable, Identifiable {
    
    let id: UUID
    var name: String
    var settings: ProjectSettings
    var pixelGrid: [[String]] // store colors as hex strings
    var lastEdited: Date
}

extension ProjectData {
    
    var toFirestoreDict: [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "lastEdited": Timestamp(date: lastEdited),
            "settings": [
                "selectedCanvasSize": settings.selectedCanvasSize.rawValue,
                "selectedTileSize": settings.selectedTileSize.rawValue,
                "selectedPalette": settings.selectedPalette.rawValue
            ],
            "pixelGrid": pixelGrid
        ]
    }
}

extension ProjectData {
    init?(from doc: DocumentSnapshot) {
        guard
            let data = doc.data(),
            let name = data["name"] as? String,
            let idString = data["id"] as? String,
            let id = UUID(uuidString: idString),
            let lastEdited = (data["lastEdited"] as? Timestamp)?.dateValue(),
            let settingsDict = data["settings"] as? [String: String],
            let canvasRaw = settingsDict["selectedCanvasSize"],
            let tileRaw = settingsDict["selectedTileSize"],
            let paletteRaw = settingsDict["selectedPalette"],
            let canvas = CanvasSizes(rawValue: canvasRaw),
            let tile = TileSizes(rawValue: tileRaw),
            let palette = ColorPalettes(rawValue: paletteRaw),
            let pixelGrid = data["pixelGrid"] as? [[String]]
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.lastEdited = lastEdited
        self.pixelGrid = pixelGrid
        self.settings = ProjectSettings(
            selectedCanvasSize: canvas,
            selectedTileSize: tile,
            selectedPalette: palette
        )
    }
}

