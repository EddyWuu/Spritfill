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
        loadSampleSprites()
    }

    func loadSampleSprites() {
        
//        availableSprites = [
//            RecreatableSprite(id: UUID(), name: "Strawberry", thumbnail: UIImage(named: "strawberry")!),
//            RecreatableSprite(id: UUID(), name: "Apple", thumbnail: UIImage(named: "apple")!)
//        ]
    }

    func startPhotoImport() {
        
    }
}
