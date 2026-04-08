//
//  CommunitySpritesService.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-18.
//

import Foundation
import FirebaseFirestore

// Fetches approved community sprites from the Firestore `community_sprites` collection.
class CommunitySpritesService: ObservableObject {
    
    static let shared = CommunitySpritesService()
    
    @Published var communitySprites: [PremadeSpriteData] = []
    @Published var isLoading = false
    @Published var fetchFailed = false
    
    private let db = Firestore.firestore()
    
    // Whether we have successfully fetched at least once this session.
    private(set) var hasFetched = false
    
    // Timestamp of the last successful fetch.
    private var lastFetchDate: Date?
    
    // Minimum time between fetches (5 minutes).
    private static let cooldownInterval: TimeInterval = 5 * 60
    
    private init() {}
    
    // Fetch only if we haven't fetched yet, or the cached data is stale (>5 min).
    func fetchIfNeeded(force: Bool = false) {
        if !force, hasFetched, let lastFetch = lastFetchDate,
           Date().timeIntervalSince(lastFetch) < Self.cooldownInterval {
            return  // Data is fresh — skip
        }
        fetchCommunitySprites()
    }
    
    // Fetch all community sprites from Firestore
    func fetchCommunitySprites() {
        // Prevent concurrent fetches
        guard !isLoading else { return }
        isLoading = true
        
        db.collection("community_sprites").getDocuments { [weak self] snapshot, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                guard let documents = snapshot?.documents, error == nil else {
                    print("Failed to fetch community sprites: \(error?.localizedDescription ?? "unknown error")")
                    self.fetchFailed = true
                    return
                }
                
                self.fetchFailed = false
                
                print("🔍 Community sprites: fetched \(documents.count) documents")
                
                var sprites: [PremadeSpriteData] = []
                
                for doc in documents {
                    let data = doc.data()
                    
                    let name = data["name"] as? String
                    let canvasWidth = data["canvasWidth"] as? Int
                    let canvasHeight = data["canvasHeight"] as? Int
                    let pixelGrid = data["pixelGrid"] as? [String]
                    let canvasSize = (canvasWidth != nil && canvasHeight != nil) ? CanvasSizes.from(width: canvasWidth!, height: canvasHeight!) : nil
                    
                    print("Community sprite doc \(doc.documentID): name=\(name ?? "nil"), width=\(canvasWidth ?? -1), height=\(canvasHeight ?? -1), gridCount=\(pixelGrid?.count ?? -1), canvasSize=\(canvasSize?.rawValue ?? "nil")")
                    
                    guard let name = name,
//                          let canvasWidth = canvasWidth,
//                          let canvasHeight = canvasHeight,
                          let pixelGrid = pixelGrid,
                          let canvasSize = canvasSize else {
                        print("Skipping community sprite \(doc.documentID) — missing required fields")
                        continue
                    }
                    
                    let artist = data["artist"] as? String ?? "Anonymous"
                    let personalLink = data["personalLink"] as? String
                    
                    // Extract unique colors from the pixel grid for palette display
                    let uniqueColors = Array(Set(pixelGrid.filter { $0 != "clear" }))
                    
                    let sprite = PremadeSpriteData(
                        id: "community_\(doc.documentID)",
                        name: "\(name) by \(artist)",
                        canvasSize: canvasSize,
                        palette: nil,
                        pixelGrid: pixelGrid,
                        group: "Community",
                        groupOrder: 0,
                        paletteColors: uniqueColors,
                        personalLink: personalLink
                    )
                    
                    sprites.append(sprite)
                }
                
                self.communitySprites = sprites
                self.hasFetched = true
                self.lastFetchDate = Date()
                print("Community sprites: loaded \(sprites.count) sprites")
            }
        }
    }
}
