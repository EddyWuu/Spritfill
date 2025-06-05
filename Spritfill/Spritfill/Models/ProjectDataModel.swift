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
    var pixelGrid: [[String]] // store colors as hex strings
    var lastEdited: Date
}
