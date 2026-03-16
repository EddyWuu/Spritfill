//
//  RecreateInProgressView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import SwiftUI

struct RecreateInProgressView: View {
    
    @ObservedObject var viewModel: RecreateViewModel
    @Binding var activeSession: RecreateSession?
    @Binding var navigateToCanvas: Bool
    
    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 16)]
    
    var body: some View {
        Group {
            if viewModel.inProgressSessions.isEmpty {
                emptyState
            } else {
                sessionList
            }
        }
    }
    
    // MARK: - Empty state
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("No sessions in progress")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Start recreating a sprite from the Browse tab!")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Session list
    
    private var sessionList: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.inProgressSessions) { item in
                    Button(action: {
                        activeSession = item.session
                        navigateToCanvas = true
                    }) {
                        VStack(spacing: 4) {
                            PixelGridThumbnailView(
                                pixelGrid: item.session.userPixels,
                                gridWidth: item.gridWidth,
                                gridHeight: item.gridHeight,
                                tileSize: max(1, 100 / CGFloat(max(item.gridWidth, item.gridHeight)))
                            )
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            
                            Text(item.session.spriteName)
                                .font(.caption)
                                .fontWeight(.medium)
                                .lineLimit(1)
                            
                            Text(item.progressText)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(8)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(role: .destructive) {
                            viewModel.deleteSession(item)
                        } label: {
                            Label("Delete Session", systemImage: "trash")
                        }
                    }
                }
            }
            .padding()
        }
    }
}
