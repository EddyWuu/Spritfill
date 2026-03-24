//
//  StoreProducts.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-24.
//

import Foundation

/// Centralized product ID constants for StoreKit 2
enum StoreProducts {
    
    // MARK: - Consumable (Donations)
    
    static let tipSmall  = "com.eddy-wu.Spritfill.tip.small"
    static let tipMedium = "com.eddy-wu.Spritfill.tip.medium"
    static let tipLarge  = "com.eddy-wu.Spritfill.tip.large"
    
    // MARK: - Grouped IDs for loading
    
    /// All product IDs — pass to Product.products(for:)
    static let allProductIDs: Set<String> = [
        tipSmall,
        tipMedium,
        tipLarge
    ]
}
