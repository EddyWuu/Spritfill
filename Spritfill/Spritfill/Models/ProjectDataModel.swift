//
//  ProjectDataModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-06-04.
//

import SwiftUI

// MARK: - Layer Data (persisted per layer)

struct LayerData: Codable, Identifiable {
    let id: UUID
    var name: String
    var pixelGrid: [String]
    var isVisible: Bool
    var opacity: Double
    
    init(id: UUID = UUID(), name: String, pixelGrid: [String], isVisible: Bool = true, opacity: Double = 1.0) {
        self.id = id
        self.name = name
        self.pixelGrid = pixelGrid
        self.isVisible = isVisible
        self.opacity = opacity
    }
}

// MARK: - Project Data

struct ProjectData: Codable, Identifiable {
    
    let id: UUID
    var name: String
    var settings: ProjectSettings
    var pixelGrid: [String]       // Flattened composite — used by thumbnails, submissions, legacy compat
    var layers: [LayerData]?      // nil for legacy single-layer projects
    var lastEdited: Date
    var isFinished: Bool
    
    init(id: UUID, name: String, settings: ProjectSettings, pixelGrid: [String], layers: [LayerData]? = nil, lastEdited: Date, isFinished: Bool = false) {
        self.id = id
        self.name = name
        self.settings = settings
        self.pixelGrid = pixelGrid
        self.layers = layers
        self.lastEdited = lastEdited
        self.isFinished = isFinished
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        settings = try container.decode(ProjectSettings.self, forKey: .settings)
        pixelGrid = try container.decode([String].self, forKey: .pixelGrid)
        layers = try container.decodeIfPresent([LayerData].self, forKey: .layers)
        lastEdited = try container.decode(Date.self, forKey: .lastEdited)
        isFinished = try container.decodeIfPresent(Bool.self, forKey: .isFinished) ?? false
    }
}

