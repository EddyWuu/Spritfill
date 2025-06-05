//
//  ProjectManagerViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-06-04.
//

import Foundation

class ProjectManagerViewModel: ObservableObject {
    
    // all saved projects
    @Published var allProjects: [ProjectData] = []
    
    // load all projects from storage
    func loadAllProjects() {
        // fetch all saved project files
    }

    // save a single project to storage
    func save(_ canvas: CanvasViewModel) {
        
        // convert to ProjectData and save to disk
    }

    // delete a project by ID
    func delete(_ project: ProjectData) {
        
        // remove file and update list
    }

    // load a single project into CanvasViewModel
    func loadProject(by id: UUID) -> CanvasViewModel? {
        
        // retrieve file and convert to CanvasViewModel
        return nil
    }
}
