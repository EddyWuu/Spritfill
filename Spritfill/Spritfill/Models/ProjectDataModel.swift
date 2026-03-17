//
//  ProjectDataModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-06-04.
//

import SwiftUI

struct ProjectData: Codable, Identifiable {
    
    let id: UUID
    var name: String
    var settings: ProjectSettings
    var pixelGrid: [String]
    var lastEdited: Date
    var isFinished: Bool
    
    init(id: UUID, name: String, settings: ProjectSettings, pixelGrid: [String], lastEdited: Date, isFinished: Bool = false) {
        self.id = id
        self.name = name
        self.settings = settings
        self.pixelGrid = pixelGrid
        self.lastEdited = lastEdited
        self.isFinished = isFinished
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        settings = try container.decode(ProjectSettings.self, forKey: .settings)
        pixelGrid = try container.decode([String].self, forKey: .pixelGrid)
        lastEdited = try container.decode(Date.self, forKey: .lastEdited)
        isFinished = try container.decodeIfPresent(Bool.self, forKey: .isFinished) ?? false
    }
}

