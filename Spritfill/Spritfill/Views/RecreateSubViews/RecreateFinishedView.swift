//
//  RecreateFinishedView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import SwiftUI

struct RecreateFinishedView: View {
    
    @ObservedObject var viewModel: RecreateViewModel
    
    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 16)]
    
    var body: some View {
        Group {
            if viewModel.finishedSessions.isEmpty {
                emptyState
            } else {
                finishedList
            }
        }
    }
    
    // MARK: - Empty state
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "trophy")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("No finished recreations yet")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Complete a recreation to see it here!")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Finished list
    
    private var finishedList: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.finishedSessions) { item in
                    VStack(spacing: 4) {
                        PixelGridThumbnailView(
                            pixelGrid: item.session.referenceGrid,
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
                        
                        HStack(spacing: 2) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption2)
                                .foregroundColor(.green)
                            Text("Complete")
                                .font(.caption2)
                                .foregroundColor(.green)
                        }
                    }
                    .padding(8)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
            }
            .padding()
        }
    }
}
