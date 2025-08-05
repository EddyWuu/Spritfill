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
    private let service = FirestoreService()

    
    // load all projects from storage
    func loadAllProjects() {
        service.fetchAllProjects { [weak self] projects in
            DispatchQueue.main.async {
                self?.allProjects = projects
            }
        }
    }

    // save a single project to storage
    func save(_ canvas: CanvasViewModel) {
        let project = canvas.toProjectData()
        service.saveProject(project) { error in
            if let error = error {
                print("Error saving project: \(error.localizedDescription)")
            }
        }
    }

    // delete a project by ID
    func delete(_ project: ProjectData) {
        service.deleteProject(project) { [weak self] error in
            if let error = error {
                print("Error deleting project: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self?.allProjects.removeAll { $0.id == project.id }
                }
            }
        }
    }

    // load a single project into CanvasViewModel
    func loadProject(by id: UUID, completion: @escaping (CanvasViewModel?) -> Void) {
        service.fetchProject(by: id) { projectData in
            if let projectData = projectData {
                let viewModel = CanvasViewModel(from: projectData)
                completion(viewModel)
            } else {
                completion(nil)
            }
        }
    }
    
    @MainActor
    func generateThumbnail(for project: ProjectData, size: CGSize) -> UIImage {
        let canvasVM = CanvasViewModel(from: project)
        let view = ProjectCanvasExportView(viewModel: canvasVM)
        let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage ?? UIImage()
    }
}
