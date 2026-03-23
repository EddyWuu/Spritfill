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
    @State private var showDeleteAlert = false
    @State private var bottomPanelCollapsed = false
    
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
                    .clipped()
                    .frame(maxHeight: .infinity)
                
                // MARK: - Collapse/expand handle
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        bottomPanelCollapsed.toggle()
                    }
                }) {
                    VStack(spacing: 2) {
                        Image(systemName: bottomPanelCollapsed ? "chevron.up" : "chevron.down")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.secondary)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(.systemGray3))
                            .frame(width: 36, height: 4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .background(Color(.secondarySystemBackground))
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                // MARK: - Tool buttons (always visible)
                RecreateToolBarView(viewModel: viewModel)
                    .padding(.bottom, bottomPanelCollapsed ? 6 : 0)
                    .background(Color(.secondarySystemBackground))
                
                // MARK: - Collapsible color palette
                if !bottomPanelCollapsed {
                    Divider()
                    
                    RecreateColorPaletteView(viewModel: viewModel)
                        .frame(maxHeight: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .edgesIgnoringSafeArea(.bottom)
        .onDisappear {
            viewModel.flushSave()
        }
        .onChange(of: viewModel.isComplete) { _, isComplete in
            if isComplete {
                viewModel.flushSave()
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
