//
//  RecreateViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-06.
//

import SwiftUI

class RecreateViewModel: ObservableObject {
    @Published var availableSprites: [RecreatableArtModel] = []
    
    private let storage = LocalStorageService.shared

    @MainActor
    func loadSprites() {
        let projects = storage.fetchAllProjects()
        
        // Only include projects that have at least one non-clear pixel
        availableSprites = projects.compactMap { project -> RecreatableArtModel? in
            let hasContent = project.pixelGrid.contains(where: { $0 != "clear" })
            guard hasContent else { return nil }
            
            // Build color-to-number mapping (excluding "clear")
            var colorNumberMap: [String: Int] = [:]
            var nextNumber = 1
            for hex in project.pixelGrid {
                if hex != "clear" && colorNumberMap[hex] == nil {
                    colorNumberMap[hex] = nextNumber
                    nextNumber += 1
                }
            }
            
            // Generate thumbnail
            let thumbnail = generateThumbnail(for: project)
            
            return RecreatableArtModel(
                id: project.id,
                name: project.name,
                thumbnail: thumbnail,
                canvasSize: project.settings.selectedCanvasSize,
                palette: project.settings.selectedPalette,
                tileSize: project.settings.selectedTileSize,
                pixelGrid: project.pixelGrid,
                colorNumberMap: colorNumberMap
            )
        }
    }
    
    @MainActor
    private func generateThumbnail(for project: ProjectData) -> UIImage {
        let canvasVM = CanvasViewModel(from: project)
        let gridWidth = CGFloat(project.settings.selectedCanvasSize.dimensions.width)
        let gridHeight = CGFloat(project.settings.selectedCanvasSize.dimensions.height)
        
        let thumbSize = CGSize(width: 120, height: 120)
        let scaledTileSize = min(thumbSize.width / gridWidth, thumbSize.height / gridHeight)
        
        let renderWidth = gridWidth * scaledTileSize
        let renderHeight = gridHeight * scaledTileSize
        
        let view = ProjectCanvasExportView(viewModel: canvasVM, overrideTileSize: scaledTileSize)
            .frame(width: renderWidth, height: renderHeight)
        
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage ?? UIImage(systemName: "square.grid.3x3")!
    }
    
    func startPhotoImport() {
        // Future feature
    }
}
