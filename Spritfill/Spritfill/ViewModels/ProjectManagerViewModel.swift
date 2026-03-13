//
//  ProjectManagerViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-06-04.
//

import Foundation
import Combine
import SwiftUI

class ProjectManagerViewModel: ObservableObject {
    
    // all saved projects
    @Published var allProjects: [ProjectData] = []
    private let storage = LocalStorageService.shared

    
    // load all projects from storage
    func loadAllProjects() {
        allProjects = storage.fetchAllProjects()
    }

    // save a single project to storage
    func save(_ canvas: CanvasViewModel) {
        let project = canvas.toProjectData()
        storage.saveProject(project)
    }

    // delete a project by ID
    func delete(_ project: ProjectData) {
        storage.deleteProject(project)
        allProjects.removeAll { $0.id == project.id }
    }

    // load a single project into CanvasViewModel
    func loadProject(by id: UUID, completion: @escaping (CanvasViewModel?) -> Void) {
        if let projectData = storage.fetchProject(by: id) {
            let viewModel = CanvasViewModel(from: projectData)
            completion(viewModel)
        } else {
            completion(nil)
        }
    }
    
    @MainActor
    func generateThumbnail(for project: ProjectData, size: CGSize) -> UIImage {
        let canvasVM = CanvasViewModel(from: project)
        
        let gridWidth = CGFloat(project.settings.selectedCanvasSize.dimensions.width)
        let gridHeight = CGFloat(project.settings.selectedCanvasSize.dimensions.height)
        
        // Calculate tile size so the full canvas fits within the thumbnail
        let scaledTileSize = min(size.width / gridWidth, size.height / gridHeight)
        
        let renderWidth = gridWidth * scaledTileSize
        let renderHeight = gridHeight * scaledTileSize
        
        let view = ProjectCanvasExportView(viewModel: canvasVM, overrideTileSize: scaledTileSize)
            .frame(width: renderWidth, height: renderHeight)
        
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage ?? UIImage()
    }
}

