//
//  CanvasHelpSheetView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-20.
//

import SwiftUI

struct CanvasHelpSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Tools
                    helpSection(title: "Tools", icon: "paintbrush") {
                        toolRow(icon: "pencil", name: "Pencil", description: "Draw pixels with the selected color. Tap again while selected to choose a brush size (1×1 up to 5×5)")
                        toolRow(icon: "eraser", name: "Eraser", description: "Clear pixels back to empty. Tap again while selected to choose a brush size (1×1 up to 5×5). Pencil and eraser sizes are independent")
                        toolRow(icon: "drop.halffull", name: "Fill", description: "Flood-fill a connected area with the selected color. Tap again while selected to switch between Fill Color and Fill Erase mode")
                        toolRow(icon: "eraser", name: "Fill Erase", description: "Erase all connected pixels of the same color. Access by tapping Fill again while selected and choosing Fill Erase")
                        toolRow(icon: "eyedropper", name: "Eyedropper", description: "Pick a color from the canvas and set it as the active color")
                        toolRow(icon: "arrow.up.and.down.and.arrow.left.and.right", name: "Shift", description: "Move the entire artwork up, down, left, or right")
                        toolRow(icon: "arrow.left.and.right.righttriangle.left.righttriangle.right", name: "Flip", description: "Mirror the artwork horizontally or vertically")
                        toolRow(icon: "hand.draw", name: "Pan", description: "Drag to move around the canvas without drawing")
                        toolRow(icon: "plus.circle", name: "Add Colors", description: "Tap the + button in the toolbar to add custom colors to your palette. Added colors appear in a separate section below the base palette")
                    }
                    
                    // MARK: - Apple Pencil
                    helpSection(title: "Apple Pencil", icon: "applepencil") {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "applepencil")
                                .font(.body)
                                .foregroundColor(.blue)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Pencil-Only Drawing")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("When Apple Pencil is detected, only the pencil can draw, erase, and fill on the canvas. Your finger automatically becomes a pan tool so you can move around without accidentally painting. When the pencil is put away, finger drawing is re-enabled.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // MARK: - Symmetry
                    helpSection(title: "Symmetry", icon: "line.3.horizontal") {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "line.3.horizontal")
                                .font(.body)
                                .foregroundColor(.orange)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Horizontal / Vertical Symmetry")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("Toggle to mirror your strokes across the center axis. Both can be active at once for 4-way symmetry.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // MARK: - Gestures & Shortcuts
                    helpSection(title: "Gestures & Shortcuts", icon: "hand.tap") {
                        gestureRow(icon: "hand.draw", name: "Two-Finger Pan", description: "Drag with two fingers to pan around the canvas, no matter which tool is selected")
                        gestureRow(icon: "arrow.up.left.and.arrow.down.right", name: "Pinch to Zoom", description: "Pinch with two fingers to zoom in and out of the canvas")
                        gestureRow(icon: "arrow.uturn.backward", name: "Two-Finger Double-Tap", description: "Double-tap with two fingers to undo the last action")
                        gestureRow(icon: "arrow.uturn.forward", name: "Redo / Undo Buttons", description: "Use the arrow buttons in the toolbar to redo or undo actions")
                    }
                    
                    // MARK: - Top Bar Buttons
                    helpSection(title: "Top Bar", icon: "rectangle.topthird.inset.filled") {
                        toolRow(icon: "questionmark.circle", name: "Help", description: "You're here!")
                        toolRow(icon: "trash", name: "Delete", description: "Permanently delete this project")
                        toolRow(icon: "info.circle", name: "Details", description: "View project info — canvas size, palette, pixel count")
                        toolRow(icon: "square.3.layers.3d", name: "Layers", description: "Toggle the layer panel — add, reorder, and manage drawing layers")
                        toolRow(icon: "pencil", name: "Rename", description: "Change the project name")
                        toolRow(icon: "square.and.arrow.down", name: "Export to Photos", description: "Save the artwork as a PNG image to your photo library")
                        toolRow(icon: "square.and.arrow.up", name: "Share", description: "Share the artwork via AirDrop, Messages, and more")
                        toolRow(icon: "checkmark.seal", name: "Finish", description: "Mark the project as finished and move it to the Finished tab")
                    }
                    
                    // MARK: - Tips
                    helpSection(title: "Tips", icon: "lightbulb") {
                        tipRow("Pinch with two fingers or use the zoom slider to zoom in and see individual pixels clearly.")
                        tipRow("Your project auto-saves after every change — you'll never lose progress.")
                        tipRow("Use the eyedropper to match colors already on your canvas.")
                        tipRow("Long press a project on the main screen to delete it.")
                    }
                    
                    // MARK: - Contact & Privacy
                    helpSection(title: "Contact & Privacy", icon: "envelope") {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "envelope.fill")
                                .font(.body)
                                .foregroundColor(.blue)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Questions or Feedback?")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("ducksss777@gmail.com")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Divider()
                        
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "lock.shield")
                                .font(.body)
                                .foregroundColor(.green)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Privacy Policy")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("Spritfill collects minimal data. Submitted artwork and your chosen artist name are stored on Firebase for community review. No emails, device IDs, or location data are collected. All local projects stay on your device.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    // MARK: - Section Builder
    
    private func helpSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 10) {
                content()
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Row Builders
    
    private func toolRow(icon: String, name: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.blue)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func gestureRow(icon: String, name: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.purple)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func tipRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption)
                .foregroundColor(.green)
                .frame(width: 28)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
