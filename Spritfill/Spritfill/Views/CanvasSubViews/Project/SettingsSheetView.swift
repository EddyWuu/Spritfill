//
//  SettingsSheetView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-04-02.
//

import SwiftUI

struct SettingsSheetView: View {
    @ObservedObject private var settings = SettingsService.shared
    @Environment(\.dismiss) private var dismiss
    
    // When false, hides settings that don't apply (e.g. background tile size in Recreate mode).
    var showCanvasAppearance: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                
                // MARK: - Input
                Section {
                    Toggle(isOn: $settings.applePencilOnly) {
                        Label("Apple Pencil Only", systemImage: "applepencil.tip")
                    }
                } header: {
                    Text("Input")
                } footer: {
                    Text("When enabled, only Apple Pencil can draw on the canvas. Finger touches will always pan. When disabled, the app auto-detects Apple Pencil and reverts to finger drawing after 10 seconds of inactivity.")
                }
                
                // MARK: - Gestures
                Section {
                    Toggle(isOn: $settings.doubleTapToUndo) {
                        Label("Double Tap to Undo", systemImage: "hand.tap")
                    }
                } header: {
                    Text("Gestures")
                } footer: {
                    Text("Two-finger double-tap anywhere on the canvas to undo the last action.")
                }
                
                // MARK: - Zoom
                Section {
                    Toggle(isOn: $settings.zoomDragBar) {
                        Label("Zoom Slider", systemImage: "slider.horizontal.below.rectangle")
                    }
                } header: {
                    Text("Zoom")
                } footer: {
                    Text("Show a zoom drag bar below the toolbar. You can always pinch-to-zoom regardless of this setting.")
                }
                
                // MARK: - Canvas Appearance
                Section {
                    Toggle(isOn: $settings.gridLines) {
                        Label("Grid Lines", systemImage: "grid")
                    }
                    
                    if showCanvasAppearance {
                        Picker(selection: $settings.backgroundTileSize) {
                            ForEach(SettingsService.availableTileSizes, id: \.self) { size in
                                Text(size == 1 ? "1×1 (Default)" : "\(size)×\(size)")
                                    .tag(size)
                            }
                        } label: {
                            Label("Background Tile Size", systemImage: "checkerboard.rectangle")
                        }
                    }
                } header: {
                    Text("Canvas Appearance")
                } footer: {
                    if showCanvasAppearance {
                        Text("Grid lines show pixel boundaries when zoomed in. Background tile size controls how large each checkerboard square is behind transparent pixels.")
                    } else {
                        Text("Grid lines show pixel boundaries when zoomed in.")
                    }
                }
                
                // MARK: - Saving
                Section {
                    Picker(selection: $settings.autoSaveInterval) {
                        ForEach(SettingsService.AutoSaveInterval.allCases) { interval in
                            Text(interval.rawValue).tag(interval)
                        }
                    } label: {
                        Label("Auto-Save", systemImage: "externaldrive")
                    }
                } header: {
                    Text("Saving")
                } footer: {
                    Text("\"Every Move\" saves after each stroke (safest). \"Every 5 Strokes\" reduces disk writes for better performance. \"On Exit Only\" saves when you leave the canvas — faster, but progress is lost if the app is force-quit.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
