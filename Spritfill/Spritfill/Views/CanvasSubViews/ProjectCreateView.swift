//
//  ProjectCreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

struct ProjectCreateView: View {

    @ObservedObject var viewModel: CanvasViewModel
    @StateObject private var projectManager = ProjectManagerViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var showDeleteAlert = false

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        projectManager.save(viewModel)
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }

                    Spacer()

                    HStack {
                        Button(role: .destructive) {
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                        
                        Button(action: {
                            // Save
                        }) {
                            Image(systemName: "square.and.arrow.down")
                        }
                        Button(action: {
                            // Share
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
                .padding()
                .frame(height: geo.size.height * 0.08)
                .background(Color.gray.opacity(0.3))
                .alert("Delete this project?", isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        let data = viewModel.toProjectData()
                        projectManager.delete(data)
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) { }
                }

                ProjectCanvasView(viewModel: viewModel)
                    .frame(height: geo.size.height * 0.54)
                    .clipped()

                ToolsBarView(toolsVM: viewModel.toolsVM)
                    .frame(height: geo.size.height * 0.38)
                    .background(Color.gray.opacity(0.2))
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}
