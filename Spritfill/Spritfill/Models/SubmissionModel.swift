//
//  SubmissionModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-18.
//

import Foundation

struct ArtSubmission: Codable, Identifiable {
    
    let id: UUID
    let artistName: String
    let projectName: String
    let canvasWidth: Int
    let canvasHeight: Int
    let pixelGrid: [String]
    let submittedAt: Date
    
    init(artistName: String, projectName: String, canvasWidth: Int, canvasHeight: Int, pixelGrid: [String]) {
        self.id = UUID()
        self.artistName = artistName
        self.projectName = projectName
        self.canvasWidth = canvasWidth
        self.canvasHeight = canvasHeight
        self.pixelGrid = pixelGrid
        self.submittedAt = Date()
    }
}
