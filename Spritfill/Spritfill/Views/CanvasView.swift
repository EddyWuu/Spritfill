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
    @State private var selectedTab: CanvasTab = .inProgress
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    enum CanvasTab: String, CaseIterable {
        case inProgress = "In Progress"
        case finished = "Finished"
    }

    private var columns: [GridItem] {
        let isRegular = sizeClass == .regular
        return [GridItem(.adaptive(minimum: isRegular ? 120 : 100), spacing: isRegular ? 20 : 16)]
    }
    
    private var gridSpacing: CGFloat {
        sizeClass == .regular ? 20 : 16
    }
    
    private var inProgressProjects: [ProjectData] {
        projectManager.allProjects.filter { !$0.isFinished }
    }
    
    private var finishedProjects: [ProjectData] {
        projectManager.allProjects.filter { $0.isFinished }
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                
                Picker("", selection: $selectedTab) {
                    ForEach(CanvasTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                switch selectedTab {
                case .inProgress:
                    inProgressTab
                case .finished:
                    finishedTab
                }
            }
            .navigationTitle("Canvas")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: CanvasRoute.self) { route in
                switch route {
                case .newProject:
                    NewProjectSetUpView(onProjectCreated: { viewModel in
                        let id = viewModel.projectID
                        canvasViewModels[id] = viewModel
                        projectManager.save(viewModel)
                        path.removeLast()
                        path.append(.projectCreate(id))
                    })

                case .projectCreate(let id):
                    if let viewModel = canvasViewModels[id] {
                        ProjectCreateView(viewModel: viewModel) {
                            selectedTab = .finished
                            projectManager.loadAllProjects()
                        }
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
                    
                case .projectView(let id):
                    if let viewModel = canvasViewModels[id] {
                        ProjectViewModeView(viewModel: viewModel) {
                            selectedTab = .inProgress
                            projectManager.loadAllProjects()
                            path.append(.projectCreate(id))
                        }
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
            .onChange(of: path) { _, newPath in
                // Evict cached ViewModels that are no longer on the navigation stack
                let activeIDs: Set<UUID> = Set(newPath.compactMap { route in
                    switch route {
                    case .projectCreate(let id), .projectView(let id): return id
                    default: return nil
                    }
                })
                for id in canvasViewModels.keys where !activeIDs.contains(id) {
                    canvasViewModels.removeValue(forKey: id)
                }
            }
        }
    }
    
    // MARK: - In Progress Tab
    
    private var inProgressTab: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: gridSpacing) {
                
                // New project button
                Button {
                    path.append(.newProject)
                } label: {
                    VStack(spacing: 4) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.15))
                                .frame(width: 100, height: 100)
                            Image(systemName: "plus")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                        }
                        
                        Text("New Project")
                            .font(.caption)
                            .fontWeight(.medium)
                            .lineLimit(1)
                    }
                    .padding(8)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                .buttonStyle(.plain)
                
                ForEach(inProgressProjects, id: \.id) { project in
                    Button {
                        path.append(.projectCreate(project.id))
                    } label: {
                        projectCard(project)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(role: .destructive) {
                            projectManager.delete(project)
                        } label: {
                            Label("Delete Project", systemImage: "trash")
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Finished Tab
    
    private var finishedTab: some View {
        Group {
            if finishedProjects.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.seal")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("No Finished Projects")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Mark a project as finished using the ✓ button")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: gridSpacing) {
                        ForEach(finishedProjects, id: \.id) { project in
                            Button {
                                path.append(.projectView(project.id))
                            } label: {
                                projectCard(project, showFinished: true)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) {
                                    projectManager.delete(project)
                                } label: {
                                    Label("Delete Project", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Project Card
    
    private func projectCard(_ project: ProjectData, showFinished: Bool = false) -> some View {
        let dims = project.settings.selectedCanvasSize.dimensions
        let maxDim = max(dims.width, dims.height)
        
        return VStack(spacing: 4) {
            PixelGridThumbnailView(
                pixelGrid: project.pixelGrid,
                gridWidth: dims.width,
                gridHeight: dims.height,
                tileSize: max(1, 100 / CGFloat(maxDim))
            )
            .frame(width: 100, height: 100)
            .cornerRadius(10)
            
            Text(project.name)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
            
            if showFinished {
                HStack(spacing: 2) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption2)
                        .foregroundColor(.green)
                    Text("Finished")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
