//
//  SettingsService.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-04-02.
//

import SwiftUI
import Combine

// Centralised settings store backed by UserDefaults.
// Observed by canvas views so toggles take effect immediately.
class SettingsService: ObservableObject {
    static let shared = SettingsService()
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Keys
    private enum Key: String {
        case applePencilOnly
        case zoomDragBar
        case doubleTapToUndo
        case backgroundTileSize
        case gridLines
        case autoSaveInterval
    }
    
    // MARK: - Auto-save interval
    
    // How often the canvas auto-saves to disk.
    enum AutoSaveInterval: String, CaseIterable, Identifiable {
        case everyMove = "Every Move"
        case every5Strokes = "Every 5 Strokes"
        case onExitOnly = "On Exit Only"
        
        var id: String { rawValue }
    }
    
    // MARK: - Published settings
    
    // When ON, only Apple Pencil can draw — finger always pans.
    // When OFF, uses the existing auto-detect behaviour (pencil sets flag, resets after 10s).
    @Published var applePencilOnly: Bool {
        didSet { defaults.set(applePencilOnly, forKey: Key.applePencilOnly.rawValue) }
    }
    
    // Show the zoom drag bar (slider) below the tool bar.
    @Published var zoomDragBar: Bool {
        didSet { defaults.set(zoomDragBar, forKey: Key.zoomDragBar.rawValue) }
    }
    
    // Two-finger double-tap to undo.
    @Published var doubleTapToUndo: Bool {
        didSet { defaults.set(doubleTapToUndo, forKey: Key.doubleTapToUndo.rawValue) }
    }
    
    // Background checkerboard tile size: how many pixel cells each checker square covers.
    // 1 = 1×1 (default, matches pixel grid), 2 = 2×2, 3 = 3×3, etc.
    @Published var backgroundTileSize: Int {
        didSet { defaults.set(backgroundTileSize, forKey: Key.backgroundTileSize.rawValue) }
    }
    
    // Show pixel grid lines on the canvas when zoomed in.
    @Published var gridLines: Bool {
        didSet { defaults.set(gridLines, forKey: Key.gridLines.rawValue) }
    }
    
    // How frequently the canvas auto-saves.
    @Published var autoSaveInterval: AutoSaveInterval {
        didSet { defaults.set(autoSaveInterval.rawValue, forKey: Key.autoSaveInterval.rawValue) }
    }
    
    static let availableTileSizes = [1, 2, 3, 4]
    
    // MARK: - Init
    
    private init() {
        // Load persisted values (with sensible defaults)
        let stored = defaults.object(forKey: Key.applePencilOnly.rawValue)
        self.applePencilOnly = (stored as? Bool) ?? false
        
        let zoomStored = defaults.object(forKey: Key.zoomDragBar.rawValue)
        self.zoomDragBar = (zoomStored as? Bool) ?? false
        
        let undoStored = defaults.object(forKey: Key.doubleTapToUndo.rawValue)
        self.doubleTapToUndo = (undoStored as? Bool) ?? true  // ON by default
        
        let tileStored = defaults.object(forKey: Key.backgroundTileSize.rawValue)
        self.backgroundTileSize = (tileStored as? Int) ?? 1
        
        let gridStored = defaults.object(forKey: Key.gridLines.rawValue)
        self.gridLines = (gridStored as? Bool) ?? true  // ON by default
        
        if let saveRaw = defaults.string(forKey: Key.autoSaveInterval.rawValue),
           let interval = AutoSaveInterval(rawValue: saveRaw) {
            self.autoSaveInterval = interval
        } else {
            self.autoSaveInterval = .everyMove  // default: save every move
        }
    }
}
