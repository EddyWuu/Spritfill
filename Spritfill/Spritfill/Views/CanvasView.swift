//
//  CanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-24.
//

import SwiftUI

struct CanvasView: View {
    
    @StateObject private var projectManager = ProjectManagerViewModel()
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
                    ForEach(projectManager.allProjects, id: \.id) { project in
                        Button {
                            path.append(.projectCreate(project.id))
                        } label: {
                            VStack {
                                Image(systemName: "doc.text")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding()
                                Text(project.name)
                                    .font(.caption)
                            }
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }

                }
                .padding()
            }
            .navigationTitle("Canvas")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: CanvasRoute.self) { route in
                switch route {
                case .newProject:
                    NewProjectSetUpView(onProjectCreated: { viewModel in
                        let id = viewModel.projectID
                        canvasViewModels[id] = viewModel
                        projectManager.save(viewModel) // save to firebase
                        path.removeLast()
                        path.append(.projectCreate(id))
                    })

                case .projectCreate(let id):
                    if let viewModel = canvasViewModels[id] {
                        ProjectCreateView(viewModel: viewModel)
                    } else {
                        ProgressView()
                            .onAppear {
                                projectManager.loadProject(by: id) { loadedViewModel in
                                    if let loadedViewModel = loadedViewModel {
                                        canvasViewModels[id] = loadedViewModel
                                    }
                                }
                            }
                    }
                }
            }
            .onAppear {
                projectManager.loadAllProjects()
            }
        }
    }
}
