//
//  RecreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-24.
//

import SwiftUI

struct RecreateView: View {
    
    @StateObject private var recreateViewModel = RecreateViewModel()
    @State private var selectedTab: RecreateTab = .browse
    @State private var spriteToConfirm: RecreatableArtModel? = nil
    @State private var showConfirmAlert = false
    @State private var activeSession: RecreateSession? = nil
    @State private var navigateToCanvas = false
    
    enum RecreateTab: String, CaseIterable {
        case browse = "Browse"
        case inProgress = "In Progress"
        case finished = "Finished"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // MARK: - Tab picker
                Picker("", selection: $selectedTab) {
                    ForEach(RecreateTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // MARK: - Tab content
                switch selectedTab {
                case .browse:
                    RecreateBrowseView(
                        viewModel: recreateViewModel,
                        spriteToConfirm: $spriteToConfirm,
                        showConfirmAlert: $showConfirmAlert
                    )
                case .inProgress:
                    RecreateInProgressView(
                        viewModel: recreateViewModel,
                        activeSession: $activeSession,
                        navigateToCanvas: $navigateToCanvas
                    )
                case .finished:
                    RecreateFinishedView(viewModel: recreateViewModel)
                }
            }
            .navigationDestination(isPresented: $navigateToCanvas) {
                if let session = activeSession {
                    RecreateCanvasView(session: session, selectedTab: $selectedTab)
                }
            }
            .navigationTitle("Recreate")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                recreateViewModel.loadAll()
            }
            .onChange(of: navigateToCanvas) { _, isActive in
                if !isActive {
                    // Reload when returning from canvas
                    recreateViewModel.loadAll()
                }
            }
            .alert("Start Recreating?", isPresented: $showConfirmAlert) {
                Button("Start") {
                    if let sprite = spriteToConfirm {
                        activeSession = recreateViewModel.getOrCreateSession(for: sprite)
                        recreateViewModel.loadAll()
                        navigateToCanvas = true
                    }
                }
                Button("Cancel", role: .cancel) {
                    spriteToConfirm = nil
                }
            } message: {
                Text("Would you like to start recreating \(spriteToConfirm?.name ?? "this sprite")?")
            }
        }
    }
}
