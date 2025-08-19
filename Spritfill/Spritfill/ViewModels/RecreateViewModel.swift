//
//  RecreateViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-06.
//

import SwiftUI

class RecreateViewModel: ObservableObject {
    @Published var availableSprites: [RecreatableArtModel] = []

    init() {
        loadDummySprites()
    }

    func loadDummySprites() {
        availableSprites = [
            RecreatableArtModel(
                id: UUID(),
                name: "Strawberry",
                thumbnail: UIImage(systemName: "leaf")!,
                availableSizes: [.smallSquare, .mediumSquare]
            ),
            RecreatableArtModel(
                id: UUID(),
                name: "Mushroom",
                thumbnail: UIImage(systemName: "capsule")!,
                availableSizes: [.mediumSquare, .largeSquare]
            ),
            RecreatableArtModel(
                id: UUID(),
                name: "Duck",
                thumbnail: UIImage(systemName: "tortoise")!,
                availableSizes: [.mediumSquare, .wide, .tall]
            )
        ]
    }

    func startPhotoImport() {
        
    }
}
