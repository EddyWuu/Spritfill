//
//  RecreateCanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-18.
//

import SwiftUI

struct RecreateCanvasView: View {
    let session: RecreateSession
    @Binding var selectedTab: RecreateView.RecreateTab
    
    @StateObject private var viewModel: RecreateCanvasViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showCompletionAlert = false
    @State private var showSavedAlert = false
    @State private var showDeleteAlert = false
    
    init(session: RecreateSession, selectedTab: Binding<RecreateView.RecreateTab>) {
        self.session = session
        self._selectedTab = selectedTab
        _viewModel = StateObject(wrappedValue: RecreateCanvasViewModel(session: session))
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                
                // MARK: - Top nav bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                    }
                    
                    Spacer()
                    
                    Text("Recreate: \(session.spriteName)")
                        .font(.headline)
                    
                    Spacer()
                    
                    // Progress indicator
                    Text("\(viewModel.completionCount)/\(viewModel.totalColoredPixels)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if viewModel.isComplete {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    Button(action: {
                        viewModel.saveProgress()
                        showSavedAlert = true
                    }) {
                        Image(systemName: "externaldrive")
                    }
                    
                    Button(action: { showDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                
                // MARK: - Canvas
                RecreateProjectCanvasView(viewModel: viewModel)
                    .frame(height: geo.size.height * 0.48)
                    .clipped()
                
                // MARK: - Zoom slider
                RecreateZoomSliderView(viewModel: viewModel)
                    .background(Color(.secondarySystemBackground))
                
                Divider()
                
                // MARK: - Tool buttons
                RecreateToolBarView(viewModel: viewModel)
                    .background(Color(.secondarySystemBackground))
                
                Divider()
                
                // MARK: - Numbered color palette
                RecreateColorPaletteView(viewModel: viewModel)
                    .frame(maxHeight: .infinity)
                    .background(Color(.secondarySystemBackground))
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .edgesIgnoringSafeArea(.bottom)
        .onDisappear {
            viewModel.saveProgress()
        }
        .onChange(of: viewModel.isComplete) { _, isComplete in
            if isComplete {
                viewModel.saveProgress()
                showCompletionAlert = true
            }
        }
        .alert("Great Work! 🎉", isPresented: $showCompletionAlert) {
            Button("Done") {
                selectedTab = .finished
                dismiss()
            }
        } message: {
            Text("You've completed recreating \(session.spriteName)!")
        }
        .alert("Saved!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your progress has been saved.")
        }
        .alert("Delete Session?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.markDeleted()
                RecreateStorageService.shared.deleteSession(id: session.id)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will delete all progress for \(session.spriteName). This cannot be undone.")
        }
    }
}
