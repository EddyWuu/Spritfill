//
//  ToolBarView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-06.
//

import SwiftUI

struct ToolsBarView: View {
    @ObservedObject var toolsVM: ToolsViewModel
    @ObservedObject var canvasVM: CanvasViewModel
    @Binding var showColorAdder: Bool

    var body: some View {
        HStack(spacing: 10) {
            // Scrollable tools + symmetry toggles (pan excluded — it's pinned on right)
            ZStack(alignment: .trailing) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        // Drawing tools (excluding pan)
                        ForEach(toolsVM.availableTools.filter { $0 != .pan }, id: \.self) { tool in
                            ToolButtonView(tool: tool, toolsVM: toolsVM)
                        }
                        
                        // Symmetry toggles (thin divider separates them from tools)
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1, height: 24)
                        
                        // Vertical symmetry toggle
                        Button(action: { toolsVM.verticalSymmetry.toggle() }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.caption)
                                .foregroundColor(toolsVM.verticalSymmetry ? .orange : .primary)
                                .padding(8)
                                .background(toolsVM.verticalSymmetry ? Color.orange.opacity(0.2) : Color.clear)
                                .clipShape(Circle())
                        }
                        
                        // Horizontal symmetry toggle
                        Button(action: { toolsVM.horizontalSymmetry.toggle() }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.caption)
                                .rotationEffect(.degrees(90))
                                .foregroundColor(toolsVM.horizontalSymmetry ? .orange : .primary)
                                .padding(8)
                                .background(toolsVM.horizontalSymmetry ? Color.orange.opacity(0.2) : Color.clear)
                                .clipShape(Circle())
                        }
                        
                        // Extra trailing space so fade doesn't clip last button
                        Spacer().frame(width: 16)
                    }
                }
                
                // Subtle fade on trailing edge to hint scrollability
                LinearGradient(
                    colors: [Color(.secondarySystemBackground).opacity(0), Color(.secondarySystemBackground)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 20, height: 36)
                .allowsHitTesting(false)
            }
            
            // Divider between scrollable area and pinned actions
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 24)
            
            // Pinned right-side actions
            HStack(spacing: 10) {
                // Undo button
                Button(action: { canvasVM.undo() }) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.title3)
                        .foregroundColor(canvasVM.canUndo ? .primary : .gray.opacity(0.4))
                }
                .disabled(!canvasVM.canUndo)
                
                // Pan / move screen button
                ToolButtonView(tool: .pan, toolsVM: toolsVM)
                
                // Add colors to palette
                Button(action: { showColorAdder = true }) {
                    Image(systemName: "paintpalette")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                // Show currently selected color swatch
                Circle()
                    .fill(toolsVM.selectedColor)
                    .frame(width: 28, height: 28)
                    .overlay(Circle().stroke(Color.primary, lineWidth: 2))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
