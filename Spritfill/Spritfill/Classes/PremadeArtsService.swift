//
//  PremadeArtsService.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-04-08.
//

import Foundation
import FirebaseFirestore

/// Fetches approved premade arts from the Firestore `premade_arts` collection.
/// These are server-pixelated landscape images (64×64 or 128×128) shown in the Catalog.
class PremadeArtsService: ObservableObject {
    
    static let shared = PremadeArtsService()
    
    @Published var premadeArts: [PremadeSpriteData] = []
    @Published var isLoading = false
    @Published var fetchFailed = false
    
    private let db = Firestore.firestore()
    
    /// Whether we have successfully fetched at least once this session.
    private(set) var hasFetched = false
    
    /// Timestamp of the last successful fetch.
    private var lastFetchDate: Date?
    
    /// Minimum time between fetches (5 minutes).
    private static let cooldownInterval: TimeInterval = 5 * 60
    
    private init() {}
    
    /// Fetch only if we haven't fetched yet, or the cached data is stale (>5 min).
    func fetchIfNeeded(force: Bool = false) {
        if !force, hasFetched, let lastFetch = lastFetchDate,
           Date().timeIntervalSince(lastFetch) < Self.cooldownInterval {
            return  // Data is fresh — skip
        }
        fetchPremadeArts()
    }
    
    /// Fetch all premade arts from Firestore
    func fetchPremadeArts() {
        guard !isLoading else { return }
        isLoading = true
        
        db.collection("premade_arts").getDocuments { [weak self] snapshot, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                guard let documents = snapshot?.documents, error == nil else {
                    print("Failed to fetch premade arts: \(error?.localizedDescription ?? "unknown error")")
                    self.fetchFailed = true
                    return
                }
                
                self.fetchFailed = false
                
                print("🖼️ Premade arts: fetched \(documents.count) documents")
                
                var arts: [PremadeSpriteData] = []
                
                for doc in documents {
                    let data = doc.data()
                    
                    let name = data["name"] as? String
                    let canvasWidth = data["canvasWidth"] as? Int
                    let canvasHeight = data["canvasHeight"] as? Int
                    
                    // Server stores pixelGrid as a comma-joined string to avoid Firestore index limits.
                    // Also handle legacy docs that used a plain array.
                    var pixelGrid: [String]?
                    if let gridString = data["pixelGridString"] as? String, !gridString.isEmpty {
                        pixelGrid = gridString.components(separatedBy: ",")
                    } else if let gridArray = data["pixelGrid"] as? [String] {
                        pixelGrid = gridArray
                    }
                    
                    let canvasSize = (canvasWidth != nil && canvasHeight != nil)
                        ? CanvasSizes.from(width: canvasWidth!, height: canvasHeight!)
                        : nil
                    
                    guard let name = name,
                          let pixelGrid = pixelGrid,
                          let canvasSize = canvasSize else {
                        print("Skipping premade art \(doc.documentID) — missing required fields")
                        continue
                    }
                    
                    // Extract unique colors from the pixel grid for palette display
                    let uniqueColors = Array(Set(pixelGrid.filter { $0 != "clear" }))
                    
                    // Group as "Landscapes" to appear alongside the hardcoded landscape sprites.
                    // Use groupOrder 100+ so server arts appear after local ones.
                    let sprite = PremadeSpriteData(
                        id: "premade_art_\(doc.documentID)",
                        name: name,
                        canvasSize: canvasSize,
                        palette: nil,
                        pixelGrid: pixelGrid,
                        group: "Landscapes",
                        groupOrder: 100 + arts.count,
                        paletteColors: uniqueColors
                    )
                    
                    arts.append(sprite)
                }
                
                self.premadeArts = arts
                self.hasFetched = true
                self.lastFetchDate = Date()
                print("🖼️ Premade arts: loaded \(arts.count) arts")
            }
        }
    }
}
