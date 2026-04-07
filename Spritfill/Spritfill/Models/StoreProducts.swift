//
//  StoreProducts.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-24.
//

import Foundation

// Centralized product ID constants and pro-gating helpers for StoreKit 2
enum StoreProducts {
    
    // MARK: - Non-Consumable
    
    // One-time purchase to unlock all pro features
    static let proUnlock = "com.eddywu.Spritfill.unlock.pro"
    
    // MARK: - Grouped IDs
    
    static let allProductIDs: Set<String> = [proUnlock]
    
    // MARK: - Pro Gating: Layers
    
    // Maximum layers for free users
    static let freeLayerLimit = 2
    
    static func layerRequiresPro(currentCount: Int) -> Bool {
        currentCount >= freeLayerLimit
    }
    
    // MARK: - Pro Gating: Canvas Sizes
    
    static let proCanvasSizes: Set<CanvasSizes> = [.extraLargeSquare, .hugeSquare, .massiveSquare, .sheet8x32, .sheet4x64, .sheet8x64]
    
    static func requiresPro(_ canvasSize: CanvasSizes) -> Bool {
        proCanvasSizes.contains(canvasSize)
    }
    
    // MARK: - Pro Gating: Extra Palette Colors
    
    // Free users can add up to 5 extra colors on top of their chosen palette
    static let freeExtraColorLimit = 5
    
    // MARK: - Pro Gating: Custom Palette
    
    // Free users can add up to 64 colors in a custom palette
    static let freeCustomPaletteColorLimit = 64
    
    // MARK: - Pro Gating: Spritfill Palette
    
    // The Spritfill 128 palette requires pro
    static func paletteRequiresPro(_ palette: ColorPalettes) -> Bool {
        palette == .spritfill
    }
    
    // MARK: - Pro Gating: Tools
    
    // Gradient, Dither, and Select tools require Pro
    static let proTools: Set<ToolsViewModel.ToolType> = [.gradient, .dither, .select]
    
    static func toolRequiresPro(_ tool: ToolsViewModel.ToolType) -> Bool {
        proTools.contains(tool)
    }
}
