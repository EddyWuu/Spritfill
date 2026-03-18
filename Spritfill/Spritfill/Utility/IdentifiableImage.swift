//
//  IdentifiableImage.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-16.
//

import UIKit

// Wrapper to make UIImage usable with .sheet(item:)
struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

// Wrapper to make URL usable with .sheet(item:)
struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}
