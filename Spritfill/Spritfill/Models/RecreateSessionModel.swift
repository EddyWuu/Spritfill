//
//  RecreateSessionModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import Foundation

// Tracks which kind of sprite source a recreate session is based on
enum RecreateSource: String, Codable {
    case premade   // from PremadeSprites
    case userMade  // from user's own saved projects
    case community // from community submissions (Firebase)
}

// A saved in-progress recreate session
struct RecreateSession: Codable, Identifiable {
    let id: UUID                // session ID
    let sourceType: RecreateSource
    let sourceID: String        // premade sprite ID string, or user project UUID string
    let spriteName: String
    let canvasSize: CanvasSizes
    let palette: ColorPalettes?
    let referenceGrid: [String] // the target pixel grid (hex / "clear")
    var userPixels: [String]    // user's painted pixels (hex / "clear")
    var lastEdited: Date
    
    var completionCount: Int {
        var count = 0
        for i in 0..<referenceGrid.count {
            let target = referenceGrid[i]
            if target == "clear" { continue }
            if i < userPixels.count && userPixels[i] != "clear" {
                if userPixels[i].lowercased() == target.lowercased() {
                    count += 1
                }
            }
        }
        return count
    }
    
    var totalColoredPixels: Int {
        referenceGrid.filter { $0 != "clear" }.count
    }
    
    var hasWrongPlacements: Bool {
        for i in 0..<referenceGrid.count {
            if referenceGrid[i] == "clear" && i < userPixels.count && userPixels[i] != "clear" {
                return true
            }
        }
        return false
    }
    
    var isComplete: Bool {
        totalColoredPixels > 0 && completionCount == totalColoredPixels && !hasWrongPlacements
    }
}
