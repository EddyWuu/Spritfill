//
//  CanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-24.
//

import SwiftUI

struct CanvasView: View {
    
    // place holder project
    @State private var projects: [String] = ["Project 1", "Project 2", "Project 3", "Project 4"]
    @State private var path: [CanvasRoute] = []
    @State private var canvasViewModels: [UUID: CanvasViewModel] = [:]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    
    var body: some View {
        
        NavigationStack(path: $path) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {

                    Button {
                        path.append(.newProject)
                    } label: {
                        VStack {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                            Text("New Project")
                                .font(.caption)
                        }
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }

                    // existing projects
                    ForEach(projects, id: \.self) { project in
                        VStack {
                            Image(systemName: "doc.text")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                            Text(project)
                                .font(.caption)
                        }
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationTitle("Canvas")
            .navigationDestination(for: CanvasRoute.self) { route in
                switch route {
                case .newProject:
                    NewProjectSetUpView(onProjectCreated: { viewModel in
                        let id = UUID()
                        canvasViewModels[id] = viewModel
                        path.removeLast()
                        path.append(.projectCreate(id))
                    })

                case .projectCreate(let id):
                    if let viewModel = canvasViewModels[id] {
                        ProjectCreateView(viewModel: viewModel)
                    } else {
                        Text("Project not found.")
                    }
                }
            }
        }
    }
}
