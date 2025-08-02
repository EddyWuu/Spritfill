//
//  GalleryView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-24.
//

import SwiftUI

struct GalleryView: View {
    
    @StateObject private var projectManager = ProjectManagerViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(projectManager.allProjects, id: \.id) { project in
                    VStack {
                        // placeholder visual, gonna replace with actual later
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 120)
                            .cornerRadius(12)
                        
                        Text(project.name)
                            .font(.caption)
                            .lineLimit(1)
                            .padding(.top, 4)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            projectManager.loadAllProjects()
        }
    }
}
