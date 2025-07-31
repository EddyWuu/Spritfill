//
//  GalleryView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-24.
//

import SwiftUI

struct DummyProject: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

struct GalleryView: View {
    
    @ObservedObject private var projectManager = ProjectManagerViewModel()
    
    let projects: [DummyProject] = [
        DummyProject(name: "Sunset Pixel", color: .orange),
        DummyProject(name: "Ocean Art", color: .blue),
        DummyProject(name: "Forest Map", color: .green),
        DummyProject(name: "Monochrome", color: .gray),
        DummyProject(name: "Strawberry", color: .red),
        DummyProject(name: "Violet Dream", color: .purple)
    ]
    
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(projects) { project in
                    VStack {
                        Rectangle()
                            .fill(project.color)
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
    }
}
