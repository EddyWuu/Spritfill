//
//  RecreateFinishedView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import SwiftUI

struct RecreateFinishedView: View {
    
    @ObservedObject var viewModel: RecreateViewModel
    
    @State private var selectedItem: RecreateSessionItem? = nil
    @State private var showDetail = false
    @State private var showSavedAlert = false
    @State private var shareImage: IdentifiableImage? = nil
    @State private var showSaveSizeSheet = false
    @State private var showShareSizeSheet = false
    @State private var pendingSaveSession: RecreateSession? = nil
    @State private var pendingShareSession: RecreateSession? = nil
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    private var columns: [GridItem] {
        let isRegular = sizeClass == .regular
        return [GridItem(.adaptive(minimum: isRegular ? 120 : 100), spacing: isRegular ? 20 : 16)]
    }
    
    private var gridSpacing: CGFloat {
        sizeClass == .regular ? 20 : 16
    }
    
    var body: some View {
        ZStack {
            Group {
                if viewModel.finishedSessions.isEmpty && viewModel.isLoadingSessions {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.finishedSessions.isEmpty {
                    emptyState
                } else {
                    finishedList
                }
            }
            
            if let item = selectedItem {
                detailOverlay(item)
                    .opacity(showDetail ? 1 : 0)
                    .allowsHitTesting(showDetail)
                    .animation(.easeInOut(duration: 0.2), value: showDetail)
            }
        }
        .alert("Saved!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your recreated sprite has been saved to your photo library.")
        }
        .confirmationDialog(
            "Small Export Size" + (pendingSaveSession.map { " (\(viewModel.sessionExportResolutionLabel($0)))" } ?? ""),
            isPresented: $showSaveSizeSheet,
            titleVisibility: .visible
        ) {
            Button("Save at Original Size") {
                if let session = pendingSaveSession {
                    viewModel.saveSessionToPhotos(session, upscale: false) {
                        showSavedAlert = true
                    }
                }
                pendingSaveSession = nil
            }
            Button("Upscale for Photos — sharper on device") {
                if let session = pendingSaveSession {
                    viewModel.saveSessionToPhotos(session, upscale: true) {
                        showSavedAlert = true
                    }
                }
                pendingSaveSession = nil
            }
            Button("Cancel", role: .cancel) {
                pendingSaveSession = nil
            }
        } message: {
            Text("This image may appear blurry in your Photos library. You can upscale it for a sharper result, or keep the original size for use in editors and game engines.")
        }
        .confirmationDialog(
            "Small Export Size" + (pendingShareSession.map { " (\(viewModel.sessionExportResolutionLabel($0)))" } ?? ""),
            isPresented: $showShareSizeSheet,
            titleVisibility: .visible
        ) {
            Button("Export at Original Size") {
                if let session = pendingShareSession, let image = viewModel.exportSessionImage(session) {
                    shareImage = IdentifiableImage(image: image)
                }
                pendingShareSession = nil
            }
            Button("Upscale for Sharing — sharper on device") {
                if let session = pendingShareSession, var image = viewModel.exportSessionImage(session) {
                    image = BitmapExporter.upscaleForPhotos(image)
                    shareImage = IdentifiableImage(image: image)
                }
                pendingShareSession = nil
            }
            Button("Cancel", role: .cancel) {
                pendingShareSession = nil
            }
        } message: {
            Text("This image may appear blurry when shared. You can upscale it for a sharper result, or keep the original size for use in editors and game engines.")
        }
        .sheet(item: $shareImage) { item in
            ShareSheet(activityItems: [item.image])
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
            LazyVGrid(columns: columns, spacing: gridSpacing) {
                ForEach(viewModel.finishedSessions) { item in
                    Button {
                        selectedItem = item
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showDetail = true
                        }
                    } label: {
                        VStack(spacing: 4) {
                            PixelGridThumbnailView(
                                pixelGrid: item.session.referenceGrid,
                                gridWidth: item.gridWidth,
                                gridHeight: item.gridHeight,
                                tileSize: 100.0 / CGFloat(max(item.gridWidth, item.gridHeight))
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
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(role: .destructive) {
                            viewModel.deleteSession(item)
                        } label: {
                            Label("Delete Project", systemImage: "trash")
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Detail overlay
    
    private func detailOverlay(_ item: RecreateSessionItem) -> some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    showDetail = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        selectedItem = nil
                    }
                }
            
            VStack(spacing: 0) {
                
                // Header
                HStack {
                    Text(item.session.spriteName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("Complete")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                // Enlarged sprite preview
                PixelGridThumbnailView(
                    pixelGrid: item.session.userPixels,
                    gridWidth: item.gridWidth,
                    gridHeight: item.gridHeight,
                    tileSize: 250.0 / CGFloat(max(item.gridWidth, item.gridHeight))
                )
                .frame(width: 250, height: 250)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                Divider()
                
                // Export buttons
                HStack(spacing: 20) {
                    Button {
                        if viewModel.sessionNeedsUpscale(item.session) {
                            pendingSaveSession = item.session
                            showSaveSizeSheet = true
                        } else {
                            viewModel.saveSessionToPhotos(item.session) {
                                showSavedAlert = true
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.down")
                            Text("Save to Photos")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .clipShape(Capsule())
                    }
                    
                    Button {
                        if viewModel.sessionNeedsUpscale(item.session) {
                            pendingShareSession = item.session
                            showShareSizeSheet = true
                        } else if let image = viewModel.exportSessionImage(item.session) {
                            shareImage = IdentifiableImage(image: image)
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .clipShape(Capsule())
                    }
                }
                .padding(.vertical, 16)
            }
            .frame(maxWidth: 320)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 10)
        }
        .transition(.opacity)
    }
}
